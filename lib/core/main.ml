type listen_channel =
  | Both of string * string
  | Mouse of string
  | Keyboard of string

open Lwt.Syntax

let observe istream shortcuts =
  let listeners = List.map Listener.make shortcuts in
  let rec forever () =
    let* input = IStream.get istream in
    let* () = Lwt_list.iter_p (fun l -> l#listen input) listeners in
    forever ()
  in
  forever ()

let poll mode shortcuts =
  let with_file = Lwt_io.with_file ~mode:Input in
  match mode with
  | Both (m, k) ->
      with_file m (fun minc ->
          with_file k (fun kinc ->
              observe
                (IStream.create ~mode:(IStream.Both (minc, kinc)))
                shortcuts))
  | Mouse m ->
      with_file m (fun inc ->
          observe (IStream.create ~mode:(Mouse inc)) shortcuts)
  | Keyboard k ->
      with_file k (fun inc ->
          observe (IStream.create ~mode:(Keyboard inc)) shortcuts)
