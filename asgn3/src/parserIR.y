%{
#include <bits/stdc++.h>
//#include<stdlib.h>
#include "parserIR.tab.h"
#include "src/html.h"
using namespace std;

int yylex(void);
//void yyerror(char *s,...);
void yyerror (const char *s) {fprintf (stderr, "%s\n", s);} 

//string typeName="";
extern FILE *yyin;
extern int yylineno;

vector <string> lhs;
vector <string> rhs;

%}

//%error-verbose
%define parse.error verbose

%union {
     char *nt;
     char *sval;
}

%token <sval> PACKAGE IMPORT FUNC BREAK CASE CONST CONTINUE DEFAULT
%token <sval> ELSE FOR GO IF RANGE RETURN STRUCT SWITCH TYPE VAR VAR_TYPE
%token <sval> BOOL_CONST NIL_VAL IDENTIFIER BYTE STRING ELLIPSIS
%token <sval> SHL SHR INC DEC
%token <sval> INTEGER
%token <sval> FLOAT
%left <sval> ADD SUB MUL QUO REM 
%right <sval> ASSIGN AND NOT DEFINE AND_NOT
%left <sval> OR XOR ARROW //Identifier
%right <sval> ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN QUO_ASSIGN REM_ASSIGN
%right <sval> AND_ASSIGN OR_ASSIGN XOR_ASSIGN
%right <sval> SHL_ASSIGN SHR_ASSIGN AND_NOT_ASSIGN COLON
%left <sval> LAND LOR EQL NEQ LEQ GEQ SEMICOLON
%left <sval> GTR LSS LPAREN RPAREN LBRACE RBRACE LBRACK RBRACK COMMA PERIOD


%type <nt> StartFile Expression 
%type <nt> Block StatementList Statement SimpleStmt 
%type <nt> EmptyStmt /*ExpressionStmt*/ IncDecStmt 
%type <nt> Assignment Declaration ConstDecl VarSpec
%type <nt> Signature Result Parameters ParameterList ParameterDecl
%type <nt> ConstSpec MethodDecl Receiver TopLevelDecl TopLevelDeclList LabeledStmt
%type <nt> ReturnStmt BreakStmt ContinueStmt StructType
%type <nt> FunctionDecl FunctionName TypeList
%type <nt> Function FunctionBody FunctionCall ForStmt ForClause /*RangeClause*/ InitStmt ArgumentList
%type <nt> PostStmt Condition UnaryExpr PrimaryExpr
%type <nt> Selector Index /*Slice */TypeDecl TypeSpecList TypeSpec VarDecl
%type <nt> TypeAssertion ExpressionList ArrayType 
//%type <nt> ExprCaseClauseList ExprCaseClause
%type <nt> Operand Literal BasicLit OperandName ImportSpec IfStmt
%type <nt> ImportPath/* SliceType*/
%type <nt> PackageClause PackageName PackageName2 ImportDecl ImportDeclList ImportSpecList
%type <nt> FieldDeclList FieldDecl Type
%type <nt> TypeName
%type <nt> /*QualifiedIdent*/ PointerType IdentifierList

//%%



%% 


StartFile:
    PackageClause SEMICOLON ImportDeclList TopLevelDeclList {
    	lhs.push_back("StartFile");rhs.push_back("PackageClause SEMICOLON ImportDeclList TopLevelDeclList");//cout << "---" << $$ << "---" << $3 << "---";
    }
    ;

Block:
	LBRACE OPENB StatementList CLOSEB RBRACE{lhs.push_back("Block");rhs.push_back("LBRACE OPENB StatementList CLOSEB RBRACE");}
	//printf("I have a block -------");cout << $1 << endl;}
	; 


OPENB:
	/*empty*/{lhs.push_back("OPENB");rhs.push_back("/*empty*/");}
	;
	
CLOSEB:
	/*empty*/{lhs.push_back("CLOSEB");rhs.push_back("/*empty*/");}
	;

StatementList:
    StatementList Statement SEMICOLON {lhs.push_back("StatementList");rhs.push_back("StatementList Statement SEMICOLON");}//printf("got a list");}
    | Statement SEMICOLON {lhs.push_back("StatementList");rhs.push_back("Statement SEMICOLON");/*;printf("got a statement");*/}
    ;

Statement:
	Declaration {lhs.push_back("Statement");rhs.push_back("Declaration");}
	| LabeledStmt {lhs.push_back("Statement");rhs.push_back("LabeledStmt");}
	| SimpleStmt {lhs.push_back("Statement");rhs.push_back("SimpleStmt");}
	|ReturnStmt {lhs.push_back("Statement");rhs.push_back("ReturnStmt");}
	| BreakStmt {lhs.push_back("Statement");rhs.push_back("BreakStmt");}
	| ContinueStmt {lhs.push_back("Statement");rhs.push_back("ContinueStmt");}
	|Block {lhs.push_back("Statement");rhs.push_back("Block");}
	| IfStmt {lhs.push_back("Statement");rhs.push_back("IfStmt");}
	|  ForStmt {lhs.push_back("Statement");rhs.push_back("ForStmt");} 
	| FunctionCall {lhs.push_back("Statement");rhs.push_back("FunctionCall");} 
	| FunctionStmt {lhs.push_back("Statement");rhs.push_back("FunctionStmt");};

SimpleStmt:
	EmptyStmt {lhs.push_back("SimpleStmt");rhs.push_back("EmptyStmt");}
	|  IncDecStmt {lhs.push_back("SimpleStmt");rhs.push_back("IncDecStmt");}
	| Assignment {lhs.push_back("SimpleStmt");rhs.push_back("Assignment");} 
;

EmptyStmt:
	/*empty*/{lhs.push_back("EmptyStmt");rhs.push_back("/*empty*/");}
	;



LabeledStmt:
	Label COLON Statement {lhs.push_back("LabeledStmt");rhs.push_back("Label COLON Statement");};
Label:
	IDENTIFIER {lhs.push_back("Label");rhs.push_back("IDENTIFIER");};



IncDecStmt:
	Expression INC {lhs.push_back("IncDecStmt");rhs.push_back("Expression INC");}
	|Expression DEC {lhs.push_back("IncDecStmt");rhs.push_back("Expression DEC");};

Assignment:
	ExpressionList assign_op ExpressionList {lhs.push_back("Assignment");rhs.push_back("ExpressionList assign_op ExpressionList");}
	;

VarDecl:
		VAR VarSpec {lhs.push_back("VarDecl");rhs.push_back("VAR VarSpec");}
		;
VarSpec:
		IdentifierList Type ASSIGN ExpressionList {lhs.push_back("VarSpec");rhs.push_back("IdentifierList Type ASSIGN ExpressionList");}
		| IdentifierList Type {lhs.push_back("VarSpec");rhs.push_back("IdentifierList Type");}
		;


Declaration:
	ConstDecl {lhs.push_back("Declaration");rhs.push_back("ConstDecl");}
	| TypeDecl {lhs.push_back("Declaration");rhs.push_back("TypeDecl");}
	| VarDecl {lhs.push_back("Declaration");rhs.push_back("VarDecl");};


FunctionDecl:
		FUNC FunctionName OPENB Function CLOSEB {lhs.push_back("FunctionDecl");rhs.push_back("FUNC FunctionName OPENB Function CLOSEB");}
		|FUNC FunctionName OPENB Signature CLOSEB {lhs.push_back("FunctionDecl");rhs.push_back("FUNC FunctionName OPENB Signature CLOSEB");};
FunctionName:
		IDENTIFIER {lhs.push_back("FunctionName");rhs.push_back("IDENTIFIER");};
Function:
		Signature FunctionBody {lhs.push_back("Function");rhs.push_back("Signature FunctionBody");};
FunctionBody:		
		Block {lhs.push_back("FunctionBody");rhs.push_back("Block");};
//-----------------------------------------------------------------------------------------------start
//function call starts here
FunctionStmt:
		VarDecl DEFINE FunctionCall{lhs.push_back("FunctionStmt");rhs.push_back("VarDecl DEFINE FunctionCall");}
		//new changes
		| IDENTIFIER DEFINE FunctionCall{lhs.push_back("FunctionStmt");rhs.push_back("IDENTIFIER DEFINE FunctionCall");}
		;


FunctionCall:	PrimaryExpr LPAREN ArgumentList RPAREN {lhs.push_back("FunctionCall");rhs.push_back("PrimaryExpr LPAREN ArgumentList RPAREN");}
		;		

ArgumentList:	
		ArgumentList COMMA Arguments {lhs.push_back("ArgumentList");rhs.push_back("ArgumentList COMMA Arguments");}//{printf("function's arguments---1");}
		| Arguments {lhs.push_back("ArgumentList");rhs.push_back("Arguments");}//{printf("function's arguments ---2");}
		| /*empty*/{lhs.push_back("ArgumentList");rhs.push_back("/*empty*/");}
		;

Arguments:	PrimaryExpr {lhs.push_back("Arguments");rhs.push_back("PrimaryExpr");}//{printf("------------");}
		| FunctionCall {lhs.push_back("Arguments");rhs.push_back("FunctionCall");}
		;
		
//function call till here 

Signature:
	Parameters {lhs.push_back("Signature");rhs.push_back("Parameters");}
	|Parameters Result {lhs.push_back("Signature");rhs.push_back("Parameters Result");};

//------------------------------------------------------------------------------------------------------end
Result:
	LPAREN TypeList RPAREN {lhs.push_back("Result");rhs.push_back("LPAREN TypeList RPAREN");}
	| Type  {lhs.push_back("Result");rhs.push_back("Type");};

Parameters:
	LPAREN RPAREN { lhs.push_back("Parameters");rhs.push_back("LPAREN RPAREN");}//printf("gor func with no arguments");}
	| LPAREN ParameterList RPAREN {lhs.push_back("Parameters");rhs.push_back("LPAREN ParameterList RPAREN");}
	|LPAREN ParameterList COMMA RPAREN {lhs.push_back("Parameters");rhs.push_back("LPAREN ParameterList COMMA RPAREN");}
	; 
ParameterList:
	ParameterDecl {lhs.push_back("ParameterList");rhs.push_back("ParameterDecl");}
	|ParameterList COMMA ParameterDecl {lhs.push_back("ParameterList");rhs.push_back("ParameterList COMMA ParameterDecl");}
	;

//change

ParameterDecl:
	IdentifierList Type {lhs.push_back("ParameterDecl");rhs.push_back("IdentifierList Type");}
	| IdentifierList ELLIPSIS  Type {lhs.push_back("ParameterDecl");rhs.push_back("IdentifierList ELLIPSIS  Type");}
	|ELLIPSIS Type {lhs.push_back("ParameterDecl");rhs.push_back("ELLIPSIS Type");}
	;

TypeList:
    TypeList COMMA Type {lhs.push_back("TypeList");rhs.push_back("TypeList COMMA Type");}
    | Type {lhs.push_back("TypeList");rhs.push_back("Type");}
    ;

//change
//--------------------------------------------------------------------------------------------------------------------------------start
IdentifierList:
		IDENTIFIER IdentifierLIST {lhs.push_back("IdentifierList");rhs.push_back("IDENTIFIER IdentifierLIST");}
		| IDENTIFIER {lhs.push_back("IdentifierList");rhs.push_back("IDENTIFIER");}
		;
//-----------------------------------------------end		
IdentifierLIST:	IdentifierLIST COMMA IDENTIFIER {lhs.push_back("IdentifierLIST");rhs.push_back("IdentifierLIST COMMA IDENTIFIER");}
		| COMMA IDENTIFIER {lhs.push_back("IdentifierLIST");rhs.push_back("COMMA IDENTIFIER");}
		;

//change
MethodDecl:
	FUNC Receiver IDENTIFIER Function {lhs.push_back("MethodDecl");rhs.push_back("FUNC Receiver IDENTIFIER Function");}
	| FUNC Receiver IDENTIFIER Signature {lhs.push_back("MethodDecl");rhs.push_back("FUNC Receiver IDENTIFIER Signature");}
	;

Receiver:
	Parameters {lhs.push_back("Receiver");rhs.push_back("Parameters");};

TopLevelDeclList:
    TopLevelDeclList SEMICOLON /*here colon*/ TopLevelDecl  {lhs.push_back("TopLevelDeclList");rhs.push_back("TopLevelDeclList SEMICOLON  TopLevelDecl");}
    | TopLevelDecl  {lhs.push_back("TopLevelDeclList");rhs.push_back("TopLevelDecl");}
    ;

TopLevelDecl:
	Declaration {lhs.push_back("TopLevelDecl");rhs.push_back("Declaration");}	
	| FunctionDecl {lhs.push_back("TopLevelDecl");rhs.push_back("FunctionDecl");}
	| MethodDecl {lhs.push_back("TopLevelDecl");rhs.push_back("MethodDecl");}
	;

TypeLit:
	ArrayType {lhs.push_back("TypeLit");rhs.push_back("ArrayType");}
	| StructType {lhs.push_back("TypeLit");rhs.push_back("StructType");}
	| PointerType {lhs.push_back("TypeLit");rhs.push_back("PointerType");}
	| FunctionType {lhs.push_back("TypeLit");rhs.push_back("FunctionType");}
	;


//change

Type:
	TypeName {lhs.push_back("Type");rhs.push_back("TypeName");}
	| TypeLit {lhs.push_back("Type");rhs.push_back("TypeLit");}
	;

Operand:
	Literal {lhs.push_back("Operand");rhs.push_back("Literal");}
	| OperandName {lhs.push_back("Operand");rhs.push_back("OperandName");}
	| LPAREN Expression RPAREN {lhs.push_back("Operand");rhs.push_back("LPAREN Expression RPAREN");};

OperandName:
	IDENTIFIER {lhs.push_back("OperandName");rhs.push_back("IDENTIFIER");}
;

ReturnStmt:
	RETURN Expression {lhs.push_back("ReturnStmt");rhs.push_back("RETURN Expression");}
	|RETURN {lhs.push_back("ReturnStmt");rhs.push_back("RETURN");};

BreakStmt:
	BREAK Label {lhs.push_back("BreakStmt");rhs.push_back("BREAK Label");}
	| BREAK {lhs.push_back("BreakStmt");rhs.push_back("BREAK");};

ContinueStmt:
	CONTINUE Label {lhs.push_back("ContinueStmt");rhs.push_back("CONTINUE Label");}
	|CONTINUE {lhs.push_back("ContinueStmt");rhs.push_back("CONTINUE");}
	;

IfStmt:
	IF OPENB Expression Block CLOSEB {lhs.push_back("IfStmt");rhs.push_back("IF OPENB Expression Block CLOSEB");}//{printf("IF case 1");}
	|IF OPENB SimpleStmt SEMICOLON Expression Block CLOSEB {lhs.push_back("IfStmt");rhs.push_back("IF OPENB SimpleStmt SEMICOLON Expression Block CLOSEB");}//{printf("IF case 2");}
	|IF OPENB SimpleStmt SEMICOLON Expression Block ELSE IfStmt CLOSEB  {lhs.push_back("IfStmt");rhs.push_back("IF OPENB SimpleStmt SEMICOLON Expression Block ELSE IfStmt CLOSEB");}//{printf("IF case 3");}
	|IF OPENB SimpleStmt SEMICOLON Expression Block ELSE  Block CLOSEB {lhs.push_back("IfStmt");rhs.push_back("IF OPENB SimpleStmt SEMICOLON Expression Block ELSE  Block CLOSEB");}//{printf("IF case 4");}
	|IF OPENB Expression Block ELSE IfStmt CLOSEB {lhs.push_back("IfStmt");rhs.push_back("IF OPENB Expression Block ELSE IfStmt CLOSEB");}//{printf("IF case 5");}
	|IF OPENB Expression Block ELSE  Block CLOSEB {lhs.push_back("IfStmt");rhs.push_back("IF OPENB Expression Block ELSE  Block CLOSEB");}//{printf("IF case 6");}
	;

ForStmt:
	FOR OPENB Condition Block CLOSEB {lhs.push_back("ForStmt");rhs.push_back("FOR OPENB Condition Block CLOSEB");}
	|FOR OPENB ForClause Block CLOSEB {lhs.push_back("ForStmt");rhs.push_back("FOR OPENB ForClause Block CLOSEB");}
	;
Condition:
	Expression {lhs.push_back("Condition");rhs.push_back("Expression");};

ForClause:
	InitStmt SEMICOLON Condition SEMICOLON PostStmt {lhs.push_back("ForClause");rhs.push_back("InitStmt SEMICOLON Condition SEMICOLON PostStmt");}
	;
InitStmt:
	SimpleStmt {lhs.push_back("InitStmt");rhs.push_back("SimpleStmt");};
PostStmt:
	SimpleStmt {lhs.push_back("PostStmt");rhs.push_back("SimpleStmt");};

int_lit:
	INTEGER{lhs.push_back("int_lit");rhs.push_back("INTEGER");}
	;
float_lit:
	  FLOAT{lhs.push_back("float_lit");rhs.push_back("FLOAT");}
	  ;



TypeName:
	IDENTIFIER {lhs.push_back("TypeName");rhs.push_back("IDENTIFIER");}
	| VAR_TYPE {lhs.push_back("TypeName");rhs.push_back("VAR_TYPE");}
	;



ArrayType:
	LBRACK ArrayLength RBRACK Type{lhs.push_back("ArrayType");rhs.push_back("LBRACK ArrayLength RBRACK Type");}
	;

ArrayLength:
	Expression{lhs.push_back("ArrayLength");rhs.push_back("Expression");}
	;

StructType:
    STRUCT LBRACE FieldDeclList RBRACE {lhs.push_back("StructType");rhs.push_back("STRUCT LBRACE FieldDeclList RBRACE");}
    | STRUCT LBRACE RBRACE {lhs.push_back("StructType");rhs.push_back("STRUCT LBRACE RBRACE");}
    ;

FieldDeclList:
    FieldDecl SEMICOLON {lhs.push_back("FieldDeclList");rhs.push_back("FieldDecl SEMICOLON");}
    | FieldDeclList FieldDecl SEMICOLON {lhs.push_back("FieldDeclList");rhs.push_back("FieldDeclList FieldDecl SEMICOLON");}
    ;

FieldDecl:
	IdentifierList Type {lhs.push_back("FieldDecl");rhs.push_back("IdentifierList Type");}
	| IdentifierList Type Tag {lhs.push_back("FieldDecl");rhs.push_back("IdentifierList Type Tag");}
	;

Tag:
	STRING {lhs.push_back("Tag");rhs.push_back("STRING");}
	;

PointerType:
	MUL BaseType {lhs.push_back("PointerType");rhs.push_back("MUL BaseType");}
	;
BaseType:
	Type {lhs.push_back("BaseType");rhs.push_back("Type");}
	;

FunctionType:
	FUNC Signature {lhs.push_back("FunctionType");rhs.push_back("FUNC Signature");}
	;

ConstDecl:
		CONST ConstSpec {lhs.push_back("ConstDecl");rhs.push_back("CONST ConstSpec");}//{printf("at constant declaration");}
		;

ConstSpec:
		IDENTIFIER Type ASSIGN Expression {lhs.push_back("ConstSpec");rhs.push_back("IDENTIFIER Type ASSIGN Expression");}
		| IDENTIFIER Type {lhs.push_back("ConstSpec");rhs.push_back("IDENTIFIER Type");}
		;

ExpressionList:
		ExpressionList COMMA Expression {lhs.push_back("ExpressionList");rhs.push_back("ExpressionList COMMA Expression");}
		| Expression {lhs.push_back("ExpressionList");rhs.push_back("Expression");}
		;

TypeDecl:
		TYPE  TypeSpec {lhs.push_back("TypeDecl");rhs.push_back("TYPE  TypeSpec");}
		| TYPE LPAREN TypeSpecList RPAREN {lhs.push_back("TypeDecl");rhs.push_back("TYPE LPAREN TypeSpecList RPAREN");};

TypeSpecList:
		TypeSpecList TypeSpec SEMICOLON {lhs.push_back("TypeSpecList");rhs.push_back("TypeSpecList TypeSpec SEMICOLON");}
		| TypeSpec SEMICOLON {lhs.push_back("TypeSpecList");rhs.push_back("TypeSpec SEMICOLON");}
		;
TypeSpec:
		AliasDecl {lhs.push_back("TypeSpec");rhs.push_back("AliasDecl");}
		| TypeDef {lhs.push_back("TypeSpec");rhs.push_back("TypeDef");};

AliasDecl:
		IDENTIFIER ASSIGN Type {lhs.push_back("AliasDecl");rhs.push_back("IDENTIFIER ASSIGN Type");}
		;

TypeDef:
		IDENTIFIER Type {lhs.push_back("TypeDef");rhs.push_back("IDENTIFIER Type");}
		;




Literal:
	BasicLit {lhs.push_back("Literal");rhs.push_back("BasicLit");}
	| FunctionLit {lhs.push_back("Literal");rhs.push_back("FunctionLit");}
	;

string_lit:
	STRING {lhs.push_back("string_lit");rhs.push_back("STRING");}
	;

//added later
byte_lit:
	BYTE {lhs.push_back("byte_lit");rhs.push_back("BYTE");}
	;
	
BasicLit:
	int_lit {lhs.push_back("BasicLit");rhs.push_back("int_lit");}
	| float_lit {lhs.push_back("BasicLit");rhs.push_back("float_lit");}
	| string_lit {lhs.push_back("BasicLit");rhs.push_back("string_lit");}
	| byte_lit {lhs.push_back("BasicLit");rhs.push_back("byte_lit");}	//added later
	;


FunctionLit:
	FUNC Function {lhs.push_back("FunctionLit");rhs.push_back("FUNC Function");};
//-----------------------------------------------------------------------------start
PrimaryExpr:
	Operand {lhs.push_back("PrimaryExpr");rhs.push_back("Operand");}|
	PrimaryExpr Selector {lhs.push_back("PrimaryExpr");rhs.push_back("PrimaryExpr Selector");}|
	PrimaryExpr Index {lhs.push_back("PrimaryExpr");rhs.push_back("PrimaryExpr Index");}|
	PrimaryExpr TypeAssertion {lhs.push_back("PrimaryExpr");rhs.push_back("PrimaryExpr TypeAssertion");}|
	OperandName StructLiteral {lhs.push_back("PrimaryExpr");rhs.push_back("OperandName StructLiteral");}
	;
//------------------------------------------------------------------------------end
//here struct literal
StructLiteral:
    LBRACE KeyValList RBRACE {lhs.push_back("StructLiteral");rhs.push_back("LBRACE KeyValList RBRACE");}
    ;

KeyValList:
    	/* empty */  {lhs.push_back("KeyValList");rhs.push_back("/* empty */");}
 	| Expression COLON Expression {lhs.push_back("KeyValList");rhs.push_back("Expression COLON Expression");}
	| KeyValList COMMA Expression COLON Expression  {lhs.push_back("KeyValList");rhs.push_back("KeyValList COMMA Expression COLON Expression");}
	;
//till here struct literal

Selector:
	PERIOD IDENTIFIER {lhs.push_back("Selector");rhs.push_back("PERIOD IDENTIFIER");};
Index:	
	LBRACK Expression RBRACK {lhs.push_back("Index");rhs.push_back("LBRACK Expression RBRACK");};


TypeAssertion:
	PERIOD LPAREN Type RPAREN {lhs.push_back("TypeAssertion");rhs.push_back("PERIOD LPAREN Type RPAREN");}
	;

Expression:
    Expression1 {lhs.push_back("Expression");rhs.push_back("Expression1");}
    ;

Expression1:
    Expression1 LOR Expression2 {lhs.push_back("Expression1");rhs.push_back("Expression1 LOR Expression2");}//{cout << "expr21";}
    | Expression2 {lhs.push_back("Expression1");rhs.push_back("Expression2");}//{cout << "expr22";}
    ;

Expression2:
    Expression2 LAND Expression3 {lhs.push_back("Expression2");rhs.push_back("Expression2 LAND Expression3");}//{cout << "expr31";}
    | Expression3 {lhs.push_back("Expression2");rhs.push_back("Expression3");}//{cout << "expr32";}
    ;

Expression3:
    Expression3 rel_op Expression4 {lhs.push_back("Expression3");rhs.push_back("Expression3 rel_op Expression4");}//{cout << "expr41";}
    | Expression4 {lhs.push_back("Expression3");rhs.push_back("Expression4");}//{cout << "expr42";}
    ;

Expression4:
    Expression4 add_op Expression5 {lhs.push_back("Expression4");rhs.push_back("Expression4 add_op Expression5");}//{cout << "expr51";}
    | Expression5 {lhs.push_back("Expression4");rhs.push_back("Expression5");}//{cout << "expr52";}
    ;

Expression5:
    Expression5 mul_op PrimaryExpr {lhs.push_back("Expression5");rhs.push_back("Expression5 mul_op PrimaryExpr");}//{cout << "primary ";}
    | UnaryExpr {lhs.push_back("Expression5");rhs.push_back("UnaryExpr");}//{cout << "unary";}
    ;
    
//till here*/	

UnaryExpr:
	PrimaryExpr {lhs.push_back("UnaryExpr");rhs.push_back("PrimaryExpr");}
	| unary_op PrimaryExpr {lhs.push_back("UnaryExpr");rhs.push_back("unary_op PrimaryExpr");}
	//UnaryExpr {lhs.push_back("UnaryExpr");rhs.push_back("UnaryExpr");}
	;

//ops using tokens
/*
binary_op:
	LOR {lhs.push_back("binary_op");rhs.push_back("LOR");}
	| LAND {lhs.push_back("binary_op");rhs.push_back("LAND");}
	| rel_op {lhs.push_back("binary_op");rhs.push_back("rel_op");}
	| add_op {lhs.push_back("binary_op");rhs.push_back("add_op");}
	| mul_op {lhs.push_back("binary_op");rhs.push_back("mul_op");};*/
rel_op:
	EQL {lhs.push_back("rel_op");rhs.push_back("EQL");}
	| NEQ {lhs.push_back("rel_op");rhs.push_back("NEQ");}
	| LSS {lhs.push_back("rel_op");rhs.push_back("LSS");}
	| LEQ {lhs.push_back("rel_op");rhs.push_back("LEQ");}
	| GTR {lhs.push_back("rel_op");rhs.push_back("GTR");}
	| GEQ {lhs.push_back("rel_op");rhs.push_back("GEQ");};
add_op:
	ADD {lhs.push_back("add_op");rhs.push_back("ADD");}
	| SUB {lhs.push_back("add_op");rhs.push_back("SUB");}
	| OR {lhs.push_back("add_op");rhs.push_back("OR");}
	| XOR {lhs.push_back("add_op");rhs.push_back("XOR");};
mul_op:
	MUL {lhs.push_back("mul_op");rhs.push_back("MUL");}
	| QUO {lhs.push_back("mul_op");rhs.push_back("QUO");}
	| REM {lhs.push_back("mul_op");rhs.push_back("REM");}
	| SHL {lhs.push_back("mul_op");rhs.push_back("SHL");}
	| SHR {lhs.push_back("mul_op");rhs.push_back("SHR");}
	| AND {lhs.push_back("mul_op");rhs.push_back("AND");}
	| AND_NOT {lhs.push_back("mul_op");rhs.push_back("AND_NOT");};
//-------------------------------------------------------------------------------------------start
unary_op:
	ADD {lhs.push_back("unary_op");rhs.push_back("ADD");}
	| SUB {lhs.push_back("unary_op");rhs.push_back("SUB");}
	| NOT {lhs.push_back("unary_op");rhs.push_back("NOT");}
	| XOR {lhs.push_back("unary_op");rhs.push_back("XOR");}
	| MUL {lhs.push_back("unary_op");rhs.push_back("MUL");}
	| AND {lhs.push_back("unary_op");rhs.push_back("AND");}
	;
//----------------------------------------------------------------------------------------------------------------end

assign_op:
	  ASSIGN {lhs.push_back("assign_op");rhs.push_back("ASSIGN");}
	| ADD_ASSIGN {lhs.push_back("assign_op");rhs.push_back("ADD_ASSIGN");}
	| SUB_ASSIGN {lhs.push_back("assign_op");rhs.push_back("SUB_ASSIGN");}
	| MUL_ASSIGN {lhs.push_back("assign_op");rhs.push_back("MUL_ASSIGN");}
	| QUO_ASSIGN {lhs.push_back("assign_op");rhs.push_back("QUO_ASSIGN");}
	| REM_ASSIGN {lhs.push_back("assign_op");rhs.push_back("REM_ASSIGN");}
	//| DEFINE 
	;
/*IfStmt shift/reduce conflict*/

PackageClause:
	/*PACKAGE*/PACKAGE PackageName {lhs.push_back("PackageClause");rhs.push_back("PACKAGE PackageName");}//{printf("here i get package");}
	;
PackageName:
	IDENTIFIER {lhs.push_back("PackageName");rhs.push_back("IDENTIFIER");}//{printf("-----************package1--------");}
	;
	
ImportDeclList:
    //* empty */ {  }    |
      ImportDeclList ImportDecl  {lhs.push_back("ImportDeclList");rhs.push_back("ImportDeclList ImportDecl");}//{ printf("got import list 1");}
    | ImportDecl  {lhs.push_back("ImportDeclList");rhs.push_back("ImportDecl");}//{ printf("got import list 2"); }
    | /*empty*/ {lhs.push_back("ImportDeclList");rhs.push_back("/*empty*/");}//{ printf("got import list 3");}
    ;

ImportDecl:
	IMPORT ImportSpec SEMICOLON {lhs.push_back("ImportDecl");rhs.push_back("IMPORT ImportSpec SEMICOLON");}//{printf("got imports 1");}
	| IMPORT LPAREN ImportSpecList  RPAREN {lhs.push_back("ImportDecl");rhs.push_back("IMPORT LPAREN ImportSpecList  RPAREN");}//{printf("got imports 2");}
	;

ImportSpecList:
	ImportSpecList ImportSpec SEMICOLON {lhs.push_back("ImportSpecList");rhs.push_back("ImportSpecList ImportSpec SEMICOLON");}
	| ImportSpec SEMICOLON {lhs.push_back("ImportSpecList");rhs.push_back("ImportSpec SEMICOLON");}
	;
ImportSpec:
	 PERIOD ImportPath {lhs.push_back("ImportSpec");rhs.push_back("PERIOD ImportPath");}
	| PackageName2 ImportPath {lhs.push_back("ImportSpec");rhs.push_back("PackageName2 ImportPath");}
	| PackageName2 {lhs.push_back("ImportSpec");rhs.push_back("PackageName2");};
ImportPath:
	string_lit {lhs.push_back("ImportPath");rhs.push_back("string_lit");}
	;
PackageName2:
	string_lit {lhs.push_back("PackageName2");rhs.push_back("string_lit");}//{printf("-----package2----");}	
	;

%%


int main (int argc, char **argv) {
	
	yyin = fopen(argv[1], "r");	//taking input as argument
	//cout << "SIZES = " << lhs.size() << ' ' << rhs.size() << endl;
	yyparse ( );
	//cout << "SIZES = " << lhs.size() << ' ' << rhs.size() << endl;
	
	//top down right derivation
	reverse(lhs.begin(),lhs.end());
	reverse(rhs.begin(),rhs.end());
	
	fstream temp;
	temp.open("temp.txt",ios_base::out);
	
	
	for(int i=0;i<lhs.size();i++){
		//if(i<rhs.size()){
			temp << lhs[i] << " -> "<< rhs[i] << "$" << endl;
		//	}
		//else cout << "NOTE HERE " << endl;
	}
	temp.close();
	generate_html();
}












