*! version 2.1.6  19feb2015
* smooth -- robust, compound, nonlinear smoother
program define smooth, sort
	version 6

		/*
			sorig contains original compound smoother
			s contains compound smoother with ",twice" removed
			twice is "twice" if ",twice" was removed
		*/

	gettoken sorig 0 : 0
	local sorig = upper("`sorig'")
	local s = bsubstr("`sorig'",1,1)
	capture confirm integer number `s'
	if _rc  & "`s'" != "H" {
		di as err "invalid smoother"
		exit 198
	}
	local s "`sorig'"
	if "`s'"=="" { exit 198 }
	local l=index("`s'",",T")
	if `l' {
		local j = bsubstr("`s'",`l',.)
		if ("`j'"!=bsubstr(",TWICE",1,length("`j'"))) { exit 198 } 
		local s=bsubstr("`s'",1,`l'-1)
		local sorig=bsubstr("`s'",1,`l'-1)+",twice"
		local twice "twice"
	}

		/*
			parse request 
		*/
	syntax varname [if] [in] [, Generate(str) Type(string) Vlabel DRYRUN] 

	if "`type'" != "" {
		tparse , `type'
		local type "`r(type)'"
	}

		/*
			if not dryrun, finish parse, perform dryrun
		*/

	if "`dryrun'"=="" { 
		if "`generat'"=="" { 
			di in red "generate(newvar) required"
			exit 198 
		}
		confirm new var `generat'
                tempvar ifmiss
                qui gen byte `ifmiss' = `varlist'!=. `if' `in'
		_crcnuse `ifmiss'
                local first = r(first)
                local last = r(last)
                local in "in `first'/`last'"
		if r(gaps) {
			di in red "`varlist' contains missing values"
			exit 498
		}
		smooth "`s'" `varlist', dryrun 		/* note, no twice */
			
	}
	else {
		local x "*"
	}

		/*
			Note, lines marked `x' are executed only if not dryrun
		*/

	`x' tempvar base res
	`x' if "`type'" == "" {
		`x' local type : type `varlist'
		`x' if "`type'"!="double" { local type "float" }
	`x' }	
	`x' qui gen `type' `res' = `varlist' `in'

	local parity 0 	/* marker for even-span median smoothers */

	if "`twice'"!="" {		/* not dryrun by definition	*/
		tempvar res1 rough res2
		smooth `s' `res', gen(`res1') 
		qui gen `type' `rough'=`varlist'-`res1' `in'
		qui smooth `s' `rough', gen(`res2') 
		qui replace `res'=`res1'+`res2' `in'
	} 
	else { 
		local Snext 0 
		while "`s'"!="" { 
			`x' capture drop `base' 
			`x' rename `res' `base' 
			local Sokay `Snext' 
			local Snext 0 
			local s1=bsubstr("`s'",1,1) 
			if (`Sokay' & "`s1'"=="S") { 
				if (bsubstr("`s'",1,2)=="SR") {
					`x' _sm_rpt "_sm_s `first' `last'" `base' `res'
					local s=bsubstr("`s'",3,.)
				}
				else {
					`x' _sm_s `first' `last' `base' `res'
					local s=bsubstr("`s'",2,.)
				}
				local Snext 1
			}
			else if real("`s1'")!=. {
				if `s1'==0 { exit 198 }
				if `s1'==3 { local Snext 1 }
				local even = (int(`s1'/2)*2) == `s1'
				local parity = `parity' != `even'
				if bsubstr("`s'",2,1)=="R" {
					`x' _sm_rpt "_sm_m `s1' `first' `last' `parity'" `base' `res'
					local s=bsubstr("`s'",3,.)
				}
				else {
					`x' _sm_m `s1' `first' `last' `parity' `base' `res'
					local s=bsubstr("`s'",2,.)
				}
				if `even' { local last = cond(`parity',`last'+1,`last'-1) }
			}
			else if "`s1'"=="H" {
				`x' _sm_h `first' `last' `base' `res'
				local s=bsubstr("`s'",2,.)
			}
			else if "`s1'"=="E" {
				local Snext `Sokay'
				`x' _sm_e `first' `last' `base' `res'
				local s=bsubstr("`s'",2,.)
			}
			else {
				di in red "`s1' not allowed in `sorig'"
				exit 198
			}
		} /* while */
	} /* else */

/*
        closeout code -- parity is 0 if there is an even number of even-span
                         smoothers, 1 if the number is odd.
*/
        if `parity' {
                di in red "You must use an even number of even-span smoothers"
                exit 498
        }
	`x' if "`vlabel'" != "" {
	`x'	local vlab : variable label `varlist'
	`x'	label var `res' "`sorig' `vlab'"
	`x' }
	`x' else {
	`x' 	label var `res' "`sorig' `varlist'"
	`x' }
	`x' rename `res' `generat'
end
	

* _sm_e -- endpoint smoother
program define _sm_e /* first_obs last_obs varname newvar */
	version 3.1
        local f `1'
        local l `2'
	local v "`3'"
	local g "`4'"
	local type : type `v'
	tempvar res
	quietly {
		gen `type' `res' = `v'
		_sm_epu `v'[`f'+2] `v'[`f'+1] `v'[`f']
		replace `res'=r(value) in `f'
		_sm_epu `v'[`l'-2] `v'[`l'-1] `v'[`l']
		replace `res'=r(value) in `l'
	}
	rename `res' `g'
end

* _sm_epu -- endpoint smoother utility (see note below)
program define _sm_epu, rclass /* s[n-2] s[n-1] s[n]  or s[3] s[2] s[1] */
	                       /*    s2     s1    s0       s2    s1   s0 */
        version 3.1
	local s2 = `1'
	local s1 = `2'			/* lazy 	*/
	local s0 = `3'			/* actual 	*/
	local p = `s1'+2*(`s1'-`s2')	
	#delimit ;
	ret scalar value = cond(
		`p'<=max(`s1',`s0') & `p'>=min(`s1',`s0'),`p',
		cond(
		`s1'<=max(`p',`s0') & `s1'>=min(`p',`s0'),`s1',
		`s0')) ;
	#delimit cr
end



* _sm_h -- Hanning smoother
program define _sm_h /* first_obs last_obs varname newvar */
	version 3.1
        local f `1'
        local l `2'
	local v "`3'"
	local g "`4'"
	tempvar res 
	local type : type `v'
        local two = `f' + 1
        local mintwo = `l' - 1
        if `mintwo'<`two' { exit }
	quietly { 
		gen `type' `res' = `v'
		replace `res'=(`v'[_n-1]+2*`v'+`v'[_n+1])/4 in `two'/`mintwo'
	}
	rename `res' `g'
end

* _sm_m -- running median smoother, copy-on endpoints.  (see note below)
program define _sm_m /* # first_obs last_obs parity varname newvar */
	version 3.1
	local span `1'
	confirm integer number `span'
	if `span'<1 { exit 198 } 
        local f `2'
        local l `3'
	local parity `4'
	if (`parity'!=0 & `parity'!=1) { exit 198 }
	local v "`5'"
	local generat "`6'"
	if "`generat'"=="" { exit 198 } 
	local type : type `v'
	tempvar res time
	quietly {
		gen `c(obs_t)' `time'=_n
		gen `type' `res'=`v' in `f'/`l' /* copy on */
		if `span'==1 {
			rename `res' `generat'
			exit
		}
		local h=int(`span'/2)
		local even = `h'*2 == `span'
		if !`even' {			/* odd */
			local s 3
			local j0 = `f'+1
		}
		else {	
			local s 2
			local j0 `f'
			local h=`h'-1
                        tempvar shift
                        local fval = `v'[`f']    /* save first and last obs */
                        local lval = `v'[`l']
		}
		local j1=`l'-1
		while `j0'<`f'+`h' {
			_sm_mu `s' `v' `res' `time' `j0' `j0'
			_sm_mu `s' `v' `res' `time' `j1' `j1'
			local j0=`j0'+1
			local j1=`j1'-1
			local s=`s'+2
		}
		_sm_mu `span' `v' `res' `time' `j0' `j1'
                if `even' {     /* adjust series according to parity */
                        if `parity' {   /* first in pair */
                                gen double `shift' = `res' in `f'/`l'
                                local l =`l'+1
                                if `l'>_N { set obs `l' }
                                local fp1 = `f'+1
                                replace `res' = `shift'[_n-1] in `fp1'/`l'
                                replace `res' = `fval' in `f'
                                drop `shift'
                        }
                        else {          /* second in pair */
                                replace `res' = `fval' in `f'
                                if `l'==_N { drop in l }
				else { replace `res' = . in `l' }
				local l = `l'-1
                                replace `res' = `lval' in `l'
                        }
                                
	}
	rename `res' `generat'
end



* _sm_mu -- running median utility
/*
	replace newvar[n0..n1] with running medians span # of varname.
	timevar = 1, 2, ..., _N; data is in order of timevar
*/
program define _sm_mu /* # varname newvar timevar n0 n1 */
	version 3.1
	local span `1'
	local v "`2'"
	local res "`3'"
	local time "`4'"
	local n0 `5'
	local n1 `6'
	quietly {
		if `span'==3 {
			local v0 "`v'[_n-1]"
			local v1 "`v'[_n+1]"
			#delimit ;
			replace `res'=cond(
			`v'<=max(`v1',`v0') & `v'>=min(`v1',`v0'),`v',
			cond(
			`v1'<=max(`v',`v0') & `v1'>=min(`v',`v0'),`v1',
			`v0')) in `n0'/`n1' ;
			#delimit cr
			exit
		}
		if `span'==2 {
			replace `res'=(`v'+`v'[_n+1])/2 in `n0'/`n1'
			exit
		}
		if int(`span'/2)*2!=`span' {		/* odd 	*/
			local hs=int(`span'/2)
			local j `n0'
			while `j'<=`n1' {
				local j0=`j'-`hs'
				local j1=`j'+`hs'
				sort `v' in `j0'/`j1'
				local answ=`v'[`j']
				sort `time' in `j0'/`j1'
				replace `res'=`answ' in `j'
				local j=`j'+1
			}
			exit
		}
						/* even */
		local hs1=int(`span'/2)
		local hs0=`hs1'-1
		local j `n0'
		while `j'<=`n1' {
			local j0=`j'-`hs0'
			local j1=`j'+`hs1'
			sort `v' in `j0'/`j1'
			local answ=(`v'[`j']+`v'[`j'+1])/2
			sort `time' in `j0'/`j1'
			replace `res'=`answ' in `j'
			local j=`j'+1
		}
	}
end

* _sm_rpt -- repeat smoother until no further change.
program define _sm_rpt /* cmd basevar newvar */
	version 3.1 
	local cmd "`1'"
	local v "`2'"
	local gen "`3'"
        parse "`cmd'", parse(" ") /* Is this an even-span median smoother? */
        local command "`1'"
        local even 0
        if "`command'"=="_sm_m" {
                local span `2'
                local f `3'
                local l `4'
                local parity "`5'"
                if !_rc & (2*int(`span'/2)==`span') { local even 1 }
                if `even' {
                        local reverse = !parity
                        local revcmd "`command' `span' `f' `l' `reverse'"
                }
        }
        else {
                local f `2'
                local l `3'
        }
	tempvar base next 
	quietly {
		`cmd' `v' `base'
		`cmd' `base' `next'
		capture assert `base'==`next' in `f'/`l'
		while _rc { 
			drop `base'
			rename `next' `base'
			`cmd' `base' `next'
			if `even' { /* force evens to come in pairs */
                                `revcmd' `base' `next' 
                        }
			capture assert `base'==`next' in `f'/`l'
		}
	}
	rename `next' `gen'
end

* _sm_s -- split repeated values in smoothed series
program define _sm_s /* first_obs last_obs varname newvar */
        version 3.1
        local f `1'
        local l `2'
	local varlist "`3'"
	local generat "`4'"
	local z `varlist'
	local type : type `z'
	tempvar res res2
	quietly {
		gen `type' `res' = `z' in `f'/`l'
		local t = `f'+2
		while `t'<=`l'-2 {
			if (`z'[`t']==`z'[`t'+1]) {
				local u=`t'+1
				local s1=sign(`z'[`t']-`z'[`t'-1])
				if `s1'==sign(`z'[`u']-`z'[`u'+1]) & `s1' {
					_sm_epu `z'[`t'-2] `z'[`t'-1] `z'[`t']
					replace `res'=r(value) in `t'
					_sm_epu `z'[`u'+2] `z'[`u'+1] `z'[`u']
					replace `res'=r(value) in `u'
				}
			}
			local t=`t'+1
		}
	}
	_sm_rpt "_sm_m 3 `f' `l' 0" `res' `res2'
	rename `res2' `generat'
end

program define tparse, rclass
	syntax ,[double float]
	if "`double'`float'" == "" {
		di as error "`0' type invalid "
		exit 198
	}
	if "`double'" != "" {
		ret local type "double"
	}
	if "`float'" != "" {
		ret local type "float"
	}
end

/* Notes */

/* 
Re:  Smooth: 

smooth	non-linear smoothers.

smooth <compound_smoother[,twice]> varname, gen(varname)

where a <compound_smoother> is a sequence of smoothers, and the smoothers are:

	#	running median
	#R	running median, repeated
	S	split followed by 3R, allowed only after 3 or 3R, or S.
	SS	implied by above
	SR	repeated S
	H	Hanning



Subroutines:

_sm_m	   #	running-median smoother
_sm_ep     E	end-point adjustments
_sm_s	   S	split followed by 3R, must only be called after 3 or 3R.
_sm_3r	   3R	running-median smoother
_sm_rpt    R	repeat operator (but not 3R because no end-point adj made)
_sm_h	   H	hanning smoother


Syntax:

_sm_m 	# varname, gen(newvar)
_sm_ep  varname
_sm_s   varname, gen(newvar)
_sm_3r	varname, gen(newvar)


_sm_rpt "cmd_less_gen"



_sm_m 		running-median smoother	(corresponds to #)
_sm_ep		end-point adjustments (E)
*/


/*
Re: _sm_epu:
Equivalency of formulas.

End-point adjustment E is (Velleman 3.4)

	z_1 = med{ 3*z_2 - 2*z_3, y_1, z_2}

Equivalent to call:

	_sm_epu z_3 z_2 y_1

Because:

	p = z_2+ 2*(z_2 - z_3) = 3*z_2 - 2*z_3
*/ 


/*
Re:	_sm_m
Shorter-span logic

      span=3   span=5   span=7       span=2   span=4   span=6
         h=1      h=2      h=3          h=1      h=2      h=3
---------------------------------------------------------------
 1.   ->1      ->1      ->1           1.5     1.5(*2)  1.5(*2)
 2.     2      2(*3)    2(*3)         2.5     2.5      2.5(*4)       
 3.     3      3        3(*5)         3.5     3.5      3.5
 4.     4      4        4             4.5     4.5      4.5
 5.
 6.     6      6        6             6.5     6.5      6.5
 7.     7      7        7(*5)         7.5     7.5      7.5(*4)
 8.     8      8(*3)    8(*3)         8.5     8.5(*2)  8.5(*2)
 9.   ->9      ->9      ->9           ->9     ->9      ->9

Thus, for odd:
	fill in j=2,..h and N-1 ...

For even, 
	fill in j=1,..h-1 and N_1 ...
*/


/*
Re: _sm_s:
for any data sequence {..., y[t-2], y[t-1], y[t], y[u], y[u+1], ...}, 
where u=t+1, 
and its smooth given by 3R {..., z[t-2], z[t-1], z[t], z[u], z[u+1], ...}, 
wherever z[t]==z[u] and sign(z[t]-z[t-1])=sign(z[u]-z[u+1]!=0, 
replace z[t] by med{3z[t-1]-2*z[t-2],z[t],z[t-1]}  (_sm_epu(z[t-2],z[t-1],z[t])
   and  z[u] by med{3z[u+1]-2*z[u+2],z[u],z[u+1]}  (_sm_epu(z[u+2],z[u+1],z[u])
Finally, resmooth by 3R.
This is usually repeated once (SS) or until no further changes take place
(SR).
*/
