;;; html-wysiwyg.el --- WYSIWYG elements for HTML editing

;; Copyright (C) 2018 defanor

;; Author: defanor <defanor@uberspace.net>
;; Maintainer: defanor <defanor@uberspace.net>
;; Created: 2018-04-24
;; Keywords: WYSIWYG, HTML
;; Homepage: https://github.com/defanor/html-wysiwyg
;; Version: 0.1.0

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Inspired by org-mode's link handling, but parsing HTML with regexps
;; like there's no tomorrow.

;;; Code:

(require 'thingatpt)

(define-minor-mode html-wysiwyg-mode
  "A minor mode for partial WYSIWYG editing of HTML, akin to
  org."
  :keymap `((,(kbd "C-c , e") . html-wysiwyg-edit-link-at-point))
  (if html-wysiwyg-mode
      ;; Enabled
      (progn
        (add-to-list 'font-lock-extra-managed-props 'invisible)
        (add-to-list 'font-lock-extra-managed-props 'help-echo)
        (html-wysiwyg-hide-links))
    ;; Disabled
    (html-wysiwyg-show-links)))

(defvar html-wysiwyg-link-match
  (rx (group "<a" (+? (not (any "<" ">"))) "href=" (syntax string-quote))
      (group (*? (not (syntax string-quote))))
      (group (syntax string-quote) (*? (not (any ">"))) ">")
      (group (+? (not (any "<" ">"))))
      (group "</a>"))
  "A regular expression used to match <a> elements.")

(defvar html-wysiwyg-font-lock-keywords
  `((,html-wysiwyg-link-match
     0
     (progn (add-text-properties (match-beginning 0)
                                 (match-end 0) '(invisible t))
            'default)
     t)
    (,html-wysiwyg-link-match
     4
     (progn
       (add-text-properties
        (match-beginning 4) (match-end 4)
        `(invisible
          nil
          help-echo
          ,(buffer-substring-no-properties
            (match-beginning 2) (match-end 2))))
       'link)
     t))
  "Keywords for font lock mode.")

(defun html-wysiwyg-hide-links ()
  "Hide <a> tags."
  (interactive)
  (font-lock-add-keywords nil html-wysiwyg-font-lock-keywords)
  (font-lock-fontify-buffer))

(defun html-wysiwyg-show-links ()
  "Make <a> tags visible again."
  (interactive)
  (font-lock-remove-keywords nil html-wysiwyg-font-lock-keywords)
  (font-lock-fontify-buffer))

(defun html-wysiwyg-edit-link-at-point ()
  "Edit an <a> element's @href attribute."
  (interactive)
  (save-excursion
    (if (thing-at-point-looking-at html-wysiwyg-link-match)
        (let* ((start (match-beginning 2))
               (end (match-end 2))
               (href (buffer-substring-no-properties start end))
               (new-href (read-from-minibuffer "href: " href)))
          (delete-region start end)
          (goto-char start)
          (insert new-href))
      (message "No link at point."))))

(provide 'html-wysiwyg)
;;; html-wysiwyg.el ends here
