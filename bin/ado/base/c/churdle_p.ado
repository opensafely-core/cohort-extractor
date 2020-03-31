*! version 1.0.6  10feb2019
program define churdle_p
	version 14
	
	syntax [anything] [if] [in], 					     ///
			[                                                    ///
			Residuals                                            ///
			Pr(string)                                           ///
			e(string)                                            ///
			YStar(string)                                        ///
			xb                                                   ///
			stdp                                                 ///
			YSTAR1						     ///
			Equation(string)                                     ///
			SCores						     ///
			]   
	
	marksample touse
	
	tempname touse2 
	
	generate `touse2' = e(sample)*`touse'
	
	
	local bound = e(bound)
	local model = e(nmodel)
	
	if `bound'!=3 {
		if (`model' < 5){
			local numeros = 3 
		}
		else{
			local numeros = 4 
		}
	}
	else {
		if (`model'==1 | `model'==4) {
			local numeros = 3
		}
		if (`model'==5 |`model'== 8){
			local numeros = 4
		}
		if (`model'==2 | `model'==3) {
			local numeros = 4
		}
		if (`model'==6 |`model'== 7){
			local numeros = 6
		}
	}
	
	local mllim   = real("`e(llimit)'")
	local mulim   = real("`e(ulimit)'")
	local msllim  = "`e(llimit)'"
	local msulim  = "`e(ulimit)'"
	local mstrll  = 0
	local mstrul  = 0

	if (`mllim' == . & `"`msllim'"' != "") {
		local mstrll = 1
	}

	if (`mulim' == . & `"`msulim'"' != "") {
		local mstrul = 1
	}
	
	_stubstar2names `anything', nvars(`numeros') singleok
	local score = real("`s(stub)'")
	local varlist  = s(varlist)
	local typlist `s(typlist)'
	local ns: list sizeof varlist 
	
	if `"`scores'"' != "" {
		
		tempname strin1 strin2 strin3 strin4 strin5 strin6
		quietly generate double `strin1' = . if `touse2'
		quietly generate double `strin2' = . if `touse2'
		quietly generate double `strin3' = . if `touse2'
		quietly generate double `strin4' = . if `touse2'
		quietly generate double `strin5' = . if `touse2'
		quietly generate double `strin6' = . if `touse2'

	
		tempname theta thetafrom mgammalf mgammauf mgammaff ///
			mgammaf1 mgammalf1 mgammauf1 theta2 mgammaf scorepr2
			
	
		quietly generate `scorepr2' = . if `touse2'
		 
		matrix `thetafrom' = e(b)
		local xvars "`e(xvars)'"
		local sx: list sizeof xvars
		local zeta    = e(hlatent)
		local noconsm = e(noconsm)
		local csk     = e(csk)
		local cskl    = e(cskl)
		local shi     = e(shi)
		
		if (`zeta' == 0) {
			local sk    = `sx' + `zeta' + abs(`noconsm' -1) + 1 
		}
		else{
			local sk    = `sx' + `zeta' + abs(`noconsm' -1) 
		}
		
		local  colstheta = colsof(`thetafrom')

		if `bound'==1 {
			matrix `mgammaff'  = `thetafrom'[1, `sk'+1..`colstheta']
			matrix `mgammalf' = `mgammaff'	
			matrix `mgammauf' = 0
		}
		
		if `bound'==2 {
			matrix `mgammaff'  = `thetafrom'[1, `sk'+1..`colstheta']
			matrix `mgammalf' = 0	
			matrix `mgammauf' = `mgammaff'
		}
		
		if `bound'== 3 {
			matrix `mgammalf' = `thetafrom'[1, `sk'+1..`sk'+`cskl']
			matrix `mgammauf' =                                 ///
			    `thetafrom'[1, `sk'+`cskl'+1..`colstheta']		
		}

		mata: _CHURDLE_newstripes2("`theta2'", "`mgammalf1'",        ///
		    "`mgammauf1'", "`mgammaf1'", `sk', `zeta', `csk', `shi', ///
		    "`thetafrom'", `bound', `model')

		    
		matrix `theta'    = `theta2'
		matrix `mgammaf'  = `mgammaf1'
		matrix `mgammalf' = `mgammalf1'
		matrix `mgammauf' = `mgammauf1'
		
		Equacion, model(`model') bound(`bound') equation(`equation')
		local equacion = e(equacion)
		local labs = e(labeler)
		local glab = e(glabeler)

		if ("`e(weight)'"!="" ) {
			capture summarize `e(pesos)', meanonly 
			local rc = _rc 
			if (`rc') {
				local pesos2 "`e(wvar)'"
			}
			else if (`r(N)'==0 & `r(sum)'==0) {
				local pesos2 "`e(wvar)'"	
			}
			else {
				local pesos2 "`e(pesos)'"
			}
		}
		qui mata: _CHURDLE_Scores(`model', "`theta'", "`mgammalf'",  ///
			"`mgammauf'", "`e(depvar)'", "`e(xvars)'",           ///
			"`e(scols)'", "`e(zvars)'", "`touse2'", `e(noconsm)', ///
			`e(sconsm)', "`e(shetvars)'", `bound',               ///
			"`e(ulimit)'", "`e(llimit)'", `mstrll', `mstrul',    ///
			"`scorepr2'", "`strin1'", "`strin2'", "`strin3'",    ///
			"`strin4'", "`strin5'", "`strin6'", `e(consmod)',    ///
			"`pesos2'", "`e(weight)'", `equacion', 	     ///
			"")
		
		if `score'>0 { 
			forvalues i = 1(1)`ns' {
				local name`i' = word("`varlist'",`i')
				local b`i'    = word("`glab'", `i')
				quietly generate `typlist' `name`i'' ///
					= `strin`i'' if `touse'
				label var `name`i''                          ///
				"equation-level score for [`b`i''] from churdle"
			}
		}
		else {
			quietly generate `typlist' `varlist' =  ///
				`scorepr2' if `touse'
			label var `varlist' ///
				"equation-level score for [`labs'] from churdle"
		}
		
	}
	
	tempname yhatp prp ep xbp ystarp stdpp xbeq


	local bound     = e(bound)
	local hlatent   = e(hlatent)>0
	local estimator = e(estimator)

	// Parsing upper and lower bounds 

	local linfty  = 0 
	local uinfty  = 0 
	local epbound = 0 

	if "`pr'" !="" {
		local parast = "pr"
		gettoken plim pr: pr, parse(",")
		local pfirst `plim'
		gettoken plim2 pr: pr, parse(",")
		local psecond `pr'
		local llim  = real("`pfirst'")
		local ulim  = real("`psecond'")
		local sllim = "`pfirst'"
		local sulim = "`psecond'"
		local strll = 0
		local strul = 0	
		
		if ("`e(model)'"=="Exponential") {
			local psecond = .
		}
		
		if ("`pfirst'"== ".") {
			local linfty = 1
		}
		
		if ("`psecond'"==".") {
			local uinfty = 1
		}
		
		if (`llim' == . & `"`sllim'"' != "" & `linfty'==0) {
			capture fvexpand `sllim' if `touse'
			local rc = _rc
			
			if `rc' {
				display as error "when specifying {bf:ll()}"
				fvexpand `sllim' if `touse'
			}
			
			local strll = 1
		}

		if (`ulim' == . & `"`sulim'"' != "" & `uinfty'==0) {
			capture fvexpand `sulim' if `touse'
			local rc = _rc
			
			if `rc' {
				display as error "when specifying {bf:ul()}"
				fvexpand `sulim' if `touse'
			}
			
			local strul = 1
		}
		
		if ("`pfirst'" != "" & `uinfty'== 1 ) {
			local epbound = 1
		
			if (`llim' == . & `strll' == 0 & `linfty'==0) {
				display as error "invalid {bf:ll()}"
				exit 198
			}
		}
		
		if (`linfty' == 1 & "`psecond'" != "") {
			local epbound = 2
		
		if (`ulim' == . & `strul' == 0 & `uinfty'==0) {
				display as error "invalid {bf:ul()}"
				exit 198
			}
		}
		
		if ("`pfirst'" != "" & "`psecond'" != "" & `uinfty'==0 &     ///
		    `linfty'==0) {
			local epbound = 3
			
			if (`ulim' == . & `strul'==0 & `uinfty'==0) {
				display as error "invalid {bf:ul()}"
				exit 198
			}
			
			if (`llim' == . & `strll' == 0 & `linfty'==0) {
				display as error "invalid {bf:ll()}"
				exit 198
			}
			
			if ((`llim' >= `ulim') & `strul'==0 & `strll'==0 &   ///
			    (`linfty'==0 & `uinfty'==0)) {
				display as error "{bf:ll()} greater than "   ///
				    "{bf:ul()}"
				exit 198
			}
		}
	}

	if "`e'" !="" {
		local ehat = "e"
		gettoken elim e: e, parse(",")
		local efirst `elim'
		gettoken elim2 e: e, parse(",")
		local esecond `e'
		local llim  = real("`efirst'")
		local ulim  = real("`esecond'")
		local sllim = "`efirst'"
		local sulim = "`esecond'"
		local strll = 0
		local strul = 0

		if ("`e(model)'"=="Exponential") {
			local esecond = .
		}
			
		if ("`efirst'"== ".") {
			local linfty = 1
		}
		
		if ("`esecond'"==".") {
			local uinfty = 1
		}

		if (`llim' == . & `"`sllim'"' != "" & `linfty'==0) {
			capture fvexpand `sllim' if `touse'
			local rc = _rc
			
			if `rc' {
				display as error "when specifying {bf:ll()}"
				fvexpand `sllim' if `touse'
			}
			
			local strll = 1
		}

		if (`ulim' == . & `"`sulim'"' != "" & `uinfty'==0) {
			capture fvexpand `sulim' if `touse'
			local rc = _rc
			
			if `rc' {
				display as error "when specifying {bf:ul()}"
				fvexpand `sulim' if `touse'
			}
		
			local strul = 1
		}
		
		if ("`efirst'" != "" & `uinfty' == 1) {
			local epbound = 1
			
			if (`llim' == . & `strll' == 0 & `linfty'==0) {
			
				display as error "invalid {bf:ll()}"
				exit 198
			}
		}
		
		if (`linfty' == 1 & "`esecond'" != "") {
			local epbound = 2
		
		if (`ulim' == . & `strul' == 0 & `uinfty'==0) {
				display as error "invalid {bf:ul()}"
				exit 198
			}
		}
		
		if ("`efirst'" != "" & "`esecond'" != "" & `uinfty'==0 &     ///
		    `linfty'==0) {
			local epbound = 3
			
			if (`ulim' == . & `strul'==0 & `uinfty'==0) {
				display as error "invalid {bf:ul()}"
				exit 198
			}
			
			if (`llim' == . & `strll' == 0 & `linfty'==0) {
				display as error "invalid {bf:ll()}"
				exit 198
			}
			
			if ((`llim' >= `ulim') & `strul'==0 & `strll'==0 &   ///
			    (`linfty'==0 & `uinfty'==0)) {
				display as error "{bf:ll()} greater than"    ///
				    " {bf:ul()}"
				exit 198
			}
		}
	}

	if "`ystar'" !="" {
		local ystarh = "ystar"
		gettoken ylim ystar: ystar, parse(",")
		local yfirst `ylim'
		gettoken ylim2 ystar: ystar, parse(",")
		local ysecond `ystar'
		local llim  = real("`yfirst'")
		local ulim  = real("`ysecond'")
		local sllim = "`yfirst'"
		local sulim = "`ysecond'"
		local strll = 0
		local strul = 0
		
		
		if ("`e(model)'"=="Exponential") {
			local ysecond = .
		}
		
		if ("`yfirst'"== ".") {
			local linfty = 1
		}
		
		if ("`ysecond'"==".") {
			local uinfty = 1
		}

		if (`llim' == . & `"`sllim'"' != "" & `linfty'==0) {
			capture fvexpand `sllim' if `touse'
			local rc = _rc
			
			if `rc' {
				display as error "when specifying {bf:ll()}"
				fvexpand `sllim' if `touse'
			}
			
			local strll = 1
		}

		if (`ulim' == . & `"`sulim'"' != "" & `uinfty'==0) {
			capture fvexpand `sulim' if `touse'
			local rc = _rc
			
			if `rc' {
				display as error "when specifying {bf:ul()}"
				fvexpand `sulim' if `touse'
			}
		
			local strul = 1
		}
		
		if ("`yfirst'" != "" & `uinfty' == 1) {
			local epbound = 1
			
			if (`llim' == . & `strll' == 0 & `linfty'==0) {
				display as error "invalid {bf:ll()}"
				exit 198
			}
		}
		
		if (`linfty' == 1 & "`ysecond'" != "") {
			local epbound = 2
		
			if (`ulim' == . & `strul' == 0 & `uinfty'==0) {
				display as error "invalid {bf:ul()}"
				exit 198
			}
		}
		
		if ("`yfirst'" != "" & "`ysecond'" != "" & `uinfty'==0 &     ///
		    `linfty'==0) {
			local epbound = 3
			
			if (`ulim' == . & `strul'==0 & `uinfty'==0) {
				display as error "invalid {bf:ul()}"
				exit 198
			}
			
			if (`llim' == . & `strll' == 0 & `linfty'==0) {
				display as error "invalid {bf:ll()}"
				exit 198
			}
			
			if ((`llim' >= `ulim') & `strul'==0 & `strll'==0 &   ///
			    (`linfty'==0 & `uinfty'==0)) {
				display as error "{bf:ll()} greater than"    ///
				   " {bf:ul()}"
				exit 198
			}
		}
	}

	if  ("`e'" =="" & "`pr'" =="" & "`ystar'"=="") {

		local llim  = real("`e(llimit)'")
		local ulim  = real("`e(ulimit)'")
		local sllim = "`e(llimit)'"
		local sulim = "`e(ulimit)'"
		local strll = 0
		local strul = 0

		if (`llim' == . & `"`sllim'"' != "") {
			capture fvexpand `sllim' if `touse'
			local rc = _rc
			
			if `rc' {
				display as error "when specifying {bf:ll()}"
				fvexpand `sllim' if `touse'
			}
			
			local strll = 1
		}

		if (`ulim' == . & `"`sulim'"' != "") {
			capture fvexpand `sulim' if `touse'
			local rc = _rc
			
			if `rc' {
				display as error "when specifying {bf:ul()}"
				fvexpand `sulim' if `touse'
			}
			
			local strul = 1
		}
	}

	// Parsing options

	local options = ("`ystar1'"!="") + ("`residuals'"!="") +             ///
	    ("`pr'"!="") + ("`e'"!="") + ("`xb'"!="") + ("`ystar'"!="") +    ///
	    ("`stdp'"!="") + ("`scores'"!="")

			
	local stat "`ystar1'`residuals'`parast'`ehat'`xb'`ystarh'`stdp'`scores'"

	if (`linfty'==1 & `uinfty'==1 & "`e'"!="") {
		local options = 0
		local e       = ""
		local stat    = "ystar1"
	}


	if `options' > 1 {
		display as error "only one statistic may be specified"
		exit 198
	}

	if `options'== 0 {
		display as text "(statistic {bf:ystar} assumed)"
		local stat = "ystar1"
	}
	
	if "`stat'"=="`residuals'" {
		local stat = "ystar1"
	}
	
	
	// Original Model Bounds

	local mllim   = real("`e(llimit)'")
	local mulim   = real("`e(ulimit)'")
	local msllim  = "`e(llimit)'"
	local msulim  = "`e(ulimit)'"
	local mstrll  = 0
	local mstrul  = 0

	if (`mllim' == . & `"`msllim'"' != "") {
		local mstrll = 1
	}

	if (`mulim' == . & `"`msulim'"' != "") {
		local mstrul = 1
	}

	if ("`e(model)'"=="Exponential" & `epbound'>1) {	
		display as error 					     ///
		"{bf:ul()} inconsistent with {bf:churdle exponential}"
		exit 198
	}
	
	quietly generate double `yhatp'    = .
	quietly generate double `xbp'      = .
	quietly generate double `ep'       = .
	quietly generate double `prp'      = .
	quietly generate double `ystarp'   = .	

	qui mata: _CHURDLE_predict_hurd("`yhatp'", `bound', `hlatent',       ///
	    "`touse'", `model', "`e(model)'", "`sllim'", "`sulim'", `strll', ///
	    `strul', "`stat'", "`xbp'", "`ep'", "`prp'", "`ystarp'",         ///
	    "`e(llimit)'", "`e(ulimit)'", `mstrll', `mstrul', `epbound',     ///
	    "`e(depvar)'")

	if `options'== 0 {
		generate `typlist' `varlist' = `yhatp' if `touse'
		label var `varlist'                                          ///
		"Conditional mean estimates of dependent variable" 
	}

	if "`residuals'" !="" {
		generate `typlist' `varlist' =  `e(depvar)'-`yhatp' if `touse'
		label var `varlist' "Residuals" 
	}

	if "`xb'" !="" {
		if "`equation'" == "" {
			generate `typlist' `varlist' = `xbp' if `touse'
			label var `varlist'                                  ///
			    "Linear prediction xb for equation `e(depvar)'"
		}
		else {
			_predict `typlist' `xbeq' if `touse', xb ///
				equation(`equation')
			generate `typlist' `varlist' = `xbeq' if `touse'
			label var `varlist'                                  ///
			    "Linear prediction xb for equation `equation'"	
		} 
	}

	if ("`e'" !=""){
		quietly generate `typlist' `varlist' = `ep' if `touse'
		label var `varlist'                                          ///
		"Conditional mean estimate of dependent variable in (a,b)" 
	}

	if "`pr'" !="" {
		generate `typlist' `varlist' = `prp' if `touse'
		label var `varlist'                                          ///
		"Probability of dependent variable in (a,b)" 
	}

	if "`ystar'" !="" {
		generate `typlist' `varlist' = `ystarp' if `touse'
		label var `varlist'                                          ///
		"Mean estimates of y*= max{a, min(`e(depvar)',b)}" 
	}
	
	if "`stdp'" !="" {
		_predict `typlist' `stdpp', stdp equation(`equation')
		generate `typlist' `varlist' = `stdpp' if `touse'
		
		local se Standard error 
		
		if "`equation'"== "" {
			label var `varlist'                                  ///
			    "`se' of linear prediction for equation `e(depvar)'"
		}
		else {
			label var `varlist'                                  ///
			    "`se' of linear prediction for equation `equation'"
		} 
	}

end

program define Equacion, eclass
	syntax,							     ///
		[	                                             ///
		equation(string)	                             ///
		model(integer 1)                                     ///
		bound(integer 1)                                     ///
		]
		
		local equacion = 1
		
		if (`model'== 1|`model'==4) {			
			if "`equation'"!= "" {
				if "`equation'"=="`e(depvar)'" {
					local equacion = 1
				}
				if "`equation'"=="selection_ll" {
					local equacion = 2
				}
				if "`equation'"=="lnsigma" {
					local equacion = 3
				}
				
				gettoken testing equation: equation, parse("#")
				
				if (`equacion'== 1 & "`testing'"=="#") {
					local equacion = `equation'
				}
				if (`equacion'== 1 & real("`testing'")!=.) {
					display as err                       ///
					"invalid {bf:equation()}"
					exit 198
				}
				
				if `equacion'==1 {
					local labeler = "`e(depvar)'"					
				}
				if `equacion'==2 {
					local labeler = "selection_ll"					
				}
				if `equacion'==3 {
					local labeler = "lnsigma"					
				}
			}
			
			local glabeler = "`e(depvar)' selection_ll lnsigma"
		}
		if (`model'== 2|`model'==3) {
			if "`equation'"!= "" {
				if "`equation'"=="`e(depvar)'" {
					local equacion = 1
				}
				if ("`equation'"=="selection_ll" & `bound'!=2) {
					local equacion = 2
				}
				if ("`equation'"=="selection_ul" & `bound'==3) {
					local equacion = 3
				}
				if ("`equation'"=="selection_ul" & `bound'==2) {
					local equacion = 2
				}
				if ("`equation'"=="lnsigma" & `bound'!=3) {
					local equacion = 3
				}
				if ("`equation'"=="lnsigma" & `bound'==3) {
					local equacion = 4
				}
				
				gettoken testing equation: equation, parse("#")
				
				if (`equacion'== 1 & "`testing'"=="#") {
					local equacion = `equation'
				}
				if (`equacion'== 1 & real("`testing'")!=.) {
					display as err                       ///
					"invalid {bf:equation()}"
					exit 198
				}
			}
			
			
			if `equacion'==1 {
				local labeler = "`e(depvar)'"					
			}
			if (`equacion'==2 &`bound'!=2) {
				local labeler = "selection_ll"					
			}
			if (`equacion'==2 &`bound'==2) {
				local labeler = "selection_ul"					
			}
			if (`equacion'==3 & `bound'!=3)  {
				local labeler = "lnsigma"					
			}
			if (`equacion'==4 & `bound'==3)  {
				local labeler = "lnsigma"					
			}
			if `bound'==1 {
				local glabeler = ///
				"`e(depvar)' selection_ll lnsigma"
			}
			if `bound'==2 {
				local glabeler = ///
				"`e(depvar)' selection_ul lnsigma"
			}
			if `bound'==3 {
				local glabeler = ///
				"`e(depvar)' selection_ll selection_ul lnsigma"
			}
		}
		if (`model'==5|`model'==8) {			
			if "`equation'"!= "" {
				if "`equation'"=="`e(depvar)'" {
					local equacion = 1
				}
				if "`equation'"=="selection_ll" {
					local equacion = 2
				}
				if "`equation'"=="lnsigma" {
					local equacion = 3
				}
				if "`equation'"=="lnsigma_ll" {
					local equacion = 4
				}
				
				gettoken testing equation: equation, parse("#")
				
				if (`equacion'== 1 & "`testing'"=="#") {
					local equacion = `equation'
				}
				if (`equacion'== 1 & real("`testing'")!=.) {
					display as err                       ///
					"invalid {bf:equation()}"
					exit 198
				}
			}
			if `equacion'==1 {
				local labeler = "`e(depvar)'"					
			}
			if `equacion'==2 {
				local labeler = "selection_ll"					
			}
			if `equacion'==3 {
				local labeler = "lnsigma"					
			}
			if `equacion'==4 {
				local labeler = "lnsigma_ll"					
			}
			local glabeler = ///
				"`e(depvar)' selection_ll lnsigma lnsigma_ll"
		}
		if (`model'== 6|`model'==7) {
			if "`equation'"!= "" {
				if "`equation'"=="`e(depvar)'" {
					local equacion = 1
				}
				if ("`equation'"=="selection_ll" & `bound'!=2) {
					local equacion = 2
				}
				if ("`equation'"=="selection_ul" & `bound'==3) {
					local equacion = 3
				}
				if ("`equation'"=="selection_ul" & `bound'==2) {
					local equacion = 2
				}
				if ("`equation'"=="lnsigma" & `bound'!=3) {
					local equacion = 3
				}
				if ("`equation'"=="lnsigma" & `bound'==3) {
					local equacion = 4
				}
				if (("`equation'"=="lnsigma_ll"| ///
					"`equation'"=="lnsigma_ul") & ///
					`bound'!=3) {
					local equacion = 4
				}
				if ("`equation'"=="lnsigma_ll" & `bound'==3) {
					local equacion = 5
				}
				if ("`equation'"=="lnsigma_ul" & `bound'==3) {
					local equacion = 6
				}
				
				gettoken testing equation: equation, parse("#")
				
				if (`equacion'== 1 & "`testing'"=="#") {
					local equacion = `equation'
				}
				if (`equacion'== 1 & real("`testing'")!=.) {
					display as err                       ///
					"invalid {bf:equation()}"
					exit 198
				}
			}
			
			if `equacion'==1 {
				local labeler = "`e(depvar)'"					
			}
			if (`equacion'==2 &`bound'!=2) {
				local labeler = "selection_ll"					
			}
			if (`equacion'==2 &`bound'==2) {
				local labeler = "selection_ul"					
			}
			if (`equacion'==3 & `bound'!=3)  {
				local labeler = "lnsigma"					
			}
			if (`equacion'==4 & `bound'==3)  {
				local labeler = "lnsigma"					
			}
			if (`equacion'==4 & `bound'==1)  {
				local labeler = "lnsigma_ll"					
			}
			if (`equacion'==4 & `bound'==2)  {
				local labeler = "lnsigma_ul"					
			}
			if (`equacion'==5)  {
				local labeler = "lnsigma_ll"					
			}
			if (`equacion'==6)  {
				local labeler = "lnsigma_ul"					
			}
			if `bound'==1 {
				local glabeler = ///
				"`e(depvar)' selection_ll lnsigma lnsigma_ll"
			}
			if `bound'==2 {
				local glabeler = ///
				"`e(depvar)' selection_ul lnsigma lnsigma_ul"
			}
			if `bound'==3 {
				local antes selection_ul lnsigma lnsigma_ll 
				local glabeler = ///
				"`e(depvar)' selection_ll `antes' lnsigma_ul"
			}
		}
		
		ereturn local equacion "`equacion'"
		ereturn local labeler  "`labeler'"
		ereturn local glabeler "`glabeler'"
end		
