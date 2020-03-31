*! version 2.0.2  20jan2015
program clustermat
	version 9

	gettoken subcmd 0 : 0 , parse(" ,")
	local subcmd = lower(`"`subcmd'"')

	if `"`subcmd'"' == "" | `"`subcmd'"' == "," {
		di as error "must specify a clustermat subcommand"
		exit 198
	}

	cluster resolve_version		// sets local -reset_these_globals-

	capture noisily MatClustWork , subcmd(`"`subcmd'"') rest(`"`0'"')

	local therc = _rc

	if `therc' {
		ClustClean // clean up chars from any partial cluster runs
	}

	foreach g of local reset_these_globals {
		global `g'
	}

	exit `therc'
end


program MatClustWork
	syntax [, subcmd(str) rest(str) ]
	local len = length(`"`subcmd'"')
	if `"`subcmd'"' == bsubstr("kmeans",1,max(1,`len')) |	///
			`"`subcmd'"' == bsubstr("kmedians",1,max(4,`len')) {
		// kmeans and kmedians need the data (can't work on matrix)
		di as error `"clustermat `subcmd' not allowed"'
		exit 198
	}
	if `"`subcmd'"' == bsubstr("singlelinkage",1,max(1,`len')) {
		MatClustLink "single" `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("averagelinkage",1,max(1,`len')) {
		MatClustLink "average" `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("completelinkage",1,max(1,`len')) {
		MatClustLink "complete" `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("centroidlinkage",1,max(4,`len')) {
		MatClustLink "centroid" `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("medianlinkage",1,max(3,`len')) {
		MatClustLink "median" `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("waveragelinkage",1,max(3,`len')) {
		MatClustLink "waverage" `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("wardslinkage",1,max(4,`len')) {
		MatClustLink "wards" `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("dendrogram",1,max(4,`len')) |	///
			`"`subcmd'"' == bsubstr("tree",1,max(2,`len')) {
		cluster_tree `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("generate",1,max(3,`len')) {
		cluster generate `rest'
		exit
	}
	if `"`subcmd'"' == "dir" {
		cluster dir `rest'
		exit
	}
	if `"`subcmd'"' == "list" {
		cluster list `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("notes",1,max(4,`len')) {
		cluster notes `rest'
		exit
	}
	if `"`subcmd'"' == "drop" {
		cluster drop `rest'
		exit
	}
	if `"`subcmd'"' == "use" {
		cluster use `rest'
		exit
	}
	if `"`subcmd'"' == "stop" {
		cluster_stop `rest'
		exit
	}
	if `"`subcmd'"' == "rename" {
		cluster rename `rest'
		exit
	}
	if `"`subcmd'"' == "renamevar" {
		cluster renamevar `rest'
		exit
	}
	if `"`subcmd'"' == "query" {
		cluster query `rest'
		exit
	}
	if `"`subcmd'"' == "set" {
		cluster set `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("delete",1,max(3,`len')) {
		cluster delete `rest'
		exit
	}

	/* Error if we get to here */
	di as error `"unrecognized clustermat subcommand `subcmd'"'
	exit 198
end


* MatClustLink -- various Linkage Hierarchical Cluster Analyses
*
*	linkages: single, complete, average, centroid, median, waverage, wards
*
program MatClustLink
	gettoken method 0 : 0 , parse(" ,")
	local cmd `"clustermat `method'linkage `0'"'
	syntax name(name=dmat id="dissimilarity matrix") [if] [in] ///
		[, LABelvar(name) Name(name) GENerate(name) ///
		clear add SHape(str) force ]

	Parse_shape `shape'
	local shape `s(arg)'

	confirm matrix `dmat'

	local dmr = rowsof(`dmat')
	local dmc = colsof(`dmat')

	if matmissing(`dmat') {			// has missings
		di as err "`dmat' has missing values"
		exit 504
	}

	if (`dmr' == `dmc') & (`dmr' > 1) {	// square (and at least 2x2)

		if inlist("`shape'","upper","lower","uupper","llower")  {
			dis as err	///
		  "shape() invalid; `shape' specified, but square matrix found"
			exit 198
		}

		local thed `dmat'

		if !issym(`thed') {		// not symmetric
			if "`force'" != "" {
				// force it to be symmetric
				tempname newd
				mat `newd' = `thed'
				mat `newd' = (`newd'+`newd'')/2
				local thed `newd'
			}
			else {
				di as err "matrix `dmat' not symmetric;"
				di as err ///
					"specify force option to proceed anyway"
				exit 505
			}
		}
		if diag0cnt(`thed') != colsof(`thed') {
			if "`force'" != "" {
				// force diagonal to zero
				tempname newd2
				mat `newd2' = `thed'
				forvalues i = 1/`=colsof(`newd2')' {
					mat `newd2'[`i',`i'] = 0
				}
				local thed `newd2'
			}
			else {
				di as err ///
					"`dmat' has nonzero values on diagonal;"
				di as err ///
					"specify force option to proceed " ///
					"as if they were zero"
				// using 559 as a matrix analogy to
				// 459 data error
				// error code 508 is exact opposite of this
				exit 559
			}
		}

	}
	else if (`dmr' == 1) & (`dmc' == 1) & /// 1x1 matrix
				!inlist("`shape'", "uupper", "llower") {

		di as err "1x1 matrix not allowed"
		// 2001 because it the same idea as only 1 observation
		exit 2001

	}
	else if (`dmr' == 1) | (`dmc' == 1) {	// vector

		if "`shape'" == "" {
			dis as err	///
			    "option shape() required with vectorized matrix"
			exit 198
		}
		if !inlist("`shape'","upper","lower","uupper","llower") {
			dis as err ///
			    "option shape(full) invalid with vectorized input"
			exit 198
		}
		if inlist("`shape'","uupper","llower") {
			// lower or upper triangle EXCLUDING the diagonal
			local dim = chop((sqrt(1+8*max(`dmr',`dmc'))+1)/2,1e-10)
			if `dim' != round(`dim') {
				dis as err	///
					"{p 0 0 2}size of vector `dmat' is " ///
					"invalid for a triangle of a square "///
					"matrix{p_end}"
				exit 503
			}
		}
		else {
			// lower or upper triangle INCLUDING the diagonal
			local dim = chop((sqrt(1+8*max(`dmr',`dmc'))-1)/2,1e-10)
			if `dim' != round(`dim') {
				dis as err	///
					"{p 0 0 2}size of vector `dmat' is " ///
					"invalid for a triangle of a square "///
					"matrix{p_end}"
				exit 503
			}
		}

		tempname thed
		matrix `thed' = J(`dim',`dim',0)
		if `dmc' == 1 {
			tempname DIN
			matrix `DIN' = `dmat''
		}
		else {
			local DIN `dmat'
		}

		if "`shape'" == "uupper" {		// upper (no diag)
			local ij 0
			forvalues i = 1/`=`dim'-1' {
				forvalues j = `=`i'+1'/`dim' {
					matrix `thed'[`i',`j'] = `DIN'[1,`++ij']
					matrix `thed'[`j',`i'] = `thed'[`i',`j']
				}
			}
		}
		else if "`shape'" == "llower" {		// lower (no diag)
			local ij 0
			forvalues i = 2/`dim' {
				forvalues j = 1/`=`i'-1' {
					matrix `thed'[`i',`j'] = `DIN'[1,`++ij']
					matrix `thed'[`j',`i'] = `thed'[`i',`j']
				}
			}
		}
		else if "`shape'" == "upper" {		// upper (with diag)
			local ij 0
			forvalues i = 1/`dim' {
				forvalues j = `i'/`dim' {
					matrix `thed'[`i',`j'] = `DIN'[1,`++ij']
					matrix `thed'[`j',`i'] = `thed'[`i',`j']
				}
			}
		}
		else {					// lower (with diag)
			local ij 0
			forvalues i = 1/`dim' {
				forvalues j = 1/`i' {
					matrix `thed'[`i',`j'] = `DIN'[1,`++ij']
					matrix `thed'[`j',`i'] = `thed'[`i',`j']
				}
			}
		}

	}
	else {		// rectangular matrix

		dis as err	///
			"`dmat' invalid; neither square-symmetric, nor vector"
		exit 503

	}

	NumNegs `thed'
	if `r(negs)'!=0  {	// negative dissimilarities
		di as err "negative " ///
			plural(`r(negs)',"dissimilarity","dissimilarities") ///
			" found in `dmat'"
		// using 559 as a matrix analogy to 459 data error
		exit 559
	}


	if "`clear'"=="" & "`add'"=="" & `c(N)'!=0 {
		di as err "add or clear are required when a dataset is present"
		exit 198
	}

	if `c(N)' == 0 {
		if "`if'`in'" != "" {
			di as err "if and in not allowed with empty dataset"
			exit 198
		}
	}

	if "`clear'" != "" {
		if "`add'" != "" {
			di as err "add and clear may not be specified together"
			exit 198
		}
		if "`if'`in'" != "" {
			di as err "clear not allowed with if and in"
			exit 198
		}
		capture cluster drop _all
		capture drop _all
	}

	if "`labelvar'" != "" {
		confirm new variable `labelvar'
	}

	if `c(N)' == 0 {
		set obs `= colsof(`thed')'
	}

	marksample touse, novarlist
	qui count if `touse'
	if r(N) != colsof(`thed') {
		di as err ///
		"number of selected observations must match dimension of `dmat'"
		exit 198
	}

	cluster set `name' , add type(hierarchical) method(`method') ///
				dissimilarity(user matrix `dmat')
	local cname `r(name)'

	capture noi ParseGen `cname' `generate'
	if _rc {
		cluster drop `cname'
		exit _rc
	}
	local idvar `s(id)'
	local ordvar `s(ord)'
	local hgtvar `s(hgt)'
	local phtvar `s(pht)'
	local varops `"idvar(`idvar') ordvar(`ordvar') hgtvar(`hgtvar')"'
	local varops `"`varops' phtvar(`phtvar')"'

	capture noi {
		_clustermat if `touse', dmatrix(`thed') `method' `varops'

		ReformatDisp `idvar' `ordvar' `hgtvar'

		CheckPHTvar `phtvar'
		if `r(nopht)' {
			qui drop `phtvar'
			cluster set `cname', var(id `idvar')	///
				var(order `ordvar')		///
				var(height `hgtvar')
		}
		else {
			cluster set `cname', var(id `idvar')	///
				var(order `ordvar')		///
				var(real_height `hgtvar')	///
				var(pseudo_height `phtvar')
		}

		if "`labelvar'" != "" {
			AddLabVar `labelvar' `touse' `thed'
		}

		cluster set `cname', other(cmd `cmd')
	}
	if _rc {
		local therc = _rc
		capture cluster drop `cname'
		if "`labelvar'" != "" {
			capture drop `labelvar'
		}
		exit `therc'
	}
end


* ClustClean -- cleans up the data cluster characteristics getting rid of any
*               of them where the associated variables or chars are missing.
*
program ClustClean
	cluster query
	local names `r(names)'
	foreach name of local names {
		local bad 0
		cluster query `name'

		local allofem `"`r(type)'`r(method)'`r(dissimilarity)'"'
		local allofem `"`allofem'`r(similarity)'`r(note1)'"'
		local allofem `"`allofem'`r(v1_tag)'`r(c1_tag)'`r(o1_tag)'"'
		if `"`allofem'"' == "" {
			cluster del `name' , zap
			continue
		}

		local i 1
		while `"`r(v`i'_tag)'"' != "" {
			capture confirm var `r(v`i'_name)'
			if _rc {
				local bad 1
				continue, break
			}
			local i = `i' + 1
		}
		if `bad' {
			cluster del `name' , zap
			continue
		}

		local i 1
		while `"`r(c`i'_tag)'"' != "" {
			if `"`r(c`i'_val)'"' == "" {
				local bad 1
				continue, break
			}
			local i = `i' + 1
		}
		if `bad' {
			cluster del `name' , zap
		}
	}
end


* ParseGen -- Parse the generate() option.
*
*       , [ ... generate(stub) ... ]
*
* The calling routine has placed the clustername in front of what was passed
* in as the body of the -generate()- option.  We use the clustername if stub
* is empty.
*
* The id, ord, and hgt variables are always to be generated.  The pht (pseudo
* heights) variable is also created (and will later be discarded if there were
* no reversals).  The variables are confirmed to be new but are not created.
*
* Returned:  s(id), s(ord), s(hgt), s(pht)   <-- variable names
*
program ParseGen, sclass
	args cname stub
	if `"`stub'"' == "" {
		local stub `cname'
	}

	// the 1234 is used to check that stub is not too long
	capture confirm name `stub'1234
	if _rc {
		di as err `"`stub' invalid stub name"'
		exit 7
	}

	confirm new var `stub'_id `stub'_ord `stub'_hgt `stub'_pht

	sreturn local id `stub'_id
	sreturn local ord `stub'_ord
	sreturn local hgt `stub'_hgt
	sreturn local pht `stub'_pht
end


program CheckPHTvar, rclass
	capture assert `1' == .
	if _rc {
		ReformatDisp `1'
		return local nopht 0
	}
	else {
		return local nopht 1
	}
end


program ReformatDisp
	qui compress `0'
	foreach x of local 0 {
		local xtype : type `x'
		if "`xtype'" == "byte" | "`xtype'" == "int" {
			format `x' %8.0g
		}
		else if "`xtype'" == "long" {
			format `x' %12.0g
		}
		else if "`xtype'" == "float" {
			format `x' %9.0g
		}
		else if "`xtype'" == "double" {
			format `x' %10.0g
		}
	}
end

program Parse_shape, sclass
	local 0 , `0'
	syntax [, Lower Upper LLower UUpper Full]
	local arg `lower' `upper' `full' `llower' `uupper'
	if `:list sizeof arg' > 1 {
		dis as err "option shape() invalid"
		exit 198
	}
	sreturn local arg `arg'
end

program NumNegs, rclass
	// counts number of negative values in lower triangle of matrix
	args mat
	local cnt 0
	forvalues i = 1/`=rowsof(`mat')' {
		forvalues j = 1/`i' {
			if `mat'[`i',`j'] < 0 {
				local ++cnt
			}
		}
	}
	return scalar negs = `cnt'
end

program AddLabVar
	// Create string var `labelvar' containing rownames of matrix `dmat'
	args labelvar touse dmat

	// count of `touse' previously verified to equal dimensions of dmat

	qui gen str1 `labelvar' = ""

	local dnames : rownames `dmat'
	local i 1
	foreach dname of local dnames {
		while !`touse'[`i'] {
			local ++i
		}
		qui replace `labelvar' = "`dname'" in `i'
		local ++i
	}
end
