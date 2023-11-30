;;; skip-flycheck.el --- A Flycheck checker for skip  -*- lexical-binding:t -*-

;; Author: Lucas Hosseini <lucas@skiplabs.io>
;; Keywords: skip
;; Package-Requires: ((flycheck) (skip))
;; URL: https://github.com/skiplabs/skdb

;;; Commentary:

;; Provides a flycheck checker for skip.

;; To enable, use something like this:

;;   (require 'skip-flycheck)
;;   (eval-after-load 'flycheck
;;     '(skip-flycheck-setup))

;;; Code:

(require 'skip)
(require 'flycheck)

(flycheck-define-checker skip
  "A syntax checker for skip."
  :command ("skargo" "check")
  :error-patterns
  ((error line-start "File \"" (file-name) "\", line " line ", characters " column "-" end-column ":\n" (message) line-end))
  :modes (skip-mode))

(defun skip-flycheck-setup ()
  "Setup skip-flycheck.
Add `skip' to `flycheck-checkers'."
  (add-to-list 'flycheck-checkers 'skip))

(provide 'skip-flycheck)
;;; skip-flycheck.el ends here
