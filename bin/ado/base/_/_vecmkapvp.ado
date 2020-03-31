*! version 1.0.0  16jul2004
program define _vecmkapvp
	version 8.0

	args newmat rank pm1 k tterms

	confirm name `newmat'

	tempname v

	mat `v' = e(V)

	local newsize = `k'*`rank' + `pm1'*`k'^2
	
	mat `newmat' = J(`newsize', `newsize', 0)


	local z = `rank' + `pm1'*`k' + `tterms'

	local off = `k'*`rank'

// put in vec(alpha) block

	forvalues ir = 1/`k' {
		forvalues jr = 1/`rank' {
		
			local newrow = (`ir' - 1)*(`rank'+`pm1'*`k') + `jr'

			local oldrow = (`ir'-1)*`z' + `jr'

			forvalues ic = 1/`k' {
				forvalues jc = 1/`rank' {
local newcol = (`ic' - 1)*(`rank'+`pm1'*`k') + `jc'
local oldcol = (`ic'-1)*`z' + `jc'
mat `newmat'[`newrow',`newcol'] = `v'[`oldrow', `oldcol']
				}
			}	


			forvalues ic = 1/`k' {
				forvalues jc = 1/`k' {
					forvalues mc = 1/`pm1' {
local oldcol = `rank' + (`ic'-1)*`z' + (`jc'-1)*`pm1' + `mc'
local newcol = `ic'*`rank' + (`ic'-1)*`pm1'*`k' + (`mc'-1)*`k' + `jc'

mat `newmat'[`newrow',`newcol'] = `v'[`oldrow', `oldcol']
mat `newmat'[`newcol',`newrow'] = `v'[`oldrow', `oldcol']
					}
				}
			}


		}
	}

	forvalues ir = 1/`k' {
		forvalues jr = 1/`k' {
			forvalues mr = 1/`pm1' {

				local oldrow = `rank' + (`ir'-1)*`z' +	///
					(`jr'-1)*`pm1' + `mr'

				local newrow = `ir'*`rank' + 		///
					(`ir'-1)*`pm1'*`k' +		///
					(`mr'-1)*`k' + `jr'

				forvalues ic = 1/`k' {
					forvalues jc = 1/`k' {
						forvalues mc = 1/`pm1' {
local oldcol = `rank' + (`ic'-1)*`z' + (`jc'-1)*`pm1' + `mc'
local newcol = `ic'*`rank' + (`ic'-1)*`pm1'*`k' + (`mc'-1)*`k' + `jc'

mat `newmat'[`newrow',`newcol'] = `v'[`oldrow', `oldcol']
						}
					}
				}
			}
		}
	}

end

exit

syntax _vecmkapvp  {it:newmat} rank pm1 k tterms

where

	newmat is name for new matrix 

	rank is the rank of the cointegrating space

	pm1 = (p-1) where p is the number of lags in the underlying VAR

	k = number of endogenous variables 

	tterms is the number of trend terms in the model
	

This program translates the VCE in e(V) from the VECM format to 

	cov(vec(\alpha), vec( Gamma_1 \ Gamma_2 \ ... Gamma_{p-1}) )


