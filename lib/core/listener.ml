open Lwt.Syntax

type t = < listen : Input.t option -> unit Lwt.t >

class listener shortcut =
  object (self)
    val mutable state : Shortcut.CompKey.t list option = None

    method private set_state s =
      state <- s;
      Lwt.return_unit

    method listen input =
      let cshort = Shortcut.Keybind.compile shortcut.Shortcut.keys in
      match (input, state) with
      | None, _ -> Lwt.return_unit
      | Some _, None -> self#set_state @@ Some cshort
      | _, Some [] ->
          let* () = Shortcut.Action.exec shortcut.action in
          self#set_state @@ Some cshort
      | ( Some (Input.Mouse { value; x; y }),
          Some (Shortcut.CompKey.Mouse (c, filter) :: []) )
        when filter (x, y) && Int.equal value c ->
          let* () = Shortcut.Action.exec shortcut.action in
          self#set_state @@ Some cshort
      | ( Some (Mouse { value; x; y }),
          Some (Shortcut.CompKey.Mouse (c, filter) :: xs) )
        when filter (x, y) && Int.equal value c ->
          self#set_state @@ Some xs
      | Some (Mouse _), Some (Shortcut.CompKey.Mouse _ :: _) ->
          self#set_state @@ Some cshort
      | ( Some (Keyboard { code; status; _ }),
          Some (Shortcut.CompKey.Keyboard (c, filter) :: []) )
        when filter status && Int.equal code c ->
          let* () = Shortcut.Action.exec shortcut.action in
          self#set_state @@ Some cshort
      | ( Some (Keyboard { code; status; _ }),
          Some (Shortcut.CompKey.Keyboard (c, filter) :: xs) )
        when filter status && Int.equal code c ->
          self#set_state @@ Some xs
      | Some (Keyboard _), Some (Shortcut.CompKey.Keyboard _ :: _) ->
          self#set_state @@ Some cshort
      | _ -> Lwt.return_unit
  end

class debug_listener _ =
  object
    method listen =
      function
      | None -> Lwt.return_unit
      | Some (Input.Mouse m) ->
          let* () = Lwt_fmt.printf "%a\n" Input.Mouse.pp m in
          Lwt_fmt.(flush stdout)
      | Some (Keyboard k) ->
          let* () = Lwt_fmt.printf "%a\n" Input.Keyboard.pp k in
          Lwt_fmt.(flush stdout)
  end

let make = new listener
let make_debug = new debug_listener
