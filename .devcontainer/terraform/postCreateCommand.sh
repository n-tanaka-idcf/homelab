#!/bin/bash

# Install misc commands
aqua install --config .devcontainer/${DEVCONTAINER_NAME}/aqua.yaml

# Setup starship config
mkdir ${HOME}/.config
cp .devcontainer/${DEVCONTAINER_NAME}/starship.toml ${HOME}/.config/starship.toml
