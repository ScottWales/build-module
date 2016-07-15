# Module Build System

System to install packages and create modules in a reproducable way, allowing
for multiple compilers and other dependencies.

## Using Modules

This system overrides the default module command to enable different contexts
based on the user environment. For instance if a user has the Intel Fortran
compiler loaded then they can access libraries with module files in Intel
format. `modules/src/modulecmd.sh` adds this functionality.

## Installing Modules

Inside the various directories are scripts to configure and build modules in
different contexts. Each script has a number of helper variables, such as the
context it should be installed in, a description and the source website, as
well as functions for downloading, building and installing the module.

The `download`, `build` and `test` functions run in a temporary directory, then
the `install` function should move files to `$INSTALDIR`
