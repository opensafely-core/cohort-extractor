*! version 1.0.4  20jan2015
program cluster_stop, rclass
	version 8

	syntax [anything(name=clname id="cluster name")] [, Rule(string) * ]

	cluster query
	local clnames `r(names)'
	if `"`clname'"' == "" {  // if no name -- take latest cluster anal.
		local clname : word 1 of `clnames'
	}

	cluster query `clname'
	local clname `r(name)'

	if "`clname'" == "" {
		di as err "no cluster solutions currently defined"
		exit 198
	}

	local len = length(`"`rule'"')
	if `"`rule'"' == bsubstr("calinski",1,max(3,`len')) | `"`rule'"' == "" {
		if `"`r(groupvar)'"' == "" { // hierarchical clustering
			Calinski_stop `clname' , `options'
		}
		else { // nonhierarchical clustering
			Calinski_stop `clname' , `options' ///
							groupvar(`r(groupvar)')
		}
		ret add
		exit
	}
	else if `"`rule'"' == "duda" {
		if `"`r(groupvar)'"' != "" {
			di as err ///
			"rule(duda) allowed only with hierarchical clustering"
			exit 198
		}
		Duda_stop `clname' , `options'
		ret add
		exit
	}
	else {  // See if there is a user defined stopping rule
		clstop_`rule' `clname' , `options'
		ret add
	}
end

program Calinski_stop, rclass

	syntax anything(name=clname) [, GRoups(numlist integer >1 sort)   ///
					MATrix(string) groupvar(varname)  ///
					VARiables(varlist numeric) ]

	if `"`matrix'"' != "" {
		local wcnt : word count `matrix'
		capture confirm name `matrix'
		if (`wcnt' > 1) | _rc {
			di as err "matrix() invalid"
			exit 198
		}
	}

	tempname esttmp bsum wsum

	if "`groupvar'" != "" {		// nonhierarchical clustering
		if "`groups'" != "" {
			di as err "groups() invalid"
			exit 198
		}

		Get_Vars_N `clname' `groupvar'	"`variables'"
		local vars `r(varlist)'
		local nn `r(num_groups)'
		local totN `r(N)'

		// about to repeatedly use -anova- and need to save users e()
		capture _estimates hold `esttmp' , restore

		// compute
		//      bsum = trace(between_groups_SS_mat) = trace(B)
		// and  wsum = trace(within_groups_SS_mat)  = trace(W)
		scalar `bsum' = 0
		scalar `wsum' = 0
		foreach vv of local vars {
			qui anova `vv' `groupvar'
			scalar `bsum' = `bsum' + e(mss)
			scalar `wsum' = `wsum' + e(rss)
		}
		ret scalar calinski_`nn' = (`bsum'/(`nn'-1))	///
						/ (`wsum'/(`totN'-`nn'))
		local toreport `nn'
		local maxdigs = floor(log10(`nn'))+1
		local tmp : di %9.2f `return(calinski_`nn')'
		local tmp `tmp'
		local tmp : length local tmp
		local maxwid = `tmp'
	}

	else {				// hierarchical clustering
		Get_Vars_N `clname' "" "`variables'"
		local vars `r(varlist)'
		local maxg `r(N)'

		// default to 2/15 or 2/(#groups-1) if less than 15
		if "`groups'" == "" {
			local gmax = min(`maxg'-1, 15)
			numlist "2/`gmax'"
			local groups `r(numlist)'
		}

		// check that asked for groups do not exceed available number
		numlist "`groups'" , range(>1 <`maxg')

		// about to repeatedly use -anova- and need to save users e()
		capture _estimates hold `esttmp' , restore

		local maxdigs 1
		local maxwid  1
		foreach nn of local groups {
			scalar `bsum' = 0
			scalar `wsum' = 0
			tempvar gvar`nn'
			cluster gen `gvar`nn'' = group(`nn'), ties(skip) ///
								name(`clname')
			capture confirm var `gvar`nn''
			if _rc {
				// if unable to generate nn # of groups then
				// go to the next iteration of the loop
				continue
			}

			// compute
			//      bsum = trace(between_groups_SS_mat) = trace(B)
			// and  wsum = trace(within_groups_SS_mat)  = trace(W)
			foreach vv of local vars {
				qui anova `vv' `gvar`nn''
				scalar `bsum' = `bsum' + e(mss)
				scalar `wsum' = `wsum' + e(rss)
			}
			capture drop `gvar`nn''

			//	compute and return Calinski-Harabasz =
			//	(trace(B)/(g-1))/(trace(W)/(N-g))
			//	which is a pseudo-F statistic

			ret scalar calinski_`nn' = (`bsum'/(`nn'-1))	///
							/ (`wsum'/(`maxg'-`nn'))
			local toreport `toreport' `nn'
			local maxdigs = max(`maxdigs',floor(log10(`nn'))+1)
			local tmp : di %9.2f `return(calinski_`nn')'
			local tmp `tmp'
			local tmp : length local tmp
			local maxwid = max(`maxwid',`tmp')
		}
	}

	if "`toreport'" == "" {
		exit
	}

	// return identifying information
	ret local rule "calinski"
	ret local label "C-H pseudo-F"
	ret local longlabel "Calinski & Harabasz pseudo-F"

	// place results in matrix if requested
	if "`matrix'" != "" {
		local wcnt : word count `toreport'
		nobreak {  // nobreak -- so that we don't leave corrupt matrix
			mat `matrix' = J(`wcnt',2,0)
			local j 0
			foreach i of local toreport {
				local ++j
				matrix `matrix'[`j',1] = `i'
				matrix `matrix'[`j',2] = `return(calinski_`i')'
			}
		}
	}

	// Display the results
	di
	di as txt "{c TLC}{hline 13}{c TT}{hline 13}{c TRC}"
	di as txt "{c |}             {c |}  Calinski/  {c |}
	di as txt "{c |}  Number of  {c |}  Harabasz   {c |}
	di as txt "{c |}  clusters   {c |}  pseudo-F   {c |}
	di as txt "{c LT}{hline 13}{c +}{hline 13}{c RT}"
	foreach i of local toreport {
		di as txt "{c |} " _c
		di as res "{center 11:{ralign `maxdigs':`i'}}" _c
		di as txt _col(15) "{c |} " _c
		local tmp : di %9.2f `return(calinski_`i')'
		local tmp `tmp'
		di as res "{center 11:{ralign `maxwid':`tmp'}}" _c
		di as txt _col(29) "{c |}"
	}
	di as txt "{c BLC}{hline 13}{c BT}{hline 13}{c BRC}"

end

program Duda_stop, rclass sortpreserve

	syntax anything(name=clname) [, GRoups(numlist integer >0 sort)   ///
				MATrix(string) VARiables(varlist numeric)]

	if `"`matrix'"' != "" {
		local wcnt : word count `matrix'
		capture confirm name `matrix'
		if (`wcnt' > 1) | _rc {
			di as err "matrix() invalid"
			exit 198
		}
	}

	Get_Vars_N `clname' "" "`variables'"
	local vars `r(varlist)'
	local maxg `r(N)'

	// Default to 1/15 or 1/(#groups-2) if less than 15
	if "`groups'" == "" {
		local gmax = min(`maxg', 17) - 2
		numlist "1/`gmax'"
		local groups `r(numlist)'
	}

	// Check that asked for groups do not exceed available number
	local gmax = `maxg' - 1
	numlist "`groups'" , range(>0 <`gmax')


	local maxdigs 1
	local maxwid  1
	local maxwid2 1
	foreach nn of local groups {
		local np1 = `nn' + 1
		tempvar gv`nn' gv2`nn' tmp`nn'

		capture cluster gen `gv`nn'' = group(`nn'), name(`clname')
		local bad = _rc
		capture cluster gen `gv2`nn'' = group(`np1'), name(`clname')
		if _rc | `bad' {
			// if unable to generate nn or nn+1 # of groups then
			// go to the next iteration of the loop
			capture drop `gv`nn'' `gv2`nn''
			continue
		}

		// Find the group that splits
		sort `gv`nn'' `gv2`nn''
		qby `gv`nn'' : gen `tmp`nn'' = 1  ///
				if `gv2`nn'' != `gv2`nn''[_n-1] & _n != 1

		tempname m`nn' m2a`nn' m2b`nn'

		// Get sum of squared errors within whole cluster
		qui summ `gv`nn'' if `tmp`nn'' == 1
		local g1 = r(min)
		qui mat accum `m`nn'' = `vars' if `gv`nn'' == `g1', noc dev
		scalar `m`nn'' = trace(`m`nn'')

		// Get sum of squared errors within subcluster 1
		qui summ `gv2`nn'' if `tmp`nn''[_n+1] == 1
		local g2a = r(min)
		qui summ `gv2`nn'' if `gv2`nn'' == `g2a'
		local n2a = r(N)
		if `n2a' > 1 {
			qui mat accum `m2a`nn'' = `vars' ///
						if `gv2`nn'' == `g2a', noc dev
			scalar `m2a`nn'' = trace(`m2a`nn'')
		}
		else {
			scalar `m2a`nn'' = 0
		}

		// Get sum of squared errors within subcluster 2
		qui summ `gv2`nn'' if `tmp`nn'' == 1
		local g2b = r(min)
		qui summ `gv2`nn'' if `gv2`nn'' == `g2b'
		local n2b = r(N)
		if `n2b' > 1 {
			qui mat accum `m2b`nn'' = `vars' ///
						if `gv2`nn'' == `g2b', noc dev
			scalar `m2b`nn'' = trace(`m2b`nn'')
		}
		else {
			scalar `m2b`nn'' = 0
		}


		//	Compute and return Duda-Hart Je(2)/Je(1)
		//	and the associated pseudo-t2 statistic
		ret scalar duda_`nn' = (`m2a`nn''+`m2b`nn'')/`m`nn''
		local tmp : di %9.4f `return(duda_`nn')'
		local tmp `tmp'
		local tmp : length local tmp
		local maxwid = max(`maxwid',`tmp')

		ret scalar dudat2_`nn' =			///
			((`m`nn''/(`m2a`nn''+`m2b`nn'')) - 1)	///
			* (`n2a' + `n2b' - 2)
		local tmp : di %9.2f `return(dudat2_`nn')'
		local tmp `tmp'
		local tmp : length local tmp
		local maxwid2 = max(`maxwid2',`tmp')

		local toreport `toreport' `nn'
		local maxdigs = max(`maxdigs',floor(log10(`nn'))+1)

		capture drop `gv`nn'' `gv2`nn'' `tmp`nn''
		capture scalar drop `m`nn'' `m2a`nn'' `m2b`nn''
	}

	if "`toreport'" == "" {
		exit
	}

	// return identifying information
	ret local rule "duda"
	ret local label "D-H Je(2)/Je(1)"
	ret local longlabel "Duda & Hart Je(2)/Je(1)"
	ret local label2 "D-H pseudo T-squared"
	ret local longlabel2 "Duda & Hart pseudo T-squared"

	// place results in matrix if requested
	if "`matrix'" != "" {
		local wcnt : word count `toreport'
		nobreak {  // nobreak -- so that we don't leave corrupt matrix
			mat `matrix' = J(`wcnt',3,0)
			local j 0
			foreach i of local toreport {
				local ++j
				matrix `matrix'[`j',1] = `i'
				matrix `matrix'[`j',2] = `return(duda_`i')'
				matrix `matrix'[`j',3] = `return(dudat2_`i')'
			}
		}
	}


	// Display the results
	di
	di as txt "{c TLC}{hline 13}{c TT}{hline 27}{c TRC}"
	di as txt "{c |}             {c |}         Duda/Hart         {c |}"
	di as txt "{c |}  Number of  {c |}             {c |}  pseudo     {c |}"
	di as txt "{c |}  clusters   {c |} Je(2)/Je(1) {c |}  T-squared  {c |}"
	di as txt "{c LT}{hline 13}{c +}{hline 13}{c +}{hline 13}{c RT}"
	foreach i of local toreport {
		di as txt "{c |} " _c
		di as res "{center 11:{ralign `maxdigs':`i'}}" _c
		di as txt _col(15) "{c |} " _c
		local tmp : di %9.4f `return(duda_`i')'
		local tmp `tmp'
		di as res "{center 11:{ralign `maxwid':`tmp'}}" _c
		di as txt _col(29) "{c |} " _c
		local tmp : di %9.2f `return(dudat2_`i')'
		local tmp `tmp'
		di as res "{center 11:{ralign `maxwid2':`tmp'}}" _c
		di as txt _col(43) "{c |}"
	}
	di as txt "{c BLC}{hline 13}{c BT}{hline 13}{c BT}{hline 13}{c BRC}"
end

program Get_Vars_N, rclass

	args clname grpvar variables

	cluster query `clname'

	if "`variables'" == "" {
		local i 1
		while `i' {
			if `"`r(o`i'_tag)'"' == "" {
				continue, break
			}
			if `"`r(o`i'_tag)'"' == "varlist" {
				local vlist `r(o`i'_val)'
				continue, break
			}
			local ++i
		}
	}
	else {
		local vlist `variables'
	}

	if "`vlist'" == "" {
		local i 1
		while `i' {
			if `"`r(o`i'_tag)'"' == "" {
				continue, break
			}
			if `"`r(o`i'_tag)'"' == "cmd" {
				local cmd `r(o`i'_val)'
				local cmd : word 1 of `cmd'
				continue, break
			}
			local ++i
		}

		if "`cmd'" == "clustermat" {
			di as err "variables() option required after clustermat"
			exit 198
		}

		di as err "{p}"
		di as err "original varlist was not saved in `clname'"
		di as err "(it was likely created using Stata 7);{break}"
		di as err "if you know the original variable names you can"
		di as err "type -cluster set `clname' , other(varlist"
		di as err "{it:original_varlist})- and try again or you can"
		di as err "use the variables({it:original_varlist}) option of"
		di as err "cluster stop"
		di as err "{p_end}"
		exit 198
	}

	if "`grpvar'" == "" {
		local ordvar `r(ordervar)'
		if "`ordvar'" == "" {
			di as err "`clname' is corrupted"
			exit 198
		}
		qui summ `ordvar'
		ret local N `r(max)'
	}
	else {
		qui summ `grpvar'
		ret local num_groups `r(max)'
		ret local N `r(N)'
	}

	ret local varlist `vlist'
end
