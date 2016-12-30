#include <iostream>
#include <stdlib.h>
#include <string>
#include <map>
#include <list>
#include <vector>

using namespace std;

///////////////  exp begin /////////////
class exp_node {
public:
	int m_val;
    virtual void print();
};
class exp_num_node : public exp_node{
public:
	exp_num_node(int num);
	void print();
	int eval();
};
class exp_id_node : public exp_node{
public:
	string m_id;
	exp_id_node(string id);
	void print();
	int eval();
};
class exp_operator_node : public exp_node {
public:
	exp_node *m_left;
	exp_node *m_right;
	string m_operation; // || && < + - * /
	exp_operator_node(string opt, exp_node* left, exp_node* right);
	void print();
	int eval();	
};
class exp_at_node : public exp_node {
public:
	exp_id_node *m_id;
	exp_node *m_at;
	exp_at_node(string id, exp_node* at);
	void print();
	int eval();
};
// include exp_length_node
class exp_point_node : public exp_node{
public:
	exp_id_node *m_id1;
	exp_id_node *m_id2;
	exp_point_node(string id1, string id2);
	void print();
	int eval();
};
class exp_not_node : public exp_node{
public:
	exp_node *m_exp;
	exp_not_node(exp_node* exp);
	void print();
	int eval();
};
class exp_new_node : public exp_node{
public:
	exp_id_node *m_id;
	exp_new_node(string id);
	void print();
	int eval();
};
class exp_new_list_node : public exp_node{
public:
	exp_id_node *m_id;
	exp_node *m_size;
	exp_new_list_node(string id, exp_node *size);
	void print();
	int eval();
};

////////// exp end /////////////

///////// state begin /////////

class state_node {
public:
	virtual void print();
};

class state_if_node : public state_node{
public:
	exp_node *m_cond;
	state_node *m_iftrue;
	state_node *m_iffalse;
	state_if_node(exp_node *cond, state_node *iftrue, 
				  state_node *iffalse);
	void print();
	int eval();
};

class state_while_node : public state_node{
public:
	exp_node *m_cond;
	///state_node *m_state;
	vector<state_node *> *m_states;
	state_while_node(exp_node *cond, vector<state_node *> *states);
	void print();
	int eval();
};
class state_print_node : public state_node{
public:
	exp_node *m_exp;
	state_print_node(exp_node *exp);
	void print();
	int eval();
};

class state_assign_node : public state_node{
public:
	exp_id_node *m_id;
	exp_node *m_exp;
	state_assign_node(string id, exp_node* exp);
	void print();
	int eval();
};
class state_list_assign_node : public state_node{
public:
	exp_id_node *m_id;
	exp_node *m_where;
	exp_node *m_exp;
	state_list_assign_node(string id, exp_node *where,
						   exp_node *exp);
	void print();
	int eval();
};


class pgm {
public:
	vector<state_node *> *m_statelist;
	pgm(vector<state_node *> *statelist);
	void print();
	int eval();
};

///////// mini type /////////
class type_node{
public:
	exp_id_node *m_id;
	type_node(string id);
	void print();
};
class type_list_node : public type_node{
public:
	void print();
};


extern pgm *root;