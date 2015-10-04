type void

module Code: sig
  val escape_all: int list -> string
  val escape: int -> string
end

module Text: sig
  val reset: string

  module Mode: sig
    type t = Bold | Underlined | Blinking | Reverse | Hidden

    val to_code: t -> int
    val escape: t -> string
    val render: t -> string -> string

    val bold:       string -> string
    val underlined: string -> string
    val blinking:   string -> string
    val reverse:    string -> string
    val hidden:     string -> string
  end

  module Color: sig
    type t = Black | Red | Green | Yellow | Blue | Magenta | Cyan | White

    val to_code: t -> int

    module Background: sig
      val to_code: t -> int
      val escape: t -> string
      val render: t -> string -> string
    end

    val escape: t -> string
    val render: t -> string -> string

    val black:   string -> string
    val red:     string -> string
    val green:   string -> string
    val yellow:  string -> string
    val blue:    string -> string
    val magenta: string -> string
    val cyan:    string -> string
    val white:   string -> string
  end
  module Style: sig
    type t = Foreground of Color.t | Background of Color.t | Mode of Mode.t

    val to_code: t -> int
    val escape: t -> string
    val render: t -> string -> string

    module Set: sig
      type nonrec t = t list
      val escape: t -> string
      val render: t -> string -> string
    end
  end
end

module Template: sig
  type 'a t =
    | Var of 'a
    | Text of string
    | Styled of Text.Style.Set.t * 'a t
    | Join of 'a t * 'a t

  module Compiled: sig
    type 'a t = Var of 'a * 'a t | Text of string * 'a t | End
  end

  val text: string -> 'a t
  val var: 'a -> 'a t
  val render: ?context:Text.Style.Set.t -> 'a t -> ('a -> string) -> string

  val to_string: ?context:Text.Style.Set.t -> void t -> string
  val print: 'a t -> ('a -> string) -> unit

  val compile: 'a -> 'a

  val (^) : 'a t -> 'a t -> 'a t

  val black:   'a t -> 'a t
  val red:     'a t -> 'a t
  val green:   'a t -> 'a t
  val yellow:  'a t -> 'a t
  val blue:    'a t -> 'a t
  val magenta: 'a t -> 'a t
  val cyan:    'a t -> 'a t
  val white:   'a t -> 'a t

  val on_black:   'a t -> 'a t
  val on_red:     'a t -> 'a t
  val on_green:   'a t -> 'a t
  val on_yellow:  'a t -> 'a t
  val on_blue:    'a t -> 'a t
  val on_magenta: 'a t -> 'a t
  val on_cyan:    'a t -> 'a t
  val on_white:   'a t -> 'a t

  val bold:       'a t -> 'a t
  val underlined: 'a t -> 'a t
  val blinking:   'a t -> 'a t
  val reverse:    'a t -> 'a t
  val hidden:     'a t -> 'a t
end
