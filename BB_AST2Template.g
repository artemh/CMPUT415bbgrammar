/*
CMPUT 415 Assignment 1
Artem Herasymchuk (herasymc)
*/

tree grammar BB_AST2Template;

options {
  language = Java;
  output = template;
  tokenVocab = BB_LLVM2AST;
  ASTLabelType = CommonTree;
}

@members {
  private ArrayList<String> entries = new ArrayList<String>();
  private HashMap<String, ArrayList<String>> map = new HashMap<String, ArrayList<String>>();
}

printer
  : ^(PROGRAM block*)
  -> Printer(entries={entries}, map={map})
  ;

block
  : ^(BLOCK id predlist) {map.put($id.value, $predlist.list); entries.add($id.value);}
  | ^(BLOCK id) {entries.add($id.value);}
  ;

predlist returns [ArrayList<String> list = new ArrayList<String>()]
  : ^(PREDLIST (id {$list.add($id.value);})+ )
  ;
  
id returns [String value]
  : NUMBER {$value = Integer.toString(Integer.parseInt($NUMBER.text));}
  | LABEL {$value = '"'+$LABEL.text+'"';}
  ;
