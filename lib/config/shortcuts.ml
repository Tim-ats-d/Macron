open Sexplib.Conv

type t = conf_shortc list [@@deriving sexp]
and conf_shortc = { name : string; keys : key list; action : string list }
and key = [ `mouse of id * mmethod | `keyboard of id * kmethod ]
and id = [ `by_code of int ]
and mmethod = [ `ignore_move | `motionless ]
and kmethod = [ `on_depressed | `on_release | `on_repeat | `on_hit ]

let to_key =
  let open Core.Shortcut.Keybind in
  function
  | `mouse (`by_code c, `ignore_move) -> Mouse.(by_code c ignore_move)
  | `mouse (`by_code c, `motionless) -> Mouse.(by_code c motionless)
  | `keyboard (`by_code c, `on_depressed) -> Keyboard.(by_code c on_depressed)
  | `keyboard (`by_code c, `on_release) -> Keyboard.(by_code c on_release)
  | `keyboard (`by_code c, `on_repeat) -> Keyboard.(by_code c on_repeat)
  | `keyboard (`by_code c, `on_hit) -> Keyboard.(by_code c on_hit)

exception EmptyKeys

module Shortc = Core.Shortcut

let shortcut_of_conf_shortc (sc : conf_shortc) =
  let keys =
    let rec loop = function
      | [] -> raise_notrace EmptyKeys
      | [ x ] -> to_key x
      | x :: xs -> Shortc.Keybind.then_ (to_key x) (loop xs)
    in
    loop sc.keys
  in
  let action = Shortc.Action.ext_process "" @@ Array.of_list sc.action in
  Shortc.make ~keys ~action

let parse str =
  try
    Sexplib.Sexp.of_string str
    |> Sexplib.Conv.list_of_sexp conf_shortc_of_sexp
    |> List.map shortcut_of_conf_shortc
    |> Result.ok
  with
  | Failure msg -> Error (`ParsingErr msg)
  | EmptyKeys -> Error `EmptyKeys
