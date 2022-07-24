type listen_channel =
  | Both of string * string
  | Mouse of string
  | Keyboard of string

val poll : listen_channel -> Shortcut.t list -> 'a Lwt.t
