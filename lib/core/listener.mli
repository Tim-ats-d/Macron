type t = < listen : Input.t option -> unit Lwt.t >

val make : Shortcut.t -> t
val make_debug : Shortcut.t -> t
