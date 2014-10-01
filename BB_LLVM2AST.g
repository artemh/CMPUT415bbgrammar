/*
CMPUT 415 Assignment 1
Artem Herasymchuk (herasymc)
*/

grammar BB_LLVM2AST;

options {
  language = Java;
  output = AST;
  ASTLabelType = CommonTree;
}

tokens {
  PROGRAM; BLOCK; PREDLIST;
}

program
  : (block|garbage)*
  -> ^(PROGRAM block*)
    ;

block
  : id
  | label
  ;
  
id
  : SEMICOLON LESS LABEL GREATER COLON nameid (SEMICOLON predlist)? (NEWLINE|EOF)
  -> ^(BLOCK nameid predlist?)
  ;

label
  : namelabel COLON (SEMICOLON predlist)? (NEWLINE|EOF)
  -> ^(BLOCK namelabel predlist?)
  ;

garbage
  : LABEL ~COLON .* (NEWLINE|EOF)
  | SEMICOLON ~LESS .* (NEWLINE|EOF)
  | ~(LABEL|SEMICOLON) .* (NEWLINE|EOF)
  ;

predlist
  : LABEL EQUAL PERCENT name (',' PERCENT name)*
  -> ^(PREDLIST name+)
  | 'No' 'predecessors!'
  -> 
  ;

name
  : nameid
  | namelabel
  ;
  
nameid
  : NUMBER
  -> ^(NUMBER)
  ;

namelabel
  : LABEL
  -> ^(LABEL)
  ;

LABEL : ('a'..'z'|'.'|'A'..'Z') ('a'..'z'|'.'|'A'..'Z'|NUMBER)*;
NUMBER : ('0'..'9')+;
NEWLINE : ('\n'|'\r')+;
WS : (' '|'\t') {$channel = HIDDEN;};
COLON : ':';
SEMICOLON : ';';
LESS : '<';
GREATER : '>';
PERCENT : '%';
EQUAL : '=';
CHAR : ('\''|'('|')'|'/'|'-'|'_'|'|'|'"'|'{'|'}'|'#'|'!'|'@'|'*'|'['|']'|'\\');
