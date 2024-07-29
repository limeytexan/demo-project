# Flox Project

## Overview

This project demonstrates a simple C shared library containing a `flox_hello_world` function, a C program that uses this shared library, and a Python script that uses CPython bindings to call the same function.

## Structure

- `src/`: Contains the C source and header files.
- `python/`: Contains the Python test script.
- `Makefile`: Builds and installs the project.

## Building and Installing

To build and install the project, run the following commands:

```sh
make
make install PREFIX=<installation_path>
