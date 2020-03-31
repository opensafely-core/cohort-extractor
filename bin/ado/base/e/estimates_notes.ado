*! version 1.0.2  13feb2015
program estimates_notes, eclass
	version 10

	if (`"`e(cmd)'"' == "") {
		error 301
	}

	if `"`0'"'=="" { 
		notelist 
		exit
	}

	gettoken todo rest : 0, parse(" :")

	if ("`todo'"==":") { 
		noteadd `rest'
		exit
	}

	if ("`todo'" == bsubstr("list", 1, max(1, length("`todo'")))) {
		notelist `rest'
		exit
	}
	if ("`todo'"=="drop") { 
		notedrop `rest'
		exit
	}
	if ("`todo'"=="sign") { 
		notesign `rest'
		exit
	}

	error 198
end

program notelist
	note_parse n1 n2 hasin : `"`0'"'
	forvalues i = `n1'/`n2' {
		if (`"`e(estimates_note`i')'"' != "") { 
			local l = max(0, 5-length("`i'"))
			di as txt "{p `l' 6}"
			di as txt "`i'."
			di as txt `"`e(estimates_note`i')'"'
			di "{p_end}"
		}
	}
end

program notedrop, eclass
	note_parse num0 num1 hasin : `"`0'"'

	if (`hasin'==0) {
		local num1 0
	}

	local dropped 0
	nobreak {
		forvalues i=`num0'/`num1' { 
			if (`"`e(estimates_note`i')'"' != "") {
				local ++dropped
			}
			ereturn local estimates_note`i'
		}
		local n = cond(e(estimates_note0)<., e(estimates_note0), 0)
		local j 0
		forvalues i=`n'(-1)1 {
			if (`"`e(estimates_note`i')'"' != "") {
				local j `i'
				continue, break
			}
		}
		ereturn scalar estimates_note0 = `j'
		local notes = cond(`dropped'==1, "note", "notes")
		di as txt "  (`dropped' `notes' dropped)"
	}
end
	


	

program noteadd /* text */, eclass
	local text `"`0'"'

	if (`"`text'"')=="" {
		di as txt "  (no note added)"
		exit
	}

	local n = cond(e(estimates_note0)<., e(estimates_note0), 0)
	local ++n

	local ts = bsubstr("$S_DATE $S_TIME",1,17) 
	local text : subinstr local text "TS" "`ts'", all word 

	nobreak {
		ereturn scalar estimates_note0 = `n'
		ereturn local estimates_note`n' "`text'"
	}
end

program rangenum
	args result colon value
	if ("`value'"=="L" | "`value'"=="l") { 
		local n = cond(e(estimates_note0)<., e(estimates_note0), 0)
		c_local `result' `n' 
	}
	else if ("`value'"=="F" | "`value'"=="f") { 
		c_local `result' 1
	}
	else {
		confirm integer number `value'
		c_local `result' `value'
	}
end
	

	



program note_parse
	args retn0 retn1 rethasin colon rest

	parse "`rest'", parse(" /")
	local hasin 0
	local i 1
	if ("`1'" == "in") {
		local hasin 1
		local ++i
		rangenum num0 : ``i''
		local num1 `num0'
		local ++i
		if "``i''"=="/" {
			local ++i
			rangenum num1 : ``i''
			local ++i
		}
		if "``i''" != "" { 
			error 198
		}
	}
	else if ("`1'"=="") {
		local num0 1
		local num1 9999
	}

	if `num1'<`num0' {
		error 198
	}


	local n = cond(e(estimates_note0)<., e(estimates_note0), 0)
	if (`num1'>`n') {
		local `num1' `n'
	}

	c_local `retn0' `num0'
	c_local `retn1' `num1'
	c_local `rethasin' `hasin'
end

program notesign 
	syntax

	local 0 "_*"
	capture syntax varlist
	if (_rc==0) {
		local subnote " (_variables omitted)"
		preserve 
		drop `varlist'
	}

	quietly _datasignature
	local sig `"`r(datasignature)'"'
	local fn  `"`c(filename)'"'
	local dt  `"`c(filedate)'"'

	if (`"`fn'"'=="") { 
		local line "File unknown"
	}
	else {
		local line `"File `fn'"'
		if (`"`dt'"'!="") {
			local line `"`line', last saved `dt'"'
		}
	}
	local line `"`line'; data signature `sig'`subnote'"'
	estimates_notes: `line'
	estimates_notes list in l
end
