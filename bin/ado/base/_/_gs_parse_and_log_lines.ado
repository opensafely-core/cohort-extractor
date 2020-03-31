*! version 1.1.5  06apr2009

// ---------------------------------------------------------------------------
//  Parse x and y line options and push edits to create the lines and the look
//  onto the specified log.
//
//	Usage:  ._gs_parse_and_log_lines log ord axnm   
//		<settings and options>
//
//  where ord is "x" or "y"

program _gs_parse_and_log_lines
	gettoken log     0 : 0
	gettoken ord     0 : 0
	gettoken axnm    0 : 0
	gettoken datesok 0 : 0

	syntax anything [ , STyle(string)				///
		   NOEXtend EXtend					///
		   LSTyle(string) LColor(string)			///
		   LWidth(string) LPattern(string)			///
		   AXis(passthru) ]		
		   					// axis ignored

	capture numlist `"`anything'"'
	local numlist `r(numlist)'
	local rc = _rc
	if `rc' & "`datesok'" != "" {
		capture _confirm_number_or_date `anything'
		local numlist `"`anything'"'
		local rc = _rc
	}
	if `rc' {
		di as error `"invalid line argument, `anything'"'
		exit 198
	}

						// create one style used by
						// ref for all the lines


	local eds      `"`style'"'				// overall edits

	if "`noextend'" != "" {
		local eds `"`eds' extend_low(no) extend_high(no)"'
	}
	if "`extend'" != "" {
		local eds `"`eds' extend_low(yes) extend_high(yes)"'
	}

	local line_eds `"`lstyle'"'				// line edits

	if `"`lcolor'"' != `""' {
		local line_eds `"`line_eds' color(`lcolor')"'
	}
	if `"`lwidth'"' != `""' {
		local line_eds `"`line_eds' width(`lwidth')"'
	}
	if `"`lpattern'"' != `""' {
		local line_eds `"`line_eds' pattern(`lpattern')"'
	}

	if `"`line_eds'"' != `""' {
		local eds `"`eds' linestyle(`line_eds')"'
	}

	.`log'.Arrpush tempname glsty			// common style
	.`log'.Arrpush .\`glsty' = .gridlinestyle.new, style(scheme)
	if `"`eds'"' != `""' {
		.`log'.Arrpush .\`glsty'.editstyle `eds' editcopy
	}


							// create the lines
	local numlist : list uniq numlist
	while `"`numlist'"' != "" {
		gettoken z numlist : numlist , match(par)
		capture confirm number `z'
		if c(rc) & "`datesok'" != "" {
			.`log'.Arrpush _fr_declare_date_line	///
				`ord' `axnm' plotregion styleref(\`glsty') (`z')
		}
		else {
			.`log'.Arrpush .`axnm'.plotregion.declare_xyline ///
				.gridline_g.new `z' , ordinate(`ord')	  ///
				plotregion(\`.`axnm'.plotregion.objkey')  ///
				styleref(\`glsty') `datesok'
		}
	}

end

