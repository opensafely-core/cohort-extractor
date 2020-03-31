*! version 1.0.2  11jul2017

// Parses options for a textbox style style and posts those edits
// to the specified log.

program _fr_tbstyle_parse_and_log , rclass
	gettoken log     0 : 0
	gettoken prefix  0 : 0
	gettoken stylenm 0 : 0

	syntax [ , 							 ///
		   TSTYle(string) ANGLE(string) Size(string)		 ///
		   Color(string) Justification(string) Alignment(string) ///
		   Margin(string) LINEGAP(string)			 ///
		   NOBox Box BMargin(string)				 ///
		   PLACEment(string) BFColor(string) FColor(string)	 /// 
		   BColor(string)					 ///
		   BLSTyle(string) BLWidth(string)			 ///
		   BLColor(string) BLPattern(string) 			 ///
		   BLAlign(string)					 ///
		   LSTyle(string)  LWidth(string)			 ///
		   LColor(string)  LPattern(string) 			 ///
		   LAlign(string)					 ///
		   ORIENTation(string) * ]
		   				// orientation allowed n ignored

	local style_eds `"`tstyle'"'		// style edits
	local line_eds `"`blstyle'"'		// init line style edits
	if `"`lstyle'"' != `""'  {
		local line_eds `"`line_eds' `lstyle'"'
	}

							// style names differ
							// from option names
	if `"`justification'"' != `""'	{
		local style_eds `"`style_eds' horizontal(`justification')"'
	}
	if `"`alignment'"' != `""'	{
		local style_eds `"`style_eds' vertical(`alignment')"'
	}
	if `"`box'"' != `""'	{
		local style_eds `"`style_eds' drawbox(yes)"'
	}
	else {
		if `"`nobox'"' != `""'	{
			local style_eds `"`style_eds' drawbox(no)"'
		}
	}
	if `"`placement'"' != `""'	{
		local style_eds `"`style_eds' box_alignment(`placement')"'
	}
	if `"`bcolor'"' != `""'	{
		local style_eds `"`style_eds' fillcolor(`bcolor')"'
		local line_eds  `"`line_eds' color(`bcolor')"'
	}
	if `"`bfcolor'"' != `""'	{
		local style_eds `"`style_eds' fillcolor(`bfcolor')"'
	}
	if `"`fcolor'"' != `""'	{
		local style_eds `"`style_eds' fillcolor(`fcolor')"'
	}
	if `"`bmargin'"' != `""'	{
		local style_eds `"`style_eds' boxmargin(`bmargin')"'
	}

							// use their own names
	foreach opt in angle size color margin linegap {
		if `"``opt''"' != `""' {
			local style_eds `"`style_eds' `opt'(``opt'')"'
		}
	}


	foreach opt in width color pattern align {
		if `"`bl`opt''"' != `""' {
			local line_eds `"`line_eds' `opt'(`bl`opt'')"'
		}
		if `"`l`opt''"' != `""' {
			local line_eds `"`line_eds' `opt'(`l`opt'')"'
		}
	}

	if `"`line_eds'"' != `""' {
		local style_eds `"`style_eds' linestyle(`line_eds')"'
	}

	if `"`style_eds'"' != `""' {
		if "`stylenm'" != "" {
			local style_eds `"`stylenm'(`style_eds')"'
		}
		.`log'.Arrpush .`prefix'.editstyle `style_eds' editcopy
	}


	return local rest `"`options'"'

end
