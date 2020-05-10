
grammar stmntGrammar;

program: statement*;


















arithOp: '+' | '-' | '*' | '/' | '%';
assignOp: (arithOp)? '='; //allows for expressions such as i += 2+ j
compOp: '>' | '<' | '>=' | '<=' | '==' | '~=';

exp: (WORD|NUMBER) (arithOp (WORD|NUMBER))*; 
compExp: (WORD | NUMBER) (compOp exp)?; //comparisons
arithExp: (WORD | NUMBER) (arithOp)? assignOp exp; //normal arithmetics
incDecExp: ('++'| '--')? WORD ('++' | '--')?; //inc/decrement

WS: [ \t\r]+ -> skip; // skip spaces and tabs

fragment UPPERCASE: [A-Z];
fragment LOWERCASE: [a-z];
WORD: (LOWERCASE | UPPERCASE | '_')+;

fragment DIGIT: [0-9];
NUMBER: DIGIT+ ([.,] DIGIT+)?;
