# Flox Demo Project

## Overview

This project demonstrates a simple C shared library containing
a `flox_hello_world` function, a C program that uses this shared
library, and a Python script that uses CPython bindings to call
the same function.

## Structure

- `src/`: Contains the C source and header files.
- `python/`: Contains the Python test script.
- `Makefile`: Builds and installs the project.

## Building and Installing

To build and install the project, run the following commands:

```sh
make
make install PREFIX=<installation_path>
```

## Demonstration

- introduce geography and function of test repository
- perform manual ad-hoc build
- demonstrate `make install PREFIX=/wherever` works
- replicate ad-hoc build in manifest
  - observe result-* symlink, test bin files
  - observe speed is good
  - demonstrate how `make clean` affects the build
  - imagine user wants to test purity, what then?
- convert ad-hoc build to sandbox
  - observe that it works
  - observe that Nix will not repeat builds when things don't change
  - but then change something and observe that the build is slow again
- enable buildCache for sandbox build
  - observe that it works
  - observe that Nix again will not repeat builds when things don't change
  - but then change something and observe that the build is fast because
    it can use previous compilation artifacts
- so imagine your build needs something from the network
  - introduce the "headlines" program
  - highlight the private API key file
  - show how we use jq to present a nicely formatted summary
  - build in "in-situ" mode and show how it works
  - build in "sandbox" mode and show how it breaks
  - split build into headlines-deps (in-situ) and headlines packages (sandbox)
    - observe how the in-situ build is able to access private files, network
    - observe how the pure package can pull the earlier stage into its build
