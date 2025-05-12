from typing import Literal 
from os import getcwd, walk, remove, mkdir
from os.path import join, splitext, dirname, abspath, exists
from requests import get
from subprocess import run 
import click
from json import load, JSONDecodeError
from base64 import b64decode
from filetype import guess
from selenium.webdriver import Chrome
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
from fnmatch import filter as fileFilter

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
    try:
        log("Converting logo to SVG...")
        run([
            "inkscape",
            "--export-filename",
            output_path,
            input_path,
        ], check=True, shell=True)
        log("Logo converted successfully!")
    except Exception as e:
        log(f"Failed to convert {input_path} to SVG: {e}", "error")


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
            convert_to_svg(tmp_path, join(OUTPUT_DIR, f"{name_normalized}.svg"))
            remove(tmp_path)

        print("\n")

    print("[>] Finished script execution")

@click.command("convert-existing-img")
@click.option('--directory', type=str, required=False, help='Path to a directory in which all files will be converted to SVG. Defaults to lib/assets/images/loyalty_cards')
def convert_existing_imgs(directory: str | None) -> None:
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

if __name__ == "__main__":
    try: 
        cli.add_command(find_company_logos)
        cli.add_command(convert_existing_imgs)

        cli()
    finally: 
        if browser: 
            browser.quit()
