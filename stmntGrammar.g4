
grammar stmntGrammar;

program: statement*;
statement: forRange | forIt | ifStatement | whileLoop | doWhile | switchStatement;















WS: [ \t\r]+ -> skip; // skip spaces and tabs  

/*----- EXPRESSIONS -----*/
arithOp: '+' | '-' | '*' | '/' | '%';
assignOp: (arithOp)? '='; //allows for expressions such as i += 2
compOp: '>' | '<' | '>=' | '<=' | '==' | '!=';

exp: (VAR|NUMBER) (arithOp (VAR|NUMBER))*; 
compExp: (VAR | NUMBER) (compOp exp)?; //comparisons, may include single vars
arithExp: VAR assignOp exp; //normal arithmetics
incDecExp: ('++'| '--')? VAR ('++' | '--')?; //inc/decrement


/*----- RESERVED KEYWORDS -----*/

//defined before the general word/var form to take precedence in parsing
//i.e. the keywords will not be recognised as variables/words

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

/*----- GENRAL COMPONENTS -----*/
fragment UPPERCASE: [A-Z];
fragment LOWERCASE: [a-z];
fragment DIGIT: [0-9];
WORD: (LOWERCASE | UPPERCASE | '_')(LOWERCASE | UPPERCASE | '_' | NUMBER)*;
VAR: (LOWERCASE | UPPERCASE | '_')(LOWERCASE | UPPERCASE | '_' | NUMBER)+; //variables are 2+ characters
NUMBER: DIGIT+ ([.,] DIGIT+)?;

