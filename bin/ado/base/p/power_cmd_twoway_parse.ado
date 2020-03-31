*! version 1.0.2  16feb2015

program define power_cmd_twoway_parse
	version 13
	syntax [anything], [ test * ]

	_power_twoway_test_parse `anything', `options'

	/* meansspec is now option meansspec(matnam) in rhs		*/
	c_local lhs
	c_local rest `"`s(rhs)'"'
end

program define _power_twoway_test_parse, sclass
	syntax [anything(name=meansspec)], pssobj(string) [ * ]

	local 0, `options'

	mata: st_local("solvefor", `pssobj'.solvefor)
	if "`meansspec'" != "" {
		tempname mspec
		_pss_chk_matspec `"{err:cell means}"' : `"`meansspec'"'
		local rows = `r(nrows)'
		local cols = `r(ncols)'
		if `rows'<=1 | `cols'<=1 {
			di as err "{p}invalid means specification; means " ///
			 "must have at least two rows and columns{p_end}"
			exit 198
		}
		local ngrps  (`rows',`cols')
		mat `mspec' = r(mat)
		mata: `pssobj'.setmatrix("`mspec'","means")
	}
	else {
		local rows = 0
		local cols = 0
	}
	_pss_syntax SYNOPTS : multileveltest
	syntax, [ `SYNOPTS' Factor(string) VAREFFect(string) varrow(string) ///
		VARCOLumn(string) VARROWCOLumn(string) VARERRor(string)     ///
		NRows(string) NCols(string) SHOWMATrices SHOWMEAns          ///
		SHOWCELLSizes * ]

	/* rewrite right hand side, rhs macro; no abbreviations,	*/
	/* otherwise pssobj will ignore pssobj.numopts built in 	*/
	/* call psobj.initonparse() below				*/

	local varrowcol `varrowcolumn'
	local k = ("`varrow'"!="")+("`varcolumn'"!="")+("`varrowcol'"!="")+ ///
			("`vareffect'"!="")
	local varopt = cond("`vareffect'"!="","vareffect",  ///
			cond("`varrow'"!="","varrow",       ///
			cond("`varcolumn'"!="","varcolumn", ///
			cond("`varrowcol'"!="","varrowcol",""))))
	local nperc balanced

	if "`meansspec'" != "" {
		if `k' {
			di as err "{p}option {bf:`varopt'()} cannot be " ///
			 "specified with the cell means{p_end}"
			exit 184
		}
		if "`solvefor'" == "esize" {
			di as err "{p}cell means cannot be specified when " ///
			 "solving for the effect size{p_end}"
			exit 198
		}
		if "`nrows'"!="" | "`ncols'"!="" {
			di as err "{p}options {bf:nrows()} or {bf:ncols()} " ///
			 "cannot be specified with the cell means{p_end}"
			exit 184
		}
		else if "`npercell'"!="" & "`cellweights'"!="" {
			di as err "{p}options {bf:cellweights()} and " ///
			 "{bf:npercell()} cannot be specified together{p_end}"
			exit 184
		}
		/* allow m#_# output columns				*/
		local means means
	}
	else if !`k' & "`solvefor'"!="esize" {
		if "`factor'" != "" {
			di as err "{p}either the cell means or option " ///
			 "{bf:vareffect()} must be specified{p_end}"
		}
		else {
			di as err "{p}either the cell means or one of "   ///
			 "{bf:vareffect()}, {bf:varrow()}, "              ///
			 "{bf:varcolumn()}, or {bf:varrowcol()} must be " ///
			 "specified{p_end}"
		}
		exit 198
	}
	else if "`solvefor'" == "esize" {
		if "`varopt'" != "" {
			di as err "{p}option {bf:`varopt'()} cannot be " ///
			 "specified when solving for effect size{p_end}"
			exit 198
		}
		if ("`factor'"=="") local factor row
	}
	else if `k' > 1 {
		di as err "{p}only one of {bf:vareffect()}, {bf:varrow()}, " ///
		 "{bf:varcolumn()}, or {bf:varrowcol()} can be specified{p_end}"
		exit 184
	}
	else if "`factor'"!="" & "`varopt'"!="vareffect" {
		di as err "{p}options {bf:factor()} and {bf:`varopt'()} " ///
		 "cannot be specified together{p_end}"
		exit 184
	}
	else if "`factor'"=="" & "`vareffect'"!="" {
		di as err "{p}option {bf:factor()} is required with option " ///
		 "{bf:vareffect()}{p_end}"
		exit 198
	}
	else {
		cap numlist "``varopt''", range(>0)
		if c(rc) { 
			di as err `"{p}invalid {bf:`varopt'(``varopt'')}: "' ///
			 "values must be greater than 0{p_end}"
			exit 198
		}
		if "`varopt'" != "vareffect" {
			/* convert varXXX() to factor() vareffect() 	*/
			/* syntax					*/
			local factor = bsubstr("`varopt'",4,strlen("`varopt'"))
		}
		/* factor() option added to rhs below			*/
		local rhs `"`rhs' vareffect(`r(numlist)')"'
	}
	if "`cellweights'" != "" {
		if ("`nfractional'"=="") local integer integer
		_pss_chk_matspec "{bf:cellweights()}" range(>0) `integer' : ///
			`"`cellweights'"'
		tempname mat
		mat `mat' = r(mat)
		local r = rowsof(`mat')
		local c = colsof(`mat')
		if !`rows' {
			local nrows = `r'
			local rows = `r'
		}
		if !`cols' {
			local ncols = `c'
			local cols = `c'
		}
		if `r'!=`rows' | `c'!=`cols' {
			di as err "{p}{bf:cellweights()} has dimensions " ///
			 "`r' x `c' but expected `rows' x `cols'{p_end}
			exit 504
		}
		/* do not worry about abbreviation			*/
		local cw cweights(`cweights')
		local rhs : list rhs - cw
		/* cweights now a flag that the matrix exists in pssobj	*/
		local rhs `"`rhs' cweights"'

		mata: `pssobj'.setmatrix("`mat'","cweights")
		local nperc cweights
	}
	if "`meansspec'" == "" {
		if "`nrows'"=="" | "`ncols'"==="" {
			di as err "{p}options {bf:nrows(}{it:#}{bf:)} and " ///
			 "{bf:ncols(}{it:#}{bf:)} are required when "       ///
			 "cell means are not given{p_end}"
			exit 198
		}
		ConfirmBoundedInteger nrows 2 : "`nrows'"
		ConfirmBoundedInteger ncols 2 : "`ncols'"

		local rhs `"`rhs' nrows(`nrows') ncols(`ncols')"'
		local rows = `nrows'
		local cols = `ncols'
		local ngrps  (`nrows',`ncols')
	}
	ParseFactor, `factor'
	local factor `s(factor)'
	local rhs `"`rhs' factor(`factor')"'

	/* default Var_r						*/
	local veffect = cond("`factor'"=="rowcol","Var_rc", ///
			cond("`factor'"=="column","Var_c","Var_r"))

	if "`n'" != "" {
		if "`npercell'" != "" {
			di as err "{p}options {bf:n()} and {bf:npercell()} " ///
			 "cannot be specified together{p_end}"
			exit 184
		}
	}
	else if "`npercell'" != "" {
		cap numlist `"`npercell'"', range(>0)
		local rc = c(rc)
		if `rc' {
			di as err "{p}invalid {bf:npercell()}: values " ///
			 "greater than zero are required{p_end}"
			exit `rc'
		}
		local rhs `"`rhs' npercell(`r(numlist)')"'
		local nperc nperc
	}
	if "`varerror'" != "" {
		cap numlist "`varerror'", range(>0)
		if c(rc) { 
			di as err "{p}invalid {bf:varerror(`varerror')}: " ///
			 "values must be greater than 0{p_end}"
			exit 198
		}
		local rhs `"`rhs' varerror(`r(numlist)')"'
	}
	if "`solvefor'"=="n" | "`solvefor'"=="esize" {
		local validate = cond("`solvefor'"=="esize","effect","N")

                _pss_chk_iteropts `validate', `options' pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
        }
	else if "`options'" != "" {
		_pss_error iteroptsnotallowed , `options' ///
			txt(when computing `solvefor')

		_pss_error optnotallowed "`options'" 
	}
	sreturn local lhs `"`mlist'"'
	sreturn local rhs `"`rhs'"'

	local show "`showmatrices' `showmeans' `showcellsizes'"
	
	/* initialize the number of groups in pss_multitest object	*/
	mata: `pssobj'.initonparse(`ngrps',"`veffect'","`nperc'","`means'", ///
			"`show'")
end

program define ConfirmBoundedInteger
	args which bound colon value
	cap confirm integer number `value'
	local rc = c(rc)
	if !`rc' {
		local rc = (`value'<`bound')
	}
	if `rc' {
		di as err "{p}invalid {bf:`which'(`value')}: integer " ///
		 "greater than or equal to `bound' is required{p_end}"
		exit 198
	}
end

program define ParseFactor, sclass
	cap syntax, [ row COLumn rowcol ]
	if c(rc) {
		di as err "{p}invalid {bf:factor(`factor')}: must be one " ///
		 "of {bf:row}, {bf:column}, or {bf:rowcol}{p_end}"
		exit 198
	}
	local k : word count `row' `column' `rowcol'
	if `k' > 1 {
		di as err "{p}invalid {bf:factor(`factor')}: only one of " ///
		 "{bf:row}, {bf:column}, or {bf:rowcol} is allowed{p_end}"
		exit 184
	}
	if (!`k') local factor row
	else local factor `row'`column'`rowcol'

	sreturn local factor `factor'
end

exit
