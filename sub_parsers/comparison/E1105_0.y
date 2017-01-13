%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    extern  FILE *yyin;
%}

%glr-parser
%token END

%%

axiom: skip '0' star '#' skip '0' star END {}
     | skip '1' star '#' skip '1' star END {}
     | skip '2' star '#' skip '2' star END {}
     | skip '3' star '#' skip '3' star END {}
     | skip '4' star '#' skip '4' star END {}
     | skip '5' star '#' skip '5' star END {}
     | skip '6' star '#' skip '6' star END {}
     | skip '7' star '#' skip '7' star END {}
     | skip '8' star '#' skip '8' star END {}
     | skip '9' star '#' skip '9' star END {}
     | skip '.' star '#' skip '.' star END {}

char: '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' | '0' | '.'

star: char star | /* empty */

skip: /* empty */

%%
int yyerror(char *s){
    exit(-1);
}

/************************************************
** Main program
*************************************************/

int main(int argc, char *argv[]){
    yyin = fopen(argv[1], "r");
    if (yyin == NULL){
        printf("Invalid input file\n");
        return -1;
    }
    yyparse();
}
