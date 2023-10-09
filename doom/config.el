;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Blake")
;;       user-mail-address "john@doe.com")

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
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

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

;; Some attempts to disable evil mode in vterm.
;; none of these seem to work. oh well. maybe ask someone who knows their stuff.
;; (add-hook 'vterm-mode-hook (lambda () (turn-off-evil-mode)))
;; (evil-set-initial-state 'vterm-mode 'emacs)
;; (add-hook 'vterm-mode-hook
          ;; (lambda () (progn
                ;; (evil-emacs-state)
                ;; (local-unset-key "ESC")))

;; use h and l to navigate in and out of dirs
(evil-define-key 'normal dired-mode-map
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-find-file)

;; move deleted files to trash
(setq delete-by-moving-to-trash t
      trash-directory "~/Trash")

(map! :leader "o c" #'cheatsheet)

;; Bindings for Flycheck errors
(map! :leader
      (:prefix ("e" . "Errors (Flycheck)")
      "p" #'flycheck-previous-error
      "n" #'flycheck-next-error
      "l" #'flycheck-list-errors
      "y" #'flycheck-copy-errors-as-kill))


;; Assert that Blake dotfiles are in the home directory
(unless (file-directory-p "~/dotfiles")
  (error "Looked for Blake's dotfiles in the home directory and didn't find them. This Emacs config depends on these bad bois, so go clone them."))

(let ((cheatsheet-filepath "~/dotfiles/keybindings.org"))
  (defun cheatsheet ()
    "Shows blake's cheatsheet notes in the current window"
    (interactive)
    (switch-to-buffer (find-file cheatsheet-filepath))))

;; Map SPC o c to open the cheatsheet in the current window
(map! :leader "o c" #'cheatsheet)

;; Add blake's emacs scripts to the load path
(add-to-list 'load-path "~/dotfiles/doom/lib")

(require 'typing-drill)


;; stolen from the internet to fix this stupid mac thing where
;; the path isn't inherited fully cause emacs isnt launched from terminal context
;; https://www.emacswiki.org/emacs/ExecPath
;; 
;; this fix is hacked together with some changes by yours truly and should probably not be used for non-mac machines
(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match
that used by the user's shell.

This is particularly useful under Mac OS X and macOS, where GUI
apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
			  "[ \t\n]*$" "" (shell-command-to-string
					  "source ~/.zshrc && echo $PATH"
						    ))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)
