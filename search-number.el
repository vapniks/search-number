;;; search-number.el --- Search for numbers matching conditions

;; Filename: search-number.el
;; Description: Search for numbers matching condition (e.g. numbers greater than 10)
;; Author: Joe Bloggs <vapniks@yahoo.com>
;; Maintainer: Joe Bloggs <vapniks@yahoo.com>
;; Copyleft (Ↄ) 2017, Joe Bloggs, all rites reversed.
;; Created: 2017-02-09 02:11:06
;; Version: 0.1
;; Last-Updated: 2017-02-09 02:11:06
;;           By: Joe Bloggs
;;     Update #: 1
;; URL: https://github.com/vapniks/search-number
;; Keywords: convenience
;; Compatibility: GNU Emacs 24.5.1
;; Package-Requires:  
;;
;; Features that might be required by this library:
;;
;; 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; This file is NOT part of GNU Emacs

;;; License
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.
;; If not, see <http://www.gnu.org/licenses/>.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Commentary: 
;;
;; Bitcoin donations gratefully accepted: 1ArFina3Mi8UDghjarGqATeBgXRDWrsmzo
;;
;; Search for numbers matching conditions, (e.g. numbers greater than 10).
;; Useful when exploring data files.
;; 
;;;;;;;;

;;; Commands:
;;
;; Below is a complete list of commands:
;;
;;  `search-forward-number'
;;    Search forward for number which satisfies predicate PRED.
;;    Keybinding: M-x search-forward-number
;;  `search-backward-number'
;;    Search backward for number which satisfies predicate PRED.
;;    Keybinding: M-x search-backward-number
;;

;;; Installation:
;;
;; Put search-number.el in a directory in your load-path, e.g. ~/.emacs.d/
;; You can add a directory to your load-path with the following line in ~/.emacs
;; (add-to-list 'load-path (expand-file-name "~/elisp"))
;; where ~/elisp is the directory you want to add 
;; (you don't need to do this for ~/.emacs.d - it's added by default).
;;
;; Add the following to your ~/.emacs startup file.
;;
;; (require 'search-number)

;;; History:

;;; Require


;;; Code:

(defvar search-number-expression-history nil
  "A history list for arguments that are Lisp expressions to evaluate.
Used by `search-forward-number' and `search-backward-number'.")

;;;###autoload
(defun search-forward-number (pred &optional bound noerror count)
  "Search forward for number which satisfies predicate PRED.
PRED should be a function which takes a single number as argument, and returns non-nil
if the number is of the required type. When called interactively a form is prompted for
which will be turned into a function to use for PRED. In this form `number' is the current
number being checked.
The other arguments (BOUND, NOERROR and COUNT) are the same as `search-forward'."
  (interactive (list (let* ((minibuffer-completing-symbol t)
			    (default-value (car search-number-expression-history))
			    (sexp (minibuffer-with-setup-hook
				      (lambda ()
					(add-hook 'completion-at-point-functions
						  #'lisp-completion-at-point nil t)
					(run-hooks 'eval-expression-minibuffer-setup-hook))
				    (read-from-minibuffer (concat "Sexp to evaluate on 'number. Default is "
								  default-value ": ")
							  nil ;initial-contents
							  read-expression-map t
							  'search-number-expression-history
							  default-value))))
		       `(lambda (number) ,sexp))))
  (let ((pos t)
	(count (or count 1))
	(i 0))
    (while (and pos (< i count))
      (while (and (setq pos (search-forward-regexp "\\<[0-9]*\\.?[0-9]+\\>" bound t))
		  (not (funcall pred (string-to-number (match-string 0)))))
	(setq pos nil))
      (setq i (1+ i)))
    (or pos (if noerror nil (error "Number search failed")))))

;;;###autoload
(defun search-backward-number (pred &optional bound noerror count)
  "Search backward for number which satisfies predicate PRED.
PRED should be a function which takes a single number as argument, and returns non-nil
if the number is of the required type. When called interactively a form is prompted for
which will be turned into a function to use for PRED. In this form `number' is the current
number being checked.
The other arguments (BOUND, NOERROR and COUNT) are the same as `search-backward'."
  (interactive (list (let* ((minibuffer-completing-symbol t)
			    (default-value (car search-number-expression-history))
			    (sexp (minibuffer-with-setup-hook
				      (lambda ()
					(add-hook 'completion-at-point-functions
						  #'lisp-completion-at-point nil t)
					(run-hooks 'eval-expression-minibuffer-setup-hook))
				    (read-from-minibuffer (concat "Sexp to evaluate on 'number. Default is "
								  default-value ": ")
							  nil ;initial-contents
							  read-expression-map t
							  'search-number-expression-history
							  default-value))))
		       `(lambda (number) ,sexp))))
  (let ((pos t)
	(count (or count 1))
	(i 0))
    (while (and pos (< i count))
      (while (and (setq pos (search-backward-regexp "\\<[0-9]*\\.?[0-9]+\\>" bound t))
		  (not (funcall pred (string-to-number (match-string 0)))))
	(setq pos nil))
      (setq i (1+ i)))
    (or pos (if noerror nil (error "Number search failed")))))


(provide 'search-number)

;; (org-readme-sync)
;; (magit-push)

;;; search-number.el ends here
