# HTTP Validator

This is a *safe* HTTP validator implemented with Flex and Bison. Here, safety means no semantic action is used so the parsing is done entirely by bison's automatically generated code, avoiding the frequent vulnerabilities associated with handwritten code.

## Requirements
* m4 version 1.4.17 (at least)
* flex
* bison

## User guide
First, compile the tool by running the command `make` within the root directory of this repository.

To validate a single message:
```
./run_parser.sh input_file
```

To validate a list of messages and compare with [HTTPolice][HTTPolice]:
```
./run_tests.sh file1 file2 file3...
```

### HTTP exchanges
HTTPValidator also validates pairs of messages request-response when they are provided in *combined format* of [HTTPolice][HTTPolice].

[HTTPolice]: https://github.com/vfaronov/httpolice/

