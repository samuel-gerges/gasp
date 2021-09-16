{
  open Lexing
  open Parser
  exception Error of string

  let next_line lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <-
      { pos with pos_bol = lexbuf.lex_curr_pos;
                 pos_lnum = pos.pos_lnum + 1
      }
}

rule token = parse
     | [' ''\t']           { token lexbuf }
     | '\n'                { next_line lexbuf; token lexbuf }
     | eof                 { EOF }
     | ['a'-'z']+ as s     { IDENT s}
     | ['0'-'9']+ as n     { NOMBRE (int_of_string n) }
     | '+'                 { PLUS }
     | '-'                 { MOINS }
     | '*'     		   { MULT }
     | '/'     		   { DIV }
     | '='     		   { EGAL }
     | ';'     		   { PV }
     | '('     		   { LPAREN }
     | ')'     		   { RPAREN }
     | "Var"   		   { VAR }
     | "Avance" 	   { AVANCE }
     | "Tourne" 	   { TOURNE }
     | "BasPinceau" 	   { BASPINCEAU }
     | "HautPinceau" 	   { HAUTPINCEAU }
     | "ChangeCouleur"     { CHANGECOULEUR }
     | "ChangeEpaisseur"   { CHANGEEPAISSEUR }
     | "Debut" 		   { DEBUT }
     | "Fin"   		   { FIN }
     | "Si"   		   { SI }
     | "Alors"    	   { ALORS }
     | "Fsi"     	   { FSI }
     | "Sinon"   	   { SINON }
     | "TantQue"   	   { TANTQUE }
     | "Faire"   	   { FAIRE }
     | _       		   { raise (Error (Lexing.lexeme lexbuf)) }
