open Ast
   
exception Error of string

let rec get_declarations = function
  | [] -> []
  | (Var e) :: tl -> let rl = get_declarations tl in
                     if List.mem (Var e) rl
                     then raise (Error ("Variable déclarée plusieurs fois : " ^ e))
                     else if((e = "noir") || (e = "rouge") || (e = "bleu") || (e = "vert") || (e = "jaune") || (e = "cyan") || (e = "magenta")) then raise (Error ("Vous ne pouvez pas déclarer de variable ayant un nom de couleur : " ^ e))
                     else (Var e) :: rl
                     
let rec expression_type declarations = function
  | Nombre _ -> true
  | Ident s -> begin
      if(s = "noir") then true
      else if(s = "rouge") then true
      else if(s = "bleu") then true
      else if(s = "vert") then true
      else if(s = "jaune") then true
      else if(s = "cyan") then true
      else if(s = "magenta") then true
      else if List.mem (Var s) declarations then true
      else raise (Error ("Cette variable n'a pas été déclaré : " ^ s))
    end
  | Oper(e1, _, e2) ->
     let t1 = expression_type declarations e1
     and t2 = expression_type declarations e2
     in t1 && t2
  | OperUn(_, e) -> expression_type declarations e
                  
let rec checktypes_instruction declarations = function
  | Avance e -> begin
      if expression_type declarations e
      then ()
    end
  | Tourne e -> begin
      if expression_type declarations e
      then ()
    end
  | BasPinceau -> ()
  | HautPinceau -> ()
  | ChangeCouleur e -> begin
      if expression_type declarations e
      then ()
    end
  | ChangeEpaisseur e -> begin
      if expression_type declarations e
      then ()
    end
  | Affect(s, e) -> begin
      if List.mem (Var s) declarations
      then begin
          if expression_type declarations e
          then ()
        end
      else raise (Error ("Cette variable n'a pas été déclaré : " ^ s))
    end
  | BlockInstr bi -> List.iter (function i -> checktypes_instruction declarations i) bi
  | SiAlorsSinon(e, i1, i2) -> if expression_type declarations e
                               then checktypes_instruction declarations i1; checktypes_instruction declarations i2
  | SiAlors(e, i) -> if expression_type declarations e
                     then checktypes_instruction declarations i
  | TantQueFaire(e, i) -> if expression_type declarations e
                          then checktypes_instruction declarations i

let checktypes_program (dl, i) =
  checktypes_instruction (get_declarations dl) i
