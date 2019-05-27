These are a few response files provided for convenience.  Source
setup_response_files.sh to install them, which will create environment
variables for each response file, and a bash function to list them.

Install:
$ . setup_response_files.sh

List:
$ show-response-files

Invoke:
$ clang++ $EMIT_LLVM <cpp file>
$ clang++ $PRINT_INCLUDE_PATHS
$ clang++ $AST_DUMP [-x (c|c++)] <file> # c++ by default

