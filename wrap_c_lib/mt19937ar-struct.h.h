typedef struct _mt_state mt_state;
mt_state *make_mt(unsigned long s);
void free_mt(mt_state *state);
double genrand_real1(mt_state *state);
