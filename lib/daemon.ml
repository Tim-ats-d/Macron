open Lwt.Syntax

let run_lwt () =
  let* str_settings =
    Lwt_io.with_file "examples/settings.sexp" ~mode:Input Lwt_io.read
  in
  match Config.Settings.parse str_settings with
  | Ok settings -> (
      let* str_shortcs =
        Lwt_io.with_file "examples/shortcuts.sexp" ~mode:Input Lwt_io.read
      in
      match Config.Shortcuts.parse str_shortcs with
      | Ok shortcuts ->
          Core.Main.poll
            (Core.Main.Both (settings.mouse_filename, settings.keyboard_filename))
            shortcuts
      | Error `EmptyKeys ->
          Lwt_io.printl "Error: shortcut with empty keys list are not allowed!"
      | Error (`ParsingErr msg) -> Lwt_fmt.printf "Error: %s\n" msg)
  | Error msg -> Lwt_fmt.printf "Error: %s\n" msg

let run () = Lwt_main.run @@ run_lwt ()
