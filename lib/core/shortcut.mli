module CompKey : sig
  type t =
    | Mouse of int * (int * int) filter
    | Keyboard of int * Input.Keyboard.status filter

  and 'a filter = 'a -> bool
end

module Keybind : sig
  type t =
    | Mouse of (int * int) comb
    | Keyboard of Input.Keyboard.status comb
    | Then of t * t

  and 'a comb = ByCode of int * ('a -> bool)

  val pp : Format.formatter -> t -> unit
  val mouse : (int * int) comb -> t
  val keyboard : Input.Keyboard.status comb -> t
  val then_ : t -> t -> t
  val compile : t -> CompKey.t list

  module Mouse : sig
    val by_code : int -> (int * int -> bool) -> t
    val motionless : int * int -> bool
    val ignore_move : int * int -> bool
  end

  module Keyboard : sig
    val by_code : int -> (Input.Keyboard.status -> bool) -> t
    val on_depressed : Input.Keyboard.status -> bool
    val on_release : Input.Keyboard.status -> bool
    val on_repeat : Input.Keyboard.status -> bool
    val on_hit : Input.Keyboard.status -> bool
  end
end

module Action : sig
  type t =
    | ExtProcess of (string * string array)
    | Thunk of (unit -> unit Lwt.t)

  val pp : Format.formatter -> t -> unit
  val ext_process : string -> string array -> t
  val thunk : (unit -> unit Lwt.t) -> t
  val exec : t -> unit Lwt.t
end

type t = { keys : Keybind.t; action : Action.t }

val pp : Format.formatter -> t -> unit
val make : keys:Keybind.t -> action:Action.t -> t

module Infix : sig
  val ( |-> ) : Keybind.t -> Keybind.t -> Keybind.t
  val ( <!> ) : Keybind.t -> Action.t -> t
end
