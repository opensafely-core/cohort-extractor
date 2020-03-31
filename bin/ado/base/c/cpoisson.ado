*! version 1.2.2  15jul2019
program cpoisson, eclass byable(onecall) prop(irr svyb svyj svyr)
	version 14
	if _by() {
		local BY `"by `_byvars' `_byrc0':"'
	}
	`BY' _vce_parserun cpoisson, mark(EXPosure OFFset CLuster) : `0'
	
	if "`s(exit)'" != "" {
		eret local cmdline `"cpoisson `0'"'
		exit
	}				 
	local version : di "version " string(_caller()) ":"
	if replay() {
		if ("`e(cmd)'" != "cpoisson") {
			error 301
		}
		if (_by()) {
			error 190
		}
		Display `0'
		error `e(rc)'				
		exit
	}	
	`version' `BY' Estimate `0'
	eret local cmdline `"cpoisson `0'"'
end

program Estimate, eclass byable(recall)
	syntax varlist(numeric fv ts)  [fw pw iw] [if] [in]                  ///
		[, 							     ///
			noCONstant					     ///
			LL(string) 					     ///
			UL(string)					     ///
			LL1 						     ///
			UL1						     ///
			EXPosure(varname numeric ts)  			     ///
			OFFset(varname numeric ts) 			     ///			
			CONSTraints(numlist integer >=1 <= 1999)  	     ///
			COLlinear					     ///
			vce(string)					     ///
			Level(cilevel)					     ///
			IRr						     ///
			NOLOg LOg					     ///
			TRace                                                ///
			GRADient                                             ///
			showstep                                             ///
			HESSian                                              ///
			SHOWTOLerance                                        ///
			TOLerance(real 1e-6)                                 ///
			LTOLerance(real 1e-7)                                ///
			NRTOLerance(real 1e-5)                               ///
			TECHnique(string)                                    ///
			ITERate(integer 16000)                               ///
			NONRTOLerance                                        ///
			from(string)                                         ///
			DIFficult   *					     ///			 
		]

	_get_diopts diopts, `options'
	local coll `"`collinear'"'
	marksample touse
	
	/* count obs and check for no-positive values of `y' */	
	gettoken y varlist : varlist
	_fv_check_depvar `y'
	tsunab y : `y'
	local yname : subinstr local y "." "_"
	
	qui sum `y' `wt' if `touse', meanonly	
	if (r(N) == 0)  error 2000
	if (r(N) == 1)  error 2001
	tempname mean nobs
	scalar `mean' = r(mean)
	scalar `nobs' = r(N) 		
	local   min   = r(min)	
	local 	max   = r(max)	 
	if (`min'<0) {
		di as err "{bf:`y'} must be greater than zero"
		exit 459
	}
	if (`min'==`max' & `min'==0) {
		di as err "{bf:`y'} is zero for all observations"
		exit 498
	}	


/* check syntax for offset and exposure */	
	if (`"`offset'"'!="" & `"`exposure'"'!="") {
		di as err "only one of {bf:offset()} or "                    ///
			"{bf:exposure()} can be specified"
		exit 198
	}
	
/* parse weight */
	if ("`weight'"!="") {
		if ("`weight'"=="fweight") {
			local wt `"[fw`exp']"'
			local fwt `"[fw`exp']"'
		}
		else {
			local wt `"[aw`exp']"'
		}	
	}
	gettoken eqsign wvar : exp	
	
/* check lower and upper limits */
	if "`ll'" != "" & "`ll1'" != "" {
		di as err "only one of {bf:ll} or {bf:ll()} is allowed"
		exit 198
	}
	if "`ul'" != "" & "`ul1'" != "" {
		di as err "only one of {bf:ul} or {bf:ul()} is allowed"
		exit 198
	}
	if "`ll1'" != "" | "`ul1'" != "" {
		qui sum `y' if `touse', meanonly
		if "`ll1'" != "" local ll `r(min)'
		if "`ul1'" != "" local ul `r(max)'
	}

/* lower limit ul */
	tokenize `"`ll'"', parse(" ,")
	if (`"`2'"'!="") {
		di as err "must specify only one argument in {bf:ll()}"
		exit 198
	}	

	local isllnumvar = 0
	if (`"`ll'"'!="") {
		cap confirm number `ll'
		if _rc {
			cap unab llunab: `ll', max(1)			
			if _rc {
				di as err "{bf:ll()} must specify a "        ///
					"number or a numeric variable"
				exit 198				
			}
			cap confirm numeric variable `llunab'
			if !_rc {
				markout `touse' `llunab'		
				local isllnumvar = 1		
			}
			else {
				cap confirm string variable `llunab'
				if !_rc {
					di as err "{bf:ll(`ll')} must "      ///
						"specify numeric values"
					exit 198
				}
				else{
					cap noisily
				}
			}
		}
	}
		
	local lc = "" 								
	if (`"`ll'"'!="") {
		cap confirm names `llunab'
		if _rc {
			cap confirm number `ll'
			if _rc {
				di as err "{bf:ll(`ll')} must "              ///
					"specify a nonnegative value"
				exit 198
			}
			else {
				cap confirm integer number `ll'
				if _rc {
					di as err "{bf:ll(`ll')} "           ///
						"must specify an integer"
					exit 198				
				}	
				
				if (`ll'<0) {
					di as err "{bf:ll(`ll')} "           ///
						"must specify a" 	     ///
						" nonnegative integer"
					exit 198
				}					
				local lc = `ll'
				cap noisily
			}
		}
		else {			
			if (`isllnumvar'==0) {       
				di as err "{bf:ll(`llunab')} must specify"   ///
					" a number or a numeric variable"
				exit 198
			}
			else {
				local lc `llunab'
				qui sum `lc' if `touse', meanonly
				if (r(min)<0) {
					di as err "{bf:ll(`llunab')} "       ///
						"must contain all "          ///
						"nonnegative values"
					exit 198
				}
				tempvar dfloor nonint
				qui gen double `dfloor' = `lc' - int(`lc')   ///
					if `touse'
				qui gen int `nonint'=1 if `dfloor'!=0 & `touse'
				qui sum `nonint' if `touse', meanonly
				local m = r(sum)
				if (`m'>0) {
					local s
					if (`m'>1) {
						local s s
					}
					di as err "{bf:ll(`llunab')} "       ///
						"contains `m' noninteger "   ///
						"value`s'"
					exit 198
				}
			}
		}				
	}
	local llopt `lc'
	
/* upper limit ul */
	tokenize `"`ul'"', parse(" ,")
	if (`"`2'"'!="") {
		di as err "must specify only one argument in {bf:ul()}"
		exit 198
	}		
		
	local isulnumvar = 0		
	if (`"`ul'"'!="") {	
		cap confirm number `ul'	
		if _rc {
			cap unab ulunab : `ul', max(1)
			if _rc {
				di as err "{bf:ul()} must specify a "	     ///
					"number or a numeric variable"
				exit 198
			}
			cap confirm numeric variable `ulunab'			
			if !_rc {
				markout `touse' `ulunab'		
				local isulnumvar = 1		
			}
			else {
				cap confirm string variable `ulunab'
				if !_rc {
					di as err "{bf:ul(`ul')} must "      ///
						"specify numeric values"
					exit 198
				}
				else{
					cap noisily
				}
			}
		}
	}	
		
	local rc = ""
	if (`"`ul'"'!="") {
		cap confirm names `ulunab'
		if _rc {
			cap confirm number `ul'
			if _rc {
				di as err "{bf:ul(`ul')} must "              ///
					"specify a nonnegative value"
				exit 198
			}
			else {
				cap confirm integer number `ul'
				if _rc {
					di as err "{bf:ul(`ul')} "           ///
						"must specify an integer"
					exit 198				
				}	
				if (`ul'<0) {
					di as err "{bf:ul(`ul')} "           ///
						"must specify a"	     ///
						" nonnegative integer"
					exit 198
				}					
				local rc = `ul'
				cap noisily
			}
		}
		else {
			if (`isulnumvar'==0) {                  
				di as err "{bf:ul(`ulunab')} must specify"   ///
					" a number or a numeric variable"
				exit 198
			}
			else {
				local rc `ulunab'
				qui sum `rc' if `touse', meanonly
				if (r(min)<0) {
					di as err "{bf:ul(`ulunab')} "       ///
						"must contain all "          ///
						"nonnegative values"
					exit 198
				}
				tempvar dfloor nonint
				qui gen double `dfloor' = `rc' - int(`rc')   ///
					if `touse'
				qui gen int `nonint'=1 if `dfloor'!=0 & `touse'
				qui sum `nonint' if `touse', meanonly
				local m = r(sum)
				if (`m'>0) {
					local s
					if (`m'>1) {
						local s s
					}
					di as err "{bf:ul(`ulunab')} "       ///
						"contains `m' noninteger "   ///
						"value`s'"
					exit 198
				}
			}
		}				
	}	
	local ulopt `rc'

/* process offset/exposure */
	if (`"`exposure'"'!="" & `"`offset'"'=="") {	
		cap assert `exposure' > 0 if `touse'
		if (_rc!=0) {
			di as err "{bf:exposure()} must be greater "         ///
				"than zero"
			exit 459
		}
		tempvar offset tmpexpo tmpoff
		qui gen double `tmpexpo' = `exposure'
		qui gen double `offset' = ln(`exposure')
		qui gen double `tmpoff' = ln(`tmpexpo')
		markout `touse' `tmpoff'
		local offvar `"ln(`exposure')"'
		local offopt `"offset(`tmpoff')"'
	}

	if (`"`offset'"'!="" & `"`exposure'"'=="") {
		tempvar tmpoff 
		qui gen double `tmpoff' = `offset'	
		markout `touse' `tmpoff'
		local offvar `"`offset'"'		
		local offopt `"offset(`tmpoff')"'
	}
	
/* parse vce */
	if (`"`vce'"'=="") {
		local vcet oim
		local clustvar = ""
		local vcew = 0
	}
	else {
		local vcew : word count `vce'		
		if (`vcew'>2) {	
			di as err "{p 0 4 2}{bf:vce(`vce')} invalid{p_end}"
			exit 498
		}
		else if (`vcew'==2) {			
			local vcet : word 1 of `vce'
			local clustvar : word 2 of `vce'
			if (`"`vcet'"'!= "cluster" & `"`vcet'"'!="cluste"    ///
				& `"`vcet'"'!="clust" & `"`vcet'"'!="clus"   ///	
				& `"`vcet'"'!="clu" & `"`vcet'"'!="cl") {
				di as err "{p 0 4 2}{bf:vce(`vce')}"         ///
					" invalid{p_end}"
				exit 498
			}
			else {
				local vcet cluster
			}
			cap confirm numeric variable `clustvar'
			if (_rc!=0) {
				di as err "{p 0 4 2}{bf:vce(`vce')}"         ///
					" invalid{p_end}"
				exit 498
			}
			
			local type Robust			
		}
		if ( `vcew'==1 ) {			
			if (`"`vce'"'!= "robust" & `"`vce'"'!= "robus" 	     ///
				& `"`vce'"'!= "robu" & `"`vce'"'!= "rob"     ///
				& `"`vce'"'!= "ro" & `"`vce'"'!="r"          ///
				& `"`vce'"'!="oim") {	
				di as err "{p 0 4 2}{bf:vce(`vce')}"         ///
					" invalid{p_end}"
				exit 498			
			}
			if (`"`vce'"'=="robust" | `"`vce'"'=="robus" 	     ///
				| `"`vce'"'=="robu" | `"`vce'"'=="rob" 	     ///
				| `"`vce'"'=="ro" | `"`vce'"'=="r") {				
				local vcet robust
				local clustvar = ""
				local type Robust
			}
			else {
				local vcet oim
				local clustvar = ""
			}
		}		
	}

	if (`"`clustvar'"'!="") {
		markout `touse' `clustvar', strok
		tempvar grp
		qui egen `grp' = group(`clustvar')
		qui su `grp'
		local nclust = r(max)
	}		
	else {
		local nclust = 0
	}
	if ("`weight'"=="pweight") {
		local clustvar = ""
		local vcet robust
		local type Robust
	}	

/* check `y', ll() and ul() */	
	local modelnum = ""
	local nlco = ""			//number of left-censored observations		
	local nuco = ""  		//number of uncensored observations
	local nrco = ""  		//number of right-censored observations	
	if (`"`ll'"'=="" & `"`ul'"'=="") {
		qui sum `y' `wt' if `touse', meanonly	
		local nlco = 0
		local nrco = 0
		local nuco = r(N)-`nlco'-`nrco'
		tempvar ynew
		qui gen double `ynew' = `y'		
		local modelnum = 1 			
	}
	else if (`"`ll'"'=="" & `"`ul'"'!="") {		 
		tempvar diff isrc
		qui gen double `diff' = `rc'-`y' if `touse'
		qui gen int `isrc' = (`diff'<=0) if `touse'
		qui sum `isrc' `fwt' if `touse', meanonly
		local nlco = 0
		local nrco = r(sum)
		local nuco = r(N)-`nlco'-`nrco'		
		if (`nuco'<=0) {
			di as err "no uncensored observations"
			exit 2000			
		}
		if (`nuco'==r(N)) {
			tempvar ynew
			qui gen double `ynew' = `y'		
			local modelnum = 1 	
		}
		else {
			tempvar ynew
			qui gen double `ynew' = `y'
			qui replace `ynew' = `rc' if (`touse' & `isrc'==1)
			if (`isulnumvar'==1) {
				local modelnum = 2		
			}
			else if (`isulnumvar'==0){
				local modelnum = 3	
			}
		}
		drop `diff' `isrc'		
	}
	else if (`"`ll'"'!="" & `"`ul'"'=="") {	
		tempvar diff islc
		qui gen double `diff' = `y'-`lc' if `touse'
		qui gen int `islc' = (`diff'<=0) if `touse'
		qui sum `islc' `fwt' if `touse', meanonly
		local nlco = r(sum)
		local nrco = 0
		local nuco = r(N)-`nlco'-`nrco'		
		if (`nuco'<=0) {
			di as err "no uncensored observations"
			exit 2000			
		}		
		if (`nuco'==r(N)) {
			tempvar ynew
			qui gen double `ynew' = `y'		
			local modelnum = 1 		
		}
		else {
			tempvar ynew
			qui gen double `ynew' = `y'
			qui replace `ynew' = `lc' if (`touse' & `islc'==1)
			if (`isllnumvar'==1) {
				local modelnum = 4	
			}
			else if (`isllnumvar'==0){
				local modelnum = 7
			}
		}
		drop `diff' `islc'		
	}
	else if (`"`ll'"'!="" & `"`ul'"'!="") {		
		tempvar diff1 diff2 islc isrc
		qui gen double `diff1' = `y'-`lc' if `touse'
		qui gen int `islc' = (`diff1'<=0) if `touse'
		qui sum `islc' `fwt' if `touse', meanonly
		local nlco = r(sum)
		qui gen double `diff2' = `rc'-`y' if `touse'
		qui gen int `isrc' = (`diff2'<=0) if `touse'
		qui sum `isrc' `fwt' if `touse', meanonly		
		local nrco = r(sum)		
		local nuco = r(N)-`nlco'-`nrco'		
		if (`nuco'<=0) {
			di as err "no uncensored observations"
			exit 2000			
		}		
		if (`nuco'==r(N)) {
			tempvar ynew
			qui gen double `ynew' = `y'		
			local modelnum = 1 		
		}
		else if (`nlco'==0) {	
			tempvar ynew
			qui gen double `ynew' = `y'
			qui replace `ynew' = `rc' if (`touse' & `isrc'==1)
			if (`isulnumvar'==1) {
				local modelnum = 2		
			}
			else if (`isulnumvar'==0){
				local modelnum = 3	
			}						
		}
		else if (`nrco'==0) {	
			tempvar ynew
			qui gen double `ynew' = `y'
			qui replace `ynew' = `lc' if (`touse' & `islc'==1)
			if (`isllnumvar'==1) {
				local modelnum = 4	
			}
			else if (`isllnumvar'==0){
				local modelnum = 7
			}			
		}
		else {		
			tempvar ynew
			qui gen double `ynew' = `y'
			qui replace `ynew' = `lc' if (`touse' & `islc'==1)
			qui replace `ynew' = `rc' if (`touse' & `isrc'==1)			
			if (`isllnumvar'==1 & `isulnumvar'==1) {						
				local modelnum = 5	
			}
			else if (`isllnumvar'==1 & `isulnumvar'==0) {
				local modelnum = 6	
			}
			else if (`isllnumvar'==0 & `isulnumvar'==1) {
				local modelnum = 8					
			}		
			else if (`isllnumvar'==0 & `isulnumvar'==0) {
				local modelnum = 9				
			}
		}
		tempvar diffll 
		qui gen int `diffll' = (`lc'-`rc')>0
		qui sum `diffll' if `touse', meanonly
		if (r(sum)>0) {
			di as err "{bf:ul(`ul')} "           		     ///
				"contains integers less than "	     	     ///
				"{bf:ll(`ll')} "
			exit 2000
		}			
		drop `diff1' `diff2' `islc' `isrc' `diffll'							
	}

/* check whether `ynew' is integer-valued */
	if ("`display'"=="") {
		cap assert `ynew' == int(`ynew') if `touse'
		if _rc {
			di in blu "note: you are responsible for " 	     ///
				"interpretation of noncount dependent variable"
		}
	}	
	
/* parse options for optimization */
	if  (`iterate'<0) {
		di as err "{bf:iterate()} must be a nonnegative integer"
		exit 125
	}
	if (`tolerance'<0) {
		di as err "{bf:tolerance()} should be nonnegative"
		exit 125		
	} 	
	if (`ltolerance'<0) {
		di as err "{bf:ltolerance()} should be nonnegative"
		exit 125
	} 
	if (`nrtolerance'<0) {
		di as err "{bf:nrtolerance()} should be nonnegative"
		exit 125
	}
	
	local istrace = 0
	if ("`trace'"!="") { 
		local istrace = 1 	
	}
	
	local isgrad = 0
	if ("`gradient'"!="") { 
		local isgrad = 1 	
	}	
	
	local ishess = 0
	if ("`hessian'"!="") { 
		local ishess = 1 
	}
	
	local sstep = 0
	if ("`showstep'"!="") { 
		local sstep = 1 
	}
	
	local stol "off"
	if ("`showtolerance'"!="") { 
		local stol "on"
	}
	
	local nonrtol "off"
	if ("`nonrtolerance'"!="") { 
		local nonrtol "on" 
	}
	
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"	
	local isnolog = 0
	if ("`log'"!="") {
		local isnolog = 1 
	}
	
	if (`"`technique'"'=="") {
		local tech "nr" 	
	}
	else {
		local techs nr dfp bfgs bhhh
		local check: list techs & technique

		if ("`check'"=="") {		
			local techsallowed = "nr, dfp, bfgs, or, bhhh"
			di as err "{bf:technique()} "                	     ///
				"must specify `techsallowed'"
			exit 111
		}
		else {
			local tech `technique'
		}
	}

	local diffi "m-marquardt"
	if ("`difficult'"!="") {
		local diffi "hybrid"
	}

/* fv */
	qui fvexpand `varlist' if `touse'
	local varlist = r(varlist)
	local rfvops = r(fvops)	

/* constant */
	local addcons = 1 		
	if (`"`constant'"'!=""){
		if (`"`varlist'"'==".") {
			di as err "independent variables required with "     ///
				"{bf:noconstant} option"
			exit 100
		}
		local addcons = 0
	}	
	
/* remove collinearity. */
	cap qui _rmcoll `varlist' [`weight'`exp'] if `touse', `constant' `coll'
	if _rc {
		local nomitted = 0
	}
	else {
		local nomitted = r(k_omitted)			
		local xvars = r(varlist)
		if (`nomitted'>0) {
			foreach val of local xvars {
				local oindex = bsubstr("`val'",1,2)
				local ovarn = bsubstr("`val'",3,.)
				if ("`oindex'"=="o.") {
					di as txt "note: `ovarn' omitted"  ///
						" because of collinearity"
				}
			}
		}
		qui fvexpand `xvars' if `touse'
		local xvars = r(varlist)
		local rfvops = r(fvops)	
	}

/* parse from() and check initial values */
	local nparamx: word count `xvars'	
	local totalnparam = `nparamx' + (`addcons' == 1)	
	local initparam = ""
	local isinitgiven = 0
	if (`"`from'"'!=""){
		tempname initparam
		_mkvec `initparam', from(`from') error("from()")
		local ninitparam = s(k)
		if (`ninitparam'!=`totalnparam') {
			di as err "invalid number of initial values in"      ///
				" option {bf:from()}"
			exit 121
		}	
		local isinitgiven = 1
		local init st_matrix("`initparam'")
	}
	else {	
		qui cap poisson `ynew' `xvars' [`weight'`exp'] if `touse',   ///
			`offopt' iterate(50) constraints(`constraints')
		if !_rc {
			tempname initparam initused
			mat `initparam' = e(b)
			local noconend = colsof(`initparam')-1
			if (`addcons'==1) {
				matrix `initused' = `initparam'
			}
			else {
				matrix `initused' =  		     	     ///
					`initparam'[1,1..`noconend']
			}		
			local init st_matrix("`initused'")		
		}	
	
	}
	
	if ("`initparam'"=="") {
		local init 1		
	}

/* Post the constraint matrix */
	tempname b V
	local wn : word count `xvars'
	local wn = `wn' + (`addcons'==1)
	mat `b' = J(1,`wn',0)
	mat `V' = J(`wn',`wn', 0)
	
	Stripes, xvars("`xvars'") yvar("`yname'") addcons(`addcons')
	local stripe = "`s(vars)'"
	matrix colnames `b' = `stripe'
	matrix rownames `V' = `stripe'
	matrix colnames `V' = `stripe'
	
	if ("`constraints'"=="") {
		local Cns = ""
		local C 1
		local numcns 0 
	}
	else {	
		eret post `b' `V'
		tempname Cns					
		makecns `constraints'			
		if ("`r(clist)'"=="") {
			local Cns = ""
			local C 1	
			local numcns 0 		
		}
		else {			
			cap matrix `Cns' = get(Cns)
			if _rc {
				local Cns = ""
				local C 1	
				local numcns 0			
			}	
			else {
				local C st_matrix("`Cns'") 		
				local numcns = rowsof(`Cns')
			}
		}
	}
	
	if (_rc ==1) {	
		local Cns = ""
		local C 1
		local numcns 0 	
	}
	
	di as txt ""
		
/* Get ll_0 constant-only model */
	if "`constant'`Cns'"=="" & "`cluster'"=="" & "`weight'"!="pweight" {
		tempname c
		if "`offset'"!="" {
			SolveC `y' `offset' [`weight'`exp'] if `touse',      ///
				n(`nobs') mean(`mean')
			scalar `c' = r(_cons)
			if `c'>=. {
				di in blu "note: exposure = exp(`offvar')"   ///
					  " overflows;" _n 		     ///
					  "      could not estimate" 	     ///
					  " constant-only model" _c
				if "`exposur'"=="" {
					di in blu _n 		  	     ///
					"      use exposure() option"        ///
					" for exposure = `offvar'"
				}
				display ""
			}
		}
	}
			
	tempname b0 V0 Vm0 N0 converge0 llike0 rank0 niter0 rcode0 gradient0 ///
		ilog0 
	local forcecons = 1
	local initcons = ""
	if ("`initparm'"!="") {
		if (`addcons'==1) {
			tempname initcons 
			matrix `initcons' = `initparam'[1,`totalnparam']
			local init0 st_matrix("`initcons'")
		}
	}
	else {
		local init0 1
	}
	if ("initcons"=="") {
	
		local init0 1
	}
	
	mata: _cpoiss_est( `modelnum', `iterate', `tolerance',	 	     ///
		`ltolerance', `nrtolerance', 0, 0, 0, 			     ///
		0, `"`nonrtol'"', `"`tech'"', `"`diffi'"', 		     ///
		`"`stol'"', 1, `"`ynew'"',	"", `C', 		     ///
		`"`vcet'"', `"`clustvar'"', `"`touse'"', `addcons', 	     ///
		`"`weight'"', `"`wvar'"', `init0', `"`lc'"', 		     ///
		`"`rc'"', `isllnumvar',	`isulnumvar', `"`b0'"', 	     ///
		 `"`V0'"', `"`Vm0'"', `"`N0'"', `"`converge0'"', 	     ///
		`"`llike0'"', `"`tmpoff'"', `"`tmpexpo'"', `forcecons',      ///
		`"`rank0'"', `"`niter0'"', `"`rcode0'"', `"`gradient0'"',    ///
		`"`ilog0'"', `isinitgiven', `"`yname'"')
		
	if (`llike0'>=.) {
		di in blu "note: could not compute " 			     ///
			"constant-only model log likelihood"	
	}
		
/* estimation */
	tempname b V Vm N converge llike rank niter rcode gradient ilog 
	local forcecons = 0	
	mata: _cpoiss_est( `modelnum', `iterate', `tolerance',		     ///
		`ltolerance', `nrtolerance', `sstep', `isgrad',	`ishess',    ///
		`istrace', `"`nonrtol'"', `"`tech'"', `"`diffi'"',           ///
		`"`stol'"', `isnolog', `"`ynew'"',	`"`xvars'"', `C',    ///
		`"`vcet'"', `"`clustvar'"', `"`touse'"', `addcons', 	     ///
		`"`weight'"', `"`wvar'"', `init', `"`lc'"', 		     ///
		`"`rc'"', `isllnumvar',	`isulnumvar', `"`b'"', 		     ///
		 `"`V'"', `"`Vm'"', `"`N'"', `"`converge'"', 		     ///
		`"`llike'"', `"`tmpoff'"', `"`tmpexpo'"', `forcecons',       ///
		`"`rank'"', `"`niter'"', `"`rcode'"', `"`gradient'"', 	     ///
		`"`ilog'"', `isinitgiven', `"`yname'"')

	Stripes, xvars("`xvars'") yvar("`yname'") addcons(`addcons')
	local stripe = "`s(vars)'"
	matrix colnames `b' = `stripe'
	matrix rownames `V' = `stripe'
	matrix colnames `V' = `stripe'
	matrix colnames `gradient' = `stripe'
	matrix rownames `Vm' = `stripe'
	matrix colnames `Vm' = `stripe'		
	matrix colnames `gradient' = `stripe'
	matrix rownames `Vm' = `stripe'
	matrix colnames `Vm' = `stripe'
			
	eret post `b' `V' `Cns', esample(`touse') buildfvinfo	
	eret scalar N = `N'
	eret scalar k = `totalnparam'
	eret scalar k_eq = 1
	eret scalar k_eq_model = 1
	eret scalar k_dv = 1
	eret scalar ll = `llike'
	eret scalar ll_0 = `llike0'
	eret scalar rank = `rank'
	if (`nclust'!=0) {
		eret scalar N_clust = `nclust'
	}
	if (e(rank)-e(k_eq_model)<0) {
		eret scalar df_m = 0
	}
	else {
		eret scalar df_m = e(rank)-(`addcons'==1)
	}

	if ((`"`vcet'"'=="oim" & "`constant'"=="" & `"`Cns'"'=="" 	     ///
		& e(df_m)>0) | (`nparamx'==0 & "`constant'"=="")) {
		eret scalar chi2 = 2*(e(ll)-e(ll_0))
		eret local chi2type = "LR"		
	}
	else {
		if (e(df_m)>0) {
		qui test `xvars' 
			eret scalar chi2 = r(chi2)
		}
		else {
			eret scalar chi2 = .
		}		
		eret local chi2type = "Wald"
		
	}

	eret scalar p = chi2tail(e(df_m), e(chi2))
	eret scalar ic = `niter'-1
	eret scalar converged = `converge'
	eret scalar rc = `rcode'	
	eret local depvar `"`y'"'
	eret local llopt `"`llopt'"'
	eret local ulopt `"`ulopt'"'
	if missing("`ll'") {
		ereturn hidden local limit_l "0"
	}
	else {
		ereturn hidden local limit_l `"`llopt'"'
	}
	if missing("`ul'") {
		ereturn hidden local limit_u "+inf"
	}
	else {
		ereturn hidden local limit_u `"`ulopt'"'
	}
	eret local wtype `"`weight'"'
	eret local wexp `"`exp'"'
	eret local title "Censored Poisson regression"
	eret local clustvar = `"`clustvar'"'
	eret local offset = `"`offvar'"'
	eret local vce `"`vcet'"'
	eret local vcetype `"`type'"'
	eret local opt "moptimize"
	eret local which "max"
	eret local ml_method "lf2"
	eret local user "_cpoisson_lnlike"
	eret local technique `"`tech'"'
	eret local predict "cpoisson_p"	
	
	qui fvset report, design(asbalanced)
	if ("`r(varlist)'"!="") {
		eret local asbalanced = "`r(varlist)'"
	}
	
	qui fvset report, design(asobserved)
	if ("`r(varlist)'"!="") {
		eret local asobserved = "`r(varlist)'"
	}
	
	eret matrix gradient `gradient'
	eret matrix ilog `ilog'
	if (e(vce)=="oim" | e(vce)=="") {
		ereturn hidden local crittype "log likelihood"	
	}
	else if (e(vce)=="robust" | e(vce)=="cluster") {
		ereturn hidden local crittype "log pseudolikelihood"		
		eret matrix V_modelbased `Vm'
	}
	
	eret hidden scalar level = `level'	
	eret hidden scalar emodelnum = `modelnum'
	eret hidden scalar eiterate = `iterate'
	eret hidden scalar etolerance = `tolerance'
	eret hidden scalar eltolerance = `ltolerance'
	eret hidden scalar enrtolerance = `nrtolerance'
	eret hidden local enonrtol = `"`nonrtol'"'
	eret hidden local etech = `"`tech'"'
	eret hidden local ediff = `"`diffi'"'
	eret hidden local estol = `"`stol'"'
	eret hidden local exvars = `"`xvars'"'
	if (`"`C'"'=="1") {
		eret hidden local eC = 1
	}
	else {
		eret hidden local eC = 0
	}	
	eret hidden scalar eaddcons = `addcons'
	eret hidden local ewvar = `"`wvar'"'
	eret hidden local ewt = `"`wt'"'
	if (`"`isinitgiven'"'=="1") {
		eret hidden local isinit=1
	}
	else {
		eret hidden local isinit=0
		eret hidden matrix einit `initparam'
	}
	
	eret hidden scalar eisllnumvar = `isllnumvar'
	eret hidden scalar eisulnumvar = `isulnumvar'
	eret hidden local eexposure = `"`exposure'"'
	eret local marginsnotok SCores stdp
	eret local marginsok N IR CM Pr(passthru) CPr(passthru)
	eret scalar N_lc = `nlco'	
	eret scalar N_unc = `nuco'
	eret scalar N_rc = `nrco'
	ereturn hidden scalar noconstant = cond("`constant'" == "noconstant",1,0)
	ereturn hidden scalar consonly = cond("`xvars'" != "",0,1)
	eret local cmd "cpoisson"	
	Display, level(`e(level)') `irr' `diopts'	
end

program define Display
	syntax [, IRr Level(cilevel) *]
	if "`irr'"!="" {
		local eopt "eform(IRR)"
	}
	_get_diopts diopts, `options'	
	if (`"`level'"'=="") {
		_prefix_display, level(`e(level)') `eopt' `options'
	}
	else {
		_prefix_display, level(`level') `eopt' `options'
	}
end

program define Stripes, sclass
	syntax,	[	                                             	     ///
		xvars(string)                                                ///
		yvar(string)                                                 ///
		addcons(integer 1)					     ///
		]
	
	local wi : list sizeof xvars
	local eqlatent = ""
	forvalues i=1/`wi' {
		local eqw: word `i' of `xvars'		
		local eqlatent = "`eqlatent' `yvar':`eqw'"  
	}		
	if (`addcons'==1) {
		local stripe = "`eqlatent' `yvar':_cons"
	}	
	else {
		local stripe = "`eqlatent'"
	}
	sreturn local vars = "`stripe'"
end


program SolveC, rclass 			// note: similar code is found 
					// in nbreg.ado 
	gettoken y  0 : 0
	gettoken xb 0 : 0
	syntax [fw aw pw iw] [if] , Nobs(string) Mean(string)
	if "`weight'"=="pweight" | "`weight'"=="iweight" {
		local weight "aweight"
	}
	capture confirm variable `xb'
	if _rc {
		tempvar xbnew
		qui gen double `xbnew' = (`xb') `if'
		local xb `xbnew'
	}			
	summarize `xb' [`weight'`exp'] `if', meanonly
	if (r(N) != `nobs') { 			
		exit 
	}
	if r(max) - r(min) > 2*709 { 	// unavoidable exp() over/underflow 
		exit 			// r(_cons) is missing 
	}
	if r(max) > 709 | r(min) < -709  {
		tempname shift		
		if (r(max) > 709) { 
			scalar `shift' =  709 - r(max) 		
		}
		else {
			scalar `shift' = -709 - r(min)
		}				
		local shift "+`shift'"
	}	
	tempvar expoff
	qui gen double `expoff' = exp(`xb'`shift') `if'
	summarize `expoff' [`weight'`exp'], meanonly	
	if (r(N) != `nobs') { 
		exit 
	} 				// should not happen 
	return scalar _cons = ln(`mean')-ln(r(mean))`shift'
end


