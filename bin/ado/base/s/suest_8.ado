*! version 2.1.7  21feb2015
program suest_8
    version 8

    if replay() {
        if "`e(cmd)'" != "suest" {
            di as err "estimation results for suest not found"
            exit 301
        }
        Display `0'
    }
    else {
        Estimate `0'
    }    
end


program Estimate, eclass
    version 8

    syntax [anything] [, CLuster(varname) SVY minus(passthru) regressml * ]
    local diopt `options'

    est_expand `"`anything'"', min(1) default(.)
    // code doesn't allow duplicates
    DropDup names : "`r(names)'"
    local nnames : word count `names'

    if "`svy'" != ""  &  `"`cluster'"' != "" {
        di as err "options cluster() and svy may not be combined"
        exit 198
    }

    if "`svy'" != "" {
        foreach key in pweight psu strata fpc {
            svy_get `key' , optional
            local svy_`key' `"`s(varname)'"'
        }
        if "`svy_psu'`svy_pweight" == "" {
            di as err "data are not svy; neither psu nor pweight were set"
            exit 198
        }
    }

    // I may later have to add a cluster() spec -- eg clogit
    local cluster_var `cluster' `svy_psu'


// extract information for selected models in -names-

    tempvar touse esamplei esample
    tempname hcurrent rank IVi V Vi b bi

    _est hold `hcurrent' , restore nullok estsystem

    scalar `rank' = 0
    local i 0
    foreach name of local names {
        local ++i

        nobreak {
            if "`name'" != "." {
                est_unhold `name' `esample'
            }
            else {
            	_est unhold `hcurrent'
            }	

            capture noisily break {
                local cmdi        `e(cmd)'
                local cmd2i       `e(cmd2)'
                local clustervari `e(clustvar)'
                local vcetypei    `e(vcetype)'
                local wtypei      `e(wtype)'
                local wexpi       `"`e(wexp)'"'
                local scoresi     `e(scorevars)'

		GetMat `name' `bi' `Vi' 
                capt drop `esamplei'
                gen byte `esamplei' = e(sample)

                // fix some irregularities in
                //   Stata's handling of estimators
                if "`cmdi'" == "regress" {
                    tempvar sc`i'_1 sc`i'_2

                    qui Fix_regress `bi' `Vi' "`regressml'" /*
                        */ `sc`i'_1' `sc`i'_2'
                    local scoresi  `sc`i'_1'  `sc`i'_2'
                }
                else if inlist("`cmdi'", "oprobit", "ologit") ///
		 & missing(e(version)) {
                    Fix_order `bi' `Vi'
                }
                else if "`cmdi'" == "clogit" {
                    tempvar sc`i'

                    Fix_clogit "`sc`i''"  "`cluster_var'"
                    local cluster_var `r(cluster_var)'
                    local scoresi `sc`i''
                }
            }
            local rc = _rc

            if "`name'" != "." {
                est_hold `name' `esample'
            }
            else {
            	_est hold `hcurrent' , restore nullok estsystem
            }	
        }
        if `rc' {
		exit `rc'
	}

        NotSupported "`cmdi'" "`cmd2i'"

        capt assert `esamplei' == 0
        if !_rc {
            di as err "estimation sample of the model saved under `name' could not be restored"
            exit 198
        }
        if bsubstr("`cmdi'",1,3) == "svy" {
            local nonsvy_name = bsubstr("`cmdi'",4,.)

            di as err "`name' was estimated as a survey command.  "
            di as err "re-estimate with nonsvy command with iweight's "
            di as err "and score(), but no cluster()."
            exit 498
        }
        if "`clustvari'" != "" {
            di as err "`name' was estimated with cluster(`clustvari'). "
            di as err "re-estimate without the cluster() option, and "
            di as err "specify the cluster() option with suest."
            exit 498
        }
        if "`vcetypei'" != "" {
            di as err ///
              "`name' was estimated with a non-standard vce (`vcetypei')"
            exit 498
        }


        // modifies equation names into name_eq or name#

        if `nnames' > 1 {
            FixEquationNames   `name' `bi' `Vi'
        }
        else {
            NoFixEquationNames `name' `bi' `Vi'
        }  

        local neq`i' `r(neq)'
        local eqnames`i' `r(eqnames)'
        local newfullnames `"`newfullnames' `:colfullnames `bi''"'


        // check score vars

        if "`scoresi'" == "" {
            di as err "score variables were not saved by model `name'"
            di as err "re-estimate with the score() option"
            exit 198
        }
        capt confirm var `scoresi'
        if _rc {
            di as err ///
              "score variables for model `name' no longer exist in the data"
            exit 198
        }
        local nscoresi : word count `scoresi'
        if `neq`i'' != `nscoresi' {
            di as err "number of score variables does not match " ///
                      "number of equations in model `name'"
            exit 198
        }
        foreach v of local scoresi {
            // scores should not be missing in e(sample)
            capt assert !missing(`v') if `esamplei'
            if _rc {
                di as err "score variable(s) for model `name' " ///
                          "contain missing values"
                exit 498
            }
            // out of sample values of score variables are set zero
            qui replace `v' = 0 if missing(`v')
        }


        // check svy weights

        if "`svy'" != "" {
            Check_svy_weight "`name'" "`svy_pweight'" "`wtypei'"
        }


        // store-append  b/V/weight

        // necessary if Vi was constrained estimator
        mat `IVi' = syminv(`Vi')
        scalar `rank' = `rank' + (colsof(`Vi') - diag0cnt(`IVi'))

        if `i' == 1 {
            gen byte `touse' = `esamplei'

            local wtype `wtypei'
            local wexp  `"`wexpi'"'

            mat `b' = `bi'
            mat `V' = `Vi'
        }
        else {
            // union of samples of models
            qui replace `touse' = `touse' | `esamplei'

            // the weights in e() should be the same as in model 1
            CheckWeight "`wtype'" "`wexp'" "`wtypei'" "`wexpi'"

            // append the bi and Vi
            mat `b' = `b' , `bi'
            local nv  = colsof(`V')
            local nvi = colsof(`Vi')
            mat `V' = (`V', J(`nv',`nvi',0) \ J(`nvi',`nv',0), `Vi')
        }

        // score vars all models
        local scores `scores' `scoresi'

    } // loop over models


// use _robust to compute the sandwich estimator

    mat colnames `b' = `newfullnames'
    mat colnames `V' = `newfullnames'
    mat rownames `V' = `newfullnames'

    if "`wtype'" != "" {
        local wght `"[`wtype'`wexp']"'

    }

    if "`svy'" != "" {
        local svyopt "zeroweight"
        // if "`svy_psu'" != "" {
	//	local svyopt `svyopt' psu(`svy_psu')
	// }
        if "`svy_strata'" != "" {
		local svyopt `svyopt' strata(`svy_strata')
	}
        if "`svy_fpc'"    != "" {
		local svyopt `svyopt' fpc(`svy_fpc')
	}

        local iftouse
        local subpop subpop(`touse')
    }
    else {
        local iftouse "if `touse'"
        local subpop
    }

    if "`cluster_var'" != "" {
        local clopt `"cluster(`cluster_var')"'
    }


    // _robust is the work horse for suest !
    capt noi _ROBUST `scores'  `iftouse' `wght', ///
        var(`V') `clopt' `svyopt' `subpop' `minus'

    local rc = _rc
    if `rc' {
        if `rc' == 1 {
		error 1
	}
        di as err "_robust failed to compute cross model sandwich"
        di as err "likely an internal error in suest"
        exit `rc'
    }

    if "`svy'" != "" {
        tempname N N_strata N_psu N_pop

        scalar `N'        = r(N)            // number of obs
        scalar `N_strata' = r(N_strata)         // number of strata
        scalar `N_psu'    = r(N_clust)          // number of PSU
        scalar `N_pop'    = r(sum_w)            // population size

        if r(N_sub) != . {
            tempname N_sub N_subpop
            scalar `N_sub'    = r(N_sub)     // # subpop. obs
            scalar `N_subpop' = r(sum_wsub)  // subpop. size
        }

        local Nobs = scalar(`N')
    }
    else {
        qui count if `touse'
        local Nobs = r(N)
    }


// post results

    eret post `b' `V', esample(`touse') obs(`Nobs')

    if "`svy'" != "" {

        eret local  svy      svy
        eret local  pweight  `svy_pweight'
        eret local  psu      `svy_psu'
        eret local  strata   `svy_strata'
        eret local  fpc      `svy_fpc'

        eret scalar N_strata = `N_strata'   // number of strata
        eret scalar N_psu    = `N_psu'      // number of PSUs
        eret scalar N_pop    = `N_pop'      // population size

        if "`N_sub'" != "" {
            eret scalar N_sub    = `N_sub'    // # subpop. obs
            eret scalar N_subpop = `N_subpop' // subpop. size
        }

        eret scalar df_r = `N_psu' - `N_strata'

    }
    else if "`cluster_var'" != "" {

        eret local vcetype   Robust
        eret local clustvar  `cluster_var'

    }
    else {
        eret local vcetype   Robust
    }

    eret scalar rank  = `rank'
    eret local wtype  `wtype'
    eret local wexp   `"`wexp'"'
    eret local names  `names'
    forvalues ieq = `nnames'(-1)1 {
        eret local eqnames`ieq' `eqnames`ieq''
    }
    eret local cmd suest

    _est unhold `hcurrent', not

    Display , `diopt'
end


// ============================================================================
// display routines
// ============================================================================

program Display_svy_header
    args nnames clicktxt adjust

    if `nnames'>1 {
        di as txt "Simultaneous survey results for `clicktxt'"
    }
    else {
        di as txt "Survey results for `clicktxt'"
    }

    svy_head `e(N)' `e(N_strata)' `e(N_psu)' `e(N_pop)' . .   ///
        "" "`e(pweight)'" "`e(strata)'" "`e(psu)'" "`e(fpc)'" ///
        "" "" ""

    if `e(N_sub)' != . {
        di
        di as txt "Subpopulation no. of obs =" as res %10.0f e(N_sub)
        di as txt "Subpopulation size       =" as res %10.4f e(N_subpop)
    }
end


program Display_robust_header, sort
    args nnames clicktxt

    if `nnames' > 1 {
        di as txt "Simultaneous results for `clicktxt'"
    }
    else {
        di as txt "Cluster adjusted results for `clicktxt'" _c
    }    

    di as txt _col(49) "Number of obs        = " ///
       as res _col(72) %7.0f e(N)

    tempvar g touse

    qui gen `touse' = e(sample)
    qui bys `touse' `e(clustvar)' : gen `c(obs_t)' `g' = _N if _n==1 & `touse'
    qui summ `g' if `touse', meanonly

    di as txt _col(49) "Number of clusters   = " ///
       as res _col(72) %7.0f r(N)
    di as txt _col(49) "Obs per cluster: min = " ///
       as res _col(72) %7.0f r(min)
    di as txt _col(49) "                 avg = " ///
       as res _col(72) %7.1f r(mean)
    di as txt _col(49) "                 max = " ///
       as res _col(72) %7.0f r(max)

end


program Display_svy_footer
    if "`e(fpc)'" != "" {
        di as txt "Finite population correction (FPC) assumes " ///
           "simple random sampling without " _n                 ///
           "replacement of PSUs within each stratum with no "   ///
           "subsampling within PSUs."
    }
end


program Display
    syntax [, Level(passthru) Dir EForm(passthru) ]

    local nnames : word count `e(names)'
    est_clickable "`e(names)'"  "replay"  ", "
    local clicktxt "`r(clicktxt)'"

    di
    if "`e(svy)'" != "" {
        Display_svy_header "`nnames'" "`clicktxt'" "`adjust'"
    }
    else if "`e(clustvar)'" != "" {
        Display_robust_header "`nnames'" "`clicktxt'"
    }
    else {
        if `nnames' > 1 {
            di as txt "Simultaneous results for `clicktxt'"
        }
        else {
            di as txt "Robust results for `clicktxt'"
        }
        di as txt _col(61) "Obs      = " as res _col(72) %7.0f e(N)
    }

    if "`dir'" != "" {
        estimates dir `e(names)' , width(78)
    }

    dis
    ereturn display, `level' `eform'

    if "`e(svy)'" != "" {
        Display_svy_footer
    }
end


// ============================================================================
// fix routines for specific estimators
// ============================================================================

/* Fix_order b V

   modifies the coefficient b and vce V of oprobit and ologit.
     - adds equation name -mean- to the linear predictor,
     - renames the cutpoints to cutx:_cons, x=1,2,..
   the vce V is modified accordingly.
*/
program Fix_order
    args b V

    local names : colnames `b'
    foreach n of local names {
        if bsubstr("`n'",1,4) != "_cut" {
            local nnames `nnames' mean:`n'
        }
        else {
            local nn = bsubstr("`n'",2,.)
            local nnames `nnames' `nn':_cons
        }
    }
    mat colnames `b' = `nnames'
    mat colnames `V' = `nnames'
    mat rownames `V' = `nnames'
end


/* Fix_regress  b V  est_ml sc1 sc2

   - adds equation name "mean" to existing coefficients
   - adds an equation named "lnvar" for the log(variance)
   - returns in the two vars sc1 and sc2 the score variables

   if the argument ml_est is defined, in addition estimation results are
   adjusted from REML to ML. This makes results identical to ml commands
   such as intreg and lnormal.
*/
program Fix_regress
    args  b V ml_est sc1 sc2

    confirm matrix `b'
    confirm matrix `V'

    tempname b0 var

    if "`ml_est'" != "" {
        // ML estimate of variance
        scalar `var' = e(rss)/e(N)
        mat `V' = (`var' / e(rmse)^2) * `V'
    }
    else {
        // REML estimate of variance
        scalar `var' = e(rmse)^2
    }
    mat `b0' = log(`var')
    mat coln `b0' = lnvar:_cons

    local n = colsof(`b')
    mat coleq `b' = mean
    mat `b'  = `b', `b0'

    local names : colfullnames `b'
    mat `V' = (`V', J(`n',1,0) \ J(1,`n',0) , 2/e(N))
    mat colnames `V' = `names'
    mat rownames `V' = `names'

    tempvar res
    predict double `res' if e(sample), res
    gen double `sc1' = `res' / `var'           if e(sample)
    gen double `sc2' = 0.5*(`res'*`sc1' - 1)   if e(sample)
end


program Fix_clogit, rclass sort
    args score_var cluster_var

    // check that we are in the one-success per group case
    tempvar p touse ng

    gen byte `touse' = e(sample)
    qui bys `touse' `e(group)' (`e(depvar)') : ///
        gen `ng' = sum(`e(depvar)'!=0) if `touse'
    capt by `touse' `e(group)' (`e(depvar)') : ///
        assert `ng'==(_n==_N) if `touse'
    if _rc {
        di as err ///
          "suest supports clogit only in case of one success per group"
        exit 498
    }

    // get score variable
    qui predict double `p'
    qui gen double `score_var' = (`e(depvar)'!=0) - `p' if `touse'

    if "`cluster_var'" == "" {
        return local cluster_var `e(group)'
    }
    else {
        // DON'T RESTRICT TO SAMPLE -- it may change lateron

        // check that -e(group)- does not cross -clvar- boundaries
        assert `: word count `e(group)'' == 1
        assert `: word count `cluster_var'' == 1
        capt bys `e(group)' : assert `cluster_var' == `cluster_var'[1]
        if _rc {
            di as err "clogit was estimated with invalid group()"
            exit 498
        }

        // determine coarsest partitioning
        capt bys `cluster_var' : assert `e(group)' == `e(group)'[1]
        if !_rc {
            return local cluster_var `e(group)'
        }
        else {
            return local cluster_var `cluster_var'
        }
    }
end


// ============================================================================
// utility subroutines
// ============================================================================

program Check_svy_weight
    args name pweight wtype

    if "`pweight'" != "" {
        if "`wtype'" != "iweight" {
            di as err "model `name' was estimated without or with improper weights"
            di as err "you should re-estimate with [iw=`pweight']"
            exit 498
        }
    }
    else if "`wtype'" != "" {
        di as err "though svy data, no pweights were defined with svyset"
        di as err "model `name' was estimated with `wtype'-weights"
        di as err "re-estimate without weights"
        exit 498
    }
end


/* CheckWeight wtype wexp wtypei wexpi

   verifies that the weighting of model i (wtypei wexpi) is identical to the
   stored weighting scheme (wtype wexp).

   The check is not foolproof; we store weighting expression, not the
   actual weights.
*/
program CheckWeight
    args wtype wexp wtypei wexpi

    if "`wtype'" != "`wtypei'" {
        di as err "inconsistent weighting types"
        exit 498
    }
    if "`wtype'" == "" {
	exit
    }

    tempvar exp expi
    qui gen double `exp'   `wexp'
    qui gen double `expi'  `wexpi'

    // NOT restricted to e(sample) --
    //   sample may change when adding more models
    capt assert reldif(`exp',`expi') < 1e-6
    if _rc {
        di as err "weighting expression differs between models"
        exit 498
    }
end


/* DropDup newlist : quoted-list

   drops all duplicate tokens from list -- copied from hausman.ado
*/
program DropDup
    args newlist    ///  name of macro to store new list
         colon      ///  ":"
         list       //   list with possible duplicates

    gettoken token list : list
    while "`token'" != "" {
        local fixlist `fixlist' `token'
        local list : subinstr local list "`token'" "", word all
        gettoken token list : list
    }

    c_local `newlist' `fixlist'
end


/* FixEquationNames name b V

   rename the equations to "name" in case of 1/0 equation, otherwise it
   prefixes "name" to equations if this yields unique equation names,
   and numbers the equations "name"_nnn otherwise.
*/
program FixEquationNames, rclass
    args name b V

    if "`name'" == "." {
        local name _LAST
    }

    local eqnames : coleq `b'
    DropDup eq : "`eqnames'"
    local neq : word count `eq'
    if "`eq'" == "_" {
        local eqnames `name'
    }
    else {
        // modify equation names
        foreach e of local eq {
            local newname = usubstr("`name'_`e'",1,32)
            local meq `meq' `newname'
        }

        DropDup eqmod : "`meq'"
        local neqmod : word count `eqmod'
        if `neq' == `neqmod' {
            // modified equation names are unique
            forvalues i = 1/`neq' {
                local oldname : word `i' of `eq'
                local newname : word `i' of `eqmod'
                local eqnames : subinstr local eqnames ///
                      "`oldname'" "`newname'", word all
            }
        }
        else {
            // truncated modified equations not unique
            // use name_1, name_2, ...
            tokenize `eq'
            forvalues i = 1/`neq' {
                local eqnames : subinstr local eqnames ///
                      "``i''" "`name'_`i'", word all
            }
        }
    }

    matrix coleq `b' = `eqnames'
    matrix roweq `V' = `eqnames'
    matrix coleq `V' = `eqnames'
    return local neq `neq'
    return local eqnames    `eq'
    return local neweqnames `eqmod'
end


program NoFixEquationNames, rclass
    args name b V

    DropDup eq : "`: coleq `b''"

    return local neq         `: word count `eq''
    return local eqnames     `eq'
    return local neweqnames  `eq'
end


program GetMat
	args name b V

	capture {
		confirm matrix e(b)
		confirm matrix e(V)
		mat `b' = e(b)
		mat `V' = e(V)
	}
	if _rc {
		dis as err "impossible to retrieve e(b) and e(V) in `name'"
		exit 198
	}	
end		


/* NotSupported cmd cmd2
*/
program NotSupported
    args cmd cmd2

    local c = cond("`cmd2'" != "", "`cmd2'", "`cmd'")
    if inlist("`c'", "cox", "xtgee") {
        di as err "`c' is not supported by suest"
        exit 498
    }
end

exit
