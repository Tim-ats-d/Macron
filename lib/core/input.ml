module Mouse = struct
  type t = { value : int; x : int; y : int }
  [@@deriving show { with_path = false }]
end

module Keyboard = struct
  type t = { timeval : int; code : int; status : status }
  [@@deriving show { with_path = false }]

  and status = Depressed | Repeat | Release

  let make ~timeval ~code ~status = { timeval; code; status }
end

type t = Mouse : Mouse.t -> t | Keyboard : Keyboard.t -> t [@@deriving show]

let mouse m = Mouse m
let keyboard k = Keyboard k
