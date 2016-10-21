# HTTP Parser

This is a *safe* HTTP parser implemented with Flex and Bison. Here safety means no semantic action is used so the parsing is done entirely by bison's automatically generated code, avoiding the frequent vulnerabilities associated with handwritten code.

## Requirements
* m4 version 1.4.17 (at least)

## User guide
First, compile the tool run the command `make` within the root directory of the repository.

To run the parser over a single message:
```
./run_parser.sh input_file
```

To run the parser over a list of files and compare its output with [HTTPolice][HTTPolice]:
```
./run_tests.sh file1 file2 file3...
```


[HTTPolice]: https://github.com/vfaronov/httpolice/

