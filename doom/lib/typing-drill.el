;;; typing-drill.el --- Description -*- lexical-binding: t; -*-
;;
;; Author: Blake
;; Maintainer: Blake
;; Created: September 29, 2023
;; Modified: September 29, 2023
;; Version: 0.0.1
;; Homepage: https://github.com/blake116th/dotfiles
;; Package-Requires: ((emacs "29.1"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;; A simple emacs typing drill for improving speed and accuracy.
;;
;;; Code:

(require 'evil)
(provide 'typing-drill)

;; Define a derived mode for typing drill
;; It will need a full ass keymap for all typeable keys and such
;; (define-derived-mode typing-drill-mode special-mode "Typing Drill Mode")

(defun typing-drill ()
  (interactive)
  (switch-to-buffer (get-buffer-create "Typing Drill"))
  (insert "Read only buffer!\n")
  (special-mode)
  (turn-off-evil-mode))


;;; typing-drill.el ends here
