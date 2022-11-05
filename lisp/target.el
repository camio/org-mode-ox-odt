((define
  ((name . "common-writing-mode-attlist"))
  (optional nil
	    (attribute
	     ((name . "style:writing-mode"))
	     (choice nil
		     (value nil "lr-tb")
		     (value nil "rl-tb")
		     (value nil "tb-rl")
		     (value nil "tb-lr")
		     (value nil "lr")
		     (value nil "rl")
		     (value nil "tb")
		     (value nil "page")))))
 (define
  ((name . "common-editable-attlist"))
  (optional nil
	    (attribute
	     ((name . "style:editable"))
	     (ref
	      ((name . "boolean"))))))
 (define
  ((name . "common-background-transparency-attlist"))
  (optional nil
	    (attribute
	     ((name . "style:background-transparency"))
	     (ref
	      ((name . "zeroToHundredPercent"))))))
 #3=(define
     ((name . "common-background-color-attlist"))
     (optional nil
	       (attribute
		((name . "fo:background-color"))
		(choice nil
			(value nil "transparent")
			(ref
			 ((name . "color")))))))
 (define
  ((name . "common-shadow-attlist"))
  (optional nil
	    (attribute
	     ((name . "style:shadow"))
	     (ref
	      ((name . "shadowType"))))))
 (define
  ((name . "common-padding-attlist"))
  (optional nil
	    (attribute
	     ((name . "fo:padding"))
	     (ref
	      ((name . "nonNegativeLength")))))
  (optional nil
	    (attribute
	     ((name . "fo:padding-top"))
	     (ref
	      ((name . "nonNegativeLength")))))
  (optional nil
	    (attribute
	     ((name . "fo:padding-bottom"))
	     (ref
	      ((name . "nonNegativeLength")))))
  (optional nil
	    (attribute
	     ((name . "fo:padding-left"))
	     (ref
	      ((name . "nonNegativeLength")))))
  (optional nil
	    (attribute
	     ((name . "fo:padding-right"))
	     (ref
	      ((name . "nonNegativeLength"))))))
 (define
  ((name . "common-border-line-width-attlist"))
  (optional nil
	    (attribute
	     ((name . "style:border-line-width"))
	     (ref
	      ((name . "borderWidths")))))
  (optional nil
	    (attribute
	     ((name . "style:border-line-width-top"))
	     (ref
	      ((name . "borderWidths")))))
  (optional nil
	    (attribute
	     ((name . "style:border-line-width-bottom"))
	     (ref
	      ((name . "borderWidths")))))
  (optional nil
	    (attribute
	     ((name . "style:border-line-width-left"))
	     (ref
	      ((name . "borderWidths")))))
  (optional nil
	    (attribute
	     ((name . "style:border-line-width-right"))
	     (ref
	      ((name . "borderWidths"))))))
 (define
  ((name . "common-border-attlist"))
  (optional nil
	    (attribute
	     ((name . "fo:border"))
	     (ref
	      ((name . "string")))))
  (optional nil
	    (attribute
	     ((name . "fo:border-top"))
	     (ref
	      ((name . "string")))))
  (optional nil
	    (attribute
	     ((name . "fo:border-bottom"))
	     (ref
	      ((name . "string")))))
  (optional nil
	    (attribute
	     ((name . "fo:border-left"))
	     (ref
	      ((name . "string")))))
  (optional nil
	    (attribute
	     ((name . "fo:border-right"))
	     (ref
	      ((name . "string"))))))
 (define
  ((name . "common-text-anchor-attlist"))
  (interleave nil
	      (optional nil
			(attribute
			 ((name . "text:anchor-type"))
			 (choice nil
				 (value nil "page")
				 (value nil "frame")
				 (value nil "paragraph")
				 (value nil "char")
				 (value nil "as-char"))))
	      (optional nil
			(attribute
			 ((name . "text:anchor-page-number"))
			 (ref
			  ((name . "positiveInteger")))))))
 #1=(define
     ((name . "common-vertical-rel-attlist"))
     (optional nil
	       (attribute
		((name . "style:vertical-rel"))
		(choice nil
			(value nil "page")
			(value nil "page-content")
			(value nil "frame")
			(value nil "frame-content")
			(value nil "paragraph")
			(value nil "paragraph-content")
			(value nil "char")
			(value nil "line")
			(value nil "baseline")
			(value nil "text")))))
 #2=(define
     ((name . "common-vertical-pos-attlist"))
     (optional nil
	       (attribute
		((name . "style:vertical-pos"))
		(choice nil
			(value nil "top")
			(value nil "middle")
			(value nil "bottom")
			(value nil "from-top")
			(value nil "below"))))
     (optional nil
	       (attribute
		((name . "svg:y"))
		(ref
		 ((name . "coordinate"))))))
 (define
  ((name . "common-margin-attlist"))
  (optional nil
	    (attribute
	     ((name . "fo:margin"))
	     (choice nil
		     (ref
		      ((name . "nonNegativeLength")))
		     (ref
		      ((name . "percent")))))))
 (define
  ((name . "common-vertical-margin-attlist"))
  (optional nil
	    (attribute
	     ((name . "fo:margin-top"))
	     (choice nil
		     (ref
		      ((name . "nonNegativeLength")))
		     (ref
		      ((name . "percent"))))))
  (optional nil
	    (attribute
	     ((name . "fo:margin-bottom"))
	     (choice nil
		     (ref
		      ((name . "nonNegativeLength")))
		     (ref
		      ((name . "percent")))))))
 (define
  ((name . "common-horizontal-margin-attlist"))
  (optional nil
	    (attribute
	     ((name . "fo:margin-left"))
	     (choice nil
		     (ref
		      ((name . "length")))
		     (ref
		      ((name . "percent"))))))
  (optional nil
	    (attribute
	     ((name . "fo:margin-right"))
	     (choice nil
		     (ref
		      ((name . "length")))
		     (ref
		      ((name . "percent")))))))
 (define
  ((name . "common-draw-size-attlist"))
  (optional nil
	    (attribute
	     ((name . "svg:width"))
	     (ref
	      ((name . "length")))))
  (optional nil
	    (attribute
	     ((name . "svg:height"))
	     (ref
	      ((name . "length"))))))
 (define
  ((name . "common-draw-rel-size-attlist"))
  (ref
   ((name . "common-draw-size-attlist")))
  (optional nil
	    (attribute
	     ((name . "style:rel-width"))
	     (choice nil
		     (ref
		      ((name . "percent")))
		     (value nil "scale")
		     (value nil "scale-min"))))
  (optional nil
	    (attribute
	     ((name . "style:rel-height"))
	     (choice nil
		     (ref
		      ((name . "percent")))
		     (value nil "scale")
		     (value nil "scale-min")))))
 (define
  ((name . "style-graphic-fill-properties-attlist"))
  (interleave nil
	      (optional nil
			(attribute
			 ((name . "draw:fill"))
			 (choice nil
				 (value nil "none")
				 (value nil "solid")
				 (value nil "bitmap")
				 (value nil "gradient")
				 (value nil "hatch"))))
	      (optional nil
			(attribute
			 ((name . "draw:fill-color"))
			 (ref
			  ((name . "color")))))
	      (optional nil
			(attribute
			 ((name . "draw:secondary-fill-color"))
			 (ref
			  ((name . "color")))))
	      (optional nil
			(attribute
			 ((name . "draw:fill-gradient-name"))
			 (ref
			  ((name . "styleNameRef")))))
	      (optional nil
			(attribute
			 ((name . "draw:gradient-step-count"))
			 (ref
			  ((name . "nonNegativeInteger")))))
	      (optional nil
			(attribute
			 ((name . "draw:fill-hatch-name"))
			 (ref
			  ((name . "styleNameRef")))))
	      (optional nil
			(attribute
			 ((name . "draw:fill-hatch-solid"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "draw:fill-image-name"))
			 (ref
			  ((name . "styleNameRef")))))
	      (optional nil
			(attribute
			 ((name . "style:repeat"))
			 (choice nil
				 (value nil "no-repeat")
				 (value nil "repeat")
				 (value nil "stretch"))))
	      (optional nil
			(attribute
			 ((name . "draw:fill-image-width"))
			 (choice nil
				 (ref
				  ((name . "length")))
				 (ref
				  ((name . "percent"))))))
	      (optional nil
			(attribute
			 ((name . "draw:fill-image-height"))
			 (choice nil
				 (ref
				  ((name . "length")))
				 (ref
				  ((name . "percent"))))))
	      (optional nil
			(attribute
			 ((name . "draw:fill-image-ref-point-x"))
			 (ref
			  ((name . "percent")))))
	      (optional nil
			(attribute
			 ((name . "draw:fill-image-ref-point-y"))
			 (ref
			  ((name . "percent")))))
	      (optional nil
			(attribute
			 ((name . "draw:fill-image-ref-point"))
			 (choice nil
				 (value nil "top-left")
				 (value nil "top")
				 (value nil "top-right")
				 (value nil "left")
				 (value nil "center")
				 (value nil "right")
				 (value nil "bottom-left")
				 (value nil "bottom")
				 (value nil "bottom-right"))))
	      (optional nil
			(attribute
			 ((name . "draw:tile-repeat-offset"))
			 (list nil
			       (ref
				((name . "zeroToHundredPercent")))
			       (choice nil
				       (value nil "horizontal")
				       (value nil "vertical")))))
	      (optional nil
			(attribute
			 ((name . "draw:opacity"))
			 (ref
			  ((name . "zeroToHundredPercent")))))
	      (optional nil
			(attribute
			 ((name . "draw:opacity-name"))
			 (ref
			  ((name . "styleNameRef")))))
	      (optional nil
			(attribute
			 ((name . "svg:fill-rule"))
			 (choice nil
				 (value nil "nonzero")
				 (value nil "evenodd"))))))
 (define
  ((name . "text-list-style-attr"))
  (interleave nil
	      (attribute
	       ((name . "style:name"))
	       (ref
		((name . "styleName"))))
	      (optional nil
			(attribute
			 ((name . "style:display-name"))
			 (ref
			  ((name . "string")))))
	      (optional nil
			(attribute
			 ((name . "text:consecutive-numbering"))
			 (ref
			  ((name . "boolean")))))))
 (define
  ((name . "text-list-level-style-attr"))
  (attribute
   ((name . "text:level"))
   (ref
    ((name . "positiveInteger")))))
 (define
  ((name . "style-num-letter-sync-attlist"))
  (optional nil
	    (attribute
	     ((name . "style:num-letter-sync"))
	     (ref
	      ((name . "boolean"))))))
 (define
  ((name . "common-num-format-attlist"))
  (choice nil
	  (attribute
	   ((name . "style:num-format"))
	   (choice nil
		   (value nil "1")
		   (value nil "i")
		   (value nil "I")
		   (ref
		    ((name . "string")))
		   (empty nil)))
	  (group nil
		 (attribute
		  ((name . "style:num-format"))
		  (choice nil
			  (value nil "a")
			  (value nil "A")))
		 (ref
		  ((name . "style-num-letter-sync-attlist"))))
	  (empty nil)))
 #4=(define
     ((name . "common-num-format-prefix-suffix-attlist"))
     (optional nil
	       (attribute
		((name . "style:num-prefix"))
		(ref
		 ((name . "string")))))
     (optional nil
	       (attribute
		((name . "style:num-suffix"))
		(ref
		 ((name . "string"))))))
 (define
  ((name . "text-list-level-style-number-attr"))
  (interleave nil
	      (optional nil
			(attribute
			 ((name . "text:style-name"))
			 (ref
			  ((name . "styleNameRef")))))
	      (ref
	       ((name . "common-num-format-attlist")))
	      (ref
	       ((name . "common-num-format-prefix-suffix-attlist")))
	      (optional nil
			(attribute
			 ((name . "text:display-levels"))
			 (ref
			  ((name . "positiveInteger")))))
	      (optional nil
			(attribute
			 ((name . "text:start-value"))
			 (ref
			  ((name . "positiveInteger")))))))
 (define
  ((name . "common-text-align"))
  (optional nil
	    (attribute
	     ((name . "fo:text-align"))
	     (choice nil
		     (value nil "start")
		     (value nil "end")
		     (value nil "left")
		     (value nil "right")
		     (value nil "center")
		     (value nil "justify")))))
 #1# #2#
 (define
  ((name . "style-list-level-properties-attlist"))
  (interleave nil
	      (ref
	       ((name . "common-text-align")))
	      (optional nil
			(attribute
			 ((name . "text:space-before"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "text:min-label-width"))
			 (ref
			  ((name . "nonNegativeLength")))))
	      (optional nil
			(attribute
			 ((name . "text:min-label-distance"))
			 (ref
			  ((name . "nonNegativeLength")))))
	      (optional nil
			(attribute
			 ((name . "style:font-name"))
			 (ref
			  ((name . "string")))))
	      (optional nil
			(attribute
			 ((name . "fo:width"))
			 (ref
			  ((name . "positiveLength")))))
	      (optional nil
			(attribute
			 ((name . "fo:height"))
			 (ref
			  ((name . "positiveLength")))))
	      (ref
	       ((name . "common-vertical-rel-attlist")))
	      (ref
	       ((name . "common-vertical-pos-attlist")))
	      (optional nil
			(attribute
			 ((name . "text:list-level-position-and-space-mode"))
			 (choice nil
				 (value nil "label-width-and-position")
				 (value nil "label-alignment"))))))
 (define
  ((name . "style-list-level-label-alignment-attlist"))
  (interleave nil
	      (attribute
	       ((name . "text:label-followed-by"))
	       (choice nil
		       (value nil "listtab")
		       (value nil "space")
		       (value nil "nothing")))
	      (optional nil
			(attribute
			 ((name . "text:list-tab-stop-position"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "fo:text-indent"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "fo:margin-left"))
			 (ref
			  ((name . "length")))))))
 (define
  ((name . "style-list-level-label-alignment"))
  (optional nil
	    (element
	     ((name . "style:list-level-label-alignment"))
	     (ref
	      ((name . "style-list-level-label-alignment-attlist")))
	     (empty nil))))
 (define
  ((name . "style-list-level-properties-elements"))
  (ref
   ((name . "style-list-level-label-alignment"))))
 (define
  ((name . "style-list-level-properties-content-strict"))
  (ref
   ((name . "style-list-level-properties-attlist")))
  (ref
   ((name . "style-list-level-properties-elements"))))
 (define
  ((name . "style-list-level-properties"))
  (element
   ((name . "style:list-level-properties"))
   (ref
    ((name . "style-list-level-properties-content-strict")))))
 #3#
 (define
  ((name . "style-text-properties-attlist"))
  (interleave nil
	      (optional nil
			(attribute
			 ((name . "fo:font-variant"))
			 (ref
			  ((name . "fontVariant")))))
	      (optional nil
			(attribute
			 ((name . "fo:text-transform"))
			 (choice nil
				 (value nil "none")
				 (value nil "lowercase")
				 (value nil "uppercase")
				 (value nil "capitalize"))))
	      (optional nil
			(attribute
			 ((name . "fo:color"))
			 (ref
			  ((name . "color")))))
	      (optional nil
			(attribute
			 ((name . "style:use-window-font-color"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "style:text-outline"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "style:text-line-through-type"))
			 (ref
			  ((name . "lineType")))))
	      (optional nil
			(attribute
			 ((name . "style:text-line-through-style"))
			 (ref
			  ((name . "lineStyle")))))
	      (optional nil
			(attribute
			 ((name . "style:text-line-through-width"))
			 (ref
			  ((name . "lineWidth")))))
	      (optional nil
			(attribute
			 ((name . "style:text-line-through-color"))
			 (choice nil
				 (value nil "font-color")
				 (ref
				  ((name . "color"))))))
	      (optional nil
			(attribute
			 ((name . "style:text-line-through-text"))
			 (ref
			  ((name . "string")))))
	      (optional nil
			(attribute
			 ((name . "style:text-line-through-text-style"))
			 (ref
			  ((name . "styleNameRef")))))
	      (optional nil
			(attribute
			 ((name . "style:text-position"))
			 (list nil
			       (choice nil
				       (ref
					((name . "percent")))
				       (value nil "super")
				       (value nil "sub"))
			       (optional nil
					 (ref
					  ((name . "percent")))))))
	      (optional nil
			(attribute
			 ((name . "style:font-name"))
			 (ref
			  ((name . "string")))))
	      (optional nil
			(attribute
			 ((name . "style:font-name-asian"))
			 (ref
			  ((name . "string")))))
	      (optional nil
			(attribute
			 ((name . "style:font-name-complex"))
			 (ref
			  ((name . "string")))))
	      (optional nil
			(attribute
			 ((name . "fo:font-family"))
			 (ref
			  ((name . "string")))))
	      (optional nil
			(attribute
			 ((name . "style:font-family-asian"))
			 (ref
			  ((name . "string")))))
	      (optional nil
			(attribute
			 ((name . "style:font-family-complex"))
			 (ref
			  ((name . "string")))))
	      (optional nil
			(attribute
			 ((name . "style:font-family-generic"))
			 (ref
			  ((name . "fontFamilyGeneric")))))
	      (optional nil
			(attribute
			 ((name . "style:font-family-generic-asian"))
			 (ref
			  ((name . "fontFamilyGeneric")))))
	      (optional nil
			(attribute
			 ((name . "style:font-family-generic-complex"))
			 (ref
			  ((name . "fontFamilyGeneric")))))
	      (optional nil
			(attribute
			 ((name . "style:font-style-name"))
			 (ref
			  ((name . "string")))))
	      (optional nil
			(attribute
			 ((name . "style:font-style-name-asian"))
			 (ref
			  ((name . "string")))))
	      (optional nil
			(attribute
			 ((name . "style:font-style-name-complex"))
			 (ref
			  ((name . "string")))))
	      (optional nil
			(attribute
			 ((name . "style:font-pitch"))
			 (ref
			  ((name . "fontPitch")))))
	      (optional nil
			(attribute
			 ((name . "style:font-pitch-asian"))
			 (ref
			  ((name . "fontPitch")))))
	      (optional nil
			(attribute
			 ((name . "style:font-pitch-complex"))
			 (ref
			  ((name . "fontPitch")))))
	      (optional nil
			(attribute
			 ((name . "style:font-charset"))
			 (ref
			  ((name . "textEncoding")))))
	      (optional nil
			(attribute
			 ((name . "style:font-charset-asian"))
			 (ref
			  ((name . "textEncoding")))))
	      (optional nil
			(attribute
			 ((name . "style:font-charset-complex"))
			 (ref
			  ((name . "textEncoding")))))
	      (optional nil
			(attribute
			 ((name . "fo:font-size"))
			 (choice nil
				 (ref
				  ((name . "positiveLength")))
				 (ref
				  ((name . "percent"))))))
	      (optional nil
			(attribute
			 ((name . "style:font-size-asian"))
			 (choice nil
				 (ref
				  ((name . "positiveLength")))
				 (ref
				  ((name . "percent"))))))
	      (optional nil
			(attribute
			 ((name . "style:font-size-complex"))
			 (choice nil
				 (ref
				  ((name . "positiveLength")))
				 (ref
				  ((name . "percent"))))))
	      (optional nil
			(attribute
			 ((name . "style:font-size-rel"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "style:font-size-rel-asian"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "style:font-size-rel-complex"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "style:script-type"))
			 (choice nil
				 (value nil "latin")
				 (value nil "asian")
				 (value nil "complex")
				 (value nil "ignore"))))
	      (optional nil
			(attribute
			 ((name . "fo:letter-spacing"))
			 (choice nil
				 (ref
				  ((name . "length")))
				 (value nil "normal"))))
	      (optional nil
			(attribute
			 ((name . "fo:language"))
			 (ref
			  ((name . "languageCode")))))
	      (optional nil
			(attribute
			 ((name . "style:language-asian"))
			 (ref
			  ((name . "languageCode")))))
	      (optional nil
			(attribute
			 ((name . "style:language-complex"))
			 (ref
			  ((name . "languageCode")))))
	      (optional nil
			(attribute
			 ((name . "fo:country"))
			 (ref
			  ((name . "countryCode")))))
	      (optional nil
			(attribute
			 ((name . "style:country-asian"))
			 (ref
			  ((name . "countryCode")))))
	      (optional nil
			(attribute
			 ((name . "style:country-complex"))
			 (ref
			  ((name . "countryCode")))))
	      (optional nil
			(attribute
			 ((name . "fo:script"))
			 (ref
			  ((name . "scriptCode")))))
	      (optional nil
			(attribute
			 ((name . "style:script-asian"))
			 (ref
			  ((name . "scriptCode")))))
	      (optional nil
			(attribute
			 ((name . "style:script-complex"))
			 (ref
			  ((name . "scriptCode")))))
	      (optional nil
			(attribute
			 ((name . "style:rfc-language-tag"))
			 (ref
			  ((name . "language")))))
	      (optional nil
			(attribute
			 ((name . "style:rfc-language-tag-asian"))
			 (ref
			  ((name . "language")))))
	      (optional nil
			(attribute
			 ((name . "style:rfc-language-tag-complex"))
			 (ref
			  ((name . "language")))))
	      (optional nil
			(attribute
			 ((name . "fo:font-style"))
			 (ref
			  ((name . "fontStyle")))))
	      (optional nil
			(attribute
			 ((name . "style:font-style-asian"))
			 (ref
			  ((name . "fontStyle")))))
	      (optional nil
			(attribute
			 ((name . "style:font-style-complex"))
			 (ref
			  ((name . "fontStyle")))))
	      (optional nil
			(attribute
			 ((name . "style:font-relief"))
			 (choice nil
				 (value nil "none")
				 (value nil "embossed")
				 (value nil "engraved"))))
	      (optional nil
			(attribute
			 ((name . "fo:text-shadow"))
			 (ref
			  ((name . "shadowType")))))
	      (optional nil
			(attribute
			 ((name . "style:text-underline-type"))
			 (ref
			  ((name . "lineType")))))
	      (optional nil
			(attribute
			 ((name . "style:text-underline-style"))
			 (ref
			  ((name . "lineStyle")))))
	      (optional nil
			(attribute
			 ((name . "style:text-underline-width"))
			 (ref
			  ((name . "lineWidth")))))
	      (optional nil
			(attribute
			 ((name . "style:text-underline-color"))
			 (choice nil
				 (value nil "font-color")
				 (ref
				  ((name . "color"))))))
	      (optional nil
			(attribute
			 ((name . "style:text-overline-type"))
			 (ref
			  ((name . "lineType")))))
	      (optional nil
			(attribute
			 ((name . "style:text-overline-style"))
			 (ref
			  ((name . "lineStyle")))))
	      (optional nil
			(attribute
			 ((name . "style:text-overline-width"))
			 (ref
			  ((name . "lineWidth")))))
	      (optional nil
			(attribute
			 ((name . "style:text-overline-color"))
			 (choice nil
				 (value nil "font-color")
				 (ref
				  ((name . "color"))))))
	      (optional nil
			(attribute
			 ((name . "style:text-overline-mode"))
			 (ref
			  ((name . "lineMode")))))
	      (optional nil
			(attribute
			 ((name . "fo:font-weight"))
			 (ref
			  ((name . "fontWeight")))))
	      (optional nil
			(attribute
			 ((name . "style:font-weight-asian"))
			 (ref
			  ((name . "fontWeight")))))
	      (optional nil
			(attribute
			 ((name . "style:font-weight-complex"))
			 (ref
			  ((name . "fontWeight")))))
	      (optional nil
			(attribute
			 ((name . "style:text-underline-mode"))
			 (ref
			  ((name . "lineMode")))))
	      (optional nil
			(attribute
			 ((name . "style:text-line-through-mode"))
			 (ref
			  ((name . "lineMode")))))
	      (optional nil
			(attribute
			 ((name . "style:letter-kerning"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "style:text-blinking"))
			 (ref
			  ((name . "boolean")))))
	      (ref
	       ((name . "common-background-color-attlist")))
	      (optional nil
			(attribute
			 ((name . "style:text-combine"))
			 (choice nil
				 (value nil "none")
				 (value nil "letters")
				 (value nil "lines"))))
	      (optional nil
			(attribute
			 ((name . "style:text-combine-start-char"))
			 (ref
			  ((name . "character")))))
	      (optional nil
			(attribute
			 ((name . "style:text-combine-end-char"))
			 (ref
			  ((name . "character")))))
	      (optional nil
			(attribute
			 ((name . "style:text-emphasize"))
			 (choice nil
				 (value nil "none")
				 (list nil
				       (choice nil
					       (value nil "none")
					       (value nil "accent")
					       (value nil "dot")
					       (value nil "circle")
					       (value nil "disc"))
				       (choice nil
					       (value nil "above")
					       (value nil "below"))))))
	      (optional nil
			(attribute
			 ((name . "style:text-scale"))
			 (ref
			  ((name . "percent")))))
	      (optional nil
			(attribute
			 ((name . "style:text-rotation-angle"))
			 (ref
			  ((name . "angle")))))
	      (optional nil
			(attribute
			 ((name . "style:text-rotation-scale"))
			 (choice nil
				 (value nil "fixed")
				 (value nil "line-height"))))
	      (optional nil
			(attribute
			 ((name . "fo:hyphenate"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "fo:hyphenation-remain-char-count"))
			 (ref
			  ((name . "positiveInteger")))))
	      (optional nil
			(attribute
			 ((name . "fo:hyphenation-push-char-count"))
			 (ref
			  ((name . "positiveInteger")))))
	      (choice nil
		      (attribute
		       ((name . "text:display"))
		       (value nil "true"))
		      (attribute
		       ((name . "text:display"))
		       (value nil "none"))
		      (group nil
			     (attribute
			      ((name . "text:display"))
			      (value nil "condition"))
			     (attribute
			      ((name . "text:condition"))
			      (value nil "none")))
		      (empty nil))))
 (define
  ((name . "style-text-properties-elements"))
  (empty nil))
 (define
  ((name . "style-text-properties-content-strict"))
  (ref
   ((name . "style-text-properties-attlist")))
  (ref
   ((name . "style-text-properties-elements"))))
 (define
  ((name . "style-text-properties"))
  (element
   ((name . "style:text-properties"))
   (ref
    ((name . "style-text-properties-content-strict")))))
 #4#
 (define
  ((name . "text-list-level-style-bullet-attr"))
  (interleave nil
	      (optional nil
			(attribute
			 ((name . "text:style-name"))
			 (ref
			  ((name . "styleNameRef")))))
	      (attribute
	       ((name . "text:bullet-char"))
	       (ref
		((name . "character"))))
	      (ref
	       ((name . "common-num-format-prefix-suffix-attlist")))
	      (optional nil
			(attribute
			 ((name . "text:bullet-relative-size"))
			 (ref
			  ((name . "percent")))))))
 #5=(define
     ((name . "common-draw-data-attlist"))
     (group nil
	    (attribute
	     ((name . "xlink:type"))
	     (value nil "simple"))
	    (attribute
	     ((name . "xlink:href"))
	     (ref
	      ((name . "anyIRI"))))
	    (optional nil
		      (attribute
		       ((name . "xlink:show"))
		       (value nil "embed")))
	    (optional nil
		      (attribute
		       ((name . "xlink:actuate"))
		       (value nil "onLoad")))))
 #6=(define
     ((name . "office-binary-data"))
     (element
      ((name . "office:binary-data"))
      (ref
       ((name . "base64Binary")))))
 (define
  ((name . "text-list-level-style-image-attr"))
  (choice nil
	  (ref
	   ((name . "common-draw-data-attlist")))
	  (ref
	   ((name . "office-binary-data")))))
 (define
  ((name . "text-list-style-content"))
  (choice nil
	  (element
	   ((name . "text:list-level-style-number"))
	   (ref
	    ((name . "text-list-level-style-attr")))
	   (ref
	    ((name . "text-list-level-style-number-attr")))
	   (optional nil
		     (ref
		      ((name . "style-list-level-properties"))))
	   (optional nil
		     (ref
		      ((name . "style-text-properties")))))
	  (element
	   ((name . "text:list-level-style-bullet"))
	   (ref
	    ((name . "text-list-level-style-attr")))
	   (ref
	    ((name . "text-list-level-style-bullet-attr")))
	   (optional nil
		     (ref
		      ((name . "style-list-level-properties"))))
	   (optional nil
		     (ref
		      ((name . "style-text-properties")))))
	  (element
	   ((name . "text:list-level-style-image"))
	   (ref
	    ((name . "text-list-level-style-attr")))
	   (ref
	    ((name . "text-list-level-style-image-attr")))
	   (optional nil
		     (ref
		      ((name . "style-list-level-properties")))))))
 (define
  ((name . "text-list-style"))
  (element
   ((name . "text:list-style"))
   (ref
    ((name . "text-list-style-attr")))
   (zeroOrMore nil
	       (ref
		((name . "text-list-style-content"))))))
 (define
  ((name . "style-background-image-attlist"))
  (interleave nil
	      (optional nil
			(attribute
			 ((name . "style:repeat"))
			 (choice nil
				 (value nil "no-repeat")
				 (value nil "repeat")
				 (value nil "stretch"))))
	      (optional nil
			(attribute
			 ((name . "style:position"))
			 (choice nil
				 (value nil "left")
				 (value nil "center")
				 (value nil "right")
				 (value nil "top")
				 (value nil "bottom")
				 (list nil
				       (ref
					((name . "horiBackPos")))
				       (ref
					((name . "vertBackPos"))))
				 (list nil
				       (ref
					((name . "vertBackPos")))
				       (ref
					((name . "horiBackPos")))))))
	      (optional nil
			(attribute
			 ((name . "style:filter-name"))
			 (ref
			  ((name . "string")))))
	      (optional nil
			(attribute
			 ((name . "draw:opacity"))
			 (ref
			  ((name . "zeroToHundredPercent")))))))
 #5#
 (define
  ((name . "base64Binary"))
  (data
   ((type . "base64Binary"))))
 #6#
 (define
  ((name . "style-background-image"))
  (optional nil
	    (element
	     ((name . "style:background-image"))
	     (ref
	      ((name . "style-background-image-attlist")))
	     (choice nil
		     (ref
		      ((name . "common-draw-data-attlist")))
		     (ref
		      ((name . "office-binary-data")))
		     (empty nil)))))
 (define
  ((name . "style-columns-attlist"))
  (interleave nil
	      (attribute
	       ((name . "fo:column-count"))
	       (ref
		((name . "positiveInteger"))))
	      (optional nil
			(attribute
			 ((name . "fo:column-gap"))
			 (ref
			  ((name . "length")))))))
 (define
  ((name . "style-column-sep-attlist"))
  (interleave nil
	      (optional nil
			(attribute
			 ((name . "style:style"))
			 (choice nil
				 (value nil "none")
				 (value nil "solid")
				 (value nil "dotted")
				 (value nil "dashed")
				 (value nil "dot-dashed"))))
	      (attribute
	       ((name . "style:width"))
	       (ref
		((name . "length"))))
	      (optional nil
			(attribute
			 ((name . "style:height"))
			 (ref
			  ((name . "zeroToHundredPercent")))))
	      (optional nil
			(attribute
			 ((name . "style:vertical-align"))
			 (choice nil
				 (value nil "top")
				 (value nil "middle")
				 (value nil "bottom"))))
	      (optional nil
			(attribute
			 ((name . "style:color"))
			 (ref
			  ((name . "color")))))))
 (define
  ((name . "style-column-sep"))
  (element
   ((name . "style:column-sep"))
   (ref
    ((name . "style-column-sep-attlist")))))
 (define
  ((name . "style-column-attlist"))
  (interleave nil
	      (attribute
	       ((name . "style:rel-width"))
	       (ref
		((name . "relativeLength"))))
	      (optional nil
			(attribute
			 ((name . "fo:start-indent"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "fo:end-indent"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "fo:space-before"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "fo:space-after"))
			 (ref
			  ((name . "length")))))))
 (define
  ((name . "style-column"))
  (element
   ((name . "style:column"))
   (ref
    ((name . "style-column-attlist")))))
 (define
  ((name . "style-columns"))
  (optional nil
	    (element
	     ((name . "style:columns"))
	     (ref
	      ((name . "style-columns-attlist")))
	     (optional nil
		       (ref
			((name . "style-column-sep"))))
	     (zeroOrMore nil
			 (ref
			  ((name . "style-column")))))))
 (define
  ((name . "style-graphic-properties-elements"))
  (interleave nil
	      (optional nil
			(ref
			 ((name . "text-list-style"))))
	      (ref
	       ((name . "style-background-image")))
	      (ref
	       ((name . "style-columns")))))
 (define
  ((name . "style-graphic-properties-attlist"))
  (interleave nil
	      (optional nil
			(attribute
			 ((name . "draw:stroke"))
			 (choice nil
				 (value nil "none")
				 (value nil "dash")
				 (value nil "solid"))))
	      (optional nil
			(attribute
			 ((name . "draw:stroke-dash"))
			 (ref
			  ((name . "styleNameRef")))))
	      (optional nil
			(attribute
			 ((name . "draw:stroke-dash-names"))
			 (ref
			  ((name . "styleNameRefs")))))
	      (optional nil
			(attribute
			 ((name . "svg:stroke-width"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "svg:stroke-color"))
			 (ref
			  ((name . "color")))))
	      (optional nil
			(attribute
			 ((name . "draw:marker-start"))
			 (ref
			  ((name . "styleNameRef")))))
	      (optional nil
			(attribute
			 ((name . "draw:marker-end"))
			 (ref
			  ((name . "styleNameRef")))))
	      (optional nil
			(attribute
			 ((name . "draw:marker-start-width"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "draw:marker-end-width"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "draw:marker-start-center"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "draw:marker-end-center"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "svg:stroke-opacity"))
			 (choice nil
				 (data
				  ((type . "double"))
				  (param
				   ((name . "minInclusive"))
				   "0")
				  (param
				   ((name . "maxInclusive"))
				   "1"))
				 (ref
				  ((name . "zeroToHundredPercent"))))))
	      (optional nil
			(attribute
			 ((name . "draw:stroke-linejoin"))
			 (choice nil
				 (value nil "miter")
				 (value nil "round")
				 (value nil "bevel")
				 (value nil "middle")
				 (value nil "none"))))
	      (optional nil
			(attribute
			 ((name . "svg:stroke-linecap"))
			 (choice nil
				 (value nil "butt")
				 (value nil "square")
				 (value nil "round"))))
	      (optional nil
			(attribute
			 ((name . "draw:symbol-color"))
			 (ref
			  ((name . "color")))))
	      (optional nil
			(attribute
			 ((name . "text:animation"))
			 (choice nil
				 (value nil "none")
				 (value nil "scroll")
				 (value nil "alternate")
				 (value nil "slide"))))
	      (optional nil
			(attribute
			 ((name . "text:animation-direction"))
			 (choice nil
				 (value nil "left")
				 (value nil "right")
				 (value nil "up")
				 (value nil "down"))))
	      (optional nil
			(attribute
			 ((name . "text:animation-start-inside"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "text:animation-stop-inside"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "text:animation-repeat"))
			 (ref
			  ((name . "nonNegativeInteger")))))
	      (optional nil
			(attribute
			 ((name . "text:animation-delay"))
			 (ref
			  ((name . "duration")))))
	      (optional nil
			(attribute
			 ((name . "text:animation-steps"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "draw:auto-grow-width"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "draw:auto-grow-height"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "draw:fit-to-size"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "draw:fit-to-contour"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "draw:textarea-vertical-align"))
			 (choice nil
				 (value nil "top")
				 (value nil "middle")
				 (value nil "bottom")
				 (value nil "justify"))))
	      (optional nil
			(attribute
			 ((name . "draw:textarea-horizontal-align"))
			 (choice nil
				 (value nil "left")
				 (value nil "center")
				 (value nil "right")
				 (value nil "justify"))))
	      (optional nil
			(attribute
			 ((name . "fo:wrap-option"))
			 (choice nil
				 (value nil "no-wrap")
				 (value nil "wrap"))))
	      (optional nil
			(attribute
			 ((name . "style:shrink-to-fit"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "draw:color-mode"))
			 (choice nil
				 (value nil "greyscale")
				 (value nil "mono")
				 (value nil "watermark")
				 (value nil "standard"))))
	      (optional nil
			(attribute
			 ((name . "draw:color-inversion"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "draw:luminance"))
			 (ref
			  ((name . "zeroToHundredPercent")))))
	      (optional nil
			(attribute
			 ((name . "draw:contrast"))
			 (ref
			  ((name . "percent")))))
	      (optional nil
			(attribute
			 ((name . "draw:gamma"))
			 (ref
			  ((name . "percent")))))
	      (optional nil
			(attribute
			 ((name . "draw:red"))
			 (ref
			  ((name . "signedZeroToHundredPercent")))))
	      (optional nil
			(attribute
			 ((name . "draw:green"))
			 (ref
			  ((name . "signedZeroToHundredPercent")))))
	      (optional nil
			(attribute
			 ((name . "draw:blue"))
			 (ref
			  ((name . "signedZeroToHundredPercent")))))
	      (optional nil
			(attribute
			 ((name . "draw:image-opacity"))
			 (ref
			  ((name . "zeroToHundredPercent")))))
	      (optional nil
			(attribute
			 ((name . "draw:shadow"))
			 (choice nil
				 (value nil "visible")
				 (value nil "hidden"))))
	      (optional nil
			(attribute
			 ((name . "draw:shadow-offset-x"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "draw:shadow-offset-y"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "draw:shadow-color"))
			 (ref
			  ((name . "color")))))
	      (optional nil
			(attribute
			 ((name . "draw:shadow-opacity"))
			 (ref
			  ((name . "zeroToHundredPercent")))))
	      (optional nil
			(attribute
			 ((name . "draw:start-line-spacing-horizontal"))
			 (ref
			  ((name . "distance")))))
	      (optional nil
			(attribute
			 ((name . "draw:start-line-spacing-vertical"))
			 (ref
			  ((name . "distance")))))
	      (optional nil
			(attribute
			 ((name . "draw:end-line-spacing-horizontal"))
			 (ref
			  ((name . "distance")))))
	      (optional nil
			(attribute
			 ((name . "draw:end-line-spacing-vertical"))
			 (ref
			  ((name . "distance")))))
	      (optional nil
			(attribute
			 ((name . "draw:line-distance"))
			 (ref
			  ((name . "distance")))))
	      (optional nil
			(attribute
			 ((name . "draw:guide-overhang"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "draw:guide-distance"))
			 (ref
			  ((name . "distance")))))
	      (optional nil
			(attribute
			 ((name . "draw:start-guide"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "draw:end-guide"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "draw:placing"))
			 (choice nil
				 (value nil "below")
				 (value nil "above"))))
	      (optional nil
			(attribute
			 ((name . "draw:parallel"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "draw:measure-align"))
			 (choice nil
				 (value nil "automatic")
				 (value nil "left-outside")
				 (value nil "inside")
				 (value nil "right-outside"))))
	      (optional nil
			(attribute
			 ((name . "draw:measure-vertical-align"))
			 (choice nil
				 (value nil "automatic")
				 (value nil "above")
				 (value nil "below")
				 (value nil "center"))))
	      (optional nil
			(attribute
			 ((name . "draw:unit"))
			 (choice nil
				 (value nil "automatic")
				 (value nil "mm")
				 (value nil "cm")
				 (value nil "m")
				 (value nil "km")
				 (value nil "pt")
				 (value nil "pc")
				 (value nil "inch")
				 (value nil "ft")
				 (value nil "mi"))))
	      (optional nil
			(attribute
			 ((name . "draw:show-unit"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "draw:decimal-places"))
			 (ref
			  ((name . "nonNegativeInteger")))))
	      (optional nil
			(attribute
			 ((name . "draw:caption-type"))
			 (choice nil
				 (value nil "straight-line")
				 (value nil "angled-line")
				 (value nil "angled-connector-line"))))
	      (optional nil
			(attribute
			 ((name . "draw:caption-angle-type"))
			 (choice nil
				 (value nil "fixed")
				 (value nil "free"))))
	      (optional nil
			(attribute
			 ((name . "draw:caption-angle"))
			 (ref
			  ((name . "angle")))))
	      (optional nil
			(attribute
			 ((name . "draw:caption-gap"))
			 (ref
			  ((name . "distance")))))
	      (optional nil
			(attribute
			 ((name . "draw:caption-escape-direction"))
			 (choice nil
				 (value nil "horizontal")
				 (value nil "vertical")
				 (value nil "auto"))))
	      (optional nil
			(attribute
			 ((name . "draw:caption-escape"))
			 (choice nil
				 (ref
				  ((name . "length")))
				 (ref
				  ((name . "percent"))))))
	      (optional nil
			(attribute
			 ((name . "draw:caption-line-length"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "draw:caption-fit-line-length"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "dr3d:horizontal-segments"))
			 (ref
			  ((name . "nonNegativeInteger")))))
	      (optional nil
			(attribute
			 ((name . "dr3d:vertical-segments"))
			 (ref
			  ((name . "nonNegativeInteger")))))
	      (optional nil
			(attribute
			 ((name . "dr3d:edge-rounding"))
			 (ref
			  ((name . "percent")))))
	      (optional nil
			(attribute
			 ((name . "dr3d:edge-rounding-mode"))
			 (choice nil
				 (value nil "correct")
				 (value nil "attractive"))))
	      (optional nil
			(attribute
			 ((name . "dr3d:back-scale"))
			 (ref
			  ((name . "percent")))))
	      (optional nil
			(attribute
			 ((name . "dr3d:depth"))
			 (ref
			  ((name . "length")))))
	      (optional nil
			(attribute
			 ((name . "dr3d:backface-culling"))
			 (choice nil
				 (value nil "enabled")
				 (value nil "disabled"))))
	      (optional nil
			(attribute
			 ((name . "dr3d:end-angle"))
			 (ref
			  ((name . "angle")))))
	      (optional nil
			(attribute
			 ((name . "dr3d:close-front"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "dr3d:close-back"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "dr3d:lighting-mode"))
			 (choice nil
				 (value nil "standard")
				 (value nil "double-sided"))))
	      (optional nil
			(attribute
			 ((name . "dr3d:normals-kind"))
			 (choice nil
				 (value nil "object")
				 (value nil "flat")
				 (value nil "sphere"))))
	      (optional nil
			(attribute
			 ((name . "dr3d:normals-direction"))
			 (choice nil
				 (value nil "normal")
				 (value nil "inverse"))))
	      (optional nil
			(attribute
			 ((name . "dr3d:texture-generation-mode-x"))
			 (choice nil
				 (value nil "object")
				 (value nil "parallel")
				 (value nil "sphere"))))
	      (optional nil
			(attribute
			 ((name . "dr3d:texture-generation-mode-y"))
			 (choice nil
				 (value nil "object")
				 (value nil "parallel")
				 (value nil "sphere"))))
	      (optional nil
			(attribute
			 ((name . "dr3d:texture-kind"))
			 (choice nil
				 (value nil "luminance")
				 (value nil "intensity")
				 (value nil "color"))))
	      (optional nil
			(attribute
			 ((name . "dr3d:texture-filter"))
			 (choice nil
				 (value nil "enabled")
				 (value nil "disabled"))))
	      (optional nil
			(attribute
			 ((name . "dr3d:texture-mode"))
			 (choice nil
				 (value nil "replace")
				 (value nil "modulate")
				 (value nil "blend"))))
	      (optional nil
			(attribute
			 ((name . "dr3d:ambient-color"))
			 (ref
			  ((name . "color")))))
	      (optional nil
			(attribute
			 ((name . "dr3d:emissive-color"))
			 (ref
			  ((name . "color")))))
	      (optional nil
			(attribute
			 ((name . "dr3d:specular-color"))
			 (ref
			  ((name . "color")))))
	      (optional nil
			(attribute
			 ((name . "dr3d:diffuse-color"))
			 (ref
			  ((name . "color")))))
	      (optional nil
			(attribute
			 ((name . "dr3d:shininess"))
			 (ref
			  ((name . "percent")))))
	      (optional nil
			(attribute
			 ((name . "dr3d:shadow"))
			 (choice nil
				 (value nil "visible")
				 (value nil "hidden"))))
	      (ref
	       ((name . "common-draw-rel-size-attlist")))
	      (optional nil
			(attribute
			 ((name . "fo:min-width"))
			 (choice nil
				 (ref
				  ((name . "length")))
				 (ref
				  ((name . "percent"))))))
	      (optional nil
			(attribute
			 ((name . "fo:min-height"))
			 (choice nil
				 (ref
				  ((name . "length")))
				 (ref
				  ((name . "percent"))))))
	      (optional nil
			(attribute
			 ((name . "fo:max-height"))
			 (choice nil
				 (ref
				  ((name . "length")))
				 (ref
				  ((name . "percent"))))))
	      (optional nil
			(attribute
			 ((name . "fo:max-width"))
			 (choice nil
				 (ref
				  ((name . "length")))
				 (ref
				  ((name . "percent"))))))
	      (ref
	       ((name . "common-horizontal-margin-attlist")))
	      (ref
	       ((name . "common-vertical-margin-attlist")))
	      (ref
	       ((name . "common-margin-attlist")))
	      (optional nil
			(attribute
			 ((name . "style:print-content"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "style:protect"))
			 (choice nil
				 (value nil "none")
				 (list nil
				       (oneOrMore nil
						  (choice nil
							  (value nil "content")
							  (value nil "position")
							  (value nil "size")))))))
	      (optional nil
			(attribute
			 ((name . "style:horizontal-pos"))
			 (choice nil
				 (value nil "left")
				 (value nil "center")
				 (value nil "right")
				 (value nil "from-left")
				 (value nil "inside")
				 (value nil "outside")
				 (value nil "from-inside"))))
	      (optional nil
			(attribute
			 ((name . "svg:x"))
			 (ref
			  ((name . "coordinate")))))
	      (optional nil
			(attribute
			 ((name . "style:horizontal-rel"))
			 (choice nil
				 (value nil "page")
				 (value nil "page-content")
				 (value nil "page-start-margin")
				 (value nil "page-end-margin")
				 (value nil "frame")
				 (value nil "frame-content")
				 (value nil "frame-start-margin")
				 (value nil "frame-end-margin")
				 (value nil "paragraph")
				 (value nil "paragraph-content")
				 (value nil "paragraph-start-margin")
				 (value nil "paragraph-end-margin")
				 (value nil "char"))))
	      (ref
	       ((name . "common-vertical-pos-attlist")))
	      (ref
	       ((name . "common-vertical-rel-attlist")))
	      (ref
	       ((name . "common-text-anchor-attlist")))
	      (ref
	       ((name . "common-border-attlist")))
	      (ref
	       ((name . "common-border-line-width-attlist")))
	      (ref
	       ((name . "common-padding-attlist")))
	      (ref
	       ((name . "common-shadow-attlist")))
	      (ref
	       ((name . "common-background-color-attlist")))
	      (ref
	       ((name . "common-background-transparency-attlist")))
	      (ref
	       ((name . "common-editable-attlist")))
	      (optional nil
			(attribute
			 ((name . "style:wrap"))
			 (choice nil
				 (value nil "none")
				 (value nil "left")
				 (value nil "right")
				 (value nil "parallel")
				 (value nil "dynamic")
				 (value nil "run-through")
				 (value nil "biggest"))))
	      (optional nil
			(attribute
			 ((name . "style:wrap-dynamic-threshold"))
			 (ref
			  ((name . "nonNegativeLength")))))
	      (optional nil
			(attribute
			 ((name . "style:number-wrapped-paragraphs"))
			 (choice nil
				 (value nil "no-limit")
				 (ref
				  ((name . "positiveInteger"))))))
	      (optional nil
			(attribute
			 ((name . "style:wrap-contour"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "style:wrap-contour-mode"))
			 (choice nil
				 (value nil "full")
				 (value nil "outside"))))
	      (optional nil
			(attribute
			 ((name . "style:run-through"))
			 (choice nil
				 (value nil "foreground")
				 (value nil "background"))))
	      (optional nil
			(attribute
			 ((name . "style:flow-with-text"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "style:overflow-behavior"))
			 (choice nil
				 (value nil "clip")
				 (value nil "auto-create-new-frame"))))
	      (optional nil
			(attribute
			 ((name . "style:mirror"))
			 (choice nil
				 (value nil "none")
				 (value nil "vertical")
				 (ref
				  ((name . "horizontal-mirror")))
				 (list nil
				       (value nil "vertical")
				       (ref
					((name . "horizontal-mirror"))))
				 (list nil
				       (ref
					((name . "horizontal-mirror")))
				       (value nil "vertical")))))
	      (optional nil
			(attribute
			 ((name . "fo:clip"))
			 (choice nil
				 (value nil "auto")
				 (ref
				  ((name . "clipShape"))))))
	      (optional nil
			(attribute
			 ((name . "draw:wrap-influence-on-position"))
			 (choice nil
				 (value nil "iterative")
				 (value nil "once-concurrent")
				 (value nil "once-successive"))))
	      (ref
	       ((name . "common-writing-mode-attlist")))
	      (optional nil
			(attribute
			 ((name . "draw:frame-display-scrollbar"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "draw:frame-display-border"))
			 (ref
			  ((name . "boolean")))))
	      (optional nil
			(attribute
			 ((name . "draw:frame-margin-horizontal"))
			 (ref
			  ((name . "nonNegativePixelLength")))))
	      (optional nil
			(attribute
			 ((name . "draw:frame-margin-vertical"))
			 (ref
			  ((name . "nonNegativePixelLength")))))
	      (optional nil
			(attribute
			 ((name . "draw:visible-area-left"))
			 (ref
			  ((name . "nonNegativeLength")))))
	      (optional nil
			(attribute
			 ((name . "draw:visible-area-top"))
			 (ref
			  ((name . "nonNegativeLength")))))
	      (optional nil
			(attribute
			 ((name . "draw:visible-area-width"))
			 (ref
			  ((name . "positiveLength")))))
	      (optional nil
			(attribute
			 ((name . "draw:visible-area-height"))
			 (ref
			  ((name . "positiveLength")))))
	      (optional nil
			(attribute
			 ((name . "draw:draw-aspect"))
			 (choice nil
				 (value nil "content")
				 (value nil "thumbnail")
				 (value nil "icon")
				 (value nil "print-view"))))
	      (optional nil
			(attribute
			 ((name . "draw:ole-draw-aspect"))
			 (ref
			  ((name . "nonNegativeInteger")))))))
 (define
  ((name . "style-graphic-properties-content-strict"))
  (ref
   ((name . "style-graphic-properties-attlist")))
  (ref
   ((name . "style-graphic-fill-properties-attlist")))
  (ref
   ((name . "style-graphic-properties-elements")))))
