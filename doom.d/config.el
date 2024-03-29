;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(setq gc-cons-threshold (* 100 1024 1024))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function.
;(setq doom-theme 'doom-Iosvkem)
(setq doom-theme 'doom-ir-black)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! olivetti
  (setq olivetti-mode 1)
  (setq olivetti-body-width 86))

(after! bqn-mode
  (set-input-method "BQN-Z")
  (setq default-input-method "BQN-Z"))
(after! gnu-apl-mode
  (set-input-method "APL-Z")
  (setq default-input-method "APL-Z"))

(setq auto-save-default t
      make-backup-files t)

(setq confirm-kill-emacs nil)

(after! smartparens
  (defun zz/goto-match-paren (arg)
    "Go to the matching paren/bracket, otherwise (or if ARG is not
    nil) insert %.  vi style of % jumping to matching brace."
    (interactive "p")
    (if (not (memq last-command '(set-mark
                                  cua-set-mark
                                  zz/goto-match-paren
                                  down-list
                                  up-list
                                  end-of-defun
                                  beginning-of-defun
                                  backward-sexp
                                  forward-sexp
                                  backward-up-list
                                  forward-paragraph
                                  backward-paragraph
                                  end-of-buffer
                                  beginning-of-buffer
                                  backward-word
                                  forward-word
                                  mwheel-scroll
                                  backward-word
                                  forward-word
                                  mouse-start-secondary
                                  mouse-yank-secondary
                                  mouse-secondary-save-then-kill
                                  move-end-of-line
                                  move-beginning-of-line
                                  backward-char
                                  forward-char
                                  scroll-up
                                  scroll-down
                                  scroll-left
                                  scroll-right
                                  mouse-set-point
                                  next-buffer
                                  previous-buffer
                                  previous-line
                                  next-line
                                  back-to-indentation
                                  doom/backward-to-bol-or-indent
                                  doom/forward-to-last-non-comment-or-eol
                                  )))
        (self-insert-command (or arg 1))
      (cond ((looking-at "\\s\(") (sp-forward-sexp) (backward-char 1))
            ((looking-at "\\s\)") (forward-char 1) (sp-backward-sexp))
            (t (self-insert-command (or arg 1))))))
  (map! "%" 'zz/goto-match-paren))

;; workaround for some errors
(after! geiser-guile
  (setq geiser-guile-binary "guile"))
(defalias 'run-geiser 'geiser)

;;; optional: per-section modification times in org-mode
;(after! org
;  (defun yant/getentryhash ()
;    "Get the hash sum of the text in current entry, except :HASH: and :MODIFIED: property texts."
;    (save-excursion
;      (let* ((beg (progn (org-back-to-heading) (point)))
;             (end (progn
;                    (forward-char)
;                    (if (not (re-search-forward "^\*+ " (point-max) t))
;                        (point-max)
;                      (match-beginning 0))))
;             (full-str (buffer-substring beg end))
;             (str-nohash (if (string-match "^ *:HASH:.+\n" full-str)
;                             (replace-match "" nil nil full-str)
;                           full-str))
;             (str-nohash-nomod (if (string-match "^ *:MODIFIED:.+\n" str-nohash)
;                                   (replace-match "" nil nil str-nohash)
;                                 str-nohash))
;             (str-nohash-nomod-nopropbeg (if (string-match "^ *:PROPERTIES:\n" str-nohash-nomod)
;                                             (replace-match "" nil nil str-nohash-nomod)
;                                           str-nohash-nomod))
;             (str-nohash-nomod-nopropbeg-end (if (string-match "^ *:END:\n" str-nohash-nomod-nopropbeg)
;                                                 (replace-match "" nil nil str-nohash-nomod-nopropbeg)
;                                               str-nohash-nomod-nopropbeg)))
;        (sxhash str-nohash-nomod-nopropbeg-end))))
;
;  (defun yant/update-modification-time ()
;    "Set the :MODIFIED: property of the current entry to NOW and update :HASH: property."
;    (org-set-property "HASH" (format "%s" (yant/getentryhash)))
;    (org-set-property "MODIFIED" (format-time-string "%Y-%m-%d %H:%M")))
;  (defun yant/skip-nonmodified ()
;    "Skip org entries, which were not modified according to the :HASH: property"
;    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
;      (if (string= (org-entry-get (point) "HASH" nil) (format "%s" (yant/getentryhash)))
;          next-headline
;        nil)))
;
;  (add-hook 'before-save-hook (lambda ()
;                                (when (eq major-mode 'org-mode)
;                                  (if org-update-heading-mod-times
;                                      (org-map-entries #'yant/update-modification-time nil 'file #'yant/skip-nonmodified)))))
;
;  (add-hook 'org-mode-hook 'org-auto-tangle-mode))

;;; latex export
;(after! ox-latex
;                                        ;;  (setq org-latex-listings 'engraved))
;  (setq org-latex-listings 'minted)
;  (setq org-latex-src-block-backend 'minted)
;  (setq org-export-latex-listings 'minted)
;  (when (boundp 'org-export-latex-packages-alist)
;    (add-to-list 'org-export-latex-packages-alist '("" "minted")))
;    (setq org-latex-compiler "xelatex")
;    (when (boundp 'org-latex-default-packages-alist)
;      (add-to-list 'org-latex-default-packages-alist
;                   '("" "titletoc" t)))
;  (when (boundp 'org-latex-minted-langs)
;    (add-to-list 'org-latex-minted-langs '(ipython "python"))
;    (add-to-list 'org-latex-minted-langs '(scheme "scheme")))
;  (setq org-latex-minted-options '(("breaklines" "true")
;                                   ("breakanywhere" "true")
;                                   ("linenos" "true")))
;    (setq org-latex-pdf-process
;          ;'("latexmk -xelatex -pdfxe -verbose -gg -shell-escape -interaction=nonstopmode -output-directory=%o %f")) ; debugging
;          '("latexmk -xelatex -pdfxe -verbose -f -shell-escape -interaction=nonstopmode -output-directory=%o %f"))
;    (setq org-export-latex-hyperref-format "\\ref{%s}")
;  )


(add-to-list 'auto-mode-alist '("\\.\\(scm\\|stk\\|ss\\|sch\\|scheme\\)\\'" . scheme-mode))

(after! org-auto-tangle
  (setq org-auto-tangle-babel-safelist '(
                                         "~/SICP-group/1/Answers.org")))

;(require 'org-id)
;(setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)
;;; when interactively getting links, create random id if none found
;
;(defun replace-all-header-links-with-id-links ()
;  "Replace all header links with id links and add ID properties when needed."
;  (interactive)
;  (save-excursion
;    (point-min)
;    (while (re-search-forward "\\[\\[\\*\\(.*?\\)\\]\\[\\(.*?\\)\\]\\]")
;      (let* ((link-text (match-string 2))
;             (header-title (match-string 1))
;             (header (org-find-exact-headline-in-buffer header-title)))
;        (when header
;	  ;(org-goto-marker-or-bmk header)
;          (let ((id (org-id-get header t)))
;            (replace-match (format "[[id:%s][%s]]" id link-text))
;            (org-entry-put (org-element-property :begin header) "ID" id)))))))
;;;; Chat GPT's first suggestion
;
;(defun replace-all-header-links-with-id-links ()
;  "Replace all header links with id links and add ID properties when needed."
;  (interactive)
;  (save-excursion
;    (goto-char (point-min))
;    (while (re-search-forward "\\[\\[*\\]\\[\\(.*?\\)\\]\\]" nil t)
;      (let* ((link-text (match-string 0))
;             (header-title (match-string 1))
;             (header (org-find-exact-headline-in-buffer header-title)))
;        (when header
;          (let ((id (org-id-get-create (org-id-find-id-in-file
;                                        (org-element-property :begin header)))))
;            (replace-match (format "[[id:%s][%s]]" id header-title))
;            (org-entry-put (org-element-property :begin header) "ID" id)))))))

(defun replace-header-links-with-org-id ()
  "Replace all header links in the current org-mode buffer with org-id links."
  (interactive)
  (save-excursion ; Save the current position of point
    (goto-char (point-min)) ; Go to the beginning of the buffer
    (while (re-search-forward "\\[\\[\\*\\(.*?\\)\\]\\[\\(.*?\\)\\]\\]") ; Search for header links
      (message "found: %S" (match-string-no-properties 0))
      (let* ((header-title (match-string-no-properties 1))
             (link-text (match-string-no-properties 2))
             (header-id (org-id-get (org-find-exact-headline-in-buffer header-title)))) ; Get the ID for the header
        (replace-match (concat "[[id:" header-id "][" link-text "]]")))))) ; Replace the link with an org-id link

(defun org-id-get-create-all-ids ()
  "Generate IDs for all headers in the buffer that do not already have an ID."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^\\*+ " nil t)
      (let ((id (org-entry-get (point) "ID"))
            (custom-id (org-entry-get (point) "CUSTOM-ID")))
        (if id
            (unless custom-id
              (org-entry-put (point) "CUSTOM-ID" id))
          (let ((new-id (org-id-new)))
            (org-entry-put (point) "ID" new-id)
            (org-entry-put (point) "CUSTOM-ID" new-id)))))))

(use-package! disaster
  :commands (disaster)
  :init
  ;; If you prefer viewing assembly code in `nasm-mode` instead of `asm-mode`
  (setq disaster-assembly-mode 'nasm-mode)

  (map! :localleader
        :map (c++-mode-map c-mode-map fortran-mode-map)
        :desc "Disaster" "d" #'disaster))

(after! flycheck
  (require 'flycheck-google-cpplint)
  ;; Add Google C++ Style checker.
  ;; In default, syntax checked by Clang and Cppcheck.
  (flycheck-add-next-checker 'c/c++-clang
                          '(warning . c/c++-googlelint)))

(add-hook! 'c-mode-common-hook 'google-set-c-style 'google-make-newline-indent)

;(add-hook! 'elixir-mode-hook ')

  (setq lsp-log-io t)
;(after! lsp-elixir
;  (setq lsp-elixir-server-command '("language_server.sh"))
;  (setq lsp-elixir-ls-server-dir "~/elixir-ls/rel/")
;  (setq lsp-elixir-ls-local-server-command "~/elixir-ls/rel/language_server.sh"))
;; Elixir machine broke, sorry
;(after! f
;  (let* ((els (executable-find "elixir-ls"))
;         (els-lib (f-join (file-name-directory (file-truename els))
;                          "../lib/"))
;         (els-dbg (f-join (file-name-directory (file-truename els-lib))
;                          "./language-server.sh")))
;    (setq lsp-elixir-server-command els-dbg)
;    (setq lsp-elixir-ls-server-dir els-lib)
;    (add-to-list 'exec-path els-lib))
;)
;; Workaround to enable running credo after lsp
;(after! lsp-clients
;  (lsp-register-client
;   (make-lsp-client :new-connection
;    (lsp-stdio-connection
;        (expand-file-name
;          "~/elixir-ls/rel/language_server.sh"))
;        :major-modes '(elixir-mode)
;        :priority -1
;        :server-id 'elixir-ls
;        :initialized-fn (lambda (workspace)
;            (with-lsp-workspace workspace
;             (let ((config `(:elixirLS
;                             (:mixEnv "dev"
;                                     :dialyzerEnabled
;                                     :json-false))))
;             (lsp--set-configuration config)))))))
(setq lsp-python-ms-executable (executable-find "python-language-server"))

;;; Be sure to edit the path appropriately; use the `.bat` script instead for Windows:
;(after! eglot
;  (add-to-list 'eglot-server-programs '(elixir-mode "~/elixir-ls/rel/language_server.sh")))
;
;(require 'eglot)
;
;(add-to-list 'exec-path "~/next-ls/bin/")
;
;(with-eval-after-load 'eglot
;  (add-to-list 'eglot-server-programs
;               `((elixir-ts-mode heex-ts-mode elixir-mode) .
;                 ("nextls"))))
;
;(add-hook 'elixir-mode-hook 'eglot-ensure)
;(add-hook 'elixir-ts-mode-hook 'eglot-ensure)
;(add-hook 'heex-ts-mode-hook 'eglot-ensure)

(use-package lsp-mode
  :commands lsp
  :ensure t
  :diminish lsp-mode
  :hook
  (elixir-mode . lsp)
  :init
  (add-to-list 'exec-path "~/elixir-ls/rel/"))
  ;(add-to-list 'exec-path "~/next-ls/bin/"))

;; (setq lsp-elixir-server-command '("nextls"))
;; (setq lsp-elixir-ls-server-dir "~/next-ls/bin/")
;; (setq lsp-elixir-ls-local-server-command "~/next-ls/bin/nextls")
(setq doom-emoji-fallback-font-families '("icons-in-terminal"))
(after! doom-modeline
  (setq doom-modeline-icon nil))
(advice-remove #'doom-modeline-propertize-icon #'+modeline-disable-icon-in-daemon-a)
