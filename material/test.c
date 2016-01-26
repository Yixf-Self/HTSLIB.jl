#include <stdlib.h>
#include <stdio.h>



int main(){
  
  char* s;
  int ls = 10;
  
  s = (char *)malloc(ls*sizeof(char));
  int i=0;
  for (i=0;i<ls-1;i++){
    s[i]= 'A';
    if (i==10){
      s[i] = 0;
    }
  }
  s[ls-1] = 0;
 
  printf("%s\n",s);
  
  
  return 0;
}
