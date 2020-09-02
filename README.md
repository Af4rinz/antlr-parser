# ANTLR parser
ANTLR-based parser for a simple programming language.

## Run

Run "run.bat" to compile the grammar, then run `grun antlr-parser program -gui`.

Sample codes and run results are stored in "Samples" folder.

## Notes
- single-line comments start with `#` until end of line character.
- multi-line comments are in form of `/*...*/`.
- code blocks in the form `{...}` are supported.
- support for do-while loops.
- classes are in Java format; i.e. no functions can be outside classes, only global variables.

