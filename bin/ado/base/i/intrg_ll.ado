*! version 2.2.0  18jun2009
program define intrg_ll /* maximized in b = beta/sigma, s = 1/sigma */
	version 6
	args todo b lnf g H g1 g2

	tempname s 
	tempvar  xb phi se dseds ln2ps

	mleval `xb' = `b', eq(1)
	mleval `s'  = `b', eq(2) scalar

	if `s' < 0 {
		scalar `s' = -`s'
		matrix `b'[1,colsof(matrix(`b'))] = `s'
	}

	qui gen double `se' = `s'
	qui gen double `dseds' = 1
	if("$ML_wtyp"=="aweight") {
		qui replace `dseds' = sqrt($ML_w)
		qui replace `se' = `se'*`dseds'
		qui replace `xb' = `xb'*`dseds'
	}

	local y1 $ML_y1
	local y2 $ML_y2
	local z1 (`se'*`y1'-`xb')
	local z2 (`se'*`y2'-`xb')

/* Check if we will have normprob() == 0.
   Note: normprob(-37) = 6e-300, normprob(-38) = 0.
*/
	local bad 37 /* also set in Int0_ll below */

	capture assert !(`y1'!=.&`z1'>`bad' | `y2'!=.&`z2'<-`bad') /*
	*/ if $ML_samp & `y1'!=`y2'

	global S_BADLC /* erase macros which may have been set by Int0ll */
	global S_BADRC
        if _rc { /* normprob() == 0 */
		Int0_ll `todo' `lnf' `g' `H' `g1' `g2' `xb' `se' `dseds'
		exit
	}

	quietly {
		gen double `phi' = cond(`y1'!=.&`y2'!=., /*
		*/ cond(`z1'>0,normprob(-`z1')-normprob(-`z2'), /*
		*/             normprob(`z2') -normprob(`z1')), /*
		*/ cond(`y2'!=.,normprob(`z2'),normprob(-`z1'))) /*
		*/ if $ML_samp & `y1'!=`y2'

	 	gen double `ln2ps' = -0.5*ln(2*_pi) + ln(`se') 

		mlsum `lnf' = cond(`y1'==`y2',-`z1'^2/2+`ln2ps',ln(`phi')) /*
			*/    / (`dseds' * `dseds') 

		if `todo' == 0 | `lnf'==. { exit }

$ML_ec		tempname d1 d2

local dphi  (cond(`y2'!=.,normd(`z2'),0)-cond(`y1'!=.,normd(`z1'),0))
local ydphi (cond(`y2'!=.,`y2'*normd(`z2'),0)-cond(`y1'!=.,`y1'*normd(`z1'),0))
local zdphi (cond(`y2'!=.,`z2'*normd(`z2'),0)-cond(`y1'!=.,`z1'*normd(`z1'),0))

		replace `g1' = cond(`y1'==`y2',`z1',-`dphi'/`phi') /*
		*/ / `dseds' if $ML_samp
		replace `g2' = cond(`y1'==`y2',-`y1'*`z1'+1/`se', /*
		*/ `ydphi'/`phi') / `dseds' if $ML_samp

$ML_ec		mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec		mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec		mat `g' = (`d1',`d2')

		if `todo' == 1 | `lnf'==. { exit }

		tempname d11 d12 d22

		mlmatsum `lnf' `d11' = cond(`y1'==`y2',1, /*
		*/ (`zdphi'+`dphi'^2/`phi')/`phi'), eq(1)

		mlmatsum `lnf' `d12' = -cond(`y1'==`y2',`y1', /*
		*/ ( cond(`y2'!=.,`y2'*`z2'*normd(`z2'),0) /*
		*/ - cond(`y1'!=.,`y1'*`z1'*normd(`z1'),0) /*
		*/ + `dphi'*`ydphi'/`phi')/`phi'), eq(1,2)

		mlmatsum `lnf' `d22' = cond(`y1'==`y2',`y1'^2+1/`se'^2, /*
		*/ ( cond(`y2'!=.,`y2'^2*`z2'*normd(`z2'),0) /*
		*/ - cond(`y1'!=.,`y1'^2*`z1'*normd(`z1'),0) /*
		*/ + `ydphi'^2/`phi')/`phi'), eq(2)

		mat `H' = (`d11',`d12' \ `d12'',`d22')
	}
end

program define Int0_ll
	args todo lnf g H g1 g2 xb se dseds

	tempvar  BADLC BADRC phi lnphi ln2ps

	local y1  $ML_y1
	local y2  $ML_y2
	local z1  (`se'*`y1'-`xb')
	local z2  (`se'*`y2'-`xb')
	local bad 37 /* also set in main routine above */

	quietly {
		gen byte `BADLC' = ($ML_samp&`y1'!=`y2'&`y2'!=.&`z2'<-`bad')
		gen byte `BADRC' = ($ML_samp&`y1'!=`y2'&`y1'!=.&`z1'>`bad')

		count if `y1'!=. & `y2'!=. & `BADLC'
		if r(N) > 0 {
			global S_BADLC `r(N)' /* # of "bad" intervals */
		}
		count if `y1'!=. & `y2'!=. & `BADRC'
		if r(N) > 0 {
			global S_BADRC `r(N)' /* # of "bad" intervals */
		}
				/* Note: "Bad" intervals (i.e., intervals with
				   both endpoints <-`bad' or >`bad) are handled
				   as bad left-censored or bad right-censored
				   observations.  This is an excellent
				   approximation for wide intervals, but only a
				   fair approximation for narrow intervals;
				   hence, we issue a warning if they occur at
				   the FINAL iteration.  Implementing a good
				   asymptotic approximation for narrow intervals
				   would be difficult.
				*/

		gen double `phi' = cond(`y1'!=.&`y2'!=., /*
		*/ cond(`z1'>0,normprob(-`z1')-normprob(-`z2'), /*
		*/             normprob(`z2') -normprob(`z1')), /*
		*/ cond(`y2'!=.,normprob(`z2'),normprob(-`z1'))) /*
		*/ if $ML_samp & `y1'!=`y2'

		gen double `lnphi' = ln(`phi')

		Lnphi replace `lnphi'  `z2' if `BADLC'
		Lnphi replace `lnphi' -`z1' if `BADRC'

		gen double `ln2ps' = -0.5*ln(2*_pi) + ln(`se')

		mlsum `lnf' = cond(`y1'==`y2',-`z1'^2/2+`ln2ps',`lnphi') /*
		*/	     / (`dseds' * `dseds')

		if `todo' == 0 | `lnf'==. { exit }

$ML_ec		tempname d1 d2

local dphi  (cond(`y2'!=.,normd(`z2'),0)-cond(`y1'!=.,normd(`z1'),0))
local ydphi (cond(`y2'!=.,`y2'*normd(`z2'),0)-cond(`y1'!=.,`y1'*normd(`z1'),0))
local zdphi (cond(`y2'!=.,`z2'*normd(`z2'),0)-cond(`y1'!=.,`z1'*normd(`z1'),0))

		tempvar mills
		Mills "gen double" `mills'  `z2' if `BADLC'
		Mills replace      `mills' -`z1' if `BADRC'

		replace `g1' = cond(`y1'==`y2',`z1', /*
		*/ cond(`BADLC',-`mills',cond(`BADRC',`mills', /*
		*/ -`dphi'/`phi'))) / `dseds' if $ML_samp

		replace `g2' = cond(`y1'==`y2',-`y1'*`z1'+1/`se', /*
		*/ cond(`BADLC',`y2'*`mills',cond(`BADRC',-`y1'*`mills', /*
		*/ `ydphi'/`phi'))) / `dseds' if $ML_samp

$ML_ec		mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec		mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec		mat `g' = (`d1',`d2')

		if `todo' == 1 | `lnf'==. { exit }

		tempname d11 d12 d22

		mlmatsum `lnf' `d11' = cond(`y1'==`y2',1, /*
		*/ cond(`BADLC',`mills'*(`z2'+`mills'), /*
		*/ cond(`BADRC',`mills'*(-`z1'+`mills'), /*
		*/ (`zdphi'+`dphi'^2/`phi')/`phi'))), eq(1)

		mlmatsum `lnf' `d12' = -cond(`y1'==`y2',`y1', /*
		*/ cond(`BADLC',`y2'*`mills'*(`z2'+`mills'), /*
		*/ cond(`BADRC',`y1'*`mills'*(-`z1'+`mills'), /*
		*/ ( cond(`y2'!=.,`y2'*`z2'*normd(`z2'),0) /*
		*/ - cond(`y1'!=.,`y1'*`z1'*normd(`z1'),0) /*
		*/ + `dphi'*`ydphi'/`phi')/`phi'))), eq(1,2)

		mlmatsum `lnf' `d22' = cond(`y1'==`y2',`y1'^2+1/`se'^2, /*
		*/ cond(`BADLC',`y2'^2*`mills'*(`z2'+`mills'), /*
		*/ cond(`BADRC',`y1'^2*`mills'*(-`z1'+`mills'), /*
		*/ ( cond(`y2'!=.,`y2'^2*`z2'*normd(`z2'),0) /*
		*/ - cond(`y1'!=.,`y1'^2*`z1'*normd(`z1'),0) /*
		*/ + `ydphi'^2/`phi')/`phi'))), eq(2)

		mat `H' = (`d11',`d12' \ `d12'',`d22')
	}
end

program define Lnphi /* `y' = ln(normprob(`x')) as `x'->-inf */
	gettoken gen 0 : 0
	gettoken y   0 : 0
	gettoken x   0 : 0
	local x (`x')
	tempname sqrt2pi
	scalar `sqrt2pi' = sqrt(2*_pi)
	qui `gen' `y' = -(0.5*`x'^2+ln(`sqrt2pi'*(-`x')) /*
	*/ +(1-(2.5-(37/3-(353/4)/`x'^2)/`x'^2)/`x'^2)/`x'^2) `0'
end

program define Mills /* `y' = normd(`x')/normprob(`x') as `x'->-inf  */
	gettoken gen  0 : 0
	gettoken y    0 : 0
	gettoken x    0 : 0
	local x (`x')
	qui `gen' `y' = (-`x') /*
	*/ *(1+(1-(2-(10-74/`x'^2)/`x'^2)/`x'^2)/`x'^2) `0'
end
