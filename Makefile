.PHONY: install dry-run update

install:
	./install.sh

dry-run:
	./install.sh --dry-run

update:
	git pull --ff-only
	./install.sh
