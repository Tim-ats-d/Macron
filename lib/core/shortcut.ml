module CompKey = struct
  type t =
    | Mouse of int * (int * int) filter
    | Keyboard of int * Input.Keyboard.status filter

  and 'a filter = 'a -> bool
end

module Keybind = struct
  type t =
    | Mouse of (int * int) comb
    | Keyboard of Input.Keyboard.status comb
    | Then of t * t

  and 'a comb = ByCode of int * ('a -> bool)

  let mouse c = Mouse c
  let keyboard c = Keyboard c
  let then_ x y = Then (x, y)

  let compile =
    let rec aux acc = function
      | Mouse (ByCode (c, f)) -> CompKey.Mouse (c, f) :: acc
      | Keyboard (ByCode (c, f)) -> Keyboard (c, f) :: acc
      | Then (x, y) -> aux acc x @ aux acc y
    in
    aux []

  module Mouse = struct
    let by_code c f = Mouse (ByCode (c, f))
    let motionless = function 0, 0 -> true | _ -> false
    let ignore_move _ = true
  end

  module Keyboard = struct
    let by_code c f = Keyboard (ByCode (c, f))
    let on_depressed = function Input.Keyboard.Depressed -> true | _ -> false
    let on_release = function Input.Keyboard.Release -> true | _ -> false
    let on_repeat = function Input.Keyboard.Repeat -> true | _ -> false
    let on_hit _ = true
  end
end

module Action = struct
  type t =
    | ExtProcess of (string * string array)
    | Thunk of (unit -> unit Lwt.t)

  let ext_process cmd args = ExtProcess (cmd, args)
  let thunk t = Thunk t

  open Lwt.Syntax

  let exec = function
    | ExtProcess cmd ->
        let* _ = Lwt_process.exec cmd in
        Lwt.return_unit
    | Thunk t -> t ()
end

type t = { keys : Keybind.t; action : Action.t }

let make ~keys ~action = { keys; action }

module Infix = struct
  let ( |-> ) = Keybind.then_
  let ( <!> ) keys action = make ~keys ~action
end
