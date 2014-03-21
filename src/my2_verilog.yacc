%{
#include <stdio.h>
#include <string.h>
%}

%tokens

%start source_text

%%

source_text:
    | description_list
    ;

description_list:
      description
    | description_list description

description:
      module

module:
    

%%

