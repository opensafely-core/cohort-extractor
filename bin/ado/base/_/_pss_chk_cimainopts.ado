*! version 1.0.2  05feb2020
program _pss_chk_cimainopts
	version 16

	args msolvefor mlevel malpha mwidth mhwidth mprobwidth ///
        mN mN1 mN2 mnratio ///
	mk mm mk1 mk2 mkratio mm1 mm2 mmratio mrho mcvcluster ///
	mside rest mnumopts colon 0
	syntax [, method(string) *]

	local clustopt k(string) m(string) CLUSTER rho(string) ///
			CVCLuster(string)

	syntax [, pssobj(string) 		///
		  Alpha(string) 		///
		  Level(string) 		///
		  Width(string)			///
		  hwidth(string)		///
		  PROBWidth(string)		///
		  NOPROBWIDTH1			///	//undoc.
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
		  KNOWNSD KNOWNSDs NORMAL	///
		  * 				///
		]

	
	local hasprobw 1

	if (inlist("`method'", "oneprop", "twoprop", "onecorr")) {
   		if ("`noprobwidth1'"=="") {
			local pss_cmd ciwidth
		if ("`method'" == "oneprop") local mthd oneproportion
		else if ("`method'" == "twoprop") local mthd twoproportions
		else if ("`method'" == "onecorr") local mthd onecorrelation

                di as err `"{bf:`pss_cmd'}: invalid method {bf:`mthd'}"'
                di as err "{p 4 4 2}The {bf:`mthd'} method is not one of the"
                di as err "officially supported {bf:`pss_cmd'}"
                di as err "{help `pss_cmd'##method:methods}.{p_end}"
         	       exit 198
		}
		else local hasprobw 0
        }

	if (inlist("`method'","onemean","pairedm") & "`knownsds'"!="") {
		di as err "option {bf:knownsds} not allowed"
		exit 198
	}
	else if ("`method'"=="twomeans" & "`knownsd'"!="") {
		local knownsd
		local knownsds knownsds
	}
	local is_knownsd = ("`knownsd'`knownsds'`normal'"!="")
	local knownsdopt "`knownsd'`knownsds'`normal'"
	opts_exclusive "`knownsd' `normal'"
	opts_exclusive "`knownsds' `normal'"

        local crd cluster randomized designs
	if ("`k'`m'`cluster'`cvcluster'`rho'"!="" | ///
		"`k1'`k2'`kratio'`m1'`m2'`mratio'"!="") {
		di as err "options for `crd' are currently not allowed with " ///
			"{bf:ciwidth}"
		exit 198	
	}	 


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
				di as err "{p}may not specify both options " ///
					"{bf:n()} and {bf:m()}{p_end}"
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
			di as err "option {bf:n()} may not be combined with " ///
			 "option {bf:compute(`compute')}"
			exit 198
		}
	
		foreach x in n k m {
		if (`"`compute_u'"'=="`x'1" | `"`compute_u'"'=="`x'2" ) {
			if (`"``x'ratio'"'!="") {
			di as err "option {bf:`x'ratio()} may not be " ///
				"combined with option {bf:compute(`compute')}"  
				exit 198
			}
			
			if (`"``x'1'"'!="" & `"``x'2'"'!="") {
				di as err "option {bf:compute(`compute')} " ///
		"may not be combined with options {bf:`x'1()} and {bf:`x'2()}"
				exit 198
			}
		}	
		}	
		
		if (`"`compute_u'"'=="n1" | `"`compute_u'"'=="n2" ) {
			if (`"`m1'`m2'`mratio'"'!="") {
				di as err "option {bf:compute(`compute')} " ///
	"may not be combined with option {bf:m1()}, {bf:m2()}, or {bf:mratio()}"
				exit 198
			}
		}
	
		if (`"`compute_u'"'=="m1" | `"`compute_u'"'=="m2" ) {
			if (`"`n1'`n2'`nratio'"'!="") {
				di as err "option {bf:compute(`compute')} " /// 
	"may not be combined with option {bf:n1()}, {bf:n2()}, or {bf:nratio()}"
				exit 198
			}
		}
		
		if (`"`compute_u'"'=="n1") {
			if (`"`n1'"'!="") {
				di as err "{p}option {bf:n1()} may not be " ///
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
				di as err "option {bf:n2()} may not be " ///
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
				di as err "{p}option {bf:k1()} may not be " ///
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
				di as err "option {bf:k2()} may not be " ///
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
				di as err "{p}option {bf:m1()} may not be " ///
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
				di as err "option {bf:m2()} may not be " ///
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
		else {
			local solvefor width
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
	else if (`hasprobw'==0) {
		if (`"`n'`n1'`n2'`npg'"'=="") {
			local solvefor n
		}
		else if (`"`width'`hwidth'"'!="") {
			di as err "option {bf:width()} not allowed when " ///
				"computing CI width" 
			exit 198
		}
		else {
			local solvefor width
		}
	}	
	else if (`hasprobw'==1) {
		if (`"`n'`n1'`n2'`npg'"'=="") {
			local solvefor n
		}
		else if (`"`width'`hwidth'"'=="") {
			local solvefor width
		}
		else {
			if (`"`probwidth'"'!="") {
				if (`"`n'"'!="") {
di as err "{p}you may not combine all three options " ///
"{bf:n()}, {bf:width()}, and {bf:probwidth()}{p_end}"				
				exit 198
				}
				else if (`"`n1'`n2'"'!="") {
				di as err "{p}you may not combine options " ///
"{bf:n1()}, {bf:n2()}, {bf:width()}, and {bf:probwidth()}{p_end}"	
				exit 198
				}
				else if (`"`npg'"'!="") {
				di as err "{p}you may not combine options " ///
"{bf:width()} and {bf:probwidth()} with sample-size specifications{p_end}"	
				exit 198
				}
			}
			local solvefor probwidth
		}
	}
	
	if (`"`pssobj'"'!="") {
		mata: `pssobj'.st_setalpha()
	}
	c_local `msolvefor' `solvefor'

	if (`"`probwidth'"'!="" & "`noprobwidth1'"!="") {
		di as err ///
	"only one of {bf:probwidth()} and {bf:noprobwidth} is allowed"
		exit 198
	}

	if ("`solvefor'"=="n") {
		if inlist("`method'","onemean","twomeans","pairedm") {
			if (`is_knownsd') {
				local extratxt ///
				" for the normal-based CI"
			}
			else {
				local extratxt ///
				" for the default Student's t-based CI"
			}
			if (`is_knownsd' & `"`probwidth'"'!="" & ///
			    `"`width'`hwidth'"'!="") {
di as err "options {bf:probwidth()} and {bf:`knownsdopt'} may not be combined"
di as err "{p 4 4 2}Probability of CI width is not relevant"
di as err "for the normal-based CI, which is computed when you specify"
di as err "option {bf:`knownsdopt'}.{p_end}"
exit 184
			}

		}
		if ((`is_knownsd' | "`noprobwidth1'"!="" | "`user'"!="") & ///
		     `"`width'`hwidth'"'=="") {
			di as err "{p}option {bf:width()} is required " ///
				"to compute sample size`extratxt'{p_end}" 
			exit 198
		}
		else if (!`is_knownsd' & "`noprobwidth1'"=="" & "`user'"=="" ///
			 & (`"`width'`hwidth'"'=="" | `"`probwidth'"'=="")) {
			di as err "{p}both options {bf:width()} and "
			di as err "{bf:probwidth()} are required to "
			di as err "compute sample size`extratxt'{p_end}"
			exit 198
		}
	}
	if ("`onesided'`lower'`upper'"!="" & `"`hwidth'"'!="") {
		di as err "option {bf:hwidth()} " ///
			"is allowed for two-sided computation only" 
		exit 198
	}
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

	if (`"`width'"'!="" & `"`hwidth'"'!="") {
		di as err "{p}options {bf:width()} and {bf:hwidth()} may " ///
			"not be specified together{p_end}"
		exit 198	
	}
	
	// alpha(), level()
	if (`"`alpha'`level'"'=="") {
		local level = c(level)
		c_local `mlevel' `level'
		local numopts `numopts' level
	}
	else if (`"`alpha'"'!="" & `"`level'"'!="") {
		di as err "{p}options {bf:alpha()} and {bf:level()} may not " ///
			"be specified together{p_end}"
		exit 198
	}
	else if (`"`alpha'"'!="") {
		_pss_chk01opts alpha : "alpha" `"`alpha'"'
		c_local `malpha' `alpha'
		local numopts `numopts' alpha
	}
	else if (`"`level'"'!="") {
		//_pss_chk01opts level: "level" `"`level'"'
		cap numlist `"`level'"', range(>=10 <=99.99001)
		if (_rc) {
			di as err "{p}{bf:level()} must be between 10 and " ///
				"99.99 inclusive{p_end}"
			exit 198
		}
		c_local `mlevel' `r(numlist)'
		local numopts `numopts' level
	}
	if (`"`probwidth'"'!="") {
		_pss_chk01opts probwidth : "probwidth" `"`probwidth'"'
		c_local `mprobwidth' `probwidth'
		local numopts `numopts' probwidth
	}
	
	if (`"`width'"'!="") {
		_pss_chkg0opts width : "width" `"`width'"'
		c_local `mwidth' `width'
		local numopts `numopts' width
	}
	
	if (`"`hwidth'"'!="") {
		_pss_chkg0eqopts hwidth : "hwidth" `"`hwidth'"'
		c_local `mhwidth' `hwidth'
		local numopts `numopts' hwidth
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

	// onesided() and onesided
	opts_exclusive "`lower' `upper'"
	opts_exclusive "`lower' `onesided'"
        opts_exclusive "`upper' `onesided'"


	if ("`lower'"!="") {
		local onesided1 lower
		local onesided onesided
	}
	else if ("`upper'"!="") {
		local onesided1 upper
		local onesided onesided

	}
	if (`"`onesided1'"'=="") {
		mata:`pssobj'.getsdefdir("defdir")
		if (`defdir'==1) {
			local onesided1 "upper"
		}	
		else if (`defdir'==0 ) {
			local onesided1 "lower"
		}
	}	

	c_local `mside' `onesided'
  	
	// numlist options
	c_local `mnumopts' `numopts'

        if ("`solvefor'"=="probwidth" | `"`probwidth'"'!="") {
                local hasprobw 1
        }
        else {
                local hasprobw 0
        }

	if (`"`direction'"'!="") {
di as err "option {bf:direction()} is not allowed with {bf:ciwidth}"
di as err "{p 4 4 2}You can specify option {bf:upper} to request an " ///
"upper one-sided CI or option {bf:lower} to request a lower one-sided CI."
		exit 198
	}
	
	// set main options
	if (`"`pssobj'"'!="") {
		mata: `pssobj'.setmainopts("ci", "`solvefor'",	///
					   "`onesided'",	///
					   "`onesided1'",	///
					   "`summary'",		///
					   "`notitle'",		///
					   "`nfractional'",	///
					   "`graph'",		///
					   `hasprobw', 		///
		`is_cls', "`cvcluster'", `"`m'"'`twosampopts')
	}
end

program usererr1
	args user caller

	if ("`user'"=="") exit

	if ("`caller'"!="") {
		if (`caller'>=15) {
di as err "{p 4 4 2}To allow this option with user-defined ciwidth methods, "
di as err "you must set {bf:s(pss_samples)} to {bf:twosample} "
di as err "in the initializer.{p_end}"
		}
		else {
di as err "{p 4 4 2}To allow this option with user-defined ciwidth methods, "
di as err "you must specify {bf:twosample} with {bf:ciwidth}.{p_end}"
		}
	}
	else {
di as err "{p 4 4 2}To allow this option with user-defined ciwidth methods, "
di as err "you must specify {bf:twosample} with {bf:ciwidth}.{p_end}"
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
"option {bf:`optname'()} must contain numbers in (0, 1)"
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
"option {bf:`optname'()} must contain numbers in [0, 1]"
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

program _pss_chk_onesided1
	args onesided1 colon 0

	cap syntax [, Upper Lower ]
	local rc = _rc
	if (!`rc') {
		cap opts_exclusive "`upper' `lower'"
		local rc = _rc
	}
	if (`rc') {
		di as err "{p}option {bf:onesided()} may include only one of "
		di as err "{bf:upper} or {bf:lower}{p_end}"
		exit `rc'
	}
	c_local `onesided1' "`upper'`lower'"
end
