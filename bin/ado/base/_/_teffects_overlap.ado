*! version 1.0.4  19jun2015 
// parsing facility to retrieve kernel name
program _get_kernel_name, sclass
        syntax , KERNEL(string)
        local kernlist epan2 epanechnikov biweight      ///
                        cosine gaussian parzen          ///
                        rectangle triangle
        local maxabbrev 5 2 2 3 3 3 3 3
        tokenize `maxabbrev'
        local i = 1
	local done = 0
        foreach kern of local kernlist {
                if bsubstr("`kern'",1,length(`"`kernel'"')) == `"`kernel'"' ///
                                             & length(`"`kernel'"') >= ``i'' {
                        sreturn local kernel `kern'
			local done = 1
                        continue, break
                }
                local ++i
        }
	assert `done' == 1
end


program _teffects_overlap, rclass
	version 13
	syntax  [,				///
		PTlevel(string) 		///
		TLevels(string) 		/// 
		Kernel(string)			///
		BWidth(string)			///
		AT(varname)			///
		N(string)			///
		noLABel				///
		addplot(string)			///
		*				///
                ]

	if ("`addplot'" != "") {
		preserve
	}
	if (inlist("`e(subcmd)'","ra")) {
di as error "{bf:teffects overlap} not supported after {bf:ra} estimation"
		exit 321
	}
	if (inlist("`e(subcmd)'","nnmatch")) {
di as error "{bf:teffects overlap} not supported after {bf:nnmatch} estimation"
		exit 321
	}

		
	if ("`kernel'" != "") {
		capture _get_kernel_name, kernel(`kernel')
		local kernel `s(kernel)'
		if _rc {
			di as err "`kernel' invalid kernel function"
			exit 198
		}	
	}
	else {
		local kernel triangle
	}			
	if ("`at'" != "") {
		local at at(`at')
		capture assert "`n'" == ""
		if _rc {
			di as error ///
			"cannot specify both {bf:at()} and {bf:n()}"
			exit 198
		}
	}
	if ("`n'" == "" & "`at'" == "") {
		local n = e(N)
		local n n(`n')
	}
	else if ("`n'" != "") {
		local n n(`n')
	}
	if ("`bwidth'" != "") {
		capture assert `bwidth' > 0
		if (_rc) {
			di as error "bwidth() must be positive"
			exit 498
		}
		local bwidth bwidth(`bwidth')	
	}
			
	// check data not changed?
	// done in psmatch post
	local postlevels `e(tlevels)'
	local nlevs: word count `postlevels'  
				
	local validtrt = 0
	if ("`ptlevel'" == "") {
		local sortedlevels: list sort postlevels
		local ptlevel: word 1 of `sortedlevels'		
		local validtrt = 1
	}
	else if (missing(real("`ptlevel'"))) {
		local vlab : value label `e(tvar)'
		if "`vlab'" != "" {
			forvalues i=1/`nlevs' {
				local l : label `vlab' `i'
				if "`l'" == "`ptlevel'" {
					local validtrt = 1
					local ptlevel : word `i' of `postlevels'
					continue, break
				}
			}

		}
	}
	else {
		local validtrt : list posof "`ptlevel'" in postlevels
	}
	if (!`validtrt') {
		di as error "`tlevel' invalid argument to {bf:ptlevel()}"
		exit 198
	}

	if ("`tlevels'" == "") {
		local tlevels `postlevels'
	}
	else {
		foreach tnum of local tlevels {
			local validtrt = 0
			forvalues i = 1/`nlevs' {
				local j: word `i' of `postlevels'
				if ("`tnum'" == "`j'") {
					local validtrt = 1
					continue, break
				}
			}
			if !`validtrt' {
				di as error ///
				"{p 0 4 2}{bf:tlevels()} must contain"
				di as error " valid treatment level;"
				di as error ///
				" `tnum' is not a valid treatment level"	
				exit 198
			}			
		}		
	}
	local nlevs : list sizeof tlevels
	
	// get line#opts properly stored
	// and form legend label list
	local lopts
	forvalues tnum=1/`nlevs' {
		local lopts `lopts' line`tnum'opts(string)
	}
	local 0 , `options'
	syntax [, `lopts' *]
	_get_gropts , graphopts(`options')
	
	forvalues tnum=1/`nlevs' {
		local sort`tnum' sort
		noi 	capture _get_gropts, graphopts(`line`tnum'opts') ///
			getallowed(addplot)
		if _rc {
			di as error "in {bf:line`tnum'opts()}"
			exit 191
		}
		if ("`s(addplot)'" != "") {
			di as error ///
			"{bf:addplot()} not allowed in {bf:line`tnum'opts()}" 
			exit 198
		}		
		if "`s(sort)'" != "" {
			local sort`tnum'
		}
	}
 
	tempvar prpt
	if ! inlist("`e(subcmd)'","nnmatch","psmatch") {
		qui predict `prpt' if e(sample), ps tlevel(`ptlevel') 
	}
	else {
		if "`e(indexvar)'" == "" {
			di as txt "{p 0 6 2}note: refitting the model " ///
			 "using the {bf:generate()} option{p_end}"
			tempname ix est
			qui estimates store `est'

			local ix `ix'_
			_tebalance_cmd_generate `ix'
			local cmd `"`s(cmdline)'"'
		}
		cap {
			if `"`cmd'"' != "" {
				`cmd'
			}
			predict `prpt', ps tlevel(`ptlevel') 
		}
		local rc = c(rc)
		if "`ix'" != "" {
			qui drop `e(indexvar)'
		}
		if (`rc') {
			di as err "{p}computing the probabilities failed; " ///
			 "the overlap graph cannot be displayed{p_end}"
			exit 492
		}
	}
	local abtvar = abbrev("`e(tvar)'",8)
	local lab
	if ("`label'" != "nolabel") {	
		local lab: value label `e(tvar)'
	}
	if ("`lab'" != "") {
		local ptlevel: label `lab' `ptlevel'
	}	
	local title `"density"' 
	label variable `prpt' `"Propensity score, `abtvar'=`ptlevel'"'

	local glist
	forvalues i=1/`nlevs' {
		local tnum : word `i' of `tlevels'
		tempvar x`tnum' den`tnum'
		kdensity `prpt' if `e(tvar)'==`tnum' & e(sample), ///
				generate(`x`tnum'' `den`tnum'')   ///
				kernel(`kernel') `bwidth' `n' `at' nograph
		return scalar bwidth`tnum' = r(bwidth)
		return scalar n`tnum' = r(n)
		return scalar scale`tnum' = r(scale)
	        if ("`lab'" != "") {
			local tnuml: label `lab' `tnum'
                }
		else {
			local tnuml `tnum'
		}
		label variable `den`tnum'' `"`abtvar'=`tnuml'"'		
		local glist `glist' ///
			(line `den`tnum'' `x`tnum'', `line`i'opts' ///
			`sort`i'')
		
	}
	twoway `glist', ytitle(`"`title'"') `options'
	if "`addplot'" != "" {
		restore
		version 8: graph addplot `addplot' ||
	}
	return local kernel `kernel'
end
exit

