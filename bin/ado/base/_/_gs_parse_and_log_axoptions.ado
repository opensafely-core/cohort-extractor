*! version 1.0.4  21nov2019

// ---------------------------------------------------------------------------
//  Parse axis style settings and options and push the associated edits of the
//  named object onto the specified log.
//
//	Usage:  ._gs_parse_and_log_axtitle log name
//		<settings and options>

program _gs_parse_and_log_axoptions
	gettoken clog    0 : 0
	gettoken name    0 : 0
	gettoken datesok 0 : 0

	local splitnm : subinstr local name "." " "		// in case a.xnm
	local ord `=usubstr("`:word `:list sizeof splitnm' of `splitnm''", 1, 1)'

	local 0 `", `0'"'
	syntax [ , 							///
		   NOLOG LOG 						///
		   NOATANH ATANH					///
		   NOLOGIT LOGIT					///
		   NOLOG1m LOG1m					///
		   ALTernate						///
		   STYle(string)					///
		   TITLEGap(string) OUTERGap(string)			///
		   NOLIne LIne NOEXtend EXtend NOFEXtend FEXtend	///
		   LSTyle(string) LColor(string)			///
		   LWidth(string) LPattern(string)			///
		   ON OFF NOFILLspace FILLspace 			///
		   RING(real -1) NOREVerse REVerse 			/// 
		   AXis(passthru) * ]
							// axis() ignored

	local transform `nolog' `log'		///
			`noatanh' `atanh'	///
			`nologit' `logit'	///
			`nolog1m' `log1m'
	opts_exclusive "`transform'"

							// expand range
	local min =  .
	local max = -1e300
	local 0 `", `options'"'
	if "`datesok'" == "" {
		syntax [ , Range(numlist missingok max=100 sort) * ]
		while `"`range'"' != `""' {
			foreach r of local range {
				if `r' >= . {
					continue , break
				}
				local min = min(`min', `r')
				local max = max(`max', `r')
			}
			local 0 `", `options'"'
			syntax [ , Range(numlist missingok max=100 sort) * ]
		}
	}
	else {
		syntax [ , Range(string asis) * ]
		while `"`range'"' != `""' {
			capture _confirm_number_or_date `range'
			if _rc {
				di as err ///
				"range() invalid -- invalid numlist"
				exit 121
			}
			local ranges `ranges' "`range'"
			local 0 `", `options'"'
			syntax [ , Range(string) * ]
		}
	}
	local 0 `", `options'"'
	syntax [, FAKE_OPT_FOR_BETTER_MSG ]

	if `min' < . {
		.`clog'.Arrpush .`name'.addmin `min'
	}
	if `max' > -1e300 {
		.`clog'.Arrpush .`name'.addmax `max'
	}
	if "`datesok'" != "" & `"`ranges'"' != "" {
		.`clog'.Arrpush .`name'.daterange `ranges'
	}

	if "`alternate'" != "" {			// swap sides 
		.`clog'.Arrpush .alt_axis `name'
	}
							// reverse
	if "`noreverse'" != "" {
		.`clog'.Arrpush .`name'.plotregion.`ord'scale.reverse.set_false
	}
	if "`reverse'" != "" {
		.`clog'.Arrpush .`name'.plotregion.`ord'scale.reverse.set_true
	}
							// scale transform
	local SCALE .`name'.plotregion.`ord'scale
	if "`transform'" == "log" {
		.`clog'.Arrpush `SCALE'.set_transform log
		.`clog'.Arrpush `SCALE'.reset_from_axes
	}
	else if "`transform'" == "atanh" {
		.`clog'.Arrpush `SCALE'.set_transform atanh
		.`clog'.Arrpush `SCALE'.reset_from_axes
	}
	else if "`transform'" == "logit" {
		.`clog'.Arrpush `SCALE'.set_transform logit
		.`clog'.Arrpush `SCALE'.reset_from_axes
	}
	else if "`transform'" == "log1m" {
		.`clog'.Arrpush `SCALE'.set_transform log1m
		.`clog'.Arrpush `SCALE'.reset_from_axes
	}
	else if "`transform'" != "" {
	     .`clog'.Arrpush .`name'.plotregion.`ord'scale.set_transform linear
	     .`clog'.Arrpush .`name'.plotregion.`ord'scale.reset_from_axes
	}

	if "`on'" != "" {				// drawing on/off
		.`clog'.Arrpush .`name'.draw_view.set_on
	}
	if "`off'" != "" {
		.`clog'.Arrpush .`name'.draw_view.set_off
	}
	if "`fillspace'" != "" {			// fill if drawn
		.`clog'.Arrpush .`name'.fill_if_undrawn.set_true
	}
	if "`nofillspace'" != "" {			// fill if drawn
		.`clog'.Arrpush .`name'.fill_if_undrawn.set_false
	}

							// change rings
	if `ring' >= 0 {	
		.`clog'.Arrpush .cells.`name'.ring = `ring'	// tricky
		.`clog'.Arrpush .reinsert_axis `name' plotregion1 
	}

	local style_ed `"`style'"'			// overall style edits

	if `"`titlegap'"' != `""' {
		local style_ed `"`style_ed' title_gap(`titlegap')"'
	}
	if `"`outergap'"' != `""' {
		local style_ed `"`style_ed' outer_space(`outergap')"'
	}
	if `"`line'"' != `""' {
		local style_ed `"`style_ed' linestyle(foreground)"'
	}
	if `"`noline'"' != `""' {
		local style_ed `"`style_ed' linestyle(none)"'
	}
	if `"`extend'"' != `""' {
		local style_ed `"`style_ed' extend_low(yes) extend_high(yes)"'
	}
	if `"`noextend'"' != `""' {
		local nofextend "nofextend"			// implied
		local style_ed `"`style_ed' extend_low(no) extend_high(no)"'
	}
	if `"`fextend'"' != `""' {
		local style_ed	///
		      `"`style_ed' extend_full_low(yes) extend_full_high(yes)"'
	}
	if `"`nofextend'"' != `""' {
	    local style_ed	///
	    	  `"`style_ed' extend_full_low(no) extend_full_high(no)"'
	}

	local line_ed `"`lstyle'"'			// linestyle edits
	if `"`lcolor'"' != `""' {
		local line_ed `"`line_ed' color(`lcolor')"'
	}
	if `"`lwidth'"' != `""' {
		local line_ed `"`line_ed' width(`lwidth')"'
	}
	if `"`lpattern'"' != `""' {
		local line_ed `"`line_ed' pattern(`lpattern')"'
	}

	if `"`line_ed'"' != "" {
		local line_ed `"linestyle(`line_ed')"'
	}
	if `"`style_ed'"' != `""' | `"`line_ed'"' != `""' {
	   .`clog'.Arrpush .`name'.style.editstyle `style_ed' `line_ed' editcopy
	}

end

