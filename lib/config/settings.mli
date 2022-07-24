type t = { mode : mode; mouse_filename : string; keyboard_filename : string }
and mode = [ `both | `keyboard | `mouse ]

val parse : string -> (t, string) result
