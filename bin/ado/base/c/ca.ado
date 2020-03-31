*! version 1.1.6  13feb2015  
program ca, eclass byable(onecall)
	version 10.0

	if _caller() < 10 {
		if  strpos(`"`0'"', ",") > 0 {
			local oldstyle oldstyle
		}
		else {
			local oldstyle ", oldstyle"
		}
	}
	if replay() {
		if (_by()) {
			error 190
		}
		if ("`e(cmd)'" != "ca") {
			error 301
		}
		camat `0' `oldstyle'
		exit
	}

	if _by() {
		local bycmd `"bysort `_byvars' `_byrc0':"'
	}

	Preprocess_ca `"`bycmd'"' `"`0' `oldstyle'"'
	ereturn local cmdline `"ca `0'"'
end


program Preprocess_ca, eclass
	args bycmd ca_args

	local 0 `"`ca_args'"'
	#del ;
	syntax anything [if] [in] [fw aw iw] ///
	[,
		REPort(passthru)
		MISsing
		ROWName(str)
		COLName(str)
		LENgth(passthru)
		MAXlength(integer 12)
		oldstyle
		* 		// options with ca.Estimate
	];
	#del cr
	local ca_opts `options' `missing' maxlength(`maxlength')

	marksample touse, novarlist

	if "`weight'" != "" {
		local wght `"[`weight'`exp']"'
	}
	if "`missing'" != "" {
		local keyword keyword
	}

// parse variable specification

	local crossed = 0
	forvalues i = 1/2 {
		gettoken spec anything: anything, match(pspec)
		local exist`i'  = "`pspec'"==""
		if !`exist`i''  {
			local crossed = 1
			// newvar = varlist
			gettoken newvar spec : spec, parse(" :")
			gettoken tok vlist  : spec, parse(" :")
			if `"`tok'"' != ":" {
				dis as err "invalid spec for " ///
				    cond(`i'==1, "rowvar", "colvar")
				dis as err ///
				    "expected syntax is (name : varlist)"
				exit 198
			}

			local 0 `newvar'
			syntax newvarname
			local name`i' `varlist'

			local 0 `vlist'
			syntax varlist(numeric) [, *]
			local defvars`i' `varlist'
			local defopt`i'  `options' // not documented
			if "`missing'" == "" {
				markout `touse' `defvars`i'' , strok
			}
		}
		else if `"`spec'"' != "" {
			// varname
			local 0 `spec'
			syntax varname(numeric)
			local usevar`i' `varlist'
			local name`i'   `varlist'
			if "`missing'" == "" {
				markout `touse' `usevar`i''
			}
		}
		else {
			dis as err "too few specifications"
			exit 102
		}
	}

	if `"`anything'"' != "" {
		dis as err `"unexpected input/too many variables: `anything'"'
		exit 103
	}

// create crossed (interaction) variables;
// in case of -by-, this is done only once

	forvalues i = 1/2 {
		if (!`exist`i'') {
			tempvar  usevar`i'
			tempname labelname`i' Coding`i'

			#del ;
			_mkcross `defvars`i'' if `touse',
				 gen(`usevar`i'')
			   	 genname(`name`i'') 
			   	 sep("/")
			   	 labelname(`labelname`i'')
			   	 coding(`Coding`i'')
			   	 `keyword'
				 `length'
			   	 `report'
			   	 `defopt`i'' maxlength(`maxlength') ;
			#del cr
		}
	}
// if user has or has not specified rownames or colnames
	if `"`rowname'"' != "" {
		local rowname rowname(`rowname')
	}
	else {
		local rowname rowname(`name1')
	}

	if `"`colnames'"' != "" {
		local colname colname(`colname')
	}
	else {
		local colname colname(`name2')
	}


// actual ca
	if `crossed' {
		local cross crossed
	}
	`bycmd' Estimate `usevar1' `usevar2' `wght' if `touse', ///
	           `rowname' `colname' `ca_opts' `cross' `oldstyle'

// clean up and define e(ca_data)

	ereturn local missing `missing'
	if !`exist1' | !`exist2' {
		ereturn local ca_data crossed

		// replace Rcoding and/or Ccoding
		// for compatibility with uncrossed storage
		//   we store transpose of coding matrices
		ereturn local Rcrossvars `defvars1'
		if (!`exist1') {
			matrix `Coding1' = `Coding1''
			ereturn matrix Rcoding = `Coding1'
		}

		ereturn local Ccrossvars `defvars2'
		if (!`exist2') {
			matrix `Coding2' = `Coding2''
			ereturn matrix Ccoding = `Coding2'
		}
	}
	else {
		ereturn local ca_data variables
	}
end


program Estimate, eclass byable(recall)
	#del ;
	syntax  varlist(numeric min=2 max=2)
	        [if] [in] [fw aw iw]
	[,
		MISsing
		DIMensions(passthru)   // documented as dim()
		DDIMensions(passthru)  // documented as ddim()
		FActors(passthru)      // undocumented synonym for dim()
		NORMalize(passthru)
		ROWSupp(string)
		COLSupp(string)
		oldstyle	      // undocumented version control
	// display options

		ROWName(string)
		COLName(string)
		noROWPoints
		noCOLPoints
		COMPact
		PLOT
		MAXlength(passthru)
		crossed
	];
	#del cr

	local display_opts `rowpoints' `colpoints' `compact' ///
	                   `plot' `maxlength' `ddimensions'

// sample

	gettoken rowvname colvname : varlist
	gettoken colvname : colvname
	Integer `rowvname'
	Integer `colvname'

	if ("`rowname'" == "") local rowname `rowvname'
	if ("`colname'" == "") local colname `colvname'

	marksample touse, novarlist
	if "`missing'" == "" {
		markout `touse' `varlist'
	}
	quietly count if `touse'==1
	if r(N) == 0 {
		error 2000
	}

// form table to be analyzed

	tempname P Rcoding Ccoding

	if "`weight'" != "" {
		local wght `"[`weight'`exp']"'
	}
   	_bigtab `rowvname' `colvname' if `touse' `wght', `missing'

	matrix `P'       = r(F)

	matrix `Rcoding' = r(rowcoding)'
	matrix `Ccoding' = r(colcoding)

	local nr = colsof(`Rcoding')
	local nc = colsof(`Ccoding')

	matrix rownames `Rcoding' = `rowvname'
	numlist `"1/`nr'"'
	matrix colnames `Rcoding' = `r(numlist)'

	matrix rownames `Ccoding' = `colvname'
	numlist `"1/`nc'"'
	matrix colnames `Ccoding' = `r(numlist)'

	if `nr' == 1 {
		dis as err "variable `rowvname' does not vary"
		exit 198
	}
	if `nc' == 1 {
		dis as err "variable `colvname' does not vary"
		exit 198
	}

	LabList `colvname' `Ccoding'
	matrix colnames `P' = `r(lab)'

	LabList `rowvname' `Rcoding'
	matrix rownames `P' = `r(lab)'

	if "`rowsupp'" != "" {
		confirm matrix `rowsupp'
		if colsof(`rowsupp') != `nc' {
			dis as err "rowsupp() invalid; " ///
			    "`rowsupp' should have `nc' columns"
			exit 503
		}
		local rowsupp rowsupp(`rowsupp')
	}

	if "`colsupp'" != "" {
		confirm matrix `colsupp'
		if rowsof(`colsupp') != `nr' {
			dis as err "colsupp() invalid; " ///
			    "`colsupp' should have `nr' rows"
			exit 503
		}
		local colsupp colsupp(`colsupp')
	}

// invoke camat on P

	#del ;
	camat `P', `dimensions'
		   `factors'
		   `ddimensions'
	  	   `normalize'
	  	   `rowsupp'
	  	   `colsupp'
	  	   rowname(`rowname')
	  	   colname(`colname')
	  	   nodisplay `oldstyle';
	#del cr

// repost, adding some stuff

	ereturn repost, esample(`touse')

	ereturn matrix Rcoding = `Rcoding'
	ereturn matrix Ccoding = `Ccoding'

	ereturn local  wtype     `"`weight'"'
	ereturn local  wexp      `"`exp'"'
	if "`crossed'"=="" {
		ereturn local  varlist   `varlist'
	}

// display
	camat, `display_opts' `oldstyle'
end

// ------------------------------------------------------------------ utilities

// LabList v RV
//
// returns in r(lab) a list of the value-labels of the values in the row vector
// RV according to the value labels associated with variable v.  The labels are
// edited to make them suitable for use in matrix stripes.
//   -- missing values are coded as strings (sysmiss, dota, ..., dotz).
//   -- additional period are removed,
//   -- quotes are removed
//   -- spaces are replaced by underscores. and
//   -- labels are truncated at 32 chars if necessary.
//
program LabList, rclass
	args v RV

	forvalues i = 1 / `=colsof(`RV')' {
		local ll : label (`v') `=`RV'[1,`i']'
		if `"`ll'"' == "." {
			local ll sysmiss
		}
		else if length(`"`ll'"')==2 & bsubstr(`"`ll'"',1,1)=="." {
			local ll = "dot" +  bsubstr(`"`ll'"',2,1)
		}
		else {
			local ll : subinstr local ll "'" "", all
			local ll : subinstr local ll " " "_", all
			local ll : subinstr local ll "." "" , all
			local ll : subinstr local ll `"""' "" , all
			local ll = usubstr(`"`ll'"',1,32)
		}
		local lab `lab' `ll'
	}
	return local lab `lab'
end

// verifies that a variable is integer-valued
program Integer
	args v

	capture assert `v' == floor(`v') if !missing(`v')
	if _rc {
		dis as err "variable `v' is not integer-valued"
		exit 198
	}
end
exit
