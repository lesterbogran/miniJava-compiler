#include <iostream>
#include <stdlib.h>
#include <string>
#include <map>
#include <list>
#include <vector>

#include "miniJava.h"

using namespace std;

int PRINT_INDENT = 0;
int INDENT_SIZE = 2;

void exp_node::print(){
	cout << " ";	
}

exp_num_node::exp_num_node(int num){
	m_val = num;
}
void exp_num_node::print(){
	cout << m_val << ' ';
}
exp_id_node::exp_id_node(string id){
	m_id = id;
}
void exp_id_node::print(){
	cout << m_id << ' ';
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

exp_not_node::exp_not_node(exp_node* exp){
	m_exp = exp;
}
void exp_not_node::print(){
	cout << "(! ";
	m_exp->print();
	cout << ") ";
}

void state_node::print(){
	cout << " ";
}

state_if_node::state_if_node(exp_node *cond, state_node *iftrue, 
				  state_node *iffalse){
	m_cond = cond;
	m_iftrue = iftrue;
	m_iffalse = iffalse;
}

void state_if_node::print(){
	cout << "(if ";
	m_cond->print();
	m_iftrue->print();
	m_iffalse->print();
	cout << ") ";
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

state_print_node::state_print_node(exp_node *exp){
	m_exp = exp;
}

void state_print_node::print(){
	cout << "(System.out.println ";
	m_exp->print();
	cout << ") ";
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

exp_new_node::exp_new_node(string id){
	m_id = new exp_id_node(id);
}
void exp_new_node::print(){
	cout << "(new ";
	m_id->print();
	cout << ") ";
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
















