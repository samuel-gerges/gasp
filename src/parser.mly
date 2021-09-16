%{ open Ast %}
%token<string> IDENT
%token<int> NOMBRE
%token PLUS MOINS MULT DIV EGAL PV (*<- point-virgule *) LPAREN RPAREN EOF
%token VAR AVANCE TOURNE BASPINCEAU HAUTPINCEAU CHANGECOULEUR CHANGEEPAISSEUR DEBUT FIN SI ALORS FSI SINON TANTQUE FAIRE
%start <Ast.program> s
%left PLUS MOINS
%left MULT DIV
%%

s: p=program EOF   { p }

program: d=declaration* i=instruction   { (d, i) }

declaration:
  | VAR id=IDENT PV   { Var(id) }

expression:
  | n=NOMBRE                            { Nombre(n) }
  | id=IDENT                            { Ident(id) }
  | e1=expression PLUS e2=expression    { Oper(e1, Plus, e2) }
  | e1=expression MOINS e2=expression   { Oper(e1, Moins, e2) }
  | e1=expression MULT e2=expression    { Oper(e1, Mult, e2) }
  | e1=expression DIV e2=expression     { Oper(e1, Div, e2) }
  | MOINS e=expression                  { OperUn(Moins, e) }
  | LPAREN e=expression RPAREN          { e }

instruction:
  | AVANCE e=expression                                         { Avance e }
  | TOURNE e=expression                                         { Tourne e }
  | BASPINCEAU                                                  { BasPinceau }
  | HAUTPINCEAU                                                 { HautPinceau }
  | CHANGECOULEUR e=expression                                  { ChangeCouleur e }
  | CHANGEEPAISSEUR e=expression                                { ChangeEpaisseur e }
  | id=IDENT EGAL e=expression                                  { Affect(id, e) }
  | DEBUT bi=blockInstruction FIN                               { BlockInstr(bi) }
  | SI e=expression ALORS i1=instruction SINON i2=instruction   { SiAlorsSinon(e, i1, i2) }
  | SI e=expression ALORS i1=instruction FSI                    { SiAlors(e, i1) }
  | TANTQUE e=expression FAIRE i=instruction                    { TantQueFaire(e, i) }

blockInstruction:
  | i=instruction PV bi=blockInstruction   { i :: bi }
  |                                        { [] }
