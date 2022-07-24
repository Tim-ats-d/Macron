open Sexplib.Conv

type t = { mode : mode; mouse_filename : string; keyboard_filename : string }
[@@deriving sexp]

and mode = [ `both | `mouse | `keyboard ]

let parse str =
  try Sexplib.Sexp.of_string str |> t_of_sexp |> Result.ok
  with Failure msg -> Error msg
