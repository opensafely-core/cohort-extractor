*! version 3.0.3  28sep2004
program define safesum, rclass
* touched by jwh -- double saves
	version 6.0, missing
	syntax varlist(max=1) [fweight] [if]
	qui summ `varlist' [`weight'`exp'] `if'
	ret scalar sum = cond(r(N)==0 | r(N)==., 0, round(r(sum),1))
	global S_1 `return(sum)'	/* double save */
end
exit
