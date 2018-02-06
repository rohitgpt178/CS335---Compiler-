#include<bits/stdc++.h>
using namespace std;

//include symtab.h
//make a header for irstruct as well


class tac{			//program will be scanned into a list(or map etc.) of objects of this class
	
	public:
	int lineno = 1;
	/*InstrType*/ string type = "";		//maybe define as enum type or mapping to types
	
	string in1 = "";				//SymTabEntry *in1;
	string in2 = "";				//SymTabEntry *in2;
	string out = "";				//SymTabEntry *out;		
		
	int target  = -1;
	string op = "";			//maybe define as enum type
	
	void get_details(){
		cout << "line = " << lineno << " type = " << type << " in1 = " << in1 << " in2 = " << in2 << " out = " << out << " target = " << target << " op = " << op << endl; 
	}
					//methods should be public
	/*void init_ir(string x,int y){	//this method will be called for each 3addr instruction
		type = x;
		target = y;
	}
	
	string getType(){
		return type;
	}
	
	int getTarget(){
		return target;
	}*/
};

int main(int argc, char **argv){
	vector <tac> prog;		//the whole ir code
	
	vector <int> leaders;		//block leaders if i is in leaders then prog[i] = leader
	leaders.push_back(1);
	
	string line;
	ifstream mycode(argv[1]);
	
	int is_prev = 0;		//1 if is_prev is goto - for leader
	
	while(getline(mycode,line)){
		//cout << line << endl;
		//cout << typeid(line).name() << endl;
		//line.ignore(' ');
		istringstream str(line);
		//cout << "-------------" << endl;
		string token;
		int i = 1;
		
		tac ins_temp;
		while(getline(str,token,',')){
			//cout << token << '\t' << typeid(token).name() << '\n';
			
			if(i==1){			//getting line no.
				ins_temp.lineno = stoi(token);
			}
			else if(i==2){				
				if(token=="="){
					ins_temp.type = "assign1";					//handles x = 3, x = y[i] , x = *y
				}	
				else if(token=="+"||token=="-"||token=="*"||token=="/"||token=="%"){	//x = y op z check for x = op y
					ins_temp.type = "assign2";
					ins_temp.op = "token";
				}//add more operators
				else if(token=="ifgoto"){
					ins_temp.type = "ifgoto";
				}
				else if(token=="goto"){
					ins_temp.type = "goto";
				}
				else if(token=="param"){
					ins_temp.type = "param";
				}
				else if(token=="call"){
					ins_temp.type = "call";
				}
				else if(token=="label"){
					ins_temp.type = "label";
				}
				else if(token=="ret"){
					ins_temp.type = "return1";					//no further tokens
				}
				else if(token=="return"){
					ins_temp.type = "return2";
				}
				else if(token=="print"){
					ins_temp.type = "print";
				}
				//label??
			}
			else{
				if(ins_temp.type == "assign1"){						//ptr and index assignments??
					if(i==3)ins_temp.out = token;
					if(i==4)ins_temp.in1 = token;
				}
				else if(ins_temp.type == "assign2"){
					if(i==3)ins_temp.out = token;
					if(i==4)ins_temp.in1 = token;
					if(i==5)ins_temp.in2 = token;
				}
				else if(ins_temp.type == "ifgoto"){
					if(i==3)ins_temp.op = token;
					if(i==4)ins_temp.in1 = token;
					if(i==5)ins_temp.in2 = token;
					if(i==6)ins_temp.target = stoi(token);
				}
				else if(ins_temp.type == "goto"){
					if(i==3)ins_temp.target = stoi(token);
				}
				else if(ins_temp.type == "param"){
					if(i==3)ins_temp.in1 = token;
				}
				else if(ins_temp.type == "call"){
					if(i==3)ins_temp.in1 = token;
					if(i==4)ins_temp.in2 = token;
				}
				else if(ins_temp.type == "label"){
					if(i==3)ins_temp.in1 = token;
				}
				else if(ins_temp.type == "return"){
					if(i==3)ins_temp.in1 = token;
				}
				else if(ins_temp.type == "print"){
					if(i==3)ins_temp.in1 = token;
				}
			}
			i++;
		}
		if(is_prev==1){
			leaders.push_back(ins_temp.lineno);
			//printf("HERE\n");
			is_prev = 0;
		}
		if(ins_temp.type == "ifgoto" || ins_temp.type == "goto"){
			leaders.push_back(ins_temp.target);
			//printf("HERE\n");
			is_prev = 1;
		}	
		prog.push_back(ins_temp);
		//printf("\n");		
	}
	
	
	for(int i=0;i<prog.size();i++){
		prog[i].get_details();
	}
	
	//printing leaders of blocks	
	/*for(int i=0;i<leaders.size();i++){
		cout << leaders[i] << "\t";
	}
	printf("\n");*/
	
	
	return 0;
}