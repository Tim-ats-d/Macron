(lang dune 3.0)

(version 0.1)

(name macron)

(license "GPL-3.0")

(authors "The macron programmers")

(maintainers "tim.arnouts@protonmail.com")

(source
 (github Tim-ats-d/Macron))

(homepage "https://github.com/Tim-ats-d/Macron")

(generate_opam_files true)

(package
 (name macron)
 (synopsis "A powerful keybind library and daemon for Linux")
 (depends
  (dune
   (>= 3.0))
  (lwt
   (>= 5.6.0))
  (ppx_sexp_conv
   (>= "v0.15.1"))
  (ocaml
   (>= 4.13))))
