#include <stdio.h>
#include <stdlib.h>

typedef struct __kstring_t {
  size_t l, m;
  char *s;
} kstring_t;


kstring_t * get_ptr_of_kstr(int num){
  char * ch = (char *)malloc(num);
  kstring_t *p = (kstring_t *)malloc(sizeof(kstring_t));
  p->l = 0; 
  p->m = num;
  p->s = ch;
  return p;
};


int main(){
  
  
  return 0;
}

