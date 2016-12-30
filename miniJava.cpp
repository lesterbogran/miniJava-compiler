#include <iostream>
#include <stdlib.h>
#include <string>
#include <map>
#include <list>
#include <vector>

#include "miniJava.h"

using namespace std;

string int_to_string(int val){
	string res = "";
	for(;val>0;val/=10)
		res = res + (char)('0'+val%10);
	return res;
}


var_map::var_map(var_map *higher_map){
	///m_map = new map<string, int>();
	m_higher_map = higher_map;
}
void var_map::declare(string id, int val){
	m_map[id] = val;
}
void var_map::set(string id, int val){
	var_map *search;
	for(search=this; search!=NULL; search=search->m_higher_map)
		if(search->m_map.find(id) != search->m_map.end()){
			search->m_map[id]=val;
			return;
		}	
	this->declare(id, val); ///todo: maybe should raise an error
}
int var_map::get(string id, int *val){
	var_map *search;
	for(search=this; search!=NULL; search=search->m_higher_map)
		if(search->m_map.find(id) != search->m_map.end()){
			*val = search->m_map[id];
			return 0;
		}
	return -1;
}

int PRINT_INDENT = 0;
int INDENT_SIZE = 2;

void exp_node::print(){
	cout << " ";	
}
int exp_node::eval(var_map *v_map){
	return 0;
}

exp_num_node::exp_num_node(int num){
	m_val = num;
}
void exp_num_node::print(){
	cout << m_val << ' ';
}
int exp_num_node::eval(var_map *v_map){
	return m_val;
}
exp_id_node::exp_id_node(string id){
	m_id = id;
}
void exp_id_node::print(){
	cout << m_id << ' ';
}
int exp_id_node::eval(var_map *v_map){
	if(v_map->get(m_id, &m_val)==-1)
		cout << "Error: var not found!" << endl;
	return m_val;
}

exp_operator_node::exp_operator_node(string opt, exp_node* left, exp_node* right){
	m_left = left;
	m_right = right;
	m_operation = opt;
}
void exp_operator_node::print(){
	cout << '(' << m_operation << ' ';
	m_left->print();
	m_right->print();
	cout << ") ";
}
int exp_operator_node::eval(var_map *v_map){
	int l,r;
	l = m_left->eval(v_map);
	r = m_right->eval(v_map);
	if(m_operation.compare("+")==0)
		m_val = l+r;
	else if(m_operation.compare("-")==0)
		m_val = l-r;
	else if(m_operation.compare("*")==0)
		m_val = l*r;
	else if(m_operation.compare("/")==0)
		m_val = l/r;
	else if(m_operation.compare("==")==0)
		m_val = l==r;
	else if(m_operation.compare("<")==0)
		m_val = l<r;
	else if(m_operation.compare(">")==0)
		m_val = l>r;
	else if(m_operation.compare("&&")==0)
		m_val = l&&r;
	else if(m_operation.compare("||")==0)
		m_val = l||r;
	else
		cout << "Error: operation " << m_operation << "not supported!" << endl;
	return m_val;	
}
exp_at_node::exp_at_node(string id, exp_node* at){
	m_id = new exp_id_node(id);
	m_at = at;
}
void exp_at_node::print(){
	cout << "(at ";
	m_id->print();
	m_at->print();
	cout << ") ";
}
int exp_at_node::eval(var_map *v_map){
	int pos;
	string posed_name;
	pos = m_at->eval(v_map);
	///todo: range check
	posed_name = m_id->m_id + "[" + int_to_string(pos) + "]";
	if(v_map->get(posed_name, &m_val)==-1)
		m_val = 0;
	return m_val;	
}
// include exp_length_node

exp_point_node::exp_point_node(string id1, string id2){
	m_id1 = new exp_id_node(id1);
	m_id2 = new exp_id_node(id2);
}
void exp_point_node::print(){
	cout << "(. ";
	m_id1->print();
	m_id2->print();
	cout << ") ";
}
int exp_point_node::eval(var_map *v_map){
	///todo: fix this after CLASS finished
	string posed_name;
	posed_name = m_id1->m_id + '.' + m_id2->m_id;
	if(v_map->get(posed_name, &m_val)==-1)
		cout << "Error: var not found!" << endl;
	return m_val;	
}
exp_not_node::exp_not_node(exp_node* exp){
	m_exp = exp;
}
void exp_not_node::print(){
	cout << "(! ";
	m_exp->print();
	cout << ") ";
}
int exp_not_node::eval(var_map *v_map){
	m_val = m_exp->eval(v_map);
	m_val = ! m_val;
	return m_val;
}

void state_node::print(){
	cout << " ";
}
int state_node::eval(var_map *v_map){
	return 0;
}

state_if_node::state_if_node(exp_node *cond, vector<state_node *> *iftrue, 
				  vector<state_node *> *iffalse){
	m_cond = cond;
	m_iftrue = iftrue;
	m_iffalse = iffalse;
}

void state_if_node::print(){
	cout << "(if ";
	m_cond->print();
	
	PRINT_INDENT++;
	for(int i=0;i<m_iftrue->size();++i){
		cout << endl;
		for(int j=0;j<PRINT_INDENT*INDENT_SIZE;++j)cout << ' ';
		cout << "STATE" << i << ": ";
		((*m_iftrue)[i])->print();
	}
	///PRINT_INDENT--; ///ELSE is actually part of IF
	cout << endl;
	for(int j=0;j<PRINT_INDENT*INDENT_SIZE;++j)cout << ' ';
	cout << "ELSE: ";
	///PRINT_INDENT++; ///ELSE is actually part of IF
	for(int i=0;i<m_iffalse->size();++i){
		cout << endl;
		for(int j=0;j<PRINT_INDENT*INDENT_SIZE;++j)cout << ' ';
		cout << "STATE" << i << ": ";
		((*m_iffalse)[i])->print();
	}
	PRINT_INDENT--;
	cout << endl;
	for(int j=0;j<PRINT_INDENT*INDENT_SIZE;++j)cout << ' ';
	cout << ")";
}
int state_if_node::eval(var_map *v_map){
	if(m_cond->eval(v_map)){
		for(int i=0;i<m_iftrue->size();++i){
			((*m_iftrue)[i])->eval(v_map);
		}
	}else{
		for(int i=0;i<m_iffalse->size();++i){
			((*m_iffalse)[i])->eval(v_map);
		}
	}
	return 0;
}

state_while_node::state_while_node(exp_node *cond, vector<state_node *> *states){
	m_cond = cond;
	m_states = states;
}

void state_while_node::print(){
	cout << "(while ";
	m_cond->print();
	PRINT_INDENT++;
	for(int i=0;i<m_states->size();++i){
		cout << endl;
		for(int j=0;j<PRINT_INDENT*INDENT_SIZE;++j)cout << ' ';
		cout << "STATE" << i << ": ";
		((*m_states)[i])->print();
	}	
	PRINT_INDENT--;
	cout << endl;
	for(int j=0;j<PRINT_INDENT*INDENT_SIZE;++j)cout << ' ';
	cout << ") ";
}
int state_while_node::eval(var_map *v_map){
	while(m_cond->eval(v_map)){
		for(int i=0;i<m_states->size();++i){
			((*m_states)[i])->eval(v_map);
		}
	}
	return 0;
}


state_print_node::state_print_node(exp_node *exp){
	m_exp = exp;
}

void state_print_node::print(){
	cout << "(System.out.println ";
	m_exp->print();
	cout << ") ";
}
int state_print_node::eval(var_map *v_map){
	cout << m_exp->eval(v_map) << endl;
	return m_exp->m_val;
}
state_assign_node::state_assign_node(string id=NULL, exp_node* exp=NULL){
	m_id = new exp_id_node(id);
	m_exp = exp;
}

void state_assign_node::print(){
	cout << "(= ";
	m_id->print();
	m_exp->print();
	cout << ") ";
}
int state_assign_node::eval(var_map *v_map){
	int val;
	val = m_exp->eval(v_map);
	v_map->set(m_id->m_id, val);
	return val;
}

state_list_assign_node::state_list_assign_node(string id, exp_node *where,
						   exp_node *exp){
	m_id = new exp_id_node(id);
	m_where = where;
	m_exp = exp;
}

void state_list_assign_node::print(){
	cout << "(=";
	m_id->print();
	cout << '[';
	m_where->print();
	cout << ']';
	m_exp->print();
	cout << ") ";
}
int state_list_assign_node::eval(var_map *v_map){
	int pos,val;
	string posed_name;
	pos = m_where->eval(v_map);
	///todo: range check
	posed_name = m_id->m_id + "[" + int_to_string(pos) + "]";
	val = m_exp->eval(v_map);
	v_map->set(posed_name, val);
	return val;
}

void state_nop_node::print(){
	;
}

int state_nop_node::eval(var_map *v_map){
	;
}


exp_new_node::exp_new_node(string id){
	m_id = new exp_id_node(id);
}
void exp_new_node::print(){
	cout << "(new ";
	m_id->print();
	cout << ") ";
}
int exp_new_node::eval(var_map *v_map){
	///to I really need to fix this?
	return 0;
}
exp_new_list_node::exp_new_list_node(string id, exp_node *size){
	m_id = new exp_id_node(id);
	m_size = size;
}
void exp_new_list_node::print(){
	cout << "(new ";
	m_id->print();
	cout << '[';
	m_size->print();
	cout << "]) ";
}
int exp_new_list_node::eval(var_map *v_map){
	///to I really need to fix this?
	return 0;
}	

type_node::type_node(string id){
	m_id = new exp_id_node(id);
}

void type_node::print(){
	cout << "(type ";
	m_id->print();
	cout << ") ";
}

void type_list_node::print(){
	cout << "(type ";
	m_id->print();
	cout << "[]) ";
}

pgm::pgm(vector<state_node *> *statelist){
	m_statelist = statelist;
}
void pgm::print(){	
	for(int i=0;i<m_statelist->size();++i){
		cout << endl << "STATE" << i << ": ";
		((*m_statelist)[i])->print();
	}
	cout << endl;
}
int pgm::eval(){
	var_map GLOBAL_VAR_MAP;	
	for(int i=0;i<m_statelist->size();++i){
		((*m_statelist)[i])->eval(&GLOBAL_VAR_MAP);
	}
	cout << endl;
}














