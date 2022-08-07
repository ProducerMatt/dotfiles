let
  path = "git+file:///home/matt/flake";
  f = builtins.getFlake path;
in
f.inputs.nixrepl.repl-setup { source = path; isUrl = true; } #// builtins
