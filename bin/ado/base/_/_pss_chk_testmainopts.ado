*! version 1.3.0  12feb2019
program _pss_chk_testmainopts
	version 13

	args msolvefor mpower mbeta malpha mN mN1 mN2 mnratio ///
	mk mm mk1 mk2 mkratio mm1 mm2 mmratio mrho mcvcluster ///
	mside mdirection rest mnumopts colon 0
	syntax [, method(string) *]
// here and the -method()- option is used to handle the m() option with 
// -power mcc-, which is not for cluster size 	
	if ("`method'"!="mcc") {
		local clustopt k(string) m(string) CLUSTER rho(string) ///
			CVCLuster(string)
	}
	syntax [, pssobj(string) 		///
		  Alpha(string) 		///
		  Power(string) 		///
		  Beta(string) 			///
		  n(string)			///
		  ONESIDed 			///
		  DIRection(string)		///
		  lower				///
		  upper				///
		  NOTItle			///
		  compute(string)		/// //two-sample options
		  n1(string)			///
		  n2(string)			/// 
		  NRATio(string)		///
		  NFRACtional 			///
		  `clustopt'			///
		  k1(string)			///
		  k2(string)			///
		  KRATio(string)		///
		  m1(string)			///
		  m2(string)			///
		  MRATio(string)		///
		  graph				/// //internal
		  method(string)		///
		  * 				///
		]

	if ("`pssobj'"!="") {
		mata: st_local("twosample", strofreal(`pssobj'.twosample))
		mata: st_local("multisample",strofreal(`pssobj'.multisample))
		if (`twosample') {
			local twosampopts `", "`n1'", "`n2'", "`nratio'", "`k1'", "`k2'", "`kratio'", "`m1'", "`m2'", "`mratio'""'
		}
		if (`multisample') {
			local 0, `options'
			syntax, [ NPERGroup(string) NPERCell(string) ///
				NPERSTRatum(string) * ]
			local npg `npergroup'`npercell' `nperstratum'
		}
		mata: `pssobj'.getusertype("user")
	}
	else {
		local twosample 0
		local multisample 0
	}
	local crd cluster randomized design
	if (!inlist("`method'", "onemean", "twomeans", ///
		"oneprop", "twoprop", "logrank")) {
		foreach x in k k1 k2 m1 m2 kratio mratio {
			if (`"``x''"'!="") {
				di as err "option {bf:`x'()} not allowed"
				exit 198
			}
		}		
		if ("`m'"!="" & "`method'"!="mcc") {
			di as err "option {bf:m()} not allowed"
			exit 198
		}
		if ("`cluster'"!="") {
			di as err "option {bf:`cluster')} not allowed"
			exit 198
		}
	}	
	if (`"`m'`k'`k1'`k2'`m1'`m2'`cluster'"'!="") {
		local is_cls 1
		c_local `mrho' `rho'
		c_local `mcvcluster' `cvcluster'
	}
	else {
		if (`"`rho'"'!="") {
			di as err "option {bf:rho()} is only allowed for `crd'"
			exit 198
		}
		if (`"`cvcluster'"'!="") {
			di as err "option {bf:cvcluster()} is only allowed " ///
				"for `crd'"
			exit 198
		}
		local is_cls 0
		c_local `mrho' ""
		c_local `mcvcluster' ""
	}
	if (!`twosample') {
		if (`"`pssobj'"'!="") {
			mata: st_local("caller",strofreal(`pssobj'.caller))
		}
		if (`"`compute'"'!="") {
			di as err "option {bf:compute()} not allowed"
			usererr1 "`user'" "`caller'"
			exit 198
		}
		c_local `mN1' ""
		c_local `mN2' ""
		c_local `mk1' ""
		c_local `mk2' ""
		c_local `mm1' ""
		c_local `mm2' ""
		c_local `mnratio' ""
		c_local `mkratio' ""
		c_local `mmratio' ""
		if (!`multisample') {
			if (`"`n1'"'!="") {
				di as err "option {bf:n1()} not allowed"
				usererr1 "`user'" "`caller'"
				exit 198
			}
			if (`"`n2'"'!="") {
				di as err "option {bf:n2()} not allowed"
				usererr1 "`user'" "`caller'"
				exit 198
			}
			if (`"`nratio'"'!="") {
				di as err "option {bf:nratio()} not allowed"
				usererr1 "`user'" "`caller'"
				exit 198
			}
			if (`"`k1'"'!="") {
				di as err "option {bf:k1()} not allowed"
				exit 198
			}
			if (`"`k2'"'!="") {
				di as err "option {bf:k2()} not allowed"
				exit 198
			}
			if (`"`kratio'"'!="") {
				di as err "option {bf:kratio()} not allowed"
				exit 198
			}
			if (`"`m1'"'!="") {
				di as err "option {bf:m1()} not allowed"
				exit 198
			}
			if (`"`m2'"'!="") {
				di as err "option {bf:m2()} not allowed"
				exit 198
			}
			if (`"`mratio'"'!="") {
				di as err "option {bf:mratio()} not allowed"
				exit 198
			}
			if (`"`n'"'!="" & `"`m'"'!="") {
				di as err "{p}may not specify both option " ///
					"{bf:n()} and option {bf:m()}{p_end}"
				exit 198
			}
		}
	}
	// m() and k() not allowed by -twomeans, cluster-
	else if (`"`m'`k'`k1'`k2'`m1'`m2'`cluster'"'!="") {
		if (`"`m'"'!="") {
			di as err "option {bf:m()} not allowed for " ///
				"two-sample test"
				exit 198
		}
		c_local `mm' ""
		if (`"`k'"'!="") {
			di as err "option {bf:k()} not allowed for " ///
				"two-sample test"
				exit 198
		}
		c_local `mk' ""
			// can't specify both n# and m#	
		if ((`"`n'`n1'`n2'`nratio'"'!="") & ///
			(`"`m1'`m2'`mratio'"'!="")) {
			di as err "{p}may not specify option {bf:n1()}" ///
		", {bf:n2()}, or {bf:nratio()} with option {bf:m1()}," ///
			" {bf:m2()}, or {bf:mratio()}{p_end}"
			exit 198
		}
	}
	// kratio mratio not allowed for non-cluster design
	else {
		if (`"`kratio'"'!="") {
			di as err "option {bf:kratio()} allowed only for `crd'"
			exit 198
		}
		if (`"`mratio'"'!="") {
			di as err "option {bf:mratio()} allowed only for `crd'"
			exit 198
		}
	}
	
	// other options
	c_local `rest' `options'

	// determine what to compute,  two-sample case only
	if (`"`compute'"'!="") { 
		local compute_u = strlower("`compute'")
		if (`"`n'"'!="" & ///
	 inlist(`"`compute_u'"',"k1", "k2", "m1", "m2", "n1", "n2")) {
			di as err "option {bf:n()} cannot be combined with " ///
			 "option {bf:compute(`compute')}"
			exit 198
		}
	
		foreach x in n k m {
		if (`"`compute_u'"'=="`x'1" | `"`compute_u'"'=="`x'2" ) {
			if (`"``x'ratio'"'!="") {
			di as err "option {bf:`x'ratio()} cannot be " ///
				"combined with option {bf:compute(`compute')}"  
				exit 198
			}
			
			if (`"``x'1'"'!="" & `"``x'2'"'!="") {
				di as err "option {bf:compute(`compute')} " ///
		"cannot be combined with options {bf:`x'1()} and {bf:`x'2()}"
				exit 198
			}
		}	
		}	
		
		if (`"`compute_u'"'=="n1" | `"`compute_u'"'=="n2" ) {
			if (`"`m1'`m2'`mratio'"'!="") {
				di as err "option {bf:compute(`compute')} " ///
	"cannot be combined with option {bf:m1()}, {bf:m2()}, or {bf:mratio()}"
				exit 198
			}
		}
	
		if (`"`compute_u'"'=="m1" | `"`compute_u'"'=="m2" ) {
			if (`"`n1'`n2'`nratio'"'!="") {
				di as err "option {bf:compute(`compute')} " /// 
	"cannot be combined with option {bf:n1()}, {bf:n2()}, or {bf:nratio()}"
				exit 198
			}
		}
		
		if (`"`compute_u'"'=="n1") {
			if (`"`n1'"'!="") {
				di as err "{p}option {bf:n1()} cannot be " ///
			"combined with option {bf:compute(`compute')}{p_end}"
				exit 198
			}
			if (`"`n2'"'=="") {
				di as err "you must also specify option " ///
				"{bf:n2()} with option {bf:compute(`compute')}"
				exit 198
			}
			local solvefor n1
		}
		else if (`"`compute_u'"'=="n2") {
			if (`"`n2'"'!="") {
				di as err "option {bf:n2()} cannot be " ///
			"combined with option {bf:compute(`compute')}"
				exit 198
			}
			if (`"`n1'"'=="") {
				di as err "you must also specify option " ///
				"{bf:n1()} with option {bf:compute(`compute')}"
				exit 198
			}
			local solvefor n2
		}
		else if (`"`compute_u'"'=="k1") {
			if (`"`k1'"'!="") {
				di as err "{p}option {bf:k1()} cannot be " ///
			"combined with option {bf:compute(`compute')}{p_end}"
				exit 198
			}
			if (`"`k2'"'=="") {
				di as err "you must also specify option " ///
				"{bf:k2()} with option {bf:compute(`compute')}"
				exit 198
			}
			local solvefor k1
		}
		else if (`"`compute_u'"'=="k2") {
			if (`"`k2'"'!="") {
				di as err "option {bf:k2()} cannot be " ///
				"combined option with {bf:compute(`compute')}"
				exit 198
			}
			if (`"`k1'"'=="") {
				di as err "you must also specify option " ///
				"{bf:k1()} with option {bf:compute(`compute')}"
				exit 198
			}
			local solvefor k2
		}
		else if (`"`compute_u'"'=="m1") {
			if (`"`m1'"'!="") {
				di as err "{p}option {bf:m1()} cannot be " ///
			"combined with option {bf:compute(`compute')}{p_end}"
				exit 198
			}
			if (`"`m2'"'=="") {
				di as err "you must also specify option " ///
				"{bf:m2()} with option {bf:compute(`compute')}"
				exit 198
			}
			local solvefor m1
		}
		else if (`"`compute_u'"'=="m2") {
			if (`"`m2'"'!="") {
				di as err "option {bf:m2()} cannot be " ///
			"combined with option {bf:compute(`compute')}"
				exit 198
			}
			if (`"`m1'"'=="") {
				di as err "you must also specify option " ///
				"{bf:m1()} with option {bf:compute(`compute')}"
				exit 198
			}
			local solvefor m2
		}
		else {
			di as err "option {bf:compute()}: invalid " ///
				`"specification `compute'"'
			exit 198
		}
	}
	
	// for now, only consider one sample and two sample for cluster design
	else if (`is_cls') {
		if (`"`k'`k1'`k2'"'=="") {
			local solvefor k
		}
		else if (`"`m'`m1'`m2'`n'`n1'`n2'"'=="") {
			local solvefor m
			if (`"`nratio'"'!="") {
				di as err "option {bf:nratio()} is not " ///
				"allowed when computing cluster size" 
				exit 198
			}
		}
		else if (`"`power'`beta'"'=="") {
			local solvefor power
		}
		else {
			local solvefor esize
		}
		if (`"`mratio'"'!="" & `"`n1'`n2'`n'`nratio'"'!="") {
			di as err "option {bf:mratio()} is not allowed " ///
"in a combination with option {bf:n()}, {bf:n1()}, {bf:n2()}, or {bf:nratio()}" 
			exit 198
		}	
		else if (`"`nratio'"'!="" & `"`m1'`m2'`mratio'"'!="") {
			di as err "option {bf:nratio()} is not allowed "///
	"in a combination with option {bf:m1()}, {bf:m2()}, or {bf:mratio()}" 
			exit 198
		}	
	}		
	
	// if not cluster design and not specify compute()
	else if (`"`n'`n1'`n2'`npg'"'=="") {
		local solvefor n
	}
	else if (`"`power'`beta'"'=="") {
		local solvefor power
	}
	else if (`"`n'`n1'`n2'`npg'"'!="" & `"`power'`beta'"'!="") {
		local solvefor esize
	}
	if (`"`pssobj'"'!="") {
		mata: `pssobj'.st_setbeta()
	}
	c_local `msolvefor' `solvefor'

		
	if (("`solvefor'" == "k" | "`solvefor'" == "k1" | ///
	"`solvefor'" == "k2") & `"`n1'`n2'`n'`m1'`m2'`m'"'=="" & `is_cls') {
			if (`twosample' ) {
				di as err "{p}options {bf:m1()} and " ///
		"{bf:m2()} or options {bf:n1()} and {bf:n2()} are " ///
			"required to compute the number of clusters{p_end}"
			}
			else {
				di as err "{p}option {bf:m()} or {bf:n()} " ///
			"is required to compute the number of clusters{p_end}"
			}
			exit 198
	}
	if (`"`solvefor'"'!="esize" & "`lower'`upper'"!="") {
		di as err "Options {bf:upper} and " ///
		"{bf:lower} not allowed with {bf:power}"
di as err "{p 4 4 2}Options {bf:upper} and {bf:lower} " ///
"are not relevant to {helpb power}.  When you specify option {bf:onesided}" ///
"  to request a one-sided test with {bf:power}, the command determines the" ///
" direction of the hypothesis automatically based on the specified null " ///
" alternative values.{p_end}"
		exit 198
	}

	// alpha()
	_pss_chk01opts alpha : "alpha" `"`alpha'"'
	if ("`alpha'"=="") {
		local alpha 0.05
	}
	c_local `malpha' `alpha'
	local numopts alpha

	// power(), beta()
	if (`"`power'`beta'"'=="" & "`solvefor'"!="power") {
		local power 0.8
		c_local `mpower' `power'
	}
	else if (`"`power'"'!="" & `"`beta'"'!="") {
		di as err "{p}options {bf:power()} and {bf:beta()} may not " ///
			"be specified together{p_end}"
		exit 198
	}
	else if (`"`beta'"'!="") {
		_pss_chk01opts beta : "beta" `"`beta'"'
		c_local `mbeta' `beta'
		local numopts `numopts' beta
	}
	else if ("`solvefor'"!="power") {
		_pss_chk01opts power : "power" `"`power'"'
		c_local `mpower' `power'
	}
	if ("`solvefor'"!="power" & "`power'"!="") {
		local numopts `numopts' power
	}

	/* multisample has more than 2 levels				*/
	if (!`multisample') {
		// n(), n1(), n2(), nratio()	
		if (`"`n'"'!="" & `"`n1'"'!="" & `"`n2'"'!="") {
			di as err ///
"{p}options {bf:n()}, {bf:n1()}, and {bf:n2()} may not be " ///
		"specified together{p_end}"
			exit 198
		}
		if (`"`nratio'"'!="" & `"`n1'"'!="" & `"`n2'"'!="") {
			di as err ///
"{p}options {bf:nratio()}, {bf:n1()}, and {bf:n2()} may not be " ///
		"specified together{p_end}"
			exit 198
		}
		if (`"`kratio'"'!="" & `"`k1'"'!="" & `"`k2'"'!="") {
			di as err ///
"{p}options {bf:kratio()}, {bf:k1()}, and {bf:k2()} may not be " ///
		"specified together{p_end}"
			exit 198
		}
		if (`"`mratio'"'!="" & `"`m1'"'!="" & `"`m2'"'!="") {
			di as err ///
"{p}options {bf:mratio()}, {bf:m1()}, and {bf:m2()} may not be " ///
		"specified together{p_end}"
			exit 198
		}
		if (`"`n'"'!="" & `"`n1'"'!="" & `"`nratio'"'!="") {
			di as err ///
"{p}options {bf:n()}, {bf:n1()}, and {bf:nratio()} may not be " ///
		"specified together{p_end}"
			exit 198
		}
		if (`"`n'"'!="" & `"`n2'"'!="" & `"`nratio'"'!="") {
			di as err ///
"{p}options {bf:n()}, {bf:n2()}, and {bf:nratio()} may not be " ///
		"specified together{p_end}"
			exit 198
		}
	}
	_pss_chkposintopts n : "n" `"`n'"'
	c_local `mN' `n'
	local kn = 0
	local kn1 = 0
	local kn2 = 0
	if ("`n'"!="") {
		local nlist `n'
		local kn : list sizeof nlist
		local numopts `numopts' n
	}	
	// crd
	if ("`k'"!="") {
		_pss_chkposintopts k : "k" `"`k'"'
		local numopts `numopts' k
		c_local `mk' `k'
	}
	if ("`k1'"!="") {
		_pss_chkposintopts k1 : "k1" `"`k1'"'
		local numopts `numopts' k1
		c_local `mk1' `k1'
	}
	if ("`k2'"!="") {
		_pss_chkposintopts k2 : "k2" `"`k2'"'
		local numopts `numopts' k2
		c_local `mk2' `k2'
	}
	// crd specific options rho() and cvcluster()
	if (`"`rho'"'!="") {
		_pss_chk01eqopts rho : "rho" `"`rho'"'
		local numopts `numopts' rho
		c_local `mrho' `rho'
	}
	if (`"`cvcluster'"'!="") {
		_pss_chkg0eqopts cvcluster : "cvcluster" `"`cvcluster'"'
		 local numopts `numopts' cvcluster
		 c_local `mcvcluster' `cvcluster'
	}
	if (`"`m'"'!="") {
		_pss_chkg0opts m : "m" `"`m'"'
		 local numopts `numopts' m
		 c_local `mm' `m'
	}	
	if (`"`m1'"'!="") {
		_pss_chkg0opts m1 : "m1" `"`m1'"'
		 local numopts `numopts' m1
		 c_local `mm1' `m1'
	}		
	if (`"`m2'"'!="") {
		_pss_chkg0opts m2 : "m2" `"`m2'"'
		 local numopts `numopts' m2
		 c_local `mm2' `m2'
	}
	if (`"`n1'"'!="") {
		_pss_chkposintopts n1 : "n1" `"`n1'"'
		local n1list `n1'
		local kn1 : list sizeof n1list
		local numopts `numopts' n1
		c_local `mN1' `n1'
	}
	if (`"`n2'"'!="") {
		_pss_chkposintopts n2 : "n2" `"`n2'"'
		local n2list `n2'
		local kn2 : list sizeof n2list
		local numopts `numopts' n2
		c_local `mN2' `n2'
	}
	if `kn' == 1 {
		if `kn1' == 1 {
			if `n1list' >= `nlist' {
				di as err "{p}{bf:n1(`n1list')} must be " ///
				 "less than {bf:n(`nlist')}{p_end}"
				exit 198
			}
		}
		else if `kn1' > 1 {
			cap numlist "`n1list'", range(>0 <`nlist')
			local rc = c(rc)
			if `rc' {
				di as err "{p}values of {bf:n1()} must " ///
				 "be less than {bf:n(`nlist')}{p_end}"
				exit `rc'
			}
		}
		if `kn2' == 1 {
			if `n2list' >= `nlist' {
				di as err "{p}{bf:n2(`n2list')} must be " ///
				 "less than {bf:n(`nlist')}{p_end}"
				exit 198
			}
		}
		else if `kn2' > 1 {
			cap numlist "`n2list'", range(>0 <`nlist')
			local rc = c(rc)
			if `rc' {
				di as err "{p}values of {bf:n2()} must " ///
				 "be less than {bf:n(`nlist')}{p_end}"
				exit `rc'
			}
		}
	}
	if (!`multisample' & `"`nratio'"'!="") {	
		_pss_chkg0opts nratio : "nratio" `"`nratio'"'
		local numopts `numopts' nratio
		c_local `mnratio' `nratio'
	}
	if (!`multisample' & `"`kratio'"'!="") {	
		_pss_chkg0opts kratio : "kratio" `"`kratio'"'
		local numopts `numopts' kratio
		c_local `mkratio' `kratio'
	}
	if (!`multisample' & `"`mratio'"'!="") {	
		_pss_chkg0opts mratio : "mratio" `"`mratio'"'
		local numopts `numopts' mratio
		c_local `mmratio' `mratio'
	}
	
	// nfractional add crd case
	if (!`twosample' & !`multisample') {
		if ("`nfractional'"!="" & ((!`is_cls' & "`solvefor'"!="n") | ///
			(`is_cls' & "`solvefor'"!="m" & "`solvefor'"!="k"))) {
			di as err "{p}option {bf:nfractional} is allowed "
			di as err "only with sample-size determination for "
			di as err "one-sample and paired tests{p_end}"
			exit 198
		}
	}

	// onesided
	c_local `mside' `onesided'

	// direction()
	if ("`solvefor'"=="esize") {
		if (`"`direction'"'=="") {
			mata:`pssobj'.getsdefdir("defdir")
			if (`defdir'==1) {
				c_local `mdirection' "upper"
				local direction "upper"
			}	
			else if (`defdir'==0 ) {
				c_local `mdirection' "lower"
				local direction "lower"
			}	
		}
		else {
			_pss_chk_direction direction : `", `direction'"'
			c_local `mdirection' "`direction'"
		}
	}
	else if (`"`direction'"'!="") {
		di as err "{p}option {bf:direction()} is allowed only " ///
			  "for effect-size determination{p_end}"
		exit 198
	}
	
	// numlist options
	c_local `mnumopts' `numopts'

	// set main options
	if (`"`pssobj'"'!="") {
		mata: `pssobj'.setmainopts("test", "`solvefor'",	///
					   "`onesided'",	///
					   "`direction'",	///
					   "`summary'",		///
					   "`notitle'",		///
					   "`nfractional'",	///
					   "`graph'",		///
				`is_cls', "`cvcluster'", `"`m'"'`twosampopts')
	}
end

program usererr1
	args user caller

	if ("`user'"=="") exit

	if ("`caller'"!="") {
		if (`caller'>=15) {
di as err "{p 4 4 2}To allow this option with user-defined power methods, "
di as err "you must set {bf:s(pss_samples)} to {bf:twosample} "
di as err "in the initializer.{p_end}"
		}
		else {
di as err "{p 4 4 2}To allow this option with user-defined power methods, "
di as err "you must specify {bf:twosample} with {bf:power}.{p_end}"
		}
	}
	else {
di as err "{p 4 4 2}To allow this option with user-defined power methods, "
di as err "you must specify {bf:twosample} with {bf:power}.{p_end}"
	}
end

program _pss_chk01opts
	args vals colon optname optvals

	if (`"`optvals'"'=="") exit

	cap numlist `"`optvals'"', range(>0 <1)
	if (_rc==123) {
		cap noi numlist `"`optvals'"', range(>0)
		di as err "in option {bf:`optname'()}"
		exit 123
	}
	if (_rc) {
		di as err ///
"option {bf:`optname'()} must contain numbers between 0 and 1"
		exit 121
	}
	c_local `vals' `r(numlist)'
end

program _pss_chk01eqopts
	args vals colon optname optvals

	if (`"`optvals'"'=="") exit

	cap numlist `"`optvals'"', range(>=0 <=1)
	if (_rc) {
		di as err ///
"option {bf:`optname'()} must contain numbers between 0 and 1"
		exit 121
	}
	c_local `vals' `r(numlist)'
end

program _pss_chkposintopts
	args vals colon optname optvals

	if (`"`optvals'"'=="") exit

	cap numlist `"`optvals'"', range(>0) integer
	if (_rc==123) {
		cap noi numlist `"`optvals'"', range(>0)
		di as err "in option {bf:`optname'()}"
		exit 123
	}
	if (_rc) {
		di as err ///
"option {bf:`optname'()} must contain positive integers"
		exit 121
	}
	c_local `vals' `r(numlist)'
end

program _pss_chkg0opts
	args vals colon optname optvals

	if (`"`optvals'"'=="") exit

	cap numlist `"`optvals'"', range(>0)
	if (_rc==123) {
		cap noi numlist `"`optvals'"', range(>0)
		di as err "in option {bf:`optname'()}"
		exit 123
	}
	if (_rc) {
		di as err ///
"option {bf:`optname'()} must contain positive numbers "
		exit 121
	}
	c_local `vals' `r(numlist)'
end

program _pss_chkg0eqopts
	args vals colon optname optvals

	if (`"`optvals'"'=="") exit

	cap numlist `"`optvals'"', range(>=0)
	if (_rc) {
		di as err ///
"option {bf:`optname'()} must contain nonnegative numbers "
		exit 121
	}
	c_local `vals' `r(numlist)'
end

program _pss_chk_direction
	args direction colon 0

	cap syntax [, Upper Lower ]
	local rc = _rc
	if (!`rc') {
		cap opts_exclusive "`upper' `lower'"
		local rc = _rc
	}
	if (`rc') {
		di as err "{p}option {bf:direction()} may include only one of "
		di as err "{bf:upper} or {bf:lower}{p_end}"
		exit `rc'
	}
	c_local `direction' "`upper'`lower'"
end
