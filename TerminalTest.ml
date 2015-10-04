let (=>), test = Test.((=>), test)

module Template = Terminal.Template

let () = test "render text" @@ fun () ->
  Template.(to_string (text "foo")) => "foo"

let () = test "render variable" @@ fun () ->
  Template.(render (var `foo) (function `foo -> "bar")) => "bar"

let () = test "render color" @@ fun () ->
  Template.(to_string (red   (text "  red  "))) => "\027[31m  red  \027[0m";
  Template.(to_string (green (text " green "))) => "\027[32m green \027[0m"

let () = test "template concatenation" @@ fun () ->
  Template.(to_string (red (text " red ") ^ text " white "))
    => "\027[31m red \027[0m white "

let () = test "render background" @@ fun () ->
  Template.(to_string (red (on_green (text "*"))))
    => "\027[31m\027[42m*\027[0m\027[31m\027[0m"

let () = test "nested colors" @@ fun () ->
  Template.(to_string (red (text " a " ^ (green (text " b ")) ^ (text " c "))))
    => "\027[31m a \027[32m b \027[0m\027[31m c \027[0m"

module TestRestoringContext = struct
  let context = [Terminal.Text.(Style.Foreground Color.Red)]

  let () = test "no need to restore context of unstyled text" @@ fun () ->
    Template.(to_string ~context (text "a")) => "a";
    Template.(render ~context (var `var) (fun `var -> "var")) => "var"

  let () = test "styled text restores context" @@ fun () ->
    Template.(to_string ~context (bold (text " x ")))
      => "\027[1m x \027[0m\027[31m";
end
