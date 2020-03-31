*! version 1.2.1  22jun2009 (minor change 03jan2017)

/*	
	Applies rules to find perfect predictors in binary choice models.

	Matrix of results is returned in r(rules)
	
	Number of rows in r(rules) = Number of reductions done
	Rowname of r(rules) = variable affected
	
	There are four columns in r(rules)
	
	Column 1: Operator (e.g. is variable > column 2)
			1	Not equal
			2	Greater than
			3	Less than
			4	Variable omitted because of collinearity
			6	Less than or equal

	Column 2: Number on RHS of operator from column 1
	
	Column 3: Various interpretations
			 0	Negative outcome perfectly predicted
			 1	Positive outcome perfectly predicted
			-1	Keep only observations == column 2
			-2	Variable perfectly segments success
				or failure.  Model inestimable, abort.
			
	Column 4: Number of observations dropped
	
*/

program define _binperfect, rclass

	version 8.2

	syntax varlist(min=2 numeric ts) , touse(varname)
	
	local dep : word 1 of `varlist'
	local rest : subinstr local varlist "`dep'" ""
	local capn : word count `rest'
	local final `rest'
	tempname m0 M0 m1 M1
	tokenize `rest'
	local stop = 0
	
	tempname rules
	local x = 1
	while `stop' == 0 {
		tokenize `final'
		summ ``x'' if `dep' == 0 & `touse', meanonly
		scalar `m0' = r(min)
		scalar `M0' = r(max)
		summ ``x'' if `dep' != 0 & `touse', meanonly
		scalar `m1' = r(min)
		scalar `M1' = r(max)
		local restart = 0
		
		/* Rule 1 */
		if `m0' == `M0' & (`m0' == `m1' | `m0' == `M1') {
			qui count if ``x'' != `m0' & `touse'
			mat `rules' = nullmat(`rules') \ 1, `m0', 1, r(N)
			addname `rules' "``x''"
			qui replace `touse' = 0 if ``x'' != `m0'
			local final : subinstr local final "``x''" ""
			local restart = 1
		}
		else if `m1' == `M1' & (`m1' == `m0' | `m1' == `M0') {
			qui count if ``x'' != `m1' & `touse'
			mat `rules' = nullmat(`rules') \ 1, `m1', 0, r(N)
			addname `rules' "``x''"
			qui replace `touse' = 0 if ``x'' != `m1'
			local final : subinstr local final "``x''" ""
			local restart = 1
		}
		/* Rule 2 */
		else if `M0' == `m1' {
			qui count if ``x'' != `M0' & `touse'
			mat `rules' = nullmat(`rules') \ 2, `M0', -1, r(N)
			addname `rules' "``x''"
			qui replace `touse' = 0 if ``x'' != `M0'
			local final : subinstr local final "``x''" ""
			local restart = 1
		}
		else if `M1' == `m0' {
			qui count if ``x'' != `M1' & `touse'
			mat `rules' = nullmat(`rules') \ 3, `M1', -1, r(N)
			addname `rules' "``x''"
			qui replace `touse' = 0 if ``x'' != `M1'
			local final : subinstr local final "``x''" ""
			local restart = 1
		}
		/* Rule 3 */
		else if `M0' < `m1' {
			mat `rules' = nullmat(`rules') \ 2, `M0', -2, 0
			addname `rules' "``x''"
			qui replace `touse' = 0
			local stop = 1
		}
		else if `M1' < `m0' {
			mat `rules' = nullmat(`rules') \ 3, `M1', -2, 0
			addname `rules' "``x''"
			qui replace `touse' = 0
			local stop = 1
		}
		if `restart' == 1 {
			local x = 1
		}
		else {
			local x = `x' + 1
		}
		local capn : word count `final'
		if `x' > `capn' {
			local stop = 1
		}
	}
	
	capture confirm matrix `rules'
	if _rc {
		mat `rules' = J(1,4,0)
	}
	
	return matrix rules = `rules'
end


/* Given a matrix and a string, makes the name of last row==string */
program define addname

        args mat name

        local m = rowsof(`mat')
        local n : rownames(`mat')
        local old : word `m' of `n' 
        local new : subinstr local n "`old'" "`name'", word
        mat rownames `mat' = `new'

end

