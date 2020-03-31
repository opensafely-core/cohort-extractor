*! version 10.1.1  29apr2019
program define nlogit_p, sortpreserve
	version 16
	
	if "`e(cmd)'" != "nlogit" {
		di as error "{p}{help nlogit##|_new:nlogit} estimation " ///
		 "results not found{p_end}"
		exit 301
	}
	
	local caller = _caller()
	
	if (`caller' < 16) {
		local optaltwise altwise
	}
	else {
		local optsingletons SINGLEtons
	}
	
	local nlev = e(levels)

	syntax anything(name=vlist id="varlist") [if] [in]    ///
		[,					      ///
		   Pr     				      ///
		   xb     				      ///
		   condp  				      ///
		   iv 					      ///   
		   SCores 				      ///
		   `optaltwise' 			      ///
		   force 				      /// undocumented
		   `optsingletons'			      /// undocumented
		   hlevel(numlist max=1 integer >=1 <=`nlev') /// 
		]

	// Undocumented option -force-:
	//
	//	Ignore alternative labels in variable e(altvar) 
	// 	and relabel values using e(alt_i): i = 1, ..., e(k_alt) 
	//
	// Undocumented option -singletons- (version 16):
	//
	//	Do not markout singletons.

	local opt `pr' `xb' `condp' `iv' `scores'

	local nopt : list sizeof opt
	
	if (`nopt' > 1) {
		di as err "{p}only one prediction type allowed; see"
		di as err "{help nlogit postestimation##predict:nlogit postestimation}"
 		di as err "for the prediction type options{p_end}"
		exit 198
	}
	
	if (`nopt' == 0) {
		local opt pr
		local default 1
	}
	else {
		local default 0
	}

	tempname b
	
	mat `b' = e(b)

	if ("`opt'" == "scores") {
		
		if ("`hlevel'" != "") {
			di as err "{p}{bf:hlevel()} cannot be specified with" 
			di as err "the option {bf:scores}{p_end}"
			exit 184
		}

		local nv = colsof(`b')
		local hlevel 0
	}
	else {
		local i1 1
		
		if ("`opt'" == "iv") {
			
			if (`nlev' == 1) {
				di as err "{p}model has only one level;"    
				di as err "there are no inclusive values{p_end}"
				exit 322
			}
			
			local i1 2	
		}
		
		if ("`hlevel'" != "") {
			local nv 1
		}
		else {
			local nv `nlev'
			local hlevel 0
		}
	}
	
	local star = (strpos(`"`vlist'"', "*") == strlen(`"`vlist'"'))
	
	_stubstar2names `vlist', nvars(`nv') noverify

	local varlist `"`s(varlist)'"'
	local typlist `"`s(typlist)'"'
	local type : word 1 of `typlist'
	
	if ("`type'" != "double" & "`type'" != "float") {
		di as err "type must be {bf:float} or {bf:double}"
		exit 198
	}
	
	if ("`opt'" == "iv" & `hlevel' == 0) {
		
		if (`star') { // iv* starts with iv2
			
			local v1 : word 1 of `varlist' 
			local varlist : list varlist - v1
		}
		
		local nv = `nv' - 1
	}

	local nvl : word count `varlist'
	
	if (`default' & `hlevel' == 0 & `nvl' == 1) {
		
		// Providing one new variable using default pr implies
		// base level.
		
		local hlevel `nlev'
		local nv 1
	}
	
	if (`nvl' != `nv') {
		di as err "{p}`nv' new variable"
		di as err plural(`nv', "name")
		di as err "required{p_end}"
		
		if (`nv' > 1) {
		         di as err "{p 4 4 2}The wildcard syntax"
		         di as err "{it:stub}{bf:*} can be used to specify"
		         di as err "multiple variable names.{p_end}"
		}
		
		exit 198
	}
	
	if (`default') {
	
		if (`hlevel' > 0) {
			
			if (`hlevel' == `nlev') {
				di as txt "(option {bf:pr} assumed; " ///
				 "Pr(`e(altvar)'))"
			}
			else {
				di as txt "(option {bf:pr} assumed; " ///
				 "Pr(`e(altvar`hlevel')'))" 
			}
		}
		else {
			di as txt "(option {bf:pr} assumed)" 
		}
	}
	
	// Set markout type.
	
	if (`caller' < 16) {
	
		// Always altwise markout for xb.
	
		if ("`opt'" == "xb") {
			local markout altwise
		}
		else {
			local markout `altwise' case 
		}
		
		// Always markout singletons for pr.
	
		if ("`opt'" == "pr") {
			local markout `markout' singleton
		}
	}
	else {
		if ("`e(marktype)'" == "altwise") {
			local markout altwise
			local altwise altwise
		}
		else {
			local markout case
		}
		
		// Always markout singletons for pr.
		// Markout singletons for other predictions unless
		// option singleton specified.
		
		if ("`opt'" == "pr" | "`singletons'" == "") {
			local markout `markout' singleton
		}
	}
	
	// scores need the dependent variable.
	
	if ("`opt'" == "scores") {
		local markout `markout' depvar
	}
	
	marksample touse, novarlist

	tempname model

	.`model' = ._nlogitmodel.new
	
	.`model'.eretget, touse(`touse') markout(`markout') ///
		avopts(`force' `altwise')

	if ("`scores'" != "") {
		.`model'.predscores `typlist' `varlist', b(`b') 
	}
	else {
		.`model'.predict `typlist' `varlist', b(`b') opt(`opt') ///
			level(`hlevel') 
	}
end 

