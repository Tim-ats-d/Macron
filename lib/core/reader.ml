module type S = sig
  type input

  val read : Lwt_io.input_channel -> input option Lwt.t
end

module type MOUSE_READER = S with type input := Input.Mouse.t
module type KEYBOARD_READER = S with type input := Input.Keyboard.t

open Lwt.Syntax

module MouseReader : MOUSE_READER = struct
  let read inc =
    let buf = Bytes.create 3 in
    let* _ = Lwt_io.read_into inc buf 0 3 in
    let read_buf n = Char.code (Bytes.unsafe_get buf n) in
    let value, x, y = (read_buf 0, read_buf 1, read_buf 1) in
    Lwt.return_some { Input.Mouse.value; x; y }
end

module KeybReader : KEYBOARD_READER = struct
  let decode buf from to_ =
    let acc = ref (Char.code (Bytes.unsafe_get buf from)) in
    for i = from + 1 to to_ do
      acc := !acc lor (Char.code (Bytes.unsafe_get buf i) lsl (i * 8))
    done;
    !acc

  let status_of_int = function
    | 0 -> Input.Keyboard.Depressed
    | 1 -> Release
    | 2 -> Repeat
    | _ -> assert false

  let read inc =
    let buf = Bytes.create 24 in
    let* _ = Lwt_io.read_into inc buf 0 24 in
    if decode buf 16 17 = 1 then
      let timeval = decode buf 0 3
      and code = decode buf 18 19
      and status = status_of_int @@ decode buf 20 23 in
      Lwt.return_some { Input.Keyboard.timeval; code; status }
    else Lwt.return_none
end
