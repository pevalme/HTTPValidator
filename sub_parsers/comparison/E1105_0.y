%{
    /*
    HTTP Validator. Copyright (C) 2016  Pedro Valero

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    */
    
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
