*! version 1.4.28  20sep2019
program define db, rclass
	version 10.0
	return add
	/* ------------------------------------------------------- parse */
	if "`c(console)'" != "" {
		error 8005
	}

	gettoken first : 0, parse(" ,")
	if "`first'"=="" | "`first'"=="," {
		di as err "{p 0 4 2}"
		di as err "invalid syntax{break}"
		di as err "db must be followed by a Stata command name."
		di as err "For instance, you might type:"
		di as err "{p_end}"
		di as err _col(8) ". db use"
		di as err _col(8) ". db regress"
		di as err "{p 4 4 2}"
		di as err "Alternatively, use one of the following Stata menus."
		di as err "File, Statistics, Data management, or Graphics."
		di as err "{p_end}"
		exit 198
	}
		
	syntax anything(name=dbname id="command name") [, 	///
				DEBUG DRYRUN 			///
				MESSAGE(string asis) 		///
				NAME(string asis)]  // undocumented
	
	if `"`name'"' != "" {
		local name __NAME(`name')
	}
	
	local svyIndex = strpos(`"`dbname'"', "svy:")
	local dbname : subinstr local dbname "svy:" ""

	if "`dbname'" == "sem" | "`dbname'" == "gsem" {
		syntax anything(name=dbname id="command name") [, NOOPT]
		sembuilder
		exit
	}

	local n : word count `dbname' 
	local dbname = subinstr("`dbname'", ":", "",1)
	forvalues i = 1/`n' {
		local token : word `i' of `dbname'
		if `i' >= 2  {
			local temp "`temp'_"
		}
		local temp "`temp'`token'"
	}
	local dbname "`temp'"
	
	if `"`message'"' != "" {
		local message __MESSAGE(`message')
	}
	else if `svyIndex' != 0 {
		local message __MESSAGE(-svy-)
		local name __NAME(svy_`dbname')
	}

	/* ---------------------------------------------------- preprocess */

	LocalMap dbname isspecial mymsg : `dbname' `svyIndex'
	if "`mymsg'" != "" {
		local message "`mymsg'"
	}

	if !`isspecial' {
		capture which `dbname'.dlg
		if _rc & "`dbname'" != "predict" & "`dbname'" != "estat" {
			capture which `dbname'_dlg.sthlp
			local mycrc = _rc
			if `mycrc' {
				capture which `dbname'_dlg.hlp
				local mycrc = _rc
			}
			if `mycrc' {
				myunabcmd `dbname'
//				capture unabcmd `dbname'
				if $unabcmd_rc ==0 {
//					local dbname "`r(cmd)'"
					local dbname "$unabcmd"
					local iscmd 1
				}
				else {
					local oldname "`dbname'"
					LocalUnabbreviate dbname : `dbname'
					capture myunabcmd `dbname'
//					capture unabcmd `dbname'
					local iscmd = ($unabcmd_rc==0)
				}
				global unabcmd ""
				global unabcmd_rc ""
			}
		}
	}

	/* --------------------------------------------- determine action */

						// case 0:  special
	if `isspecial' {
		if "`dryrun'"=="" {
			`dbname'
		}
		else {
			di as txt `"-> `dbname'"'
		}
		exit
	}
						// case 1:  it's a .dlg 
	capture which `dbname'.dlg
	if _rc ==0 | "`dbname'" == "predict" | "`dbname'" == "estat" { 
		if "`dryrun'"=="" {
			// _dialog create `dbname', `debug'
			// _dialog run `dbname'_dlg
			_dialog show `dbname', `debug' `message' `name'
		}
		else {
			// di as txt "-> _dialog create `dbname'"
			// di as txt "-> _dialog run `dbname'_dlg"
			di as txt "-> _dialog show `dbname'"
		}
		exit
	}

						// case 2:  it's a _dlg.sthlp 
	capture FindHelpFile hname : `dbname'_dlg
	if _rc==0 { 
		if "`dryrun'"=="" {
			view help `hname'##|_new
			exit
		}
		di as txt "-> help `hname'##|_new"
		exit
	}

	/* -------------------------- not found; determine extended action */

	if "`dryrun'" != "" {
		di as err "neither `dbname'.dlg nor `dbname'_dlg.sthlp found"
		exit 111
	}

						// case 3:  .sthlp file exists
	capture FindHelpFile hname : `dbname'
	if _rc==0 {
		window stopbox rusure ///
		"Dialog for `dbname' not found:" ///
		"Either `dbname' is a programming command or a community-contributed" ///
		"command for which no dialog box has been written." ///
		"Would you like to see the help for `dbname'?"
		view help `hname'
		exit
	}

						// case 4:  not found
	if `iscmd'==0 {
						// case 4.1 & not command 
		di as err "{p 0 4 2}"
		di as err "`dbname' is not a command name"
		di as err  "or an abbreviation of a command name"
		di as err "{p_end}"
		exit 199
	}

						// case 4.2 & is command 
	di as err "{p 0 4 2}"
	di as err "dialog for `dbname' not found{break}"
	di as err "`dbname' is either a programming command or"
	di as err "a community-contributed command for which there is no dialog."
	di as err "No one has written a help file for it, either."
	di as err "{p_end}"
	exit 111
end

program FindHelpFile
	args d colon name

	capture which `name'.sthlp
	local mycrc = _rc
	if `mycrc' {
		capture which `name'.hlp
		local mycrc = _rc
	}
	if `mycrc'==0 {
		c_local `d' "`name'"
		exit
	}
	capture _findhlpalias `name'
	if _rc==0 {
		local alias "`r(name)'"
		capture which `alias'.sthlp
		local mycrc = _rc
		if `mycrc' {
			capture which `alias'.hlp
			local mycrc = _rc
		}
		if `mycrc'==0 {
			c_local `d' "`alias'"
			exit
		}
	}
	exit 111
end

program LocalUnabbreviate 
	args d colon cmd

	c_local `d' "`cmd'"
	local l = length("`cmd'")

	if "`cmd'" == bsubstr("graph", 1, max(`l',2)) {
		c_local `d' "graph"
		exit
	}
end

program LocalMap
	args d sp mm colon cmd svyIndex

	c_local `sp' 0

	if "`cmd'" == "avplots" {
		local cmd "avplot"
	}
	else if "`cmd'" == "an" | "`cmd'" == "ano" | "`cmd'" == "anov" {
		local cmd "anova"
	}
	else if "`cmd'" == "ap" | "`cmd'" == "app" 			///
		| "`cmd'" == "appe" | "`cmd'" == "appen" {
		local cmd "append"
	}
	else if "`cmd'" == "bayes_prefix" {
			local cmd "bayes"
	}
	else if "`cmd'" == "biprobit" {
		if `svyIndex' != 0 {
			local cmd "svy_biprobit"
		}
	}
	else if "`cmd'" == "clo" | "`cmd'" == "clog" | "`cmd'" == "clogi" {
		local cmd "clogit"
	}
	else if "`cmd'" == "cnr" | "`cmd'" == "cnre" {
		local cmd "cnreg"
	}
	else if "`cmd'" == "constraint_define" {
		local cmd "cons_define"
	}
	else if "`cmd'" == "constraint_drop" {
		local cmd "cons_drop"
	}
	else if "`cmd'" == "d" | "`cmd'" == "de" | "`cmd'" == "des" 	///
		| "`cmd'" == "desc" | "`cmd'" == "descr" 		///
		| "`cmd'" == "descri" | "`cmd'" == "describ"		///
	{
		local cmd "describe"
	}
	else if "`cmd'" == "discrim_knn" | "`cmd'" == "discrim_lda"	///
		| "`cmd'" == "discrim_logistic" | "`cmd'" == "discrim_qda" {
		local cmd "discrim"
	}
	else if "`cmd'" == "est" {
		local cmd "estimates"
	}
	else if "`cmd'" == "esti" {
		local cmd "estimates"
	}
	else if "`cmd'" == "fac" | "`cmd'" == "fact" | "`cmd'" == "facto" {
		local cmd "factor"
	}
	else if "`cmd'" == "fmm_betareg" {
		local cmd "fmm"
		c_local `mm' "__MESSAGE(-betareg-)"
		c_local name __NAME(fmm_betareg)
	}
	else if "`cmd'" == "fmm_cloglog" {
		local cmd "fmm"
		c_local `mm' "__MESSAGE(-cloglog-)"
		c_local name __NAME(fmm_cloglog)
	}
	else if "`cmd'" == "fmm_glm" {
		local cmd "fmm"
		c_local `mm' "__MESSAGE(-glm-)"
		c_local name __NAME(fmm_glm)
	}
	else if "`cmd'" == "fmm_intreg" {
		local cmd "fmm"
		c_local `mm' "__MESSAGE(-intreg-)"
		c_local name __NAME(fmm_intreg)
	}
	else if "`cmd'" == "fmm_ivregress" {
		local cmd "fmm"
		c_local `mm' "__MESSAGE(-ivregress-)"
		c_local name __NAME(fmm_ivregress)
	}
	else if "`cmd'" == "fmm_logit" {
		local cmd "fmm"
		c_local `mm' "__MESSAGE(-logit-)"
		c_local name __NAME(fmm_logit)
	}
	else if "`cmd'" == "fmm_mlogit" {
		local cmd "fmm"
		c_local `mm' "__MESSAGE(-mlogit-)"
		c_local name __NAME(fmm_mlogit)
	}
	else if "`cmd'" == "fmm_nbreg" {
		local cmd "fmm"
		c_local `mm' "__MESSAGE(-nbreg-)"
		c_local name __NAME(fmm_nbreg)
	}
	else if "`cmd'" == "fmm_ologit" {
		local cmd "fmm"
		c_local `mm' "__MESSAGE(-ologit-)"
		c_local name __NAME(fmm_ologit)
	}
	else if "`cmd'" == "fmm_oprobit" {
		local cmd "fmm"
		c_local `mm' "__MESSAGE(-oprobit-)"
		c_local name __NAME(fmm_oprobit)
	}
	else if "`cmd'" == "fmm_pointmass" {
		local cmd "fmm"
		c_local `mm' "__MESSAGE(-pointmass-)"
		c_local name __NAME(fmm_pointmass)
	}
	else if "`cmd'" == "fmm_poisson" {
		local cmd "fmm"
		c_local `mm' "__MESSAGE(-poisson-)"
		c_local name __NAME(fmm_poisson)
	}
	else if "`cmd'" == "fmm_probit" {
		local cmd "fmm"
		c_local `mm' "__MESSAGE(-probit-)"
		c_local name __NAME(fmm_probit)
	}
	else if "`cmd'" == "fmm_regress" {
		local cmd "fmm"
		c_local `mm' "__MESSAGE(-regress-)"
		c_local name __NAME(fmm_regress)
	}
	else if "`cmd'" == "fmm_streg" {
		local cmd "fmm"
		c_local `mm' "__MESSAGE(-streg-)"
		c_local name __NAME(fmm_streg)
	}
	else if "`cmd'" == "fmm_tobit" {
		local cmd "fmm"
		c_local `mm' "__MESSAGE(-tobit-)"
		c_local name __NAME(fmm_tobit)
	}
	else if "`cmd'" == "fmm_tpoisson" {
		local cmd "fmm"
		c_local `mm' "__MESSAGE(-tpoisson-)"
		c_local name __NAME(fmm_tpoisson)
	}
	else if "`cmd'" == "fmm_truncreg" {
		local cmd "fmm"
		c_local `mm' "__MESSAGE(-truncreg-)"
		c_local name __NAME(fmm_truncreg)
	}
	else if "`cmd'" == "gr" {
		local cmd "graph"
	}
	else if "`cmd'" == "gsort" {
		local cmd "sort"
		c_local `mm' "__MESSAGE(-gsort-)"
	}
	else if "`cmd'" == "bar" {
		local cmd "graph_bar"
	}
	else if "`cmd'" == "dot" {
		local cmd "graph_dot"
	}
	else if "`cmd'" == "graph_dot_data" {
		local cmd "dot_data"
	}
	else if "`cmd'" == "pie" {
		local cmd "graph_pie"
	}
	else if "`cmd'" == "box" {
		local cmd "graph_box"
	}
	else if "`cmd'" == "graph_twoway" {
		local cmd "twoway"
	}
	else if "`cmd'" == "heckman" {
		if `svyIndex' != 0 {
			local cmd "heckman_ml"
		}
	}
	else if "`cmd'" == "hist" {
		local cmd histogram
	}
	else if "`cmd'" == "hotel" {
		local cmd "hotelling"
	}
	else if "`cmd'" == "icd9p" {
		local cmd "icd9"
	}
	else if "`cmd'" == "irt" | "`cmd'" == "irt_1pl"			///
		| "`cmd'" == "irt_2pl" | "`cmd'" == "irt_3pl" 		///
		| "`cmd'" == "irt_grm" | "`cmd'" == "irt_nrm" 		///
		| "`cmd'" == "irt_pcm" | "`cmd'" == "irt_rsm" 		///
		| "`cmd'" == "irt_hybrid" | "`cmd'" == "difmh" 		///
		| "`cmd'" == "irtgraph_icc" | "`cmd'" == "irtgraph_iif" ///
		| "`cmd'" == "irtgraph_tcc" | "`cmd'" == "irtgraph_tif" {
		local cmd "irt"
	}
	else if "`cmd'" == "keep" {
		local cmd "drop"
	}
	else if "`cmd'" == "la" | "`cmd'" == "lab" | "`cmd'" == "labe" {
		local cmd "label"
	}	
	else if "`cmd'" == "logi" {
		local cmd "logit"
	}	
	else if "`cmd'" == "note" | "`cmd'" == "notes" {
		/* the internal notes dialog is intentionally intercepted
		   and the smcl router will be used. */
		local cmd "notes"
	}
	else if "`cmd'" == "margin" {
		local cmd "margins"
	}
	else if "`cmd'" == "mer" | "`cmd'" == "merg" {
		local cmd "merge"
	}
	else if "`cmd'" == "mlog" | "`cmd'" == "mlogi" {
		local cmd "mlogit"
	}
	else if "`cmd'" == "move" {
		local cmd "order"
	}
	else if "`cmd'" == "olo" | "`cmd'" == "olog" | "`cmd'" == "ologi" {
		local cmd "ologit"
	}
	else if "`cmd'" == "opr" | "`cmd'" == "opro" | 		///
		"`cmd'" == "oprob"  || "`cmd'" == "oprobi"  {
		local cmd "oprobit"
	}
	else if "`cmd'" == "prob" | "`cmd'" == "probi" {
		local cmd "probit"
	}	
	else if "`cmd'" == "reg" | "`cmd'" == "regr" | 		///
		"`cmd'" == "regre" | "`cmd'" == "regres"	{
		local cmd "regress"
	}
	else if "`cmd'" == "renpfix" {
		local cmd "rename"
	}
	else if "`cmd'" == "rot" | "`cmd'" == "rota" | "`cmd'" == "rotat" {
		local cmd "rotate"
	}
	else if "`cmd'" == "scree" {
		local cmd "screeplot"
	}
	else if "`cmd'" == "svydes" {
		local cmd "svydescribe"
	}
	else if "`cmd'" == "stcrr" | "`cmd'" == "stcrre" {
		local cmd "stcrreg"
	}
	else if "`cmd'" == "te" {
		local cmd "test"
	}
	else if "`cmd'" == "tes" {
		local cmd "test"
	}
	else if "`cmd'" == "tsrline" {
		local cmd "tsline"
	}	
	else if "`cmd'" == "tis" {
		local cmd "tsset"
	}
	else if "`cmd'" == "tob" | "`cmd'" == "tobi" {
		local cmd "tobit"
	}
	else if "`cmd'" == "treatreg" {
		if `svyIndex' != 0 {
			local cmd "treatreg_ml"
		}
	}
	else if "`cmd'" == "tset" {
		local cmd "tsset"
	}
	else if "`cmd'" == "tw" {
		local cmd "twoway"
	}
	else if "`cmd'" == "two" {
		local cmd "twoway"
	}
	else if "`cmd'" == "yx" {
		local cmd "twoway"
	}
	else if "`cmd'" == "scatter" {
		local cmd "twoway"
	}
	else if "`cmd'" == "line" {
		local cmd "twoway"
	}
	else if "`cmd'" == "stpow_cox" {
		local cmd "stpower_cox"
	}
	else if "`cmd'" == "stpow_exp" {
		local cmd "stpower_exponential"
	}
	else if "`cmd'" == "stpow_expon" {
		local cmd "stpower_exponential"
	}
	else if "`cmd'" == "stpow_exponential" {
		local cmd "stpower_exponential"
	}
	else if "`cmd'" == "stpower_exp" {
		local cmd "stpower_exponential"
	}
	else if "`cmd'" == "stpower_expon" {
		local cmd "stpower_exponential"
	}
	else if "`cmd'" == "stpow_log" {
		local cmd "stpower_logrank"
	}
	else if "`cmd'" == "stpow_logrank" {
		local cmd "stpower_logrank"
	}
	else if "`cmd'" == "stpower_log" {
		local cmd "stpower_logrank"
	}
	else if "`cmd'" == "power_exp" {
		local cmd "power_exponential"
	}
	else if "`cmd'" == "bayesreps" {
		local cmd "bayespredict"
		c_local `mm' "__MESSAGE(-bayesreps-)"
	}
	else if "`cmd'" == "ado" {
		local cmd "view help net_mnu"
		c_local `sp' 1
	}
	else if "`cmd'" == "browse" {
		local cmd "browse"
		c_local `sp' 1
	}
	else if "`cmd'" == "doedit" {
		local cmd "doedit"
		c_local `sp' 1
	}
	else if "`cmd'" == "edit" {
		local cmd "edit"
		c_local `sp' 1
	}
	else if "`cmd'" == "findit" {
		local cmd "view search_d"
		c_local `sp' 1
	}
	else if "`cmd'" == "help" {
		local cmd "view help help_advice"
		c_local `sp' 1
	}
	else if "`cmd'" == "net" {
		local cmd "view help net_mnu"
		c_local `sp' 1
	}
	else if "`cmd'" == "news" {
		local cmd "view news"
		c_local `sp' 1
	}
	else if "`cmd'" == "search" {
		local cmd "view search_d"
		c_local `sp' 1
	}
	else if "`cmd'" == "view" {
		local cmd "view"
		c_local `sp' 1
	}
/* route special internal dialogs which do not match a real command name */
	else if "`cmd'" == "labeldefine" {
		/* deprecated, but still works */
		local cmd "view dialog `cmd'_dlg"
		c_local `sp' 1
	}
	else if "`cmd'" == "label_manage" {
		local cmd "view dialog `cmd'_dlg"
		c_local `sp' 1
	}
	else if "`cmd'" == "import_delimited" {
		local cmd "view dialog `cmd'_dlg"
		c_local `sp' 1
	}
	else if "`cmd'" == "import_haver" {
		local cmd "view dialog `cmd'_dlg"
		c_local `sp' 1
	}
	else if "`cmd'" == "import_excel" {
		local cmd "view dialog `cmd'_dlg"
		c_local `sp' 1
	}
	else if "`cmd'" == "import_fred" {
		local cmd "view dialog `cmd'_dlg"
		c_local `sp' 1
	}
	else if "`cmd'" == "import_sas" {
		local cmd "view dialog `cmd'_dlg"
		c_local `sp' 1
	}
	else if "`cmd'" == "import_spss" {
		local cmd "view dialog `cmd'_dlg"
		c_local `sp' 1
	}
	else if "`cmd'" == "use_using" {
		local cmd "view dialog `cmd'_dlg"
		c_local `sp' 1
	}
	else if "`cmd'" == "ciwidth" {
		local cmd "view dialog `cmd'_dlg"
		c_local `sp' 1
	}
	else if "`cmd'" == "power" {
		local cmd "view dialog `cmd'_dlg"
		c_local `sp' 1
	}
	else if "`cmd'" == "pss" {
		local cmd "view dialog power_dlg"
		c_local `sp' 1
	}
	else if "`cmd'" == "power_oneproportion" {
		local cmd "power_oneprop"
	}
	else if "`cmd'" == "power_onecorrelation" {
		local cmd "power_onecorr"
	}
	else if "`cmd'" == "power_onevariance" {
		local cmd "power_onevar"
	}
	else if "`cmd'" == "power_pairedmeans" {
		local cmd "power_pairedm"
	}
	else if "`cmd'" == "power_pairedproportions" {
		local cmd "power_pairedpr"
	}
	else if "`cmd'" == "power_rsq" {
		local cmd "power_rsquared"
	}
	else if "`cmd'" == "power_twoproportions" {
		local cmd "power_twoprop"
	}
	else if "`cmd'" == "power_twocorrelations" {
		local cmd "power_twocorr"
	}
	else if "`cmd'" == "power_twovariances" {
		local cmd "power_twovar"
	}
	else if "`cmd'" == "ciwidth_onevariance" {
		local cmd "ciwidth_onevar"
	}
	else if "`cmd'" == "ciwidth_pairedmeans" {
		local cmd "ciwidth_pairedm"
	}
	else if "`cmd'" == "frame" {
		local cmd "frames"
	}
/**/
	else {
		local cpy `cmd'
		capture myunabcmd `dbname'
		global unabcmd ""
//		capture unabcmd `cpy'
		if !$unabcmd_rc {
			capture which `cpy'_dlg
			if !_rc {
				local cmd `cpy'_dlg
				c_local `sp' 1
			}
		}
		global unabcmd_rc ""
	}

	c_local `d' "`cmd'"
end

// This program is used to preserve rclass results 
program myunabcmd
	args name
	capture unabcmd `name'
	global unabcmd = "`r(cmd)'"
	global unabcmd_rc =  _rc
end
