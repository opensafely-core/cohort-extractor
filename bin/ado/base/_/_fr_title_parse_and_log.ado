*! version 1.0.6  23feb2015
program _fr_title_parse_and_log , rclass

	gettoken log       0 : 0
	gettoken obj       0 : 0
	gettoken ttype     0 : 0
	gettoken parsenm   0 : 0
	gettoken scm_entry 0 : 0

	local 0 , `0'
	syntax [ , `parsenm'(string asis) * ]
	local rest `"`options'"'

	while `"``ttype''"' != `""' {		// allow option to be repeated
		local rest `"`options'"'
		_parse comma curlines 0 : `ttype'
		syntax [ , NOSPAN SPAN PREFIX SUFFIX POSition(string)	///
			   RING(string) STYle(string) * ]

		if `"`curlines'"' != `""' {		// handle text
			if "`suffix'" != "" {
				local lines `"`lines' `curlines'"'

				if "`prefix'" != "" {
				    di as text "option prefix ignored, " ///
					"may not be combined with suffix"
				}
			}
			else {
				if "`prefix'" != "" {
					local lines `"`curlines' `lines'"'
				}
				else {
					local lines `"`curlines'"'
				}
			}
		}

		if `"`style'"' != `""' {		// accept last seen
			local ustyle `style'
		}
		if `"`position'"' != `""' {
			local uposition `position'
		}
		if `"`ring'"' != `""' {
			local uring `ring'
		}
		if `"`nospan'"' != `""' {
			local uspan no
		}
		if `"`span'"' != `""' {
			local uspan yes
		}

		local uoptions `uoptions' (`options')

		local 0 `", `rest'"'
		syntax [ , `parsenm'(string asis) * ]
	}

	if `"`ustyle'"' == `""' {			// default style
		local ustyle scheme `scm_entry'
	}

	local n = bsubstr("`ttype'", 2, 1)
	local numbered = ("`n'" == "1" | "`n'" == "2")	// r1,r2,l1,l2title...
	if `numbered' {					// not style controlled

		if "`uring'" == "" {			// ring()
			local uring = `n'
		}

		if "`uposition'" == "" {		// position()
			local c = bsubstr("`ttype'",1,1)
			PosMap pos : `c'
			if "`c'" == "r" | "`c'" == "l" {
				local orient orientation(vertical)
			}
		}
		else {
			tempname p
			.`p' = .clockdir.new, style(`uposition')
			local pos `.`p'.relative_position'
		}
	}
	else {						// title, caption, ...
							// style controlled

		if `"`uposition'"' != "" {		// position()
			.style.editstyle `ttype'_position(`uposition') editcopy
			.`log'.Arrpush `obj'.style.editstyle		///
				       `ttype'_position(`uposition') editcopy
		}
		if 0`.style.`ttype'_ring.setting' == 0 {	
			local pos on
		}
		else {
			local pos `.style.`ttype'_position.relative_position'
		}

		if `"`uring'"' != "" {			// ring()
			.`log'.Arrpush `obj'.style.editstyle 		///
				`ttype'_ring(`uring') editcopy
			if `"`uring'"' == `"inside"' {
				local uring 0
			}
			else {
				if `"`uring'"' == `"outside"' {
					local uring 1
				}
			}
		}
		else {
		    	local uring `.style.`ttype'_ring.setting'
		}
		if `"`uring'"' == `"0"' {
			local pos on
		}

	}

	if "`uspan'" != "" {				// handle spanning
	     .`log'.Arrpush .style.editstyle `ttype'_span(`uspan') editcopy
	}
	else	local uspan `.style.`ttype'_span.stylename'

	if "`uspan'" == "yes" {
		if "`pos'" != "on" {
			if "`pos'" == "above" | "`pos'" == "below" {
				local span spancols(all) spanfit(left right)
			}
			else {
				local span spanrows(all) spanfit(above below)
			}
		}
		else {
			local span
			di in green "(option span ignored for position(0))"
		}
	}

							// push view
	if "`.`ttype'.isa'" == "" {
	    .`log'.Arrpush `obj'.insert (`ttype' = .sized_textbox.new,	///
		mtextq(`"`lines'"') style(`ustyle') `orient')		///
		`pos' plotregion1 , ring(`uring') `span'
	}


	if ! `numbered' & "`.`ttype'.isa'" == "" {
						// over-ride box alignment
		.`log'.Arrpush `obj'.`ttype'.style.editstyle 		     ///
		      box_alignment(`.style.`ttype'_position.compass2style') ///
		      editcopy

		if "`pos'" != "leftof" & "`pos'" != "rightof"  {
						// over-ride text halign
		    .`log'.Arrpush `obj'.`ttype'.style.editstyle	     ///
		      horizontal(`.style.`ttype'_position.horizontal_style') ///
		      editcopy
		}
	}

	local obname = cond("`obj'"=="" , "`ttype'" , "`obj'.`ttype'")
	local i 0
	while `++i' < 20 & `"`uoptions'"' != `""' {
		gettoken 0 uoptions : uoptions , match(unused) bind
		if `"`0'"' != `""' {
			_fr_sztextbox_parse_and_log `log' `obname' , `0'
			local 0 `", `r(rest)'"'
		}
		syntax [, FAKE_OPT_FOR_BETTER_MSG ]
	}

	return local rest `rest'
end


program define PosMap
	args mac color poschar

	if "`poschar'" == "l" {
		c_local `mac' leftof
		exit
	}
	if "`poschar'" == "r" {
		c_local `mac' rightof
		exit
	}
	if "`poschar'" == "t" {
		c_local `mac' above
		exit
	}
	if "`poschar'" == "b" {
		c_local `mac' below
		exit
	}

	c_local `mac' on
end
