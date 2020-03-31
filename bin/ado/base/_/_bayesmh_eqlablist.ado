*! version 1.0.7  03dec2018
program _bayesmh_eqlablist
	version 14.0
	_bayesmh_eqlablist_`0'
end

program _bayesmh_eqlablist_init
	global MCMC_eqlablist " "
	global MCMC_betapar_1
	global MCMC_beta_1
	global MCMC_latent
	// used in bayespredict
	global MCMC_predfile
	global MCMC_ysimlist
end

program _bayesmh_eqlablist_export, eclass
	local ltemp `"$MCMC_eqlablist"'
	local ltemp `ltemp'
	ereturn hidden local eqlablist = `"`ltemp'"'
	local toklist $MCMC_eqlablist
	local ylabind : word count $MCMC_eqlablist
	gettoken tok toklist : toklist
	forvalues tok = 1/`ylabind' {
		local ltemp MCMC_betapar_`tok'
		ereturn hidden local betapar_`tok' = `"$`ltemp'"'
		local ltemp MCMC_beta_`tok'
		ereturn hidden local beta_`tok' = `"$`ltemp'"'
		gettoken tok toklist : toklist
	}
end

program _bayesmh_eqlablist_import
	
	if (`"`e(cmd)'"' != "bayesmh" & `"`e(prefix)'"' != "bayes") | ///
		`"`e(parnames)'"' == "" {
		di as err "last estimates not found"
		exit 301
	}

	global MCMC_eqlablist = `"`e(eqlablist)'"'
	global MCMC_latent    = `"`e(latparams)'"'
	local toklist $MCMC_eqlablist
	local ylabind : word count $MCMC_eqlablist
	gettoken tok toklist : toklist
	forvalues tok = 1/`ylabind' {
		local ltemp MCMC_betapar_`tok'
		global `ltemp' = `"`e(betapar_`tok')'"'
		local ltemp MCMC_beta_`tok'
		global `ltemp' = `"`e(beta_`tok')'"'
		gettoken tok toklist : toklist
	}

	exit

	// old code
	// initialize with 1 interval 
	global MCMC_eqlablist " "
	
	local parnames `"`e(parnames)'"'
	gettoken next parnames : parnames
	while `"`next'"' != "" {

		local eqlab
		local param `"`next'"'
		tokenize `"`next'"', parse(":")
		if `"`1'"' != "" & `"`2'"' == ":" {
			local eqlab `"`1'"'
			local param `"`3'"'
		}
		if `"`eqlab'"' == "" {
			gettoken next parnames : parnames
			continue
		}
		// update $MCMC_eqlablist
		if !regexm(`"$MCMC_eqlablist"', `" `eqlab' "') {
			global MCMC_eqlablist `"$MCMC_eqlablist`eqlab' "'
			local eqlabind : word count $MCMC_eqlablist
			local ltemp MCMC_betapar_`eqlabind'
			global `ltemp'
			// clear global MCMC_beta_`ylabind'
			local eqlablist MCMC_beta_`eqlabind'
			global `eqlablist'
		}
		else {
			tokenize $MCMC_eqlablist
			local eqlabind 1
			while`"`1'"' != "" & `"`eqlab'"' != `"`1'"' {
				local eqlabind = `eqlabind'+1
				mac shift
			}
			local eqlablist MCMC_beta_`eqlabind'
		}
		if !regexm(`"$`eqlablist'"', `"`param' "') {
			global `eqlablist' = `"$`eqlablist'`param' "'
		}
		gettoken next parnames : parnames
	}
end

program _bayesmh_eqlablist_clear
	local toklist $MCMC_eqlablist
	local ylabind : word count $MCMC_eqlablist
	gettoken tok toklist : toklist
	forvalues tok = 1/`ylabind' {
		// clear global MCMC_beta_`tok'
		local ltemp MCMC_betapar_`tok'
		global `ltemp'
		local ltemp MCMC_beta_`tok'
		global `ltemp'
		gettoken tok toklist : toklist
	}
	global MCMC_eqlablist
	global MCMC_latent
end


program _bayesmh_eqlablist_ind, sclass
	args yvar
	local ylabind 1
	if !regexm(`"$MCMC_eqlablist"', `"`yvar' "') {
		global MCMC_eqlablist = ///
			`"$MCMC_eqlablist`yvar' "'
		local ylabind : word count $MCMC_eqlablist
	}
	else {
		tokenize $MCMC_eqlablist
		local ylabind 1
		while `"`1'"' != "" & `"`yvar'"' != `"`1'"' {
			local ylabind = `ylabind'+1
			mac shift
		}
	}
	sreturn local ylabind = `ylabind'
end

program _bayesmh_eqlablist_up
	args yvar param ylabind

	local ltemp MCMC_betapar_`ylabind'
	local gtemp `"$`ltemp'"'
	if !regexm(`"`gtemp'"', `"{`yvar':`param'} "') {
		global `ltemp' = `"`gtemp'{`yvar':`param'} "'
		local ltemp MCMC_beta_`ylabind'
		local gtemp `"$`ltemp'"'
		global `ltemp' = `"`gtemp'`param' "'
	}
end
