*! version 1.0.1  11sep2015

program mswitch_estat
	version 14.0

	if ("`e(cmd)'"!="mswitch") {
		di as err "{p 0 8 2}{bf:estat `0'} only works after"
	     	di as err "{bf:mswitch}{p_end}"
		exit 198
	}
	_parse comma ecmd rhs : 0

	if (`e(states)'==1 & ("`ecmd'"=="transition" | "`ecmd'"=="duration")) {
		di as err "{p 0 8 2}estat `ecmd' is not appropriate for a model"
		di as err "with one state{p_end}"
		exit 198
	}
	if ("`ecmd'"=="transition") _mktransition `rhs'
	else if ("`ecmd'"=="duration") _mkduration `rhs'
	else estat_default `0'

end


program _mktransition, rclass
	syntax [, Level(cilevel)]

	di _n as txt "Number of obs = " as res %-12.0gc `e(N)'

	local eqlist
	tempname est_mat
	mat `est_mat' = J(`e(states)'*`e(states)',4,.)
	local partderiv= `e(num_reg)'-1
	if (`"`partderiv'"'=="0") local partderiv 1
	local cnt = 0
	forvalues i=1/`e(states)' {
		local pij
		local den 1
		forvalues j=1/`e(num_reg)' {
			local den `den'+exp(-@`j')
			local pij `pij' p`i'`j'
		}
		forvalues k=1/`e(states)' {
			local eqlist `eqlist' p`i'`k'
			local cnt = `cnt' + 1

			local func exp(-@`k')/(`den')
			if (`k'==`e(states)') local func 1/(`den')
			local fderiv

			forvalues l=1/`e(num_reg)' {
if (`k'==`l')			local fd (-exp(-@`l')*(`den'-exp(-@`l')))
else if (`k'==`e(states)')	local fd exp(-@`l')
else 				local fd (exp(-@`k')*exp(-@`l'))
local fderiv `fderiv' `fd'/(`den')^2
			}

			if (`e(states)'==2) {
				if (`k'==2) {
					local func 1/(1+exp(-@))
					local fderiv -exp(-@)/(1+exp(-@))^2
				}
				else {
					local func exp(-@)/(1+exp(-@))
					local fderiv exp(-@)/(1+exp(-@))^2
				}
			}
			_diparm `pij', f(`func') d(`fderiv') ci(logit) notab /*
			*/ level(`level')
			mat `est_mat'[`cnt',1] = r(est)
			mat `est_mat'[`cnt',2] = r(se)
			mat `est_mat'[`cnt',3] = r(lb)
			mat `est_mat'[`cnt',4] = r(ub)


			tempname ci`cnt'
			matrix `ci`cnt'' = `est_mat'[`cnt',3..4]
			mat colnames `ci`cnt'' = ll ul
			mat rownames `ci`cnt'' = p`i'`k'
			return matrix ci`cnt' = `ci`cnt''
			return local label`cnt' = "p`i'`k'"
			local probcols `probcols' p`i'`k'

		}
	}


                                /* Set transition probabilities table class */
	tempname probobj

	.`probobj' = ._tab.new, col(5) lmargin(0)
	.`probobj'.width 29 | . . . .
	.`probobj'.titlefmt . . . %24s .
	.`probobj'.pad . 2 1 3 3
	.`probobj'.numfmt . %9.0g %9.0g %9.0g %9.0g
	.`probobj'.sep, top
	.`probobj'.titles "Transition Probabilities"			///
			"Estimate"					/// 
			"Std. Err."					/// 
			"[`level'% Conf. Interval]" ""

	local _nprobs = `e(states)'*`e(states)'
	local cnt 0
	tempname prob se
	mat `prob' = J(1,`_nprobs',.)
	mat `se' = J(1,`_nprobs',.)
	forvalues i = 1/`_nprobs' {
		local cnt = `cnt'+1
		local name: word `i' of `eqlist'
		.`probobj'.sep
		.`probobj'.strcolor result  .  .  .  .
		.`probobj'.strfmt    %-12s  .  .  .  .
		.`probobj'.strcolor   text  .  .  .  .
		.`probobj'.strfmt     %28s  .  .  .  .
		.`probobj'.row    "`name'"                              ///
				`est_mat'[`cnt',1]                      ///
				`est_mat'[`cnt',2]                      ///
				`est_mat'[`cnt',3]                      ///
				`est_mat'[`cnt',4]
		mat `prob'[1,`i'] = `est_mat'[`cnt',1]
		mat `se'[1,`i'] = `est_mat'[`cnt',2]
	}
	mat colnames `prob' = `probcols'
	mat rownames `prob' = prob
	return matrix prob = `prob'
	mat colnames `se' = `probcols'
	mat rownames `se' = se
	return matrix se = `se'
	return scalar level = `level'

	.`probobj'.sep, bot

end



program _mkduration, rclass
	syntax [, Level(cilevel)]

	di _n as txt "Number of obs = " as res %-12.0gc `e(N)'

	local eqlist
	tempname est_mat
	mat `est_mat' = J(`e(states)',4,.)
	local partderiv = `e(num_reg)'-1
	if (`"`partderiv'"'=="0") local partderiv 1

	
	local cnt = 0
	forvalues i=1/`e(states)' {
		local pij
		local den 1
		forvalues j=1/`e(num_reg)' {
			local den `den'+exp(-@`j')
			local pij `pij' p`i'`j'
		}
		local eqlist `eqlist' State`i'
		local cnt = `cnt' + 1


		local fderiv
		local func (`den')/(`den'-exp(-@`i'))
		if (`i'==`e(states)') local func (`den')/(`den'-1)

		forvalues l=1/`e(num_reg)' {
			if (`i'==`l') {
				local fd -exp(-@`i')/(`den'-exp(-@`i'))
			}
			else if (`i'==`e(states)') {
				local fd exp(-@`l')/(`den'-1)^2
			}
			else {
 				local fd /*
				*/ (exp(-@`i')*exp(-@`l'))/(`den'-exp(-@`i'))^2
			}
			local fderiv `fderiv' `fd'
		}

		if (`e(states)'==2) {
			if (`i'==2) {
				local func (1+exp(-@))/exp(-@)
				local fderiv -1/exp(-@)
			}
			else {
				local func 1+exp(-@)
				local fderiv -exp(-@)

			}
		}
		_diparm `pij', f(`func') d(`fderiv') notab level(`level')

		mat `est_mat'[`cnt',1] = r(est)
		mat `est_mat'[`cnt',2] = r(se)
		mat `est_mat'[`cnt',3] = r(lb)
		mat `est_mat'[`cnt',4] = r(ub)
	}


                                /* Set transition probabilities table class */
	tempname probobj

	.`probobj' = ._tab.new, col(5) lmargin(0)
	.`probobj'.width 29 | . . . .
	.`probobj'.titlefmt . . . %24s .
	.`probobj'.pad . 2 1 3 3
	.`probobj'.numfmt . %9.0g %9.0g %9.0g %9.0g
	.`probobj'.sep, top
	.`probobj'.titles "Expected Duration"				///
			"Estimate"					/// 
			"Std. Err."					/// 
			"[`level'% Conf. Interval]" ""

	local _nprobs = `e(states)'
	local cnt 0
	forvalues i = 1/`_nprobs' {
		tempname ci`i'
		local cnt = `cnt'+1
		local name: word `i' of `eqlist'
		.`probobj'.sep
		.`probobj'.strcolor result  .  .  .  .
		.`probobj'.strfmt    %-12s  .  .  .  .
		.`probobj'.strcolor   text  .  .  .  .
		.`probobj'.strfmt     %28s  .  .  .  .
		.`probobj'.row    "`name'"                              ///
				`est_mat'[`cnt',1]                      ///
				`est_mat'[`cnt',2]                      ///
				`est_mat'[`cnt',3]                      ///
				`est_mat'[`cnt',4]


		return scalar d`i' = `est_mat'[`cnt',1]
		return scalar se`i' = `est_mat'[`cnt',2]
		matrix `ci`i'' = `est_mat'[`cnt',3..4]
		mat colnames `ci`i'' = ll ul
		mat rownames `ci`i'' = duration
		return matrix ci`i' = `ci`i''
		return local label`i' = "State`i'"
	}

	return scalar level = `level'
	.`probobj'.sep, bot


end
