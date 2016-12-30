#include <iostream>
#include <stdlib.h>
#include <string>
#include <map>
#include <list>
#include <vector>

using namespace std;


//////////////  eval begin /////////////////

class var_map{
private:
	var_map *m_higher_map;
	map<string, int> m_map;
public:
	var_map(var_map *higher_map = NULL);
	void declare(string id, int val=0);
	void set(string id, int val=0); /// will try to search upward
	int get(string id, int *val);  /// will try to search upward, return -1 if not found, 0 otherwise
};


///////////////  exp begin /////////////
class exp_node {
public:
	int m_val;
    virtual void print();
	virtual int eval(var_map *v_map);
};
class exp_num_node : public exp_node{
public:
	exp_num_node(int num);
	void print();
	int eval(var_map *v_map);
};
class exp_id_node : public exp_node{
public:
	string m_id;
	exp_id_node(string id);
	void print();
	int eval(var_map *v_map);
};
class exp_operator_node : public exp_node {
public:
	exp_node *m_left;
	exp_node *m_right;
	string m_operation; // || && < + - * /
	exp_operator_node(string opt, exp_node* left, exp_node* right);
	void print();
	int eval(var_map *v_map);	
};
class exp_at_node : public exp_node {
public:
	exp_id_node *m_id;
	exp_node *m_at;
	exp_at_node(string id, exp_node* at);
	void print();
	int eval(var_map *v_map);
};
// include exp_length_node
class exp_point_node : public exp_node{
public:
	exp_id_node *m_id1;
	exp_id_node *m_id2;
	exp_point_node(string id1, string id2);
	void print();
	int eval(var_map *v_map);
};
class exp_not_node : public exp_node{
public:
	exp_node *m_exp;
	exp_not_node(exp_node* exp);
	void print();
	int eval(var_map *v_map);
};
class exp_new_node : public exp_node{
public:
	exp_id_node *m_id;
	exp_new_node(string id);
	void print();
	int eval(var_map *v_map);
};
class exp_new_list_node : public exp_node{
public:
	exp_id_node *m_id;
	exp_node *m_size;
	exp_new_list_node(string id, exp_node *size);
	void print();
	int eval(var_map *v_map);
};

////////// exp end /////////////

///////// state begin /////////

class state_node {
public:
	virtual void print();
	virtual int eval(var_map *v_map);
};

class state_if_node : public state_node{
public:
	exp_node *m_cond;
	vector<state_node *> *m_iftrue;
	vector<state_node *> *m_iffalse;
	state_if_node(exp_node *cond, vector<state_node *> *iftrue, 
				  vector<state_node *> *iffalse);
	void print();
	int eval(var_map *v_map);
};

class state_while_node : public state_node{
public:
	exp_node *m_cond;
	vector<state_node *> *m_states;
	state_while_node(exp_node *cond, vector<state_node *> *states);
	void print();
	int eval(var_map *v_map);
};
class state_print_node : public state_node{
public:
	exp_node *m_exp;
	state_print_node(exp_node *exp);
	void print();
	int eval(var_map *v_map);
};

class state_assign_node : public state_node{
public:
	exp_id_node *m_id;
	exp_node *m_exp;
	state_assign_node(string id, exp_node* exp);
	void print();
	int eval(var_map *v_map);
};
class state_list_assign_node : public state_node{
public:
	exp_id_node *m_id;
	exp_node *m_where;
	exp_node *m_exp;
	state_list_assign_node(string id, exp_node *where,
						   exp_node *exp);
	void print();
	int eval(var_map *v_map);
};
class state_nop_node : public state_node{
public:
	void print();
	int eval(var_map *v_map);
};

/*
class pgm {
public:
	vector<state_node *> *m_statelist;
	pgm(vector<state_node *> *statelist);
	void print();
	int eval();
};
*/

///////// mini type /////////
class type_node{
public:
	exp_id_node *m_id;
	type_node(string id);
	void print();
};
class type_list_node : public type_node{
public:
	type_list_node(string id);
	void print();
};
class var_declare_node : public state_node{
public:
	type_node *m_type;
	exp_id_node *m_id;
	var_declare_node(type_node *type, string id);
	void print();
	int eval(var_map *v_map);
};
class method_declare_node{
public:
	exp_id_node *m_id;
	vector<state_node *> *m_statelist;
	exp_node *m_result;
	method_declare_node(string id, vector<state_node *> *statelist, exp_node *result);
	void print();
	int eval(var_map *v_map);
};
	
class pgm {
public:
	method_declare_node *m_m;
	pgm(method_declare_node *m);
	void print();
	int eval();
};

extern pgm *root;