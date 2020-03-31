*! version 1.3.0  22nov2016
program gsem_parse_fl, sclass
	version 13

	syntax [, Family(string) LInk(string)]

	local 0 `"`family'"'
	syntax [anything] [, *]
	local fopts : copy local options
	gettoken family fargs : anything
	ParseFamily family fargs, `family' args(`fargs') opts(`fopts')
	gettoken link largs : link
	ParseLink `family' link largs, `link' args(`largs')

	if "`family'" == "gaussian" {
		if "`link'" == "log" {
			if "`fargs'" != "" {
				di as err		///
"{p 0 0 2}"						///
"link log is not allowed with family gaussian when "	///
"censoring is specified"				///
"{p_end}"
				exit 198
			}
		}
	}

	sreturn clear
	sreturn local family	`family'
	sreturn local fargs	`"`fargs'"'
	sreturn local link	`link'
	sreturn local largs	`"`largs'"'
end

program ParseFamily
	syntax namelist			///
		[,	Bernoulli	///
			BETa		///
			BINomial	///
			Exponential	///
			GAMma		///
			GAUssian	///
			Multinomial	///
			NBinomial	///
			NORMal		///
			Ordinal		///
			POIsson		///
			Weibull		///
			LOGNormal	///
			LNormal		///
			LOGLogistic	///
			LLogistic	///
			3pl		///
			POINTMASS	///
			args(string)	///
			opts(string)	///
		]

	if "`normal'" != "" {
		local gaussian gaussian
	}
	if "`lnormal'" != "" {
		local lognormal lognormal
	}
	if "`llogistic'" != "" {
		local loglogistic loglogistic
	}

	gettoken c_F c_ARGS : namelist

	local family	`bernoulli'	///
			`beta'		///
			`binomial'	///
			`exponential'	///
			`gamma'		///
			`gaussian'	///
			`multinomial'	///
			`nbinomial'	///
			`ordinal'	///
			`poisson'	///
			`weibull'	///
			`lognormal'	///
			`loglogistic'	///
			`3pl'		///
			`pointmass'	///
					 // blank

	opts_exclusive "`family'" "family()"

	if "`family'" == "" {
		local family gaussian
	}

	local k : list sizeof args
	if "`family'" == "binomial" {
		if `k' > 1 {
			di as err "option family() invalid;"
			di as err "too many arguments for family `family'"
			exit 198
		}
		if `k' == 0 | `"`args'"' == "1" {
			local family bernoulli
			local args
		}
		else {
			capture confirm number `args'
			if c(rc) == 0 {
				capture confirm integer number `args'
				if c(rc) {
					di as err "option family() invalid;"
					confirm integer number `args'
					exit 7	// [sic]
				}
				if `args' < 1 {
					di as err "option family() invalid;"
					di as err ///
"`args' found where a positive integer value expected"
					exit 125
				}
			}
			else {
				capture unab ARGS : `args'
				if c(rc) {
					di as err "option family() invalid;"
					unab ARGS : `args'
					exit 111	// [sic]
				}
				if `:list sizeof ARGS' > 1 {
					di as err "option family() invalid;"
					di as err ///
"too many arguments for family `family'"
					exit 198
				}
				local args : copy local ARGS
			}
		}
	}
	else if "`family'" == "nbinomial" {
		if `k' > 1 {
			di as err "option family() invalid;"
			di as err "too many arguments for family `family'"
			exit 198
		}
		if `k' == 0 {
			local args mean
		}
		local 0 `", `args'"'
		capture syntax [, Mean Constant]
		if c(rc) {
			di as err "option family() invalid;"
			di as err "invalid argument for family `family'"
			syntax [, Mean Constant]
			exit 198	// [sic]
		}
		local args `mean' `constant'
	}
	else if "`family'" == "pointmass" {
		if `k' > 1 {
			di as err "option family() invalid;"
			di as err "too many arguments for family `family'"
			exit 198
		}
		if `k' == 0 {
			di as err "option family(`family') invalid;"
			di as err "nothing found where integer value expected"
			exit 198
		}
		capture confirm integer number `args'
		if c(rc) {
			di as err "option family(`family') invalid;"
			confirm integer number `args'
			exit 7	// [sic]
		}
	}
	else {
		if `k' {
			di as err "option family() invalid;"
			di as err "arguments not allowed with family `family'"
			exit 198
		}
	}

	local survlist	gamma		///
			exponential	///
			weibull		///
			lognormal	///
			loglogistic
	local k : list sizeof opts
	if "`family'" == "gaussian" {
		gsem_parse_gauss_args, `opts'
		local opts `"`s(fargs)'"'
	}
	else if "`family'" == "poisson" {
		gsem_parse_poisson_args, `opts'
		local opts `"`s(fargs)'"'
	}
	else if `: list family in survlist' {
		gsem_parse_st_args `family', `opts'
		local opts `"`s(fargs)'"'
	}
	else {
		if `k' {
			di as err "option family() invalid;"
			di as err "suboptions not allowed with family `family'"
			exit 198
		}
	}

	c_local `c_F' `family'
	if "`opts'" != "" {
		c_local `c_ARGS' `args' , `opts'
	}
	else {
		c_local `c_ARGS' `args'
	}
end

program ParseLink
	gettoken family 0 : 0
	syntax namelist			///
		[,	CLOGlog		///
			IDentity	///
			LOG		///
			LOGIt		///
			PROBit		///
			args(string)	///
		]

	gettoken c_L c_ARGS : namelist

	local k : list sizeof args
	local noargs 1
	if "`family'" == "bernoulli" {
		local LINK	logit		/// default
				cloglog		///
				probit		///
						 // blank
	}
	else if "`family'" == "beta" {
		local LINK	logit		/// default
				cloglog		///
				probit		///
						 // blank
	}
	else if "`family'" == "binomial" {
		local LINK	logit		/// default
				cloglog		///
				probit		///
						 // blank
	}
	else if "`family'" == "exponential" {
		local LINK	log		/// default
						 // blank
	}
	else if "`family'" == "gamma" {
		local LINK	log		/// default
						 // blank
	}
	else if "`family'" == "gaussian" {
		local LINK	identity	/// default
				log		///
						 // blank
	}
	else if "`family'" == "multinomial" {
		local LINK	logit		/// default
						 // blank
	}
	else if "`family'" == "nbinomial" {
		local LINK	log		/// default
						 // blank
	}
	else if "`family'" == "ordinal" {
		local LINK	logit		/// default
				cloglog		///
				probit		///
						 // blank
	}
	else if "`family'" == "poisson" {
		local LINK	log		/// default
						 // blank
	}
	else if "`family'" == "weibull" {
		local LINK	log		/// default
						 // blank
	}
	else if "`family'" == "lognormal" {
		local LINK	log		/// default
						 // blank
	}
	else if "`family'" == "loglogistic" {
		local LINK	log		/// default
						 // blank
	}
	else if "`family'" == "3pl" {
		local LINK	logit		/// default
				identity	///
						 // blank
	}
	else if "`family'" == "pointmass" {
		local LINK	identity	/// default
						 // blank
	}
	if `noargs' {
		if `k' {
			di as err "option link() invalid;"
			di as err "arguments not allowed with link `link'"
			exit 198
		}
	}

	local link	`cloglog'	///
			`identity'	///
			`log'		///
			`logit'		///
			`probit'	///
			`ph'		///
					 // blank

	local rest : list link - LINK

	if `: list sizeof rest' {
		gettoken link : rest
		di as err "link `link' is not allowed with family `family'"
		exit 198
	}

	opts_exclusive "`link'" "link()"

	if "`link'" == "" {
		gettoken link : LINK
	}
	c_local `c_L' `link'
	c_local `c_ARGS' `args'
end
exit
