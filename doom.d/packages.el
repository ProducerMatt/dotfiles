;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)
(package! olivetti)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))

;; the madness begins
(package! bqn-mode
  :recipe (:host github :repo "museoa/bqn-mode"))
(package! dyalog-mode)
(package! gnu-apl-mode
  :recipe (:host github :repo "lokedhs/gnu-apl-mode"))
;; See also input mode variables set by default in config.el

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)

;(unpin! clipetty)

(package! leetcode)
(package! literate-calc-mode)
(package! rnix-lsp
  :recipe (:host github :repo "nix-community/rnix-lsp"))
(package! org-auto-tangle)

(package! engrave-faces)

;(unpin! geiser-guile)
;(unpin! geiser)

(package! ob-mermaid)

;; Temp fix for "Error running hook global-git-commit-mode"
;; https://github.com/doomemacs/doomemacs/issues/6425
(package! transient
	  :pin "c2bdf7e12c530eb85476d3aef317eb2941ab9440"
	  :recipe (:host github :repo "magit/transient"))

(package! with-editor
	  :pin "bbc60f68ac190f02da8a100b6fb67cf1c27c53ab"
	  :recipe (:host github :repo "magit/with-editor"))

(package! nix-update
          :recipe (:host github :repo "jwiegley/nix-update-el"))

(package! disaster
  :recipe (:host github :repo "jart/disaster"))

(package! google-c-style)
(package! flycheck-google-cpplint)

;(package! gleam-mode
;  :recipe (:local-repo "~/gleam-mode"))
;(package! tree-sitter)
;(package! tree-sitter-indent
;  :recipe (:host nil
;           :repo "https://codeberg.org/FelipeLema/tree-sitter-indent.el.git"
;           :branch "main"
;           :files ("tree-sitter-indent.el")))
