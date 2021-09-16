
(* The type of tokens. *)

type token = 
  | VAR
  | TOURNE
  | TANTQUE
  | SINON
  | SI
  | RPAREN
  | PV
  | PLUS
  | NOMBRE of (int)
  | MULT
  | MOINS
  | LPAREN
  | IDENT of (string)
  | HAUTPINCEAU
  | FSI
  | FIN
  | FAIRE
  | EOF
  | EGAL
  | DIV
  | DEBUT
  | CHANGEEPAISSEUR
  | CHANGECOULEUR
  | BASPINCEAU
  | AVANCE
  | ALORS

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val s: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.program)
