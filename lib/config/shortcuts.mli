type t = conf_shortc list
and conf_shortc = { name : string; keys : key list; action : string list }
and key = [ `keyboard of id * kmethod | `mouse of id * mmethod ]
and id = [ `by_code of int ]
and mmethod = [ `ignore_move | `motionless ]
and kmethod = [ `on_depressed | `on_hit | `on_release | `on_repeat ]

val parse :
  string ->
  (Core.Shortcut.t list, [> `EmptyKeys | `ParsingErr of string ]) result
