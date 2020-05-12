/**
 * Project: Language Parser for TLM Project
 * Author: Afarin Zamanian
 * Student ID: 9712762250
 * Version: 1.0
 * Date: May 2020
 */
grammar stmntGrammar;

program: (preProcess)* (statement | classDef | function)*;
preProcess: (
		(VAR '=' REQUIRE VAR)
		| (VAR '=' FROM VAR REQUIRE VAR)
	) ';'?;

statement:
	forRange
	| forIt
	| ifStatement
	| whileLoop
	| doWhileLoop
	| switchStatement
	| defStatement
	;

defStatement: (LET | CONST) (INT | FLOAT | BOOL) '[]'? varAssign (',' varAssign)* ';'?; //variable definition, supporting multi-definitions
classDef: CLASS VAR (EXTENDS VAR)? implementExp? '{' (defStatement | function)* '}';
function: CONST? (VOID | INT | FLOAT | BOOL) VAR '(' (((INT | FLOAT | BOOL) VAR) (','(INT | FLOAT | BOOL) VAR)*)? ')' '{' statement  (RETURN (exp)? ';')? '}' ;
ifStatement:
	IF '(' compExp ')' (('{' statement* '}') | statement) 
		(ELSE (('{' statement* '}') | statement))?;
whileLoop: WHILE '(' compExp (logicOp compExp) ')' (('{' statement* '}') | statement);
doWhileLoop: DO (('{' statement* '}') | statement) WHILE '(' compExp (logicOp compExp) ')' ';'?;
//switch statement include 0+ cases and may include one default case
switchStatement: SWITCH '(' VAR ')' '{' (CASE ('\'' (VAR | NUMBER) '\'') ':' (('{' statement* '}') | statement+) (BREAK ';'?)?)* 
	(DEFAULT ':'(('{' statement* '}') | statement+) (BREAK ';'?)?)? '}';

//range-based for, range is given in init:fin format with steps
forRange: FOR '(' VAR IN ((VAR|NUMBER)':'(VAR|NUMBER)) STEP (NUMBER|VAR) ')' (('{' statement* '}') | statement);
//iterative for using var IN iterator format
forIt: FOR '(' AUTO VAR IN VAR ')' (('{' statement* '}') | statement);

multiComment: '/*' .*? '*/' -> skip; //skip multiline comments in /* .. */ format
commentLine: '##'  ~[\n\r]* -> skip; //skip single-line comments starting with ##
WS: [ \t\r]+ -> skip; // skip spaces and tabs  


/*----- EXPRESSIONS -----*/

/*parts*/
powOp: '**';
multiDivOp: '*' | '/' | '%' | '//' ;
addSubOp: '+' | '-' ;
arithOp: powOp | addSubOp | multiDivOp;
bitOp: '<<' | '>>' | '~' | '^' | '|' | '&';
logicOp: AND | OR | NOT | '&&' | '||';
assignOp: (arithOp)? '='; //allows for expressions such as i += 2
compOp: '>' | '<' | '>=' | '<=' | '==' | '!=';

/*exps*/
exp: (VAR | NUMBER) (arithOp (VAR | NUMBER))*;
parExp: '(' exp ')'; //expression in paranthesis
compExp: (VAR | NUMBER) (compOp (exp | parExp))?;//comparisons, may include single vars
arithExp: VAR assignOp (exp | parExp); //normal arithmetics
incDecExp: ('++' | '--')? VAR ('++' | '--')?; //inc/decrement
varAssign: VAR ('=' (VAR | NUMBER | CONSTANT | SCIENTIFIC_NUMBER)); //variable assignment
implementExp: (IMPLEMENTS VAR) (',' IMPLEMENTS VAR)*; //'implements' expression, supporting multi
conditionExp:'!'? compExp ('!'? (logicOp | bitOp) compExp)*;



/*----- RESERVED KEYWORDS -----*/
//defined before the general word/var form to take precedence in parsing i.e. the keywords will
// not be recognised as variables/words
fragment REQUIRE: 'require';
fragment CONST: 'const';
fragment FROM: 'from';
fragment CLASS: 'class';
fragment EXTENDS: 'extends';
fragment IMPLEMENTS: 'implements';
fragment LET: 'let';
fragment INT: 'int';
fragment FLOAT: 'float';
fragment VOID: 'void';
fragment TRUE: 'true';
fragment FALSE: 'false';
fragment IOTA: 'iota';
fragment NULL: 'null' | 'NULL';
fragment RETURN: 'return';
fragment IN: 'in';
fragment FOR: 'for';
fragment IF: 'if';
fragment STEP: 'step';
fragment AUTO: 'auto';
fragment WHILE: 'while';
fragment SWITCH: 'switch';
fragment CASE: 'case';
fragment DEFAULT: 'default';
fragment BREAK: 'break';
fragment ELSE: 'else';
fragment DO: 'do';
fragment NOT: 'not';
fragment AND: 'and';
fragment OR: 'or';
fragment BOOL: 'boolean';


/*----- GENRAL COMPONENTS -----*/
fragment UPPERCASE: [A-Z];
fragment LOWERCASE: [a-z];
fragment DIGIT: [0-9];
fragment LETTER: UPPERCASE | LOWERCASE;
WORD: (LETTER | '_') (LETTER | '_' | NUMBER)*;
VAR: (LETTER | '_') (LETTER | '_' | NUMBER)+;
//variables are 2+ characters, not starting with numerals
NUMBER:  DIGIT+ ([.,] DIGIT+)?;
SCIENTIFIC_NUMBER: DIGIT+ ([.,] DIGIT+)? ('e' NUMBER)?;
CONSTANT: TRUE | FALSE | NULL | IOTA;
