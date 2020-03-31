*! version 1.2.0  20feb2019
program _asprobit_vce_parserun, eclass 
	version 16
	
	local vv : di "version " string(_caller()) ":"

	_on_colon_parse `0'

	local 0 `s(before)'

	syntax name(name=cmd id="program name") [, by(string) ]

	local 0 `s(after)'

	qui syntax [anything] [fw pw iw] [if] [in], CASE(varname numeric) ///
		[ 							  ///
		  Cluster(varname)				  	  ///
		  VCE(passthru)					  	  /// 
                  CM                                		  	  /// 
		  ALTernatives(passthru)	    		  	  ///
		  *						  	  ///
		]

	sreturn clear
	
	if  ("`vce'" == "") {
		exit 
	}

	if ("`cm'" != "") {
		local cmd = "cm" + substr("`cmd'", 3, .)
		local groptname tempcaseid
		
		// `alternatives' is not to be included with options.
	}
	else {
		local groptname case
		local options   `"`alternatives' `options'"'
	}

	tempname id
	
	_vce_cluster `cmd',		///
		groupvar(`case')	///
		newgroupvar(`id')	///
		groptname(`groptname')	///
		`vce'			///
		cluster(`cluster')
	
	local vce   `"`s(vce)'"'
	local idopt   `s(idopt)'
	local clopt   `s(clopt)'
	local gropt   `s(gropt)'
	local bsgropt `s(bsgropt)'
	
	if "`s(cluster)'" != "" {
		local ccheckopt clustercheck(`s(cluster)')
	}

	if ("`weight'" != "") {
		local wgt [`weight'`exp']
	}
	
	local vceopts jkopts(`clopt' notable noheader)               ///
		bootopts(`clopt' `idopt' `bsgropt' notable noheader) ///
		required(BASEalternative SCALEalternative)     

	`vv' `by' _vce_parserun `cmd', `vceopts' : ///
		`anything' `wgt' `if' `in',   ///
		`gropt' `vce' `options' `ccheckopt'
	
	if ("`s(exit)'") == "" {
		exit
	}
	
	RemoveClusterCheck `e(command)'

	if ("`cm'" != "") {
		ereturn        local caseid `case'
		ereturn hidden local case   `case'
		
		// Remove tempcaseid() option when -cm*-
		// and reset e(command).
		
		RemoveTempcaseid `e(command)' 
	}
	else {
		ereturn local case `case'

		// Remove tempvar `id' from case() option when -as*-. 
	
		local cmd1 `"`e(command)'"'

		if "`cluster'" == "" & "`cm'" == "" {
			local cmd2 : subinstr local cmd1 "`id'" "`group'"
		}
		
		local cmd2 : list retokenize cmd2

		ereturn local command  `"`cmd2'"'
	}

	ereturn local cluster `cluster'
		
	local 0 , `options'
		
	syntax [, Level(string asis) * ]
		
	if (!`:length local level') {
		local level `"`s(level)'"'
	}

	_get_diopts diopts options, `options'
	
	_asprobit_replay, level(`level') `diopts'
	
	Exit
end

program Exit, sclass
	sreturn local exit 1
end

program RemoveTempcaseid, eclass
	syntax [anything] [fw pw iw] [if] [in], tempcaseid(passthru) [ * ]
	
	local cmd1 `0'
	local cmd2 : subinstr local cmd1 "`tempcaseid'" ""
	local cmd2 : list retokenize cmd2

	ereturn local command `"`cmd2'"'	
end

program RemoveClusterCheck, eclass
	syntax [anything] [fw pw iw] [if] [in] [, clustercheck(passthru) * ]
	
	if ("`clustercheck'" != "") {
		local cmd1 `0'
		local cmd2 : subinstr local cmd1 "`clustercheck'" ""
		local cmd2 : list retokenize cmd2

		ereturn local command `"`cmd2'"'
	}	
end

