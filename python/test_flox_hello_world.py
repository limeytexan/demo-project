#!/usr/bin/env python3

import sys
import os

# Set PYTHONPATH to include the installed directory
sys.path.append('/usr/local/lib/python3.8/site-packages')

import flox_hello_world_py

if __name__ == "__main__":
    flox_hello_world_py.flox_hello_world()
