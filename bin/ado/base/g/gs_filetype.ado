*! version 1.2.1  21nov2019
program gs_filetype, rclass
	local 0 `"using `macval(0)'"'
	syntax using/ [, SUFFIX]

	if "`suffix'"!="" {
		local dup : subinstr local using "/" " ", all
		local dup : subinstr local dup   "\" " ", all
		local n   : word count `dup'
		local last: word `n' of `dup'
		if index("`last'", ".") == 0 {
			local using `"`using'.gph"'
		}
	}
	ret local fn `"`using'"'

	tempname h b1 b2 b3 b4

	local s7_min   8
	local s7_max   8

	local asis_min 33		// asis formats we understand
	local asis_max 36

	local live_minfmt 1		// live formats we understand
	local live_maxfmt 7			// compared to gversion
	local live_mincode 1			// compared to clsversion
	local live_maxcode 7

	file open `h' using `"`using'"', read bin
	file read `h' %1bu `b1' %1bu `b2' %1bu `b3' %1bu `b4'
	file close `h'

					// Try old and asis
	if `b1'==129 & `b2'==132 & (`b4'==1 | `b4'==2) {
		if `b3'>=01 & `b3'<=04 {
			ret local olddtl "real"
			ret local ft "old"
			exit
		}
		if `s7_min'<=`b3' & `b3'<=`s7_max' {
			ret local olddtl "emulation"
			ret local ft "old"
			exit
		}
		if `asis_min'<=`b3' & `b3'<=`asis_max' {
			ret local ft "asis"
			exit
		}
		if `b3'>`asis_max' {
			TooNew `"`using'"'
		}
		NotGph
	}

					// Try live
	if !(`b1'==83 & `b2'==116) {
		NotGph
	}

					// Read StataFileTM header
	file open `h' using `"`using'"', read text
	file read `h' line

	if length(`"`line'"') > 80 { 
		NotGph `"`using'"'
	}
	if bsubstr(`"`line'"',1,12) != "StataFileTM:" {
		NotGph `"`using'"'
	}
	local 0 `"`line'"'
	gettoken tok 0 : 0, parse(": ")		// StataFileTm
	gettoken tok 0 : 0, parse(": ")		// :
	gettoken tok 0 : 0, parse(": ")		// <#_format>


	if "`tok'"== "00001" {
		gettoken tok 0 : 0, parse(": ")		// :
		gettoken tok 0 : 0, parse(": ")		// <#_ft>
		if "`tok'" != "01000" {
			NotGph `"`using'"'
		}
							// Read gph line
		file read `h' line
		gettoken tok line : line, parse(": ")	// vernum
		capture confirm number `tok'
		if _rc {
			NotGph `"`using'"'
		}
		if `tok'<`live_minfmt' {
			TooOld `"`using'"'
		}
		if `tok'>`live_maxfmt' {
			TooNew `"`using'"'
		}
		ret scalar fversion = `tok'

		gettoken tok line : line, parse(": ")	/* :		*/
		gettoken tok line : line, parse(": ")	/* codever	*/
		capture confirm number `tok'
		if _rc {
			NotGph `"`using'"'
		}
		if `tok'<`live_mincode' {
			TooOld `"`using'"'
		}
		if `tok'>`live_maxcode' {
			TooNew `"`using'"'
		}
		ret scalar cversion = `tok'
		ret local ft "live"
		exit
	}
	TooNew `"`using'"'
end

program NotGph
	args using lookingfor
	di as err "{p}"
	di as err `"file `using' not a Stata .gph file"'
	di as err "{p_end}"
	exit 610
end

program TooNew
	args using
	di as err "{p}"
	di as err `"file `using' is a new format that this version of Stata"'
	di as err "does not know how to read"
	di as err "{p_end}"
	exit 610
end

program TooOld
	args using
	di as err "{p}"
	di as err `"file `using' is an old format that Stata"
	di as err "no longer knows how to read"
	di as err "{p_end}"
	exit 610
end
