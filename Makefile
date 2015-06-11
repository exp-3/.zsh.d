CURRENT_DIR := $(shell cd $(dirname $0); pwd)

.Phony: install

install:
	echo "source $(CURRENT_DIR)/.zsh.d/zshrc" >> $(HOME)/.zshrc
