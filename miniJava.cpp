#include <iostream>
#include <stdlib.h>
#include <string>
#include <map>
#include <list>
#include <vector>

#include "miniJava.h"

using namespace std;

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
































