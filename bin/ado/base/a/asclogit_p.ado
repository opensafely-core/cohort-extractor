*! version 1.2.4  15oct2019
program define asclogit_p, sortpreserve properties(notxb)
	version 10

	// e(cmd) is either -asclogit- or -cmclogit-. 
	
	// Note: -cmclogit_p- already checked e(cmd).

	if "`e(cmd)'" != "asclogit" & "`e(cmd)'" != "cmclogit" {

di as err "{helpb asclogit##|_new:asclogit} estimation results not found"
		
		exit 301
	}
	
	syntax anything(name=vlist id="varlist") [if] [in] [iw] [, SCores ///
		Pr xb stdp noOFFset altwise k(string) force 		  ///
		outcome(passthru) j1(passthru) j2(passthru) 		  ///
		altidx(passthru) dydx(passthru) dyex(passthru) 	          ///
		eydx(passthru) eyex(passthru) ]

	/* undocumented:
	 *  force - ignore alternative labels in variable e(altvar) 
	 * 	    and relabel values using e(alt_i), i=1,...,e(k_alt) 
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
	local wopt [`weight'`exp']	// margins
	
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
		local 0 `vlist'
		syntax newvarlist(min=1 max=1)
		if "`opt'" == "" {
			local opt pr
			di as gr "(option {bf:pr} assumed; Pr(`e(altvar)'))"
		}
		if "`opt'" != "pr" & "`k'"!="" {
			di as err "{p}option {bf:k()} may only be used " ///
			 "with option {bf:pr}{p_end}"
			exit 184
		}
	}
	local type: word 1 of `typlist'
	if "`type'"!="double" & "`type'"!="float" {
		di as err "{p}type must be {bf:double} or {bf:float}; the " ///
		 "default is c(type) = {bf:`c(type)'}{p_end}"
		exit 198
	}
	/* always altwise markout for xb and stdp			*/
	if ("`opt'"=="xb" | "`opt'"=="stdp") local markout altwise
	else local markout `altwise' case 

	/* scores and rank probabilities need the dependent variable	*/
	if ("`opt'"=="scores") local markout `markout' depvar
	else if ("`opt'"=="pr" & "`k'"=="observed") ///
		local markout `markout' depvar
	
	if ("`offset'"=="") local markout `markout' offset

	tempname model

	.`model' = ._asclogitmodel.new
	local vv = cond("`e(opt)'"=="ml", "10.1", "11")
	version `vv': ///
	.`model'.eretget, touse(`touse') markout(`markout') avopts(`force')

	if "`scores'" != "" {
		.`model'.predscores `typlist' `varlist', b(`b') 
	}
	else if "`outcome'" != "" {
		.`model'.margins_predict double `varlist' `wopt', b(`b') ///
			`outcome' `j1'`j2' `altidx' `dydx'`dyex' `eydx'  ///
			`eyex'
	}
	else {
		mat `V' = e(V)
		.`model'.predict `typlist' `varlist', b(`b') v(`V') ///
			opt(`opt') `offset' k(`k') 
	}
end

exit
