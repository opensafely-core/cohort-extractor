*! version 1.0.4  03feb2015
program discrim, eclass
	version 10

	if replay() {
		if "`e(cmd)'" == "candisc" {
			// we allow -discrim lda- and -candisc- to call
			// to each other on replay
			discrim_lda `0'
			exit
		}
		if "`e(cmd)'" != "discrim" | "`e(subcmd)'" == "" {
			error 301
		}
		// call through to subcommand for replay
		discrim_`e(subcmd)' `0'
		exit
	}

	// Determine the subcommand
	gettoken subcmd 0 : 0 , parse(" ,")

	// take care of any allowed abbreviations
	local len = length(`"`subcmd'"')
	if `"`subcmd'"' == bsubstr("logistic",1,max(4,`len')) {
		local subcmd logistic
	}
	else if `"`subcmd'"' == bsubstr("logit",1,max(4,`len')) {
		local subcmd logistic
	}

	// Redirect to the programmer utility subroutine if appropriate
	if `"`subcmd'"' == "prog_utility" {
		ProgUtility `0'
		exit
	}

	// Call through to the subcommand
	discrim_`subcmd' `0'

	// Check e() items

	// Let e(cmd) of "candisc" slip through without complaint
	if "`e(cmd)'" == "candisc" {
		exit
	}

	if "`e(cmd)'" != "discrim" {
		di as err `"discrim_`subcmd' failed to set e(cmd) to "discrim""'
		eret clear
		exit 322
	}
	if bsubstr(`"`e(cmdline)'"',1,8) != "discrim " {
		di as err `"discrim_`subcmd' failed to set e(cmdline)"'
		eret clear
		exit 322
	}
	if "`e(subcmd)'" == "" {
		di as err `"discrim_`subcmd' failed to set e(subcmd)"'
		eret clear
		exit 322
	}
	if "`e(estat_cmd)'" == "" {
		di as err `"discrim_`subcmd' failed to set e(estat_cmd)"'
		eret clear
		exit 322
	}
	if "`e(predict)'" == "" {
		di as err `"discrim_`subcmd' failed to set e(predict)"'
		eret clear
		exit 322
	}
end

// Program utilities
program ProgUtility

	gettoken progsubcmd 0 : 0 , parse(" ,")

	if `"`progsubcmd'"' == "" {
		di as err "additional arguments are required"
		exit 198
	}

	if `"`progsubcmd'"' == "groups" {
		GroupsChk `0'
	}
	else if `"`progsubcmd'"' == "priors" {
		PriorsChk `0'
	}
	else if `"`progsubcmd'"' == "classtable" {
		ClassTab `0'
	}
	else if `"`progsubcmd'"' == "assigngroup" {
		AssignGroup `0'
	}
	else if `"`progsubcmd'"' == "ties" {
		ParseTies `0'
	}
	else if `"`progsubcmd'"' == "groupheader" {
		GrpHdr	`0'
	}
	else {
		di as err ///
		   "`progsubcmd' is not a subcommand of -discrim prog_utility-"
		exit 198
	}
end

program GrpHdr
	// syntax:
	// discrim prog_utility groupheader [, left(#)]

	syntax [, Left(numlist integer max=1 >=0)]

	if "`left'" == ""		local left 0
	if `left' > c(linesize)/2 {
		di as err "invalid call to -discrim prog_utility groupheader-;"
		di as err "left(`left')" is too extreme"
		exit 198
	}
	if `"`e(grouplabels)'"' == "" {
		"e(grouplabels) not found"
		exit 322
	}
	if `"`e(N_groups)'"' == "" {
		"e(N_groups) not found"
		exit 322
	}
	local gpvar `e(groupvar)'
	if `"`gpvar'"' == "" {
		"e(groupvar) not found"
		exit 322
	}

	mata: st_local("maxlen", ///
		strofreal(max(strlen(tokens(st_global("e(grouplabels)"))))))

	if `maxlen' > (`c(linesize)' - `left' - 10) {
		local wid = `c(linesize)' - `left' - 10
	}
	else	local wid = `maxlen' + 2

	if `wid' < length("`gpvar'")+1     local wid = length("`gpvar'")+1

	tokenize `"`e(grouplabels)'"'

	tempname tab
	.`tab' = ._tab.new, col(2) lmarg(`left')
	.`tab'.width    8 | `wid'
	.`tab'.titlefmt .   %-`wid's
	.`tab'.strfmt   .   %-`wid's
	.`tab'.titles "" " `gpvar'"
	.`tab'.sep, mid

	forvalues i = 1/`e(N_groups)' {
		if udstrlen(`"``i''"') > `wid'-1 {
			.`tab'.row `"group`i'"' ///
				   `" `= udsubstr(`"``i''"',1,`=`wid'-3')'.."'
		}
		else {
			.`tab'.row `"group`i'"' `" ``i''"'
		}
	}

end

program GroupsChk, rclass
	// syntax:
	// discrim prog_utility groups <groupvar> <tousevar> [<fweightexp>]

	local synx varlist(min=2 max=2 numeric) [fweight]
	capture syntax `synx'
	if c(rc) {
		di as err "invalid call to -discrim prog_utility groups-;"
		di as err "group variable and " ///
				"sample indicator variable are required"
		syntax `synx'
	}

	local grpvar : word 1 of `varlist'
	local tousevar : word 2 of `varlist'

	if `"`weight'"' != "" {
		local fw `"[fweight`exp']"'
	}

	tempname grpvals grpcnts
	qui tabulate `grpvar' if `tousevar' `fw', ///
				matrow(`grpvals') matcell(`grpcnts')
	local N = r(N)
	local k = r(r)
	if `k' < 2 {
		di as err "at least two groups are required"
		exit 148  // too few categories error code
	}
	mat `grpvals' = `grpvals''
	mat `grpcnts' = `grpcnts''
	local cnames : colnames `grpvals'
	local cnames : subinstr local cnames "r" "group", all
	mat rownames `grpvals' = Values
	mat colnames `grpvals' = `cnames'
	mat rownames `grpcnts' = Counts
	mat colnames `grpcnts' = `cnames'

	// create macro with list of Group labels
	local vlab : value label `grpvar'
	if "`vlab'" == "" {
		forvalues i = 1/`k' {
			local grplabs `"`grplabs' `"`=`grpvals'[1,`i']'"'"'
		}
	}
	else {
		forvalues i = 1/`k' {
			local grplabs ///
			  `"`grplabs' `"`: label `vlab' `=`grpvals'[1,`i']''"'"'
		}
	}
	local grplabs : list retokenize grplabs

	ret scalar N		= `N'		// number of obs
	ret scalar N_groups	= `k'		// number of groups
	ret mat groupvalues	= `grpvals'	// matrix of group values
	ret mat groupcounts	= `grpcnts'	// matrix of group counts
	ret local grouplabels	`"`grplabs'"'	// group labels
end

program PriorsChk, rclass
	// syntax:
	// discrim prog_utility priors <priors> <k> <grpsizemat>

	args priors k gsizes therest

	if `"`priors'"' == "" {
		local priors equal
	}

	if `"`therest'"' != "" | `"`k'"' == "" | `"`gsizes'"' == "" {
		di as err "invalid call to -discrim prog_utility priors-;"
		if `"`therest'"' != "" {
			di as err `"unexpected arguments:  `therest'"'
		}
		else {
			di as err "priors option argument, number of " ///
				"groups, and group-sizes matrix are required"
		}
		exit 198
	}

	capture confirm integer number `k'
	if !_rc {
		capture assert `k' > 1
	}
	if _rc {
		di as err "invalid call to -discrim prog_utility priors-;"
		di as err `"number of groups argument was `k'"'
		exit 198
	}

	capture confirm matrix `gsizes'
	if _rc {
		di as err "invalid call to -discrim prog_utility priors-;"
		di as err `"`gsizes' provided where matrix expected"'
		exit 198
	}
	capture assert (rowsof(`gsizes')==1 | colsof(`gsizes')==1) & ///
			(rowsof(`gsizes')==`k' | colsof(`gsizes')==`k')
	if _rc {
		di as err "invalid call to -discrim prog_utility priors-;"
		di as err ///
		    `"`gsizes' is not a `k'-dimensional row or column vector"'
		exit 198
	}
	if matmissing(`gsizes') {
		di as err "invalid call to -discrim prog_utility priors-;"
		di as err `"matrix `gsizes' contains missing values"'
		exit 198
	}


	tempname mpriors

	local len = length(`"`priors'"')

	forvalues i = 1/`k' {
		local mcnam `mcnam' group`i'
	}

	// Equal prior probabilities
	if `"`priors'"' == bsubstr("equal",1,max(2,`len')) {
		mat `mpriors' = J(1,`k',1/`k')
		mat colnames `mpriors' = `mcnam'
		mat rownames `mpriors' = Priors
		return matrix grouppriors = `mpriors'
		exit
	}

	// Proportional-to-sample-size prior probabilities
	if `"`priors'"' == bsubstr("proportional",1,max(4,`len')) {
		mat `mpriors' = `gsizes'
		if colsof(`mpriors') == 1 {
			mat `mpriors' = `mpriors''
		}
		tempname tmptot
		mat `tmptot' = `mpriors' * J(`k',1,1)
		scalar `tmptot' = `tmptot'[1,1]
		forvalues i = 1/`k' {
			capture assert `mpriors'[1,`i'] > 0
			if _rc {
				di as err ///
				"invalid call to -discrim prog_utility priors-;"
				di as err ///
				`"matrix `gsizes' contains nonpositive values"'
				exit 198
			}
			mat `mpriors'[1,`i'] = `mpriors'[1,`i']/`tmptot'
		}
		mat colnames `mpriors' = `mcnam'
		mat rownames `mpriors' = Priors
		return matrix grouppriors = `mpriors'
		exit
	}

	// User provided matrix of prior probabilities (might come as a
	// matrix, set of values, or expression that defines the matrix)
	capture matrix input `mpriors' = `priors'
	if _rc {
		capture matrix define `mpriors' = `priors'
	}
	if !_rc {
		if !( (rowsof(`mpriors')==1   | colsof(`mpriors')==1) & ///
		      (rowsof(`mpriors')==`k' | colsof(`mpriors')==`k') ) {
			di as err ///
			"`priors' is not a `k'-dimensional row or column vector"
			exit 198
		}
		if matmissing(`mpriors') {
			di as err "matrix `priors' contains missing values"
			exit 198
		}
		if colsof(`mpriors') == 1 {
			mat `mpriors' = `mpriors''
		}
		tempname prsum
		scalar `prsum' = 0
		forvalues i = 1/`k' {
			if `mpriors'[1,`i'] <= 0 | `mpriors'[1,`i'] >= 1 {
				di as err ///
				 "matrix `priors' contains values outside (0,1)"
				exit 198
			}
			scalar `prsum' = `prsum' + `mpriors'[1,`i']
		}
		if reldif(`prsum', 1) > 1e-5 {
			di as err "the elements of `priors' do not sum to one"
			exit 198
		}
		mat colnames `mpriors' = `mcnam'
		mat rownames `mpriors' = Priors
		return matrix grouppriors = `mpriors'
		exit
	}

	// Getting to here means that `priors' is invalid
	di as err "option priors() is incorrectly specified"
	exit 198

end

program ClassTab, rclass

	if `"`e(cmd)'"' != "discrim" & `"`e(cmd)'"' != "candisc" {
		di as err "invalid call to -discrim prog_utility classtable-;"
		di as err "e(cmd) must already be set to discrim"
		exit 301
	}

	local synx varlist(min=1 max=2) [if] [in] [fweight] [,	///
		predopts(string)				///
		TITle(passthru) PRIors(passthru)		///
		noTotals noROWTotals noCOLTotals noGRANDTotal	///
		noPERcents NOPRIors				///
		PRVars(varlist numeric) probpredopts(string)	///
		noLABELKEY					///
		CLPREFIX(passthru)	/// undocumented
		]
	capture syntax `synx'
	if c(rc) {
		di as err "invalid call to -discrim prog_utility classtable-;"
		syntax `synx'	// rerun to get additional error message out
	}

	marksample touse, novarlist
	tempvar fw
	qui gen byte `fw' = 1 if `touse'
	if `"`weight'"' != "" {
		qui replace `fw'`exp' if `touse'
	}
	qui summ `fw' if `touse', meanonly
	if r(sum) < 1	error 2000

	if "`prvars'" != "" & `"`probpredopts'"' != "" {
		opts_exclusive "prvars() probpredopts()"
	}
	if "`prvars'`probpredopts'" != ""	local doprobs doprobs

	local passon `totals' `rowtotals' `coltotals' `grandtotal' `percents'
	local passon `passon' `title' `labelkey' `clprefix'

	if `: word count `varlist'' == 2 {
		local truegrpvar `: word 1 of `varlist''
		local grpvar `: word 2 of `varlist''
		if `"`predopts'"' != "" {
			di as err
			   "predopts() not allowed when two variables specified"
			exit 198
		}
	}
	else {
		local truegrpvar `varlist'
		tempvar grpvar

		if `"`predopts'"' == "" {
			local predopts classification
		}

		qui predict long `grpvar' if `touse', `predopts' `priors'

		// If the -predict- sets r(warning) macro then present it
		if `"`r(warning)'"' != "" {
			di `"{p}`r(warning)'{p_end}"'
		}
		else if `"`r(N_ties)'"' != "" {
			capture confirm integer number `r(N_ties)'
			if !c(rc) {
				if `r(N_ties)' > 0 {
					di as txt "{p}Warning: `r(N_ties)' " ///
					    plural(`r(N_ties)',"tie")       ///
					    " encountered in predicting "   ///
					    "group membership.{p_end}"
				}
			}
		}
	}

	local ngps = e(N_groups)

	if "`doprobs'" != "" {	// do posterior probabilities
		if "`prvars'" != "" { // user specified variables; check them
			if `: list sizeof prvars' != `ngps' {
				di as err ///
				    "prvars() does not have `ngps' variables"
				exit 198
			}
			// Checking [0,1] but not checking if they sum to one
			foreach v of local prvars {
				capture assert (`v' >= 0 & `v' <= 1) | ///
							missing(`v') if `touse'
				if c(rc) {
					di as err "invalid prvars(): `v' " ///
						"has values outside [0,1]"
					exit 198
				}
			}
		}
		else {
			if "`probpredopts'" == "" {
				local probpredopts pr
			}
			local prvars
			forvalues i = 1/`ngps' {
				tempvar ttt
				local prvars `prvars' `ttt'
			}

			qui predict double (`prvars') if `touse', ///
							`probpredopts' `priors'

			// If -predict- sets r(warning) macro then present it
			if `"`r(warning)'"' != "" {
				di `"{p}`r(warning)'{p_end}"'
			}
		}
	}

	// ====Get priors for display if applicable ==//
	if `"`nopriors'"' != "" {
		local priors
	}
	else if `"`priors'"' == "" {
		if `"`e(grouppriors)'"' == "matrix" {
			tempname priormat
			mat `priormat' = e(grouppriors)
			local priors priors(`priormat')
		}
	}
	local passon `passon' `priors'
	tempname cnts rowvals colvals avgpprob

	mata:_discrim_TabCTable("`truegrpvar'", "`grpvar'", "`touse'", ///
				"`fw'", "`cnts'","`rowvals'", "`colvals'", ///
				"`prvars'", "`avgpprob'")

	forvalues i = 1/`ngps' {
		local gnum `gnum' group`i'
	}

	if "`doprobs'" == "" {
		local avgpprob		// blank it out
	}
	else {
		mat rownames `avgpprob' = `gnum'
		mat colnames `avgpprob' = `gnum'
	}

	mat rownames `cnts' = `gnum'
	if colsof(`cnts') > `ngps' {
		local gnum `gnum' Unclassified
	}
	mat colnames `cnts' = `gnum'

	Cl_Table `cnts' `avgpprob' , `passon'
	return add
end

program AssignGroup, rclass
	args ans vlist touse ties ismin

	if "`ties'" == "" {
		local ties missing
		if "`e(ties)'" != "" {
			local ties `e(ties)'
		}
	}
	

	if `"`e(groupvalues)'"' != "matrix" {
		// matrix e(groupvalues) must be set
		di as err "invalid call to -discrim prog_utility assigngroup-;"
		di as err "e(groupvalues) not found"
		exit 301
	}

	local domin 0
	if `"`ismin'"' == "minimum" {
		local domin 1
	}
	else if `"`ismin'"' == "maximum" {
		local domin 0
	}
	else if `"`ismin'"' != "" {
		di as err "invalid call to -discrim prog_utility assigngroup-;"
		di as err `"unexpected argument: `ismin'"'
		exit 198
	}
	capture confirm variable `touse'
	if c(rc) | `: word count `touse'' != 1 {
		di as err "invalid call to -discrim prog_utility assigngroup-;"
		di as err ///
		     `"`touse' found where an existing variable was expected"'
		exit 198
	}
	capture confirm variable `vlist'
	if c(rc) {
		di as err "invalid call to -discrim prog_utility assigngroup-;"
		di as err ///
		     `"`vlist' found where an existing variable list expected"'
		exit 198
	}
	if `: word count `ans'' != 1 {
		di as err "invalid call to -discrim prog_utility assigngroup-;"
		di as err `"`ans' found where a single name was expected"'
		exit 198
	}

	capture confirm variable `ans'
	if c(rc) qui gen double `ans' = .

	local nvars : word count `vlist'

					// local numties is set here
	mata: _discrim_MaxIndex("`ans'","`vlist'","`touse'","numties", ///
							`domin', "`ties'")

	return local N_ties `numties'
end

program ParseTies, sclass
	syntax [, Missing Random Nearest First *]

	local opt `missing' `random' `nearest' `first'
	local nopt: list sizeof opt
	if `nopt' > 1 {
		opts_exclusive "`opt'" ties 198
	}
	else if `"`options'"' != "" {
		di as error				///
			`"ties() may be one of missing, random, first, or "' ///
				"nearest"
		exit 198
	}
	else if "`opt'"=="" {
		if "`e(cmd)'" == "discrim" & "`e(ties)'" != "" {
			local opt `e(ties)'
		}
		else local opt missing
	}
	local opt = trim("`opt'")
	sreturn local ties `opt'
end

program Cl_Table, rclass
	syntax namelist (name=matname id="matrix name" min=1 max=2) [,	///
		PRIors(string)						///
		TITle(string)						///
		noTotals noROWTotals noCOLTotals noGRANDTotal		///
		noPERcents						///
		noLABELKEY						///
		CLPREFIX(string)	/// undocumented
		]

	tempname cmat tmpmat pprmat tmpmat2 tmpmat3


	if `: word count `matname'' > 1 {		// post. probs
		local dopp dopp
		mat `cmat' = `: word 1 of `matname''
		mat `pprmat' = `: word 2 of `matname''
		local matname : word 1 of `matname'
		local rowtotals norowtotals
	}
	else {						// no post. probs
		mat `cmat' = `matname'
	}
	local origr = rowsof(`cmat')
	local origc = colsof(`cmat')

	mat `tmpmat' = `cmat' * J(colsof(`cmat'),1,1)
	mat `tmpmat' =`tmpmat''

	mata: st_local("anyless0", strofreal(any(st_matrix("`cmat'") :< 0)))
	if `anyless0' {
		di as err "`matname' has negative values"
		exit 508
	}

	local dopriors 0
	if `"`priors'"' != "" {
		// allowed (capitalization indicates min abbrev):
		// PRIors(EQual)  PRIors(PROPortional)  PRIors(matrix)
		// PRIors(matrix_expression)
		local dopriors 1
		tempname priormat
		PriorsChk `"`priors'"' `= rowsof(`cmat')' `tmpmat'
		mat `priormat' = r(grouppriors)
		mat rownames `priormat' = Priors
		if colsof(`priormat') == (colsof(`cmat')-1) {
			mat `priormat' = (`priormat',.z)
		}
	}

	if "`totals'" == "nototals" {
		local coltotals nocoltotals
		local rowtotals norowtotals
	}

	if "`coltotals'" != "nocoltotals" {
		mat `tmpmat' = J(1,rowsof(`cmat'),1)* `cmat'
		mat rownames `tmpmat' = Total
		mat `cmat' = `cmat' \ `tmpmat'

		if "`dopp'" != "" {
			mat `tmpmat2' = `cmat'[1..`= rowsof(`pprmat')' , ///
						1..`= colsof(`pprmat')']
			mata: st_matrix("`tmpmat3'", quadcolsum(	 ///
					st_matrix("`pprmat'") :*	 ///
					st_matrix("`tmpmat2'")) :/	 ///
					(st_matrix("`tmpmat'")[|1,1 \	 ///
						1,`= colsof(`pprmat')'|] ///
					))
			mat rownames `tmpmat3' = Total
			mat `pprmat' = `pprmat' \ `tmpmat3'
		}
	}

	mat `tmpmat' = `cmat' * J(colsof(`cmat'),1,1)
	mat colnames `tmpmat' = Total

	if "`percents'" != "nopercents" {
		tempname pmat
		mata: st_matrix("`pmat'", ///
				st_matrix("`cmat'") :/ st_matrix("`tmpmat'"))
		// You can have missing percents from percent 0/0!
		// This takes missing and makes them 0
		mata: st_matrix("`pmat'", editmissing(st_matrix("`pmat'"),0))
		mat `pmat' = `pmat'*100
		local pmatarg `"blanks(.z) format(%6.2f) keyent("Percent")"'
		local pmatarg `"`pmatarg' omitline(.o)"'
		local pmatarg `"(`pmat' , `pmatarg')"'
	}
	if "`dopp'" != "" {
		local pprmatarg `"keyent("Average posterior probability")"'
		local pprmatarg `"`pprmatarg' blanks(.z) format(%6.4f)"'
		local pprmatarg `"`pprmatarg' omitline(.o)"'
		local pprmatarg `"(`pprmat' , `pprmatarg')"'
	}

	if "`rowtotals'" != "norowtotals" {
		mat `cmat' = `cmat' , `tmpmat'

		if "`percents'" != "nopercents" { // will be 100%
			mat `pmat' = `pmat' , J(rowsof(`pmat'),1,100)
			mata: _discrim_Mstripes("`pmat'", "`cmat'")
		}
	}

	if "`grandtotal'" == "nograndtotal" {
		if ("`rowtotals'" != "norowtotals") & ///
				("`coltotals'" != "nocoltotals") {
			mat `cmat'[rowsof(`cmat'),colsof(`cmat')] = .z
			if "`percents'" != "nopercents" {
			    mat `pmat'[rowsof(`pmat'),colsof(`pmat')] = .z
			}
		}
	}

	if "`dopp'" != "" {
		local droplastcol 0
		if colsof(`pprmat') < colsof(`cmat') {
			// tack column on pprmat to match "ties" column of cmat
			mat `tmpmat2' = J(rowsof(`pprmat'),1,.z)
			mat `pprmat' = `pprmat' , `tmpmat2'
			local droplastcol 1
		}
	}

	if `"`title'"' != "" {
		di as txt `"`title'"'
	}

	local lcom "left top eq rows(gap)"
	if `dopriors' {
		if "`rowtotals'" != "norowtotals" {
			mat `priormat' = `priormat' , .z
		}
		mat `cmat' = `cmat' \ `priormat'
		if "`percents'" != "nopercents" {
			mat `tmpmat2' = J(1,colsof(`priormat'),.o)
			mat `pmat' = `pmat' \ `tmpmat2'
		}
		if "`dopp'" != "" {
			mat `tmpmat2' = J(1,colsof(`priormat'),.o)
			mat `pprmat' = `pprmat' \ `tmpmat2'
		}

		if ("`rowtotals'" != "norowtotals") & ///
					("`coltotals'" != "nocoltotals") {
			mata: st_local("atc", "|" + "."*`= `origc'-1' + "|.")
			mata: st_local("atr", "-" + "g"*`= `origr'-1' + "-g.")
			local lineopt "lines(atrows(`atr') atcols(`atc'))"
		}
		else if "`coltotals'" != "nocoltotals" {
			mata: st_local("atc", "|" + "."*`origc')
			mata: st_local("atr", "-" + "g"*`= `origr'-1' + "-g.")
			local lineopt "lines(atrows(`atr') atcols(`atc'))"
		}
		else if "`rowtotals'" != "norowtotals" {
			local lineopt "lines(`lcom' last(row col))"
		}
		else {
			local lineopt "lines(`lcom' last(row))"
		}
	}
	else {
		if ("`rowtotals'" != "norowtotals") & ///
					("`coltotals'" != "nocoltotals") {
			local lineopt "lines(`lcom' last(row col))"
		}
		else if "`coltotals'" != "nocoltotals" {
			local lineopt "lines(`lcom' last(row))"
		}
		else if "`rowtotals'" != "norowtotals" {
			local lineopt "lines(`lcom' last(col))"
		}
		else {
			local lineopt "lines(`lcom')"
		}
	}

	MaxCntFmt maxfmt `cmat'		// sets local maxfmt

	local cmatarg	`"blanks(.z) keyent("Number")"'
	if `dopriors' {
		mata: st_local("afm", "`maxfmt' "*`= rowsof(`cmat')-1')
		local cmatarg `"`cmatarg' format(`afm' %6.4f, row)"'
	}
	else {
		local cmatarg `"`cmatarg' format(`maxfmt')"'
	}
	local cmatarg	`"(`cmat' , `cmatarg')"'

	local commonopts `", `lineopt' key("Key") left(4)"'

	local holdcmatrn : rownames `cmat'
	local holdcmatcn : colnames `cmat'

	mata: _discrim_NameSub(`"`e(grouplabels)'"',"`holdcmatrn'", ///
				/// remaining args will be set as locals
				"newrn", "rnlen", "ranyus", "ranyoth")

	mata: _discrim_NameSub(`"`e(grouplabels)'"',"`holdcmatcn'", ///
				/// remaining args will be set as locals
				"newcn", "cnlen", "canyus", "canyoth")

	local unat : list posof "Unclassified" in newcn
	if `rnlen' > 0 & `rnlen' < 13 & !`ranyoth' ///
			& `cnlen' > 0 & `cnlen' < 13 & !`canyoth' {
		local resetnm 1
		mat rownames `cmat' = `newrn'
		mat colnames `cmat' = `newcn'
		if `unat' {
			local tlen = max(6,`cnlen')
			mata: st_local("wids", ///
				"`tlen' " * `= `unat'-1' + "12 " + ///
				"`tlen' " * `= `: list sizeof newcn' - `unat'')
			local commonopts `"`commonopts' widths(`wids')"'
		}
		else if `cnlen' > 6 {
			local commonopts `"`commonopts' widths(`cnlen')"'
		}
		if length("`e(groupvar)'") < 8 {
			local rnopt ///
			  `"rownames(, title("True `e(groupvar)'") underscore)"'
		}
		else {
			local rnopt ///
			`"rownames(, title("True" "`e(groupvar)'") underscore)"'
		}
		local cnopt ///
			`"colnames(, title("`clprefix'Classified") underscore)"'

	}
	else {	// show a table listing group and the value or label
		if `unat' {
			local tlen = cond(`e(N_groups)'<10, 6, 7)
			mata: st_local("wids", ///
				"`tlen' " * `= `unat'-1' + "12 " + ///
				"`tlen' " * `= `: list sizeof newcn' - `unat'')
			local commonopts `"`commonopts' widths(`wids')"'
		}
		local rnopt `"rownames(, title("True") underscore)"'
		local cnopt ///
			`"colnames(, title("`clprefix'Classified") underscore)"'

		if "`labelkey'" != "nolabelkey" {
		// (since the table itself will only say group1 ...)
			di
			GrpHdr, left(4)
		}
	}

	local commonopts `"`commonopts' `rnopt' `cnopt'"'

	_multiplemat_tab `cmatarg' `pmatarg' `pprmatarg' `commonopts'

	if 0`resetnm' == 1 {
		mat rownames `cmat' = `holdcmatrn'
		mat colnames `cmat' = `holdcmatcn'
	}

	if `dopriors' {
		mat `cmat' = `cmat'[1..`= rowsof(`cmat')-1', 1...]
	}
	return matrix counts = `cmat'
	if "`percents'" != "nopercents" {
		if `dopriors' {
			mat `pmat' = `pmat'[1..`= rowsof(`pmat')-1', 1...]
		}
		return matrix percents = `pmat'
	}
	if "`dopp'" != "" {
		if `dopriors' {
			mat `pprmat' = `pprmat'[1..`= rowsof(`pprmat')-1', 1...]
		}
		if `droplastcol' {
			mat `pprmat' = `pprmat'[1..., 1..`= colsof(`pprmat')-1']
		}
		return matrix avgpostprob = `pprmat'
	}
end

program MaxCntFmt
	args ans y

	tempname m
	mata: st_numscalar("`m'", max(st_matrix("`y'")))
	if `m' < 100000 {
		c_local `ans' "%6.0fc"
	}
	else {
		local numdigs = ceil(log10(`m'+1))
		local numcommas = floor((`numdigs'-1)/3)
		c_local `ans' "%`= `numdigs'+`numcommas''.0fc"
	}
end
