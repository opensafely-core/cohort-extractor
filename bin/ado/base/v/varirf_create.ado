*! version 1.2.7  12feb2010
program define varirf_create
	version 8.0
	syntax	anything(id="irf name")	/*
	*/	[,		/*
	*/	*		/*
	*/	]		/*
	*/

	CREATE `0'
	exit
end

program define CREATE
	syntax	anything(name=irfname id="irf name")	/*
	*/	[,					/*
	*/	Order(string)				/*
	*/	STep(integer 8)				/*
	*/	replace					/*
	*/	set(string)				/*
	*/	BS 					/* 
	*/	BSP 					/* 
	*/	BSAving(passthru)   			/* 
	*/	Reps(numlist integer max=1 >=50)	/*
	*/ 	noSE 					/*
	*/ 	noDots					/*
	*/	ESTimates(string)			/*
	*/	Level(cilevel)		 		/* 
	*/	]					/*
	*/
	
	if "`estimates'" == "" {
		local estimates .
	}

	if "`estimates'" != "." {
		capture confirm name `estimates'
		if _rc > 0 {
			di as err "estimates(`estimates') specifies "	/*
				*/ "an invalid name"
			exit 198
		}
	}	

	tempname pest
	tempvar samp

	_estimates hold `pest', copy restore nullok varname(`samp') 

	capture estimates restore `estimates'
	if _rc > 0 {
		di as err "could not restore estimates(`estimates')"
		exit _rc
	}	
	

	if "`e(cmd)'" != "var" & "`e(cmd)'" != "svar" {
	di as err "{help varirf_create##|_new:varirf create} can "	/*
		*/ "only be used after {help var##|_new:var} or "  	/*
			*/ "{help svar##|_new:svar}" 
		exit 198
	}

	if "`order'" != "" & "`e(cmd)'" == "svar" {
		di as err "order cannot be specified after svar"
		exit 198
	}	

	if "`reps'" != "" {
		local rmac "reps(`reps')"
	}
	if "`e(cmd)'" != "var" & "`e(cmd)'" != "svar" {
		di as err "varirf can only estimate VAR IRFs after var and svar"
		exit 198
	}	
	
	_ckirfset , set(`set') 

	qui tsset, noquery
	
	tempfile irfwork

	_virf_nlen `irfname'  /* note this returns length of name in r(len)
			    *  but only checking is needed so do not
			    * store length
			    */
	qui varirf des

	if "`replace'" != "" {
		capture varirf drop `irfname'
		if _rc > 0 { 
			di as txt `"irfname `irfname' not found in $S_vrffile"'
		}
	}	
	
	local cnames `r(irfnames)'
	local tmp : subinstr local cnames "`irfname'" "`irfname'", 	/*
	 	*/ word count(local found)
	if `found' > 0 {
		di as err `"irfname `irfname' is already in $S_vrffile"'
		exit 498
	}	

	preserve
	capture noi _varirf `order', saving(`irfwork', replace) step(`step') /*
		*/ irfname(`irfname') `bs' `bsp' `se' `rmac' 	/*
		*/ level(`level') `bsaving' `dots'
	local rc = _rc
	capture constraint drop $T_cns_a_n
	capture constraint drop $T_cns_b_n
	capture constraint drop $T_cns_lr_n
	macro drop T_cns_a_n
	macro drop T_cns_b_n
	macro drop T_cns_lr_n
	if `rc' != 0 {
		exit `rc'
	}

	varirf_add `irfname' , using(`irfwork') exact	
	restore	

	_estimates unhold `pest'
end 

exit

Syntax

	varirf_create <irfname> [, <create options> set(varirf_filename) ]

computes the specified irf functions (results) and saves them into the active
varirf file with the specified irfname.
	
set(varirf_filename) can be used to change the active varirf file.

