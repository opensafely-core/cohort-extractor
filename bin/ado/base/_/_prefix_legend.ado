*! version 1.0.5  19feb2015
program _prefix_legend, sclass
	version 9
	syntax [name(name=caller)] [, NOIsily noLegend Verbose rclass * ]

	// NOTE: do not use any -rclass- commands within this program

	sreturn local col1 13

	if ("`legend'" != "") exit

	if `"`options'"' != "" {
		local 0 `", `options'"'
		syntax [,			///
			command(string asis)	///
			egroup(string asis)	///
			enames(string)		///
			group(string)		///
			names(string)		///
			express(string asis)	///
		]
		local k_eexp : word count `enames'
		local k_exp : word count `names'
		if `k_eexp' != `:word count `enames'' ///
		 | `k_exp'  != `:word count `names'' {
			// internal error, but exit silently
			exit
		}
		if "`verbose'" != "" {
			// also display the `eexp' expressions
			local group : list egroup | group
			local names `enames' `names'
		}
		else {
			// drop the expressions 1 to `k_eexp'
			forvalues k = 1/`k_eexp' {
				gettoken exp express : express, match(parens)
			}
		}
	}
	else {
		if "`rclass'" == "" {
			local e e
		}
		else	local e r
		// The following depends upon results in -e()- or -r()-:
		// 	e(command)	command called by prefix cmd
		// 	e(b)		vector of values
		// 	e(k_eexp)	number of values from eexp(s)
		// 	e(k_exp)	number of values from exp(s)
		local command	`"``e'(command)'"'
		local names : colna `e'(b)
		local group : coleq `e'(b), quote
		local group : list clean group
		local ek = `e'(k_eexp)
		local K = `ek' + `e'(k_exp)
		if (missing(`K')) {
			local K : word count `names'
			local ek `K'
			local verbose verbose
		}
		if `K' != `:word count `names'' {
			di as err ///
"estimation command error: `e'(k_eexp) or `e'(k_exp) is invalid"
			exit 322
		}
		if "`verbose'" == "" {
			if `ek' == `K' {
				local names
				local k1 0
			}
			else {
				local k1 = `ek' + 1
				forval i = 1/`ek' {
					gettoken junk names : names
					gettoken junk group : group
				}
			}
		}
		else	local k1 = 1
		if `k1' {
			local ugroup : list clean group
			local ugroup : list uniq ugroup
			if `"`ugroup'"' == "_" {
				local group
			}
			forval i = `k1'/`K' {
				local express `express' (``e'(exp`i')')
			}
		}
	}
	local K : word count `names'

	local mincol1 13
	if `"`group'"' != "" {
		local maxcol1 26
	}
	else	local maxcol1 13

	if `K' {
		tempname mname mgroup
		ListElementSizes `mincol1' `mname' : `names'
		if `"`group'"' != "" {
			ListElementSizes `mincol1' `mgroup' : `group'
			matrix `mname' = `mname' + `mgroup' + J(1,`K',2)
		}
		local col1 0
		forval i = 1/`K' {
			local size = `mname'[1,`i']
			local col1 = cond(`col1'<`size',`size',`col1')
		}

	}
	else	local col1 `mincol1'

	local col1 = ceil(cond(`col1'<`mincol1',`mincol1', ///
			  cond(`col1'>`maxcol1',`maxcol1',`col1')))
	local col2 = `col1' + 4
	local col2i = `col2' + 4

	sreturn local col1 `col1'

	if `K' == 0 & inlist("`caller'", "brr", "bootstrap", "jackknife") {
		// suppress "command:" if there is nothing else to display
		if ("`e(cmd)'" != "bstat") exit
	}
	else if `"`command'"' == "" {
		local blank di
	}

	if `"`noisily'"' != "" {
		if `"`caller'"' != "" {
			local dicaller "{cmd:`caller'} "
		}
		di as txt _n "`dicaller'legend:"
	}

	if `"`command'"' != "" {
		local c1 = 1+`col1'-udstrlen("command")
		di "{p2colset `c1' `col2' `col2i' 2}{...}"
		di as txt _n `"{p2col :command:}`command'{p_end}"'
	}

	if `K' == 0 {
		exit
	}

	forvalues k = 1/`K' {
		gettoken eq group : group
		if inlist(`"`eq'"',"","_") {
			local eq
			local delta 0
		}
		else	local delta 2
		gettoken name names : names
		local leq : udstrlen local eq
		local lna : udstrlen local name
		local len = `leq' + `lna' + `delta'
		if `"`eq'"' != "" {
			local eq = abbrev(`"`eq'"',`mincol1')
			local name = abbrev("`name'",`mincol1')
		}
		else	local name = abbrev("`name'",`col1')
		gettoken exp express : express, match(parens)
		if `"`exp'"' != "" {
			`blank'
			local blank
			local c1 = 1+`col1'-udstrlen("`eq'`name'")-`delta'
			di "{p2colset `c1' `col2' `col2i' 2}{...}"
			if "`eq'" != "" {
				local deq : di "{txt}[{res:`eq'}]"
			}
			di as txt `"{p2col :`deq'`name':}{res:`exp'}{p_end}"'
		}
	}
end

program ListElementSizes
	gettoken maxlen 0 : 0
	_on_colon_parse `0'
	local b `s(before)'
	local 0 `"`s(after)'"'
	local size : word count `0'
	matrix `b' = J(1,`size',0)
	forval i = 1/`size' {
		gettoken str 0 : 0
		matrix `b'[1,`i'] = min(`maxlen',`: udstrlen local str')
	}
end

exit
