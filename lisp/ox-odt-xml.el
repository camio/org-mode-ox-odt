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

;; (cl-defstruct
;;     (person
;;      (:constructor nil)   ; no default constructor
;;      (:constructor new-person
;;                    (first-name sex &optional (age 0)))
;;      (:constructor new-hound (&key (first-name "Rover")
;;                                    (dog-years 0)
;;                               &aux (age (* 7 dog-years))
;;                                    (sex 'canine))))
;;     first-name age sex)

(defun test (property default-value default-value-for-sample-usage tree)
  (let* ((props (->> tree
		     (org-odt-xml-properties-type property)
		     (-map 'car)))
	 (props1 (org-odt-xml--destructure-props props))
	 (constructor (intern (format "org-odt-make-%s" property))))
    ;; (message "props1: %S" props1)
    `(progn
       (cl-defstruct
	   (
	    ,(intern (format "org-odt-%s" property))
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
	       (buffer-substring-no-properties (point-min) (point-max)))))))

;; (test 'style:style default-value default-value styles-tree)

 (test 'style:style
       nil
       (org-odt-xml-properties  (car (org-odt-get-style-definition styles-tree "Text_20_body")))
       styles-tree)

(progn
  (cl-defstruct
      (org-odt-style:style
       (:constructor org-odt-make-style:style
                     (&key
                      (name nil)
                      (family nil)
                      (class nil)
                      (parent-style-name nil)
                      (next-style-name nil)
                      (display-name nil)
                      (default-outline-level nil)
                      (list-style-name nil)
                      &aux
                      (style:name name)
                      (style:family family)
                      (style:class class)
                      (style:parent-style-name parent-style-name)
                      (style:next-style-name next-style-name)
                      (style:display-name display-name)
                      (style:default-outline-level default-outline-level)
                      (style:list-style-name list-style-name))))
    style:name style:family style:class style:parent-style-name style:next-style-name style:display-name style:default-outline-level style:list-style-name)
  (put 'org-odt-make-style:style 'function-documentation "(org-odt-make-style:style
 :name \"Text_20_body\"
 :display-name \"Text body\"
 :family \"paragraph\"
 :parent-style-name \"Standard\"
 :class \"text\")
"))


(setq x (org-odt-make-style:style))


(setq default-value
      (org-odt-xml-properties  (org-odt-get-style-definition styles-tree "Text_20_body"))
      )


;; (setq x (org-odt-make-style:style
;;          :name "Text_20_body"
;;          :display-name "Text body"
;;          :family "paragraph"
;;          :parent-style-name "Standard"
;;          :class "text"))

;; (cl-struct-slot-value 'cl-tag-slot)

(defun org-odt-struct-to-lisp (instance)
  (cl-loop with struct-name = (aref x 0)
	   for (slot-name _) in (cl-struct-slot-info struct-name)
	   unless (eq slot-name 'cl-tag-slot)
	   for val = (cl-struct-slot-value struct-name slot-name x)
	   when val
	   collect (cons slot-name val)))

;; (org-odt-struct-to-lisp x)

;; (org-odt-get-style-definition styles-tree "Text_20_body")

(defun org-odt-xml-map (f xml)
  (cl-letf ((compose (lambda (xml results)
		       (when (org-odt-xml-node-p xml)
			 (let ((val (funcall f xml)))
			   (if val (append (list val)
					   results)
			     results))))))
    (when xml
      (cond
       ;; ((stringp xml)
       ;;  nil)
       ;; ((null xml))
       ((consp xml)
	(funcall compose xml
		 (cl-loop for n in (org-odt-xml-contents xml)
			  for val = ;; (funcall f n)
			  (org-odt-xml-map f n)
			  ;; do (message "type: %s" (org-odt-xml-type n))
			  ;; do (message "val: %S" val)
			  when val
			  append val)))
       (t
	(funcall f xml))))))

;; (defun org-odt-xml-map (f1 xml)
;;   (org-odt-xml-map xml f1))

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

;; (org-odt-xml-container-type 'style:graphic-properties styles-tree)

;; (org-odt-xml-contents-type 'style:graphic-properties styles-tree)

(defun org-odt-xml-contents-type (types xml)
  (unless (consp types)
    (setq types (list types)))
  (->> xml
       (org-odt-xml-map
	(lambda (n)
	  (when (and (eq types (org-odt-xml-type n))
		     ;; (string= (org-odt-xml-property n 'family) "paragraph")
		     )
	    (->> (org-odt-xml-contents n)
		 (--map (if (atom it) 'LITERAL (car it)))))))
       (-flatten-n 1)
       -uniq
       (org-odt-xml-sort< #'identity)))

(defun org-odt-xml-compose (&rest args) args)

;; (cl-defun org-odt-build-graphic-properties (&key
;; 					    ;;  "as-char" "char" "page" "paragraph"
;; 					    anchor-type
;; 					    ;;  "center" "from-left" "right"
;; 					    horizontal-pos
;; 					    ;;  "page" "paragraph" "paragraph-content"
;; 					    horizontal-rel
;; 					    ;;  "bottom" "from-top" "middle" "top"
;; 					    vertical-pos
;; 					    ;;  "baseline" "page" "paragraph" "paragraph-content" "text"
;; 					    vertical-rel
;; 					    (x "0cm")
;; 					    (y "0cm")
;; 					    min-height
;; 					    rel-width
;; 					    width
;; 					    flow-with-text
;; 					    wrap
;; 					    wrap-influence-on-position
;; 					    number-wrapped-paragraphs
;; 					    wrap-contour
;; 					    margin-bottom
;; 					    margin-left
;; 					    margin-right
;; 					    margin-top
;; 					    (padding "0cm")
;; 					    (border "none")
;; 					    (shadow-opacity "100%")
;; 					    (shadow "none")
;; 					    background-color
;; 					    fill
;; 					    fill-color
;; 					    opacity
;; 					    background-transparency
;; 					    run-through)
;;   `(style:graphic-properties
;;     ((
;;       (text:anchor-type ,anchor-type)
;;       (style:horizontal-pos ,horizontal-pos)
;;       (style:horizontal-rel ,horizontal-rel)
;;       (style:vertical-pos ,vertical-pos)
;;       (style:vertical-rel ,vertical-rel)
;;       (svg:x ,x)
;;       (svg:y ,y)
;;       ;;  "0.499cm" "0cm"
;;       ,@(when min-height
;; 	  `((fo:min-height ,min-height)))
;;       ;;  "100%"
;;       ,@(when rel-width
;; 	  `((style:rel-width ,rel-width)))
;;       ;;  "0cm" "2cm"
;;       ,@(when width
;; 	  `((svg:width ,width)))
;;       ;;  "true"
;;       ,@(when flow-with-text
;; 	  `((style:flow-with-text ,flow-with-text)))
;;       ;;  "none" "parallel" "run-through"
;;       ,@(when wrap
;; 	  `((style:wrap ,wrap)))
;;       ;;  "once-concurrent"
;;       ,@(when wrap-influence-on-position
;; 	  `((draw:wrap-influence-on-position ,wrap-influence-on-position)))
;;       ;;  "1" "no-limit"
;;       ,@(when number-wrapped-paragraphs
;; 	  `((style:number-wrapped-paragraphs ,number-wrapped-paragraphs)))
;;       ;;  "false"
;;       ,@(when wrap-contour
;; 	  `((style:wrap-contour ,wrap-contour)))
;;       ,@(when margin-bottom
;; 	  `((fo:margin-bottom ,margin-bottom)))
;;       ,@(when margin-left
;; 	  `((fo:margin-left ,margin-left)))
;;       ,@(when margin-right
;; 	  `((fo:margin-right ,margin-right)))
;;       ,@(when margin-top
;; 	  `((fo:margin-top ,margin-top)))
;;       ,@(when padding
;; 	  `((fo:padding ,padding)))
;;       ;;  "0.06pt solid #000000" "0.26pt solid #000000" "none"
;;       ,@(when border
;; 	  `((fo:border ,border)))
;;       ;;  "100%"
;;       ,@(when shadow-opacity
;; 	  `((draw:shadow-opacity ,shadow-opacity)))
;;       ;;  "none"
;;       ,@(when shadow
;; 	  `((style:shadow ,shadow)))
;;       ;;  "#ffffcc" "transparent"
;;       ,@(when background-color
;; 	  `((fo:background-color ,background-color)))
;;       ;;  "none" "solid"
;;       ,@(when fill
;; 	  `((draw:fill ,fill)))
;;       ;;  "#729fcf" "#ffffcc"
;;       ,@(when fill-color
;; 	  `((draw:fill-color ,fill-color)))
;;       ;;  "100%"
;;       ,@(when opacity
;; 	  `((draw:opacity ,opacity)))
;;       ;;  "0%"
;;       ,@(when background-transparency
;; 	  `((style:background-transparency ,background-transparency)))
;;       ;;  "foreground"
;;       ,@(when run-through
;; 	  `((style:run-through ,run-through)))))))

;; (cl-defun org-odt-build-margin-note (name &key parent-style-name)
;;   `(style:style
;;     ((style:name . ,name)
;;      (style:parent-style-name . ,parent-style-name)
;;      (style:family . "graphic"))
;;     ,(org-odt-build-graphic-properties
;;       :anchor-type "paragraph"
;;       :horizontal-pos "from-left"
;;       :horizontal-rel "page-start-margin"
;;       :vertical-pos "top"
;;       :vertical-rel "paragraph-content"
;;       :min-height "0.041cm"
;;       :width "3cm")))

;; (org-odt-xml-properties-type--ok-to-abbreviate tree 'style:graphic-properties)

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

;; (setq doc-tree
;;       (nreverse doc-tree))

;; (with-current-buffer (get-buffer-create "*org*")
;;   (org-mode)
;;   (erase-buffer)
;;   (pop-to-buffer (current-buffer))
;;   (call-interactively 'set-mark-command)
;;   (insert
;;    (->> contents-tree
;; 	org-odt-xml-transcode))
;;   (call-interactively 'org-fill-paragraph)
;;   (call-interactively 'set-mark-command))

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

;; (cl-intersection defined-char-styles applied-styles :test #'string=)

;; ("url" "menu" "italic" "gras" "code_5f_par" "code_5f_em")

;; (regexp-opt '("url" "menu" "italic" "gras" "code_5f_par" "code_5f_em"))

;; (defun compose (xml results)
;;   (when (org-odt-xml-node-p xml)
;;     (append (list (org-odt-xml-map xml))
;; 	    results)))

;; (->> styles-tree
;;      (org-odt-xml-map
;;       (lambda (n)
;;         (when (eq (org-odt-xml-type n) 'style:style)
;;           n))))

;; (defclass my-baseclass ()
;;   ((value)
;;    (reference))
;;   "My Baseclass.")

;; (my-baseclass :value 3 :reference nil)

;; (my-class :value 3 :reference nil)

;; (defclass person ()			; No superclasses
;;   ((name :initarg :name
;; 	 :initform ""
;; 	 :type string
;; 	 :custom string
;; 	 :documentation "The name of a person.")
;;    (birthday :initarg :birthday
;; 	     :initform "Jan 1, 1970"
;; 	     :custom string
;; 	     :type string
;; 	     :documentation "The person's birthday.")
;;    (phone :initarg :phone
;; 	  :initform ""
;; 	  :documentation "Phone number."))
;;   "A class for tracking people I know.")

;; (setq pers (person :name "Eric" :birthday "June" :phone "555-5555"))

;; (cl-struct-slot-value 'person 'first-name dave)

;; (cl-struct-slot-info person)

;; (cl-defstruct person first-name age sex)

;; (setq dave (make-person :first-name "Dave" :sex 'male))

;; (my-with-slots person (first-ame age sex) dave

;;   (message "name %s" first-name)
;;   (message "birthday %s" age))

(eval-when-compile
  (defun org-odt-xml--destructure-props (props)
    (cl-loop for prop in props
	     for prop-name = (symbol-name prop)
	     for (_prefix rest) = (split-string prop-name ":")
	     for suffix = (intern rest)
	     collect (cons prop suffix)))
  ;; (defun org-odt--bbody (props)
  ;;   `(apply #'append
  ;;           ,@(cl-loop for prop in props
  ;;       	       for prop-name = (symbol-name prop)
  ;;       	       do (message "prop: %S " prop)
  ;;       	       for (_prefix rest) = (split-string prop-name ":")
  ;;       	       for arg = (intern rest)
  ;;       	       collect `(when ,arg
  ;;       			  (list (cons ',prop ,arg))))))
  (defun org-odt-xml--bbody-1 (props)
    `(append
      ,@(cl-loop for (prop . suffix) in (org-odt-xml--destructure-props props)
		 collect `(when ,suffix
			    (list (cons ',prop ,suffix))))))
  ;; (defun org-odt--bargs (props)
  ;;   (cl-loop for prop in props
  ;;            for prop-name = (symbol-name prop)
  ;;            do (message "prop: %S " prop)
  ;;            for (_prefix rest) = (split-string prop-name ":")
  ;;            for arg = (intern rest)
  ;;            collect arg))
  (defun org-odt-xml--bargs-1 (props)
    (cl-loop for (_prop . suffix) in (org-odt-xml--destructure-props props)
	     collect suffix)))

(defmacro org-odt-xml-builder (s &rest props)
  (declare (indent 1) (debug t))
  `(cl-defun ,s (&key ,@(org-odt-xml--bargs-1 props))
     ,(org-odt-xml--bbody-1 props)))

;; (cl-defstruct org-odt-graphic-properties
;;   draw:fill draw:fill-color draw:opacity draw:shadow-opacity
;;   draw:wrap-influence-on-position fo:background-color fo:border
;;   fo:margin-bottom fo:margin-left fo:margin-right fo:margin-top
;;   fo:min-height fo:padding style:background-transparency
;;   style:flow-with-text style:horizontal-pos style:horizontal-rel
;;   style:number-wrapped-paragraphs style:rel-width
;;   style:run-through style:shadow style:vertical-pos
;;   style:vertical-rel style:wrap style:wrap-contour svg:width svg:x
;;   svg:y text:anchor-type)

;; (cl-struct-slot-info 'org-odt-graphic-properties)

(eval-when-compile
  (org-odt-xml-builder org-odt-build-graphic-properties
    draw:fill draw:fill-color draw:opacity draw:shadow-opacity
    draw:wrap-influence-on-position fo:background-color fo:border
    fo:margin-bottom fo:margin-left fo:margin-right fo:margin-top
    fo:min-height fo:padding style:background-transparency
    style:flow-with-text style:horizontal-pos style:horizontal-rel
    style:number-wrapped-paragraphs style:rel-width
    style:run-through style:shadow style:vertical-pos
    style:vertical-rel style:wrap style:wrap-contour svg:width svg:x
    svg:y text:anchor-type)

  (org-odt-xml-builder org-odt-build-style
    style:name style:parent-style-name style:family))

(cl-defun org-odt-define-graphics-style (&key style-properties graphic-properties)
  (org-odt-xml-compose
   'style:style
   nil
   (apply 'org-odt-build-style style-properties)
   (org-odt-xml-compose 'style:graphic-properties
			(apply #'org-odt-build-graphic-properties
			       graphic-properties))))

;; (org-odt-define-graphics-style
;;  :style-properties
;;  '(:name "OrgMarginNote"
;; 	 :parent-style-name "Frame"
;; 	 :family "graphic")
;;  :graphic-properties
;;  '(:shadow-opacity "100%"
;; 		   :border "none"
;; 		   :min-height "0.041cm"
;; 		   :padding "0cm"
;; 		   :horizontal-pos "from-left"
;; 		   :horizontal-rel "page-start-margin"
;; 		   :shadow "none"
;; 		   :vertical-pos "top"
;; 		   :vertical-rel "paragraph-content"
;; 		   :width "3cm"
;; 		   :x "0cm"
;; 		   :y "0cm"
;; 		   :anchor-type "paragraph"))

;; (org-odt-define-graphics-style
;;  :style-properties
;;  '(:name "OrgMarginNote"
;; 	 :parent-style-name "Frame"
;; 	 :family "graphic")
;;  :graphic-properties
;;  '(:shadow-opacity "100%"
;; 		   :border "none"
;; 		   :min-height "0.041cm"
;; 		   :padding "0cm"
;; 		   :horizontal-pos "from-left"
;; 		   :horizontal-rel "page-start-margin"
;; 		   :shadow "none"
;; 		   :vertical-pos "top"
;; 		   :vertical-rel "paragraph-content"
;; 		   :width "3cm"
;; 		   :x "0cm"
;; 		   :y "0cm"
;; 		   :anchor-type "paragraph"))

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

(provide 'ox-odt-xml.el)
;;; ox-odt-xml.el.el ends here
