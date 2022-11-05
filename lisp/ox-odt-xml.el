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

(defvar org-odt-styles-file-as-lisp
  (org-odt-xml-parse
   (expand-file-name "OrgOdtStyles.xml" org-odt-styles-dir)
   'remove-xmlns-attributes))

(defvar styles-tree org-odt-styles-file-as-lisp)

(defvar org-odt-content-template-file-as-lisp
  (org-odt-xml-parse
   (expand-file-name "OrgOdtContentTemplate.xml" org-odt-styles-dir)
   'remove-xmlns-attributes))

(defvar org-odf1.2-os-schema-as-rng
  (org-odt-xml-parse
   (expand-file-name "odf1.2/OpenDocument-v1.2-os-schema.rng" org-odt-schema-dir)))

(setq rng org-odf1.2-os-schema-as-rng)

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

;; (org-odt-xml-properties-type 'style:graphic-properties org-odt-styles-file-as-lisp)

;; (org-odt-xml-contents-type 'style:graphic-properties styles-tree)

;; (org-odt-xml-containers-type 'style:graphic-properties styles-tree)

(defun org-odt-define-struct-property-attributes (property default-value default-value-for-sample-usage tree)
  (let* ((props (->> tree
		     (org-odt-xml-properties-type property)
		     (-map 'car)))
	 (props1 (org-odt-xml--destructure-props props))
         (struct-type (intern (format "odt-%s-attributes" property)))
	 (constructor (intern (format "odt-make-%s-attributes" property))))
    ;; (message "props1: %S" props1)
    (eval
     `(progn
	(cl-defstruct
	    (
	     ,struct-type
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
	;; (put ',constructor 'function-documentation
	;;      ,(with-temp-buffer
	;; 	(emacs-lisp-mode)
	;; 	(pop-to-buffer (current-buffer))
	;; 	(insert (pp-to-string
	;; 		 `(,constructor
	;; 		   ,@(->> default-value-for-sample-usage
	;; 			  (--keep (list (intern (format ":%s" (alist-get (car it) props1)))
	;; 					(cdr it)))
	;; 			  (-flatten-n 1)))))
	;; 	(goto-char (point-min))
	;; 	(when (re-search-forward " " nil t)
	;; 	  (while (re-search-forward ":" nil t)
	;; 	    (save-excursion
	;; 	      (goto-char (1- (match-beginning 0)))
	;; 	      (newline))
	;; 	    (inspect "test")))
	;; 	(indent-region (point-min) (point-max))
	;; 	(buffer-substring-no-properties (point-min) (point-max))))
        ))))

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

(defun org-odt-xml-properties-type-new (types xml)
  (unless (consp types)
    (setq types (list types)))
  (->> xml
       (org-odt-xml-map (lambda (n)
			  (when (memq (org-odt-xml-type n) types)
			    (->> (org-odt-xml-properties n)
				 (-map #'org-odt-xml-type)))))
       (-flatten-n 1)
       -uniq
       (org-odt-xml-sort< #'identity)))

(org-odt-xml-properties-type-new 'style:style styles-tree)

(defun org-odt-xml-container-type (type xml)
  (->> xml
       (org-odt-xml-map (lambda (n)
			  (when-let ((ntype (org-odt-xml-node-p n)))
			    (cl-loop for x in (org-odt-xml-contents n)
				     when (eq (org-odt-xml-type x) type)
				     return ntype))))
       -uniq))

(defun test (types xml)
  (unless (consp types)
    (setq types (list types)))
  (->> xml
       (org-odt-xml-map
	(lambda (n)
	  (when (and (memq (org-odt-xml-type n) types)
		     ;; (string= (org-odt-xml-property n 'family) "paragraph")
		     )
	    (when (cl-some #'atom (org-odt-xml-contents n))
	      n))))))

(test 'style:style styles-tree)

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
   :properties-types (org-odt-xml-properties-type-new type styles-tree)
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

;; (org-odt-define-struct-property-attributes 'style:style
;; 					   nil
;; 					   (org-odt-xml-properties (org-odt-get-style-definition styles-tree "Text_20_body"))
;; 					   styles-tree)

;; (org-odt-xml-glimpse 'style:style styles-tree)

;; (defun org-odt-xml-ok-to-abbreviate )

(defun transform (xml)
  (cond
   ;; ((eq 'define (org-odt-xml-type xml))
   ;;  (set  (intern (org-odt-xml-property xml 'name))
   ;;        (transform (org-odt-xml-contents xml))))
   ;; ((eq 'attribute (org-odt-xml-type xml))
   ;;  (intern (format ":%s" (org-odt-xml-property xml 'name) ))
   ;;  ;; (cond
   ;;  ;;  ((member  data-types)
   ;;  ;;   nil)
   ;;  ;;  (t
   ;;  ;;   xml))
   ;;  ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
   ;;  )
   ((eq 'value (org-odt-xml-type xml))
    nil
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )

   ((and (eq 'ref (org-odt-xml-type xml))
	 (member (org-odt-xml-property xml 'name) data-types))
    nil
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )
   ((eq 'ref (org-odt-xml-type xml))
    (cl-assert (null (org-odt-xml-contents xml)))
    (intern (format ":!%s" (org-odt-xml-property xml 'name)))
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )
   ;; ((eq 'element (org-odt-xml-type xml))
   ;;  `(,(intern (format "%s" (org-odt-xml-property xml 'name)))
   ;;          ,@(delq nil (transform (org-odt-xml-contents xml))))
   ;;  ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
   ;;  )
   ;; ((eq 'optional (org-odt-xml-type xml))
   ;;  (transform (org-odt-xml-contents xml)) )
   ;; ((eq 'eval (org-odt-xml-type xml))
   ;;  (eval (nth 1 xml)))
   ;; ((eq 'value (org-odt-xml-type xml))
   ;;  ;; (transform (org-odt-xml-contents xml))
   ;;  nil)

   ((eq 'data (org-odt-xml-type xml))
    nil
    ;; (transform (org-odt-xml-contents xml))
    )
   ((eq 'choice (org-odt-xml-type xml))
    (delq nil (transform (org-odt-xml-contents xml)))

    ;; (transform (org-odt-xml-contents xml))
    )
   ((and (eq 'define (org-odt-xml-type xml))
	 (eq 'data (org-odt-xml-type (car (org-odt-xml-contents xml)))))
    nil
    ;; (transform (org-odt-xml-contents xml))
    )
   ((eq 'group (org-odt-xml-type xml))
    (transform (org-odt-xml-contents xml)))
   ((eq 'optional (org-odt-xml-type xml))
    (transform (org-odt-xml-contents xml)))
   ((eq 'zeroOrMore (org-odt-xml-type xml))
    (transform (org-odt-xml-contents xml)))
   ((eq 'oneOrMore (org-odt-xml-type xml))
    (transform (org-odt-xml-contents xml)))
   ((eq 'interleave (org-odt-xml-type xml))
    (transform (org-odt-xml-contents xml)))
   ((eq 'attribute (org-odt-xml-type xml))
    (intern (format ":%s" (org-odt-xml-property xml 'name))))
   ;; ((eq 'element (org-odt-xml-type xml))
   ;;  (list (intern (format "%s" (org-odt-xml-property xml 'name)))
   ;;        (transform (org-odt-xml-contents xml))))
   ;; ((eq 'value (org-odt-xml-type xml))
   ;;  `(value ,(car (org-odt-xml-contents xml))))
   ((org-odt-xml-node-p xml)
    `(
      ,(nth 0 xml)
      ,(nth 1 xml)
      ,@(delq nil (transform (org-odt-xml-contents xml)))))
   ((consp xml)
    (mapcar #'transform xml))
   (t xml)))

(defun collect-data-types (xml)
  (->> xml
       (org-odt-xml-map
	(lambda (n)
	  (when (and (eq 'define (org-odt-xml-type n ))
                     (eq 'data (org-odt-xml-type (car (org-odt-xml-contents n)))))
	    (org-odt-xml-property n 'name))))))

;; (setq data-types
;;       (collect-data-types rng))

;; ("CURIE" "ID" "IDREF" "IDREFS" "NCName" "SafeCURIE" "angle" "anyIRI"
;;  "anyURI" "base64Binary" "cellAddress" "cellRangeAddressList"
;;  "character" "clipShape" "color" "countryCode" "date" "dateTime"
;;  "double" "duration" "extrusionOrigin" "integer" "language"
;;  "languageCode" "length" "namespacedToken" "nonNegativeDecimal"
;;  "nonNegativeInteger" "nonNegativeLength" "nonNegativePixelLength"
;;  "pathData" "percent" "point3D" "points" "positiveInteger"
;;  "positiveLength" "relativeLength" "scriptCode"
;;  "signedZeroToHundredPercent" "string" "styleName" "textEncoding"
;;  "time" "variableName" "vector3D" "zeroToHundredPercent"
;;  "zeroToOneDecimal")

;; (setq x (transform rng))

;; (setq rng1 (transform rng))

(defun transform1 (xml)
  (cond
   ((org-odt-xml-node-p xml)
    `(
      ,(nth 0 xml)
      ,(nth 1 xml)
      ,@(delq nil (-flatten (org-odt-xml-contents xml)))))
   ;; ((consp xml)
   ;;  (mapcar #'transform xml))
   (t xml)))

;; (transform rng1)

(defun ox-odt-xml-dom-search (dom predicate)
  "Return elements in DOM where PREDICATE is non-nil.
PREDICATE is called with the node as its only parameter."
  (let ((matches (cl-loop for child in (dom-children dom)
			  for matches = (and (not (stringp child))
					     (ox-odt-xml-dom-search child predicate))
			  when matches
			  append matches)))
    (if (funcall predicate dom)
	(cons (funcall predicate dom) matches)
      matches)))

(defun ox-odt-xml-data-types (rng)
  (->> (ox-odt-xml-dom-search rng
		   (lambda (n)
		     (when (and (eq 'define (dom-tag n))
				(eq 'data (dom-tag (car (dom-children n)))))
		       (list
			(dom-attr n 'name)
			(apply #'append
			       (list :type (dom-attr (car (dom-children n)) 'type))
			       (ox-odt-xml-dom-search (car (dom-children n))
					   (lambda (n)
					     (when (eq (dom-tag n) 'param)
					       (list (intern (format ":%s" (dom-attr n 'name)))
						     (car (dom-children n)))
					       ;; n
					       )))))
		       ;; (dom-attr n 'name)
		       ;; (cons
		       ;;  )
		       )))
       ;; (-group-by #'car)
       ;; (--map (cons (car it)
       ;; 		  (->> (cdr it)
       ;; 		       (-map #'cdr)
       ;; 		       (-flatten-n 1)
       ;; 		       -uniq
       ;; 		       )
       ;; 		  ))
       ))

(defun ox-odt-xml-attribute-types (rng)
  (->> (ox-odt-xml-dom-search rng
		   (lambda (n)
		     (when (and (eq 'define (dom-tag n))
				;; (eq 'data (dom-tag (car (dom-children n))))
                                )
                       n
		       
		       ;; (dom-attr n 'name)
		       ;; (cons
		       ;;  )
		       )))
       ;; (-group-by #'car)
       ;; (--map (cons (car it)
       ;; 		  (->> (cdr it)
       ;; 		       (-map #'cdr)
       ;; 		       (-flatten-n 1)
       ;; 		       -uniq
       ;; 		       )
       ;; 		  ))
       ))

(ox-odt-xml-data-types rng)

(ox-odt-xml-attribute-types rng)


(defun odt-xml-get-element-name (name)
  (ox-odt-xml-dom-search rng (lambda (n)
			       (when (and (eq 'element (dom-tag n))
					  (string= name (dom-attr n 'name)))
				 n))))

(defun odt-xml-deref-ref-name (name)
  (let ((result (car (ox-odt-xml-dom-search rng (lambda (n)
						  (when (and (eq 'define (dom-tag n))
							     (string= name (dom-attr n 'name)))
						    n))))))
    result))

(defun odt-xml-ref-data-p (n)
  (when (and (eq 'ref (dom-tag n))
	     (not (eq (dom-tag (car (dom-children n))) 'data)))
    n))

(defun odt-xml-do-referenced-ref-names (n)
  (ox-odt-xml-dom-search n (lambda (n)
			     (when (eq 'ref (dom-tag n))
			       ;; (message "parents of %s" (dom-attr n 'name))
			       (let ((parents (odt-xml-dom-parents n)))
				 ;; (message "parents %S" parents)
				 (cond
				  ((cl-some (lambda (n)
					      (eq (dom-tag n) 'attribute))
					    parents)
				   nil)
				  (t
				   (dom-attr n 'name))))
			       ;; (pause "test")
			       ))))

(defun odt-xml-dom-parents (n)
  (let* ((this n)
	 (parent nil)
	 (parents '()))
    (while (setq parent (dom-parent rng this))
      (push parent parents)
      (setq this parent))
    parents))

(defun odt-xml-referenced-ref-names (ref-name)
  (delete-dups (odt-xml-do-referenced-ref-names (odt-xml-deref-ref-name ref-name))))

(defun odt-xml-ref-name->ref-names (ref-name)
  (let* ((done '())
	 (pending (if (consp ref-name)
		      ref-name
		    (list ref-name)))
	 (this nil)
	 (final '()))
    (while (setq this (pop pending))
      (push this done)
      (push (odt-xml-deref-ref-name this) final)
      (setq pending (cl-union pending
			      (cl-set-difference
			       (odt-xml-referenced-ref-names this) done)))
      ;; (message "\n\n\ndone:\n%S" done)
      ;; (message "\n\n\npending:\n%S" pending)
      )
    final))

(odt-xml-deref-ref-name "style-graphic-properties-content-strict")

(odt-xml-ref-name->ref-names "style-graphic-properties-content-strict")

(setq target (odt-xml-ref-name->ref-names (odt-xml-do-referenced-ref-names (odt-xml-get-element-name "style:graphic-properties")))) 

(defun odt-xml-rng->rnc (xml)
  (cond
   ((stringp xml)
    xml)
   ((eq 'value (org-odt-xml-type xml))
    (format "\"%s\""
	    (prog1 (car (dom-children xml))
	      (cl-assert (= 1 (length (dom-children xml)))
			 t
			 "type: %s" (org-odt-xml-type xml))))
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )
   
   ((eq 'choice (org-odt-xml-type xml))
    (mapconcat #'odt-xml-rng->rnc
	       (dom-children xml)
	       "\n| ")
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )
   ((eq 'attribute (org-odt-xml-type xml))
    (format "attribute %s {\n %s \n}"
	    (dom-attr xml 'name)
	    (prog1 (odt-xml-rng->rnc (car (dom-children xml)))
	      (cl-assert (= 1 (length (dom-children xml)))
			 t
			 "type: %s" (org-odt-xml-type xml))))
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )
   ((eq 'optional (org-odt-xml-type xml))
    (format "%s?"
	    (prog1 (odt-xml-rng->rnc (dom-children xml))
	      (cl-assert (= 1 (length (dom-children xml)))
			 t
			 "type: %s" (org-odt-xml-type xml))))
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )
   ((eq 'oneOrMore (org-odt-xml-type xml))
    (format "\n(\n%s\n)+\n"
	    (prog1 (odt-xml-rng->rnc (dom-children xml))
	      (cl-assert (= 1 (length (dom-children xml)))
			 t
			 "type: %s" (org-odt-xml-type xml))))
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )
   ((eq 'list (org-odt-xml-type xml))
    (format "list { %s }"
	    (mapconcat #'odt-xml-rng->rnc
		       (dom-children xml)
		       "\n, ")
	    ;; (prog1 (odt-xml-rng->rnc (dom-children xml))
	    ;;   (cl-assert (= 1 (length (dom-children xml)))
	    ;; 		 t
	    ;; 		 "type: %s" (org-odt-xml-type xml)))
	    )
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )
   ((eq 'define (org-odt-xml-type xml))
    (format "%s =\n%s"
	    (dom-attr xml 'name)
	    (mapconcat #'odt-xml-rng->rnc
	       (dom-children xml)
	       ",\n"))
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )
   ((eq 'ref (org-odt-xml-type xml))
    (dom-attr xml 'name)
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )
   ((eq 'interleave (org-odt-xml-type xml))
    (mapconcat #'odt-xml-rng->rnc
	       (dom-children xml)
	       "\n& ")
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )
   ((eq 'param (org-odt-xml-type xml))
    (format "%s = %s"
	    (dom-attr xml 'name)
	    (odt-xml-rng->rnc (dom-children xml)))
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )
   ((eq 'data (org-odt-xml-type xml))
    (format "xsd:%s = %s"
	    (dom-attr xml 'type)
	    (odt-xml-rng->rnc (dom-children xml)))
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )
   ((eq 'empty (org-odt-xml-type xml))
    (format "%s"
	    (org-odt-xml-type xml))
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )
   ((eq 'group (org-odt-xml-type xml))
    (format "(%s)"
	    (mapconcat #'odt-xml-rng->rnc
		       (dom-children xml)
		       "\n, ")
	    ;; (prog1 (odt-xml-rng->rnc (dom-children xml))
	    ;;   (cl-assert (= 1 (length (dom-children xml)))
	    ;; 		 t
	    ;; 		 "type: %s" (org-odt-xml-type xml)))
	    )
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )
   ((eq 'element (org-odt-xml-type xml))
    (format "element %s {\n%s\n}"
	    (dom-attr xml 'name)
	    (mapconcat #'odt-xml-rng->rnc
		       (dom-children xml)
		       ",\n "))
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )
   ((eq 'zeroOrMore (org-odt-xml-type xml))
    (format "%s*"
	    (prog1 (odt-xml-rng->rnc (dom-children xml))
	      (cl-assert (= 1 (length (dom-children xml)))
			 t
			 "type: %s" (org-odt-xml-type xml))))
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )
   ((eq 'comment (org-odt-xml-type xml))
    "\n"
    ;; (mapconcat #'odt-xml-rng->rnc
    ;; 	       (dom-children xml)
    ;; 	       "\n| ")
    ;; (intern (format "!%s" (org-odt-xml-property xml 'name)))
    )   
   ((org-odt-xml-type xml)
    (error "You aren't handling %S" (org-odt-xml-type xml)))
   (t
    (mapconcat #'odt-xml-rng->rnc
	       xml
	       ""))))

(with-current-buffer (get-buffer-create "*rnc*")
  (erase-buffer)
  (cl-loop for n in
	   target
	   ;; (dom-children rng)
	   
	   do (insert "\n\n" (odt-xml-rng->rnc n)))
  
  (pop-to-buffer (current-buffer))
  (rnc-mode)
  (indent-region (point-min) (point-max)))

(provide 'ox-odt-xml.el)
;;; ox-odt-xml.el.el ends here
