open Ast
open Typecheck

exception OutOfCanvas of string
                       
exception NotAColor of string

exception WidthTooSmall of string

let angle = ref 0

let draw = ref false
         
let radian a =
  (a*.(4.*.atan(1.)))/.180.0
;;

let variables_init l =
  List.map
    (function 
     | (Var e) -> (e, 0))
    l;;

let rec eval l expr =
  match expr with
  | Nombre i -> i
  | Ident s -> if(s = "noir") then 1
               else if(s = "rouge") then 2
               else if(s = "bleu") then 3
               else if(s = "vert") then 4
               else if(s = "jaune") then 5
               else if(s = "cyan") then 6
               else if(s = "magenta") then 7
               else List.assoc s l
  | Oper (el, op, er) -> begin
      let eval_l = eval l el in
      let eval_r = eval l er in
      match (eval_l, op, eval_r) with
      | (i, Plus, j) -> i + j
      | (i, Moins, j) -> i - j
      | (i, Mult, j) -> i * j
      | (i, Div, j) -> if j != 0 then i / j else raise (Error ("Division par 0 impossible."))
    end
  | OperUn(op_un, e) -> let eval_un = eval l e in
                        match (op_un, eval_un) with
                        | (Moins, i) -> (-i)

let rec exec_inst l inst =
  match inst with
  | Avance e -> let dist = eval l e in
                let foi = float_of_int in
                let iof = int_of_float in
                let new_x = foi(Graphics.current_x()) +. ((foi dist)*.cos(radian (foi !angle))) in
                let new_y = foi(Graphics.current_y()) -. ((foi dist)*.sin(radian (foi !angle))) in
                if ( (new_x < (-1.0)) || (new_y < 0.0) || (new_x > foi(Graphics.size_x())) || (new_y > foi(Graphics.size_y())) ) then
                  raise (OutOfCanvas ("Vous êtes en dehors du canevas !"))
                else
                  if (!draw) then
                    (Graphics.lineto (iof new_x) (iof new_y); l)
                  else
                    (Graphics.moveto (iof new_x) (iof new_y); l)
  | Tourne e -> let a = eval l e in angle := !angle+a; l
  | BasPinceau -> draw := true; l
  | HautPinceau -> draw := false; l
  | ChangeCouleur e -> let a = eval l e in
                 if(a = 1) then (Graphics.set_color Graphics.black; l)
                 else if(a = 2) then (Graphics.set_color Graphics.red; l)
                 else if(a = 3) then (Graphics.set_color Graphics.blue; l)
                 else if(a = 4) then (Graphics.set_color Graphics.green; l)
                 else if(a = 5) then (Graphics.set_color Graphics.yellow; l)
                 else if(a = 6) then (Graphics.set_color Graphics.cyan; l)
                 else if(a = 7) then (Graphics.set_color Graphics.magenta; l)
                 else raise (NotAColor ("La couleur choisie n'existe pas."))
  | ChangeEpaisseur e -> let a = eval l e in
                         if(a >= 0) then (Graphics.set_line_width(a); l)
                         else raise (WidthTooSmall ("L'épaisseur doit être supérieure ou égale à 0."))
  | Affect (s, e) -> let value = eval l e in (s, value) :: l
  | BlockInstr bi -> exec_list l bi
  | SiAlorsSinon(e, i1, i2) -> let eval_e = eval l e in
                               if eval_e != 0 then exec_inst l i1
                               else exec_inst l i2
  | SiAlors(e, i) -> let eval_e = eval l e in
                     if eval_e != 0 then exec_inst l i
                     else l
  | TantQueFaire(e, i) -> let eval_e = eval l e in
                          if eval_e = 0 then
                            []
                          else
                            let i_loop = TantQueFaire(e, i) in
                            exec_list l [i; i_loop]
                            
and exec_list l il =
  match il with
  | [] -> l
  | ins :: il' -> exec_list (exec_inst l ins) il'

let rec keep_win_open () =
  let e = Graphics.wait_next_event [Graphics.Key_pressed] in
  if (e.key == 'e') then exit 0
  else keep_win_open()

let exec_program (decl_l, ins_l) =
  let l = variables_init decl_l in
    Graphics.open_graph " 2000x1500"; ignore (exec_inst l ins_l); keep_win_open();
