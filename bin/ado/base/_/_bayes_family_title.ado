*! version 1.0.0  06dec2017

program _bayes_family_title, rclass

	args family
	gettoken cnames family : family	

	if "`cnames'" == "Binomial" {
		local cnames binomial 
	}
	else if "`cnames'" == "Inverse" {
		local cnames inverse
	}
	else if "`cnames'" == "Gamma" {
		local cnames gamma
	}
	else if "`cnames'" == "bernoulli" {
		local cnames Bernoulli
	}
	else if "`cnames'" == "gaussian" {
		local cnames Gaussian
	}
	else if "`cnames'" == "poisson" {
		local cnames Poisson
	}

	local result = "`cnames'" + "`family'"
 
	if "`cnames'" == "Neg." {
		local result negative binomial
	}

	ret local cnames `result'	
end
