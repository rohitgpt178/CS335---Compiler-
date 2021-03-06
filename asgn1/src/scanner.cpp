#include<bits/stdc++.h>
#include <cstdio>
#include <fstream>
#include <iostream>
#include "scanner.h"

using namespace std;

extern int yylex();
extern int yylineno;
extern char* yytext;


extern FILE *yyin;

string tokens[] = {"NIL","ASSIGN",
"ADD",
"SUB",
"MUL",
"QUO",
"REM",
"AND",
"OR",
"XOR",
"SHL",
"SHR",
"AND_NOT",
"ADD_ASSIGN",
"SUB_ASSIGN",
"MUL_ASSIGN",
"QUO_ASSIGN",
"REM_ASSIGN",
"AND_ASSIGN",
"OR_ASSIGN",
"XOR_ASSIGN",
"SHL_ASSIGN",
"SHR_ASSIGN",
"AND_NOT_ASSIGN",
"LAND",
"LOR",
"ARROW",
"INC",
"DEC",
"EQL",
"GTR",
"LSS",
"NOT",
"NEQ",
"LEQ",
"GEQ",
"DEFINE",
"ELLIPSIS",
"LPAREN",
"RPAREN",
"LBRACE",
"RBRACE",
"LBRACK",
"RBRACK",
"COMMA",
"SEMICOLON",
"COLON",
"PERIOD",
"PACKAGE",
"IMPORT",
"FUNC",
"REAK",
"CASE",
"CONST",
"CONTINUE",
"DEFAULT",
"ELSE",
"FOR",
"GO",
"IF",
"RANGE",
"RETURN",
"STRUCT",
"SWITCH",
"TYPE",
"VAR",
"VAR_TYPE",
"BOOL_CONST",
"NIL_VAL",
"IDENTIFIER",
"INTEGER",
"FLOAT",
"BYTE",
"STRING"};


int main(int argc, char **argv){
	//0 -> "NIL" 
	int n_token,v_token;
	int occ[74];
	for(int i=0;i<75;i++){
		occ[i] = 0;
	}
	vector <string> lexemes[74];
	
	yyin = fopen(argv[1], "r");
	
	n_token = yylex();
	while(n_token){
		//cout << "n_token = "<< n_token << " token = " << tokens[n_token] << " yytext = " << yytext  << endl;
		occ[n_token]++;
		lexemes[n_token].push_back(yytext);
		
		//v_token = yylex();
		//cout << "v_token = " << v_token << endl;
		//cout << "yytext = " << yytext << endl;
		n_token = yylex();
	}
	cout << setw(20) << "Token"  << setw(20) << "Occurences" << setw(20) << "Lexemes" << endl;
	cout << "______________________________________________________________________________________________" << endl;
	for(int i=0;i<75;i++){
		if(occ[i]!=0){
			cout << setw(20) << tokens[i] << setw(20) << occ[i];
			
			for(int j=0;j<occ[i];j++){
				if(j==0){
					cout << setw(20) << lexemes[i][j] << "\n";
				}
				else 	cout << setw(60) << lexemes[i][j] << "\n";
				if(i<66) break;
			}
			cout << endl;
		}
	}
	return 0;
}
