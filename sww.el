;;; sww.el --- Switch to a named window on win32 systems

;; Copyright (C) 2003-2007 by Stefan Reichör

;; Emacs Lisp Archive Entry
;; Filename: sww.el
;; Author: Stefan Reichör, <stefan@xsteve.at>

;; sww.el is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; sww.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary

;; sww is an emacs wrapper for my switch to window utility
;; sww runs only on win32 systems
;; You need sww.exe (http://www.xsteve.at/prg/win/) if you want to use sww.el

;; sww provides the following features:
;; * Switch to a named window
;; * Start an application, if a window with a given name does not exist
;;   Otherwise switch to that window
;; * Show a named window
;; * Hide a named window
;; * Close an application by its window name
;; * Send keystrokes to an application (not finished at the moment)
;; * Set the priority of an application

;; Usage:
;; (require 'sww)
;; (setq sww-sww-cmd "c:/emacs/bin/sww.exe")

;; The latest version of sww.el can be found at:
;;   http://www.xsteve.at/prg/emacs/sww.el
;; The latest version of sww.exe can be found at:
;;   http://www.xsteve.at/prg/win/

;; Comments / suggestions welcome!


;;; History:
;;

;;; Code:

(defvar sww-debug nil "Debug the calls to sww")
(defvar sww-use-shell-execute t)
(defvar sww-use-title-substring-matching nil "When t, add -m to the sww command line.")
(defvar sww-sww-cmd (concat (file-name-directory (locate-library "sww")) "sww.exe") "Full path for the sww executable")

(defun sww-run-sww (window-name parameters)
  "Run sww with a the given WINDOW-NAME and the given PARAMETERS."
  (when sww-use-title-substring-matching
    (setq parameters (concat " -m" parameters)))
  (let ((param-string (concat parameters " " window-name)))
    (when sww-debug
      (message "sww-param: %s" param-string))
    (if sww-use-shell-execute
        (w32-shell-execute "open" sww-sww-cmd param-string)
      (shell-command-to-string (concat sww-sww-cmd param-string)))))

(defun sww (window-name)
  "Switch to the window called WINDOW-NAME using the shell command sww."
  (interactive "sSwitch to Window: ")
  (sww-run-sww window-name ""))

(defun sww-hide (window-name)
  "Hide all windows with a given WINDOW-NAME."
  (interactive "sHide Window: ")
  (sww-run-sww window-name "-h"))

(defun sww-show (window-name)
  "Show all windows with a given WINDOW-NAME."
  (interactive "sShow Window: ")
  (sww-run-sww window-name "-s"))

(defun sww-close-app (window-name)
  "Close all windows with a given WINDOW-NAME (send WM_CLOSE)."
  (interactive "sClose Window: ")
  (sww-run-sww window-name "-c"))

(defun sww-type-keys (window-name keys)
  "Send the keystrokes to a WINDOW-NAME.
The string KEYS is sent to the window. But only if there is only one window
that matches the WINDOW-NAME.
Caveat: not all key sequences are supported now - please mail me
(stefan@xsteve.at) if you want more!"
  (interactive "sShow Window: \nsKeys: ")
  (sww-run-sww window-name (concat "-k " "\"" keys "\"")))

(defun sww-with-app (window-name app)
  "Switch to the window called WINDOW-NAME, or start the application APP.
If the window window-name does not exist, Start the application APP."
  (interactive "sWindow name: \nsApplikation: ")
  ;;(sww-run-sww window-name (concat "-x \"" app "\"")))
  (shell-command-to-string (concat "sww -x \"" app "\" " window-name)))

(defun sww-set-high-priority (window-name)
  "Raise the process priority of the given WINDOW-NAME."
  (interactive "sRaise the priority of window: ")
  (shell-command-to-string (concat "sww -P1 " window-name)))

(defun sww-set-normal-priority (window-name)
  "Set the process priority of the given WINDOW-NAME to normal priority."
  (interactive "sSet the priority of window to normal priority: ")
  (shell-command-to-string (concat "sww -P2 " window-name)))

(provide 'sww)

;;; sww.el ends here

;; arch-tag: d22134ec-ab60-4a5a-9d32-5e245f7818ba
