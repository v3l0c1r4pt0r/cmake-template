# cmake-template

Simple C program built by CMake and tested by CMocka

## Project structure

* **src/program.c** - module with `main()` function, meant to be entry point of an
  executable
* **src/module.c** - utility module, meant to provide interfaces for main module
* **test/test_*.c**[*cmocka* branch] - test modules for modules in src/
  directory

## Repository structure

* **cmake** branch - basic project with no fancy features - just sources
* **cmocka** branch - same as cmake plus unit tests and mocking with help of
  cmocka framework
* **getopt** branch - same as cmake plus CLI interface using `getopt()` function
