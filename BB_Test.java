/*
CMPUT 415 Assignment 1
Artem Herasymchuk (herasymc)
*/

import java.io.FileReader;

import org.antlr.runtime.ANTLRFileStream;
import org.antlr.runtime.CharStream;
import org.antlr.runtime.CommonTokenStream;
import org.antlr.runtime.tree.CommonTree;
import org.antlr.runtime.tree.CommonTreeNodeStream;
import org.antlr.stringtemplate.StringTemplate;
import org.antlr.stringtemplate.StringTemplateGroup;

public class BB_Test {
    public static void main(String[] args) throws Exception {
    	if (args.length != 1) {
    		System.out.println("Invalid arguments.\nUsage: java BB_Test <input file>");
    		System.exit(0);
    	}
        CharStream input = new ANTLRFileStream(args[0]);
        // Create the lexer
        BB_LLVM2ASTLexer lex = new BB_LLVM2ASTLexer(input);
        // Create a buffer of tokens between lexer and parser
        CommonTokenStream tokens = new CommonTokenStream(lex);
        // Create the parser, attaching it to the token buffer
        BB_LLVM2ASTParser p = new BB_LLVM2ASTParser(tokens);
        BB_LLVM2ASTParser.program_return program = p.program();   // launch parser at rule file
        
        CommonTree tree = (CommonTree) program.getTree();

        CommonTreeNodeStream nodes = new CommonTreeNodeStream(tree);
        nodes.setTokenStream(tokens);
        BB_AST2Template walker = new BB_AST2Template(nodes);
        FileReader file = new FileReader("BB2CFG.stg");
        StringTemplateGroup templates = new StringTemplateGroup(file);
        file.close();
        walker.setTemplateLib(templates);
        BB_AST2Template.printer_return retn = walker.printer();
        StringTemplate out = (StringTemplate)retn.getTemplate();
        System.out.println(out.toString());
    }
}
