

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
// char * dest, 
static inline char * sub_str(char * dest, char *src, int s_idx, int edix)
{
  int len = strlen(src);
  char *string = malloc((edix-s_idx+2));
  //is this necessary ?
  string[edix-s_idx+1] = '\0';
  int z=0, i=0;
  for(z=s_idx; z<=edix; z++)
  {    
      string[i] = src[z];
      i++;
  }
  dest=string;
  return dest;
}


static inline char * asm_sub_str(char * dest, char *src, int s_idx, int edix)
{
  char *string = malloc((edix-s_idx+2));
  //is this necessary ?
  string[edix-s_idx+1] = '\0';


  dest=string;
  return dest;
}



int main(int argc,char **argv) 
{

  char *pt_c;
  char *pt_asm;
  int s_idx = atoi(argv[2]);
  int edix  = atoi(argv[3]);

  pt_c=sub_str(pt_c, argv[1], s_idx, edix );
  printf("\n\n");
  printf(" starting index: %i\n", s_idx );
  printf("ending index :%i\n",edix );
  printf("sub string produced by c : %s\n\n", pt_c);
  // pt_asm=asm_sub_str(pt_asm, pt_c,0,4);

  // printf("sub string produced by asm : %s\n", pt_asm);

  free(pt_c);
  // free(pt_asm);
  return 0;
}

