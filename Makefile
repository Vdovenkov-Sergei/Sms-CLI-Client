MAIN_APP = app.main
SRC_CODE_DIR = app/
POETRY_CMD = poetry run
EXCLUDE = 

.PHONY: format run test lint clean

format:
	$(POETRY_CMD) black $(SRC_CODE_DIR) --exclude=$(EXCLUDE)
	$(POETRY_CMD) isort $(SRC_CODE_DIR) --skip=$(EXCLUDE)

run:
	$(POETRY_CMD) python -m $(MAIN_APP) --sender "$(SENDER)" --recipient "$(RECIPIENT)" --message "$(MESSAGE)"

test:
	$(POETRY_CMD) python -m pytest -k "$(TEST_NAME)" -m "$(MARKERS)" -q --cov=$(SRC_CODE_DIR) --cov-report=term-missing --import-mode=append

lint:
	$(POETRY_CMD) ruff check $(SRC_CODE_DIR) --exclude=$(EXCLUDE)
	$(POETRY_CMD) mypy $(SRC_CODE_DIR) $(if $(EXCLUDE),--exclude=$(EXCLUDE))

clean:
	find . -type d -name "__pycache__" ! -path "./.venv/*" -exec rm -rf {} +
	find . -type f \( -name "*.pyc" -o -name "*.pyo" -o -name "*.pyd" \) ! -path "./.venv/*" -delete
	rm -rf .coverage .pytest_cache .mypy_cache .ruff_cache
