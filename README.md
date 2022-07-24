# Macron

A powerful keybind library and daemon for Linux.

## Usage

### As a daemon

TODO

### As an OCaml library

You can create keybind easily with a large set of combinator:

```ocaml
open Macron.Core
open Macron.Core.Shortcut.Infix

let trigger () =
  let open Lwt.Syntax in
  let* () = Lwt_io.printl "Trigger!" in
  Lwt_io.(flush stdout)

let press_t =
  Shortcut.(
    Keybind.(Keyboard.(by_code 20 on_depressed))
    <!> Shortcut.Action.ext_process "echo" [| "ok" |])

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
       [ press_t; azerty; key_a_then_left_button ]
```

See [this file](examples/shortcuts.ml) for a more complete example.

## Installing

```
$ make deps
$ make build
$ make install
```

## Contributing

Pull requests, bug reports, and feature requests are welcome.

## License

- **GPL 3.0** or later. See [license](LICENSE) for more information.
