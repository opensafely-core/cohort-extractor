*! version 1.0.4  11mar2019
program _mcmc_paramnotfound
	args param baselevel allowpredictions
if "`baselevel'" != "" {
	di as err `"{p}parameter {bf:{c -(}`param'{c )-}} not allowed{p_end}"'
	di as err "{p 4 4 2}There is no simulation data available for "
	di as err "base-level and omitted parameters."
	di as err "{p_end}"
	exit 498
}
else {
	di as err `"{p}parameter {bf:{c -(}`param'{c )-}} not found{p_end}"'
/*
	di as err "{p 4 4 2}If you are specifying a function of parameters,"
	di as err "remember to enclose it in parentheses.  "
	di as err "If you are referring to regression coefficients, remember to "
	di as err "include the name of the corresponding dependent variable "
	di as err "as an equation label.  If you are referring "
	di as err "to equation labels or parameter names of regression"
	di as err "coefficients, remember to specify full variable names;"
	di as err "abbreviations are not allowed. If you are using"
	di as err "the {bf:bayes} prefix, you can specify option {bf:dryrun}"
	di as err "to see the names of model parameters."
	di as err "{p_end}"
*/
	di as err "{p 4 4 2}1. If you are referring to regression coefficients, remember to include the name of the corresponding dependent variable as an equation label.{p_end}"
	di as err ""
	di as err "{p 4 4 2}2. If you are referring to equation labels or parameter names of regression coefficients, remember to specify full variable names; abbreviations are not allowed. If you fit your model using the bayes prefix, you can specify option dryrun to see the names of model parameters.{p_end}"
	di as err ""
	di as err "{p 4 4 2}3. If you are specifying a function of parameters, remember to enclose it in parentheses.{p_end}"
	if `"`allowpredictions'"' != "" {
		di as err ""
		di as err "{p 4 4 2}4. If you are specifying prediction quantities, remember to provide a prediction dataset with the {bf:using} specification, {bf:using} {it:predfile}.{p_end}"
	}
	exit 198
}
end
