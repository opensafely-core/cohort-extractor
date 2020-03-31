*! version 2.2.1  09sep2017
program mds, eclass byable(onecall)
	global T_mds_version : di string(_caller())
	version 9, user		// 'user' for matrix stripes

	if replay() {
		if _by() {
			error 190
		}
		if "`e(cmd)'" != "mds" {
			dis as err "mds estimation results not found"
			exit 301
		}
		Display `0'
		exit
	}

	if _by() {
		by `_byvars'`_byrc0' : Estimate `0'
	}
	else {
		Estimate `0' 
	}
	ereturn local cmdline `"mds `0'"'
	
	capture global drop T_mds_version
end


program Estimate, eclass byable(recall) sortpreserve

	#del ;
	syntax  varlist(numeric) [if] [in] ,
		ID(varname)
	[
	// data options
		MEAsure(str)
		s2d(str)
		STD
		STDv(string)
		UNIT
		UNITv(string)
	// model options
		METhod(str)
		LOSS(passthru)
		TRANSformation(passthru)               // doc as transform()
		DIMensions(numlist integer >=1 max=1)  // doc as dim()
		WEight(passthru)                       // undoc: used for error msg
		noSORTID                               // undocumented
		*
	];
	#del cr

	_nostrl error : `id'
	
	tempvar orig_order 
	gen `orig_order' = _n


	mds_parse_method `method', `loss' `transformation'
	local loss        `s(loss)'
	local losstitle   `s(losstitle)'
	local transf      `s(transf)'
	local transftitle `s(transftitle)' 	
	local classical `s(classical)'

	
/* might try to put in a weight matrix like in -mdsmat- so ... */
	if `"`weight'"' != "" {
		dis as err "mds does not allow observation weights"
		dis as err "note that mdsmat and mdslong allow pairwise (dyadic) weights"
		exit 198
	}	

	mds_parse_cdopts `"`options'"' "`classical'"
	local copts `s(copts)'  	
	local dopts `s(dopts)'

	parse_dissim `measure'
	local dname `s(unab)'    // measure
	local dtype `s(dtype)'   // (dis)similarity

	if `"`s2d'"' != "" {
		if "`dtype'" == "dissimilarity" {
			dis as err "s2d() allowed only with a similarity " ///
				   "measure; see {help measure option}"
			exit 198
		}
		mds_parse_s2d `s2d'
		local s2d `s(s2d)'
	}
	else if "`dtype'" == "similarity" {
		local s2d standard
	}

	if "`dimensions'" != "" {
		local p   `dimensions' 
		local dim dim(`p')
	}
	
	marksample touse
	quietly count if `touse'
	local N = r(N)
	if (`N' == 0)  error 2000
	if (`N' == 1)  error 2001

	if "`std'" != "" & "`stdv'" != "" {
		opts_exclusive "std std()"
	}
	if "`unit'" != "" & "`unitv'" != "" {
		opts_exclusive "unit unit()"
	}
	if "`std'" != "" {
		local stdv _all
	}
	if "`unit'" != "" {
		local unitv _all
	}
	if "`stdv'" != "" {
		capture noi unab stdv : `stdv'
		if _rc {
			di as err "std() must contain a varlist"
			exit 198
		}
	}
	if "`unitv'" != "" {
		capture noi unab unitv : `unitv'
		if _rc {
			di as err "unit() must contain a varlist"
			exit 198
		}
	}

	/*
		if "`:list stdv - varlist'" != "" {
			dis as txt "(std() contains variables not in varlist)"
		}
		if "`:list unitv - varlist'" != "" {
			dis as txt "(unit() contains variables not in varlist)"
		}
	*/

	if "`:list stdv & unitv'" != "" {
		dis as err "options std() and unit() may not have variables in common"
		exit 198
	}

// check id --------------------------------------------------------

	tempvar ID idcoding

	mds_id2string `id', touse(`touse') gen(`ID') nosortid
	
	local idtype `r(idtype)'
	local duplicates = `r(duplicates)'
	if "`idtype'"!="int" & `duplicates'==0 {
		local mxlen = `r(mxlen)'
		local labels `"`r(labels)'"'
	}
	if "`idtype'" != "str" { 
		matrix `idcoding' = r(idcoding)
	}
	
// compute dissimilarity matrix of observations --------------------

	tempname Coding D X

	local nvar : list sizeof varlist
	
	matrix `Coding' = J(`nvar',1,0), J(`nvar',1,1)
	matrix rownames `Coding' = `varlist'
	matrix colnames `Coding' = loc scale

	if "`unitv'`stdv'" != "" {
		local ustd : list stdv | unitv

		local i = 0
		foreach v of local varlist {
			local ++i
			if !`:list v in ustd' {
				local Varlist `Varlist' `v'
				continue
			}

			tempvar v`i'
			quietly summ `v' if `touse'
			if r(sd) < 1e-8*(1+abs(r(mean))) {
				dis as err "variable `v' is (almost) constant"
				exit 198
			}

			if `:list v in unitv' {
				matrix `Coding'[`i',1] = r(min)
				matrix `Coding'[`i',2] = r(max)-r(min)
			}
			else {
				matrix `Coding'[`i',1] = r(mean)
				matrix `Coding'[`i',2] = r(sd)
			}

			quietly gen `v`i'' = ///
			   (`v'-`Coding'[`i',1])/`Coding'[`i',2] if `touse'
			local Varlist `Varlist' `v`i''
		}
	}
	else {
		local Varlist `varlist'
	}

	matrix dissim `D' = `Varlist' if `touse' , `dname' name(`ID')

	// convert to dissimilarities
	if "`s2d'" != "" {
		mds_s2d `D', `s2d'
	}

// MDS on dissimilarity matrix --------------------------------------
	
	if "`classical'" != "" {
		mds_classical `D', `dim' `copts'
	}
	else {
		version $T_mds_version : ///
		mds_modern `D', loss(`loss') transform(`transf') `dim' `copts'
	}

// save results from r() into e() and display -----------------------


	if "`classical'" != "" {
		quietly ereturn post, esample(`touse') properties(nob noV eigen)
	}
	else {
		quietly ereturn post, esample(`touse') properties(nob noV)
	}

	foreach x in `:r(macros)' {
		if "`x'" == "rmsg" {
			local rmsg `r(`x')'
		}
		else if "`x'" == "seed" | "`x'" == "iseed" {
			ereturn hidden local `x' `r(`x')'
		}
		else {
			ereturn local `x' `r(`x')'
		}
	}
	foreach x in `:r(scalars)'  {
		if "`x'" == "rc"  {
			local rc `r(`x')'
			if `r(`x')' == 430 {
				eret scalar converged = 0
			}
			else if `r(`x')' == 0 & "`classical'" == "" {
				eret scalar converged = 1
			}
		}
		ereturn scalar `x' = r(`x')
	}
	if "`rc'" == "" {
		local rc 0
		ereturn scalar rc = 0
		if "`classical'" == ""{
			eret scalar converged = 1
		}
	}
	foreach x in `:r(matrices)' {
		matrix `X' = r(`x')
		ereturn matrix `x' = `X'
	}

	ereturn scalar N            = `N'
	ereturn matrix coding       = `Coding'
	ereturn local  varlist        `varlist'
	
	ereturn local  id             `id'
	ereturn local  idtype         `idtype'
	ereturn local  duplicates   = `duplicates'
	if "`idtype'" != "int" & `duplicates' == 0 {
		ereturn local labels  `"`labels'"'
		ereturn local strfmt  "str`mxlen'"
	}
	if "`idtype'" != "str" {
		ereturn matrix idcoding = `idcoding'
	}	

	ereturn local  dname        `dname'
	ereturn local  dtype        `dtype'
	ereturn local  s2d          `s2d'
	
	ereturn local  loss         `loss'
	ereturn local  losstitle    `losstitle'
	ereturn local  tfunction    `transf'
	ereturn local  transftitle  `transftitle'

	ereturn local  predict      mds_p
	ereturn local  marginsnotok _ALL
	ereturn local  cmd          mds
	ereturn local estat_cmd	    mds_estat

	if `rc' == 498 {
		ereturn clear
		di as err `"{p}`rmsg'{p_end}"'
		exit `rc'
	}
	if `"`rmsg'"' != "" {
		di as err `"{p}`rmsg'{p_end}"'
		if `rc' != 430 {
			exit `rc'
		}
	}
	Display, `dopts'
end


program Display
	syntax [, *]
	mds_display, `options'
end

exit
