let error_position outx lexbuf =
  Lexing.(
    let pos = lexbuf.lex_curr_p in
    Printf.fprintf outx "ERREUR: [Ligne %d Colonne %d]"
      pos.pos_lnum
      (pos.pos_cnum - pos.pos_bol + 1)
  )
  
let _ =
  let lb = Lexing.from_channel stdin
  in
  try
    let ast =
      Parser.s Lexer.token lb
    in Typecheck.checktypes_program ast; Interpreter.exec_program ast
  with
  | Lexer.Error error ->
     Printf.fprintf stderr "%a Caractère non reconnu : %s.\n" error_position lb error;
     exit (-1)
  | Parser.Error ->
     Printf.fprintf stderr "%a Erreur de syntaxe.\n" error_position lb;
     exit (-1)
  | Typecheck.Error s ->
     Printf.fprintf stderr "ERREUR DE TYPE: %s\n" s;
     exit (-1)
