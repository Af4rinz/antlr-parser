',' varAssign)* ';'? NL; //variable definition, supporting multi-definitions

classDef: CLASS VAR (EXTENDS VAR)? implementExp? '{' (defStatem