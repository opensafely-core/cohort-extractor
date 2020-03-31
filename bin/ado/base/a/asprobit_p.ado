*! version 4.0.4  15oct2019
program define asprobit_p, sortpreserve
	version 13

	// Note: -cmmprobit_p- and -cmroprobit_p- already checked e(cmd).

	if (   "`e(cmd)'" != "asmprobit"      ///
	     & "`e(cmd)'" != "asroprobit"     ///
	     & "`e(cmd)'" != "cmmprobit"      ///
	     & "`e(cmd)'" != "cmroprobit" ) { 

di as err "{p}{helpb asmprobit##|_new:asmprobit} or " ///
	  "{helpb asroprobit##|_new:asroprobit} "     ///
	  "estimation results not found{p_end}"

		exit 301
	}
	
	syntax anything(name=vlist id="varlist") [if] [in] [iw] [, SCores ///
		Pr pr1 xb stdp altwise force outcome(passthru)            ///
		j1(passthru) j2(passthru) altidx(passthru)                ///
		dydx(passthru) dyex(passthru) eydx(passthru) eyex(passthru) ]

	/* undocumented: 
	 *  force - ignore alternative labels in variable e(altvar) 
	 * 	    and relabel values using e(alt_i), i=1,...,e(k_alt) 
	 *  pr1      - synonymous to pr for asmprobit
	 *  iweight  - margins only
	 *  outcome  - margins only
	 *  j1       - margins only
	 *  j2       - margins only
	 *  altidx   - margins only
	 *  dydx     - margins only
	 *  dyex     - margins only
	 *  eydx     - margins only
	 *  eyex     - margins only					*/

	local opt `pr' `pr1' `xb' `stdp' `scores'

	local nopt : word count `opt'
	if `nopt' > 1 {

di as err "{p}only one prediction type allowed; see "                        ///
	  "{help `e(cmd)' postestimation##predict:`e(cmd)' postestimation} " ///
          "for the prediction type options{p_end}"

		exit 198
	}
	
	marksample touse, novarlist

	tempname b V
	mat `b' = e(b)

	if "`opt'" == "scores" {
		local nb = colsof(`b')

		_stubstar2names `vlist', nvars(`nb') singleok noverify

		local varlist `"`s(varlist)'"'
		local typlist `"`s(typlist)'"'

		local nsc: word count `varlist'

		if `nsc' != `nb' {
			di as err "{p}need `nb' new variable names, or " ///
			 "use the {it:stub}{bf:*} wildcard syntax{p_end}"
			exit 198
		}
	}
	else {
		if "`weight'" != "" {
			local wopt [`weight'`exp']
		}
		local 0 `vlist'
		syntax newvarlist(min=1 max=1)
		if "`opt'" == "" {
			local opt pr
			di as gr "(option {bf:pr} assumed; Pr(`e(altvar)'))"
		}

	}
	local type: word 1 of `typlist'
	if "`type'"!="double" & "`type'"!="float" {
		di as err "{p}type must be double or float; the default " ///
		 "is c(type) = `c(type)'{p_end}"
		exit 198
	}
	
	local ranked = ("`e(cmd)'"=="asroprobit" | "`e(cmd)'"=="cmroprobit")

	/* always altwise markout for xb and stdp			*/
	if ("`opt'"=="xb" | "`opt'"=="stdp") local markout altwise
	else local markout `altwise' case 

	/* scores and rank probabilities need the dependent variable	*/
	if ("`opt'"=="scores") local markout `markout' depvar
	else if (`ranked' & "`opt'"=="pr") local markout `markout' depvar
	
	/* markout singleton cases					*/
	if (bsubstr("`opt'",1,2)=="pr") local markout `markout' singleton

	tempname model
	
	if "`e(cmd)'" == "cmmprobit" {
		local modelname "asmprobit"
	}
	else if "`e(cmd)'" == "cmroprobit" {
		local modelname "asroprobit"
	}
	else {
		local modelname "`e(cmd)'"
	}

	.`model' = ._`modelname'model.new
	.`model'.eretget, touse(`touse') markout(`markout') avopts(`force')

	if "`scores'" != "" {
		.`model'.predscores `typlist' `varlist', b(`b') 
	}
	else if "`outcome'" != "" {
		/* "`c(marginscmd)'"=="on"				*/
		.`model'.margins_predict double `varlist' `wopt',    ///
			b(`b') `outcome' `j1' `j2' `altidx' `dydx' ///
			`dyex' `eydx' `eyex'
	}
	else {
		mat `V' = e(V)
		.`model'.predict `typlist' `varlist', b(`b') v(`V') opt(`opt') 
	}
end

exit
