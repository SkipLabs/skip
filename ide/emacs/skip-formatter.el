;;; skip-formatter.el --- Minor mode to format Skip code on file save

;; Author: Benno Stein <benno@skiplabs.io>
;; Maintainer: Benno Stein <benno@skiplabs.io>
;; Package-Requires: ((reformatter "0.7"))
;; URL: https://github.com/skiplabs/skdb

;;; Defines a minor mode skip-format-on-save-mode
;;; (along with skip-format-buffer and skip-format-region functions)

;;; To enable by default, add this to your .emacs file:
;;; (require 'skip-formatter "<path to skdb>/ide/emacs/skip-formatter.el")
;;; (add-hook 'skip-mode-hook 'skip-format-on-save-mode)

;;; Optionally, configure to run skfmt in a docker container by setting
;;; the skip-format-in-docker custom variable

(require 'reformatter)

(defgroup skip-formatter nil
  "Minor mode to format Skip code on file save"
  :group 'languages
  :prefix "skip-formatter"
  :link '(url-link :tag "Repository" "https://github.com/skiplang/skip"))

(defcustom skip-format-in-docker nil
  "Where to run skfmt: either within a specified docker container or locally."
  :type '(choice
	  (string :tag "Docker Container")
	  (const :tag "Local" nil))
  :group 'skip-formatter)

(reformatter-define skip-format
  :program (if skip-format-in-docker "docker" "skfmt")
  :args (if skip-format-in-docker (list "exec" "-i" skip-format-in-docker "skfmt"))
  :lighter " skfmt"
  )

(provide 'skip-formatter)
