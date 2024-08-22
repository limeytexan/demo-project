#!/usr/bin/env python3

import sys
import os

# Set PYTHONPATH to include the installed directory
sys.path.append('@@__PYTHON_SITE_PACKAGES__@@')

import flox_hello_world_py

if __name__ == "__main__":
    flox_hello_world_py.flox_hello_world()
