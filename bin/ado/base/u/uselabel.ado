*! version 1.1.10  07nov2016
program define uselabel
	version 8

	global T_uselabel_clear
	capture noisily Uselabel_u `0'
	local rc = _rc
	nobreak {
		if "$T_uselabel_clear" != "" {
			quietly drop _all
			quietly label drop _all
		}
	}
	exit `rc'
end


program define Uselabel_u, rclass
	syntax [anything(name=lablist)] [using/] [, CLEAR REPLACE Var]

	if `"`lablist'"' == "" | `"`lablist'"' == "_all" {
		local lablist  	/* *all* value labels */
	}
	else {
		capture noi confirm name `lablist'
		if _rc {
			exit 198
		}
	}

	if "`replace'" != "" {
		local clear clear
	}
						/* parsing complete 	*/
	if "`clear'" == "" {
		qui desc, short
		if r(changed) {
			error 4
		}
	}

	if `"`using'"' != "" {
		global T_uselabel_clear TRUE
		quietly {
			drop _all
			label drop _all
			use `"`using'"' , clear
		}
	}

	if "`lablist'" != "" {
		quietly label list `lablist'	/* verify labels exists	*/
	}
	else {
		quietly label dir
		local lablist `r(names)'
	}

	if "`var'" != "" {
		capt label language
		if _rc==198 {
			local olns
		}
		else {
			local lns `r(languages)'
			local cln `r(language)'
			local olns : list lns - cln
		}

		foreach v of varlist _all {
			capt local vt : value label `v'
			if "`vt'" != "" & `:list vt in lablist' {
				return local `vt' `return(`vt')' `v'
			}

			foreach ln of local olns {
				capt local vt : char `v'[_lang_l_`ln']
				if "`vt'" != "" & `:list vt in lablist' {
					return local `vt'_`ln' `return(`vt'_`ln')' `v'
				}
			}
		}

		// use awkward macro names to prevent name conflict with value labels
		return local __current_language__ `cln'
		return local __other_languages__  `olns'
		return local __labnames__         `lablist'
	}

	quietly {
		tempfile labfile
		label save `lablist' using `"`labfile'"'
		global T_uselabel_clear TRUE
		drop _all
		label drop _all

		local strlen = c(maxstrvarlen)

		local max = 100 // block size for appending obs
		set obs `max'

		gen lname = ""
		gen double value = .
		gen label = ""
		gen byte trunc = 0

		tempname fh
		file open `fh' using `"`labfile'"', text read
		local i = 0
		file read `fh' line
		while r(eof)==0 {
			local ++i
			if `i' > `max' {
				local max = `max' + 100
				set obs `max'
				replace trunc = 0 in -100/l
			}
			gettoken word    line : line // label
			gettoken word    line : line // define
			gettoken labname line : line
			gettoken value   line : line
			gettoken ltext   line : line, parse(", ") match(paren)
			replace lname =  "`labname'" in `i'
			replace value =  `value' in `i'
			replace label =  `"`ltext'"' in `i'
			local length : length local ltext
			if (`length' > `strlen') {
				replace trunc = 1 in `i'
			}
		      	file read `fh' line
		}
		file close `fh'
		drop if _n > `i'
		if _N==0 {
			noi di as txt "(dataset has no value labels)"
			return clear
			exit
		}
		compress
		sort lname value
	}
	global T_uselabel_clear
end
exit
