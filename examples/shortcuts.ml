open Macron.Core
open Macron.Core.Shortcut.Infix

let trigger () =
  let open Lwt.Syntax in
  let* () = Lwt_io.printl "Trigger!" in
  Lwt_io.(flush stdout)

let print_ok = Shortcut.Action.ext_process "echo" [| "ok" |]

let press_t =
  Shortcut.(Keybind.(Keyboard.(by_code 20 on_depressed)) <!> print_ok)

let ctrl_x =
  Shortcut.(
    Keybind.(Keyboard.(by_code 29 on_hit |-> by_code 45 on_hit))
    <!> Action.thunk trigger)

let azerty =
  Shortcut.(
    Keybind.(
      Keyboard.(
        by_code 16 on_depressed |-> by_code 17 on_hit |-> by_code 18 on_hit
        |-> by_code 19 on_hit |-> by_code 20 on_hit))
    <!> Action.thunk trigger)

let key_a_then_left_button =
  Shortcut.(
    Keybind.(Keyboard.(by_code 16 on_hit) |-> Mouse.(by_code 9 ignore_move))
    <!> Action.thunk trigger)

let () =
  Lwt_main.run
  @@ Main.poll
       (Main.Both ("/dev/input/mouse2", "/dev/input/event3"))
       [ press_t; ctrl_x; azerty; key_a_then_left_button ]
