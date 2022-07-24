module Mouse : sig
  type t = { value : int; x : int; y : int }

  val pp : Format.formatter -> t -> unit
end

module Keyboard : sig
  type t = { timeval : int; code : int; status : status }
  and status = Depressed | Repeat | Release

  val make : timeval:int -> code:int -> status:status -> t
  val pp : Format.formatter -> t -> unit
  val pp_status : Format.formatter -> status -> unit
end

type t = Mouse : Mouse.t -> t | Keyboard : Keyboard.t -> t

val mouse : Mouse.t -> t
val keyboard : Keyboard.t -> t
