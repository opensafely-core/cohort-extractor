*! version 1.0.3  02dec2019

program define _mixlogit_p, rclass sortpreserve

	version 16

        gettoken panel 0 : 0
        if (`panel' > 0) local xt xt
        if (`panel' < 0) local cm as
        else local cm cm

	if ("`e(cmd)'" != "`cm'`xt'mixlogit") {
		di as error "{p}{help `as'`xt'mixlogit##|_new:`as'`xt'mixlogit} "    ///
                            "estimation results not found{p_end}" 
		exit 301
	}
	syntax 	anything(name=vlist id="varlist") 	///
			[if] [in] [iw] ,		///
			[ 				///
			Pr				///
			xb				///
			SCores				///
                        Outcome(string)                 ///
			altwise				///
                        j1(passthru)                    /// <-- UNDOCUMENTED
                        j2(passthru)                    /// <-- UNDOCUMENTED
                        dydx(varname numeric fv ts)     /// <-- UNDOCUMENTED
                        dyex(varname numeric fv ts)     /// <-- UNDOCUMENTED
                        eydx(varname numeric fv ts)     /// <-- UNDOCUMENTED
                        eyex(varname numeric fv ts)     /// <-- UNDOCUMENTED
                        ALTidx(string)                  /// <-- UNDOCUMENTED
                        bmat(string)                    /// <-- UNDOCUMENTED
			]

	local opt `pr' `xb' `scores'
	if ("`weight'" != "") {
                local wgtexp `"`exp'"'
        }

        if (`"`j1'"' != "" & `"`scores'"' != "") {
                di as err as smcl "{p 0 0 2 `s(width)'}" ///
                "options {bf:j1()} and {bf:scores} may not be combined"
                error 458
        }

	local nopt : word count `opt'
	if (`nopt' > 1) {
                di as err "only one prediction type allowed"
		di as err "{p 4 4 2}See "      ///
	`"{help `e(cmd)' postestimation##predict:`e(cmd)' postestimation} "' ///
	"for the prediction type options.{p_end}"
		exit 198
	}

        local ndx : word count `dydx' `dyex' `eydx' `eyex'
        if (`ndx' > 1) {
                di as err "only one derivative type allowed"
                exit 198
        }
        local j2xvar `dydx' `dyex' `eydx' `eyex'
        local j2alt `"`altidx'"'
        if ("`dydx'" != "") {
                local j2which dydx
        }
        else if ("`dyex'" != "") {
                local j2which dyex
        }
        else if ("`eydx'" != "") {
                local j2which eydx
        }
        else if ("`eyex'" != "") {
                local j2which eyex
        }

	tempname b
        mat `b' = e(b)
        tempvar ifin
        qui gen byte `ifin' = 1 `if'`in'
        marksample touse, novarlist

        if ("`cm'" != "as") {
                // altwise as per model fit (new for -cm-)
                local marktype = e(marktype)
                if ("`marktype'" == "altwise") {
                        local altwise altwise
                }
        }

        // predictions need an alternatives variable
        local alternatives `"`e(altvar)'"'
        if ("`alternatives'" == "") {
                di as err as smcl "{p}"   ///
                "predictions require specification " ///
                "of option {bf:alternatives()} in {bf:asxtmixlogit}{p_end}"
                exit 198
        }

        // varlists
	if ("`opt'" == "scores") {
		local nb = colsof(`b')
		_stubstar2names `vlist', nvars(`nb') singleok noverify
		local varlist `"`s(varlist)'"'
		local typlist `"`s(typlist)'"'
		local nsc: word count `varlist'
		if (`nsc' != `nb') {
			di as err `"{p}need `nb' new variable names, or "' ///
			 "use the {it:stub}{bf:*} wildcard syntax{p_end}"
			exit 198
		}
	}
	else {
		local 0 `vlist'
		syntax newvarlist(min=1 max=1)
		if ("`opt'" == "") {
			local opt pr
			di as txt `"(option {bf:pr} assumed; "' ///
                                  `"Pr(`alternatives'))"'
		}
	}
	local type : word 1 of `typlist'
	if ("`type'"!="double" & "`type'"!="float") {
		di as err "{p}type must be double or float; the default " ///
		          `"is c(type) = `c(type)'{p_end}"'
		exit 198
	}

	_mxlog_pred `typlist' `varlist', b(`b')                         ///
                                         opt(`opt')                     ///
                                         touse(`touse')                 ///
                                         alt(`alternatives')            ///
                                         outcome(`outcome')             ///
                                         ifin(`ifin')                   ///
                                         tlist(`typlist')               ///
                                         `altwise'                      ///
                                         panel(`panel')                 ///
                                        `j1' `j2'                       ///
                                        j2xvar(`j2xvar')                ///
                                        j2which(`j2which')              ///
                                        j2alt(`j2alt')                  ///
                                        wgtexp(`wgtexp')
end


program define _mxlog_pred

	syntax  newvarlist ,            ///
                b(string)               /// 
                opt(string)             /// 
                touse(varname)          ///
                [                       ///
                ALTernatives(varname)   ///
                outcome(string)         ///
                altwise                 ///
                ifin(varname)           ///
                tlist(string)           ///
                panel(integer 0)        ///
                j1(string)              ///
                j2(string)              ///
                j2xvar(varname numeric fv) ///
                j2which(string)         ///
                j2alt(string)           ///
                wgtexp(string)          ///
                ]

	// get stuff 
	local npf         = e(npf)
	local npr         = e(npr)
	local npreff      = e(npreff)
	local npteff      = e(npteff)
	local nmvst       = e(nmvst)
	local nprmoeff    = e(nprmoeff)
        local npfc        = e(npfc)
	local method      = e(intmethod)
	local burn        = e(intburn)
	local R           = e(intpoints)
	local N           = e(N_case)
	local N_obs       = e(N)
	local idgroup     = e(case)
	local depvar      = e(depvar) 
        local seq         = e(sequence)
        local kalt        = e(k_alt)
        local const       = e(const)
        local corrmetric  = e(corrmetric)
        local scalemetric = e(scalemetric)
        local cmd         = e(cmd)
        local hasts       = e(hasts)
        local panelid       `"`e(panelid)'"'
        if ("`method'" == "random") {
                local seed = e(mc_rngstate) 
        }
        if !`R' local R 1

	tempname fgin1 fgin2 npmreff omitm
	mat `fgin1'   = e(fg1)
	mat `fgin2'   = e(fg2)
	mat `npmreff' = e(npmr)
	mat `omitm'   = e(omitm)

	// getting varnames
        local vf `"`e(fixvars)'"'
        local vr `"`e(ranvars)'"'
        local vfc `"`e(casevars)'"'

        // Grabbing varlists from -e(b)- for -margins-
        if ("`vf'" != "") {
                tempname bf
                local npf `"`e(npf)'"'
                mat `bf' = `b'[1,1..`npf']
                local vf : colnames `bf'
        }
        if ("`vr'" != "") {
                tempname br
                local npr `"`e(npr)'"'
                if ("`npf'" == "") local npf 0
                mat `br' = `b'[1,`npf'+1..`npf'+`npr']
                local vr : colnames `br'
        }
        if ("`vfc'" != "") {
                tempname avals
                mat `avals' = e(altvals)
                local base `"`e(base)'"'
                local cn : colna `avals'
                local cn : list cn - base
                local cevfc : word 1 of `cn'
                _ms_lf_info
                local k_lf = r(k_lf)
                forval i = 1/`k_lf' {
                        if (`"`r(lf`i')'"' == "`cevfc'") {
                                local vfc `"`r(varlist`i')'"'
                                continue, break
                        }
                }
        }

        // ts op
        if `hasts' {
                qui cmset
                local pvar `"`r(panelvar)'"'
                local tvar `"`r(timevar)'"'
                sort `pvar' `tvar'
                local famts vf vr vfc
                foreach fam of local famts {
                        fvrevar ``fam'', tsonly
                        local `fam' `"`r(varlist)'"'
                }
        }

        // Omitted
        tempname bomit
        mat `bomit' = e(bomit)

        // markout variables
        markout `touse' `idgroup' `vf' `vr' `vfc' `alternatives' `wgtvar', strok

        // create alt var as string & 
        // markout cases/alternatives that are not in model
        local hasas = e(hasas) 
        local altuser `alternatives' 
        local alteqs2 = e(alteqs)
        local sbase = e(base)
        mata : st_local("sbase", strtoname(`"`sbase'"',0))
        local alteqs : list alteqs2 - sbase
        tempvar nalt alternatives2
        qui clonevar `alternatives2' = `alternatives'
        local alternatives `alternatives2'
        local atype : type `alternatives'
        if (substr("`atype'",1,3) != "str") {
                local alab : value label `alternatives'
                cap label list `alab'
                local rc = _rc
                if ("`alab'" != "" & !`rc') {
                        // prep for -decode- for the case of 
                        // single unlabeled alternatives
                        qui levelsof `alternatives', local(ale)
                        tempname vlab
                        foreach l of local ale {
                                local llab : label (`alternatives') `l'
                                label def `vlab' `l' `"`llab'"', modify
                        }
                        label val `alternatives' `vlab'
                        qui decode `alternatives' if `touse', gen(`nalt')
                }
                else {
                        qui tostring `alternatives', gen(`nalt')
                        qui replace `nalt' = "" if !`touse'
                }
                local sortal `alternatives'
                local alternatives `nalt'
        }
        qui levelsof `altuser' if `touse', local(ualt)
        foreach ua of local ualt {
                if ("`alab'" != "") {
                        local llab : label (`altuser') `ua'
                        local alev `"`alev' `"`llab'"'"'
                }
                else {
                        local alev `"`alev' `"`ua'"'"'
                }
        }
        local er 1
        foreach lab of local alev {
                local lab0 `"`lab'"'
                mata : st_local("lab", strtoname(`"`lab'"',0))
                local labcum `labcum' `lab'
                local ldup : list dups labcum
                if ("`ldup'" != "") {
                        local lab `altuser'`er'
                        local labcum : list labcum - ldup
                }
                qui replace `alternatives' = "`lab'" if `touse' & ///
                                             `alternatives' == `"`lab0'"'
                local ++er
        }
        tempvar isalt notalt
        qui gen byte `isalt' = 0 if `touse'
        local kalt = e(k_alt) 
        local labcum 
        forval i = 1/`kalt' {
                local alt = e(alt`i')
                mata : st_local("alt", strtoname(`"`alt'"',0))
                local labcum `labcum' `alt'
                local ldup : list dups labcum
                if ("`ldup'" != "") {
                        local alt `altuser'`i'
                        local labcum : list labcum - ldup
                }
                qui replace `isalt' = 1 if ///
                inlist(`alternatives', "`alt'") & `touse'
        }
        qui gen str `notalt' = `alternatives' if `isalt' == 0 & `touse'
        qui replace `touse' = 0 if `isalt' == 0 & `touse'
        qui levelsof `notalt', local(lout)

        foreach a of local lout {
                di as txt as smcl `"{p 0 0 2 `s(width)'}"'        ///
                `"Note: alternative {bf:`a'} "'                   ///
                "is not in the fitted model {p_end}"
        }

        // margins j1 and j2 derivatives set-up
        local iscs 0
        local j2d2 0
        if ("`j1'`j2'" != "") {
                if ("`outcome'" == "") {
                        di as err as smcl "{p 0 0 2 `s(width)'}"   ///
                        "options {bf:j1()} and {bf:j2()} require " ///
                        "specification of option {bf:outcome()}"
                        error 458
                }
                if ("`wgtexp'" != "") {
                        tempvar wgtvar
                        qui gen double `wgtvar' `wgtexp' if `touse'
                        markout `touse' `wgtvar'
                }
                tempvar outcat totout
                if ("`alab'" != "") {
                        local labout : label (`alternatives2') `outcome'
                }
                else local labout `outcome'
                gen byte `outcat' = `alternatives'=="`labout'" if `touse'
                if ("`j2'" != "") {
                        sort `touse' `idgroup' `panelid'
                        by `touse' `idgroup' `panelid' : ///
                          egen `totout' = total(`outcat') if `touse'
                        qui replace `outcat' = . if `totout' < 1 & `touse'
                        markout `touse' `outcat'
                        tempvar altcat totalt
                        local j2xvarLU : char `j2xvar'[fvrevar]
                        _ms_parse_parts `j2xvarLU'
                        if `r(omit)' {
                                gen `tlist' `varlist' = 0 if `touse'
                                local j2cols : colsof `b'
                                mat `j2' = J(1,`j2cols',0)
                                exit
                        }
                        local exit 0
                        foreach csv of local vfc {
                                _ms_parse_parts `csv'
                                local vfcn `vfcn' `r(name)'
                                if ("`j2xvar'" == "`r(name)'" & `r(omit)') {
                                        gen `tlist' `varlist' = 0 if `touse'
                                        local j2cols : colsof `b'
                                        mat `j2' = J(1,`j2cols',0)
                                        local exit 1
                                        exit
                                }
                        }
                        local asvar `vf' `vr'
                        foreach asv of local asvar {
                                _ms_parse_parts `asv'
                                if ("`j2xvar'" == "`r(name)'" & `r(omit)') {
                                        gen `tlist' `varlist' = 0 if `touse'
                                        local j2cols : colsof `b'
                                        mat `j2' = J(1,`j2cols',0)
                                        local exit 1
                                        exit
                                }
                        }
                        if `exit' exit
                        local iscs : list posof "`j2xvar'" in vfcn
                        if !`iscs' {
                                if ("`j2alt'" == "") {
                                        di as err as smcl "{p 0 0 2 `s(width)'}" ///
                                        "option {bf:j2()} requires specification of " ///
                                        "option {bf:alternative()}"
                                        error 458
                                }
                                tempvar altcat
                                if ("`alab'" != "") {
                                        local labalt : label (`alternatives2') `j2alt'
                                }
                                else local labalt `j2alt'
                                gen byte `altcat'=`alternatives'=="`labalt'" if `touse'
                                by `touse' `idgroup' `panelid' : ///
                                  egen `totalt' = total(`altcat') if `touse'
                                qui replace `altcat' = . if `totalt' < 1 & `touse'
                                markout `touse' `altcat'
                        }
                        tempname dx dxvars
                        local stripe : colfullnames `b'
                        _ms_dzb_dx `j2xvar', matrix(`b')
                        mat `dx' = r(b)
                        mat `dxvars' = `dx'
                        mata: st_matrix("`dx'", ///
                              editmissing(st_matrix("`dx'"):/st_matrix("`b'"),0))
                        mat colnames `dx' = `stripe'

                        // count as vars in dx
                        local ndxas 0
                        if (`iscs' &  "`asvar'" != "") {
                                _ms_lf_info , matrix(`dx')
                                local asvardx `"`r(varlist1)'"'
                                local nasvardx = r(k1)
                                tempname dxas
                                mat `dxas' = `dx'[1,1..`nasvardx']
                                forval i = 1/`nasvardx' {

                                        local isdx  = `dxas'[1,`i'] > 0
                                        if `bomit'[1,`i'] < 1 {
                                                local ndxas = `ndxas'+`isdx'
                                        }
                                }
                        }
                        local j2d2 = 1
                }
        }

        // check alts are unique per case
        sort `idgroup' `panelid' `touse' `alternatives', stable
        cap by `idgroup' `panelid' `touse' : assert `alternatives' >      ///
                                   `alternatives'[_n-1]         ///
                                   if `touse' & _n > 1
        if _rc {
                di as err as smcl   ///
                `"{p}variable {bf:`altuser'} has replicate "' ///
                "levels for one or more cases; this is not allowed{p_end}"
                exit 459
        }

        // case-wise exclusion
        if ("`altwise'" == "") {
                qui bys `idgroup' `panelid' `ifin' : ///
                  replace `touse' = `touse'[1] 
        }

        // scores need the outcome variable
        if ("`opt'" == "scores") {
                tempvar y toty
                qui clonevar `y' = `depvar' if `touse' 
                qui bys `idgroup' `touse' : egen `toty' = total(`y') if `touse'
                qui replace `y' = . if `toty' < 1 & `touse'
                sum `y' if `touse', mean
                cap assert r(min) == 0 & r(max) == 1
                if _rc {
                        di as err as smcl "{p}"   ///
                        "outcome variable invalid, not coded "     ///
                        "0 and 1{p_end}"
                        exit 499
                }
                qui tab `y' if `touse'
                cap assert r(r) == 2 
                if _rc {
                        di as err as smcl "{p}"   ///
                        "outcome variable invalid, too many "      ///
                        "values{p_end}"
                        exit 499
                } 
                markout `touse' `y'
        }

	// id var
	tempvar id first nid imin imax iuse touse2
        qui gen byte `touse2' = -`touse'
        sort `idgroup' `touse2', stable
	qui by `idgroup' : gen `first' = _n == 1 if `touse'
	qui gen `id' = sum(`first') if `touse'

        // panel info 
        if (`panel' > 0) {
                if ("`opt'" == "scores") {
                        tempvar seltu1
                        sort `idgroup' `touse2' `panelid' `alternatives'
                        qui by `idgroup' : gen `seltu1' = _n == 1 if `touse'
                }
                tempvar Tvar paneluniq
                qui gen double `Tvar' = 0 if `touse'
                qui bys `id' `touse' (`panelid') : ///
                replace `Tvar' = 1 if ///
                  (`panelid' > `panelid'[_n-1] | _n==1 ) & `touse'
                qui by `id' `touse' : replace `Tvar' = sum(`Tvar') if `touse'
                qui by `id' `touse' : replace `Tvar' = `Tvar'[_N] if `touse'
                qui egen double `paneluniq' = group(`id' `panelid') if `touse'
        }
        else {
                tempvar Tvar paneluniq
                qui gen double `paneluniq' = `id' if `touse'
                qui gen byte `Tvar' = 1 if `touse' 
        }

        // counts
        qui count if `touse' & `first'
        local N = r(N)
        qui count if `touse'
        local N_obs = r(N) 

        // check obs
        if (`N' < 1) {
                di as err as smcl "{p}"  ///
                "no cases remain after removing invalid observations{p_end}"
                exit 2000
        }

        // Check outcome option / alternatives
        if ("`outcome'" != "") {
                local out0 `outcome'
                local atype : type `altuser'
                local atype = substr("`atype'",1,3)
                if ("`atype'" != "str") {
                        local alab : value label `altuser'
                        cap confirm integer number `outcome'
                        if ("`alab'" != "" & !_rc) {
                                local outcome : label (`altuser') `outcome'
                                if ("`j2alt'" != "") {
                                        local j2alt : label (`altuser') `j2alt'
                                }
                        } 
                }
                else if ("`atype'" == "str") {
                        mata : st_local("outcome", strtoname(`"`outcome'"',0))
                        if ("`j2alt'" != "") {
                                mata : st_local("j2alt", strtoname(`"`j2alt'"',0))
                        }
                }
                local alteqs `"`e(alteqs)'"'
                local ineq : list posof "`outcome'" in alteqs
                if !`ineq' {
                        di as err as smcl "{p 0 0 2 `s(width)'}"        ///
                        "alternative {bf:`outcome'} is "                ///
                        "not in the fitted model; error in option "     ///
                        "{bf:outcome()} {p_end}"
                        error 458
                }
                local altout if !(`alternatives'=="`outcome'") & `touse'
        }

        // Need to if -svy- for scores
        local prefix = c(prefix)

        // Predictions
	mata : _mxl_predict(    "`opt'",	        ///
                                "`b'",		        ///
                                `npf',		        ///
                                `npr',		        ///
                                `npfc',                 ///
                                `npreff',	        ///
                                `npteff',	        ///
                                `nmvst',	        ///
                                `nprmoeff',	        ///
                                "`omitm'",	        ///
                                "`bomit'",              ///
                                "`fgin1'",	        ///
                                "`fgin2'",	        ///
                                "`npmreff'",	        ///
                                "`method'",	        ///
                                "`seq'",                ///
                                "`seed'",               ///
                                `burn',		        ///
                                `R',		        ///
                                `N',		        ///
                                `N_obs',	        ///
                                "`vf'",		        ///
                                "`vr'",		        ///
                                "`vfc'",                ///
                                `const',                ///
                                "`sbase'",              ///
                                "`tlist'",	        ///
                                "`varlist'",    	///
                                "`touse'",              ///
                                "`corrmetric'",         ///
                                "`scalemetric'",        ///
                                "`id'",                 ///
                                "`paneluniq'",          ///
                                "`Tvar'",               ///
                                "`alternatives'",       ///
                                "`y'",                  ///
                                "`seltu1'",             ///
                                "`outcat'",             ///
                                "`j1'", "`j2'",         ///
                                "`j2which'",            ///
                                "`altcat'",             ///
                                "`dx'",                 ///
                                "`dxvars'",             ///
                                "`j2xvar'",             ///
                                `iscs',                 ///
                                "`wgtvar'", `j2d2', `ndxas')

        // clean up
        if ("`opt'" == "scores") {
                local w 1
                local labs : colfullnames `b'
                foreach v of varlist `varlist' {
                        qui replace `v' = 0 if mi(`v') & `touse'
                        local vlab : word `w' of `labs' 
                        label var `v' "`vlab' scores"
                        local ++w
                }
        }
        else if ("`opt'" == "pr"){
                label var `varlist' "Pr(`altuser')"
        }
        else if ("`opt'" == "xb"){
                label var `varlist' "Linear prediction"
        }
        if ("`altout'" != "") {
                foreach v of varlist `varlist' {
                        qui replace `v' = . `altout'
                        label var `varlist' "Pr(`altuser'=`out0')"
                }
        }

end

exit

