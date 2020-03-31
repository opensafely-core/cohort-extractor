*! version 1.1.6  06jan2020

program define _mixlogit, eclass byable(onecall) ///
                          properties(svylb svyj svyr svyb cm) sortpreserve

	version 16

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

        gettoken panel 0 : 0
        if (`panel' > 0) local xt xt
        if (`panel' < 0) local cm as
        else local cm cm

        qui syntax [anything] [fw iw pw] [if] [in] ,    ///
                        [                               /// 
                        Case(varname)                   ///
                        VCE(passthru)                   ///
                        *                               /// 
                        ]

        if (`panel' >= 0) {
    		if (`panel' == 1) local panelopt panel
                _cm, `panelopt'
                if      (`"`panel'"' == "0") local case `"`r(caseid)'"' 
                else if (`"`panel'"' == "1") {
                        if (`"`r(origpanelvar)'"' == "") {
di as err "{p 0 6 2}note: data not {bf:cmset} as panel data; " ///
          "use {bf:cmset} {it:panelvar} {it:timevar} {it:altvar}{p_end}"
                                exit 198
                        }
                        local case `"`r(origpanelvar)'"'
                }
        }
        if ("`panel'" == "0" & !replay()) {
                local prefix = c(prefix)
                local bsloop :  list posof "_loop_bs"  in prefix
                local pfbs   :  list posof "bootstrap" in prefix
                local pfjk   :  list posof "jackknife" in prefix
                local origpanelvar : char _dta[_cm_origpanelvar]
                if ("`origpanelvar'" != "" & `"`vce'"' == "" & ///
                    !`pfbs' & !`pfjk') {
                        local vce2 "vce(cluster `origpanelvar')"
                        local case `origpanelvar'
di as text "{p 0 6 2}note: data were {bf:cmset} as panel data, and the "  ///
           "default {it:vcetype} for panel data is {bf:{bind:`vce2'}}; "  ///
           "see {helpb cmmixlogit}{p_end}"
                }
                else if ("`vce'" != "" & !`bsloop') {
                        _parse_vcetype , `vce'
                        local hascl `"`s(hascl)'"'
                        local vcetype `"`s(vcetype)'"'
                        if (inlist("`vcetype'","bootstrap","jackknife") & ///
                           "`origpanelvar'" != "" & !`hascl' ) {
                                local case `origpanelvar'
                                local nopost nopost
di as text "{p 0 6 2}note: data were {bf:cmset} as panel data, "        ///
           "`vcetype' replications are based on clusters "              ///
           "in {bf:{bind:`case'}}, and {bf:vce} is "                    ///
           "{bf:{bind:vce(`vcetype', cluster(`case'))}}; "              ///
           "see {helpb cmmixlogit}{p_end}"
                        }
                }
        }

	if replay() {
                if (`"`e(cmd)'"' != "`cm'`xt'mixlogit")  { 
                        error 301
                }
		else if _by() { 
			error 190 
		}
		else {
			Display `0'
		}
		exit
	}

        if (`"`vce'`vce2'"' != "") {
                tempname bsid 
                _vce_cluster `cm'`xt'mixlogit,  ///
                        groupvar(`case')        ///
                        newgroupvar(`bsid')     ///
                        groptname(case)         ///
                        `vce'`vce2' 

                local vce `"`s(vce)'"'
                local idopt `s(idopt)'
                local clopt `s(clopt)'
                local gropt `s(gropt)'
                local bsgropt `s(bsgropt)'
                if (`"`s(cluster)'"' != "") {
                        local bsclopt bsclustvar(`"`s(cluster)'"') 
                }
		if ("`weight'" != "") {
			local wgt [`weight'`exp']
		}
                local noshow notable noheader
                local vceopts   jkopts(`clopt' `noshow') ///
                                bootopts(`clopt' `idopt' ///
                                `bsgropt' `noshow')

                if (`panel' >= 0) {
                        local gropt
                        local bsidopt bsid(`bsid')
                }

                `BY' _vce_parserun `cm'`xt'mixlogit, `vceopts' :  ///
	                        `anything' `wgt' `if' `in',       ///
			        `gropt' `vce' `options' `bsidopt' `bsclopt'

                if ("`s(exit)'" != "") {
                        if ("`clopt'" != "") {
                                local cmd1 `"`e(command)'"'
                                local cmd2 : ///
                                subinstr local cmd1 "`bsid'" "`case'"
                                ereturn local command `"`cmd2'"'
                        }
                        if ("`nopost'" != "nopost") {
                                ereturn local caseid `case'
                                ereturn hidden local case `case'
                        }
                        ereturn local group `case'
                        ereturn local cmdline `"`cm'`xt'mixlogit`0'"'
                        SetEreturnMark `0'
                        _get_diopts diopts options, `options'
                        Display, `diopts'
                        exit
                }
                if !strpos(`"`0'"',",") {
                        local vce2 ,`vce2'
                }
        }

	`BY' Estimate `panel' `0' `vce2'
	
	SetEreturnMark `0'

        ereturn local cmdline `"`cm'`xt'mixlogit`0'"'
end

program define SetEreturnMark, eclass
	qui syntax [anything] [fw iw pw] [if] [in] , [ ALTWISE * ] 

	ereturn hidden local marginsmark cm_margins_marksample 

	if ("`altwise'" != "") {
		ereturn local marktype altwise
	}
	else {
		ereturn local marktype casewise
	}	 
end

program define Estimate, eclass byable(recall)

        gettoken panel 0 : 0

        if (`panel' >= 0) {
                qui syntax [anything] [fw iw pw] [if] [in] ,    ///
                                [                               /// 
                                ALTernatives(varname)           ///
                                bsid(varname numeric)           ///
                                bsclustvar(varname)             ///
                                *                               /// 
                                ]

                if (`"`alternatives'"' == "") {
                        local alternatives : char _dta[_cm_altvar]
                }
                if (`"`alternatives'"' != "" & `panel' > 0) {
                        local ts ts
                }
                local prefix = c(prefix)
                local bsloop : list posof "_loop_bs" in prefix
                if (`bsloop' & `panel' > 0) {
                        tempvar bspanelaltid
                        local panelid : char _dta[_cm_timevar]
                        local origpanelvar : char _dta[_cm_origpanelvar]
                        if (`"`bsclustvar'"' != "") {
                                qui replace `bsid' = `origpanelvar'
                        }
                        qui egen double `bspanelaltid' = group(`bsid' `alternatives')
                        qui tsset `bspanelaltid' `panelid'
                }
        }

	syntax  varlist(fv `ts' numeric)        /// 
                [if] [in] [fw iw pw] ,	        ///
		[                               ///
                Case(varname numeric) 		///
                Random(passthru)                ///
                ALTernatives(varname) 	        ///
                CASEVars(varlist numeric fv `ts') ///
                BASEalternative(string)         ///
                INTPoints(passthru)		///
		INTMethod(passthru)             ///
                INTBurn(passthru)               ///
                INTSeed(passthru)               ///     
                favor(passthru)                 ///
                altwise                         ///
                FROM(passthru)			///
                NOLOg LOg			///
		VCE(passthru)			///
                CONSTraints(numlist)            ///
                COLlinear                       ///
                noCONstant                      ///
                CORRmetric(passthru)            ///
                lnforce                         /// UNDOCUMENTED
                SCALemetric(passthru)           /// UNDOCUMENTED
                bsid(varname numeric)           ///
                bsclustvar(varname)             ///
                OR                              ///
                *                               /// 
                ]

        * ID
        if (`"`case'"' == "") {
                if (`panel' > 0) {
                        local case : char _dta[_cm_origpanelvar]
                }
                else {
                        local case : char _dta[_cm_caseid]
                }
        }
        if (`panel' >= 0) {
                if (`"`alternatives'"' == "") {
                       local alternatives : char _dta[_cm_altvar]
                }
                if (`panel' > 0) {
                        local tspan : char _dta[_TSpanel]
                }
                local panelid : char _dta[_cm_timevar]
                if (`bsloop' & `panel' > 0) local case `bsid'
                else if (`bsloop' & "`panel'" == "0") {
                        if ("`panelid'" != "") {
                                tempvar newcaseid
                                if ("`bsclustvar'" != "") {
                                        local origpanelvar : char _dta[_cm_origpanelvar]
                                        qui replace `bsid' =`origpanelvar'
                                }
                                qui egen double `newcaseid' = ///
                                    group(`bsid' `panelid')
                                qui replace `case' = `newcaseid'
                        }
                        else {
                                if ("`bsclustvar'" == "") {
                                        qui replace `case' = `bsid'
                                }
                        }
                }
        }
        if (`panel' < 0 & `"`case'"' == "") {
                di as err "option case() required"
                exit 198
        }

        // depvar and fixed
        gettoken depvar fvars : varlist  

        // preparse random
        local rand `random' `options'
        _mxlog_parse_rand, `rand' 
        local options = "`s(rest)'"
        local ropt = "`s(ropt)'"

        // check if ts operators
        local hasts 0
        if (`panel' > 0) {
                _parse expand eq op : ropt
                local neq `eq_n'
                forval i = 1/`eq_n' {
                        _parse comma r`i' opts`i' : eq_`i'
                        local tscheck `tscheck' `r`i''
                }
                local tscheck `tscheck' `fvars' `casevars'
                fvexpand `tscheck' 
                local tscheck `"`r(varlist)'"'
                foreach iniv of local tscheck {
                        _ms_parse_parts `iniv'
                        if (`"`r(ts_op)'"' != "") {
                                local hasts 1
                                continue, break
                        } 
                }
        }

        // parse random
	_mxlog_parse_mod , ropt(`ropt') fixed(`fvars') ///
                           casevars(`casevars') panel(`panel')
	local nvars  = "`s(nvars)'"
	local nvarsc = "`s(nvarsc)'"
	local lnvars = "`s(lnvars)'"
	local uvars  = "`s(uvars)'"
	local trvars = "`s(trvars)'"
	local tnvars = "`s(tnvars)'"

        // fvrevar ts
        if `hasts' {
                local famts nvars nvarsc lnvars uvars trvars tnvars fvars casevars
                foreach fam of local famts {
                        fvrevar ``fam'', tsonly
                        local `fam' `"`r(varlist)'"'
                }
        }

        // varlists	
	local fp `fvars'
        local fpcase `casevars'
	local rp `nvars' `nvarsc' `lnvars' `uvars' `trvars' `tnvars'
        if `hasts' {
                local fvrevars `fp' `rp' `fpcase'
        }

        // parse other stuff
	local vceopt =	`:length local vce'		|	///
	   		`:length local weight'
	if `vceopt' {
		_vce_parse, argopt(CLuster) opt(OIM OPG Robust)	///
			: [`weight'`exp'], `vce'
		local vce
		if "`r(cluster)'" != "" {
			local clustvar `r(cluster)'
			local vce vce(cluster `r(cluster)')
                        local vcetype cluster
		}
		else if "`r(robust)'" != "" {
                        // cluster panelvar if robust with panel data
                        local origpanelvar : char _dta[_cm_origpanelvar]
                        if ("`panel'" == "0" & "`origpanelvar'" != "") {
                                local clustvar `origpanelvar'
                                local vce vce(cluster `origpanelvar')
                                local vcetype cluster
di as text "{p 0 6 2}note: data were {bf:cmset} as panel data, and " ///
           "{bf:vce(robust)} for panel data is {bf:{bind:`vce'}}; "  ///
           "see {helpb cmmixlogit}{p_end}"
                        }
                        else {
			        local vce vce(robust)
                                local vcetype robust
                        }
		}
		else if "`r(vce)'" != "" {
			local vce vce(`r(vce)')
                        local vcetype `r(vce)'
		}
	}

        if ("`vcetype'" == "robust" | "`vcetype'" == "cluster") {
                local pseudo pseudo
        }
        local crittype log simulated-`pseudo'likelihood

	_get_diopts diopts options, `options'
	mlopts mlopts, `options' `vce'
        local cns `constraints'

        // esample
	marksample touse
	local coll `s(collinear)'
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
                local wgttype `weight'
                tempvar wgtvar
                qui gen double `wgtvar' `exp' if `touse'
                markout `touse' `wgtvar'
	}
        if ("`prefix'" == "bootstrap" | "`prefix'" == "jackknife") {
                if ("`bsclustvar'" != "") {
                        markout `touse' `bsclustvar', strok
                }
        }
	if ("`clustvar'" != "") {
		markout `touse' `clustvar', strok
	}
	markout `touse' `depvar' `fp' `rp' `case' `alternatives' ///
                `casevars', strok
        if ( "`if'`in'" != "" | _by() ) {
                tempvar utouse
                mark `utouse' `if' `in' 
        }

        // case-wise exclusion
        if ("`altwise'" == "") {
                qui bysort `case' `panelid' `utouse' (`touse') : ///
                replace `touse' = `touse'[1]
        }

	// FV depvar
        _fv_check_depvar `depvar'

        // Estimation
        _mixlogit_est `depvar' , 	                    ///
                     fp(`fp') 		                    ///
                     fpcase(`casevars')                     ///
                     rnormal(`nvars') 	                    ///
                     rmvnormal(`nvarsc') 	            ///
                     rlognormal(`lnvars')	            ///
                     runiform(`uvars') 	                    ///
                     rtriangle(`trvars') 	            ///
                     rtnormal(`tnvars')	                    /// 
                     idgroup(`case') 	                    ///
                     alternatives(`alternatives')           ///
                     basealternative(`"`basealternative'"') ///
                     constant(`constant')                   ///
                     touse(`touse')                         ///
                     utouse(`utouse')                       ///
                     `lnforce'                              ///
                     `intpoints'                            ///
                     `intmethod'                            ///
                     `intburn'                              ///
                     `intseed'                              ///
                     `favor'                                ///
                      vce(`vce')                            ///
                      vcetype(`vcetype')                    ///
                      clustvar(`clustvar')                  ///
                      wgt(`wgt')                            ///
                      wgtvar(`wgtvar')                      ///
                      wgttype(`wgttype')                    ///
                      touse(`touse')                        ///
                      crittype(`crittype')                  ///
                      `collinear'                           ///
                      `from'                                ///
                      `log' `nolog'                         ///
                      cns(`cns')                            ///
                      `corrmetric'                          ///
                      `scalemetric'                         ///
                      `mlopts'                              ///
                      panelid(`panelid')                    ///
                      panel(`panel')                        ///
                      tspan(`tspan')                        ///
                      fvrevars(`"`fvrevars'"')              ///
                      bsclustvar(`bsclustvar') 

	Display, `diopts' `or'

end


program define Display

	syntax [ , OR * ]

        local panel = e(panel)

	_get_diopts diopts, `options'

	if (`panel' < 0) _mixlogit_header_as
        else _mixlogit_header

        // parse eform label
        if ("`or'" != "") {
                if (`"`e(ranvars)'`e(fixvars)'"' == "") {
                       local or rrr
                }
        }

	_coef_table, `diopts' `opts' cmdextras notest `or' 

        if `panel' < 1 {
                if (e(converged_cons) == 1 & e(converged) == 1 & ///
                    "`e(vce)'" == "oim" &  e(has_cns) == 0) {
                        local df = e(df_c)
                        if (`df' > 0) {
                                if ((e(chi2_c) > 0.005) & (e(chi2_c)<1e5)) | ///
                                   (e(chi2_c)==0) {
                                        local cfmt "%8.2f"
                                }
                                else    local cfmt "%8.2e"
                                local fpar fixed parameters
                                if (`df' == 1) { 
                                        di as txt "LR test vs. `fpar': " ///
                                        "{help j_chibar##|_new:chibar2(01) =} "    ///
                                        as res `cfmt' e(chi2_c)                    ///
                                        as txt _col(55) "Prob >= chibar2 = "       ///
                                        as res _col(73) %5.4f e(p_c)
                                }
                                else {
        local cfmt=cond(e(chi2_c)<1e+7,"%10.2f","%10.3e")
        di as txt "LR test vs. `fpar': chi2(" ///
        as res `df' as txt ") = " as res `cfmt' e(chi2_c)    ///
        as txt _col(59) "Prob > chi2 = "                     ///
        as res _col(73) %5.4f e(p_c)
        di
        di as txt as smcl ///
        "{p 0 6 2 `s(width)'}" ///
        "Note: {help j_mixedlr##|_new:LR test is conservative} " ///
        "and provided only for reference.{p_end}"
                                }
                        }
                }
                else if e(converged_cons) == 0 {
                        di as txt "{p 0 6 2 `s(width)'} Note: Fixed-parameter " ///
                        "model did not converge; no LR test reported{p_end}"
                }
        }

	ml_footnote

end


program define _mixlogit_header_as

        local hasas = e(hasas)
        if `hasas' {     	
                local altvar `=abbrev("`e(altvar)'",17)'
                local avdisp  ///
                "Alternative variable: " as res "`altvar'"
        }
        local crtype = upper(substr(`"`e(crittype)'"',1,1)) + ///
		       substr(`"`e(crittype)'"',2,.)
	di _n as txt `"`e(title)'"' ///
	_col(48) "Number of obs" _col(67) "= " as res %10.0gc e(N)
	di as txt `"Case variable: "' as res `"`=abbrev("`e(case)'",24)'"' ///
	as txt _col(48) "Number of cases" _col(67) "= " as res %10.0gc e(N_case)
	di
	di as txt "`avdisp'" as txt  ///
        _col(48) "Alts per case: min = " as res %10.0g e(alt_min) ///
	_n _col(63) as txt "avg = " as res %10.1fc e(alt_avg) ///
	_n _col(63) as txt "max = " as res %10.0gc e(alt_max)

	local lencr = length("`e(crittype)'")
	local sk = `lencr'-length("`e(intmethod)'") - 8
        
        if ("`e(intmethod)'" != "") {
                di as txt "Integration sequence:" _skip(`sk') ///
                   as res "`e(intmethod)'" 
        }
        else di
        
        if (`lencr' < 15) {
                local sk = `sk'+7
                local d 18
                local skip _skip(7)
        }
        else local d 21	
        
        local sk = `lencr'-`d'
	local intpoints ///
	`""Integration points:" _skip(`sk') as res %15.0g `=e(intpoints)'"'

        local chi2type `"`e(chi2type)'"'
        if ("`chi2type'" == "Wald") {
                local stat chi2
                local cfmt=cond(e(chi2)<1e+7,"%10.2f","%10.3e")
                if e(chi2) >= . {
                        local h help j_robustsingular:
                        di as txt `intpoints' as txt _col(51) ///
                        "{`h'Wald chi2(`e(df_m)'){col 67}= }" ///
                        as res `cfmt' e(chi2)
                }
                else {
                        di as txt `intpoints' as txt _col(51) ///
                        "`e(chi2type)' chi2(" as res "`e(df_m)'"as txt ")" ///
                        _col(67) "= " as res `cfmt' e(chi2)
                }
        }
        else {
                local stat F
                local cfmt=cond(e(F)<1e+7,"%10.2f","%10.3e")
                if e(F) >= . {
                        local h help j_robustsingular:
                        di as txt `intpoints' as txt _col(51)   ///
                        "{`h'F(`e(df_m)',`e(df_r)'){col 67}= }" ///
                        as res `cfmt' e(F)
                }
                else {
                        di as txt `intpoints' as txt _col(51)   ///
                        "F(" as res %3.0f e(df_m) as txt ","    ///
                        as res %6.0f e(df_r) as txt ")"         ///
                        _col(67) "= " as res `cfmt' e(F)
                }
        }

	di as txt "`crtype' = " `skip' as res %10.0g e(ll) _col(51) as txt ///
	 "Prob > `stat'" _col(67) "= " as res %10.4f e(p) _n

end


program define _mixlogit_header

        local hasas = e(hasas)
        if `hasas' {     	
                local altvar `=abbrev("`e(altvar)'",17)'
                local avdisp1  ///
                "Alternatives variable: " as res "`altvar'"
        }
        local panel = e(panel)
        if (`panel' >= 0) {
                local panvar `=abbrev("`e(panelid)'",9)'
                local avdisp2  ///
                "Time variable: " as res "`panvar'"
        }
        if (`panel' < 1) {
                local cola 48
                local apc "Alts per case: min = "
        }
        else {
                local cola 46
                local apc "Alts per case:   min = " 
        }
        local crtype = upper(substr(`"`e(crittype)'"',1,1)) + ///
		       substr(`"`e(crittype)'"',2,.)
	di _n as txt `"`e(title)'"' ///
	_col(`cola') "Number of obs" _col(67) "= " as res %10.0gc e(N)
        if (`panel' > 0) {
                di as txt  ///
                _col(`cola') "Number of cases" _col(67) "= " as res %10.0gc e(N_case)
        }
        else {
                di as txt `"Case ID variable: "' as res `"`=abbrev("`e(caseid)'",24)'"' ///
                as txt _col(`cola') "Number of cases" _col(67) "= " as res %10.0gc e(N_case)
        }
        if (`panel' > 0) {
                di as txt `"Panel variable: "' as res `"`=abbrev("`e(caseid)'",24)'"' ///
                as txt _col(`cola') "Number of panels" _col(67) "= " as res %10.0gc e(N_panel)
        }
        if (`panel' > 0) {
                di
                di as txt "`avdisp2'" as txt  ///
                _col(`cola') "Cases per panel: min = " as res %10.0g e(t_min) ///
                _n _col(63) as txt "avg = " as res %10.1fc e(t_avg) ///
                _n _col(63) as txt "max = " as res %10.0gc e(t_max)
        }
	di
	di as txt "`avdisp1'" as txt  ///
        _col(`cola') `"`apc'"' as res %10.0g e(alt_min) ///
	_n _col(63) as txt "avg = " as res %10.1fc e(alt_avg) ///
	_n _col(63) as txt "max = " as res %10.0gc e(alt_max)

	local lencr = length("`e(crittype)'")
	local sk = `lencr'-length("`e(intmethod)'") - 8
        
        if ("`e(intmethod)'" != "") {
                di as txt "Integration sequence:" _skip(`sk') ///
                   as res "`e(intmethod)'" 
        }
        else di
 
        if (`lencr' < 15) {
                local sk = `sk'+7
                local d 18
                local skip _skip(7)
        }
        else local d 21	

        local sk = `lencr'-`d'
	local intpoints ///
	`""Integration points:" _skip(`sk') as res %15.0g `=e(intpoints)'"'

        local chi2type `"`e(chi2type)'"'
        if ("`chi2type'" == "Wald") {
                local stat chi2
                local cfmt=cond(e(chi2)<1e+7,"%10.2f","%10.3e")
                if e(chi2) >= . {
                        local h help j_robustsingular:
                        di as txt `intpoints' as txt _col(51) ///
                        "{`h'Wald chi2(`e(df_m)'){col 67}= }" ///
                        as res `cfmt' e(chi2)
                }
                else {
                        di as txt `intpoints' as txt _col(51) ///
                        "`e(chi2type)' chi2(" as res "`e(df_m)'"as txt ")" ///
                        _col(67) "= " as res `cfmt' e(chi2)
                }
        }
        else {
                local stat F
                local cfmt=cond(e(F)<1e+7,"%10.2f","%10.3e")
                if e(F) >= . {
                        local h help j_robustsingular:
                        di as txt `intpoints' as txt _col(51)   ///
                        "{`h'F(`e(df_m)',`e(df_r)'){col 67}= }" ///
                        as res `cfmt' e(F)
                }
                else {
                        di as txt `intpoints' as txt _col(51)   ///
                        "F(" as res %3.0f e(df_m) as txt ","    ///
                        as res %6.0f e(df_r) as txt ")"         ///
                        _col(67) "= " as res `cfmt' e(F)
                }
        }

	di as txt "`crtype' = " `skip' as res %10.0g e(ll) _col(51) as txt ///
	 "Prob > `stat'" _col(67) "= " as res %10.4f e(p) _n

end

// random parms parser
program define _mxlog_parse_rand, sclass

        local u 1
        while (`u' == 1) {
                syntax [ , Random(string) * ]
                if ("`random'" != "") {
                        local ropt `ropt' (`random')
                        local 0 ,`options'
                }
                else {
                        local rest `options'
                        local u 0
                }
        }

	sreturn local ropt = "`ropt'"
	sreturn local rest = "`rest'"

end


// input parser
program define _mxlog_parse_mod, sclass

        syntax  [ , ropt(string) fixed(varlist fv ts) ///
                    casevars(varlist fv ts) panel(string) ]

	_parse expand eq op : ropt
	local neq `eq_n' // # eqs
        if ("`panel'" == "1") local ts ts

	// parse each random eq
	forval i = 1/`eq_n' {
		_parse comma r`i' opts`i' : eq_`i'
	
		local opts`i' = substr("`opts`i''",2,.)
		
		local nopts : list sizeof opts`i'
		if (`nopts' > 2) {
			di as err "{p}too many options specified; check " ///
                                  "option {bf:random()}{p_end}"
			exit 499
		}

		local 0 ", `opts`i''"
		syntax [ , Normal LOGNormal LNormal Uniform ///
                           TRiangle TNormal CORRelated ]

                if ("`lognormal'" != "" | "`lnormal'"!= "") {
                        local lognormal lognormal
                }
		local dist `normal' `lognormal' `uniform' `triangle' `tnormal'
		local nd : list sizeof dist
		if (`nd' > 1) {
			di as err "{p}too many distributions specified; " ///
                                  "check option {bf:random()}{p_end}"
			exit 499
		}
		if (`nd' == 0) local dist normal
		if ("`correlated'" != "" & "`dist'" != "normal") {
			di as err "{p}correlated random parameters " ///
                                  "allowed only with normal distribution{p_end}"
			exit 499
		}

		local 0 `r`i''
		syntax varlist(fv `ts' numeric)

		if ("`dist'" == "normal" & "`correlated'" == "") {
			local nvars `nvars' `varlist'
		}
		else if ("`dist'" == "normal" & "`correlated'" != "") {
                        tempname btmp
                        fvexpand `varlist'
                        local expv `"`r(varlist)'"'
                        local nvmvn : list sizeof expv
                        mat `btmp' = J(1,`nvmvn',.)
                        mat colnames `btmp' = `expv'
                        _ms_omit_info `btmp'
                        local komit = r(k_omit)
                        local neff = `nvmvn'-`komit'
                        if `neff' > 1 {
			        local nvarsc `nvarsc' `varlist'
                        }
                        else {
                                local nvars `nvars' `nvarsc' `varlist'
                        }
		}
		else if ("`dist'" == "lognormal") {
			local lnvars `lnvars' `varlist'
		}
		else if ("`dist'" == "uniform") {
			local uvars `uvars' `varlist'
		}
		else if ("`dist'" == "triangle") {
			local trvars `trvars' `varlist'
		}
		else if ("`dist'" == "tnormal") {
			local tnvars `tnvars' `varlist'
		}
	}

	// Drop duplicates within families
	foreach m in nvars nvarsc lnvars uvars trvars tnvars {
                fvexpand ``m''
                local flist = r(varlist)
                if "`flist'" != "." {
		        local `m' : list uniq flist
                        local all `all' ``m''
                }
	}

	// Check duplicates across families
	local d : list dups all
	if (`:list sizeof d' > 0) {
		di as err "{p}conflicting distributions specified " ///
                          `"for variables: `d'{p_end}"'
		exit 499
	}

	// Check duplicates across random/fixed
        fvexpand `fixed'
        local fall = r(varlist)
        local all `all' `fall'
	local d : list dups all
        if (`:list sizeof d' > 0) {
		di as err `"{p}variables `d' need to be specified as "' ///
                          "either fixed or random, not both{p_end}"
		exit 499
	}
	
	sreturn local tnvars = "`tnvars'"
	sreturn local trvars = "`trvars'"
	sreturn local uvars  = "`uvars'"
	sreturn local lnvars = "`lnvars'"
	sreturn local nvarsc = "`nvarsc'"
	sreturn local nvars  = "`nvars'"

end


// Most frequent category
program define mfcat, rclass
	syntax varname(numeric) [if] [in], choice(varname)
	marksample touse
	tempname ct
	qui levelsof `varlist' if `touse', local(cat)
	local k : list sizeof cat
	mat `ct' = J(`k',2,.)
	local a 1
	foreach d of local cat {
		qui count if `varlist' == `d' & `touse' & `choice' == 1
		mat `ct'[`a',1] = `d'
		mat `ct'[`a',2] = r(N)
		local ++a
	}
	mata : st_local("mf", strofreal(sort(st_matrix("`ct'"),(-2,1))[1,1]))
	return scalar mfcat = `mf'
end


// Parsing integration method
program define _parse_intmeth, sclass

	syntax [anything(name=intmethod)] [, STANdard ANTIthetics MANTIthetics ]

	local intmethod = ustrlower("`intmethod'")
        if ("`intmethod'" != "") {
                if inlist("`intmethod'","hammersley","halton","random") < 1 {
                        di as err as smcl ///
                        "option {bf:intmethod()} incorrectly specified" 
                        exit 499
                }
        }
        else local intmethod hammersley
        opts_exclusive "`standard' `antithetics' `mantithetics'" intmethod
	if ("`standard'`antithetics'`mantithetics'" == "") {
                local sequence standard
	}
	else {
		local sequence `standard'`antithetics'`mantithetics'
	}
	sreturn local intmethod = `"`intmethod'"'
	sreturn local sequence = `"`sequence'"'  
end


// Parsing parameterization/scale metric
program define _parse_scalem, sclass

        cap syntax [ , scale logscale logscale2 unconstrained ]

        if _rc {
                di as err "error in option {bf:scalemetric()}; "
                syntax [ , scale logscale logscale2 unconstrained ]
        }

        opts_exclusive ///
        "`scale' `logscale' `logscale2' `unconstrained'" ///
        scalemetric

        if ("`scale'`logscale'`logscale2'`unconstrained'" == "") {
                local scale scale
        }
        else local scale `scale'`logscale'`logscale2'`unconstrained'

        if      ("`scale'" == "scale") {
                local eval _asmixlogit1_gf1()
        }
        else if ("`scale'" == "logscale") {
                local eval _asmixlogit2_gf1()
        }
        else if ("`scale'" == "logscale2") {
                local eval _asmixlogit3_gf1()
        }
        else if ("`scale'" == "unconstrained") {
                local eval _asmixlogit4_gf1()
        }
        sreturn local scalemetric `scale'
        sreturn local eval `eval'
end


// Mapping stripes from user defined initial values for corr normal
program define adjfromc, sclass

        syntax anything(name=binit), nparm(integer)     ///
                                     mvtmp(string)      ///
				     mvnormeq(string)

        local eq `mvnormeq'
        forval i = 1/`nparm' {

                _ms_element_info, element(`i') matrix(`binit') eq(`eq')
                local term = r(term)
                local 0 ,`term'

                syntax, [ l(string) sd(string) corr(string) ///
                          var(string) cov(string) ]

                local z `l'`sd'`corr'`var'`cov'

                if strpos("`z'", ",") == 0 {
                        local v1 `z' 
                        local s1 : colnumb `mvtmp' `v1'
                        if ("`s1'" != ".") {
                                local str `str' l_`s1'_`s1' 
                        }
                        else {
                                local str `str' `eq':`term'
                        }
                }
                else {
                        _parse comma v1 v2 : z
                        local s1 : colnumb `mvtmp' `v1'
                        local v2 = substr("`v2'",2,.)
                        local s2 : colnumb `mvtmp' `v2'
                        if  ("`s1'" != "." & "`s2'" != ".") {
                                local str `str' l_`s2'_`s1' 
                        }
                        else {
                                local str `str' `eq':`term'
                        }
                }
        }

        sreturn local frstr2init = "`str'"

end

// Mapping parameters to normal/mvnormal for user defined starting values
program define _mapmvn, sclass

	syntax [ , term(string)           ///
                   normal(string)         ///
                   mvnormal(string)       ///
                   corrmetric(string)     ///
                   uhasc(string) 	  ///
		   normeq(string) mvnormeq(string) ]

	local 0 , `term'
	syntax [ , sd(string) var(string) l(string) ///
                   corr(string) cov(string) * ]

	local isin `sd'`var'`l'`corr'`cov'
	if ("`isin'" == "") {
		local eqout `normeq'
	}
	else if ("`l'`corr'`cov'" != "") {
		local eqout `mvnormeq'
	}
	else if ("`sd'`var'" != "") {
		local vlist `sd'`var'
		local isn   : list normal - vlist
		local ismvn : list mvnormal - vlist
		local cn1   : list sizeof normal
		local cmvn1 : list sizeof mvnormal
		local cn2   : list sizeof isn
		local cmvn2 : list sizeof ismvn
		local dn    = `cn1' - `cn2' 
		local dmvn  = `cmvn1' - `cmvn2'
		if (`dmvn' > 0) {
			local eqout `mvnormeq'
		}
		else if (`dn' > 0) {
			local eqout `normeq'
		}
	}
	else {
		local eqout `normeq'
	}
        if ("`isin'" != "" & "`eqout'" == "`mvnormeq'") {
                local a `l'`var'`cov'
                local b `l'`sd'`corr'
                if (`uhasc' > 0) {
                        local c `var'`cov'`sd'`corr'
                }
                else {
                        local c `var'`cov'`corr'
                }
                local cm `corrmetric'
                if ("`cm'" == "correlation" & "`a'" != "") | ///
                   ("`cm'" == "covariance"  & "`b'" != "") | ///
                   ("`cm'" == "cholesky"    & "`c'" != "") {
                        di
                        di as err                                     ///
                        "error in option {bf:from()}" 
                        di as err                                     ///
                        "{p 4 4 2} Initial values do not "            ///
                        `"correspond to {bf:corrmetric(}`cm'{bf:)}."' ///
                        "{p_end}"
                        exit 111
                }
        }
	sreturn local eq = "`eqout'"
end


// Parse whether bs/jknife or other for -cmmixlogit- on panel data
program define _parse_vcetype, sclass
	syntax [ , vce(string) ]
        if (`"`vce'"' == "") exit
        local hascl 0
	local posopt  = strpos("`vce'",",")
	if `posopt' {
		local posopt  = `posopt' - 1
		local vcetype = strtrim(substr("`vce'",1,`posopt'))
                local opts = strtrim(substr("`vce'",`=`posopt'+1',.))
                if ("`opts'" != "") {
                        local 0 `opts'
                        syntax [ , CLuster(string) * ]
                        if ("`cluster'" != "") {
                                local hascl 1
                        }
                }
	}
	else {
		local vcetype = strtrim("`vce'")
	}
	local 0 , `vcetype'
	syntax [ , bs BOOTstrap JKnife JACKknife Robust * ]
	if ("`bs'`bootstrap'" != "") {
		local vcetype bootstrap
	}
	else if ("`jknife'`jackknife'" != "") {
		local vcetype jackknife
	}
        else if ("`robust'" != "") {
                local vcetype robust
        }
	else local vcetype other
	sreturn local vcetype `"`vcetype'"'
        sreturn local hascl `"`hascl'"'
end


// Estimation 
program define _mixlogit_est, eclass

	syntax varname(numeric), 	                ///
		   idgroup(varname) 			///
		   [ 					///
		   fp(varlist fv numeric)		///
                   fpcase(varlist fv numeric)           ///
		   rnormal(varlist fv numeric)	        ///
		   rmvnormal(varlist fv numeric) 	///
		   rlognormal(varlist fv numeric)	///
		   runiform(varlist fv numeric) 	///
		   rtriangle(varlist fv numeric) 	///
		   rtnormal(varlist fv numeric)         ///   
                   alternatives(varname)                ///
                   basealternative(string)              ///
                   constant(string)                     ///
		   touse(varname)			///
                   utouse(varname)                      ///
                   lnforce                              ///
                   INTPoints(string)		        ///
		   INTMethod(string)                    ///
                   INTBurn(string)                      ///
                   INTSeed(string)                      ///  
                   favor(string)                        ///
                   vce(string)                          ///
                   vcetype(string)                      ///
                   clustvar(varname)                    ///
                   wgt(string)                          ///
                   wgtvar(varname)                      ///
                   wgttype(string)                      ///
                   crittype(string)                     ///
                   from(string)                         ///
                   collinear                            ///
                   cns(string)                          ///
                   NOLOg LOg                            ///
                   corrmetric(string)                   ///
                   scalemetric(string)                  ///
                   panelid(varname numeric)             ///
                   panel(integer 0)                     ///
                   tspan(varlist numeric)               ///
                   fvrevars(string)                     ///
                   bsclustvar(varname)                  ///
                   *                                    ///
		   ]

        // Type
	local Normal /Normal
	local MVNormal /MVNormal
        if (`panel' < 0) {
                local cm as
		local Normal Normal
		local MVNormal MVNormal
        }
        else local cm cm
        if (`panel' > 0) local xt xt

	local Normalc `Normal':
	local MVNormalc `MVNormal':

        // checking correlation metric option
        if ("`corrmetric'" != "" & "`rmvnormal'" == "") {
                di as err as smcl                        /// 
                "{p}"                                    ///
                "option {bf:corrmetric()} allowed only " ///
                "with option {bf:random(}{it:varlist}, " ///
                "{bf:correlated)}{p_end}"
                exit 198
        }
        else if ("`corrmetric'" != "" & "`rmvnormal'" != "") {
                if inlist("`corrmetric'","cholesky","covariance", ///
                          "correlation") < 1 {
                        di as err                               /// 
                        "option {bf:corrmetric()} "             ///
                        "incorrectly specified"
                        di as err                               /// 
                        "{p 4 4 2}Only "                        ///
                        "{bf:corrmetric(}correlation{bf:)}, "   ///
                        "{bf:corrmetric(}covariance{bf:)}, "    ///
                        "and {bf:corrmetric(}cholesky{bf:)} "   ///
                        "are allowed.{p_end}"
                        error 499   
                }
        }
        else if ("`corrmetric'" == "" & "`rmvnormal'" != "") { 
                local corrmetric correlation
        }

        // checking scale metric option
        local ds `rnormal'`rlognormal'`runiform'`rtriangle'`rtnormal'
        if (("`scalemetric'" == "logscale"   | ///
             "`scalemetric'" == "logscale2") & ///
             "`ds'" == "") {
                di as txt as smcl   /// 
                "{p 0 6 2 `s(width)'}Note: " ///
                "option {bf:scalemetric()} ignored{p_end}"
        }

        // checking depvar
        local depvar `varlist'
        local astxt as err as smcl
        cap tab `depvar' if `touse'
        local nlev = r(r)
        if (_rc | `nlev' > 2) {
                di `astxt' "{p}outcome variable " ///
                `"{bf:`depvar'} invalid: too many levels{p_end}"'
                di `astxt' ///
                "{p 4 4 2}Outcome variable needs to be coded 1 for " ///
                "chosen alternative and 0 otherwise.{p_end}"
                exit 459
        }
        if (`nlev' < 1) error 2000
        if (`nlev' == 1) {
                di `astxt' "{p}outcome variable " ///
                `"{bf:`depvar'} does not vary{p_end}"'
                exit 2000                
        }
        qui levelsof `depvar' if `touse', local(ylev)

        local nlev : list sizeof ylev
        if ("`ylev'" == "") {
                qui count if `touse'
                cap assert r(N) > 0
                if _rc error 2000
        }
        local l0 : word 1 of `ylev'
        local l1 : word 2 of `ylev'
        if (`l0' != 0 | `l1' != 1) {
                di `astxt' "{p}outcome variable "                         ///
                           `"{bf:`depvar'} invalid{p_end}"' 
                di `astxt' "{p 4 4 2}Outcome variable needs to be coded " ///
                           "1 for chosen alternative and 0 otherwise.{p_end}"
                exit 459
        }
        tempvar ycheck ycheck2 out last
        sort `idgroup' `panelid' `utouse' `touse', stable 
        qui by `idgroup' `panelid' `utouse' : ///
          egen `ycheck' = total(`depvar') if `touse'
        qui by `idgroup' `panelid' `utouse' `touse' : ///
          gen `ycheck2' = _N if `touse'
        qui gen byte `out' = (`ycheck' != 1 | `ycheck2' == 1) if `touse'
        qui count if `out' == 1
        local nout = r(N)
        qui by `idgroup' `panelid' : gen `last' = _n == _N if `touse'
        qui cou if `out' == 1 & `last' == 1
        local cout = r(N)
        qui replace `out' = . if `out' == 1
        markout `touse' `out'
        qui cou if `touse'
        cap assert r(N) > 0
        if _rc error 2000

        if (`nout' > 0) {
                if (`cout' > 1) local ca cases
                else local ca case
                di as txt as smcl                                         /// 
                `"{p 0 6 2 `s(width)'}Note: `cout' `ca' (`nout' obs) "' ///
                "dropped due to no positive outcome, "                    ///
                "multiple positive outcomes, or a single "                ///
                "observation per case{p_end}"
        }

        // Create ASCs and interaction terms for case-specific variables
        // determine base

        if ("`alternatives'" == "" & "`constant'" == "") {
                di as err as smcl                                       /// 
                "{p}models with alternative-specific "                  ///
                "constants or variables require specification of "  ///
                "alternatives; for models without "                     ///
                "alternative-specific constants, specify "              ///
                "{bf:noconstant}{p_end}"
                exit 198
        }
        if ("`alternatives'" == "" & "`fpcase'" != "") {
                di as err as smcl                                /// 
                "{p}models with case-specific "                  ///
                "variables require specification of "        ///
                "alternatives{p_end}"
                exit 198                
        }
        if ("`alternatives'" == "" & "`basealternative'" != "") {
                di as err as smcl                         /// 
                "{p}specifying "                          ///
                "option {bf:basealternative()} requires " ///
                "specification of alternatives{p_end}"
                exit 198
        }
        local hasal = ( "`alternatives'" != "" )
        local hasas = ( "`constant'" == "" | "`fpcase'" != "" )

        // Required options for bootstrap/jackknife
        local prefix = c(prefix)
        if ("`prefix'" == "bootstrap" | "`prefix'" == "jackknife") {
                if (`hasas' & "`basealternative'" == "") {
                        di as err as smcl                               /// 
                        "{p}option "                                    ///
                        "{bf:basealternative()} is required "           ///
                        `"when option {bf:vce(`prefix')} or the "'      ///
                        `"{bf:`prefix'} prefix command is specified{p_end}"'
                        exit 198
                }
        }

        if `hasal' {
                tempvar altvar
                local atype : type `alternatives'
                local atype = substr("`atype'",1,3)
                if ("`atype'" == "str") { 
                        qui egen long `altvar' = group(`alternatives') ///
                                                 if `touse', label
                }
                else {
                        qui clonevar `altvar' = `alternatives' if `touse'
                        qui levelsof `altvar' , local(altvalues)
                }
                if ("`basealternative'" == "") {
                        mfcat `altvar' if `touse' , choice(`depvar')
                        local base = r(mfcat)
                        qui levelsof `altvar' if `touse', local(cat)
                        local basealternative : label (`altvar') `base'
                }
                else {
                        cap confirm number `basealternative'
                        if (_rc | "`atype'" == "str") {  // string or label
                                qui levelsof `altvar' if `touse', local(cat)
                                foreach n of local cat {
                                        local lab : label (`altvar') `n'
                                        if ("`lab'" == "`basealternative'") {
                                                local base `n'
                                        }
                                }
                                if ("`base'" == "") local inl 0
                                else local inl 1
                        }
                        else {  // level
                                qui levelsof `altvar' if `touse', local(cat)
                                local inl : list cat - basealternative
                                if ("`cat'" == "`inl'") local inl 0
                                else local inl 1
                                local base `basealternative'
                        }
                        if (`inl' == 0) {
                                di as err as smcl                            ///
                                `"{p}`basealternative' is not one of the "'  ///
                                "alternatives of {bf:`alternatives'}{p_end}" 
                                di as err as smcl 			     ///
                                "{p 4 4 2}Use {help tabulate oneway:tabulate} " ///
                                "for a list of values{p_end}"
                                exit 459
                        }
                        cap confirm number `basealternative'
                        if !_rc {
                                local basealternative : ///
                                label (`altvar') `basealternative'
                        }
                }
                tempname newlab
                local er 1
                foreach n of local cat {
                        cap confirm integer number `n'
                        if _rc {
                                di as err as smcl  "{p}"                    ///
                                `"variable {bf:`alternatives'} in option "' ///
                                "{bf:alternatives()} must be a discrete "   ///
                                "variable{p_end}"
                                exit 459
                        }
                        local lab : label (`altvar') `n'
                        local alteqser`er' `"`lab'"'
                        mata : st_local("lab", strtoname(`"`lab'"',0))
                        local labcum `labcum' `lab'
                        local ldup : list dups labcum
                        if ("`ldup'" != "") {
                                local lab `alternatives'`er'
                                local labcum : list labcum - ldup
                        }
                        label define `newlab' `n' "`lab'", modify
                        local alteqs `alteqs' `lab'
                        if (`n' == `base') {
                                local i_base = `er'
                        }
                        local ++er
                }
                local k_alt : list sizeof alteqs
                label val `altvar' `newlab'

                // check alts are unique within case/panel
                sort `idgroup' `panelid' `touse' `altvar', stable
                cap by `idgroup' `panelid' `touse' : assert `altvar' >  ///
                                          `altvar'[_n-1] if `touse' & _n > 1 
                if _rc {
                        di as err as smcl                                   ///
                        `"{p}variable {bf:`alternatives'} "'                ///
                        "has replicate levels for one or more "             ///
                        "cases; this is not allowed{p_end}"
                        exit 459
                }
        }

        // terms
        if `hasas' {
                qui levelsof `altvar', local(alt)
                foreach a of local alt {
                        if (`a' != `base') {
                                tempvar alt_`a'
                                qui gen byte `alt_`a'' = `a'.`altvar'
                                local altind `altind' `alt_`a''
                        }
                }
        }
        if `hasas' {
                _rmcoll `fpcase' `wgt' if `touse', expand `collinear'
                local fpcase `"`r(varlist)'"'
                local nfpcase : list sizeof fpcase
                local rcat : list cat - base
                if (`nfpcase' > 0) {
                        local j 0  
                        foreach av of local altind {
                                local ++j
                                foreach iv of local fpcase {
                                        _ms_parse_parts `iv'
                                        if (`"`r(type)'"' == "variable") {
                                                local c c. 
                                        }
                                        else local c
                                        local fpcint `fpcint' c.`av'#`c'`iv'
                                        local iname `iname' `c'`iv'
                                        if (`j' == 1) local eqml `eqml' `iv'
                                        local k : word `j' of `rcat'
                                        local eqn : label (`altvar') `k'
                                        local icol `icol' `eqn'
                                }
                                if ("`constant'" == "") {
                                        local fpcint `fpcint' `av'
                                        local iname `iname' _cons
                                        local k : word `j' of `rcat'
                                        local eqn : label (`altvar') `k'
                                        local icol `icol' `eqn'
                                }
                                else {
                                        local fpcint `fpcint'
                                }
                                local k : word `j' of `rcat'
                                local eqn : label (`altvar') `k'
                                local eq_fcase `eq_fcase' ///
                                ( `eqn' : `depvar' = `eqml' , `constant' )
                        }
                }
                else {
                        local j 0
                        foreach av of local altind {
                                local ++j
                                local fpcint `fpcint' `av'
                                local k : word `j' of `rcat'
                                local eqn : label (`altvar') `k'
                                local eq_fcase `eq_fcase' ( `eqn' : `depvar' = )
                                local icol `icol' `eqn'
                                local iname `iname' _cons
                        }
                }
        }

        // varlists
        local fpcasevars `fpcint'
        local rp `rmvnormal' `rnormal' `rlognormal' ///
                 `runiform' `rtriangle' `rtnormal' 

        // At least one variable
        if ("`fp'`rp'`fpcasevars'" == "" & "`constant'" == "noconstant") {
                di as err "too few variables specified"
                exit 102  
        }

        // FV	
	foreach m in fp rp fpcasevars {
		fvexpand ``m''
                if ("`r(varlist)'" != "") {
		        local `m' = r(varlist)
                }    
	}

        // n of parms
        local nfp : word count `fp'
	local nrp : word count `rp'

        // checking that cases nested in clusters
        if (`panel' >= 0) sort `idgroup' `touse'
        if ("`vcetype'" == "cluster") {
	        cap by `idgroup' `touse' : ///
                assert `clustvar'==`clustvar'[1] if `touse'
	        if _rc {
		        di as err "cases are not nested within clusters"
		        exit 459
        	}
        }
        else if (("`prefix'" == "bootstrap" | "`prefix'" == "jackknife") & ///
                  "`bsclustvar'" != "") {
	        cap by `idgroup' `touse' : ///
                assert `bsclustvar'==`bsclustvar'[1] if `touse'
	        if _rc {
		        di as err "cases are not nested within clusters"
		        exit 459
        	}
        }

        // Check that weights constant within case
	if ("`wgtvar'" != "") {
		cap by `idgroup' `touse' : ///
                assert `wgtvar' == `wgtvar'[1] if `touse'
		if _rc {
                        di as err "{p}weights must be the same for " ///
                        "all observations of a case{p_end}"
			exit 407
		}	
	}

        // checks for -svy-; psu and strata constant within case
        if ("`prefix'" == "svy") {
                qui svyset
                local psu `"`r(su1)'"'
                local strata `"`r(strata1)'"'
                if ("`psu'" != "") {
                        cap by `idgroup' `touse' : ///
                        assert `psu' == `psu'[1] if `touse'
                        if _rc {
                                di as err                               ///
                                  "{p}cases not clustered within "      ///
                                  "primary sampling units{p_end}"              
                                di as err                                 ///
                                  "{p 4 4 2}"                             ///
                                  "{bf:`cm'`xt'mixlogit} requires cases to be " ///
                                  "the primary sampling units, or cases " ///
                                  "need to be clustered within primary "  ///
                                  "sampling units.{p_end}"
                                exit 407
                        }	
                }
                else {
                        di as err "{p}no primary sampling units set{p_end}"
                        di as err "{p 4 4 2}"                             ///
                                  "{bf:`cm'`xt'mixlogit} requires cases to be " ///
                                  "the primary sampling units, or cases " ///
                                  "need to be clustered within primary "  ///
                                  "sampling units.{p_end}"
                        exit 407
                }
                if ("`strata'" != "") {
                        cap by `idgroup' `touse' : ///
                        assert `strata' == `strata'[1] if `touse'
                        if _rc {
                                di as err ///
                                  "{p}cases not clustered within strata{p_end}"
                                di as err "{p 4 4 2}"                      ///
                                  "{bf:`cm'`xt'mixlogit} requires cases to "     ///
                                  "be clustered within strata.{p_end}"
                                exit 407
                        }	        
                }
        }

        // Check casevars are constant within case / set
        sort `idgroup' `panelid' `touse'
        if `hasas' { 
                if (`nfpcase' > 0) {
                        foreach iv of local fpcase {
                                _ms_parse_parts `iv'
                                local fname `"`r(name)'"' 
                                local nlist `nlist' `fname'
                        }
                        local nlist : list uniq nlist
                        if (`panel' > 0) local caseset choice set
                        else local caseset case
                        foreach iv of local nlist {
                                cap by `idgroup' `panelid' `touse' : ///
                                assert `iv'==`iv'[1] if `touse'
                                if _rc {
                                        di as err `"{p}variable {bf:`iv'} "' ///
                                        "not constant within `caseset'{p_end}"
                                        exit 407
                                }
                        }
                }
        }

        // Check alt spec variables are not constant within case/set
        tempvar chtmp
        qui gen double `chtmp' = . in 1
        local dgroups fp rmvnormal rnormal rlognormal runiform rtriangle rtnormal
        if (`panel' > 0) local caseset set
        else local caseset case
        foreach g of local dgroups {
                if ("``g''" != "") {                        
                        fvexpand ``g''
                        local `g' = r(varlist)
                        local newlist
                        foreach v of local `g' {                       
                                _ms_parse_parts `v'
                                if r(omit) == 0 {
                                        if r(type) == "variable" {
                                                local chvar `v'
                                        }
                                        else {
                                                qui replace `chtmp' = `v'  
                                                local chvar `chtmp'        
                                        }
                                        cap by `idgroup' `panelid' `touse' : assert ///
                                               `chvar'==`chvar'[1] if `touse'
                                        if !_rc {
                                                di as txt                   ///
                                        `"{p}Note: {bf:`v'} omitted "'      ///
                                        "because of no within-`caseset' "   ///
                                        "variance{p_end}"
                                                _ms_put_omit `v'
                                                local comit `comit' `s(ospec)' 
                                                local v = s(ospec)
                                        }
                                }        
                                local newlist `newlist' `v' 
                        }
                        local `g' `newlist'
                }
        }

        // Defaults for integration 
        local uintmethod `intmethod' 
        if ("`intmethod'" == "") {
                local intmethod hammersley
                local sequence standard
        }
        else {
                // Parse user-specified
                _parse_intmeth `intmethod'
                local intmethod `s(intmethod)'
                local sequence `s(sequence)'
        }

        if ("`intseed'" != "") {
                if ("`intmethod'" != "random") {
                        di as err "{p}specifying random-number seed "   ///
                                  "allowed only with option "           /// 
                                  "{bf:intmethod(random)}{p_end}"
                        exit 198
                }
                cap confirm integer number `intseed'
                local rc = _rc
                cap assert `intseed' > 0
                local rc = `rc' + _rc
                if (`rc' > 0) {
                        di as err "{p}random-number seed must be a " ///
                                  "positive integer{p_end}"
                        exit 198
                }
                set seed `intseed'
        }
        local intseed = "`c(seed)'"

        local ufavor `favor'
        if ("`favor'" == "") local favor speed
        if inlist("`favor'","speed","space") == 0 {
                di as err "{p}option {bf:favor()} incorrectly " ///
                          "specified{p_end}"
                exit 198
        }

        // Parameterization / evaluator
        _parse_scalem , `scalemetric'
        local scalemetric = s(scalemetric)
        local eval = s(eval)

        // tmp id & N_case
	tempvar id first touse2
        qui gen byte `touse2' = -`touse'
        sort `idgroup' `utouse' `touse2', stable
	qui by `idgroup' `utouse' : gen `first' = _n == 1 if `touse'
	qui gen `id' = sum(`first') if `touse' 

        // Obs counts
        if ("`wgttype'" == "fweight") local swt `wgt'
        sum `touse' if `first' & `touse' `swt', mean
        local N_panel_wt = r(sum)

        sum `touse' if `touse' `swt', mean
        local N_obs_wt = r(sum)
	qui count if `first' & `touse'

	//local N_case = r(N)
	local N_dm = r(N)

        qui count if `touse'
        local N_obs = r(N)

        // check alt balance & N per alt
        if (`panel' > 0) {
                tempvar first_set
                sort `idgroup' `panelid' `utouse' `touse2', stable
                qui by `idgroup' `panelid' `utouse' : ///
                    gen `first_set' = _n == 1 if `touse'
                local first `first_set' 
                sum `touse' if `first' & `touse' `swt', mean
                local N_case_wt = r(sum)
        }
        else {
                local N_case_wt `N_panel_wt'
        }
	tempvar ncat
        sort   `idgroup' `panelid' `touse', stable
	qui by `idgroup' `panelid' : gen `ncat' = sum(`touse') if `touse'
	qui by `idgroup' `panelid' `touse' : ///
            replace `ncat' = `ncat'[_N] if `touse'
        qui tab `ncat', matrow(`jmat')
	cap assert r(r) == 1
	if _rc { 
                di as txt as smcl "{p 0 6 2 `s(width)'}Note: " ///
                "alternatives are unbalanced{p_end}"
	}
        sum `ncat' if `touse' & `first', mean
        local altmin = r(min)
        local altmax = r(max)
        local altavg = r(mean)

        // panel info
        if `panel' > 0 {
                local xt xt
                if (`"`panelid'"' == "") {
                        di as err "Panel identifier not set"
                        exit 499
                }
        }
        else {
                tempvar panelid
                qui gen byte `panelid' = 1 if `touse'
        }

        tempvar Tvar paneluniq
        qui gen double `Tvar' = 0 if `touse'
        qui bys `id' `touse' (`panelid') : ///
        replace `Tvar' = 1 if (`panelid' > `panelid'[_n-1] | _n==1 ) & `touse'
        qui by `id' `touse' : replace `Tvar' = sum(`Tvar') if `touse'
        qui by `id' `touse' : replace `Tvar' = `Tvar'[_N] if `touse'
        qui egen double `paneluniq' = group(`id' `panelid') if `touse' 

        // remove collinear within family
        local rp
        local dgroups rmvnormal rnormal rlognormal runiform rtriangle rtnormal
        foreach g of local dgroups {
                _rmcoll ``g'' `wgt' if `touse', expand `collinear'
                local `g' `"`r(varlist)'"'
                local rp `rp' ``g''
        }
        _rmcoll `fp' `wgt' if `touse', expand `collinear'
        local fp `"`r(varlist)'"'

        // collin across fixed/case (only need for alt indicators)
        _rmcoll `altind' `fp' `wgt' if `touse', expand `collinear'
        local rmc `"`r(varlist)'"'
        local fp : list rmc - altind

        // collin across families (vars need back mapping to distribution)
        local vars `fp' `rp' 
        local cols : list sizeof vars
        if (`cols' > 0) {
                tempname mtmp 
                mat `mtmp' = J(1,`cols',0)
                mat colnames `mtmp' = `vars'
                _ms_omit_info `mtmp'
                local nom1 = r(k_omit)
                _rmcoll `fp' `rp' `wgt' if `touse', expand `collinear'
                local nom2 = r(k_omitted)
                if (`nom2' != `nom1') {
                        local clist = r(varlist)
                        local dgroups rmvnormal rnormal rlognormal ///
                                      runiform rtriangle rtnormal
                        foreach g of local dgroups {
                                local om : list `g' - clist
                                foreach w of local `g' {
                                        foreach a of local om { 
                                                if ("`w'" == "`a'") {
                                                        _ms_put_omit `a'
                                                        local new = r(stripe)
                                                        local `g' =     ///
                                                        regexr("``g''", ///
                                                        "`w'","`new'")
                                                }
                                        }
                                }
                        }
                }
        }

	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
        // Initial values
        if ("`log'" != "nolog") {
                di
                di as txt "Fitting fixed parameter model:"
        }

        if !`hasas' {
                cap clogit `depvar' `fp' `rp' `wgt' if `touse', ///
                group(`paneluniq') iterate(50)
        }
        else {
                cap asclogit `depvar' `fp' `rp' `wgt' if `touse', ///
                case(`paneluniq') iterate(50)                            ///
                casevars(`fpcase') alternatives(`altvar')         ///
                basealternative(`base') `constant'
        }

        cap mat li e(b) 
        if _rc {
                di as err as smcl "{p}"                         ///
                "problem occurred with fixed-parameter model; " ///
                "check your command specification{p_end}"
                exit 499
        }

        // For LR test
        local df_c = e(df_m)
        local ll_c = e(ll)

        local converged_cons = e(converged)
        if `hasas' {
                sum `altvar' if `touse', mean
                local altm = r(min)
                local eqalt1 : label (`altvar') `altm'
                local eretbase `basealternative'
                mata : st_local("basealternative", ///
                       strtoname(`"`basealternative'"',0))
                if ("`eqalt1'" == "`basealternative'") {
                        sum `altvar' if `touse' & ///
                        `altvar' != `altm', mean
                        local altm = r(min)
                        local eqalt1 : label (`altvar') `altm'
                }
        }

        if (`"`from'"' == "") {
                if `hasas' {
                        tempname bini binit2
                        mat `bini' = e(b)
                        if ("`fp'`rp'" != "") {
                                tempname binit0
                                mat `binit0' = `bini'[1,"`altvar':"]
                                local comma ,
                        }
                        local nubu : colnumb `bini' "`eqalt1':"
                        mat `binit2' = `bini'[1,`nubu'...]
                        local fpc_eq : coleq `binit2'
                        local fpc_na : colnames `binit2' 
                        local binicase `comma'`binit2'
                }
                else {
                        tempname binit0
                        mat `binit0' = e(b)
                }

                // Adjust initial values for lognormal parameters
                if ("`rlognormal'" != "") {
                        local plnf : word count `rmvnormal' `rnormal' 
                        local plnt : word count `rmvnormal' `rnormal' ///
                                                `rlognormal'
                        local plnf = `nfp' + `plnf' + 1
                        local plnt = `nfp' + `plnt'
                        tempname nneg
                        mata : _ASMIX_adjlnorm("`binit0'", ///
                                                `plnf',    ///
                                                `plnt',    ///
                                                "`nneg'")
                        if (scalar(`nneg') > 0) {
                                di
                                if ("`lnforce'" == "") {
                                        di as err as smcl               ///
                        "{p}negative coefficients for"                  ///
                        " lognormally distributed parameters in fixed"  ///
                        " parameter model encountered;"                 /// 
                        " sign of corresponding variables may need to"  ///
                        " be reversed{p_end}"
                                        exit 499
                                }
                                else {
                                        di as txt as smcl              ///
                        "{p 0 9 2 `s(width)'}Warning:"                 ///
                        " negative coefficients for"                   ///
                        " lognormally distributed parameters in fixed" ///
                        " parameter model encountered;"                /// 
                        " sign of corresponding variables may need to" ///
                        " be reversed{p_end}"
                                }
                        }
                }
        }

        // Effective random parameters
        tempname npmreff
        tempname omitm
        if (`nrp' > 0) {
                local dgroups rmvnormal rnormal rlognormal ///
                              runiform rtriangle rtnormal
                foreach g of local dgroups {
                        tempname tmpmat
                        fvexpand ``g''
                        local `g' "`r(varlist)'"
                        if ("``g''" != "") { 
                                local ncol : list sizeof `g'
                                mat `tmpmat' = J(1,`ncol',.)
                                mat colnames `tmpmat' = ``g''
                                _ms_omit_info `tmpmat'
                                local n_omit = r(k_omit)
                                mat `omitm' = (nullmat(`omitm'), r(omit))
                                local n_eff = `ncol' - `n_omit'
                                mat `npmreff' = (nullmat(`npmreff'), `n_eff')
                        }
                        else {
                                mat `npmreff' = (nullmat(`npmreff'), 0)
                                local `g'
                        }
                }
        }
        else {
                mat `npmreff' = J(1,7,0)
                mat `omitm' = 0
        }

        // Check model includes random coefficients
        mata : st_local("nrpeff",strofreal(sum(st_matrix("`npmreff'"))))
        if (`nrpeff' == 0 & "`intpoints'" != "") {
                di
                di as err "{p}option {bf:intpoints()} " ///
                "not allowed{p_end}"
                di as err "{p 4 4 2}"                   ///
                "Option {bf:intpoints()} is allowed "   ///
                "only if the model includes "           ///
                "random coefficients.{p_end}"
                exit 198
        }
        if (`nrpeff' == 0 & "`intburn'" != "") {
                di
                di as err "{p}option {bf:intburn()} "   ///
                "not allowed{p_end}"
                di as err "{p 4 4 2}"                   ///
                "Option {bf:intburn()} is allowed "     ///
                "only if the model includes "           ///
                "random coefficients.{p_end}"
                exit 198
        }
        if (`nrpeff' == 0 & "`ufavor'" != "") {
                di
                di as err "{p}option {bf:favor()} "     ///
                "not allowed{p_end}"
                di as err "{p 4 4 2}"                   ///
                "Option {bf:favor()} is allowed "       ///
                "only if the model includes "           ///
                "random coefficients.{p_end}"
                exit 198
        }
        if (`nrpeff' == 0 & "`uintmethod'" != "") {
                di
                di as err "{p}option {bf:intmethod()} " ///
                "not allowed{p_end}"
                di as err "{p 4 4 2}"                   ///
                "Option {bf:intmethod()} is allowed "   ///
                "only if the model includes "           ///
                "random coefficients.{p_end}"
                exit 198
        }

        // Default n of integration points
        if (`nrpeff' > 0) { 
                if ("`intpoints'" == "") {
                        if (`panel' >= 0) {
                                local nmvn = `npmreff'[1,1]
                                local ncov = `nmvn' * (`nmvn'-1) / 2
                                if ("`sequence'" != "mantithetics") { 
                                        local inc 2.5
                                        local ina 500
                                }
                                else {
                                        local inc 0.5
                                        local ina 250
                                }
                                local intpoints = ceil(`ina' + `inc'*   ///
                                                  sqrt(`N_panel_wt')*   ///
                                                  sqrt(ln(`nrpeff'+5)+  ///
                                                  `nrpeff'+`ncov'))
                                if ("`intmethod'" == "random") ///
                                local intpoints = `intpoints'*2
                        }
                        else {
                                local nmvn = `npmreff'[1,1]
                                local ncov = `nmvn' * (`nmvn'-1) / 2
                                local intpoints = floor(sqrt(`nrpeff'))*50 + ///
                                                  floor(sqrt(`ncov'))*50
                                if ("`intmethod'" == "random") ///
                                local intpoints = `intpoints'*5
                        }
                }
                else {
                        cap confirm integer number `intpoints'
                        local rc = _rc
                        cap assert `intpoints' > 1
                        local rc = `rc' + _rc
                        if `rc' > 0 {
                                di as err "{p}number of integration points " ///
                                          "must be an integer > 1{p_end}"
                                exit 198
                        }
                }
        }
        else local intpoints 1

        if ("`intburn'" != "" & `nrpeff' > 0) {
                if ("`intmethod'" == "random") {
                        di as err "{p}option {bf:intburn()} not allowed " ///
                                  "with option {bf:intmethod(random)}{p_end}"
                        exit 198
                } 
                cap confirm integer number `intburn'
                local rc = _rc
                cap assert `intburn' >= 0
                local rc = `rc' + _rc
                if (`rc' > 0) {
                        di as err "{p}number of discarded sequence points " ///
                                  "must be a nonnegative integer{p_end}"
                        exit 198
                }
        }
        else local intburn -1

        if (`nrpeff' > 20 & `"`intmethod'"' != "random")  {
                di as err `"{p}integration method {bf:`intmethod'} not "' ///
                          "allowed with more than 20 random parameters; " ///
                          "use option {bf:intmethod(random)}{p_end}"
                exit 198
        }
        if (`nrpeff' == 0) {
                local crittype = regexr("`crittype'"," simulated-"," ")
        }


        // Striping, -ml- eqs, and init values for scale params

        if ("`alternatives'" != "") {
                local mdepvar `alternatives'
        }
        else {
                local mdepvar `depvar'
        }
        if ("`scalemetric'" == "logscale") local sini = ln(0.3)
        else if ("`scalemetric'" == "logscale2") local sini = ln(0.3^2)
        else local sini = 0.3
 
        // mvnormal (only actual parameters)     
        if ("`rmvnormal'" != "") {
                local sinimv 0.3
                foreach s of local rmvnormal {
                        _ms_parse_parts `s'
                        if r(omit) <= 0 {
                                local mvnseff `mvnseff' `s'
                        }
                        local str1 `str1' `s'
                        local eq1 `eq1' `mdepvar'
                        local eq1init `eq1init' mvnormal
                }
                local q 1
                foreach s of local mvnseff {
                        local r 1
                        foreach t of local mvnseff {
                                if (`r' >= `q') {
                                        
if (`r' == `q') {
        if ("`corrmetric'" == "correlation") {
                local str2 `str2' sd(`t')
        }
        else if ("`corrmetric'" == "covariance") {
                local str2 `str2' var(`t')
        }
        else if ("`corrmetric'" == "cholesky") {
                local str2 `str2' l(`t')
        }
        if (`"`from'"' == "") {
                local str2init ///
                `str2init' l_`r'_`q'
                local sdi `sdi' ,`sinimv'
        }
}
else if (`r' > `q') {
        if ("`corrmetric'" == "correlation") {
                local str2 `str2' corr(`s',`t')
        }
        else if ("`corrmetric'" == "covariance") {
                local str2 `str2' cov(`s',`t')
        }
        else if ("`corrmetric'" == "cholesky") {
                local str2 `str2' l(`s',`t')
        }
        if (`"`from'"' == "") {
                local str2init ///
                `str2init' l_`r'_`q'
                local sdi `sdi' ,0
        }
}
local eq_Var_mvnormal ///
`eq_Var_mvnormal' /l_`r'_`q'
if ("`corrmetric'" == "correlation") {
        local eq2 `eq2' `Normalc'
}
else if ("`corrmetric'" == "covariance") {
        local eq2 `eq2' `Normalc'
}
else if ("`corrmetric'" == "cholesky") {
        local eq2 `eq2' `Normalc'
}
local eq2init `eq2init' /
 
                                }
                                local ++r	                      
                        }
                        local ++q
                }
                local eq_mvnormal (mvnormal : `depvar' = `rmvnormal' ,  ///
                                              noconstant)
                local str2new `str2'
        }

        // other distributions
        local a 1
        local scale SD SD Spread Spread SD
        if ("`scalemetric'" == "logscale") {
                local scale2 lnSD lnSD lnSpr lnSpr lnSD
                local ln ln_
        }
        else if ("`scalemetric'" == "logscale2") { 
                local scale2 lnVar lnVar lnSpr2 lnSpr2 lnVar
                local ln ln_
                local s2 _2
        }
        else local scale2 SD SD Spread Spread SD
        local vdist rnormal rlognormal runiform rtriangle rtnormal
        foreach d of local vdist {
                if ("``d''" != "") {
                        fvexpand ``d''
                        local `d' = r(varlist)
                        local dd = substr("`d'",2,.)
                        local eq_`d' (`dd' : `depvar' = ``d'', noconstant)
                        local sc  : word `a' of `scale'
                        local sc2 : word `a' of `scale2'
                        local eq_`sc'_`dd' (`sc2'_`dd' : `depvar' = ``d'', ///
                              noconstant)
                        local str1 `str1' ``d''
                        local str2 `str2' ``d''
                        foreach svn of local `d' {
                                if inlist("`dd'","uniform","triangle") {
                                        local str2new `str2new' ///
                                              `ln'sprd`s2'(`svn')
                                }
                                else {
                                        local str2new `str2new' ///
                                              `ln'sd`s2'(`svn')
                                }
                        }
                        local str2init `str2init' ``d''
                        foreach v of local `d' {
                                if inlist("`dd'","lognormal","tnormal") {
                                        local dd2 = substr("`dd'",1,5)
                                }
                                else local dd2 = substr("`dd'",1,4)
                                local eq1 `eq1' `mdepvar'
                                local eq1init `eq1init' `dd' 
                                local dd2 = strproper("`dd'")
				if `panel' < 0 {	// AS
                                	local eq2 `eq2' `dd2'
				}
				else {			// CM
	                                local eq2 `eq2' /`dd2':
				}
                                local eq2init `eq2init' `sc2'_`dd'
                                local sdi `sdi' ,`sini'
                        } 
                }
                local ++a
        }
        local str2 `str2new'


        // fixed
        if ("`fp'" != "") {
                local eq_fixed (`mdepvar': `depvar' = `fp', noconstant)		
                forval i = 1/`nfp' {
                        local eq0 `eq0' `mdepvar'

	        }
	        foreach s of local fp {
		        local str0 `str0' `s'
	        }
        }

        // n of equations for -ml- Wald test
        local eqs `eq0' `eq1' `eq2'
        local eqs2 `eq0' `eq1init' `eq2' `icol'
        local equn  : list uniq eqs
        local neqfr : list sizeof equn
        local equn2 : list uniq eqs2
        local neq   : list sizeof equn2


        if ("`log'" != "nolog") {
                di
	        di as txt "Fitting full model:"
        }

        // init matrix 
        if (`"`from'"' == "") {
                tempname binit
	        mat `binit' = `binit0'`sdi'`binicase'
                mat colnames `binit' = `str0' `str1' `str2init' `iname'
                mat coleq    `binit' = `eq0' `eq1init' `eq2init' `icol'
	}
        else {
                if `hasas' {
                        local fpcon `fpcase' _cons
                        foreach d of local rcat {
                                local eqn : label (`altvar') `d'
                                foreach f of local fpcon {
                                        local fpc_eq `fpc_eq' `eqn'
                                        local fpc_na `fpc_na' `f'
                                }
                        }
                }
                tempname binit
                _parse comma umat fopt : from
                cap confirm matrix `umat'
                if _rc {
                        di as err as smcl                       ///
                          "{p}"                                 ///
                          " error in option {bf:from()}{p_end}" 
                        di as err as smcl                       ///
                          "{p 4 4 2}"                           ///
                          " {bf:`cm'`xt'mixlogit} requires that"    /// 
                          " initial values be specified as"     ///
                          " a matrix.{p_end}"
                        exit 198
                }
                mat `binit' = `umat'

                if ("`fvrevars'" != "") { 
                        local colnacns : colnames `binit'
                        foreach v of local fvrevars {
                                local orvar
                                _ms_parse_parts `v'
                                local vtype `"`r(type)'"'
                                local v `"`r(name)'"'
                                cap local orvar : char `v'[tsrevar]
                                if (`"`vtype'"' == "factor") local dot .
                                if ("`orvar'" != "") {
                                        local colnacns = ustrregexra(    ///
                                                         `"`colnacns'"', ///
                                                         `"`orvar'"',`"`dot'`v'"')
                                }
                        }
                        mat colnames `binit' = `colnacns'
                }

                local nmvneff = `npmreff'[1,1]
                _ms_eq_info, mat(`binit')
                local keq = r(k_eq)
                local unmvn 0
                local unames : colnames `binit'
                local uhasc1 = strpos("`unames'","corr(") 
                local uhasc2 = strpos("`unames'","cov(") 
                local uhasc3 = strpos("`unames'","l(")
                local uhasc  = `uhasc1'+`uhasc2'+`uhasc3'

                // mapping normal - mvnormal
                forval i = 1/`keq' {
                        _ms_eq_info, mat(`binit')
                        local eq = r(eq`i')
                        local undis = r(k`i')
                        if ("`eq'" == "`Normal'" & "`rmvnormal'" != ""  ) {
                                _ms_eq_info, mat(`binit')
                                local unmvn = r(k`i')
                                forval j = 1/`unmvn' {
                                        _ms_element_info, element(`j')     ///
                                          matrix(`binit') eq(`eq') 
                                        _mapmvn , term(`"`r(term)'"')      ///
                                                  normal(`rnormal')        ///
                                                  mvnormal(`rmvnormal')    ///
                                                  corrmetric(`corrmetric') ///
                                                  uhasc(`uhasc')	   ///
						  normeq(`Normalc')	   ///
						  mvnormeq(`MVNormalc')
                                        local eqnew `"`s(eq)'"'
                                        local ncoleq `ncoleq' `eqnew'
                                }
                        }
                        else {
                                forval j = 1/`undis' {
                                        local ncoleq `ncoleq' `eq'
                                }
                        }
                }
                mat coleq `binit' = `ncoleq'
                _ms_eq_info, mat(`binit')
                local keq = r(k_eq)
                local unmvn 0
                forval i = 1/`keq' {
                        _ms_eq_info, mat(`binit')
                        local eq = r(eq`i')
                        if inlist("`eq'", "`MVNormal'") {
                                local unmvn = r(k`i')
                        }
                }
                local copy = substr("`fopt'",2,.)
                if (`nmvneff' > 0 & "`copy'" == "" ) {
                        tempname mvtmp
                        mat `mvtmp' = J(1,`nmvneff',0)
                        mat colnames `mvtmp' = `mvnseff'
                        adjfromc `binit', nparm(`unmvn')  ///
                                  mvtmp(`mvtmp')          ///
				  mvnormeq(`MVNormal')
                        local frstr2init = "`s(frstr2init)'"
                }

                // Mapping means from alt equations to their distributions
                local isalt 0
                local vdist rnormal rmvnormal rlognormal runiform rtriangle rtnormal
                _ms_eq_info, mat(`binit')
                local k_eq_init = r(k_eq)
                forval i = 1/`k_eq_init' {
                        _ms_eq_info, mat(`binit')
                        local eqn `"`r(eq`i')'"'
                        if ("`eqn'" == "`mdepvar'") {
                                local isalt 1
                                local k_eq_alt = r(k`i')
                                local p_eq_alt `i'
                        }
                }
                if `isalt'  {
                        local exvdist `rnormal' `rmvnormal' `rlognormal' ///
                                      `runiform' `rtriangle' `rtnormal'
                        forval i = 1/`k_eq_init' {
                                _ms_eq_info, mat(`binit')
                                local eqn `"`r(eq`i')'"'
                                if ("`eqn'" != "`mdepvar'") {
                                        local n_keq = r(k`i')
                                        local feq_n
                                        forval t = 1/`n_keq' {
                                                local feq_n `feq_n' `eqn'
                                        }
                                        local feqr `feqr' `feq_n'
                                }
                                else {
                                        forval kq = 1/`k_eq_alt' {
                                                _ms_element_info, ///
                                                matrix(`binit')   ///
                                                element(`kq') eq(`mdepvar')
                                                local eltype `"`r(type)'"'
                                                if ("`eltype'" == "factor" | ///
                                                    "`eltype'" == "interaction" ) {
                                                        local kterm : word `kq' of `exvdist'
                                                }
                                                else {
                                                        local kterm `"`r(term)'"'
                                                }
                                                local isi : list exvdist - kterm
                                                local wc1 : list sizeof isi
                                                local wc2 : list sizeof exvdist
                                                local wcd = `wc2'-`wc1'
if (`wcd' > 0) {
        foreach d of local vdist {
                local isr : list `d' - kterm
                local nv1 : list sizeof isr
                local nv2 : list sizeof `d'
                local indist = `nv2'-`nv1'
                if (`indist' > 0) {
                        local eqnalt = substr("`d'",2,.)
                        local feqr `feqr' `eqnalt'
                }
        }
}
else {
        local eqnalt `mdepvar'
        local feqr `feqr' `eqnalt'
}

                                        }
                                }
                        }

                        // Removing stuff from colnames
                        local fna : colnames `binit'
                        local fna = ustrregexra("`fna'","`ln'sd`s2'\(","")
                        local fna = ustrregexra("`fna'","`ln'sprd`s2'\(","")
                        local fna = ustrregexra("`fna'","\)","")
                        local fna = ustrregexra("`fna'","corr\(","")
                        local fna = ustrregexra("`fna'","var\(","")
                        local fna = ustrregexra("`fna'","cov\(","")
                        local fna = ustrregexra("`fna'","l\(","")
                        local fna = ustrregexra("`fna'",",","_")
                        local cn1 1
                        local cn2 1
			foreach f of local feqr {
                                if ("`f'" != "`MVNormal'") {
                                        local v : word `cn1' of `fna'
                                        local fna2 `fna2' `v'
                                }
                                else {
                                        local v : word `cn2' of `frstr2init'
                                        local fna2 `fna2' `v'
                                        local ++cn2 
					local f "/:"
                                }
				local feqr0 `"`feqr0' `f'"'
                                local ++cn1
                        }
			local feqr `"`feqr0'"'

                        mat coleq    `binit' = `feqr'
                        mat colnames `binit' = `fna2'
                }

                if ("`scalemetric'" == "scale" | ///
                    "`scalemetric'" == "unconstrained" ) {
                        local rxstr Normal Lognormal Uniform              ///
                                    Triangle Tnormal
                        local rxrep SD_normal SD_lognormal Spread_uniform ///
                                    Spread_triangle SD_tnormal
                }
                else if ("`scalemetric'" == "logscale") {
                        local rxstr Normal Lognormal Uniform            ///
                                    Triangle Tnormal
                        local rxrep lnSD_normal lnSD_lognormal          ///
                                    lnSpread_uniform                    ///
                                    lnSpread_triangle lnSD_tnormal
                }
                else if ("`scalemetric'" == "logscale2") {
                        local rxstr Normal Lognormal Uniform            ///
                                    Triangle Tnormal
                        local rxrep lnVar_normal lnVar_lognormal        ///
                                    lnSpread2_uniform                   ///
                                    lnSpread2_triangle lnVar_tnormal
                }
                local ueq : coleq `binit'
		foreach ue of local ueq {
			if usubstr("`ue'",1,1) == "/" {
				if ustrlen("`ue'") > 1 {
					local ue = usubstr("`ue'",2,.)
				}
			}
			local ueq0 `"`ueq0' `ue'"'
		}
		local ueq `"`ueq0'"'
                if ("`rmvnormal'" != "") {
                        local ueq = ustrregexra("`ueq'","MVNormal","/")
                }
                local istr 1
                foreach st of local rxstr {
                        if (`"`st'"' != "") { 
                                local rep : word `istr' of `rxrep'
                                local ueq = ustrregexra("`ueq'","`st'","`rep'")
                                local ++istr
                        }
                }
                mat coleq `binit' = `ueq'
        }
        local initopt init(`binit' `fopt')

        // Constraints
        if ("`cns'" != "") {
                local has_cns 1
                tempname btmp
                if (`"`from'"' == "") {
                        mat `btmp' = `binit'
                }
                else {
                        local eqs `eq0' `eq1' `eq2' `fpc_eq'
                        local cols : list sizeof eqs 
                        mat `btmp' = J(1,`cols',0)
                }
                mat coleq    `btmp' = `eq0' `eq1' `eq2' `fpc_eq'
                mat colnames `btmp' = `str0' `str1' `str2' `fpc_na'

                if ("`fvrevars'" != "") { 
                        local colnacns : colnames `btmp'
                        foreach v of local fvrevars {
                                local orvar
                                _ms_parse_parts `v'
                                local v `"`r(name)'"'
                                cap local orvar : char `v'[tsrevar]
                                if ("`orvar'" != "") {
                                        local colnacns =                ///
                                        ustrregexra(`"`colnacns'"',     ///
                                        `"`v'"',`"`orvar'"')
                                }
                        }
                        mat colnames `btmp' = `colnacns'
                }

                ereturn post `btmp'
                makecns `cns'
                cap mat li e(Cns)

                if !_rc local hascns 1
                if !_rc {
                        tempname T a Cns
                        matcproc `T' `a' `Cns'
                        mat coleq `Cns' = `eq0' `eq1init' `eq2init' ///
                                          `icol' _Cns
                        mat colnames `Cns' = ///
                        `str0' `str1' `frstr2init' `str2init' `iname' _r

                        if ("`corrmetric'" == "cholesky" | ///
                            "`corrmetric'" == "" ) { 
                                local lconstraints constraints(`Cns')
                        }
                        else local vconstraints constraints(`Cns')
                }
        }
        else local has_cns 0

        // Mata set-up
        tempname mxl_init 
        mata : `mxl_init' = _ASMIX_setup(     "`fp'",           ///
                                              "`rmvnormal'",    ///
                                              "`rnormal'",      ///
                                              "`rlognormal'",   ///
                                              "`runiform'",     ///
                                              "`rtriangle'",    ///
                                              "`rtnormal'",     ///
                                              "`fpcasevars'",   ///
                                              "`npmreff'",      ///
                                              "`omitm'",        ///
                                              "`touse'",        ///
                                               `N_dm',          ///
                                               `intpoints',     ///
                                               `intburn',       ///
                                              "`intmethod'",    ///
                                              "`sequence'",     ///
                                              "`intseed'",      ///
                                              "`favor'",        ///
                                              "`corrmetric'",   ///
                                              "`scalemetric'",  ///
                                              "`id'",           ///
                                              "`paneluniq'",    ///
                                              "`Tvar'")


        // Transform user defined starting values for MVN
        if (`"`from'"' != "" & `nmvst' > 0 & "`uhasc'" != "0") {
                tempname mvech
                local bnames : colnames `binit'
                local beqn   : coleq `binit'
                local f : colnumb `binit' /
                local t = `f' + `nmvst' - 1
                mat `mvech' = `binit'[1,`f'..`t']
                if ("`corrmetric'" == "correlation") {
                        mata : _ASMIX_stchol("`binit'", "`mvech'", `f', `t')
                }
                else if ("`corrmetric'" == "covariance") {
                        mata : _ASMIX_vtchol("`binit'", "`mvech'", `f', `t')
                }
                mat coleq    `binit' = `beqn'
                mat colnames `binit' = `bnames'
        }


        // Estimate
        set buildfvinfo off
        ml model gf1 `eval'             ///
                `eq_fixed'              ///
                `eq_mvnormal'           ///
                `eq_rnormal'            ///
                `eq_rlognormal'         ///
                `eq_runiform'           ///
                `eq_rtriangle'          ///
                `eq_rtnormal'           ///
                `eq_Var_mvnormal'       ///
                `eq_SD_normal'          ///
                `eq_SD_lognormal'       ///
                `eq_Spread_uniform'     ///
                `eq_Spread_triangle'    ///
                `eq_SD_tnormal'         ///
                `eq_fcase'              ///
                `wgt' if `touse' ,      ///
                userinfo(`mxl_init')    ///
                maximize                ///
                collinear               ///
                search(off)             ///
                `initopt'               ///
                `vce'                   ///
                waldtest(-`neq')        ///
                crittype(`crittype')    ///
                group(`id')             ///
                `mllog'                 ///
                `lconstraints'          ///
                `options'  

        // Refining estimates
        if ("`corrmetric'" != "cholesky" & `nmvst' > 0) {

                tempname binit2 lvech varcov
                mat `binit2' = e(b)
                local bnames : colnames `binit2'
                local beqn   : coleq `binit2'
                local f = `npf' + `npr' + 1
                local t = `npf' + `npr' + `nmvst'
                mat `lvech' = `binit2'[1,`f'..`t']
                if ("`corrmetric'" == "correlation") {
                        mata : _ASMIX_tcorr("`binit2'", "`lvech'", `f', `t')
                }
                else if ("`corrmetric'" == "covariance") {
                        mata : _ASMIX_tcov("`binit2'", "`lvech'", `f', `t')
                }

                local eval _asmixlogit5_gf1()

                mat coleq `binit2' = `beqn'
                mat colnames `binit2' = `bnames'
                local initopt init(`binit2')

                if ("`log'" != "nolog") {
                        di
                        di as txt "Refining estimates:"
                }

                ml model gf1 `eval'             ///
                        `eq_fixed'              ///
                        `eq_mvnormal'           ///
                        `eq_rnormal'            ///
                        `eq_rlognormal'         ///
                        `eq_runiform'           ///
                        `eq_rtriangle'          ///
                        `eq_rtnormal'           ///
                        `eq_Var_mvnormal'       ///
                        `eq_SD_normal'          ///
                        `eq_SD_lognormal'       ///
                        `eq_Spread_uniform'     ///
                        `eq_Spread_triangle'    ///
                        `eq_SD_tnormal'         ///
                        `eq_fcase'              ///
                        `wgt' if `touse' ,      ///
                        userinfo(`mxl_init')    ///
                        maximize                ///
                        collinear               ///
                        search(off)             ///
                        `initopt'               ///
                        `vce'                   ///
                        waldtest(-`neq')        ///
                        crittype(`crittype')    ///
                        group(`id')             ///
                        `mllog'                 ///
                        `vconstraints'          ///
                        `options'

        }

        // rm init
        mata mata drop `mxl_init'

        // LR test against clogit
        if (e(converged) == 1 & "`hascns'" != "1") {
                tempname V1 chi2_c p_c
                mat `V1' = e(V)
                local df_m = e(df_m)
                scalar `chi2_c' = max(0,2*(e(ll) - `ll_c'))
                local df_c = `df_m'-`df_c'
                scalar `p_c' = chi2tail(`df_c',`chi2_c')
		if (`df_c' == 1) ereturn scalar p_c = 0.5*`p_c'
                else ereturn scalar p_c = `p_c'
                ereturn scalar chi2_c = `chi2_c'
                ereturn scalar df_c   = `df_c'
                ereturn scalar ll_c   = `ll_c'
        }

        // Restriping
        tempname b V Cns gradient
        mat `b' = e(b)
        mat `V' = e(V)
        mat `gradient' = e(gradient)
        mat coleq    `b' = `eq0' `eq1' `eq2' `fpc_eq'
        mat colnames `b' = `str0' `str1' `str2' `fpc_na'
        mat coleq    `gradient' = `eq0' `eq1' `eq2' `fpc_eq'
        mat colnames `gradient' = `str0' `str1' `str2' `fpc_na'

        // restriping
        local ranvars `rmvnormal' `rnormal' `rlognormal' ///
                      `runiform' `rtriangle' `rtnormal'
        if ("`fvrevars'" != "") { 
                local colna : colnames `b'
                foreach v of local fvrevars {
                        local orvar
                        _ms_parse_parts `v'
                        local v `"`r(name)'"'
                        cap local orvar : char `v'[tsrevar]
                        if ("`orvar'" != "") {
                                local colna   = ///
                                  ustrregexra(`"`colna'"',`"`v'"',`"`orvar'"')
                                local fp      = ///
                                  ustrregexra(`"`fp'"',`"`v'"',`"`orvar'"')
                                local ranvars = ///
                                  ustrregexra(`"`ranvars'"',`"`v'"',`"`orvar'"')
                                local fpcase = ///
                                  ustrregexra(`"`fpcase'"',`"`v'"',`"`orvar'"')
                        }
                }
                mat colnames `b'        =  `colna'
                mat colnames `gradient' =  `colna'
                local hasts 1
        }
        else local hasts 0
        ereturn hidden scalar hasts = `hasts'
        ereturn hidden local fixvars `fp'
        ereturn hidden local ranvars `ranvars'


        // Scale parameter CIs
        if (`nrpeff' > 0) {
                tempname pclass
                matrix `pclass' = J(1,colsof(`b'),0)
                _b_pclass code0 : bseonly
                _b_pclass code1 : var
                _b_pclass code2 : cov
                _b_pclass code3 : corr
                _b_pclass code4 : aux

                local ncfg2 : colsof(`fg2') 
                forval a = 1/`ncfg2' {
                        local bpos = `fg2'[1,`a']               
                        matrix `pclass'[1,`bpos'] = `code1' 
                }

                _ms_eq_info, mat(`b')
                local keqb = r(k_eq)
                local cnt 1
                forval u = 1/`keqb' {
                        _ms_eq_info, mat(`b')
                        local keqx = r(k`u')
                        forval i = 1/`keqx' {
                                _ms_eq_info, mat(`b')
                                local eqx `"`r(eq`u')'"'
                                _ms_element_info, element(`i') ///
                                  eq(`eqx') mat(`b')
                                local issc = `pclass'[1,`cnt']
                                if (`issc' > 0) {
                                        local term `"`r(term)'"'
                                        local wat = substr("`term'",1,3)
                                        if inlist("`wat'","sd(","var","spr") ///
                                           local code `code1'
                                        else if inlist("`wat'","cor","cov") ///
                                                local code `code3'
                                        else if substr("`wat'",1,1) == "l" {
                                                if strpos("`term'",",") ///
                                                   local code `code2'
                                                else local code `code1' 
                                        }
                                        if ("`wat'" == "ln_") local code `code4'
                                        mat `pclass'[1,`cnt'] = `code'
                                }
                                local ++cnt
                        }
                }
                ereturn hidden matrix b_pclass `pclass'
        }


        // Repost b V
        sort `tspan' `panelid'
        set buildfvinfo on
        ereturn matrix gradient = `gradient'
        ereturn repost b=`b' V=`V' , rename buildfvinfo ADDCONS


        // Wald model test; testing fixed, means, and 
        // alternative-specific parameters against 0
        if (`nrpeff' > 0) {
                ereturn hidden matrix fg2 = `fg2'
        }
        if ("`prefix'" != "bootstrap" &         ///
            "`prefix'" != "jackknife" &         ///
            "`prefix'" != "svy") {
                _asmixtest
        }

        // Store results
        tempname b bomit
        mat `b' = e(b)
        _ms_eq_info, matrix(`b')
        ereturn scalar k_eq = r(k_eq)
        ereturn hidden scalar k_eform = r(k_eq)
        ereturn local group = "`idgroup'"
        _ms_omit_info `b'
        mat `bomit' = r(omit)
        if ("`vcetype'" == "cluster") {
                ereturn local clustvar = "`clustvar'"
        }
        if `hasal' {
                ereturn local altvar = "`alternatives'"
                ereturn local alteqs = "`alteqs'"
                ereturn local base   = `"`eretbase'"'
                ereturn scalar k_alt = `k_alt'
                forval s = `k_alt'(-1)1 {
                        ereturn local alt`s' `"`alteqser`s''"'
                }
                if (`"`altvalues'"' != "") {
                        tempname altvals
                        mat `altvals' = J(1,`k_alt',0)
                        mat colnames `altvals' = `alteqs'
                        forval altv = 1/`k_alt' {
                                local z : word `altv' of `altvalues'
                                mat `altvals'[1,`altv'] = `z'
                        }
                        ereturn matrix altvals =  `altvals'
                }
        }
        if `hasas' {
                ereturn hidden local casevars = "`fpcase'"
                ereturn hidden scalar i_base = `i_base'
                ereturn scalar k_casevars = `nfpcase'
                local bcol : colnumb `b' "`eqalt1':"
                ereturn hidden scalar k_indvars = `bcol' - 1
        }
        else {
                ereturn scalar k_casevars = 0
                ereturn hidden scalar k_indvars = colsof(`b')
        }

        ereturn scalar const   = "`constant'" != "noconstant"
        ereturn hidden scalar noconstant = `=1-("`constant'" != "noconstant")'
        ereturn scalar N_case  = `N_case_wt'
        ereturn scalar N_ic    = `N_case_wt'
        ereturn scalar N       = `N_obs_wt'
        ereturn scalar alt_min = `altmin'
        ereturn scalar alt_max = `altmax'
        ereturn scalar alt_avg = `altavg'
        ereturn local key_N_ic = "cases"
        ereturn local depvar   = "`depvar'"
        ereturn local caseid   = "`idgroup'"
        ereturn hidden local case = "`idgroup'"

        if (`panel' > 0) {
                ereturn scalar N_panel = `N_panel_wt'
                ereturn local timevar  = "`panelid'"
                ereturn scalar t_min   = `mint'
                ereturn scalar t_max   = `maxt'
                ereturn scalar t_avg   = `meant'
                ereturn hidden local panelid = "`panelid'"
        }
        if (`panel' >= 0) { 
 	        ereturn local title = "Mixed logit choice model"
        }
        else {
                ereturn local title = "Alternative-specific mixed logit"
        }

        ereturn local group
        ereturn local cmd `cm'`xt'mixlogit
        ereturn local predict = "`cm'`xt'mixlogit_p"
        ereturn local k_dv

        if (`intpoints' == 1) local intpoints 0
        ereturn scalar intpoints = `intpoints'
        if (`nrpeff' > 0) {
                if ("`intmethod'" != "random") {
                        ereturn local intmethod = strproper("`intmethod'")
                }
                else  ereturn local intmethod = "`intmethod'"
                if ("`sequence'" == "standard") local lseq `intpoints'
                else if ("`sequence'" == "antithetics")  ///
                         local lseq = 2*`intpoints'
                else if ("`sequence'" == "mantithetics") ///
                         local lseq = 2^`npreff' * `intpoints'
                ereturn scalar lsequence = `lseq'
                ereturn local sequence = "`sequence'"
                ereturn hidden local scalemetric = "`scalemetric'"
                ereturn local corrmetric = "`corrmetric'"
                ereturn hidden matrix fg1 = `fg1'
        }

        if ("`intmethod'" == "random") ereturn local mc_rngstate = "`intseed'"
        if ("`intmethod'" != "random" & `nrpeff' > 0) ///
        ereturn scalar intburn = `intburn'
        ereturn hidden local marginsprop addcons cm allcons
	ereturn local marginsnotok SCores
	ereturn local marginsok default Pr XB
        ereturn hidden local  crittype = "`crittype'"
        ereturn hidden local  case = "`idgroup'"
        ereturn hidden scalar converged_cons = `converged_cons'
        ereturn hidden scalar has_cns = `has_cns'
        ereturn hidden scalar npf = `npf'
        ereturn hidden scalar npr = `npr'
        ereturn hidden scalar npreff = `npreff'
        ereturn hidden scalar npteff = `npteff'
        ereturn hidden scalar nmvst = `nmvst'
        ereturn hidden scalar nprmoeff = `nprmoeff'
        ereturn hidden scalar npfc = `npfc'
        ereturn hidden scalar k_eqfr = `neqfr'
        ereturn hidden scalar hasas = `hasas'
        ereturn hidden scalar panel = `panel'
        ereturn hidden matrix npmr = `npmr'
        ereturn hidden matrix omitm = `omitm'
        ereturn hidden matrix bomit = `bomit'
        ereturn hidden local marginsj1 default Pr
        ereturn hidden local marginsj2 default Pr

	_ms_varnames `e(casevars)'
	ereturn hidden local casevars_cat  `s(fvars)'
	ereturn hidden local casevars_cont `s(cvars)'
	_ms_varnames `e(fixvars)'
	local fixvars_cat  `s(fvars)'
	local fixvars_cont `s(cvars)'
	_ms_varnames `e(ranvars)'
	local ranvars_cat  `s(fvars)'
	local ranvars_cont `s(cvars)'

	ereturn hidden local altspvars_cat  `fixvars_cat'  `ranvars_cat' 
	ereturn hidden local altspvars_cont `fixvars_cont' `ranvars_cont' 

end

exit
