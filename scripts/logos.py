from typing import Literal
from os import getcwd, walk, remove, mkdir
from os.path import join, splitext, dirname, abspath, exists
from requests import get
from subprocess import run
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
import base64
import re
import tempfile
import os
from xml.etree import ElementTree as ET

BASE_DIR = dirname(abspath(__file__))
OUTPUT_DIR = join(getcwd(), "../lib/assets/images/loyalty_cards")
tmp = join(BASE_DIR, ".tmp")

browser: Chrome | None = None

@click.group()
def cli():
    """Company logo related scripts"""
    pass

def log(message: str, type: Literal["error", "info"] = "info") -> None:
    if (type == "error"):
        print(f"    [!] {message}")
    else:
        print(f"    [>] {message}")


def setup_browser():
    """
    Set up a headless browser using Selenium.
    """
    options = Options()
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')

    global browser
    browser = Chrome(service=Service(ChromeDriverManager().install()), options=options)


# ===== Conversion BASE64→VECTOR =====

def extract_base64_image(svg_content):
    """Extract base64 image data from SVG content."""
    match = re.search(r'href="data:image/(png|jpeg|jpg);base64,([^"]+)"', svg_content)
    if not match:
        match = re.search(r'xlink:href="data:image/(png|jpeg|jpg);base64,([^"]+)"', svg_content)
    if not match:
        return None, None
    image_type = match.group(1)
    base64_data = match.group(2)
    return image_type, base64_data

def save_base64_image(image_type, base64_data, filename):
    """Save base64 data as image file."""
    image_data = base64.b64decode(base64_data)
    with open(filename, 'wb') as f:
        f.write(image_data)

def replace_image_with_vector(svg_content, vector_svg_content):
    """Replace embedded image in SVG with vector paths."""
    try:
        orig_svg = ET.fromstring(svg_content)
        vector_svg = ET.fromstring(vector_svg_content)

        # Remove embedded image elements from original SVG
        for image in orig_svg.findall(".//{http://www.w3.org/2000/svg}image"):
            orig_svg.remove(image)

        # Append vector paths from traced SVG to original SVG
        for elem in vector_svg:
            orig_svg.append(elem)

        return ET.tostring(orig_svg, encoding='unicode')
    except Exception as e:
        log(f"Error replacing image with vector: {e}", "error")
        return svg_content

def convert_base64_to_vector(svg_path):
    """Convert SVG with embedded base64 image to vector SVG."""
    log("   Checking for embedded base64 images...")

    try:
        with open(svg_path, 'r', encoding='utf-8') as f:
            svg_content = f.read()

        image_type, base64_data = extract_base64_image(svg_content)
        if not base64_data:
            log("   No base64 embedded image found - SVG is already vector")
            return True

        log("   Found embedded base64 image - converting to vector...")

        with tempfile.TemporaryDirectory() as tmpdir:
            raster_path = os.path.join(tmpdir, f'image.{image_type}')
            vector_path = os.path.join(tmpdir, 'traced.svg')

            # Save base64 image to temporary file
            save_base64_image(image_type, base64_data, raster_path)
            log(f"   Extracted raster image")

            # Trace with inkscape
            log("   Tracing bitmap with Inkscape...")
            run([
                "inkscape",  # MUDANÇA: usar inkscape do PATH
                raster_path,
                "--trace-bitmap",
                f"--export-filename={vector_path}"
            ], check=True)
            subprocess.run([
                INKSCAPE_PATH,
                raster_path,
                "--trace-bitmap",
                f"--export-filename={vector_path}"
            ], check=True)

            log("   Successfully traced to vector")

            # Read traced vector content
            with open(vector_path, 'r', encoding='utf-8') as vf:
                vector_svg_content = vf.read()

            # Replace base64 image in original SVG with vector paths
            new_svg = replace_image_with_vector(svg_content, vector_svg_content)

            # Write new vectorized SVG
            with open(svg_path, 'w', encoding='utf-8') as out_f:
                out_f.write(new_svg)

            log("   Successfully converted base64 to vector SVG")
            return True

    except Exception as e:
        log(f"   Error converting base64 SVG to vector: {e}", "error")
        return False

def find_and_download_logo(company_name: str, name_normalized: str) -> str | None:
    """
    Downloads the logo of a given company from the web.
    """
    query = f"https://www.google.com/search?q={company_name.replace(" ", "+")}+logo&tbm=isch"

    log(f"Looking for logo... ({query})")

    browser.get(query)

    # Locate the first image in the search results
    src = (
        browser
        .find_element(By.ID, "search")
        .find_element(By.TAG_NAME, "img")
        .get_attribute("src")
    )

    if not src:
        log("Couldn't find logo", "error")
        return None


    tmp_path = join(tmp, f"{name_normalized}.png")

    # Convert base64 to image
    if src.startswith("data:image"):
        # Validate and fix Base64 string padding
        if len(src) % 4 != 0:
            src += '=' * (4 - len(src) % 4)

        decoded = b64decode(src.split(",")[1])
        tmp_path = join(tmp, f"{name_normalized}.{guess(decoded).extension}")
        with open(tmp_path, 'wb') as f:
            f.write(decoded)

        return tmp_path

    # Download and save image
    response = get(src, stream=True)
    tmp_path = join(tmp, f"{name_normalized}.{guess(img_file).extension}")
    with open(tmp_path, "wb") as img_file:
        for chunk in response.iter_content(1024):
            img_file.write(chunk)

    return tmp_path


def convert_to_svg(input_path: str, output_path: str) -> None:
    """
    Converts a given image file to SVG format.
    """
    INKSCAPE_PATH = r"C:\Program Files\Inkscape\bin\inkscape.exe"

    try:
        log("Converting logo to SVG...")
        run([
            INKSCAPE_PATH,
            "--export-filename",
            output_path,
            input_path,
        ], check=True, shell=True)
        log("Logo converted successfully!")
    except Exception as e:
        log(f"Failed to convert {input_path} to SVG: {e}", "error")


def resize_svg(svg_path: str, target_width: int = 100, target_height: int = 64):
    """
    Smart resize: resize SVG with smart crop
    """
    log("   Smart resizing SVG...")
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

    orig_width = parse_dimension(root.get('width'))
    orig_height = parse_dimension(root.get('height'))

    if orig_width is None or orig_height is None:
        viewBox = root.get('viewBox')
        if viewBox:
            parts = viewBox.split()
            if len(parts) >= 4:
                _, _, orig_width, orig_height = map(float, parts[:4])
        else:
            raise ValueError("SVG missing width/height and viewBox")

    orig_ratio = orig_width / orig_height
    target_ratio = target_width / target_height

    root.set('width', f'{target_width}px')
    root.set('height', f'{target_height}px')

    if orig_ratio > target_ratio:
        new_height = orig_height
        new_width = orig_height * target_ratio
        x_offset = (orig_width - new_width) / 2
        y_offset = 0
    else:
        new_width = orig_width
        new_height = orig_width / target_ratio
        x_offset = 0
        y_offset = (orig_height - new_height) / 2

    root.set('viewBox', f'{x_offset} {y_offset} {new_width} {new_height}')
    root.set('preserveAspectRatio', 'xMidYMid slice')

    log(f"   SVG smart resized (crop: {x_offset:.1f},{y_offset:.1f} size: {new_width:.1f}x{new_height:.1f})")
    return svg_tree

def optimize_svg_string(svg_str: str) -> str:
    log("   Optimizing SVG...")
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
    log("   SVG otpmized")
    return result


def resize_and_optimize(path: str, target_width: int = 100, target_height: int = 64) -> None:
    log(f"Smart resizing and optimizing {path}...")

    # Convert base64 --> vector before resize
    convert_base64_to_vector(path)

    svg_tree = resize_svg(path, target_width, target_height)

    # Convert XML tree back to string
    svg_str = etree.tostring(svg_tree.getroot(), encoding='unicode')

    # Optimize SVG string
    optimized_svg = optimize_svg_string(svg_str)

    # Write optimized SVG to file
    with open(path, 'w', encoding='utf-8') as f:
        f.write(optimized_svg)

    log(f"SVG ready")

@click.command("find-company-logos")
@click.option('--path', type=str, required=False, help='Path to the JSON with the companies list. Optional')
def find_company_logos(path: str | None) -> None:
    """
    Looks up company logos, downloads them as SVG, or as another image format and then converts to SVG. The companies
    are determined by the JSON specified by --path
    """
    if not path:
        path = join(BASE_DIR, "companies.json")

    try:
        with open(path) as file:
            companies: list[str] = load(file)
    except JSONDecodeError:
        log("Invalid JSON configuration file.")
        return
    except FileNotFoundError:
        log(f"Could not find {path}. Make sure to specify full path")
        return

    print("[>] Finding logos for:", ", ".join(companies))

    if not exists(tmp):
        mkdir(tmp)

    setup_browser()

    for company in companies:
        log(f"Getting logo for {company}...")

        name_normalized = company.lower().replace(" ", "_")

        if (tmp_path := find_and_download_logo(company, name_normalized)):
            output = join(OUTPUT_DIR, f"{name_normalized}.svg")
            convert_to_svg(tmp_path, output)
            resize_and_optimize(output)
            remove(tmp_path)

        print("\n")

    print("[>] Finished script execution")


@click.command("convert-existing-img")
@click.option('--directory', type=str, required=False, help='Path to a directory in which all files will be converted to SVG. Defaults to lib/assets/images/loyalty_cards')
def convert_existing_img(directory: str | None) -> None:
    """
    Convert existing image files to SVG format and saves them in {OUTPUT_DIR}
    """
    if not directory:
        directory = OUTPUT_DIR

    print(f"[>] Converting images in ${directory} to svg")

    image_extensions = ('*.jpg', '*.jpeg', '*.png', '*.gif', '*.bmp', '*.tiff', '*.webp')

    for root, _, files in walk(directory):
        for ext in image_extensions:
            for filename in fileFilter(files, ext):
                file_path = join(root, filename)
                convert_to_svg(file_path, splitext(file_path)[0] + ".svg")
                remove(file_path)

    print("[>] Finished script execution")

@click.command("optimize")
@click.option('--directory', type=str, required=False, help='Path to a directory in which all files will be converted to SVG. Defaults to lib/assets/images/loyalty_cards')
@click.option('--width', type=int, required=False, help="Target width (default: 100)")
@click.option('--height', type=int, required=False, help="Target height (default: 64)")
@click.option('--suffix', type=str, required=False, help="Suffix to add to filename (default: _card)")
def optimize(directory: str | None, width: int | None, height: int | None, suffix: str | None) -> None:
    """
    Smart resize: fills entire target dimensions by cropping excess content and optimizes SVG
    """
    if not directory:
        directory = OUTPUT_DIR

    if not width:
        width = 100
    if not height:
        height = 64
    if not suffix:
        suffix = "_card"

    print(f"[>] Smart optimizing SVGs in {directory} to {width}x{height}")

    for root, _, files in walk(directory):
        for filename in files:
            if filename.endswith('.svg'):
                log(f"Processing {filename}")
                file_path = join(root, filename)

                name_without_ext = splitext(filename)[0]
                new_filename = f"{name_without_ext}{suffix}.svg"
                new_file_path = join(root, new_filename)

                resize_and_optimize(file_path, width, height)

                if file_path != new_file_path:
                    import shutil
                    shutil.move(file_path, new_file_path)
                    log(f"Renamed to {new_filename}")

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