.PHONY: init, activate, logos

init: 
	python -m venv .venv
	source .venv/Scripts/activate
	pip install -r requirements.txt

activate: 
	source .venv/Scripts/activate

find-logos: 
	python logos.py find-company-logos

convert-existing: 
	python logos.py convert-existing-img
