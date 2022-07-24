type t

type mode =
  | Both of Lwt_io.input_channel * Lwt_io.input_channel
  | Mouse of Lwt_io.input_channel
  | Keyboard of Lwt_io.input_channel

val create : mode:mode -> Input.t option Lwt.t Lwt_stream.t
val get : 'a Lwt.t Lwt_stream.t -> 'a Lwt.t
