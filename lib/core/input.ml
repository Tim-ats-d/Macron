module Mouse = struct
  type t = { value : int; x : int; y : int }

  let pp fmt t =
    Format.fprintf fmt "Mouse: { value = %i; x = %i; y = %i }" t.value t.x t.y
end

module Keyboard = struct
  type t = { timeval : int; code : int; status : status }
  and status = Depressed | Repeat | Release

  let make ~timeval ~code ~status = { timeval; code; status }

  let pp_status fmt s =
    Format.fprintf fmt
    @@
    match s with
    | Depressed -> "Depressed"
    | Repeat -> "Repeat"
    | Release -> "Release"

  let pp fmt t =
    Format.fprintf fmt "Keyboard: { timeval = %i; code = %i; status = %a }"
      t.timeval t.code pp_status t.status
end

type t = Mouse : Mouse.t -> t | Keyboard : Keyboard.t -> t

let mouse m = Mouse m
let keyboard k = Keyboard k
