test:
	ocamlbuild -r -cflags '-w @a-44 -annot -bin-annot' -I vendor -no-links TerminalTest.byte --


clean:
	ocamlbuild -clean


build:
	ocamlbuild -r -cflags '-w @a-44 -annot -bin-annot' -I vendor -no-links Terminal.byte
