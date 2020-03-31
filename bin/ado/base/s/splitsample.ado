*! version 1.0.0  05may2019
program splitsample, sortpreserve rclass
	version 16

	local vv : di "version " string(_caller()) ":"

	syntax [varlist(default=none fv)] [if] [in],	///
		GENerate(string)			///
		[ 					///
		NSPLIT(passthru)			///
		SPLIT(passthru)				///
		VALUEs(passthru)			///
		CLuster(varname)			/// strok always
		BALance(varlist)			/// strok always
		RROUND					///
		STROK					///
		RSEED(string)				///
		SHOW					///
		PERCENT					///
		]

	// Check syntax.

	ParseGenerate `generate'
	local generate `s(generate)'

	CheckSyntaxOfSplit, `nsplit' `split' `values' `rround'
	local nsplit      `s(nsplit)'
	local nsplit_true `s(nsplit_true)'  // for rround

	if ("`varlist'" != "" & "`strok'" == "") {

		cap confirm numeric variable `varlist'
		if (c(rc)) {
			foreach var of local varlist {
				cap confirm numeric variable `var'
				if (!c(rc)) {
					local newvarlist `newvarlist' `var'
				}
			}

			local varlist : copy local newvarlist
		}
	}
	
	if ("`show'" == "" & "`percent'" != "") {

di as error "{bf:percent} must be specified with option {bf:show}"
			
		exit 198
	}

	// Markout.

	marksample touse, `strok'
	markout `touse' `cluster' `balance', strok

	qui replace `touse' = -`touse' // for sort order

	if ("`balance'" != "" & "`cluster'" != "") {
		assertnested `cluster' if `touse', within(`balance')
	}

	// Sample size. rround requires # obs (or clusters) >= nsplit.

	CheckSampleSize if `touse', nsplit(`nsplit') `split'              ///
	                            cluster(`cluster') balance(`balance') ///
	                            `rround'

	local N          `r(N)'
	local n_clusters `r(n_clusters)'

	// Set seed and save state.

	if (`"`rseed'"' != "") {
		`vv' set seed `rseed'
	}

	local rngstate `c(rngstate)'

	tempvar splitvar

	if ("`rround'" != "") {
		RandomRounding `splitvar' if `touse',         ///
			nsplit(`nsplit') `split' `values'     ///
			cluster(`cluster') balance(`balance') ///
			`show'
	}
	else {
		DeterministicRounding `splitvar' if `touse',     ///
			nsplit(`nsplit') n(`N') nc(`n_clusters') ///
			`split' `values'                         ///
			cluster(`cluster') balance(`balance')    ///
			`show'

		local n_samples `r(n_samples)'
	}

	// Set return.

	return local rngstate `rngstate'

	if ("`balance'" != "") {
		qui tab `splitvar' if `touse'
		return scalar n_samples = r(r)
		return local balancevars `balance'
	}
	else if ("`rround'" != "") {
	
		// When rround and no balance, guaranteed to have 
		// n_samples = nsplit since # obs or # clusters must 
		// be >= nsplit.
		
		return scalar n_samples = `nsplit_true'
	}
	else {
		return scalar n_samples = `n_samples'
	}

	if ("`cluster'" != "") {
		return scalar N_clust = `n_clusters'
		return local clustvar `cluster'
	}

	return scalar N = `N'

	cap drop `generate'

	rename `splitvar' `generate'

	// Display split.

	if ("`show'" != "") {
		Display `generate' if `touse', cluster(`cluster') ///
		                               balance(`balance') ///
				               `percent'
	}
end

///////////////////////// Parsing and syntax checking //////////////////////////

program ParseGenerate, sclass
	syntax [name] [, REPLACE ]

	if ("`namelist'" == "") {

		if ("`replace'" != "") {
			di as error "{p}"
			di as error "option {bf:replace} must be specified"
			di as error "after a {it:newvarname}"
			di as error "{p_end}
			exit 198
		}
	}
	else if ("`replace'" == "") {
		confirm new variable `namelist'
	}

	sreturn local generate `namelist'
end

program CheckSyntaxOfSplit, sclass
	syntax [, nsplit(numlist integer max=1 >0)      ///
		  split(numlist >0) 		        ///
		  values(numlist integer >=0 ascending) ///
		  rround			        ///
	       ]

	// rround requires split() to be integers.

	if ("`rround'" != "" & "`split'" != "") {

		local 0 , split(`split')

		cap noi syntax , split(numlist integer)

		if (c(rc) == 126) {
			di as error "{p 4 4 2}"
			di as error "Option {bf:rround} requires elements of"
			di as error "{bf:split()} {it:numlist} to be integers."
			di as error "{p_end}"
			exit 126
		}
		else if (c(rc)) {
			exit c(rc)
		}
	}

	// Check split() and nsplit() if both specified.

	if ("`split'" != "") {
		local nsize : list sizeof split

		if ("`nsplit'" != "") {
			if (`nsize' != `nsplit') {
				di as error "{p}"
				di as error "conflict between option"
				di as error "{bf:split()} and option"
				di as error "{bf:nsplit()}"
				di as error "{p_end}"
				di as error "{p 4 4 2}"
				di as error "Option {bf:split()} specified"
				di as error "splitting into `nsize' samples and"
				di as error "option {bf:nsplit()} specified"
				di as error "`nsplit' samples. Only one of "
				di as error "{bf:split()} or {bf:nsplit()}"
				di as error "required."
		    		di as error "{p_end}"
		    		exit 198
		    	}
		}

		local nsplit `nsize'
	}
	else if ("`nsplit'" == "") {
		local nsplit 2  // default
	}

	// Check size of values().

	if ("`values'" != "") {
		local vsize : list sizeof values

		if (`vsize' != `nsplit') {
			di as error "{p}"
			di as error "option {bf:values()} must be a numlist"
			di as error "with `nsplit' values"
		    	di as error "{p_end}"
			exit 198
		}
	}

	// Reset nsplit when rround and split() specified.

	if ("`rround'" != "") {
	
		sreturn local nsplit_true `nsplit'
	
		if ("`split'" != "") {

			tempname S

			matrix input `S' = (`split')

			matrix `S' = `S'*J(colsof(`S'), 1, 1)

			local nsplit = `S'[1, 1]
		}
	}

	sreturn local nsplit `nsplit'
end

program CheckSampleSize, rclass
	syntax if/, nsplit(integer)     ///
		    [		        ///
		      split(numlist)    ///
		      cluster(varname)  ///
		      balance(passthru) ///
		      rround	        ///
		    ]

	local touse `if'

	qui count if `touse'
	if (r(N) == 0) {
		error 2000
	}

	return scalar N = r(N)

	if ("`cluster'" != "") {
		tempvar nclust
		qui bysort `touse' `cluster': gen double `nclust' = 1 ///
			if _n == 1 & `touse'

		qui count if `nclust' == 1

		return scalar n_clusters = r(N)
	}

	local N `r(N)'  // # obs or clusters

	if ("`rround'" == "") {
		exit
	}

	// When rround, check how many subsamples need to be created.
	
	local nd : di %15.0fc `nsplit'
	local nd `nd'  // trim

	local Nd : di %15.0fc `N'
	local Nd `Nd'  // trim

	if ("`cluster'" != "") {
		local units clusters
	}
	else {
		local units observations
	}

	if (`nsplit' > `N') {
		
		di as error "{p}"
		di as error "insufficient `units' for option {bf:rround}"
		di as error "{p_end}"

		if ("`split'" != "") {
			di as error "{p 4 4 2}"
			di as error "Option {bf:rround} needs to generate"
			di as error "{it:n} subsamples, where {it:n} = `nd'"
			di as error "is the sum of the elements of"
			di as error "{bf:split()}. {it:n} must be less than"
			di as error "or equal to `Nd', the number of `units'."
			di as error "{p_end}"
		}
		else {
			di as error "{p 4 4 2}"
			di as error "{bf:nsplit()} must be less than or equal"
			di as error "to the number of `units' when option"
			di as error "{bf:rround} specified. {bf:nsplit()} is"
			di as error "`nd' and the number of `units' is `Nd'."
			di as error "{p_end}"
		}

		exit 2001
	}
	
	if ("`balance'" == "") {
		exit
	}

	// When rround and balance, we may need to expand data. 
	// We impose a limit on the number of new observations
	// created by -expand-.

	SizeOfBalanceExpand if `touse', nsplit(`nsplit') `balance'

	if (r(N_new) > max(10*_N, 1e5)) {  // limit on -expand- new obs

		di as error "{p}"
		di as error "insufficient `units' in {bf:balance()} groups"
		di as error "for option {bf:rround}"
		di as error "{p_end}"

		di as error "{p 4 4 2}"

		if ("`split'" != "") {
			di as error "Option {bf:rround} needs to generate"
			di as error "{it:n} subsamples, where {it:n} = `nd' is"
			di as error "the sum of the elements of {bf:split()}."
			di as error "The number of subsamples"
		}
		else {
			di as error "The number of samples requested"
		}
			
		di as error "is too large relative to the number of `units'"
		di as error "in the {bf:balance()} groups."
		di as error "{p_end}"

		exit 2001
	}
end

///////////////////////// Main program for no -rround- /////////////////////////

program DeterministicRounding, rclass
	syntax name(name=svar) if/, nsplit(integer)     ///
	                            n(integer)          ///
				    [                   ///
				      nc(numlist max=1) ///
				      split(passthru)   ///
				      values(passthru)  ///
				      cluster(passthru) ///
				      balance(passthru) ///
				      show              ///
				    ]
	local touse `if'

	if ("`nc'" != "") {  // use number of clusters
		local n `nc'
	}

	tempname min N V

	// Get N = vector with cumulative counts for splitting.

	SplitAt, nsplit(`nsplit') n(`n') `split' `balance'

	scalar `min' = r(min)   // required for balance to detect gaps
	matrix `N'   = r(split)

	// Look for gaps (samples of size zero) and process `values'.

	Values, `values' nmatrix(`N')

	local n_samples = `nsplit' - r(n_gaps)

	matrix `V' = r(values)

	// Do split.

	if ("`balance'" != "" & "`cluster'" != "") {
		SplitBalanceCluster `svar' if `touse', n(`N') min(`min') ///
			`balance' `cluster' `show'
	}
	else if ("`balance'" != "" & "`cluster'" == "") {
		SplitBalance `svar' if `touse', n(`N') min(`min') ///
		                                `balance' `show'
	}
	else if ("`balance'" == "" & "`cluster'" != "") {
		SplitCluster `svar' if `touse', n(`N') `cluster'
	}
	else {
		Split `svar' if `touse', n(`N')
	}

	// Map 1, 2, ... to values().
	//
	// Note: Always have to do this since sample numbering may have been
	//       adjusted for gaps.

	qui replace `svar' = `V'[1, `svar'] if `touse'

	return scalar n_samples = `n_samples'
end

///////////////////////// Subroutines for no -rround- //////////////////////////

program SplitAt, rclass
	syntax , nsplit(integer)     ///
		 n(integer)          ///
		 [	             ///
		   split(numlist)    ///
		   balance(passthru) ///
		 ]

	tempname matrix min

	if ("`split'" != "") {
		matrix input `matrix' = (`split')
	}

	if ("`balance'" != "") {
		tempname min

		mata: Nsplit("`matrix'", "`min'", `nsplit')

		return scalar min = `min'
	}
	else {
		mata: NsplitRound("`matrix'", `nsplit', `n')
	}

	return matrix split = `matrix'
end

program Values, rclass
	syntax , Nmatrix(name) [ values(numlist) ]

	tempname vmatrix gmatrix

	if ("`values'" != "") {
		matrix input `vmatrix' = (`values')
	}

	mata: Nfix("`nmatrix'", "`vmatrix'", "`gmatrix'")

	return matrix values = `vmatrix'

	cap local n = colsof(`gmatrix')
	if (c(rc) == 111) {  // no gaps
		return scalar n_gaps = 0
		exit
	}
	else if (c(rc)) {
		exit c(rc)
	}

	// If here, there are gaps.

	local gap = `gmatrix'[1, 1]

	di as text "{p 0 6 2}"
	di as text "note: sample `gap' has no observations because specified"
	di as text "split proportion for that sample is too small"
	di as text "{p_end}"

	local n_gaps 1

	forvalues i = 2/`n' {

		local gap = `gmatrix'[1, `i']

		local ++n_gaps

		di as text "{p 6 6 2}"
		di as text "sample `gap' has no observations because specified"
		di as text "split proportion for that sample is too small"
		di as text "{p_end}"
	}

	return scalar n_gaps = `n_gaps'
end

program Split
	syntax name(name=svar) if/, n(name)
	local touse `if'

	quietly {
		tempvar r1 r2

		gen double `r1' = runiform() if `touse'
		gen double `r2' = runiform() if `touse'

		sort `touse' `r1' `r2'

		gen byte `svar' = 1 in 1  // guaranteed since `touse' == -1

		replace `svar' = cond(_n <= `n'[1, `svar'[_n - 1]],       ///
				      `svar'[_n - 1], `svar'[_n - 1] + 1) ///
				 if _n > 1 & `touse'
	}
end

program SplitCluster
	syntax name(name=svar) if/, n(name) cluster(varname)
	local touse `if'

	quietly {
		tempvar r1 r2 order

		bysort `touse' `cluster': gen double `r1' = runiform() ///
			if _n == 1 & `touse'

		by     `touse' `cluster': gen double `r2' = runiform() ///
			if _n == 1 & `touse'

		by `touse' `cluster': replace `r1' = `r1'[1]
		by `touse' `cluster': replace `r2' = `r2'[1]

		bysort `touse' `r1' `r2' (`cluster'): gen double `order' = ///
			(_n == 1) if `touse'

		replace `order' = sum(`order') if `touse'

		gen byte `svar' = 1 in 1  // guaranteed since `touse' == -1

		replace `svar' = cond(`order' <= `n'[1, `svar'[_n - 1]],  ///
				      `svar'[_n - 1], `svar'[_n - 1] + 1) ///
				 if _n > 1 & `touse'
	}
end

program SplitBalance
	syntax name(name=svar) if/, n(name) min(name) balance(varlist) ///
	                            [ show ]
	local touse `if'

	quietly {
		tempvar r1 r2 N

		gen double `r1' = runiform() if `touse'
		gen double `r2' = runiform() if `touse'

		sort `touse' `balance' `r1' `r2'

		drop `r1' `r2'

		local by "by `touse' `balance':"

		`by' gen byte `svar' = 1 if _n == 1 & `touse'

		`by' replace `svar' = 				     ///
			cond(_n <= round(`n'[1, `svar'[_n - 1]]*_N), ///
			     `svar'[_n - 1], `svar'[_n - 1] + 1)     ///
			if _n > 1 & `touse'

		// If `min'*_N < 1, there could be gaps and svar is wrong.

		`by' gen double `N' = _N if _n == 1 & `touse'

		su `N', meanonly

		if (`min'*r(min) >= 1) { // guaranteed to have no gaps
			exit
		}

		drop `N'

		// Fix svar. It must be increased after a gap.

		tempvar new old

		rename `svar' `old'

		local nsplit = colsof(`n')
		local imax   = `nsplit' - 1

		forvalues i = 1/`imax' { // should exit much earlier

			`by' gen `:type `old'' `new' =			     ///
				cond(   _n >  round(`n'[1, `old'    ]*_N)    ///
				     &  _n <= round(`n'[1, `old' + `i']*_N), ///
				     `old' + `i', `old')		     ///
				if `touse'

			cap assert `new' == `old'
			if (c(rc) == 0) {
				continue, break
			}
			else if (c(rc) == 9) {
				if (`i' < `imax') {
					drop `old'
					rename `new' `old'
				}
			}
			else {
				error c(rc)
			}
		}

		rename `new' `svar'
	}

	CheckBalance `svar' if `touse', nsplit(`nsplit') balance(`balance') ///
	                                `show'
end

program SplitBalanceCluster
	syntax name(name=svar) if/, n(name) min(name)                 ///
				    balance(varlist) cluster(varname) ///
				    [ show ]
	local touse `if'

	quietly {
		tempvar r1 r2 order N

		local sort `touse' `balance'

		bysort `sort' `cluster': gen double `r1' = runiform() ///
			if _n == 1 & `touse'

		by     `sort' `cluster': gen double `r2' = runiform() ///
			if _n == 1 & `touse'

		by `sort' `cluster': replace `r1' = `r1'[1]
		by `sort' `cluster': replace `r2' = `r2'[1]

		bysort `sort' `r1' `r2' `cluster': gen double `order' = ///
			(_n == 1) if `touse'

		drop `r1' `r2'

		by `sort': replace `order' = sum(`order') if `touse'

		by `sort': gen byte `svar' = 1 if _n == 1 & `touse'

		by `sort': replace `svar' = cond(`order' <=	   ///
			round(`n'[1, `svar'[_n - 1]]*`order'[_N]), ///
			`svar'[_n - 1], `svar'[_n - 1] + 1)        ///
			if _n > 1 & `touse'

		// If `min'*_N < 1, there could be gaps and svar is wrong.

		by `sort': gen double `N' = `order'[_N] if _n == 1 & `touse'

		su `N', meanonly

		if (`min'*r(min) >= 1) { // guaranteed to have no gaps
			exit
		}

		drop `N'

		// Fix svar. It must be increased after a gap.

		tempvar new old

		rename `svar' `old'

		local nsplit = colsof(`n')
		local imax   = `nsplit' - 1

		forvalues i = 1/`imax' { // should exit much earlier

by `sort': gen `:type `old'' `new' =			           ///
	cond(   `order' >  round(`n'[1, `old'      ]*`order'[_N])  ///
	     &  `order' <= round(`n'[1, `old' + `i']*`order'[_N]), ///
	     `old' + `i', `old')			           ///
	if `touse'

			cap assert `new' == `old'
			if (c(rc) == 0) {
				continue, break
			}
			else if (c(rc) == 9) {
				if (`i' < `imax') {
					drop `old'
					rename `new' `old'
				}
			}
			else {
				error c(rc)
			}
		}

		rename `new' `svar'
	}

	CheckBalance `svar' if `touse', nsplit(`nsplit') balance(`balance') ///
	                                `show'
end

program CheckBalance
	syntax varname if/, nsplit(integer) balance(varlist) [ show ]
	local svar  `varlist'
	local touse `if'

	// Check whether svar is 1, 2, ..., nsplit in each balance() group
	// by computing number of distinct values in each group.

	local by "qui bysort `touse' `balance':"

	tempvar nvals

	`by' gen double `nvals' = cond(_n == _N,			 ///
				       sum(`svar' != `svar'[_n - 1]), .) ///
				  if `touse'

	su `nvals', meanonly

	if (`r(min)' < `nsplit') {
		di as text "{p 0 6 2}"
		di as text "note: some groups defined by {bf:balance()}"
		di as text "do not contain every sample"
		
		if ("`show'" == "") {
	   		di as text "value; use option {bf:show} to"
	   		di as text "see which ones"
	   	}
	   	else {
	   		di as text "value"
	   	}
	   	
	   	di as text "{p_end}"
	}
end

/////////////////////////////////// Display ////////////////////////////////////

program Display
	syntax varname(numeric) if/ [, cluster(varname) ///
	                               balance(varlist) ///
	                               percent          ///
	                            ]
	                            
	local touse `if'

	if ("`balance'" != "" & "`cluster'" != "") {
		ShowBalanceCluster `varlist' `touse' `cluster' `balance', ///
			`percent'
	}
	else if ("`balance'" != "" & "`cluster'" == "") {
		ShowBalance `varlist' `touse' `balance', `percent'
	}
	else if ("`balance'" == "" & "`cluster'" != "") {
		tempvar first
		qui bysort `touse' `cluster' (`varlist'): gen byte `first' ///
			= (_n == 1 & `touse')
		tab `varlist' if `first'
		di _n as text "Total is number of clusters."
	}
	else {
		tab `varlist'
	}
end

program ShowBalance
	syntax varlist(min=3) [, percent ]
	gettoken svar varlist  : varlist
	gettoken touse balance : varlist

	quietly {
		sort `touse' `balance' `svar'

		if ("`percent'" != "") {
			tempvar n
			by `touse' `balance': gen double `n' = sum(abs(`touse'))

			local hundred 100*
			local divn    /`n'
		}
		else {
			tempvar sum
			gen double `sum' = 0
			char `sum'[varname] "Total"
		}

		tempvar tolist notdone

		by `touse' `balance': gen byte `tolist' = (_n == _N & `touse')

		gen byte `notdone' = (`svar' < .)
		
		su `svar' if `notdone'
		
		local dname = abbrev("`svar'", 12)

		local maxhead 8

		while (r(N) > 0) {
			
			tempvar ni

			by `touse' `balance': gen double `ni' =        ///
				`hundred' sum(`svar' == r(min)) `divn' ///
				if `touse'
				
			if ("`percent'" == "") {
				replace `sum' = `sum' + `ni'
			}	

			local head "`dname' `r(min)'"
			
			local length = udstrlen("`head'")	
			
			local maxhead = max(`length', `maxhead')
			
			char `ni'[varname] "`head'"

			local nvars `nvars' `ni'

			replace `notdone' = 0 if `svar' == r(min)

			su `svar' if `notdone'
		}
		
		local nvars `nvars' `sum'
	}

	if ("`percent'" != "") {
		format %5.1f `nvars'
	}
	
	local nbalvars : list sizeof balance
	
	if (`nbalvars' > 1) {
		local last : word `nbalvars' of `balance'
		local sepvars : list balance - last
		local sepopt sepby(`sepvars')
	}
	
	local maxhead = min(129, `maxhead')  // limit for -ab()-

	list `balance' `nvars' if `tolist', `sepopt' noobs subvar ab(`maxhead')
end

program ShowBalanceCluster
	syntax varlist(min=4) [, percent ]
	gettoken svar    varlist : varlist
	gettoken touse   varlist : varlist
	gettoken cluster balance : varlist

	quietly {
		sort `touse' `balance' `svar' `cluster'

		tempvar isclust tolist

		by `touse' `balance' `svar' `cluster': gen byte `isclust' = ///
				(_n == 1 & `touse')

		if ("`percent'" != "") {
			tempvar n

			gen `:type `isclust'' `n' = `isclust'
			by `touse' `balance': replace `n' = sum(`n') if `touse'

			local hundred 100*
			local divn    /`n'
		}
		else {
			tempvar sum
			gen double `sum' = 0
			char `sum'[varname] "Total"
		}

		by `touse' `balance': gen byte `tolist' = (_n == _N & `touse')

		su `svar' if `isclust'

		local dname = abbrev("`svar'", 12)
		
		local maxhead 8 

		while (r(N) > 0) {
			
			tempvar ni

			by `touse' `balance': gen double `ni' =             ///
				`hundred' sum(`isclust' & `svar' == r(min)) ///
				`divn' if `touse'

			if ("`percent'" == "") {
				replace `sum' = `sum' + `ni'
			}
			
			local head "`dname' `r(min)'"	
			
			local length = udstrlen("`head'")	
			
			local maxhead = max(`length', `maxhead')
			
			char `ni'[varname] "`head'"

			local nvars `nvars' `ni'

			replace `isclust' = 0 if `svar' == r(min)

			su `svar' if `isclust'
		}
		
		local nvars `nvars' `sum'
	}

	if ("`percent'" != "") {
		format %5.1f `nvars'
	}

	local nbalvars : list sizeof balance

	if (`nbalvars' > 1) {
		local last : word `nbalvars' of `balance'
		local sepvars : list balance - last
		local sepopt sepby(`sepvars')
	}
	
	local maxhead = min(129, `maxhead')  // limit for -ab()-
	
	list `balance' `nvars' if `tolist', `sepopt' noobs subvar ab(`maxhead')

	if ("`percent'" == "") {
		di _n as text "Counts are numbers of clusters."
	}
	else {
		di _n as text "Percentages of clusters shown."
	}
end

////////////////////////// Main program for -rround- ///////////////////////////

program RandomRounding
	syntax name(name=svar) if/, nsplit(passthru)    ///
				    [                   ///
				      split(numlist)    ///
				      values(numlist)   ///
				      cluster(passthru) ///
				      balance(passthru) ///
				      show		///
				    ]
	local touse `if'

	// Split into `nsplit' subsamples.

	if ("`balance'" != "" & "`cluster'" != "") {
		RSplitBalanceCluster `svar' if `touse', `nsplit' `balance' ///
			                                `cluster'
	}
	else if ("`balance'" != "" & "`cluster'" == "") {
		RSplitBalance `svar' if `touse', `nsplit' `balance'
	}
	else if ("`balance'" == "" & "`cluster'" != "") {
		RSplitCluster `svar' if `touse', `nsplit' `cluster'
	}
	else {
		RSplit `svar' if `touse', `nsplit'
	}

	// Combine subsamples into split() samples.

	if ("`split'" != "") {
		CombineSubsamples `svar', split(`split')
		
		local nsplit nsplit(`:list sizeof split')  // true nsplit
	}
	
	if ("`balance'" != "") {
		CheckBalance `svar' if `touse', `nsplit' `balance' `show'
	}

	// Map 1, 2, ... to values().
	
	if ("`values'" != "") {
		tempname V
		
		matrix input `V' = (`values')

		qui replace `svar' = `V'[1, `svar'] if `touse'
	}
end

/////////////////////////// Subroutines for -rround- ///////////////////////////

program RSplit
	syntax name(name=svar) if/, nsplit(integer)
	local touse `if'

	quietly {
		tempvar obs first r1 r2 newsvar

		// Create variable for deterministic sort.
		
		gen double `obs' = _n

		// Put touse obs first.

		sort `touse' `obs' // -1 and 0

		// Generate svar = 1, 2, ..., nsplit, 1, 2, ....

		gen byte `svar' = . in 1

		replace `svar' = mod(_n - 1, `nsplit') + 1 if `touse'

		// Identify the first 1, 2, ..., nsplit obs.

		gen byte `first' = -(_n <= `nsplit')

		gen double `r1' = runiform() if `touse'
		gen double `r2' = runiform() if `touse'

		local typ : type `svar'

		// Randomly permute the first nsplit values of svar.

		bysort `first' (`r1' `r2'): gen `typ' `newsvar' ///
			= `svar'[`svar'] if `first' 

		// Set all obs to the new permuted values.

		bysort `svar' (`first'): replace `svar' = `newsvar'[1]
	}
end

program RSplitCluster
	syntax name(name=svar) if/, nsplit(integer) cluster(varname)
	local touse `if'

	quietly {
		tempvar obs ctouse
		
		// Create variable for deterministic sort.
		
		gen double `obs' = _n

		// Put one obs per cluster (in touse) first.

		bysort `touse' `cluster' (`obs'): gen byte `ctouse' ///
			= -(_n == 1 & `touse')

		// Randomly split the set of one obs per cluster.

		noi RSplit `svar' if `ctouse', nsplit(`nsplit')

		// Set all obs in each cluster to the sample identifier.

		bysort `touse' `cluster' (`ctouse'): replace `svar' = `svar'[1]
	}
end

program RSplitBalance
	syntax name(name=svar) if/, nsplit(passthru) balance(passthru)
	local touse `if'

	quietly {
		tempvar obs exvar

		gen double `obs' = _n
	
		// Check if there are at least nsplit observations in each
		// balance group to permute samples. 

		SizeOfBalanceExpand `exvar' `obs' if `touse', `nsplit' `balance'

		local must_expand `r(N_new)'
		
		if (`must_expand') {
			preserve
			ExpandBalance `exvar' `obs' if `touse', `balance'
		}

		// Note: obs needed by DoRSplitBalance so its initial sort is 
		// deterministic.

		DoRSplitBalance `svar' `obs' if `touse', `nsplit' `balance'

		if (`must_expand') {
			tempfile new
			keep `obs' `svar'
			drop if `obs' == .
			save `"`new'"'
			restore
			qui merge 1:1 `obs' using `"`new'"', nogen
		}
	}
end

program RSplitBalanceCluster
	syntax name(name=svar) if/, nsplit(integer) balance(varlist) ///
				    cluster(varname)
	local touse `if'

	quietly {
		tempvar obs exvar newcluster ctouse

		gen double `obs' = _n
	
		// Check if there are at least nsplit observations in each
		// balance group to permute samples.

		SizeOfBalanceExpand `exvar' `obs' if `touse', ///
			nsplit(`nsplit') balance(`balance') cluster(`cluster')

		local must_expand `r(N_new)'

		// Create a numeric cluster variable that indicates the
		// first obs in each cluster in each balance group.

		gen byte `newcluster' = . in 1

		bysort `touse' `balance' (`cluster' `obs'): replace        ///
			`newcluster' = sum(`cluster' != `cluster'[_n - 1]) ///
			if `cluster' != `cluster'[_n - 1] & `touse'

		if (`must_expand') {
			preserve
			ExpandBalance `exvar' `obs' if `touse', ///
				balance(`balance') cluster(`newcluster')
		}

		// Flag the first obs of the cluster plus first nsplit obs.

		bysort `touse' `balance' `newcluster' (`obs'): gen byte    ///
			`ctouse' = -( (_n <= `nsplit' | `newcluster' != .) ///
			             & `touse' )

		DoRSplitBalance `svar' `obs' if `ctouse', nsplit(`nsplit') ///
							  balance(`balance')
		if (`must_expand') {
			tempfile new
			keep `obs' `svar'
			drop if `obs' == .
			save `"`new'"'
			restore
			qui merge 1:1 `obs' using `"`new'"', nogen
		}

		// Set all obs in each cluster to the sample identifier.

		bysort `touse' `cluster' (`newcluster'): replace `svar' ///
			= `svar'[1]
	}
end

program SizeOfBalanceExpand, sortpreserve rclass
	syntax [namelist(min=2 max=2)] if/, nsplit(integer) balance(varlist) ///
					    [ cluster(varname) ]
	gettoken exvar obs : namelist
	local touse `if'

	quietly {
		if ("`exvar'" == "") {
			tempvar exvar
		}
		
		gen byte `exvar' = . in 1
		
		bysort `touse' `balance' (`cluster' `obs'): replace `exvar'  ///
			= cond(`nsplit' > _N & _n == 1, `nsplit' - _N, 0)    ///
			  if `touse'

		su `exvar', meanonly

		return scalar N_new = r(sum)
	}
end

program ExpandBalance, rclass
	syntax varlist(min=2 max=2) if/, balance(varlist) [ cluster(varname) ]
	gettoken exvar obs : varlist
	local touse `if'

	quietly {
		tempvar new

		keep `exvar' `obs' `touse' `balance' `cluster'
		drop if !`touse'

		expand `exvar' + 1, gen(`new')

		replace `obs' = . if `new'

		drop `exvar'
	
		tab `new'
	}
end

program DoRSplitBalance
	syntax namelist(min=2 max=2) if/, nsplit(integer) balance(varlist)
	gettoken svar obs : namelist

	// syntax name(name=svar) if/, nsplit(integer) balance(varlist)
	
	local touse `if'

	quietly {
		tempvar first r1 r2 newsvar

		// Generate svar = 1, 2, ..., nsplit, 1, 2, ....

		gen byte `svar' = . in 1
		
		// Note: obs needed for deterministic sort.

		bysort `touse' `balance' (`obs'): replace `svar' ///
			= mod(_n - 1, `nsplit') + 1 if `touse'

		// Identify the first 1, 2, ..., nsplit obs.

		by `touse' `balance': gen byte `first' = -(_n <= `nsplit') ///
			if `touse'

		gen double `r1' = runiform() if `touse'
		gen double `r2' = runiform() if `touse'

		local typ : type `svar'

		// Randomly permute the first nsplit values of svar.

		bysort `touse' `balance' `first' (`r1' `r2'): gen `typ' ///
			`newsvar' = `svar'[`svar'] if `first' & `touse'
			
		// Set all obs to the new permuted values.

		bysort `touse' `balance' `svar' (`first'): replace `svar' ///
			= `newsvar'[1]
	}
end

program CombineSubsamples
	syntax varname, split(numlist integer >0)

	local start 1
	local n : list sizeof split

	qui forvalues i = 1/`n' {

		local s : word `i' of `split'

		local end = `s' + `start' - 1

		replace `varlist' = `i' if inrange(`varlist', `start', `end')

		local start = `end' + 1
	}
end

///////////////////////////////////// mata /////////////////////////////////////

version 16
mata:
mata set matastrict on

void NsplitRound(string scalar matname,
		 real   scalar n,
		 real   scalar N)
{
	// Use when number of obs or clusters is known.

	real rowvector M

	M = st_matrix(matname)

	if (cols(M) == 0) {
		M = (1..n)
	}
	else {
		M = runningsum(M)
	}

	M = round(M:*(N/M[cols(M)]))

	st_matrix(matname, M)
}

void Nsplit(string scalar matname,
	    string scalar minname,
            real   scalar n)
{
	// Use when number of obs or clusters varies.

	real rowvector M
	real scalar    m

	M = st_matrix(matname)

	if (cols(M) == 0) {
		M = (1..n)
		m = 1/n
	}
	else {
		m = min(M)
		M = quadrunningsum(M)
		m = m/M[cols(M)]
	}

	M = M:/M[cols(M)]

	st_matrix(matname, M)
	st_numscalar(minname, m)
}

void Nfix(string scalar N_name,
	  string scalar V_name,
	  string scalar G_name)
{
	real rowvector N, V, G, X
	real scalar    n

	N = st_matrix(N_name)
	V = st_matrix(V_name)

	n = cols(N)

	if (cols(V) == 0) {
		V = (1..n)
	}

	if (n == 1) {
		st_matrix(V_name, V)
		return
	}

	X = (0, N[|1\(n-1)|])

	X = N - X

	if (!anyof(X, 0)) {
		st_matrix(V_name, V)
		return
	}

	// If here, there are gaps.

	G = select(V, X :== 0)
	V = select(V, X :!= 0)
	N = select(N, X :!= 0)

	st_matrix(N_name, N)
	st_matrix(V_name, V)
	st_matrix(G_name, G)
}

end

