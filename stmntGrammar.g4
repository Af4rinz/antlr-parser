grammar stmntGrammar;

program: (preProcess)* (statement | classDef | function)*;
preProcess: (
		(VAR '=' REQUIRE VAR)
		| (VAR '=' FROM VAR REQUIRE VAR)
	) ';'? NL;

statement:
	forRange
	| forIt
	| ifStatement
	| whileLoop
	| doWhileLoop
	| switchStatement
	| defStatement
	| incDecStatement
	| assignStatement
	;

defStatement: (LET | CONST) (INT | FLOAT | BOOL) '[]'? varAssign (',' varAssign)* ';'? NL; //variable definition, supporting multi-definitions

classDef: CLASS VAR (EXTENDS VAR)? implementExp? '{' (defStatement | function)* '}';

function: CONST? (VOID | INT | FLOAT | BOOL) VAR '(' (((INT | FLOAT | BOOL) VAR) (','(INT | FLOAT | BOOL) VAR)*)? ')' 
	'{' statement  (RETURN (exp)? ';')? '}' ;

ifStatement:
	IF '(' compExp ')' (('{' statement* '}') | statement) 
		(ELSE (('{' statement* '}') | statement))?;

whileLoop: WHILE '(' compExp (logicOp compExp) ')' (('{' statement* '}') | statement);
doWhileLoop: DO (('{' statement* '}') | statement) WHILE '(' compExp (logicOp compExp) ')' ';'? NL;

//switch statement include 0+ cases and may include one default case
switchStatement: SWITCH '(' VAR ')' '{' (CASE ('\'' (VAR | NUMBER) '\'') ':' (('{' statement* '}') | statement+) (BREAK ';'?)?)* 
	(DEFAULT ':'(('{' statement* '}') | statement+) (BREAK ';'?)?)? '}';

//range-based for, range is given in init:fin format with steps
forRange: FOR '(' VAR IN ((VAR|NUMBER)':'(VAR|NUMBER)) STEP (NUMBER|VAR) ')' (('{' statement* '}') | statement);

//iterative for using var IN iterator format
forIt: FOR '(' AUTO VAR IN VAR ')' (('{' statement* '}') | statement);

//single inc/decrement expression e.g. --j
incDecStatement: incDecExp ';'? NL ;
assignStatement: VAR assignOp (SCIENTIFIC_NUMBER | genExp) ';'? NL;

NL: [\r\n]+;
LCOMMENT: '#' ~[\r\n]* '\r'? '\n' -> skip; //skip single-line comments starting with #
MCOMMENT: '/*' .*? '*/' -> skip; //skip multiline comments in /*..*/ format
WS: [ \t\r\n]+ -> skip; // skip spaces and tabs  


/*----- EXPRESSIONS -----*/

/*parts*/
//u- signifies unary operator
powOp: '**';
multiDivOp: '*' | '/' | '%' | '//' ;
addSubOp: '+' | '-' ;
uArithOp: '-';
arithOp: powOp | addSubOp | multiDivOp;
bitOp: '<<' | '>>' | '^' | '|' | '&';
uBitOp: '~';
logicOp: AND | OR | '&&' | '||';
uLogicOp: NOT;
assignOp: (arithOp)? '='; //allows for expressions such as i += 2
compOp: '>' | '<' | '>=' | '<=' | '==' | '!=';

/*exps*/

exp: (uBitOp | uArithOp)? (VAR | NUMBER) (arithOp (VAR | NUMBER))*;
//expression in parentheses
parExp: '(' exp | ((uBitOp|uArithOp)?(VAR|NUMBER)) ')'; 
//combination of expression sentences with and without ()
genExp: (exp | parExp) ((powOp | multiDivOp | addSubOp | bitOp | logicOp)(parExp|exp))*;
//comparisons, may include single vars or non-comparative expressions
compExp: (exp | parExp) (compOp (exp | parExp))?;
//normal arithmetics
arithExp: VAR assignOp (exp | parExp); 
//inc/decrement
incDecExp: ('++' | '--')? VAR ('++' | '--')?; 
//variable assignment
varAssign: VAR ('=' (VAR | NUMBER | CONSTANT | SCIENTIFIC_NUMBER | genExp)); 
//'implements' expression, supporting multi
implementExp: (IMPLEMENTS VAR) (',' IMPLEMENTS VAR)*; 
conditionExp:(uLogicOp)? compExp ( (logicOp | bitOp) (uLogicOp)? compExp)*;



/*----- RESERVED KEYWORDS -----*/
//defined before the general word/var form to take 
//precedence in parsing i.e. the keywords will
//not be recognised as variables/words
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
DEFAULT: 'default';
BREAK: 'break';
ELSE: 'else';
DO: 'do';
NOT: 'not';
AND: 'and';
OR: 'or';
BOOL: 'boolean';
// KEYWORD: REQUIRE | CONST | FROM | CLASS | EXTENDS | IMPLEMENTS | LET | INT | FLOAT | VOID
// | TRUE | FALSE | IOTA | NULL | RETURN | IN | FOR | IF | STEP | AUTO | WHILE | SWITCH |CASE |DEFAULT
// |BREAK | ELSE | DO | NOT | OR | AND | BOOL;

/*----- GENRAL COMPONENTS -----*/
fragment UPPERCASE: [A-Z];
fragment LOWERCASE: [a-z];
fragment DIGIT: [0-9];
fragment LETTER: UPPERCASE | LOWERCASE;
WORD: (LETTER | '_')(LETTER | '_' | NUMBER)*;
VAR: (LETTER | '_')(LETTER | '_' | NUMBER)+;
//variables are 2+ characters, not starting with numerals
NUMBER:  DIGIT+ ([.,] DIGIT+)?;
SCIENTIFIC_NUMBER: DIGIT+ ([.,] DIGIT+)? ('e' NUMBER)?;
CONSTANT: TRUE | FALSE | NULL | IOTA;
