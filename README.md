`Terminal.ml`—exercise terminal capabilities in OCaml
======================================================

`Terminal` is meant for exercising terminal capabilities, such as color text and cursor manipulation.

At the moment the only interesting functionality it provides is a type-safe templating language for printing color messages, limited to 16 colors.

If you need a more full-featured terminal manipulation library, [lambda-term](https://github.com/diml/lambda-term) is recommended.

This release is made to collect feedback on the library API design and implementation. To give feedback, create an [issue](https://github.com/keleshev/Terminal.ml/issues/new).

What follows is informal documentation of `Terminal.Template` module.
For more information see [`Terminal.mli`](https://github.com/keleshev/Terminal.ml/blob/master/Terminal.ml).


`Terminal.Template`
-------------------

`Terminal.Template` is a simple templating language for expressing styled terminal text with type-safe template variable substitution.

Alias `Terminal.Template` to `Template` for convenience:

```ocaml
module Template = Terminal.Template
```

To create a template for `hello <name>` where `hello` is green and `<name>` is a placeholder which is underlined, you write:

```ocaml
let template =
  Template.(green (text "hello ") ^ underlined (var `name))
```

You use functions like `green` and `underlined` for color and style, `text` for literal text and `var` for template variables, as well as `^` operator for concatenating sub-templates.

Available colors, backgrounds, and modes:

| Foregrounds | Backgrounds  | Modes        |
| ----------- | ------------ | ------------ |
| `black`     | `on_black`   | `bold`       |
| `red`       | `on_red`     | `underlined` |
| `green`     | `on_green`   | `blinking`   |
| `yellow`    | `on_yellow`  | `reverse`    |
| `blue`      | `on_blue`    | `hidden`     |
| `magenta`   | `on_magenta` |              |
| `cyan`      | `on_cyan`    |              |
| `white`     | `on_white`   |              |

You do *not* need to explicitly reset style at any point.

Template variables can be of any type, but polymorphic variants make most sense for this, since you don't need to declare them.

To render this template you need a function that maps from template variables to strings:

```ocaml
Template.render template (function `name -> "world")
```

It is a type error to misspell or omit a template variable when rendering.

If you want to render a template that has no template variables, use `to_string`:

```ocaml
Template.(to_string (red (text "Error: ") ^ text "out of bounds"))
```

It is a type error to call `to_string` on a template with template variables.


Example
-------

Imagine you wanted to make a template for an error message like this:

    Error: ./path/file.ml line 14: Invalid Quigley Matrix

Informally, the template would be:

    Error: <path> line <line>: <message>

Here's how you can construct such template:

```ocaml
let error_template =
  Template.(text "Error: " ^ var `path ^ text " line " ^
            var `line ^ text ": " ^ var `message)
```

Say, you want to add some style. You want to make `"Error:"` red, the path underlined, and the message bold. Here's what you can do:


```ocaml
let error_template =
  Template.(red (text "Error: ") ^ underlined (var `path) ^ text " line " ^
            var `line ^ text ": " ^ bold (var `message))
```

Now, to render this template into string you need to supply a function that maps from the template variables to strings:

```ocaml
let error_message =
  Template.render error_template @@ function
    | `path -> "./path/file.ml"
    | `line -> "14"
    | `message -> "Invalid Quigley Matrix"
```

Future
------

Plan for `Terminal.Template` to add more capabilities and color support.

Currently `Template.render` is a naive implementation that issues many redundant escape sequences that could be eliminated.
The plan is to make a `Template.compile` function that compiles to `Terminal.Compiled.t` that could be rendered more efficiently with optimal number of escape sequences.

Add full-screen and cursor capabilities.

Add to `opam` packages after getting API and design feedback.
