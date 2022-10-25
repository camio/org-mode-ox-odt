;;;; ox-odt-xml.el --- Ox Odt Xml.El -*- lexical-binding: t; coding: utf-8-emacs; -*-

;; Copyright (C) 2022  Jambuanthan K

;; Author: Jambunathan K <kjambunathan@gmail.com>
;; Version:
;; Homepage: https://github.com/kjambunathan/dotemacs
;; Keywords:
;; Package-Requires: ((emacs "24"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(defun org-odt-xml-parse (file-name &optional remove-xmlns-attributes)
  (with-temp-buffer
    (insert-file-contents file-name)
    (when remove-xmlns-attributes
      (goto-char (point-min))
      (when (re-search-forward (rx "<office:document-styles") nil t)
	(delete-region (match-beginning 0)
		       (save-excursion
			 (goto-char (match-beginning 0))
			 (xmltok-forward)
			 (point)))
	(insert "<office:document-styles>"))
      (goto-char (point-min))
      (when (re-search-forward (rx "<office:document-content") nil t)
	(delete-region (match-beginning 0)
		       (save-excursion
			 (goto-char (match-beginning 0))
			 (xmltok-forward)
			 (point)))
	(insert "<office:document-content>")))
    (org-odt--xml-to-lisp (buffer-substring-no-properties (point-min) (point-max)))))

(defvar org-odt-styles-file-as-xml
  (org-odt-xml-parse
   (expand-file-name "OrgOdtStyles.xml" org-odt-styles-dir)
   'remove-xmlns-attributes))

(defvar styles-tree org-odt-styles-file-as-xml)

(defvar org-odt-content-template-file-as-xml
  (org-odt-xml-parse
   (expand-file-name "OrgOdtContentTemplate.xml" org-odt-styles-dir)
   'remove-xmlns-attributes))

;; (defvar contents-tree
;;   (org-odt-xml-parse "~/Downloads/gnulinuxmagazine/xml/content-full.xml"))

;; (defvar abbr-contents-tree
;;   (org-odt-xml-parse "~/Downloads/gnulinuxmagazine/xml/content.xml"))

(defun org-odt-xml-type (xml)
  (when-let ((first (car-safe xml))
	     ((symbolp first)))
    first))

(defun org-odt-xml-properties (xml)
  (when (org-odt-xml-node-p xml)
    (cadr xml)))

(defun org-odt-xml-property (xml property)
  (cdr (assq property
	     (org-odt-xml-properties xml))))

(defun org-odt-xml-contents (node)
  (cddr node))

(defalias 'org-odt-xml-node-p
  'org-odt-xml-type)

(defun org-odt-xml-sort< (valuemapper list)
  (let ((an-item (funcall valuemapper (car list))))
    (->> list
	 (-sort (-on (cond ((numberp an-item) '<)
			   (t 'string<))
		     (-compose
		      (lambda (an-item)
			(cond
			 ((or (stringp an-item)
			      (numberp an-item))
			  an-item)
			 (t (format "%S" an-item))))
		      valuemapper))))))

;; (org-odt-xml-properties-type 'style:graphic-properties org-odt-styles-file-as-xml)

;; (org-odt-xml-contents-type 'style:graphic-properties styles-tree)

;; (org-odt-xml-containers-type 'style:graphic-properties styles-tree)

(defun test (property default-value default-value-for-sample-usage tree)
  (let* ((props (->> tree
		     (org-odt-xml-properties-type property)
		     (-map 'car)))
	 (props1 (org-odt-xml--destructure-props props))
	 (constructor (intern (replace-regexp-in-string
			       ":" "-" (format "odt-make-%s" property) t t))))
    ;; (message "props1: %S" props1)
    (eval
     `(progn
	(cl-defstruct
	    (
	     ,(intern (format "odt-struct-%s" property))
	     (:constructor ,constructor
			   (&key
			    ,@(->> props1
				   (--map
				    (list (cdr it)
					  (assoc-default (car it)
							 default-value))))
			    &aux
			    ,@(->> props1
				   (--map
				    (list (car it)
					  (cdr it)))))))
	  ,@props)
	(put ',constructor 'function-documentation
	     ,(with-temp-buffer
		(emacs-lisp-mode)
		(pop-to-buffer (current-buffer))
		(insert (pp-to-string
			 `(,constructor
			   ,@(->> default-value-for-sample-usage
				  (--keep (list (intern (format ":%s" (alist-get (car it) props1)))
						(cdr it)))
				  (-flatten-n 1)))))
		(goto-char (point-min))
		(when (re-search-forward " " nil t)
		  (while (re-search-forward ":" nil t)
		    (save-excursion
		      (goto-char (1- (match-beginning 0)))
		      (newline))
		    (inspect "test")))
		(indent-region (point-min) (point-max))
		(buffer-substring-no-properties (point-min) (point-max))))))))

;; (test 'style:style default-value default-value styles-tree)

;; (cl-defstruct
;;     (person
;;      (:constructor nil)			; no default constructor
;;      (:constructor new-person
;; 		   (first-name sex &optional (age 0)))
;;      (:constructor new-hound (&key (first-name "Rover")
;; 				   (dog-years 0)
;; 				   &aux (age (* 7 dog-years))
;; 				   (sex 'canine))))
;;   first-name age sex)

;; (setq y (new-hound))

(defun org-odt-struct-to-lisp (instance)
  (cl-loop with struct-name = (aref instance 0)
	   for (slot-name _) in (cl-struct-slot-info struct-name)
	   unless (eq slot-name 'cl-tag-slot)
	   for val = (cl-struct-slot-value struct-name slot-name instance)
	   when val
	   collect (cons slot-name val)))

(defun org-odt-xml--map (f composef xml)
  (when xml
    (cond
     ;; ((stringp xml)
     ;;  nil)
     ;; ((null xml))
     ((consp xml)
      (funcall composef xml
	       (cl-loop for n in (org-odt-xml-contents xml)
			for val = ;; (funcall f n)
			(org-odt-xml--map f composef n)
			;; do (message "type: %s" (org-odt-xml-type n))
			;; do (message "val: %S" val)
			when val
			append val)))
     (t
      (funcall f xml)))))

(defun org-odt-xml-map (f xml)
  (org-odt-xml--map f (lambda (xml results)
			(when (org-odt-xml-node-p xml)
			  (let ((val (funcall f xml)))
			    (if val (append (list val)
					    results)
			      results))))
		    xml))

(defun org-odt-xml-properties-type (types xml)
  (unless (consp types)
    (setq types (list types)))
  (->> xml
       (org-odt-xml-map (lambda (n)
			  (when (memq (org-odt-xml-type n) types)
			    (->> (org-odt-xml-properties n)
				 (--map (cons
					 (org-odt-xml-type it)
					 (if (stringp (cdr it))
					     (cdr it)
					   'NESTED)))))))
       (-flatten-n 1)
       (-group-by 'car)
       (--map (cons
	       (car it)
	       (->> (cdr it)
		    (-map 'cdr)
		    -uniq
		    (org-odt-xml-sort< 'identity))))))

(defun org-odt-xml-container-type (type xml)
  (->> xml
       (org-odt-xml-map (lambda (n)
			  (when-let ((ntype (org-odt-xml-node-p n)))
			    (cl-loop for x in (org-odt-xml-contents n)
				     when (eq (org-odt-xml-type x) type)
				     return ntype))))
       -uniq))

(defun org-odt-xml-contents-type (types xml)
  (unless (consp types)
    (setq types (list types)))
  (->> xml
       (org-odt-xml-map
	(lambda (n)
	  (when (and (memq (org-odt-xml-type n) types)
		     ;; (string= (org-odt-xml-property n 'family) "paragraph")
		     )
	    (->> (org-odt-xml-contents n)
		 (--map (if (atom it) 'LITERAL (car it))))
	    ;; n
	    )))
       (-flatten-n 1)
       -uniq
       (org-odt-xml-sort< #'identity)))

(defun org-odt-xml-glimpse (type styles-tree)
  (list
   :parent-types (org-odt-xml-container-type type styles-tree)
   :properties-types (org-odt-xml-properties-type type styles-tree)
   :contents-types
   (org-odt-xml-contents-type type styles-tree)))

(defun org-odt-xml-compose (&rest args) args)

(defun org-odt-get-style-names (tree)
  (->> tree
       (org-odt-xml-map
	(lambda (n)
	  (when-let ((style-name (org-odt-xml-property n 'style:name)))
	    (cons (org-odt-xml-property n 'style:family) style-name))))
       ;; -uniq
       ;; (org-odt-xml-sort< #'identity)
       ;; length
       ))

(defun org-odt-get-style-definitions (tree)
  (->> tree
       (org-odt-xml-map
	(lambda (n)
	  ;; (message "node-type: %S" (org-odt-xml-node-p n))
	  (when-let (((org-odt-xml-node-p n))
		     (style-name (org-odt-xml-property n 'style:name)))
	    (list :style-name style-name :node-type (org-odt-xml-type n) :node n))))))

(defun org-odt-get-style-definition (tree style-name)
  (->> tree
       (org-odt-xml-map
	(lambda (n)
	  ;; (message "node-type: %S" (org-odt-xml-node-p n))
	  (when-let (((org-odt-xml-node-p n))
		     ((string= style-name (or (org-odt-xml-property n 'style:name) ""))))
	    n)))
       car))

;; (org-odt-get-style-definition styles-tree "Text_20_body")

(defun org-odt-get-char-style-definitions (tree)
  (->> tree
       (org-odt-xml-map
	(lambda (n)
	  (when-let ((style-name (org-odt-xml-property n 'style:name))
		     (style-family (org-odt-xml-property n 'style:family))
		     ((string= style-family "text")))
	    style-name)))))

(defun to-string (xml contents)
  (cl-assert (stringp contents))
  (message "\n\n\n[%s] %S" (org-odt-xml-node-p xml) contents)
  (pcase (org-odt-xml-node-p xml)
    (`text:p
     (format "\n\n#+ATTR_ODT: :style \"%s\"\n%s"
	     (org-odt-xml-property xml 'text:style-name)
	     contents))
    (`text:span
     ;; (format "[%s]%s[/%s]"
     ;;         (org-odt-xml-property xml 'text:style-name)
     ;;         contents
     ;;         (org-odt-xml-property xml 'text:style-name))
     (format "*%s*"
	     ;; (org-odt-xml-property xml 'text:style-name)
	     contents
	     ;; (org-odt-xml-property xml 'text:style-name)
	     ))
    (_

     (message "Not handling %s" (org-odt-xml-node-p xml))
     contents)))

(defun org-odt-xml-transcode (xml)
  (when xml
    (cond
     ((stringp xml)
      xml)
     ((null xml)
      "")
     (t
      (to-string xml
		 (when (consp xml)
		   (mapconcat 'org-odt-xml-transcode
			      (org-odt-xml-contents xml)
			      "")))))))

(defun org-odt-xml->org (&optional file-name)
  (setq file-name (or file-name
		      "~/Downloads/gnulinuxmagazine/xml/content-full.xml"))
  (with-current-buffer (get-buffer-create "*org*")
    (org-mode)
    (erase-buffer)
    (pop-to-buffer (current-buffer))
    (call-interactively 'set-mark-command)
    (insert
     (->> file-name
	  org-odt-xml-parse
	  org-odt-xml-transcode))
    (call-interactively 'org-fill-paragraph)
    (call-interactively 'set-mark-command)))

(defun org-odt-xml-applied-styles (xml)
  (->> xml
       (org-odt-xml-map
	(lambda (n)
	  (when-let ((style-name (org-odt-xml-property n 'text:style-name)))
	    style-name)))))

;; (setq applied-styles (->> contents-tree
;;                            org-odt-xml-applied-styles
;;                            -uniq
;;                            (org-odt-xml-sort< 'identity)))

(defun org-odt-xml--destructure-props (props)
  (cl-loop for prop in props
	   for prop-name = (symbol-name prop)
	   for (_prefix rest) = (split-string prop-name ":")
	   for suffix = (intern rest)
	   collect (cons prop suffix)))

(defun org-odt-xml-properties-type--ok-to-abbreviate (tree _type)
  (let* ((x (->> tree
		 (org-odt-xml-properties-type tree)
		 (--map (symbol-name (car it)))
		 (--map (s-split ":" it))
		 ;; (--map (progn (cl-assert (= (length it) 2))
		 ;;               it))
		 )))
    (=
     (length x)
     (->> x
	  (-map 'cdr)
	  -uniq
	  length))))

(test 'style:style
      nil
      (org-odt-xml-properties (org-odt-get-style-definition styles-tree "Text_20_body"))
      styles-tree)

(provide 'ox-odt-xml.el)
;;; ox-odt-xml.el.el ends here
