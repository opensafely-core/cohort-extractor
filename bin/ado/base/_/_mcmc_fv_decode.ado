*! version 1.1.6  27jan2020
program _mcmc_fv_decode, sclass
	version 14.0

	args instr touse

	local outstr
	local keepstr
	local omit
	local vars
	local fvlablist

	if `"`instr'"' == "" {
		sreturn local instr    = `"`instr'"'
		sreturn local outstr   = `"`instr'"'
		sreturn local omitlist = ""
		sreturn local varlist  = ""
	}

	local isexpr 0
	local n = bstrlen(`"`instr'"')
	if bsubstr(`"`instr'"', 1, 1) == "(" & ///
		bsubstr(`"`instr'"', `n', 1) == ")" {
		local isexpr 1
	}

	if `"`touse'"' != "" {
		local touse if `touse'
	}

	// if it is a varlist with no expressions, expand it together 
	capture fvexpand `instr' `touse'
	if _rc == 0   {
		local varlist `"`r(varlist)'"'
		
		if `"`r(fvops)'"' == "true" {
			local fvlablist `fvlablist' `instr'
		}
		
		local n: word count `varlist'
		if `n' == 1 {
			// if there is no expansion, leave the input unchanged 
			local varlist `instr'
		}
		local vars `"`varlist'"'
		gettoken tok varlist: varlist
		while `"`tok'"' != "" {
			_ms_parse_parts `"`tok'"'
			local keepstr = `"`keepstr'`tok' "'
			if `"`r(omit)'"' == "0" {
				local omit "`omit'0 "
			}
			else {
				local omit "`omit'1 "
			}
			gettoken tok varlist: varlist
		}
		if `isexpr' {
			local keepstr `"(`keepstr')"'
		}
	}
	else {
		tempvar bmat

		// expand piecewise 
		local whitepad 0
		local eqlab

		local next TED
		while `"`next'"' != "" {

			local whitepad = bsubstr(`"`instr'"', 1, 1) == " "
			if `whitepad' == 1 & `"`keepstr'"' != "" {
				local keepstr = `"`keepstr' "'
			}
			if `whitepad' == 1 & `"`outstr'"' != "" {
				local outstr  = `"`outstr' "'
			}

			gettoken eqlab instr: instr, ///
				parse("\ ,{}:") match(paren) bind

		if `"`eqlab'"' != "" {
			// ts operands: translate (LFDS)1.* to (LFDS).*
			capture _ms_parse_parts `eqlab'
			if _rc == 0 {
				capture confirm name `r(name)'
			}
			if _rc == 0 & "`r(ts_op)'" != "" {
				if `"`r(op)'.`r(name)'"' != `"`eqlab'"' {
					local lglobal MCMC_TSSUB_`r(ts_op)'
					global `lglobal' = $`lglobal' + 1
					local lglobal MCMC_TSSUB_`r(ts_op)'_words
					global `lglobal' $`lglobal' `eqlab'
				}
				local eqlab `r(op)'.`r(name)'
			}
		}
			gettoken next : instr, /// don't overwrite `paren'
				parse("\ ,{}:") match(paren2) bind
			if `"`next'"' == ":" {	
				gettoken next instr: instr, ///
					parse("\ ,{}:") match(paren) bind
				local keepstr = `"`keepstr'`eqlab':"'
				local outstr  = `"`outstr'`eqlab':"'
				gettoken next instr: instr, ///
					parse("\ ,{}:") match(paren) bind
			}
			else {
				local next `"`eqlab'"'
				local eqlab
			}
			
			if `"`paren'"' == "(" {
				local keepstr = `"`keepstr'("'
			}

			local bkeep 1

			local eqlabind  0
			local neqparams 0

			local lablist $MCMC_eqlablist
			if `"`eqlab'"' != "" {
				gettoken eqlabel lablist : lablist
				local eqlabind 1
				while `"`eqlabel'"' != "" & ///
					`"`eqlabel'"' != `"`eqlab'"' {
					gettoken eqlabel lablist : lablist
					local `++eqlabind'
				}
				if `"`eqlabel'"' != `"`eqlab'"' {
					local eqlabind 0
				}
				local eqparams MCMC_beta_`eqlabind'
				local eqparams $`eqparams'
				local neqparams : word count `eqparams'
				if `neqparams' > 0 {
					cap matrix `bmat' = J(1,`neqparams',0)
					if _rc {
						global MCMC_matsizeerr = ///
							$MCMC_matsizeerr + 1
						global MCMC_matsizemin `neqparams'
						local neqparams 0
					}
					else {
						mat colnames `bmat' = `eqparams'
					}
				}
			}
			else if `"`lablist'"' != "" {
				// use the first eqparams list
				gettoken eqlab : lablist
				local eqparams MCMC_beta_1
				local eqparams $`eqparams'
				local neqparams : word count `eqparams'
				if `neqparams' > 0 {
					cap matrix `bmat' = J(1,`neqparams',0)
					if _rc {
						local neqparams 0
					}
					else {
						mat colnames `bmat' = `eqparams'
					}
				}
			}

			capture _ms_parse_parts `"`next'"'
			if _rc == 0 {
				capture confirm name `r(name)'
			}
			if _rc == 0 & "`r(ts_op)'" != "" {
				if `"`r(op)'.`r(name)'"' != `"`next'"' {
					local lglobal MCMC_TSSUB_`r(ts_op)'
					global `lglobal' = $`lglobal' + 1
					local lglobal MCMC_TSSUB_`r(ts_op)'_words
					global `lglobal' $`lglobal' `next'
				}
				local next `r(op)'.`r(name)'
			}

			// expand only *.* 
			tokenize `"`next'"', parse(".#(")
			if `"`1'"' == "i" & `"`2'"' == "." & `"`3'"' != "(" {
				confirm variable `3'
			}
			// fvexpand all i*.* 
			capture fvexpand `next' `touse'
			if _rc == 907 {
				// reproduce the error
				fvexpand `next' `touse'
			}
			if _rc {
				local varlist ""
			}
			else {
				local varlist `"`r(varlist)'"'
				if `"`r(fvops)'"' == "true" {
					local fvlablist `fvlablist' `next'
				}
			}

			if `neqparams' > 0 {
				_unab_match `varlist', matrix(`bmat')
				local varlist `s(varlist)'
			}
			else {
				local nwords : word count `varlist'
				if `nwords' == 1 {
					// if nothing has expanded, keep `next'
					local varlist `"`next'"'
				}
			}

			if _rc == 0 & `"`varlist'"' != "" {
				local vars `"`vars' `varlist'"'
				gettoken tok varlist: varlist
				while `"`tok'"' != "" {
					_ms_parse_parts `"`tok'"'
					local keepstr = ///
						`"`keepstr' `tok'"'
					if `"`r(omit)'"' == "0" {
						local omit "`omit'0 "
					}
					else {
						local omit "`omit'1 "
					}
					gettoken tok varlist: varlist
				}
				local bkeep 0
			}
	
			if `bkeep' {
				if regexm(`"`next'"', "i\.") & !`isexpr' {
					local next = regexr(`"`next'"',"i\.","")
					di as err "{bf:`next'}: " _c
					cap noi error 907
di as red _n "{p 4 4}If you are using option {bf:reffects()}"
di as err "or {bf:redefine()} to include random-effects parameters,"
di as err "you may have exceeded the current maximum number of "
di as err "random-effects levels; see help {help maxvar}.{p_end}"
					exit 907
				}
				local keepstr = `"`keepstr'`next'"'
			}
			if `"`paren'"' == "(" {
				local keepstr = `"`keepstr')"'
			}
			local outstr = `"`outstr'`next'"'
		}
	}

	if regexm(`"`keepstr'"', "i\.") & !`isexpr' {
		di as err `"{bf:`keepstr'} contains invalid factor variable"'
		exit 198
	}

	local ct 1
	while `ct' > 0 {
		local keepstr : subinstr local keepstr ": " ":", count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local keepstr : subinstr local keepstr " :" ":", count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local keepstr : subinstr local keepstr "{ " "{", count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local keepstr : subinstr local keepstr " }" "}", count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local keepstr : subinstr local keepstr "( " "(", count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local keepstr : subinstr local keepstr " )" ")", count(local ct)
	}

	sreturn local instr    = `"`outstr'"'
	sreturn local outstr   = `"`keepstr'"'
	sreturn local omitlist = `"`omit'"'
	sreturn local varlist  = `"`vars'"'
	sreturn local fvlablist = `"`fvlablist'"'
end

program _unab_match, sclass

	syntax [anything] , MATrix(name)

	local COLNA : colna `matrix'
	local i 0
	foreach X of local COLNA {
		local X`++i' : copy local X
	}

	local keepordrop = c(emptycells)
	set emptycells keep
	cap _unab `anything', matrix(`matrix')
	set emptycells `keepordrop'
	if _rc==111 { 
		//ignore variable not found error
		sreturn local varlist "`anything'"
		exit
	}
	else if _rc {
		_unab `anything', matrix(`matrix')
	}

	local VARLIST `"`r(varlist)'"'
	foreach X of local VARLIST {
		local i = colnumb(`matrix', "`X'")
		if `i' == . {
			local X : subinstr local X "b." ".", all
			local i = colnumb(`matrix', "`X'")
		}
		if `i' != . {
			local varlist `"`varlist' `X`i''"'
		}
		else {
			sreturn local varlist "`anything'"
			exit
		}
	}

	sreturn local varlist `"`:list retok varlist'"'
end
