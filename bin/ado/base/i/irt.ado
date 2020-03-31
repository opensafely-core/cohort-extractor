*! version 1.2.13  15jan2020
program irt, eclass byable(onecall) prop(or irr svyg svyj svyb)
	version 14
	local vv : di "version " string(_caller()) ", missing:"

	if _by() {
		local by "by `_byvars'`_byrc0':"
	}

	`vv' `by' _vce_parserun irt , noeqlist : `0'
	if "`s(exit)'" != "" {
		local 0 : list clean 0
		ereturn local cmdline `"irt `0'"'
		exit
	}

	if replay() {
		if `"`e(cmd2)'"' != "irt" {
			error 301
		}
		if _by() {
			error 190
		}
		irt_display `0'
		exit
	}

	preserve, changed

	capture confirm new variable _one
	if _rc {
		local drop 0
	}
	else local drop 1
	
	capture noi `vv' `by' Estimate `0'
	local rc = _rc
	if `drop' {
		capture drop _one
	}
	if `rc' {
		exit `rc'
	}
	
	local 0 : list clean 0
	ereturn local cmdline `"irt `0'"'
end

program Estimate, sortpreserve eclass byable(recall)
	version 14
	local vv : di "version " string(_caller()) ", missing:"

	if _by() {
		tempname bytouse
		mark `bytouse'
	}

	gettoken hybrid : 0
	if "`hybrid'" == "hybrid" {
		gettoken hybrid 0 : 0
	}

	syntax anything [if] [in] [fw pw iw] [, LLABel(name) noCNSReport ///
		noHEADer DVHEADer notable CONSTRaints(passthru) LISTwise ///
		from(passthru) ESTMetric noESTimate COEFLegend noCONTRACT ///
		GRoup(varname numeric) vce(passthru) *]

	local options `"`options' `vce'"'
	_vce_parse, optlist(oim Robust) argoptlist(CLuster):,`vce'
	local clust `r(cluster)'
	
	marksample touse

	tempname m
	
	local hasgr = `"`group'"' != ""
	if `hasgr' {
		markout `touse' `group'
		qui tab `group' if `touse', matrow(`m')
		local gr_n = rowsof(`m')
		if `gr_n' == 1 {
			di as err "group variable has only one value in the sample"
			exit 198
		}
		forvalues i=1/`gr_n' {
			local z = `m'[`i',1]
			__isInteger `z' `group' "group"
			local gr_levels `gr_levels' `z'
			local grlist_fv `grlist_fv' `z'.`group'
			local g : label (`group') `z'
			if `"`g'"' == "`z'" {
				local g `z'.`group'
			}
			local gr_labels `"`gr_labels' "`g'""'
		}
		gettoken gr_ref gr_focal : gr_levels
		if "`gr_focal'" == "" {
			local hasgr 0
		}
		local gr_var1 "`gr_ref':"
	}
	
	if missing("`llabel'") local llabel Theta

	if missing("`dvheader'") local dvheader "nodvheader"
	local opts_not `header' `cnsreport' `table' `dvheader'

	if "`estimate'"=="noestimate" {
		local coeflegend coeflegend
		local contract nocontract
	}

	if "`weight'" != "" local wopt [`weight'`exp']
	else local wopt
	
	local hassvy = "`c(prefix)'" == "svy"
	local hasipw = inlist("`weight'","iweight","pweight")
	if `hassvy' | `hasipw' | "`contract'" == "nocontract" {
		local preserve 0
	}
	else 	local preserve 1
	
	if `hasgr' local preserve 0
	
	local 0 `anything' `if' `in', `options'

	_parse expand eq opt : 0
	local gl_if `opt_if'
	local gl_in `opt_in'
	local gl_opts `opt_op'
	local mif = !missing(`"`gl_if'`gl_in'"')

	_get_diopts diopts gl_opts, `gl_opts'

	local allowed 1pl 2pl 3pl grm rsm pcm gpcm nrm
	local hasrsm 0
	local ginv 0

	foreach g in `gr_levels' {
		local w : list posof "`g'" in gr_levels
		scalar m`w'_irt_k_eq = 0
	}
	
	forvalues i = 1/`eq_n' {
		local 0 `eq_`i''

		local gr_eq = strpos(`"`0'"',":")
		if `gr_eq' {
			if !`hasgr' {
				di as err "group equation invalid; option {bf:group()} required"
				exit 198
			}
			local gr_id = usubstr(`"`0'"',1,`gr_eq'-1)
			local gr_id = trim("`gr_id'")
			if `=`: list sizeof gr_id'' > 1 {
				di as err `"invalid {bf:`0'}"'
				exit 198
			}

			local 0 = usubstr(`"`0'"',`gr_eq'+1,.)
			local gr_ok : list posof "`gr_id'" in gr_levels
			if !`gr_ok' {
				di as err "invalid group level {bf:`gr_id'}"
				exit 198
			}
		}
		
		gettoken model 0 : 0
		__check_model, model(`model') allowed(`allowed')
		if "`model'"=="3pl" {
			local g_opt SEPGuessing
			if `hasgr' local g_opt `g_opt' GSEPGuessing
		}
		if "`model'"=="rsm" & `hasrsm'==0 {
			_irtrsm_one
			local one _one
		}
		local hasrsm = `hasrsm' | "`model'"=="rsm"
		syntax varlist [if] [in] [, LLABel1(string) CNS(string) `g_opt' *]
		
		if _caller() < 16 {
			if `"`cns'"' != "" {
				di as err "option {bf:cns()} not allowed under version " _caller()
				exit 198
			}
		}
		
		local mif = `mif' + !missing(`"`if'`in'"')
		if `mif' > 1 {
			di as err "multiple 'if' specifications not allowed"
			exit 198
		}
		local varlist : list varlist - touse
		if `hasrsm' {
			local varlist : list varlist - one
		}
		_get_diopts eq_di eq_op, `options'
		local diopts `diopts' `eq_di'
		local eq_opts `eq_opts' `eq_op'

		if !missing("`llabel1'") {
			di as err ///
			"option {bf:llabel()} not allowed inside equation"
			exit 198
		}

		foreach v of local varlist {
			local mlist `mlist' `model'
			local ilist `ilist' `v'
		}
		
		if `hasgr' {
			local o 1
			local gg group(`group') grlev(`gr_levels') grid(`gr_id')
		}
		
		sreturn clear
		`vv' ///
		__make_`model'`o' `varlist', latent(`llabel') `sepguessing' ///
			`gsepguessing' ix(`i') touse(`touse') `constraints' ///
			cns_usr(`cns') `gg' onecns(`onecns') onesym(`onesym')
		local eqs `eqs' `s(eq)'
		local cns_usr `cns_usr' `s(cns_usr)'
		local cns_st `cns_st' `s(cns_st)'
		local _from `_from' `s(_from)'
		local model`i' `model'
		local modelname`i' `s(modelname)'
		local models `models' `model'
		local items`i' `varlist'
		local k_items`i' `=`:list sizeof varlist''
		local sepg`i' `s(sepg)'
		local gsepg`i' `s(gsepg)'
		local n_cuts`i' `s(n_cuts)'
		local n_cuts_all `n_cuts_all' `s(n_cuts)'
		local off`i' `s(off)'
		local ilist_fv `ilist_fv' `s(ilist_fv)'
		local varth `varth' `s(varth)'
		local csymbolic `csymbolic' `s(csymbolic)'
		local onecns `onecns' `s(onecns)'
		local onesym `onesym' `s(onesym)'
		local ginv = `ginv' | `s(ginv)'
		
		local gr_inc `gr_inc' `s(gg)'
		
		foreach g in `s(gg)' {
			local w : list posof "`g'" in gr_levels
			scalar m`w'_irt_k_eq = m`w'_irt_k_eq +1
			local j = m`w'_irt_k_eq
			local m`w'_model`j' `m`w'_model`i'' `model'
			local m`w'_modelname`j' `m`w'_modelname`i'' `s(modelname)'
			local m`w'_models `m`w'_models' `model'
			local m`w'_items`j' `m`w'_items`i'' `varlist'
			local m`w'_k_items`j' `k_items`i''
			local m`w'_sepg`j' `m`w'_sepg`i'' `s(sepg)'
			local m`w'_gsepg`j' `m`w'_gsepg`i'' `s(gsepg)'
			local m`w'_n_cuts`j' `m`w'_n_cuts`i'' `s(n_cuts)'
			local m`w'_off`j' `m`w'_off`i'' `s(off)'
			local m`w'_ilist_fv `m`w'_ilist_fv' `s(m`g'_ilist_fv)'
			foreach v of local varlist {
				local m`w'_mlist `m`w'_mlist' `model'
				local m`w'_ilist `m`w'_ilist' `v'
				local m`w'_mlist_gr `m`w'_mlist_gr' `model'
				local m`w'_ilist_gr `m`w'_ilist_gr' `g':`v'
			}
		}
		
		local gr_id
		local gg
	}
	_get_diopts diopts, `diopts'
	
	if `hasgr' {
		local gr_inc : list uniq gr_inc
		if `=`: list sizeof gr_inc'' == 1 {
			di as err "group variable has only one value in the sample"
			exit 198
		}
		
		local j 0
		foreach i of local gr_levels {
			local ++j
			local dups : list dups m`j'_ilist
			if !missing("`dups'") {
				di as err "group `i' has duplicate items: {bf:`dups'}"
				di as err "duplicate items not allowed"
				exit 198
			}
		}
	}
	else {
		local dups : list dups ilist
		if !missing("`dups'") {
			di as err "duplicate items: {bf:`dups'}"
			di as err "duplicate items not allowed"
			exit 198
		}
	}
	
	tempname base last
	local n : list sizeof ilist
	mat `base' = J(1,`n',0)
	mat `last' = J(1,`n',0)
	local j = 1
	foreach i of local ilist {
		qui summ `i' if `touse', meanonly
		if r(N) == 0 {
			di as err "item {bf:`i'} contains only missing values"
			exit 2000
		}
		if r(min) == r(max) {
			di as err "the model is not identified;"
			di as err "{p 4 4 2}"				///
				"item {bf:`i'} does not vary in the "	///
				"estimation sample{p_end}"
				exit 459
		}
		mat `base'[1,`j'] = `r(min)'
		mat `last'[1,`j'] = `r(max)'
		local ++j
	}
	mat colnames `base' = `ilist'
	mat colnames `last' = `ilist'

	if "`csymbolic'" != "" {
		mata: irt__get_csymbolic("`csymbolic'")
		forvalues k=1/`csymb_cnt' {
			gettoken i rest : csymb`k'
				foreach j of local rest {
				constraint free
				local c `r(free)'
				constraint `c' `i' = `j'
				local csymb `csymb' `c'
			}
		}
	}

	if "`varth'" == "" local v_at 1

	local opts variance(`gr_var1'`llabel'@`v_at') latent(`llabel') ///
		constraints(`cns_usr' `cns_st' `csymb') `startvalues' `listwise'

	if !missing("`_from'") & missing("`from'") {
		local from from(`_from',skip)
	}

	if `preserve' {
		tempvar miss fw
		if "`listwise'" != "" {
			qui egen byte `miss' = rowmiss(`ilist') if `touse'
			qui replace `touse' = 0 if `miss'
		}
		else {
			qui egen byte `miss' = rownonmiss(`ilist') if `touse'
			qui replace `touse' = 0 if !`miss'
		}
		preserve
		contract `ilist' `clust' `one' `touse' `wopt' if `touse', freq(`fw')
		local wt [fweight=`fw']
		local cmd1 `eqs' if `touse' `wt'
		qui count
		local N_p `r(N)'
	}
	else {
		local cmd1 `eqs' if `touse' `wopt'
	}
	
	if `hasgr' {
		if `ginv' local gi ginvariant(none)
		local gropt group(`group') forcenoanchor `gi'
	}
	
	local cmd1 `cmd1', `opts' `eq_opts' `gl_opts' `from' `gropt' collinear
	local cmd2 `eqs' `if' `in' `wopt', `opts' `eq_opts' `gl_opts' ///
		`from' `gropt' collinear
	local cmd2 : list clean cmd2

	`vv' ///
	gsem `cmd1' irtcmd noheader nocnsreport notable nodvheader `estimate'
	
	if `hasrsm' {
		capture drop _one
	}

	if `hasgr' {
		local k = e(N_groups)
		foreach gg in `gr_levels' {
			local g : label (`group') `gg'
			ereturn hidden local grlabel`gg' `"`g'"'
		}
		ereturn local groupvar `group'
		ereturn hidden local group_levels `gr_levels'
		ereturn hidden local group_labels `"`gr_labels'"'
		ereturn hidden local group_list_fv `grlist_fv'
		
	}

	local gr_invariant `m1_ilist'
	
	local ilist : list uniq ilist
	local ilist_fv : list uniq ilist_fv
	
	tempname fvmat m
	foreach g in `gr_levels' {
		local w : list posof "`g'" in gr_levels
		local gr_invariant : list gr_invariant & m`w'_ilist
		forvalues i = 1/`eq_n' {
			ereturn hidden local m`w'_model`i' `m`w'_model`i''
			ereturn hidden local m`w'_items`i' `m`w'_items`i''
			capture ereturn hidden scalar m`w'_k_items`i' = `m`w'_k_items`i''
			capture ereturn hidden scalar m`w'_sepguess`i' = `m`w'_sepg`i''
			capture ereturn hidden scalar m`w'_gsepguess`i' = `m`w'_gsepg`i''
			ereturn hidden local m`w'_n_cuts`i' `m`w'_n_cuts`i''
			ereturn hidden local m`w'_off`i' `m`w'_off`i''
			ereturn hidden local m`w'_item_list `m`w'_ilist'
			ereturn hidden local m`w'_item_list_fv `m`w'_ilist_fv'
			ereturn hidden local m`w'_model_list `m`w'_mlist'
		}
		local item_list_gr `item_list_gr' `m`w'_ilist_gr'
		local mlist_gr `mlist_gr' `m`w'_mlist'
		ereturn hidden scalar m`w'_irt_k_eq = m`w'_irt_k_eq
		
		local items_fv `e(m`w'_item_list_fv)'
		local nn : list sizeof items_fv
		mata: st_matrix(st_local("fvmat"),J(1,`nn',0))
		mat colnames `fvmat' = `items_fv'
		ereturn hidden matrix m`w'_fvmat = `fvmat'
		
		foreach it in `ilist' {
			local jj : list posof "`it'" in ilist
			qui tab `it' if `group' == `g' & `touse', matrow(`m')
			if !inlist("`r(N)'", "", "0") {
				// capture possible empty sample when
				// `it' is missing for all elements of
				// the current group

				ereturn hidden matrix m`w'_`jj'_levels = `m'
			}
		}
	}
	ereturn hidden local item_list_gr `item_list_gr'
	ereturn hidden local model_list_gr `mlist_gr'

	if `eq_n'==1 local MODEL `modelname1'
	else	     local MODEL "Hybrid IRT"
	ereturn local title "`MODEL' model"
	ereturn hidden local llabel `llabel'

	foreach i of local ilist {
		local jj : list posof "`i'" in ilist
		qui tab `i' if `touse', matrow(`m')
		ereturn hidden matrix item_`jj'_values = `m'
	}

	// hidden results
	ereturn hidden local cmdline2 `"gsem `cmd2'"'
	ereturn hidden local models `models'
	ereturn hidden local model_list `mlist'
	ereturn hidden local item_list `ilist'
	ereturn hidden local item_list_fv `ilist_fv'
	ereturn hidden matrix base = `base'
	ereturn hidden matrix last = `last'

	forvalues i = 1/`eq_n' {
		ereturn local model`i' `model`i''
		ereturn local items`i' `items`i''
		ereturn scalar k_items`i' = `k_items`i''

		capture ereturn scalar sepguess`i' = `sepg`i''
		capture ereturn scalar gsepguess`i' = `gsepg`i''

		ereturn hidden local n_cuts`i' `n_cuts`i''
		local off `off' `off`i''
	}
	capture ereturn hidden local off `off'
	ereturn hidden local n_cuts_all `n_cuts_all'

	foreach c in `cns_usr' `csymb' {
		local tmp : constraint `c'
		ereturn hidden local irt_cns_`c' `tmp'
		constraint drop `c'
	}
	ereturn hidden local irt_cns_list `cns_usr' `csymb'

	ereturn scalar irt_k_eq = `eq_n'

	ereturn local estat_cmd irt_estat
	ereturn local cmd2 irt
	
	ereturn local predict "irt_p"
	
	ereturn hidden local marginsdefault "`e(marginsdefault)'"
	ereturn hidden local marginsok "`e(marginsok)'"
	ereturn hidden local marginsnotok "`e(marginsnotok)'"
	ereturn hidden scalar contract = `preserve'
	
	ereturn hidden scalar irt_version = 2
	
	if `preserve' {
		restore
		ereturn repost `wopt', esample(`touse')
		ereturn hidden scalar N_patterns = `N_p'
		if "`wopt'" == "" {
			ereturn local wtype
			ereturn local wexp
		}
		signestimationsample `ilist' `clust'
	}

	irt_display, `diopts' `opts_not' `coeflegend' `estmetric'
	
	mata: irt__gr_invariant()
end

program __check_model
	syntax , model(string) allowed(string)
	local good : list posof "`model'" in allowed
	if !`good' {
		di as err "invalid model {bf:`model'};"
		di as err "{bf:`model'} is not one of the officially "	///
			"supported {help irt} models."
		exit 198
	}
end

program __make_1pl, sclass
	version 14
	syntax varlist, latent(name) ix(string) touse(varname) ///
		[cns_usr(string) *]
	__check01 `varlist' , touse(`touse') model(1pl)
	
	// process cns() option
	mata: irt__get_cns("1pl")

	if "`a1'" == "" local a1 a`ix'
	local eq (`latent'@`a1' _cons@`b1' -> `varlist', logit)
	
	sreturn local ginv 0
	sreturn local varth `v1'
	sreturn local eq `eq'
	sreturn local ilist_fv `s(ilist_fv)'
	sreturn local off `=`:list sizeof varlist'*2'
	if "`v1'" == "" {
		sreturn local modelname "One-parameter logistic"
	}
	else	sreturn local modelname "Rasch"
end

program __make_1pl1, sclass
	version 16
	syntax varlist, latent(name) ix(string) touse(varname) ///
		group(string) grlev(string) [grid(string) cns_usr(string) *]
	__check01 `varlist' , touse(`touse') model(1pl)
	local ilist_fv `s(ilist_fv)'

	if "`grid'" != "" {
		local gg `grid'
		local idd `"`grid':"'
	}
	else local gg `grlev'
	
	// process cns() option
	mata: irt__get_cns("1pl")
	
	if "`a1'" == "" local a1 a`ix'
	local addb = "`b1'" == ""
	
	local eq (`idd'`latent'@`a1' -> `varlist', logit)
	
	local cnt 0
	foreach v of local varlist {
		local ++cnt
				
		if `addb' local bb b`ix'_`cnt'
		else 	  local bb `b1'
		
		local eqq `eqq' `v'@`bb'
	}
	local eqq (`idd'_cons -> `eqq', logit)
	
	local eq `eq' `eqq'
	
	sreturn local gg `gg'
	sreturn local ginv 0
	foreach g of local gg {
		sreturn local m`g'_ilist_fv `ilist_fv'
	}
	sreturn local eq `eq'
	sreturn local ilist_fv `ilist_fv'
	sreturn local off `=`:list sizeof varlist'*2'
	sreturn local modelname "One-parameter logistic"
end

program __make_2pl, sclass
	version 14
	syntax varlist, latent(name) ix(string) touse(varname) ///
		[cns_usr(string) *]
	__check01 `varlist' , touse(`touse') model(2pl)

	// process cns() option
	mata: irt__get_cns("2pl")

	local eq (`latent'@`a1' _cons@`b1' -> `varlist', logit)
	
	sreturn local ginv 0
	sreturn local eq `eq'
	sreturn local ilist_fv `s(ilist_fv)'
	sreturn local off `=`:list sizeof varlist'*2'
	sreturn local modelname "Two-parameter logistic"
end

program __make_2pl1, sclass
	version 16
	syntax varlist, latent(name) ix(string) touse(varname) ///
		group(string) grlev(string) [grid(string) cns_usr(string) *]
	__check01 `varlist' , touse(`touse') model(2pl)
	local ilist_fv `s(ilist_fv)'
	
	if "`grid'" != "" {
		local gg `grid'
		local idd `"`grid':"'
	}
	else local gg `grlev'
	
	// process cns() option
	mata: irt__get_cns("2pl")
	
	local adda = "`a1'" == ""
	local addb = "`b1'" == ""
	
	local cnt 0
	foreach v of local varlist {
		local ++cnt
		
		if `adda' local aa a`ix'_`cnt'
		else 	  local aa `a1'
		
		if `addb' local bb b`ix'_`cnt'
		else 	  local bb `b1'
		
		local eq `eq' `v'@`aa'
		local eqq `eqq' `v'@`bb'
	}
	local eq (`idd'`latent' -> `eq', logit)
	local eqq (`idd'_cons -> `eqq', logit)
	
	local eq `eq' `eqq'
	
	sreturn local gg `gg'
	sreturn local ginv 0
	foreach g of local gg {
		sreturn local m`g'_ilist_fv `ilist_fv'
	}
	sreturn local eq `eq'
	sreturn local ilist_fv `ilist_fv'
	sreturn local off `=`:list sizeof varlist'*2'
	sreturn local modelname "Two-parameter logistic"
end

program __make_3pl, sclass
	version 14
	syntax varlist, latent(name) ix(string) touse(varname) ///
		[SEPGuessing CONSTRaints(numlist) cns_usr(string) *]

	__check01 `varlist' , touse(`touse') model(3pl)
	sreturn local ilist_fv `s(ilist_fv)'

	// process cns() option
	mata: irt__get_cns("3pl")

	local eq (`latent'@`a1' _cons@`b1' -> `varlist', family(3pl))
	
	local sepg = !missing("`sepguessing'")
	
	if "`c1'" != "" {
		foreach i of local varlist {
			constraint free
			local c `r(free)'
			constraint `c' _b[/`i':logitc] = `c1'
			local cns `cns' `c'
		}
	}
	if "`c2'" != "" {
		foreach i of local varlist {
			local csymbolic `csymbolic' _b[/`i':logitc] `c2'
		}
	}
	if !`sepg' & "`c1'`c2'" == "" {
		gettoken i rest : varlist
		foreach j of local rest {
			constraint free
			local c `r(free)'
			if _caller() < 15 {
				constraint `c' _b[`i'_logitc:_cons] =	///
					 _b[`j'_logitc:_cons]
			}
			else {
				constraint `c' _b[/`i':logitc] =	///
					 _b[/`j':logitc]
			}
			local cns `cns' `c'
		}
	}

	sreturn local ginv 0
	sreturn local eq `eq'
	sreturn local cns_usr `cns'
	sreturn local cns_st `constraints'
	sreturn local sepg `sepg'
	sreturn local off `=`:list sizeof varlist'*3'
	sreturn local modelname "Three-parameter logistic"
	sreturn local csymbolic `csymbolic'
end

program __make_3pl1, sclass
	version 14
	syntax varlist, latent(name) ix(string) touse(varname) ///
		group(string) grlev(string) [grid(string) cns_usr(string) ///
		SEPGuessing GSEPGuessing CONSTRaints(numlist) *]

	__check01 `varlist' , touse(`touse') model(3pl)
	local ilist_fv `s(ilist_fv)'
		
	if "`grid'" != "" {
		local gg `grid'
		local idd `"`grid':"'
	}
	else local gg `grlev'
	
	// process cns() option
	mata: irt__get_cns("3pl")

	// this is exactly like a 2pl model
	
	local adda = "`a1'" == ""
	local addb = "`b1'" == ""
	
	local cnt 0
	foreach v of local varlist {
		local ++cnt
		
		if `adda' local aa a`ix'_`cnt'
		else 	  local aa `a1'
		if `addb' local bb _`cnt'
		else	  local bb `b1'
		
		local eq `eq' `v'@`aa'
		local eqq `eqq' `v'@`bb'
	}
	local eq (`idd'`latent' -> `eq', family(3pl))
	local eqq (`idd'_cons -> `eqq', family(3pl))
	
	local eq `eq' `eqq'
	
	// this is unique to a 3pl model
		
	local sepg = !missing("`sepguessing'")
	local gsepg = !missing("`gsepguessing'")
	if `gsepg' & "`grid'" != "" {
		di as err "option {bf:gsepguessing} not allowed"
		exit 198
	}
	local cnsok = !(`sepg' & `gsepg')
	
	if "`c1'" != "" {
		foreach i of local varlist {
			foreach g of local gg {
				constraint free
				local c `r(free)'
				constraint `c' _b[/`i':`g'.`group'#logitc] = `c1'
				local cns `cns' `c'
			}
		}
	}
	else if "`c2'" != "" {
		foreach i of local varlist {
			foreach g of local gg {
				local csymbolic `csymbolic' _b[/`i':`g'.`group'#logitc] `c2'
			}
		}
	}
	else if `sepg' & `cnsok' { // c's equal across items
		gettoken ref focal : gg
		local rr "`ref'.`group'#"
		
		foreach f of local focal {
			foreach v of local varlist {		
				constraint free
				local c `r(free)'
				constraint `c' _b[/`v':`rr'logitc] = ///
					 _b[/`v':`f'.`group'#logitc]
				local cns `cns' `c'
			}
		}
	}
	else if `gsepg' & `cnsok' { // c's equal within groups
		gettoken i rest : varlist
		
		foreach v of local rest {
			foreach g of local gg {
				constraint free
				local c `r(free)'	
				constraint `c' _b[/`i':`g'.`group'#logitc] = ///
				 	_b[/`v':`g'.`group'#logitc]
				local cns `cns' `c'
			}
		}
	}
	else if `sepg' & `gsepg' {
		// no constraints on c's
	}
	else { // c's equal within groups and across items (default)
		gettoken ref focal : gg
		local rr "`ref'.`group'#"
		
		gettoken i rest : varlist
		foreach j of local rest {
			constraint free
			local c `r(free)'
			constraint `c' _b[/`i':`rr'logitc] = ///
				_b[/`j':`rr'logitc]
			local cns `cns' `c'
		}
		
		foreach f of local focal {
			foreach v of local varlist {
				constraint free
				local c `r(free)'
				constraint `c' _b[/`i':`rr'logitc] = ///
					 _b[/`v':`f'.`group'#logitc]
				local cns `cns' `c'
			}
		}
	}
	
	sreturn local gg `gg'
	sreturn local ginv 0
	foreach g of local gg {
		sreturn local m`g'_ilist_fv `ilist_fv'
	}
	sreturn local ilist_fv `ilist_fv'
	sreturn local eq `eq'
	sreturn local cns_usr `cns'
	sreturn local cns_st `constraints'
	sreturn local sepg `sepg'
	sreturn local off `=`:list sizeof varlist'*3'
	sreturn local modelname "Three-parameter logistic"
	sreturn local csymbolic `csymbolic'
end

program __make_grm, sclass
	version 14
	syntax varlist, latent(name) ix(string) touse(varname) ///
		[cns_usr(string) *]
	local off 0
	local m 0
	foreach v of local varlist {
		local ++m
		tempname m`m'
		qui tab `v' if `touse', matrow(`m`m'')
		local off = `off' + `r(r)'
		local cuts `cuts' `r(r)'
		local rows = rowsof(`m`m'')
		forvalues i=1/`rows' {
			local z = `m`m''[`i',1]
			__isInteger `z' `v'
			local ilist_fv `ilist_fv' `z'.`v'
		}
		local _from `_from' `v':`latent'=1
	}
	
	// process cns() option
	mata: irt__get_cns("grm")
	forvalues i=1/`k' {
		local m 0
		foreach v of local varlist {
			local ++m
			if "`b`i''" != "" {
				local r = rowsof(`m`m'') -1
				if `i' > `r' {
					di as txt "(item `v': constraint on b`i' ignored)"
				}
				else {
					constraint free
					local c `r(free)'
					constraint `c' _b[/`v':cut`i'] = `b`i''
					local cns `cns' `c'
				}
			}
		}
	}

	sreturn local ginv 0
	sreturn local eq (`latent'@`a1' -> `varlist', ologit)
	sreturn local cns_usr `cns'
	sreturn local off `off'
	sreturn local n_cuts `cuts'
	sreturn local _from `_from'
	sreturn local ilist_fv `ilist_fv'
	sreturn local modelname "Graded response"
end

program __make_grm1, sclass
	version 16
	syntax varlist, latent(name) ix(string) touse(varname) ///
		group(string) grlev(string) [grid(string) cns_usr(string) *]
	
	local ginv 0
	if "`grid'" != "" {
		local gg `grid'
		local idd `"`grid':"'
		local ginv 1
	}
	else local gg `grlev'
	
	tempname m
	local maxr 0
	local off 0
	foreach v of local varlist {
		qui tab `v' if `touse', matrow(`m')
		local off = `off' + `r(r)'
		local cuts `cuts' `r(r)'
		local r = rowsof(`m')
		if `r' > `maxr' local maxr `r'
		forvalues i=1/`r' {
			local z = `m'[`i',1]
			__isInteger `z' `v'
			local ilist_fv `ilist_fv' `z'.`v'
		}
		foreach g of local gg {
			local _from `_from' `v':`g'.`group'#c.`latent'=1
		}
	}

	// process cns() option
	mata: irt__get_cns("grm")

	local adda = "`a1'" == ""

	foreach v of local varlist {
		foreach g of local gg {
			qui tab `v' if `touse' & `group'==`g', matrow(`m')
			
			local r = rowsof(`m')
			forvalues ii=1/`r' {
				local z = `m'[`ii',1]
				local m`g'_ilist_fv `m`g'_ilist_fv' `z'.`v'
			}
			local --r
			
			forvalues i=1/`k' {
				if "`b`i''" != "" {		
					if `i' > `r' {
						di as txt "(item `v': constraint on b`i' ignored for group `g')"
					}
					else {
						constraint free
						local c `r(free)'
						constraint `c' _b[/`v':`g'.`group'#cut`i'] = `b`i''
						local cns `cns' `c'
					}
				}
			}
		}
	}

	if !`ginv' {
		local --maxr
		gettoken ref focal : gg
		tempname mm
		foreach v of local varlist {
			qui tab `v' if `touse' & `group'==`ref', matrow(`mm')
			local p = rowsof(`mm') -1
			forvalues i=1/`maxr' {
				foreach f of local focal {
					qui tab `v' if `touse' & `group'==`f', matrow(`m')
					local r = rowsof(`m') -1
					if `i' <= `r' & `i' <= `p' {
						if "`b`i''" == "" {
							qui tab `v' if `touse' & `group'==`f', matrow(`m')
							local r = rowsof(`m') -1
							constraint free
							local c `r(free)'
							constraint `c' _b[/`v':`ref'.`group'#cut`i'] = _b[/`v':`f'.`group'#cut`i']
							local cns `cns' `c'
						}
					}
				}
			}
		}
	}

	local cnt 0
	foreach v of local varlist {
		local ++cnt
		
		if `adda' local aa a`ix'_`cnt'
		else 	  local aa `a1'
	
		local eq `eq' (`idd'`latent'@`aa' -> `v', ologit)
	}
	
	sreturn local gg `gg'
	sreturn local ginv `ginv'
	sreturn local eq `eq'
	sreturn local cns_usr `cns'
	sreturn local off `off'
	sreturn local n_cuts `cuts'
	sreturn local _from `_from'
	sreturn local ilist_fv `ilist_fv'
	foreach g of local gg {
		sreturn local m`g'_ilist_fv `m`g'_ilist_fv'
	}
	sreturn local modelname "Graded response"
end

program __make_nrm, sclass
	version 14
	syntax varlist, latent(name) ix(string) touse(varname) ///
		[cns_usr(string) *]
	
	local off 0
	local i 0
	foreach v of local varlist {
		local ++i
		tempname m`i'
		
		qui tab `v' if `touse', matrow(`m`i'')
		local n_cuts = `r(r)'
		local cuts `cuts' `r(r)'
		local off = `off' + `r(r)'*2
		
		forvalues j=1/`n_cuts' {
			local z = el(`m`i'',`j',1)
			__isInteger `z' `v'
			local ilist_fv `ilist_fv' `z'.`v'
			if `j'>1 {
				local _from `_from' `z'.`v':`latent'=1
			}
		}	
		mat `m`i'' = `m`i''[2...,1]
	}
	
	// process cns() option
	mata: irt__get_cns("nrm")

	local i 0
	foreach v of local varlist {
		local ++i
		local r = rowsof(`m`i'')
		forvalues j=1/`k' {
			local z = el(`m`i'',`j',1)
			if "`a`j''" != "" {
				if `j' > `r' {
					di as txt "(item `v': constraint on a`j' ignored)"
				}
				else {
					capture confirm number `a`j''
					local anum = !_rc
					if `anum' {
						constraint free
						local c `r(free)'
						constraint `c' _b[`z'.`v':`latent'] = `a`j''
						local cns `cns' `c'
					}
					else {
						local eqq `eqq' (`z'.`v' <- Theta@`a`j'', mlogit)
					}
				}
			}
			if "`b`j''" != "" {
				// symbolic constraints on b not allowed
				// capture confirm number `b`j''
				// local bnum = !_rc
				if `j' > `r' {
					di as txt "(item `v': constraint on b`j' ignored)"
				}
				else {
					constraint free
					local c `r(free)'
					constraint `c' _b[`z'.`v':_cons] = `b`j''
					local cns `cns' `c'
				}
			}
		}
	}

	sreturn local ginv 0
	sreturn local eq (`latent' -> `varlist', mlogit) `eqq'
	sreturn local cns_usr `cns'
	sreturn local off `off'
	sreturn local n_cuts `cuts'
	sreturn local _from `_from'
	sreturn local ilist_fv `ilist_fv'
	sreturn local modelname "Nominal response"
end

program __make_nrm1, sclass
	version 16
	syntax varlist, latent(name) ix(string) touse(varname) ///
		group(string) grlev(string) [grid(string) cns_usr(string) *]
	
	local ginv 0
	if "`grid'" != "" {
		local gg `grid'
		local idd `"`grid':"'
		local ginv 1
	}
	else local gg `grlev'
	
	local off 0
	local maxr 0
	local i 0
	foreach v of local varlist {
		local ++i
		tempname m`i'
		
		qui tab `v' if `touse', matrow(`m`i'')
		local n_cuts = `r(r)'
		local cuts `cuts' `r(r)'
		local off = `off' + `r(r)'*2
		local r = rowsof(`m`i'')
		if `r' > `maxr' local maxr `r'
		
		forvalues j=1/`n_cuts' {
			local z = el(`m`i'',`j',1)
			__isInteger `z' `v'
			local ilist_fv `ilist_fv' `z'.`v'
			if `j'>1 {
				foreach g of local gg {
					local _from `_from' `z'.`v':`g'.`group'#c.`latent'=1
				}
			}
		}	
		mat `m`i'' = `m`i''[2...,1]
	}

	// process cns() option
	mata: irt__get_cns("nrm")

	tempname m
	local --maxr
	local i 0
	foreach v of local varlist {
		local ++i
		foreach g of local gg {
			qui tab `v' if `touse' & `group'==`g', matrow(`m')

			local r = rowsof(`m')
			forvalues ii=1/`r' {
				local z = `m'[`ii',1]
				local m`g'_ilist_fv `m`g'_ilist_fv' `z'.`v'
			}
			local --r

			forvalues j=1/`k' {
				local jj = `j' +1
				
				if "`a`j''" != "" {
					if `j' > `r' {
						di as txt "(item `v': constraint on a`j' ignored for group `g')"
					}
					else {
						local z = el(`m',`jj',1)
						capture confirm number `a`j''
						local anum = !_rc
						if `anum' {
							constraint free
							local c `r(free)'
							constraint `c' _b[`z'.`v':`g'.`group'#c.`latent'] = `a`j''
							local cns `cns' `c'
						}
						else {		
							local eqq `eqq' (`g':`z'.`v' <- Theta@`a`j'', mlogit)
						}
					}
				}

				if "`b`j''" != "" {
					// symbolic constraints on b not allowed
					// capture confirm number `b`j''
					// local bnum = !_rc
					if `j' > `r' {
						di as txt "(item `v': constraint on b`j' ignored for group `g')"
					}
					else {
						local z = el(`m',`jj',1)
						constraint free
						local c `r(free)'
						constraint `c' _b[`z'.`v':`g'.`group'] = `b`j''
						local cns `cns' `c'
					}
				}
			}
		}
	}

	if !`ginv' {
		gettoken ref focal : gg
		tempname mm
		foreach v of local varlist {
			qui tab `v' if `touse' & `group'==`ref', matrow(`mm')
			local p = rowsof(`mm') -1
			forvalues j=1/`maxr' {
				local jj = `j' +1
				foreach g of local focal {
					qui tab `v' if `touse' & `group'==`g', matrow(`m')
					local r = rowsof(`m') -1
					if `j' <= `r' & `j' <= `p' {
						local w = el(`mm',`jj',1)
						local z = el(`m',`jj',1)
						if "`a`j''" == "" {
constraint free
local c `r(free)'
constraint `c' _b[`w'.`v':`ref'.`group'#c.`latent'] = _b[`z'.`v':`g'.`group'#c.`latent']
local cns `cns' `c'
						}
					
						if "`b`j''" == "" {
constraint free
local c `r(free)'
constraint `c' _b[`w'.`v':`ref'.`group'] = _b[`z'.`v':`g'.`group']
local cns `cns' `c'
						}
					}
				}
			}
		}
	}
	
	local eq (`idd'`latent' -> `varlist', mlogit)

	sreturn local gg `gg'
	sreturn local ginv `ginv'
	sreturn local eq `eq' `eqq'
	sreturn local cns_usr `cns'
	sreturn local off `off'
	sreturn local n_cuts `cuts'
	sreturn local _from `_from'
	sreturn local ilist_fv `ilist_fv'
	foreach g of local gg {
		sreturn local m`g'_ilist_fv `m`g'_ilist_fv'
	}
	sreturn local modelname "Nominal response"
end

program __make_pcm,  sclass
	version 14
	syntax varlist, latent(name) ix(string) touse(varname) ///
		[generalized cns_usr(string) *]

	local gen = !missing("`generalized'")
	local n_vars : list sizeof varlist

	local off 0
	local i 0
	foreach v of local varlist {
		local ++i
		if `gen' local c `i'
		tempname m`i'
		qui tab `v' if `touse', matrow(`m`i'')
		local n_cuts = `r(r)'
		local cuts `cuts' `r(r)'
		local off = `off' + `n_cuts'*2
	}

	// process cns() option
	mata: irt__get_cns("pcm")
	
	local i 0
	foreach v of local varlist {
		local ++i
		if `gen' local c `i'
		local kk 0
		local n_cuts = rowsof(`m`i'')
		forvalues j=1/`n_cuts' {
			local z = el(`m`i'',`j',1)
			__isInteger `z' `v'
			local ilist_fv `ilist_fv' `z'.`v'
			if "`a`j''" != "" {
				local aa`j' `a`j''
			}
			else {
				local aa`j' `kk'*a`c'_`ix'
			}
			local eq ( `z'.`v' <- `latent'@(`aa`j'') , mlogit)
			local ++kk
			local eqs `eqs' `eq'
			if `j'>1 {
				local _from `_from' `z'.`v':`latent'=`=`j'-1'
			}
		}
	}

	local ++k
	local i 0
	foreach v of local varlist {
		local ++i
		local r = rowsof(`m`i'')
		forvalues j=1/`k' {
			local z = el(`m`i'',`j',1)
			if "`b`j''" != "" {
				if `j' > `r' {
					local jj = `j' -1
					di as txt "(item `v': constraint on b`jj' ignored)"
				}
				else {
					constraint free
					local c `r(free)'
					constraint `c' _b[`z'.`v':_cons] = `b`j''
					local cns `cns' `c'
				}
			}
		}
	}
	
	sreturn local ginv 0
	sreturn local eq `eqs'
	sreturn local cns_usr `cns'
	sreturn local off `off'
	sreturn local n_cuts `cuts'
	sreturn local _from `_from'
	sreturn local ilist_fv `ilist_fv'
	sreturn local modelname "Partial credit"
end

program __make_pcm1,  sclass
	version 16
	syntax varlist, latent(name) ix(string) touse(varname) ///
		group(string) grlev(string) [grid(string) generalized ///
		cns_usr(string) *]
	
	local ginv 0
	if "`grid'" != "" {
		local gg `grid'
		local idd `"`grid':"'
		local ginv 1
		local grp _`grid'
	}
	else local gg `grlev'
	
	local gen = !missing("`generalized'")
	local n_vars : list sizeof varlist

	tempname m
	local off 0
	local i 0
	foreach v of local varlist {
		local ++i
		tempname m`i'
		qui tab `v' if `touse', matrow(`m`i'')
		local n_cuts = `r(r)'
		local cuts `cuts' `r(r)'
		local off = `off' + `n_cuts'*2
	}

	// process cns() option
	mata: irt__get_cns("pcm")
	
	local maxr 0
	local i 0
	foreach v of local varlist {
		local ++i
		local k 0
		if `gen' local c `i'
		foreach g of local gg {
			qui tab `v' if `touse' & `group'==`g', matrow(`m')
			local k 0
			local n_cuts = rowsof(`m')
			if `n_cuts' > `maxr' local maxr `n_cuts'
			forvalues j=1/`n_cuts' {
				local z = el(`m',`j',1)
				__isInteger `z' `v'
				local ilist_fv `ilist_fv' `z'.`v'
				if "`a`j''" != "" {
					local aa`j' `a`j''
				}
				else {
					local aa`j' `k'*a`c'_`ix'`grp'
				}
				local eq ( `g':`z'.`v' <- `latent'@(`aa`j'') , mlogit)
				local eqs `eqs' `eq'

				if `j'>1 {
					local _from `_from' `z'.`v':`g'.`group'#`latent'=`=`j'-1'
				}
				local ++k
			}
		}
	}

	local --maxr
	tempname m
	local i 0
	foreach v of local varlist {
		local ++i
		forvalues j=1/`maxr' {
			local jj = `j' +1
			foreach g of local gg {
				qui tab `v' if `touse' & `group'==`g', matrow(`m')
				
				local r = rowsof(`m')
				forvalues ii=1/`r' {
					local z = `m'[`ii',1]
					local m`g'_ilist_fv `m`g'_ilist_fv' `z'.`v'
				}
				local --r
				
				if "`b`jj''" != "" {
					if `j' > `r' {
						di as txt "(item `v': constraint on b`j' ignored for group `g')"
					}
					else {
						local z = el(`m',`jj',1)
						constraint free
						local c `r(free)'
						constraint `c' _b[`z'.`v':`g'.`group'] = `b`jj''
						local cns `cns' `c'
					}
				}
			}
		}
	}

	// constraints on a are handled above;
	// here we add constraints on b if needed
	
	if !`ginv' {
		tempname m mm
		gettoken ref focal : gg
		
		local i 0
		foreach v of local varlist {
			local ++i
			qui tab `v' if `touse' & `group'==`ref', matrow(`mm')
			local p = rowsof(`mm') -1
			forvalues j=1/`maxr' {
				local jj = `j' +1
				if "`b`j''" == "" {
					foreach g of local focal {
						qui tab `v' if `touse' & `group'==`g', matrow(`m')
						local r = rowsof(`m') -1
						if `j' <= `r' & `j' <= `p' & "`b`jj''" == "" {
							local w = el(`mm',`jj',1)
							local z = el(`m',`jj',1)			
							constraint free
							local c `r(free)'
							constraint `c' _b[`w'.`v':`ref'.`group'] = _b[`z'.`v':`g'.`group']
							local cns `cns' `c'
						}
					}
				}
			}
		}
	}

	sreturn local gg `gg'
	sreturn local ginv `ginv'
	sreturn local eq `eqs'
	sreturn local cns_usr `cns'
	sreturn local off `off'
	sreturn local n_cuts `cuts'
	sreturn local _from `_from'
	sreturn local ilist_fv `ilist_fv'
	foreach g of local gg {
		sreturn local m`g'_ilist_fv `m`g'_ilist_fv'
	}
	sreturn local gg `gg'
	sreturn local modelname "Partial credit"
end

program __make_gpcm, sclass
	version 14
	local vv : di "version " string(_caller()) ", missing:"
	syntax varlist, latent(passthru) ix(passthru) touse(passthru) [*]
	local 0 `varlist', `latent' `ix' `touse' `options' generalized
	`vv' __make_pcm `0'
	sreturn local ginv `s(ginv)'
	sreturn local eq `s(eq)'
	sreturn local cns_usr `s(cns_usr)'
	sreturn local off `s(off)'
	sreturn local n_cuts `s(n_cuts)'
	sreturn local _from `s(_from)'
	sreturn local ilist_fv `s(ilist_fv)'
	sreturn local modelname "Generalized partial credit"
end

program __make_gpcm1, sclass
	version 16
	local vv : di "version " string(_caller()) ", missing:"
	syntax varlist , latent(passthru) ix(passthru) touse(passthru) [*]
	local 0 `varlist', `latent' `ix' `touse' `options' generalized
	`vv' __make_pcm1 `0'
	sreturn local gg `s(gg)'
	sreturn local ginv `s(ginv)'
	sreturn local eq `s(eq)'
	sreturn local cns_usr `s(cns_usr)'
	sreturn local off `s(off)'
	sreturn local n_cuts `s(n_cuts)'
	sreturn local _from `s(_from)'
	sreturn local ilist_fv `s(ilist_fv)'
	foreach g in `s(gg)' {
		sreturn local m`g'_ilist_fv `m`g'_ilist_fv'
	}
	sreturn local modelname "Generalized partial credit"
end

program __make_rsm,  sclass
	version 14
	syntax varlist, latent(name) ix(string) touse(varname) ///
		[cns_usr(string) onecns(string) onesym(string) *]

	local n_vars : list sizeof varlist
	gettoken y ys : varlist

	local i 0
	local ++i

	tempname m`i'
	qui tab `y' if `touse', matrow(`m`i'')
	local n_cuts = `r(r)'
	local cuts `cuts' `r(r)'
	local off = `off' + `n_cuts'*2
		
	// process cns() option
	mata: irt__get_cns("rsm")
	
	// with a symbolic constraint on a, cns(a@k),
	// the locals will be populated as follows
	// a0 "0"
	// a1 "1*k"
	// a2 "2*k"
	// ...
	// aname "k"
	
	local a_pos 0
	local a_symb
	local one_cns
	local tix `ix'
	
	// if there is a symbolic constraint on parameter a,
	// you must constrain the corresponding _one's to be the same
	// but only if there are no constraints on b parameters
	
	// use a list of symbolic constraints on a and an index, for example
	// (rsm q1, cns(a@k1)) (rsm q2, cns(a@k1))
	// (rsm q3, cns(a@k2)) (rsm q4, cns(a@k2))
	// will have the following:
	// onesym : k1 k2
	// onecns : 1  3
	// and then _one for items q1 and q2 will be _one@t1_#
	// and _one for items q3 and q4 will be _one@t3_#
	
	if "`aname'" != "" & "`b1'" == "" {
		local a_pos : list posof "`aname'" in onesym
		if `a_pos' {
			local tix : word `a_pos' of `onecns'
		}
		else {
			local a_symb `aname'
			local one_cns `ix'
		}
	}
	
	forvalues j=1/`n_cuts' {
		local m = `j'-1
		local z = el(`m1',`j',1)
		__isInteger `z' `y'	
		local ilist_fv `ilist_fv' `z'.`y'
		
		if "`a`m''" != "" local aa `a`m''
		else local aa (`m'*L1_`ix')
		
		if "`b`m''" != "" local bb `b`m''
		else local bb (`m'*b`i'_`ix')
		
		if "`t`m''" != "" local tt `t`m''
		else local tt t`tix'_`m'
		
		local eq ( `z'.`y' <- `latent'@`aa' _one@`tt' _cons@`bb' , mlogit)
		local eqs `eqs' `eq'
		
		if `j'>1 {
			local _from `_from' `z'.`y':`latent'=`=`j'-1'
			local cns `cns' _b[`z'.`y':_one] +
		}
	}
	
	local cns_ok = `n_cuts'>2 & !`a_pos' & "`b1'" == ""
	if `cns_ok' {
		local cns `cns' 0 = 0
		constraint free
		local c `r(free)'
		constraint `c' `cns'
		local cns `c'
	}
	else	local cns
	
	local ncuts1 `n_cuts'

	foreach v of local ys {
		local ++i

		tempname m`i'
		qui tab `v' if `touse', matrow(`m`i'')
		local n_cuts = `r(r)'
		if `n_cuts' != `ncuts1' {
			di as err "items {bf:`varlist'} must have "	///
				"the same number of levels"
			exit 198
		}
		local cuts `cuts' `r(r)'
		local off = `off' + `n_cuts'*2
		forvalues j=1/`n_cuts' {
			local m = `j'-1
			local z = el(`m`i'',`j',1)
			__isInteger `z' `v'
			local ilist_fv `ilist_fv' `z'.`v'
			
			if "`a`m''" != "" local aa `a`m''
			else local aa (`m'*L1_`ix')
			
			if "`b`m''" != "" local bb `b`m''
			else local bb (`m'*b`i'_`ix')
			
			if "`t`m''" != "" local tt `t`m''
			else local tt t`tix'_`m'
			
			local eq ( `z'.`v' <- `latent'@`aa' _one@`tt' _cons@`bb' , mlogit)
			local eqs `eqs' `eq'
			
			if `j'>1 {
				local _from `_from' `z'.`v':`latent'=`=`j'-1'
			}
		}
	}
	
	sreturn local onecns `one_cns'
	sreturn local onesym `a_symb'
	sreturn local ginv 0
	sreturn local eq `eqs'
	sreturn local cns_usr `cns'
	sreturn local off `off'
	sreturn local n_cuts `cuts'
	sreturn local _from `_from'
	sreturn local ilist_fv `ilist_fv'
	sreturn local modelname "Rating scale"
end

program __make_rsm1,  sclass
	version 16
	syntax varlist, latent(name) ix(string) touse(varname) ///
		group(string) grlev(string) [grid(string) cns_usr(string) ///
		onecns(string) onesym(string) *]

	local ginv 0
	if "`grid'" != "" {
		local gg `grid'
		local idd `"`grid':"'
		local ginv 1
	}
	else local gg `grlev'
	
	tempname mm
	local maxr 0
	foreach v of local varlist {
		foreach g of local gg {
			qui tab `v' if `touse' & `group'==`g', matrow(`mm')
			local r = rowsof(`mm')
			local levs `levs' `r'
		}
	}	
	local levs : list uniq levs
	if `=`: list sizeof levs'' > 1 {
		di as err "items {bf:`varlist'} must have " ///
			"the same number of levels for each group"
		exit 198
	}

	gettoken g1 gg : gg
		
	local n_vars : list sizeof varlist
	gettoken y ys : varlist

	local i 0
	local ++i

	tempname m`i'
	qui tab `y' if `touse', matrow(`mm')
	local n_cuts = `r(r)'
	local cuts `cuts' `r(r)'
	local off = `off' + `n_cuts'*2
		
	// process cns() option
	mata: irt__get_cns("rsm")
	
	// with a symbolic constraint on a, cns(a@k),
	// the locals will be populated as follows
	// a0 "0"
	// a1 "1*k"
	// a2 "2*k"
	// ...
	// aname "k"
	
	local a_pos 0
	local a_symb
	local one_cns
	local tix `ix'

	// if there is a symbolic constraint on parameter a,
	// you must constrain the corresponding _one's to be the same
	// but only if there are no constraints on b parameters
	
	// use a list of symbolic constraints on a and an index, for example
	// (rsm q1, cns(a@k1)) (rsm q2, cns(a@k1))
	// (rsm q3, cns(a@k2)) (rsm q4, cns(a@k2))
	// will have the following:
	// onesym : k1 k2
	// onecns : 1  3
	// and then _one for items q1 and q2 will be _one@t1_#
	// and _one for items q3 and q4 will be _one@t3_#
	
	if "`aname'" != "" & "`b1'" == "" {
		local a_pos : list posof "`aname'" in onesym
		if `a_pos' {
			local tix : word `a_pos' of `onecns'
		}
		else {
			local a_symb `aname'
			local one_cns `ix'
		}
	}
	
	forvalues j=1/`n_cuts' {
		local m = `j'-1
		local z = el(`mm',`j',1)
		__isInteger `z' `y'	
		local ilist_fv `ilist_fv' `z'.`y'
		
		if "`a`m''" != "" local aa `a`m''
		else local aa (`m'*L1_`ix')
		
		if "`b`m''" != "" local bb `b`m''
		else local bb (`m'*b`i'_`ix')
		
		if "`t`m''" != "" local tt `t`m''
		else local tt t`tix'_`m'
		
		local eq (`idd'`z'.`y' <- `latent'@`aa' _one@`tt' _cons@`bb' , mlogit)

		local eqs `eqs' `eq'
		if `j'>1 {
			local _from `_from' `z'.`y':`g1'.`group'#`latent'=`=`j'-1'
			local cns `cns' _b[`z'.`y':`g1'.`group'#_one] +
		}
	}

	local cns_ok = `n_cuts'>2 & !`a_pos' & "`b1'" == ""
	if `cns_ok' {
		local cns `cns' 0 = 0
		constraint free
		local c `r(free)'
		constraint `c' `cns'
		local cns `c'
	}
	else	local cns
	
	local ncuts1 `n_cuts'

	foreach v of local ys {
		local ++i
		qui tab `v' if `touse', matrow(`mm')
		local n_cuts = `r(r)'
		local cuts `cuts' `r(r)'
		local off = `off' + `n_cuts'*2
		forvalues j=1/`n_cuts' {
			local m = `j'-1
			local z = el(`mm',`j',1)
			__isInteger `z' `v'
			local ilist_fv `ilist_fv' `z'.`v'
			
			if "`a`m''" != "" local aa `a`m''
			else local aa (`m'*L1_`ix')
			
			if "`b`m''" != "" local bb `b`m''
			else local bb (`m'*b`i'_`ix')
			
			if "`t`m''" != "" local tt `t`m''
			else local tt t`tix'_`m'		

			local eq (`idd'`z'.`v' <- `latent'@`aa' _one@`tt' _cons@`bb' , mlogit)
			local eqs `eqs' `eq'
			
			if `j'>1 {
				foreach g of local gg {
					local _from `_from' `z'.`v':`g'.`group'#`latent'=`=`j'-1'
				}
			}
		}
	}

	sreturn local onecns `one_cns'
	sreturn local onesym `a_symb'
	sreturn local gg `g1' `gg'
	sreturn local ginv `ginv'
	sreturn local eq `eqs'
	sreturn local cns_usr `cns'
	sreturn local off `off'
	sreturn local n_cuts `cuts'
	sreturn local _from `_from'
	sreturn local ilist_fv `ilist_fv'
	foreach g in `s(gg)' {
		sreturn local m`g'_ilist_fv `ilist_fv'
	}
	sreturn local modelname "Rating scale"
end

program __check01, sclass
	syntax varlist, touse(varname) model(string)
	foreach v of varlist `varlist' {
		capture assert missing(`v') | inlist(`v',0,1) if `touse'
                if _rc {
di as err "variable {bf:`v'} has invalid values;"
di as err "{bf:irt `model'} requires item variables be coded 0, 1, or missing"
exit 198
                }
                local ilist_fv `ilist_fv' 0.`v' 1.`v'
	}
	sreturn local ilist_fv `ilist_fv'
end

program __isInteger
	args k item group
	capture confirm integer number `k'
	local rc = _rc
	if !`rc' & `k'<0 {
		local rc = 459
	}
	if `rc' {
		if "`group'" == "group" {
			di as err "invalid {bf:group()} option;"
			local itmvar variable
		}
		else {
			local itmvar item
		}
		di as err "`itmvar' {bf:`item'} must contain only nonnegative integers"
		exit 459
	}
end

exit

