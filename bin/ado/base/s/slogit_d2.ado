*! version 1.1.1  26oct2009
program slogit_d2
        version 9

        args todo b lnf g negH $STEREO_dv

        tempvar lf
	tempname theta
quietly {
	local lev : word 1 of $STEREO_levels
	local k = colnumb(`b',"theta`lev':")
	matrix `theta' = `b'[1,`k'...]
	local ncut = colsof(`theta')
	forvalues i = 1/`ncut' {
		tempname p`i'
		gen double `p`i'' = el(`theta',1,`i')
		local exblist "`exblist' `p`i''"
	}
	/* likelihood */
	forvalues dm = $STEREO_dim(-1)1 {
		tempvar xb`dm'
		tempname phi`dm'

		mleval `xb`dm'' = `b', eq(`dm')
		local j = colnumb(`b',"phi`dm'_`lev':")
		matrix `phi`dm'' = `b'[1,`j'..`k'-1]
		assert colsof(`phi`dm'') == `ncut'
		local k = `j'

		forvalues i = 1/`ncut' {
			replace `p`i'' = `p`i'' - el(`phi`dm'',1,`i')*`xb`dm''
		}
	}
	local ncp1 = `ncut'+1
	tempname denom p`ncp1'

	gen double `denom' = 1.0
	forvalues i = 1/`ncut' {
		replace `p`i'' = exp(`p`i'')
		replace `denom' = `denom'+`p`i''
	}

	gen double `p`ncp1'' = 1.0
	gen double `lf' = 0.0
	forvalues i = 1/`ncp1' {
		local lev : word `i' of $STEREO_levels
		replace `p`i'' = `p`i''/`denom'
		replace `lf' = log(`p`i'') if $STEREO_resp == `lev'
	}

	mlsum `lnf' = `lf'
	if `todo' <= 0 { 
		exit 0
	}
	/* gradient */
$ML_ec	tempname g1 d
	local eq = $STEREO_dim

	forvalues dm = 1/$STEREO_dim {
		replace `dbv`dm'' = 0.0
		forvalues i=1/`ncut' {
			local lev : word `i' of $STEREO_levels
			replace `dpv`dm'`i'' = cond($STEREO_resp==`lev',(`p`i''-1.0)* ///
				`xb`dm'',`p`i''*`xb`dm'')
			
			replace `dbv`dm'' = `dbv`dm'' + el(`phi`dm'',1,`i')* ///
				cond($STEREO_resp==`lev',`p`i''-1.0,`p`i'')
		}
		if `dm' == 1 {
$ML_ec			mlvecsum `lnf' `g' = `dbv1', eq(1)
		}
		else {
$ML_ec			mlvecsum `lnf' `d' = `dbv`dm'', eq(`dm')
$ML_ec			matrix `g' = (`g',`d')
		}
		forvalues i=1/`ncut' {
$ML_ec			mlvecsum `lnf' `d' = `dpv`dm'`i'', eq(`++eq')
$ML_ec			matrix `g1' = (nullmat(`g1'),`d')
		}
	}	
$ML_ec	matrix `g' = (`g',`g1')

	local eq = $STEREO_dim*`ncut'
	forvalues i=1/`ncut' {
		local lev : word `i' of $STEREO_levels
		replace `dtv`i'' = cond($STEREO_resp==`lev',1.0-`p`i'',-`p`i'')
$ML_ec		mlvecsum `lnf' `d' = `dtv`i'', eq(`++eq')
$ML_ec		matrix `g' = (`g',`d')
	}
	if `todo' <= 1 {
		exit 0
	}
	/* negative hessian */
	tempname phi dd 
	tempvar yeqi ppp xdxj
	local p = colsof(`b') 
	matrix `negH' = J(`p',`p',0.0)
	gen double `yeqi' = 0.0
	gen double `ppp'  = 0.0
	gen double `xdxj' = 0.0
	forvalues dm = 1/$STEREO_dim {
		tempname pp`dm' 
		gen double `pp`dm'' = 0.0
		replace `ppp' = 0.0		
		local eq = $STEREO_dim+(`dm'-1)*`ncut'+1
		local k  = $STEREO_dim*$STEREO_nreg+(`dm'-1)*`ncut'+1
		forvalues i=1/`ncut' {
			scalar `phi' = el(`phi`dm'',1,`i')
			replace `pp`dm'' = `pp`dm'' + `p`i''*`phi'
			replace `ppp' = `ppp' + `p`i''*`phi'*`phi'
			/* d phi(dm,i) d phi(dm,i) */
			mlmatsum `lnf' `dd' = `xb`dm''*`xb`dm''*`p`i''*(1.0-`p`i''), ///
				eq(`eq',`eq')
			matrix `negH'[`k',`k'] = `dd'

			local ip1 = `i' + 1
			local eqp = `eq' + 1
			local kp  = `k' + 1
			forvalues j=`ip1'/`ncut' {
				/* d phi(dm,i) d phi(dm,j) */
				mlmatsum `lnf' `dd' = -`xb`dm''*`xb`dm''*`p`i''*`p`j'', ///
					eq(`eq',`eqp++')
				matrix `negH'[`k',`kp'] = `dd'
				matrix `negH'[`kp++',`k'] = `dd'
			}
			local eqt = $STEREO_dim*(1+`ncut')+1
			local kt  = $STEREO_dim*($STEREO_nreg+`ncut')+1
			forvalues j=1/`ncut' {
				/* d phi(dm,i) d theta(j) */
				if `j' == `i' {
					mlmatsum `lnf' `dd' = -`xb`dm''*`p`i''*(1.0-`p`i''), ///
						eq(`eq',`eqt++')
				}
				else {
					mlmatsum `lnf' `dd' = `xb`dm''*`p`i''*`p`j'', ///
						eq(`eq',`eqt++')
				}
				matrix `negH'[`kt',`k'] = `dd'
				matrix `negH'[`k',`kt++'] = `dd'
			}
			local eq = `eq' + 1
			local k = `k' + 1
		}
		/* d xb(dm) d xb(dm) */
		mlmatsum `lnf' `dd' = `ppp'-`pp`dm''*`pp`dm'', eq(`dm',`dm')
		local kx = (`dm'-1)*$STEREO_nreg+1
		matrix `negH'[`kx',`kx'] = `dd'

		local eqt = $STEREO_dim*(1+`ncut')+1
		local kt  = $STEREO_dim*($STEREO_nreg+`ncut')+1
		local eq = $STEREO_dim+(`dm'-1)*`ncut'+1
		local k  = $STEREO_dim*$STEREO_nreg+(`dm'-1)*`ncut'+1

		forvalues i=1/`ncut' {
			local lev : word `i' of $STEREO_levels
			replace `yeqi' = $STEREO_resp == `lev'
			/* d xb(dm) d phi(dm,i) */
			mlmatsum `lnf' `dd' = `p`i''*`xb`dm''*(el(`phi`dm'',1,`i')-`pp`dm'') - ///
				`p`i'' + `yeqi', eq(`dm',`eq++')
			matrix `negH'[`kx',`k'] = `dd'
			matrix `negH'[`k++',`kx'] = `dd''

			/* d xb(dm) d theta(i) */
			mlmatsum `lnf' `dd' = `p`i''*(`pp`dm''-el(`phi`dm'',1,`i')), ///
				eq(`dm',`eqt++')
			matrix `negH'[`kx',`kt'] = `dd'
			matrix `negH'[`kt++',`kx'] = `dd''
		}
		local dm1 = `dm'-1
		local kx1 = 1 

		forvalues j = 1/`dm1' {
			local eq = $STEREO_dim+(`dm'-1)*`ncut'+1
			local k  = $STEREO_dim*$STEREO_nreg+(`dm'-1)*`ncut'+1

			forvalues i=1/`ncut' {
				/* d xb(j) d phi(dm,i) */
				mlmatsum `lnf' `dd' = `p`i''*`xb`dm''*(-`pp`j''+ ///
					el(`phi`j'',1,`i')), eq(`j',`eq++')
				matrix `negH'[`kx1',`k'] = `dd'
				matrix `negH'[`k++',`kx1'] = `dd''
			}

			local kx1 = `kx1' + $STEREO_nreg
		}
		local kx1 = `kx' - $STEREO_nreg

		forvalues j = `dm1'(-1)1 {
			replace `ppp' = 0.0
			forvalues i=1/`ncut' {
				replace `ppp' = `ppp'+`p`i''*el(`phi`dm'',1,`i')* ///
					el(`phi`j'',1,`i')
			}
			/* d xb(dm) d xb(j) */
			mlmatsum `lnf' `dd' = `ppp'-`pp`dm''*`pp`j'', eq(`dm',`j')
			matrix `negH'[`kx',`kx1'] = `dd'
			matrix `negH'[`kx1',`kx'] = `dd''

			local eq = $STEREO_dim+(`j'-1)*`ncut'+1
			local k  = $STEREO_dim*$STEREO_nreg+(`j'-1)*`ncut'+1

			replace `xdxj' = `xb`dm''*`xb`j''
			forvalues i=1/`ncut' {
				local eqp = $STEREO_dim+(`dm'-1)*`ncut'+1
				local kp  = $STEREO_dim*$STEREO_nreg+(`dm'-1)*`ncut'+1
				forvalues l=1/`ncut' {
					/* d phi(dm,l) d phi(j,i) */
					if `i' == `l' {
						mlmatsum `lnf' `dd' = `xdxj'*`p`i''*(1.0-`p`i''), ///
							eq(`eqp++',`eq')
					}
					else {
						mlmatsum `lnf' `dd' = -`xdxj'*`p`i''*`p`l'', ///
							eq(`eqp++',`eq')
					}
					matrix `negH'[`kp',`k'] = `dd'
					matrix `negH'[`k',`kp++'] = `dd'
				}

				/* d xb(dm) d phi(j,i) */
				mlmatsum `lnf' `dd' = `p`i''*`xb`j''*(-`pp`dm''+el(`phi`dm'',1,`i')), ///
					eq(`dm',`eq++')
				matrix `negH'[`kx',`k'] = `dd'
				matrix `negH'[`k++',`kx'] = `dd''
			}

			local kx1 = `kx1' - $STEREO_nreg
		}
	}
	local eq = $STEREO_dim*(1+`ncut')+1
	local k  = $STEREO_dim*($STEREO_nreg+`ncut')+1
	forvalues i=1/`ncut' {
		/* d theta(i) d theta(i) */
		mlmatsum `lnf' `dd' = `p`i''*(1.0-`p`i''), eq(`eq',`eq')
		matrix `negH'[`k',`k'] = `dd'
		local e1  = `eq'+1
		local k1  = `k'+1
		local ip1 = `i'+1
		forvalues j = `ip1'/`ncut' {
			/* d theta(i) d theta(j) */
			mlmatsum `lnf' `dd' = -`p`i''*`p`j'', eq(`eq',`e1++')
			matrix `negH'[`k',`k1'] = `dd'
			matrix `negH'[`k1++',`k'] = `dd'
		}
		local eq  = `eq'+1
		local k   = `k'+1
	}
}
end

