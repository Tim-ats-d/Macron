type t = Input.t option Lwt.t Lwt_stream.t

type mode = Both of in_chan * in_chan | Mouse of in_chan | Keyboard of in_chan
and in_chan = Lwt_io.input_channel

open Lwt.Syntax

let create ~mode =
  Lwt_stream.from (fun () ->
      Lwt.return_some
        (match mode with
        | Both (minc, kinc) ->
            Lwt.pick
              [
                (let+ input = Reader.MouseReader.read minc in
                 Option.map Input.mouse input);
                (let+ input = Reader.KeybReader.read kinc in
                 Option.map Input.keyboard input);
              ]
        | Mouse inc ->
            let+ input = Reader.MouseReader.read inc in
            Option.map Input.mouse input
        | Keyboard inc ->
            let+ input = Reader.KeybReader.read inc in
            Option.map Input.keyboard input))

let get stream =
  let* maybe_input = Lwt_stream.get stream in
  Option.get maybe_input
