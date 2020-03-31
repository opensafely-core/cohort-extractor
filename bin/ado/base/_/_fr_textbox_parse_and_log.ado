*! version 1.0.0  06sep2002

// Parses options for a textbox and its associated style and posts those edits
// of the specified textbox to the specified log.

program _fr_textbox_parse_and_log , rclass
	gettoken log  0 : 0
	gettoken tbox 0 : 0

	syntax [ , ORIENTation(string) DRAWVIEW(string)			 ///
		   XOFFSET(real -99999) YOFFSET(real -99999)		 ///
		   * ]

		   				// object edits
	if `"`orientation'"' != `""' {
		.`log'.Arrpush .`tbox'._set_orientation `orientation'
	}
	if `"`drawview'"' != `""' {
		.`log'.Arrpush .`tbox'.draw_view.setstyle, style(`drawview')
	}
	if `xoffset' != -99999 {
		.`log'.Arrpush .`tbox'.xoffset = `xoffset'
	}
	if `yoffset' != -99999 {
		.`log'.Arrpush .`tbox'.yoffset = `yoffset'
	}

	_fr_tbstyle_parse_and_log `log' `tbox'.style "" , `options'

	return local rest `"`r(rest)'"'
end
