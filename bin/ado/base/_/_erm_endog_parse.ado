*! version 1.1.1  20feb2019
program _erm_endog_parse, sclass
	version 15
	syntax, EQuation(string) 
	_erm_parse_equation, equation(`equation') 			///
		fnequation("endogenous variable") 			///
		nequation("endogenous")					///
		ndepvar("endogenous variables")				///
		nindepvars("regressors for endogenous variables")	///
		plural extraopts(					///
		"PROBit OPROBit noMain POVARiance POCORRelation noRE")
	if "`s(offset)'" != "" {
		di as error ///
		"{p 0 4 2}invalid specification of {bf:endogenous()};"
		di as error "option {bf:offset()} not allowed{p_end}"
		exit 198
	}
	if "`s(probit)'`s(oprobit)'" == "" & "`s(pocorrelation)'" != "" {
		di as error ///
			"{p 0 4 2}invalid specification of {bf:endogenous()}; "
		di as error ///
			"option {bf:pocorrelation} not allowed when "
		di as error "endogenous variable is not categorical{p_end}"
		exit 198
	}
	if "`s(probit)'`s(oprobit)'" == "" & "`s(povariance)'" != "" {
		di as error ///
			"{p 0 4 2}invalid specification of {bf:endogenous()}; "
		di as error ///
			"option {bf:povariance} not allowed when "
		di as error "endogenous variable is not categorical{p_end}"
		exit 198
	}
	if "`s(indepvars)'" == "" {
		di as error ///
			"{p 0 4 2}invalid specification of {bf:endogenous()}; "
		di as error "no instruments specified for `s(depvar)'{p_end}"
		exit 198
	}	
end
exit
