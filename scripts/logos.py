from typing import Literal
from os import getcwd, walk, remove, mkdir
from os.path import join, splitext, dirname, abspath, exists
from requests import get
from subprocess import run, CalledProcessError
import click
from json import load, JSONDecodeError
from base64 import b64decode
from lxml import etree
from scour import scour
from filetype import guess
from selenium.webdriver import Chrome
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
from fnmatch import filter as fileFilter
import os
import shutil

BASE_DIR = dirname(abspath(__file__))
OUTPUT_DIR = join(getcwd(), "../lib/assets/images/sim_cards")
tmp = join(BASE_DIR, ".tmp")

# Inkscape path (add to PATH or specify full path)
# INKSCAPE_PATH = "inkscape"  # If in PATH
INKSCAPE_PATH = r"C:\Program Files\Inkscape\bin\inkscape.exe"  # Windows full path

browser: Chrome | None = None

@click.group()
def cli():
    """Company logo related scripts"""
    pass

def log(message: str, type: Literal["error", "info"] = "info") -> None:
    if type == "error":
        print(f"    [!] {message}")
    else:
        print(f"    [>] {message}")

def setup_browser():
    """Set up a headless browser using Selenium."""
    options = Options()
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')

    global browser
    browser = Chrome(service=Service(ChromeDriverManager().install()), options=options)

def find_and_download_logo(company_name: str, name_normalized: str) -> str | None:
    """Downloads the logo of a given company from the web."""
    query = f"https://www.google.com/search?q={company_name.replace(' ', '+')}+logo&tbm=isch"

    log(f"Looking for logo... ({query})")

    browser.get(query)

    try:
        # Locate the first image in the search results
        src = (
            browser
            .find_element(By.ID, "search")
            .find_element(By.TAG_NAME, "img")
            .get_attribute("src")
        )
    except Exception:
        log("Couldn't find logo", "error")
        return None

    if not src:
        log("Couldn't find logo", "error")
        return None

    # Convert base64 to image
    if src.startswith("data:image"):
        try:
            # Extract base64 data
            base64_data = src.split(",")[1]
            # Fix padding if needed
            if len(base64_data) % 4 != 0:
                base64_data += '=' * (4 - len(base64_data) % 4)

            decoded = b64decode(base64_data)
            file_type = guess(decoded)
            extension = file_type.extension if file_type else "png"
            tmp_path = join(tmp, f"{name_normalized}.{extension}")

            with open(tmp_path, 'wb') as f:
                f.write(decoded)

            return tmp_path
        except Exception as e:
            log(f"Error processing base64 image: {e}", "error")
            return None

    # Download regular image
    try:
        response = get(src, stream=True)
        response.raise_for_status()

        # Determine file extension
        content = response.content
        file_type = guess(content)
        extension = file_type.extension if file_type else "png"
        tmp_path = join(tmp, f"{name_normalized}.{extension}")

        with open(tmp_path, "wb") as img_file:
            img_file.write(content)

        return tmp_path
    except Exception as e:
        log(f"Error downloading image: {e}", "error")
        return None

def convert_to_svg(input_path: str, output_path: str) -> None:
    """Convert image to SVG using Inkscape CLI with automatic tracing."""
    log(f"Converting {input_path} to SVG using Inkscape...")

    try:
        # Step 1: Import and trace the bitmap
        cmd = [
            INKSCAPE_PATH,
            input_path,
            "--actions",
            "select-all;trace-bitmap;EditSelectAll;EditDelete",
            "--export-filename",
            output_path
        ]

        result = run(cmd, capture_output=True, text=True, check=True)

        # Check if the SVG was created and has content
        if exists(output_path):
            with open(output_path, 'r', encoding='utf-8') as f:
                content = f.read()
                if '<path' in content or '<g' in content or '<rect' in content or '<circle' in content:
                    log("Successfully converted to SVG")
                else:
                    log("SVG created but appears empty, trying alternative method...", "error")
                    # Try simpler conversion without deleting original
                    cmd_alt = [
                        INKSCAPE_PATH,
                        input_path,
                        "--actions",
                        "select-all;trace-bitmap",
                        "--export-filename",
                        output_path
                    ]
                    run(cmd_alt, capture_output=True, text=True, check=True)
                    log("Alternative conversion completed")
        else:
            raise Exception("SVG file was not created")

    except CalledProcessError as e:
        log(f"Inkscape conversion failed: {e.stderr}", "error")
        raise
    except FileNotFoundError:
        log("Inkscape not found. Please install Inkscape and add it to PATH or set INKSCAPE_PATH", "error")
        raise

def resize_svg(svg_path: str, target_width: int = 100, target_height: int = 64):
    """Smart resize: resize SVG with smart crop."""
    log("Smart resizing SVG...")

    try:
        svg_tree = etree.parse(svg_path)
        root = svg_tree.getroot()

        def parse_dimension(dim: str) -> float | None:
            if dim is None:
                return None
            if dim.endswith('px'):
                return float(dim.replace('px', ''))
            if dim.endswith('pt'):
                pt_value = float(dim.replace('pt', ''))
                return pt_value * 1.3333
            try:
                return float(dim)
            except ValueError:
                return None

        # Get original dimensions
        orig_width = parse_dimension(root.get('width'))
        orig_height = parse_dimension(root.get('height'))

        # Try to get dimensions from viewBox if width/height not available
        if orig_width is None or orig_height is None:
            viewBox = root.get('viewBox')
            if viewBox:
                parts = viewBox.split()
                if len(parts) >= 4:
                    _, _, orig_width, orig_height = map(float, parts[:4])

            # If still no dimensions, try to calculate from content
            if orig_width is None or orig_height is None:
                # Set reasonable defaults based on common image sizes
                orig_width = orig_width or 512
                orig_height = orig_height or 512
                log(f"Using default dimensions: {orig_width}x{orig_height}")

        # Calculate aspect ratios
        orig_ratio = orig_width / orig_height
        target_ratio = target_width / target_height

        # Set new dimensions
        root.set('width', f'{target_width}px')
        root.set('height', f'{target_height}px')

        # Calculate viewBox for smart cropping
        if orig_ratio > target_ratio:
            # Image is wider - crop sides
            new_height = orig_height
            new_width = orig_height * target_ratio
            x_offset = (orig_width - new_width) / 2
            y_offset = 0
        else:
            # Image is taller - crop top/bottom
            new_width = orig_width
            new_height = orig_width / target_ratio
            x_offset = 0
            y_offset = (orig_height - new_height) / 2

        # Ensure we don't have negative offsets
        x_offset = max(0, x_offset)
        y_offset = max(0, y_offset)

        root.set('viewBox', f'{x_offset} {y_offset} {new_width} {new_height}')
        root.set('preserveAspectRatio', 'xMidYMid slice')

        log(f"SVG smart resized (crop: {x_offset:.1f},{y_offset:.1f} size: {new_width:.1f}x{new_height:.1f})")
        return svg_tree

    except Exception as e:
        log(f"Error resizing SVG: {e}", "error")
        raise

def optimize_svg_string(svg_str: str) -> str:
    """Optimize SVG string using scour."""
    log("Optimizing SVG...")

    try:
        options = scour.sanitizeOptions({
            "remove_metadata": True,
            "remove_descriptions": True,
            "remove_titles": True,
            "strip_comments": True,
            "shorten_ids": True,
            "enable_viewboxing": True,
            "indent_type": None,
            "newlines": False,
        })
        result = scour.scourString(svg_str, options)
        log("SVG optimized")
        return result
    except Exception as e:
        log(f"Error optimizing SVG: {e}", "error")
        return svg_str  # Return original if optimization fails

def resize_and_optimize(path: str, target_width: int = 100, target_height: int = 64) -> None:
    """Resize and optimize SVG file."""
    log(f"Smart resizing and optimizing {path}...")

    try:
        # First check if SVG has actual content
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()

        # Check if SVG is essentially empty
        if not any(tag in content for tag in ['<path', '<g', '<rect', '<circle', '<polygon', '<line', '<text']):
            log("SVG appears to be empty, skipping optimization", "error")
            return

        svg_tree = resize_svg(path, target_width, target_height)

        # Convert XML tree back to string
        svg_str = etree.tostring(svg_tree.getroot(), encoding='unicode')

        # Only optimize if we have substantial content
        if len(svg_str) > 200:  # Basic threshold to avoid optimizing empty SVGs
            optimized_svg = optimize_svg_string(svg_str)
        else:
            log("SVG too small to optimize safely, keeping original")
            optimized_svg = svg_str

        # Write optimized SVG to file
        with open(path, 'w', encoding='utf-8') as f:
            f.write(optimized_svg)

        log("SVG ready")

    except Exception as e:
        log(f"Error processing SVG: {e}", "error")
        # Don't raise - keep the original file if optimization fails

@click.command("find-company-logos")
@click.option('--path', type=str, required=False, help='Path to the JSON with the companies list. Optional')
def find_company_logos(path: str | None) -> None:
    """
    Looks up company logos, downloads them as SVG, or as another image format and then converts to SVG.
    The companies are determined by the JSON specified by --path
    """
    if not path:
        path = join(BASE_DIR, "companies.json")

    try:
        with open(path) as file:
            companies: list[str] = load(file)
    except JSONDecodeError:
        log("Invalid JSON configuration file.", "error")
        return
    except FileNotFoundError:
        log(f"Could not find {path}. Make sure to specify full path", "error")
        return

    print("[>] Finding logos for:", ", ".join(companies))

    if not exists(tmp):
        mkdir(tmp)

    if not exists(OUTPUT_DIR):
        mkdir(OUTPUT_DIR)

    setup_browser()

    for company in companies:
        log(f"Getting logo for {company}...")

        name_normalized = company.lower().replace(" ", "_")

        try:
            if tmp_path := find_and_download_logo(company, name_normalized):
                output = join(OUTPUT_DIR, f"{name_normalized}.svg")
                convert_to_svg(tmp_path, output)

                if exists(output):
                    resize_and_optimize(output)
                    log(f"Successfully processed logo for {company}")
                else:
                    log(f"Failed to create SVG for {company}", "error")

                # Clean up temporary file
                if exists(tmp_path):
                    remove(tmp_path)
            else:
                log(f"Could not download logo for {company}", "error")

        except Exception as e:
            log(f"Error processing {company}: {e}", "error")

        print()

    print("[>] Finished script execution")

@click.command("convert-existing-img")
@click.option('--directory', type=str, required=False, help='Path to a directory in which all files will be converted to SVG. Defaults to lib/assets/images/loyalty_cards')
def convert_existing_img(directory: str | None) -> None:
    """Convert existing image files to SVG format using Inkscape and saves them in {OUTPUT_DIR}"""
    if not directory:
        directory = OUTPUT_DIR

    print(f"[>] Converting images in {directory} to SVG using Inkscape")

    image_extensions = ('*.jpg', '*.jpeg', '*.png', '*.gif', '*.bmp', '*.tiff', '*.webp')

    for root, _, files in walk(directory):
        for ext in image_extensions:
            for filename in fileFilter(files, ext):
                file_path = join(root, filename)
                svg_path = splitext(file_path)[0] + ".svg"

                log(f"Processing {filename}")

                try:
                    convert_to_svg(file_path, svg_path)

                    # Only remove original if conversion was successful
                    if exists(svg_path):
                        remove(file_path)
                        log(f"Successfully converted {filename} to SVG")
                    else:
                        log(f"Failed to convert {filename}", "error")

                except Exception as e:
                    log(f"Error converting {filename}: {e}", "error")

    print("[>] Finished script execution")

@click.command("optimize")
@click.option('--directory', type=str, required=False, help='Path to a directory in which all files will be optimized. Defaults to lib/assets/images/loyalty_cards')
@click.option('--width', type=int, required=False, help="Target width (default: 100)")
@click.option('--height', type=int, required=False, help="Target height (default: 64)")
@click.option('--suffix', type=str, required=False, help="Suffix to add to filename (default: _card)")
def optimize(directory: str | None, width: int | None, height: int | None, suffix: str | None) -> None:
    """Smart resize: fills entire target dimensions by cropping excess content and optimizes SVG"""
    if not directory:
        directory = OUTPUT_DIR

    if not width:
        width = 100
    if not height:
        height = 64
    if not suffix:
        suffix = "_card"

    print(f"[>] Smart optimizing SVGs in {directory} to {width}x{height} with suffix '{suffix}'")

    for root, _, files in walk(directory):
        for filename in files:
            if filename.endswith('.svg'):
                log(f"Processing {filename}")
                file_path = join(root, filename)

                name_without_ext = splitext(filename)[0]
                new_filename = f"{name_without_ext}{suffix}.svg"
                new_file_path = join(root, new_filename)

                try:
                    resize_and_optimize(file_path, width, height)

                    if file_path != new_file_path:
                        shutil.move(file_path, new_file_path)
                        log(f"Renamed to {new_filename}")

                except Exception as e:
                    log(f"Error processing {filename}: {e}", "error")

    print("[>] Finished script execution")

if __name__ == "__main__":
    try:
        cli.add_command(find_company_logos)
        cli.add_command(convert_existing_img)
        cli.add_command(optimize)

        cli()
    finally:
        if browser:
            browser.quit()