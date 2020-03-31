*! version 1.0.1  11mar2019

program _bayespredict_notfound
	version 16.0
	args param estfile cmd	
	if `"`cmd'"' == "bayespredict" {
		di as err `"{p 4 4 2}The specified prediction dataset, {bf:`estfile'}, "' ///
		`"does not contain results for {bf:`param'}. You must use "' ///
		`"{manhelp bayespredict BAYES} to generate {bf:`param'} "' ///
		`"and to save it in a prediction dataset.{p_end}"'
	}
	else {
		di as err `"{p 4 4 2}The specified prediction dataset, {bf:`estfile'}, "' ///
		`"does not contain results for {bf:`param'}. You must use "' ///
		`"{manhelp bayespredict BAYES} to generate {bf:`param'} "' ///
		`"and to save it in a prediction dataset. "' ///
		`"If {bf:`param'} is a model parameter, you should specify it in "' ///
		`"a separate call to {bf:`cmd'}. You may not specify "' ///
		`"model parameters and Bayesian predictions in one command statement.{p_end}"'
	}
end
