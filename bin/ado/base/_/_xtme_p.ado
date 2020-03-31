*! version 1.1.9  21dec2015
program _xtme_p
	
	if inlist("`e(cmd)'","xtmelogit","xtmepoisson") global ME_QR = 0
	else global ME_QR = 1
	
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	version 10
	
	cap noi `vv' _xtme_p_u `0'
	local rc = _rc
	cap drop ___uu*
	cap drop ___ss*
	cap mac drop ME_QR
	exit `rc'
end

program _xtme_p_u
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	
	if $ME_QR local lev_opt RELEVel
	else local lev_opt Level
	
	version 10
	syntax [anything(name=vlist)] [if] [in] ///
				[, FIXEDonly xb stdp `lev_opt'(string) ///
				   REFfects RESEs Mu Pearson Deviance /// 
				   Anscombe noOFFset SCores RESES1(string)] 
	
	local level `level' `relevel'
	
	if `"`scores'"' != "" {
		if "`offset'" != "" {
			di as err "{p 0 4 2}nooffset not allowed with "
			di as err "scores{p_end}"
			exit 198
		}
		`vv' GenScores `0'
		exit
	}
	
	if `"`reses'"'!="" & "`reses1'"!="" {
		di as err "only one of {bf:reses} or {bf:reses()} is allowed"
		exit 198
	}
	local k = ("`mu'"!="") + ("`xb'"!="") + ("`stdp'"!="") + ///
		  ("`reffects'"!="") + ("`reses'"!="") + ///
		  ("`pearson'" != "") + ("`deviance'"!="") + ///
		  ("`anscombe'" != "")
	if `k' > 1 {
		di as err "{p 0 4 2}only one of mu, xb, stdp, reffects, " 
		di as err "reses, pearson, deviance, or anscombe "
		di as err "should be specified{p_end}"
		exit 198
	}

	if `"`reses1'"' != "" {
		local junk "`mu'`xb'`stdp'`pearson'`deviance'`anscombe'"
		if "`junk'" != "" {
			di as err "option {bf:reses()} not allowed with " ///
				"option {bf:`junk'}"
			exit 198
		}
		if "`reffects'" == "" {
			di as err "option {bf:reses()} requires the {bf:reffects} option"
			exit 198
		}
		if "`vlist'" == "" {
			di as err "stub* or newvarlist required"
			exit 100
		}
		local rr reses()
	}
	
	if `"`reses1'"' == "" {
local type "`mu'`xb'`stdp'`pearson'`deviance'`anscombe'`reffects'`reses'"
	}
	else {		
local type "`mu'`xb'`stdp'`pearson'`deviance'`anscombe'`rr'"
	}

	if "`type'" == "" {
		local type mu
		local defp defp
	}

	if `"`level'"' != "" {
		if `"`level'"' != "_all" {
			if `:word count `level'' > 1 {
			    di as err "{p 0 4 2}invalid level() specification"
			    di as err "{p_end}"
			    exit 198
			}
			unab level : `level'
		}
		if !inlist("`type'","reffects","reses","reses()") {
			di as err "{p 0 4 2}level() not allowed"	
			di as err "{p_end}"
			exit 198
		}
		local ivars `e(ivars)'
		if `:list posof `"`level'"' in local ivars' == 0 {
			di as err `"{p 0 4 2}`level' is not a level variable "'
			di as err "in this model{p_end}"
			exit 198
		}
	}
	if "`type'" == "reffects" | "`type'" == "reses" {
		if "`offset'" != "" {
			di as err `"{p 0 4 2}option nooffset not allowed"'
			di as err "{p_end}"
			exit 198
		}
	}
	// reffects are standard errors, mimic the calculation except for
	// the command option
	local ditype `type'
	if "`type'" == "reses"{
		local ise ise
		local type reffects
		local reffects reffects
		local ditype reses
	}
	if "`type'" == "reses()" {
		local type reffects
		local reffects reffects
		local ditype reses
	}

	if "`type'" == "reffects" {
		ParseRE `"`vlist'"' `level'
		local varn `s(varlist)'
		local vtyp `s(typlist)'
		if `"`reses1'"' != "" {
			ParseRE `"`reses1'"' `level'
			local varn_se `s(varlist)'
			local vtyp_se `vtyp'
		}
	}
	else {
		local 0 `vlist' `if' `in'
		syntax [newvarname] [if] [in]
		local varn `varlist'
		local vtyp `typlist'
	}

	marksample touse, novarlist
	tempvar t 
	if "`type'" == "xb" {
		if "`type'" == "" {
			di as txt "(option xb assumed)"
		}
		if !`e(k_f)' {
			qui gen double `t' = 0 if `touse' 
		}
		else {
			qui _predict double `t' if `touse', `offset'
		}
		gen `vtyp' `varn' = `t' if `touse'
		label var `varn' "Linear prediction, fixed portion"
		exit
	}
	if "`type'" == "stdp" {
		if !`e(k_f)' {
			qui gen double `t' = 0 if `touse' 
		}
		else {
			qui _predict double `t' if `touse', stdp `offset'
		}
		gen `vtyp' `varn' = `t' if `touse'
		label var `varn' "s.e. of the linear prediction, fixed portion"
		exit
	}

	// at this point we need blups (unless fixedonly of course), 
	// and for that we need to reconstruct the model from e()

	if "`fixedonly'" == "" {
		if "`e(ivars)'" != "" {      // no random effects, no blups
			qui count if e(sample)
			if r(N)==0 {
				di as err "{bf:predict, `ditype'} requires " ///
				"that the data used in estimation be in memory"
				exit 459
			}
			ConstCommand
			local command `s(command)'
			BlupList "`reffects'" "`level'"	"`ise'" "uu"
			local blupopt `s(blupoption)'
			if `"`reses1'"' != "" {
				BlupList "`reffects'" "`level'"	"ise" "ss"
				local blupopt `blupopt' `s(blupoption)' reseok
			}
			qui `vv' `command' `blupopt' // rerun _xtme

			cap assert `touse' == e(sample) 
			if _rc {
				MapBlups `touse'  // map blups to out-of-sample
			}
		}
	
		cap unab uvars : ___uu*
		if "`reffects'" != "" {		       // done
			foreach v of local varn {
				gettoken typ vtyp : vtyp
			 	gettoken u uvars : uvars
				gen `typ' `v' = `u' if `touse'
				label var `v' `"`:var label `u''"'
			}
			if `"`reses1'"' != "" {
				cap unab uvars_se : ___ss*
				foreach v of local varn_se {
					gettoken typ vtyp_se : vtyp_se
				 	gettoken u uvars_se : uvars_se
					gen `typ' `v' = `u' if `touse'
					label var `v' `"`:var label `u''"'
				}
			}
			exit
		}	
	}

	// Get linear predictor/fixed portion

	if !`e(k_f)' {
		qui gen double `t' = 0 if `touse' 
	}
	else {
		qui _predict double `t' if `touse', `offset'
	}

	// take blups and score them with the variables in the data
	// If fixedonly specified, just leave it as the fixed portion

	if "`fixedonly'" == "" {
		if "`uvars'" != "" {
			foreach u of varlist `uvars' {
				local lab : var label `u'
				local z : word 5 of `lab'
				if "`z'"=="_cons" | bsubstr("`z'",1,2)=="R." {
					local z 1	
				}
				qui replace `t' = `t' + `u'*`z' if `touse'
			}
		}
	}
	else {
		local fixlab , fixed portion only
	}

	tempvar den mu
	if "`e(binomial)'" != "" {
		qui gen double `den' = `e(binomial)' if `touse'
	}
	else {
		qui gen double `den' = 1 if `touse'
	}

	// Need mu no matter what
	GetMu `mu' `t' `den' `touse'

	if "`type'" == "mu" {
		gen `vtyp' `varn' = `mu' if `touse'
		local vlab Predicted mean`fixlab'
		label var `varn' "`vlab'"
		if "`defp'" != "" {
			di as txt "(option mu assumed; predicted means)"
		}
		exit
	}

	tempvar res
	if "`type'" == "pearson" {
		GetPearson `res' `mu' `den' `touse'
		gen `vtyp' `varn' = `res' if `touse'
		local vlab Pearson residual`fixlab'
		label var `varn' "`vlab'"
		exit
	}

	if "`type'" == "deviance" {
		GetDeviance `res' `mu' `den' `touse'
		gen `vtyp' `varn' = `res' if `touse'
		local vlab Deviance residual`fixlab'
		label var `varn' "`vlab'"
		exit
	}

	if "`type'" == "anscombe" {
		GetAnscombe `res' `mu' `den' `touse'
		gen `vtyp' `varn' = `res' if `touse'
		local vlab Anscombe residual`fixlab'
		label var `varn' "`vlab'"
		exit
	}

	di as err "predict type `type' not allowed"
	exit 198
end

program GetMu
	args mu xb den touse

	if "`e(model)'" == "logistic" {
 		qui gen double `mu' = `den'*invlogit(`xb') if `touse'
	}	
	else {
		qui gen double `mu' = exp(`xb') if `touse'
	}
end

program GetPearson 
	args res mu den touse

	tempvar y

	if "`e(model)'" == "logistic" {
		if "`e(binomial)'" == "" {		// Bernoulli
			qui gen double `y' = (`e(depvar)' != 0) if `touse'
		}
		else {
			qui gen double `y' = `e(depvar)' if `touse'
		}
		qui gen double `res' = (`y' - `mu') /      ///
		                       sqrt((`mu') * (1 - `mu'/`den')) ///
				       if `touse'
	}
	else {				// Poisson
		qui gen double `y' = `e(depvar)' if `touse'
		qui gen double `res' = (`y' - `mu')/sqrt(`mu') if `touse'
	}
end

program GetDeviance
	args res mu den touse

	tempvar y

	if "`e(model)'" == "logistic" {
		if "`e(binomial)'" == "" {		// Bernoulli
			qui gen double `y' = (`e(depvar)' != 0) if `touse'
		}
		else {
			qui gen double `y' = `e(depvar)' if `touse'
		}
		qui gen double `res' = cond(`y'>0 & `y'<`den', ///
				            2*`y'*ln(`y'/`mu') + ///
					    2*(`den'-`y') * ///
					    ln((`den'-`y')/(`den'-`mu')), ///
					    cond(`y'==0, 2*`den'* ///
					    ln(`den'/(`den'-`mu')), ///
					    2*`y'*ln(`y'/`mu')) ) if `touse'
	}
	else {				// Poisson
		qui gen double `y' = `e(depvar)' if `touse'
		qui gen double `res' = cond(`y'==0, 2*`mu', ///
		                            2*(`y'*ln(`y'/`mu') - ///
					    (`y'-`mu'))) ///
					    if `touse'
	}
	qui replace `res' = sign(`y' - `mu')*sqrt(`res') if `touse'
end

program GetAnscombe
	args res mu den touse

	tempvar y

	if "`e(model)'" == "logistic" {
		if "`e(binomial)'" == "" {		// Bernoulli
			qui gen double `y' = (`e(depvar)' != 0) if `touse'
		}
		else {
			qui gen double `y' = `e(depvar)' if `touse'
		}
		qui gen double `res' = 1.5*(`y'^(2/3)*_hyp2f1(`y'/`den') - ///
		                        `mu'^(2/3)*_hyp2f1(`mu'/`den')) /  ///
					((`mu'*(1-`mu'/`den'))^(1/6))
	}
	else {				// Poisson
		qui gen double `y' = `e(depvar)' if `touse'
		qui gen double `res' = 1.5*(`y'^(2/3)-`mu'^(2/3)) /   ///
				       `mu'^(1/6) if `touse'
	}
end

program MapBlups, sort
	args touse

	unab uvars : ___uu*
	tempvar id one
	
	qui gen byte `one' = 1 

	local ivars `e(ivars)'
	local ivars : list uniq ivars
	local ivars : subinstr local ivars "_all" "`one'", all
	qui egen long `id' = group(`ivars') 

	foreach v of varlist `uvars' {
		local lab : var label `v'
		local name : word 5 of `lab'
		local fvar
		if bsubstr("`name'",1,2) == "R." { 	// factor variable
			local fvar = bsubstr("`name'",3,length("`name'"))	
		}
		qui sort `id' `fvar' `v'
		qui by `id' `fvar':replace `v' = `v'[1] if `touse'
	}
end

program BlupList, sclass
	args blup level ise name

	local ivars `e(ivars)'	
	local ivars : list uniq ivars
	local k : word count `ivars' 
	if !`k' {			        // model is regression
		exit
	}
	if "`level'" == "" {		// wants them all
		forval i = 1/`k' {
			local gr : word `i' of `ivars'
			local opt `opt' `gr' ___`name'`i'
		}		
	}
	else {				// specific level
		if "`blup'" != "" {
			local opt `level' ___`name'1
		}
		else {
			local i 1
			gettoken gr ivars : ivars
			while "`gr'" != "`level'" {
				local opt `opt' `gr' ___`name'`i'
				local ++i
				gettoken gr ivars : ivars
			}	
			local opt `opt' `level' ___`name'`i'
		}
	}
	if "`ise'" != "" {
		sreturn local blupoption `"getblupses(`opt')"'
	}
	else {
		sreturn local blupoption `"getblups(`opt')"'
	}
end

program ConstCommand, sclass
	local command _xtme_estimate "`=lower("`e(model)'")'" `e(depvar)'
	
	// fixed parameters

	local colnames : colnames e(b)
	local nf = `e(k_f)'
	if !`nf' {
		local command `"`command', nocons||"'
	}
	else {
		if `"`:word `nf' of `colnames''"' != "_cons" {
			local nocons nocons
		}
		local feq `:subinstr local colnames "_cons" "", all'
		local command `"`command' `feq',`nocons'||"'
	}

	// random equations, one by one

	local revars `e(revars)'
	local nlev : word count `e(ivars)'
	forvalues i = 1/`nlev' {
		local level : word `i' of `e(ivars)'
		local command `"`command'`level':"'
		local nz : word `i' of `e(redim)'
		local vars
		forvalues j = 1/`nz' {
			gettoken token revars : revars
			local vars `vars' `token'
		}	
		local nocons
		if `"`:word `nz' of `vars''"' != "_cons" {
			local nocons nocons
		}
		local req `:subinstr local vars "_cons" "", all'
		local command `"`command'`req',`nocons'"'
		local vtype = lower("`:word `i' of `e(vartypes)''")
		local command `"`command' cov(`vtype')||"'
	}
	local command `"`command'  if e(sample), "'
	if "`e(offset)'" != "" {
		_get_offopt `e(offset)'
		local offopt `s(offopt)'
	}
	local command `"`command' `offopt'"'
	if `"`e(binomial)'"' != "" {
		local command `"`command' bin(`e(binomial)')"'
	}
	sreturn local command `command'
end

program ParseRE, sclass
	args vlist level

	local nvars 0
	local w : word count `e(redim)'
	forvalues i = 1/`w' {
		if "`level'"=="" | "`:word `i' of `e(ivars)''" == "`level'" {
			local nvars = `nvars' + `:word `i' of `e(redim)''
		}
	}
	if !`nvars' {
		di as err "{p 0 4 2}model is `e(model)' regression; estimates "
		di as err "of r.e.'s or their standard errors "
		di as err "are not available{p_end}"
		exit 459
	}
	
	if bsubstr(`"`vlist'"',-1,1) == "*" {
		local nargs : word count `vlist'
		if `nargs' != 1 {
			if `nargs' == 2 {
				tokenize `vlist'
				args type vlist
			}
			else {
				di as err "too many variables specified"
				exit 103
			}
		}
		else    {
			local type `c(type)'
		}
		local vlist = bsubstr("`vlist'",1,length("`vlist'")-1)
		local varlist
		local typlist
		forvalues i = 1/`nvars' {
			local varlist `varlist' `vlist'`i'
			local typlist `typlist' `type'	
		}
		confirm new variable `varlist'
	}
	else { 			// user specifies his own variables
		local 0 `"`vlist'"'
		cap noi syntax newvarlist(min=`nvars' max=`nvars')
		local rc = c(rc)
		if `rc' {
			if `rc' == 102 | `rc' == 103 {
				di as err "{p 0 4 2}you must specify `nvars' "
				di as err "new variable(s){p_end}"	
			}
			exit `rc'
		}
	}
	sreturn local varlist `varlist'
	sreturn local typlist `typlist'	
end

program GenScores
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	version 10
	syntax [anything] [if] [in] [, *]
	marksample touse

	tempname b
	mat `b' = e(b) 
	forval i = 1/`=colsof(`b')' {
		local ceq `ceq' `i'
	}
	mat coleq `b' = `ceq'

	_score_spec `anything', b(`b')
	local varn `s(varlist)'
	local vtype `s(typlist)'

	local w : word count `varn'

	if `w' != e(k) {
		local 0 `"`varn'"'
		cap noi syntax newvarlist(min=`e(k)' max=`e(k)')
		local rc = c(rc)
		if `rc' {
			if `rc' == 102 | `rc' == 103 {
				di as err "{p 0 4 2}you must specify `e(k)' "
				di as err "new variable(s){p_end}"
			}
			exit `rc'
		}
	}

	ConstCommand
	local command `"`s(command)' intpoints(`e(n_quad)')"'
	qui `vv' `command' getscores(___uu)	
	local w : word count `varn'
	forval i = 1/`w' {
		local vname : word `i' of `varn'
		local vvtype : word `i' of `vtype'
		rename ___uu`i' `vname'
		qui recast `vvtype' `vname', force
	}
end

