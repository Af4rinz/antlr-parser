grammar langGrammar;

program: (preProcess)* (classDec | varDec)* EOF;

preProcess: (
		(VAR '=' REQUIRE VAR)
		| (VAR '=' FROM VAR REQUIRE VAR)
	) ';';

statement: assignExp';'
	| varDec
	| forRange
	| forIt
	| whileLoop
	| ifStatement
	| switchStatement
	| doWhileLoop
	| incDecStatement
	| (functionCall';') 
	| block
;
classDec: CLASS VAR (EXTENDS VAR)? implementExp? '{' (varDec | function | assignExp)* '}' ';'?;

function: (TYPE | VOID) VAR '=' '(' ((TYPE) VAR (',' TYPE VAR)* )? ')' '=>' '{' statement* 
	(RETURN exp? ';') '}' ';'?;

functionCall: VAR '(' (exp (',' exp)*)? ')';
implementExp: IMPLEMENTS VAR (',' VAR)*;

varDec: (LET | CONST) TYPE ('[]')? varAssign (',' varAssign)* (';');
varAssign: VAR (('=' VAR)* '=' (SCIENTIFIC_NUMBER | exp ))?; //only to use in var declaration

//support for code blocks in program
block: '{' statement* '}';

//switch statement include 0+ cases and may include one default case
switchStatement: SWITCH '(' VAR ')' '{' (CASE (('\'' VAR '\'') | NUMBER | BOOL) ':' (('{' statement* '}') | statement*) (BREAK ';')?)* 
	(DEFAULT ':'(('{' statement* '}') | statement*) (BREAK ';')?)? '}';

//range-based for, range is given in init:fin format with steps
forRange: FOR '(' VAR IN ((VAR|NUMBER)':'(VAR|NUMBER)) STEP (NUMBER|VAR) ')' (('{' statement* '}') | statement);

//iterative for using var IN iterator format
forIt: FOR '(' AUTO VAR IN VAR ')' (('{' statement* '}') | statement);

whileLoop: WHILE '(' exp ')' (('{' statement* '}') | statement);

doWhileLoop: DO (('{' statement* '}') | statement) WHILE '(' exp ')';

ifStatement:
	IF '(' exp ')' (('{' statement* '}') | statement) 
		( ELSE (('{' statement* '}') | statement))? ;

incDecStatement: ((('--' | '++') VAR) | (VAR ('--' | '++'))) ';';



/*----- EXPRESSIONS -----*/
assignExp: VAR ('*' | '/' | '%' | '//' | '+' | '-' | '**')? '=' (exp | SCIENTIFIC_NUMBER);
exp: '(' exp ')'
    | exp ('**') exp //power
	| ('~') exp //unary bit op
	| ('+'|'-') exp //unary sign op
    | exp ('*' | '/' | '%' | '//') exp //mul/div op
    | exp ('+' | '-') exp //sum/sub op
	|('--' | '++') exp //inc/decrement
	| exp ('--' | '++')
	| exp ('<<' | '>>' ) exp //shift
	| exp ('^' | '|' | '&') exp //bit op
	| exp ('==' | '!=' | '<>') exp //equality op
	| exp ('>' | '<' | '>=' | '<=') exp //inequality op
	| NOT exp
	| exp (OR | AND) exp
    | atom;
atom: (('-' | '+')? (NUMBER | VAR)) | BOOL | IOTA | functionCall;

// NL: [\r\n]+;
LCOMMENT: '#' ~[\r\n]*  -> skip; //skip single-line comments starting with #
MCOMMENT: '/*' .*? '*/' -> skip; //skip multiline comments in /*..*/ format
WS: [ \t\r\n]+ -> skip; // skip spaces and tabs  


/*----- RESERVED KEYWORDS -----*/
//defined before the general word/var form to take 
//precedence in parsing i.e. the keywords will
//not be recognised as variables/words
TYPE: BOOLEAN | INT | FLOAT;
REQUIRE: 'require';
CONST: 'const';
FROM: 'from';
CLASS: 'class';
EXTENDS: 'extends';
IMPLEMENTS: 'implements';
LET: 'let';
INT: 'int';
FLOAT: 'float';
VOID: 'void';
IOTA: 'iota';
NULL: 'null' | 'NULL';
RETURN: 'return';
IN: 'in';
FOR: 'for';
IF: 'if';
STEP: 'step';
AUTO: 'auto';
WHILE: 'while';
SWITCH: 'switch';
CASE: 'case';
DEFAULT: 'default';
BREAK: 'break';
ELSE: 'else';
DO: 'do';
NOT: 'not';
AND: 'and';
OR: 'or';
BOOLEAN: 'boolean';
BOOL: 'true' | 'false';

/*----- GENRAL COMPONENTS -----*/
fragment UPPERCASE: [A-Z];
fragment LOWERCASE: [a-z];
fragment DIGIT: [0-9];
fragment LETTER: [a-zA-Z];
//variables are 2+ characters, not starting with numerals
VAR: (LETTER | '_')(LETTER | '_' | NUMBER)+;
NUMBER: DIGIT+([.,] DIGIT+)?;
SCIENTIFIC_NUMBER: NUMBER ('e' ('+'|'-')? NUMBER);


