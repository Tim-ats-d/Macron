module type S = sig
  type input

  val read : Lwt_io.input_channel -> input option Lwt.t
end

module type MOUSE_READER = S with type input := Input.Mouse.t
module type KEYBOARD_READER = S with type input := Input.Keyboard.t

module MouseReader : MOUSE_READER
module KeybReader : KEYBOARD_READER
