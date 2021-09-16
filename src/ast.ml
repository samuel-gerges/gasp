type op = Plus | Moins | Mult | Div

type op_un = Moins

type expression =
  | Nombre of int
  | Ident of string
  | Oper of expression * op * expression
  | OperUn of op_un * expression

type declaration =
  Var of string

type instruction =
  | Avance of expression
  | Tourne of expression
  | BasPinceau
  | HautPinceau
  | ChangeCouleur of expression
  | ChangeEpaisseur of expression
  | Affect of string * expression
  | BlockInstr of blockInstruction
  | SiAlorsSinon of expression * instruction * instruction
  | SiAlors of expression * instruction
  | TantQueFaire of expression * instruction
and blockInstruction = instruction list
                     
type program = declaration list * instruction
