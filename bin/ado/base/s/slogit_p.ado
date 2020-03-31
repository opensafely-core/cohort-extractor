*! version 1.1.6  21oct2019
/* predict for slogit */
program define slogit_p
        version 9
	if "`e(cmd)'" != "slogit" {
		di as error "{p}stereotype logistic regression " ///
	"estimates from {help slogit##|_new:slogit} not found{p_end}"
		exit 301
	}

	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		global STEREO_nreg	`e(k_indvars)'
		global STEREO_dim	`e(k_dim)'
		global STEREO_nlev	`e(k_out)'
		tempname levels
		matrix `levels' = e(outcomes)
		forval i = 1/`e(k_out)' {
			if (`i' == e(i_base)) continue
			local valist `"`valist' `i'"'
		}
		global STEREO_levels	`valist' `e(i_base)'
		global STEREO_base	`e(i_base)'
		local dl : word count `valist'
		// identify the score variables
		forvalues dm = 1/$STEREO_dim {
			local dbv `"`dbv' dbv`dm'"'
			forval i = 1/`dl' {
				local dpv `"`dpv' dpv`dm'`i'"'
			}
		}
		forval i = 1/`dl' {
			local dtv `"`dtv' dtv`i'"'
		}
		global STEREO_dv `dbv' `dpv' `dtv'
		/* create a proper factor variable for the response */
		marksample touse, novarlist
		markout `touse' `e(indvars)'
		tempvar fdepvar
		qui egen `fdepvar' = group(`e(depvar)') if `touse'
		global STEREO_resp `"`fdepvar'"'

		cap noi ml score `0'
		local rc = _rc
		macro drop STEREO_*
		exit `rc'
	}

        syntax anything(name=vlist id="varlist") [if] [in] ///
		[, Outcome(string) EQuation(string) XB STDP Pr INDex SEIndex]

        local nopt : word count `xb' `stdp' `pr' `index' `seindex'
        if `nopt' > 1 {
                di as error "{p}only one of options {bf:pr}, {bf:xb}, {bf:index}, " ///
		 "{bf:stdp}, or {bf:seindex} can be specified{p_end}"
                exit 198
        }
	if "`equation'" != "" {
		if "`outcome'" != "" {
			di as error "{p}options {bf:outcome()} and " ///
			 "{bf:equation()} may not be specified together{p_end}"
			exit 198
		}
		local outcome `equation'
		local equation
	}
	marksample touse, novarlist
	markout `touse' `e(indvars)'

	local type "`xb'`stdp'`pr'`index'`seindex'"        

	if "`type'"=="xb" | "`type'"=="index" ///
	 | "`type'"=="stdp" | "`type'"=="seindex" {
        	syntax newvarlist [if] [in] [, * ]
		local nvar : word count `varlist'
		if `"`outcome'"' == "" {
			local outcome "#1"
		}
		if `nvar' > 1 {
			di as error "{p}only one new variable can be " ///
 			 "specified with option {bf:`type'}{p_end}"
			exit 103
		}
		if index("`vlist'","*") {
			di as err "{p}`vlist' may not be " ///
 			 "specified with option {bf:`type'}{p_end}"
			exit 198
		}
        }
	else {
		if "`type'" == "" {
			di in gr "(option {bf:pr} assumed; predicted probabilities)"
		}
		local type "pr"
		cap _stubstar2names `vlist', nvars(`e(k_out)') singleok outcome
		local rc = _rc
		if `rc' == 0 {
			local varlist `s(varlist)'
			local typlist `s(typlist)'
			local nvar : word count `varlist'
			if ("`outcome'"!="" & `nvar'>1) local rc = 103
		}
		if `rc' {
			if `rc'==102 | `rc'==103 {
				di as error "{p}must specify " e(k_out)      ///
				 " new variable names, or one new variable " ///
				 "name with the {bf:outcome()} option when " ///
				 "using the {bf:pr} option{p_end}"
				exit 198
			}
			error `rc'
		}
		if `nvar'==1 & "`outcome'"=="" {
			local outcome "#1"
		}
	}

	Outcome `outcome'
	local lev `s(outcome)'	
	tokenize `typlist'

	if "`type'"=="xb" | "`type'"=="index" {
		tempvar xb
		qui Xbeta `lev' `xb' `1' `touse'
		gen `1' `varlist' = `xb'
		label var `varlist' `"Index, `e(depvar)'=`=abbrev("`e(out`lev')'",17)'"'
	}
	else if "`type'" == "pr" {
		qui Predict `"`varlist'"' `1' `touse' `lev'
	}
	else { /* if "`type'"=="stdp" | "`type'"=="seindex" */
		tempvar var 
		local type `1'
		tempname b theta phi V X

		local covar `"`e(indvars)'"'
		local dim  = e(k_dim)
		matrix `b' = e(b)
		scalar `phi' = 0.0

		tempvar zero one
		qui gen double `zero' = 0.0 if `touse'
		qui gen double `one' = 1.0 if `touse'
		forvalues dm = 1/`dim' {
			tempvar xb`dm' 
			qui _predict `type' `xb`dm'' if `touse', xb equation(dim`dm')
			qui replace `xb`dm'' = -`xb`dm'' if `touse'

			if `lev' != e(i_base) {
				local k = colnumb(`b',"phi`dm'_`lev':")
				scalar `phi' = `b'[1,`k']
			}
			if abs(`phi') < c(epsdouble) {
				foreach vari of local covar {
					local blist `"`blist' `zero'"'
				}
			}
			else {
				foreach vari of local covar {
					tempvar x
					qui gen `type' `x' = -`phi'*`vari'
					local blist `"`blist' `x'"'
				}
			}
			forvalues i = 1/`e(k_out)' {
				if `i' == e(i_base) {
					continue
				}
				if `lev' == `i' {
					local plist `"`plist' `xb`dm''"'
					if `dm' == 1 {
						local tlist `"`tlist' `one'"'
					}
				}
				else {
					local plist `"`plist' `zero'"'
					if `dm' == 1 {
						local tlist `"`tlist' `zero'"'
					}
				}
			}
		}	
		local nb = e(k)
		qui gen `type' `var' = .
		mata: QuadProd("`blist'`plist'`tlist'", "`var'", "`touse'")
		gen `type' `varlist' = `var'
		local outlev `"`e(depvar)'=`=abbrev("`e(out`lev')'",17)'"'
		label var `varlist' `"Standard error of the index, `outlev'"'
	}
	sret clear
end

program Outcome, sclass
	local o = trim(`"`0'"')

	if "`o'" == "" {
		sreturn local outcome
		exit
	}

	if bsubstr(`"`o'"',1,1) == "#" {
		local i = bsubstr(`"`o'"',2,.)
		cap confirm integer number `i'
		if _rc > 0 {
			di as error "the outcome index must follow the # " ///
			 "in {bf:outcome(`o')}"
			exit 198
		}
		if `i' < 1 | `i' > e(k_out) {
			di as error "{p}the outcome index specified with # " ///
			 "must be an integer between 1 and `=e(k_out)' "     ///
			 "inclusive{p_end}"
			exit 198
		}
		sreturn local outcome = `i'
		exit
	}
	cap confirm number `o'
	if _rc == 0 {
	       	forvalues i = 1/`e(k_out)' {
			local j = el(e(outcomes),`i',1)
			if `j' == `o' {
				sreturn local outcome = `i'
				continue, break	
			}
		}
	}
	if "`s(outcome)'" == "" {
       		forvalues i = 1/`e(k_out)' {
			if `"`e(out`i')'"' == `"`o'"' {
				sreturn local outcome = `i'
				continue, break	
			}
		}
	}
	if "`s(outcome)'" == "" {
		di as error "{p}{bf:`o'} is not one of the outcomes{p_end}"
		exit 322
	}
end
 
program Xbeta
	args lev xb type touse

	tempname bij b

	tempvar tx
	if `lev' == e(i_base) {
		cap confirm new variable `xb'
		if _rc == 0 {
			qui gen `type' `xb' = 0.0 if `touse'
		}
		else {
	       	        qui replace `xb' = 0.0 if `touse'
		}
		exit
        }
	
	matrix `b' = e(b)
	local k = colnumb(`b',"theta`lev':")
	scalar `bij' = el(`b',1,`k')
	cap confirm new variable `xb'
	if _rc == 0 {
		qui gen `type' `xb' = `bij' if `touse'
	}
	else {
		qui replace `xb' = `bij' if `touse'
	}

	forvalues dm = 1/`e(k_dim)' {
		tempvar xb`dm'
		local k = colnumb(`b',"phi`dm'_`lev':")
		scalar `bij' = el(`b',1,`k')
		qui _predict `type' `xb`dm'' if `touse', xb equation("dim`dm'")
		qui replace `xb' = `xb' - `bij'*`xb`dm'' if `touse'
	}	
end

program Predict
        args varlist type touse lev

        tempvar denom
        qui gen `type' `denom' = 0.0 if `touse'
        local nvar : word count `varlist'
        if `nvar' == 1 {
                tempvar vari
		tempvar vark
        }
                                                                                          
        forvalues i = 1/`e(k_out)' {
                if `nvar' > 1 {
                        tempvar var`i'
			local vari `var`i''
                }
                Xbeta `i' `vari' `type' `touse'
                replace `vari' = exp(`vari') if `touse'
                qui replace `denom' = `denom' + `vari' if `touse'
                if `nvar'==1 {
			if `i'==`lev' {
	                        qui gen `type' `vark' = `vari' if `touse'
			}
			drop `vari'
                }
        }
        if `nvar' > 1 {
                /* predict all levels */
		local i = 0
                foreach vari of local varlist {
			local `++i'
                        qui gen `type' `vari' = `var`i''/`denom' if `touse'
			local outi `"`=abbrev("`e(out`i')'",17)'"'
                        label var `vari' `"Pr(`e(depvar)'==`outi')"'
                }
        }
        else {
                qui gen `type' `varlist' = `vark'/`denom' if `touse'
		local outlev `"`=abbrev("`e(out`lev')'",17)'"'
                label var `varlist' `"Pr(`e(depvar)'==`outlev')"'
        }
end

mata:
function QuadProd(string scalar svar, string scalar sv, string scalar stou)
{
	real vector x
	real matrix V
	scalar i, n, iv, ix, itou

	ix = st_varindex(tokens(svar))
	iv = st_varindex(sv)
	itou = st_varindex(stou)
	V = st_matrix("e(V)")
	n = st_nobs()
	for (i=1; i<=n; i++) {
		if ( st_data(i,itou) ) {
			x = st_data(i,ix)
			st_store(i, iv, sqrt(x*V*x'))
		}
	}
}
end
