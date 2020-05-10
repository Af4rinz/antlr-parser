/*
 Author: Afarin Zamanian
 
 
 
 
 */
grammar stmntGrammar;

program: preProcess* statement*;
preProcess: (
		(VAR '=' REQUIRE VAR)
		| (VAR '=' FROM VAR REQUIRE VAR)
	) ';'?;

statement:
	forRange
	| forIt
	| ifStatement
	| whileLoop
	| doWhile
	| switchStatement
	| defStatement
	| classDef;

defStatement: (LET | CONST) (INT | FLOAT) '[]'? varAssign (',' varAssign)* ';'?; //variable definition, supporting multi-definition
classDef: CLASS VAR (EXTENDS VAR)? implementExp? '{' statement* '}';
ifStatement:
	IF '(' compExp ')' (('{' statement* '}') | statement) (
		ELSE (statement | ('{' statement* '}')))?;



WS: [ \t\r]+ -> skip; // skip spaces and tabs  

/*----- EXPRESSIONS -----*/

/*parts*/
arithOp: '+' | '-' | '*' | '/' | '%' | '//' | '**';
bitOp: '<<' | '>>' | '~' | '^' | '|' | '&';
logicOp: AND | OR | NOT | '&&' | '||';
assignOp: (arithOp)? '=';
//allows for expressions such as i += 2
compOp: '>' | '<' | '>=' | '<=' | '==' | '!=';

/*exps*/
exp: (VAR | NUMBER) (arithOp (VAR | NUMBER))*;
parExp: '(' exp ')'; //expression in paranthesis
compExp: (VAR | NUMBER) (compOp (exp | parExp))?;//comparisons, may include single vars
arithExp: VAR assignOp (exp | parExp); //normal arithmetics
incDecExp: ('++' | '--')? VAR ('++' | '--')?; //inc/decrement
varAssign: VAR ('=' (VAR | NUMBER | CONSTANT)); //variable assignment
implementExp: (IMPLEMENTS VAR) (',' IMPLEMENTS VAR)*; //'implements' expression, supporting multi
conditionExp:'!'? compExp ('!'? (logicOp | bitOp) compExp)*;



/*----- RESERVED KEYWORDS -----*/
//defined before the general word/var form to take precedence in parsing i.e. the keywords will
// not be recognised as variables/words
REQUIRE: 'require';
CONST: 'const';
FROM: 'from';
CLASS: 'class';
EXTENDS: 'extends';
IMPLEMENTS: 'implements';
LET: 'let';
INT: 'int';
FLOAT: 'float';
TRUE: 'true';
FALSE: 'false';
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
BREAK: 'break';
ELSE: 'else';
DO: 'do';
NOT: 'not';
AND: 'and';
OR: 'or';
/*----- GENRAL COMPONENTS -----*/
fragment UPPERCASE: [A-Z];
fragment LOWERCASE: [a-z];
fragment DIGIT: [0-9];
fragment LETTER: UPPERCASE | LOWERCASE;
WORD: (LETTER | '_') (LETTER | '_' | NUMBER)*;
VAR: (LETTER | '_') (LETTER | '_' | NUMBER)+;
//variables are 2+ characters, not starting with numerals
NUMBER: DIGIT+ ([.,] DIGIT+)?;
CONSTANT: TRUE | FALSE | NULL | IOTA;
