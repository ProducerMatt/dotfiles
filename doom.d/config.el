;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


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
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

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

(after! geiser-guile
  (setq geiser-guile-binary "guile"))

(after! org
  (defun yant/getentryhash ()
    "Get the hash sum of the text in current entry, except :HASH: and :MODIFIED: property texts."
    (save-excursion
      (let* ((beg (progn (org-back-to-heading) (point)))
             (end (progn
                    (forward-char)
                    (if (not (re-search-forward "^\*+ " (point-max) t))
                        (point-max)
                      (match-beginning 0))))
             (full-str (buffer-substring beg end))
             (str-nohash (if (string-match "^ *:HASH:.+\n" full-str)
                             (replace-match "" nil nil full-str)
                           full-str))
             (str-nohash-nomod (if (string-match "^ *:MODIFIED:.+\n" str-nohash)
                                   (replace-match "" nil nil str-nohash)
                                 str-nohash))
             (str-nohash-nomod-nopropbeg (if (string-match "^ *:PROPERTIES:\n" str-nohash-nomod)
                                             (replace-match "" nil nil str-nohash-nomod)
                                           str-nohash-nomod))
             (str-nohash-nomod-nopropbeg-end (if (string-match "^ *:END:\n" str-nohash-nomod-nopropbeg)
                                                 (replace-match "" nil nil str-nohash-nomod-nopropbeg)
                                               str-nohash-nomod-nopropbeg)))
        (sxhash str-nohash-nomod-nopropbeg-end))))

  (defun yant/update-modification-time ()
    "Set the :MODIFIED: property of the current entry to NOW and update :HASH: property."
    (org-set-property "HASH" (format "%s" (yant/getentryhash)))
    (org-set-property "MODIFIED" (format-time-string "%Y-%m-%d %H:%M")))
  (defun yant/skip-nonmodified ()
    "Skip org entries, which were not modified according to the :HASH: property"
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (if (string= (org-entry-get (point) "HASH" nil) (format "%s" (yant/getentryhash)))
          next-headline
        nil)))

  (add-hook 'before-save-hook (lambda ()
                                (when (eq major-mode 'org-mode)
                                  (if org-update-heading-mod-times
                                      (org-map-entries #'yant/update-modification-time nil 'file #'yant/skip-nonmodified)))))

  (add-hook 'org-mode-hook 'org-auto-tangle-mode))

(add-to-list 'auto-mode-alist '("\\.\\(scm\\|stk\\|ss\\|sch\\|scheme\\)\\'" . scheme-mode))
