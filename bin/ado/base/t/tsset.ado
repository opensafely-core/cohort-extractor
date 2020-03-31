*! version 7.4.7  09sep2019
program tsset, rclass
	version 10

	capture syntax [, MI noQUERY PANELNAME(passthru) /// 
			  DISPLAYINDENT(passthru) ]
	if (_rc==0) {
		if ("`mi'"=="") {
			u_mi_not_mi_set tsset
		}
		_ts tvar pvar, panel
		local fmt: format `tvar'
		local tsdelta : char _dta[_TSdelta]
		if "`tsdelta'" == "" {
			local tsdelta 1
		}
		tsset `pvar' `tvar', format(`fmt') delta((`tsdelta')) ///
			`mi' `query' `panelname' `displayindent'
		ret add
		exit
	}

	syntax [varlist(numeric max=2 default=none)] [,			/*
			*/ CLEAR Daily Format(passthru) Generic		/*
			*/ Halfyearly  Monthly	Quarterly Weekly Yearly /*
			*/ DELta(passthru) Clocktime FORCE MI noQUERY   /*
			*/ PANELNAME(passthru) DISPLAYINDENT(passthru)  /*
			*/ PANELLABEL(passthru) TSVARLABEL(passthru) ]

	if ("`mi'"=="") {
		u_mi_not_mi_set tsset
	}
	else {
		u_mi_check_setvars tsset `varlist'
	}

	if ("`clear'" != "") { 
		syntax [, CLEAR MI]
		Clear
		exit
	}

	if ("`varlist'"=="") { 
		_ts tvar pvar, panel 
		tsset `pvar' `tvar', `daily' `format' /*
			*/ `generic' `halfyearly' `monthly' `quarterly' /*
			*/ `weekly' `yearly' `clocktime' `mi' `delta'	/*
			*/ `query' `panelname' `displayindent'		/*
			*/ `panellabel' `tsvarlabel'
		ret add
		exit
	}

	syntax varlist(numeric max=2 default=none) [ ,			/*
			*/ CLEAR Daily Format(string) Generic		/*
			*/ Halfyearly  Monthly	Quarterly Weekly Yearly /*
			*/ DELta(string) Clocktime FORCE MI noQUERY     /*
			*/ PANELNAME(string) DISPLAYINDENT(integer 0)	/*
			*/ PANELLABEL(string) TSVARLABEL(string) ]

	local ct : word count `varlist'
	if `ct'==2 { 
		tokenize `varlist'
		local panel   `1'
		local timevar `2'
	}
	else {
		local timevar `varlist'
	}

					/* fill in format		*/
	local period `daily' `weekly' `monthly' `quarterly' /*
			*/ `halfyearly' `yearly' `generic' `clocktime'

	if `"`format'"'!="" {
		local dfltfmt "no"	// user supplied fmt; not using default
		if "`period'" != "" { 
			gettoken period : period
			di in red ///
			"may not specify both {bf:format()} and {bf:`period'}"
			exit 198
		}
		local try : di `format' 2	/* will issue error message */
	}
	else if "`period'" != "" {
		/* no format but specified period -- apply default format */
		local ct : word count `period'
		if `ct' > 1 {
			di in red "may only specify one time-scale from " /*
				*/ "{bf:daily}, {bf:weekly}, {bf:monthly}, "
			di in red "{bf:quarterly}, {bf:halfyearly}, " /*
				*/ "{bf:yearly}, and {bf:generic}"
			exit 198
		}
		local format = "%t" + bsubstr("`period'",1,1) 
		if bsubstr("`period'", 1, 1) == "c" {
			// keep track of whether we applied
			// default %tc for formatting purposes
			local dfltfmt "yes"
		}
	}
	else {		/* get format from variable */
		local format : format `timevar'
	}			/* end fill in format		*/


	/* Issue warning if old periodicity is different from newly
	   declared periodicity of time var */
	local curfmt : format `timevar'
	local curftyp = bsubstr("`curfmt'", 2, 1)
	if "`curftyp'" != "t" & "`curftyp'" != "d" {
		local curftyp g
	}
	else if "`curftyp'" == "t" {
		local curftyp = bsubstr("`curfmt'", 3, 1)
	}
	local newftyp = bsubstr("`format'", 2, 1)
	if "`newftyp'" != "t" & "`newftyp'" != "d" {
		local newftyp g
	}
	else if "`newftyp'" == "t" {
		local newftyp = bsubstr("`format'", 3, 1)
	}
	if "`curftyp'" != "`newftyp'" & "`curftyp'" != "g" {
		local shorty = abbrev("`timevar'", 13)
		Period curftyp2 : "" "`curftyp'"
		Period newftyp2 : "" "`newftyp'"
		di
		di in smcl as err 					///
"Variable {res}`shorty'{err} had been formatted `curfmt' (a " 		///
"`curftyp2' period)," _n "and you asked for a `newftyp2' period.  " 	///
"Are you sure that is" _n "what you want?  It has been done; "		///
"{res}`shorty'{err} is now formatted `format'."
		di
	}
	else if "`curftyp'" == "`newftyp'" & "`dfltfmt'" != "no" {
		// Use existing format since valid and user 
		// didn't supply different one
		local format `curfmt'
	}
	

			/* Confirm that time variable is integer */
	capture assert int(`timevar')==`timevar'
	if _rc {
		di in red "time variable must contain only integer values"
		exit 451
	}

			/* Check that time data is valid */
	sort `panel' `timevar'
	if "`panel'" != ""   {
		local bypfx "by `panel': "
	}

			/* Must apply format BEFORE parsing delta */
	if `"`format'"' != "" {
		format `timevar' `format'
	}
			/* Check delta option */
	tempname scdelta
	mata: _TS_p_delta("`scdelta'", "`delta'", "`timevar'")
	if `scdelta' == -2 {
		di as err "invalid time-series format on {bf:`timevar'}"
		exit 120
	}
	if `scdelta' == -1 {
		di as err "invalid argument in {bf:delta()}"
		exit 198
	}

			/* Make sure no repeated or intervening values */
	tempvar timedif
	qui `bypfx' gen double `timedif' = `timevar'[_n+1] - `timevar'
	cap confirm variable `timedif'
	if _rc {
		di as text "no observations"
		exit
	}
	qui sum `timedif', meanonly
	if r(min) == 0 {
		if "`panel'" != "" {
			di in red "repeated time values within panel"  
		}
		else  {
			di in red "repeated time values in sample"  
		}
		exit 451
	}
	if "`force'" == "" {
		if r(min) < `scdelta' {
di in red "time values with period less than {bf:delta()} found"
			exit 451
		}
	}

	Clear

	nobreak { 
		char _dta[_TStvar]   "`timevar'"
		char _dta[_TSpanel]  "`panel'"
		char _dta[_TSdelta]  `: di %21x `scdelta''
		char _dta[_TSitrvl]  1
		char _dta[tis]   "`timevar'"
		char _dta[iis]   "`panel'"
	}
	// If we applied the default %tc format, temporarily override
	// to show full milliseconds
	if "`dfltfmt'" == "yes" & bsubstr("`format'", 3, 1) == "c" {
		format `timevar' %tcDDmonCCYY_HH:MM:SS.sss
	}
	/* Report the time-series information */
	if "`query'" == "" {
		Query, panelname(`"`panelname'"') 			  /*
		*/	displayindent(`displayindent') 			  /*
		*/	panellabel(`panellabel') tsvarlabel(`tsvarlabel') 
				/* sets r(tmax), r(tmin), r(tdelta), etc. */
		ret add
	}
	else {
		ret scalar tdelta = `: char _dta[_TSdelta]'
	}
	if "`dfltfmt'" == "yes" & bsubstr("`format'", 3, 1) == "c" {
		format `timevar' %tc
	}
	local fmt : format `timevar'
	return local tsfmt `fmt'
	return local unit1 = bsubstr("`fmt'", 3, 1)
	Period per : "`period'" `return(unit1)'
	return local unit `per'

	ret local timevar "`timevar'"
	ret local panelvar "`panel'"
end


program define Clear
	/* careful:  this list is repeated in iis.ado and tis.ado */
	char _dta[_TStvar]
	char _dta[_TSpanel]
	char _dta[_TSdelta]
	char _dta[_TSitrvl]	// This is a rudimentary form of delta 
				// used by -ac- and -pergram-.
	char _dta[tis]
	char _dta[iis]
end


program define Query, rclass
	syntax [, PANELNAME(string) DISPLAYINDENT(integer 0) /*
		*/ PANELLABEL(string) TSVARLABEL(string) ]
	
	local timevar `_dta[_TStvar]'
	local panel   `_dta[_TSpanel]'

	/* see if we have gaps */
	local delta : char _dta[_TSdelta]

	if _N > 1 {
		if "`panel'" == "" {
			qui count if `timevar'-`timevar'[_n-1] != `delta' & /*
				*/ `timevar' != . in 2/l
			local gaps = r(N)
		}
		else {
			qui count if `timevar'-`timevar'[_n-1] != `delta' & /*
				*/ `timevar' != . & `panel' == `panel'[_n-1] /*
				*/ in 2/l
			local gaps = r(N)
		}
	}
	else {
		local gaps 0
	}

	/* find the time range of the data */
	if "`panel'" == "" {
		tempvar seenvar
		local t0 = `timevar'[1]
		gen long `seenvar' = sum(`timevar' != .)
		local t1 = `timevar'[`seenvar'[_N]]
	}
	else {
		/* display panel report */
		tempname firstob lastob

		qui gen byte `firstob' = `panel' != . & `panel' != `panel'[_n-1]
		qui sum `timevar' if `firstob', meanonly
		local t0 = r(min)

		qui gen byte `lastob' = `panel' != . & `timevar' != . & /*
			*/ (`panel' != `panel'[_n+1] | `timevar'[_n+1] == .)
		qui sum `timevar' if `lastob', meanonly
		local t1 = r(max)
		local npanel = r(N)

		sum `panel', meanonly
		ret scalar imin = r(min)
		ret scalar imax = r(max)
		tempvar tmin tmax tcount
		qui by `panel' : gen double `tcount' = _N if !missing(`timevar')
		capture assert `tcount' == `tcount'[1]
		if c(rc) {
			local bal unbalanced
		}
		else {
			CheckStrongBal `npanel' `panel' `timevar'
			if r(rc) {
				local bal "weakly balanced"
			}
			else	{
				local bal "strongly balanced"
			}
		}
		
		if `"`panelname'"' == "" {
			local panelname "panel"
			local col = 8 + `displayindent'
		}
		else {
			local col = 13 - strlen(`"`panelname'"') ///
				    + `displayindent'		
		}
		if `"`panellabel'"' != "" {
			local plab `"`panellabel'"'
		}
		else {
			local plab `"`panel'"'
		}
		di in gr _col(`col') `"`panelname' variable:  "' /*
		*/ in ye "`plab' (`bal')"
		return local balanced "`bal'"
	}

	local fmt : format `timevar'
	local t0s = trim(string(`t0', "`fmt'"))
	local t1s = trim(string(`t1', "`fmt'"))
	
	local col = 9 + `displayindent'
	di in gr _col(`col') "time variable:  " _c
	
	local i 1
	// Time variable
	if `"`tsvarlabel'"' != "" {
		local line`i' `=abbrev("`tsvarlabel'",13)',
	}
	else {
		local line`i' `=abbrev("`timevar'",13)',
	}
	local linelen = length(`"`line`i''"')
	
	// t0 
	if (`linelen' + length(`"`t0s'"')) < 53 {	// start in col 25
		local line`i' `line`i'' `t0s'
		local linelen = length(`"`line`i''"')
	}
	else {
		local `++i'
		local line`i' `t0s'
		local linelen = length(`"`line`i''"')
	}
	
	// word 'to'
	if (`linelen' + 3) < 53 {
		local line`i' `"`line`i'' to"' 
		local linelen = length(`"`line`i''"')
	}
	else {
		local `++i'
		local line`i' "to"
		local linelen = 3
	}

	// t1
	if (`linelen' + length(`"`t1s'"')) < 53 {
		local line`i' `line`i'' `t1s'
		local linelen = length(`"`line`i''"')
	}
	else {
		local `++i'
		local line`i' `t1s'
		local linelen = length(`"`t1s'"')
	}

	// Last, gaps
	if `gaps' > 0 {
		if `gaps' == 1 {
			local note "but with a gap"
		}
		else {
			local note "but with gaps"
		}
		if (`linelen' + length(`", `note'"')) < 53 {
			local line`i' `line`i'', `note'
		}
		else {
			local `++i'
			local line`i' `note'
		}
	}

	forvalues j = 1/`i' {
		local col = 25 + `displayindent'
		di in ye _col(`col') `"`line`j''"'
	}

	tempname fancyd
	mata:_TS_p_delta2str("`fancyd'", `=`delta'', "`timevar'")
	local col = 17 + `displayindent'
	di in gr _col(`col') "delta:  " in ye "`=`fancyd''"

	if `gaps' > 0 {
		ret scalar gaps = 1
	}
	else {
		ret scalar gaps = 0
	}
	ret scalar tmin = `t0'
	ret scalar tmax = `t1'
	ret scalar tdelta = `delta'

	ret local tmins `t0s'
	ret local tmaxs `t1s'
	ret local tdeltas "`=`fancyd''"
	
end

program CheckStrongBal, sort rclass
	args npanel panel time
	capture bysort `time': assert `npanel' == _N
	return scalar rc = c(rc)
end

program define Period
	args newper colon per unit1

	if "`per'" == "" {
		if "`unit1'" != "" {
			local c "clocktime"
			local g "generic" 
			local d "daily" 
			local w "weekly" 
			local m "monthly" 
			local q "quarterly" 
			local h "halfyearly" 
			local y "yearly"

			capture c_local `newper' ``unit1''
		}
		else {
			c_local `newper' "generic"
		}
	}
	else {
		c_local `newper' `per'
	}
end


mata:

/*
	TS_GENERIC_ERR = -1
	TS_UNITS_ERR   = -2
*/

void _TS_p_delta(
	string scalar scname, 		// name of scalar to return delta
	string scalar delta,		// string of delta() to be parsed
	string scalar tvarname)		// name of time variable
{
	real scalar		d, i
	string scalar		fmt, units
	string rowvector	t


	/* ------------------------------------------------------------ */
					/* set units			*/
	units = "g"
	if (_st_varindex(tvarname)!=.) {
		fmt = st_varformat(tvarname)
		if (bsubstr(fmt,2,1)=="t") units = bsubstr(fmt, 3, 1) 
		else if (bsubstr(fmt,2,1)=="d") units = "d" 
	}

	/* ------------------------------------------------------------ */
					/* set t[]			*/
	t = tokens(delta, " +()")
	if (cols(t)==0) { 
		st_numscalar(scname, 1)
		return 
	}

	/* ------------------------------------------------------------ */
					/* parse t[]			*/
	d = 0 
	for (i=1; i<=cols(t); i++) {
		if (t[i]=="+") ;
		else i = _TS_p_delta_increment(d, units, t, i)
		if (i<0) {
			if (i== -1) _TS_p_delta_abort(delta) /* TS_GENERIC_ERR */
			else _TS_p_delta_uniterr(delta, units)
			/*NOTREACHED*/
		}
	}

	/* ------------------------------------------------------------ */
					/* verify result		*/
	if (d >= .) {
		errprintf("delta(" + delta + ") evaluates to a missing value\n")
		exit(198)
	}
	else if (abs(d) < epsilon(1)) {
		errprintf("delta(" + delta + ") evaluates to zero\n")
		exit(198)
	}
	else if (d < 0) {
		errprintf("delta(" + delta + 
			") evaluates to a negative number\n")
		exit(198)
	}
	else if (d != floor(d)) {
		errprintf("delta(" + delta + 
			") evaluates to a noninteger value\n")
		exit(198)
	}
	/* ------------------------------------------------------------ */
					/* set return value		*/
	st_numscalar(scname, d)
}


void _TS_p_delta_abort(string scalar delta)
{
	errprintf("invalid argument in delta(): " + delta + "\n")
	exit(198)
	/*NOTREACHED*/
}

void _TS_p_delta_uniterr(string scalar delta, string scalar units)
{
	errprintf("%s\n", "option delta(" + delta + ") invalid for %t" + 
			units + " time variable")
	exit(198)
	/*NOTREACHED*/
}


real scalar _TS_p_delta_increment(
	real scalar d, 			// sum of increments (in/out value)
	string scalar units, 		// %t<units>
	string rowvector t, 		// t[] to be parsed
	real scalar useri)		// where to start in t[]
{
	real scalar	i, toadd, cas, mult
	string scalar	s

	/* ------------------------------------------------------------ */
				/* parse <elit> of <elit> <units>	*/
	pragma unset toadd
	if ((i=_TS_p_delta_getnumb(toadd, t, useri))<0) return(i)
	/* ------------------------------------------------------------ */
				/* parse optional <units> 		*/
	cas = 0
	s = (cols(t)>i ? t[i+1] : "")
	if      (s=="seconds"   | s=="secs" | 
		 s=="second"	| s=="sec") 		cas = 1
	else if (s=="minutes"   | s=="mins" |
		 s=="minute"	| s=="min") 		cas = 2
	else if (s=="hours"     | s=="hour") 		cas = 3
	else if (s=="days"      | s=="day") 		cas = 4
	else if (s=="weeks"     | s=="week")		cas = 5
	else if (s=="months"    | s=="month")		cas = 6
	else if (s=="quarters"  | s=="quarter")		cas = 7
	else if (s=="halfyears" | s=="halfyear")	cas = 8
	else if (s=="years" 	| s=="year")		cas = 9
	else if (s!="")					return(-1)
							/* TS_GENERIC_ERR */

	if (cas) {
		if (units=="c" | units=="C") {
			if (cas==1) 		mult = 1000
			else if (cas==2) 	mult = 60000
			else if (cas==3)	mult = 3600000
			else if (cas==4)	mult = 86400000
			else if (cas==5)	mult = 604800000
			else			return(-2) /* TS_UNITS_ERR */
			toadd = toadd*mult
		}
		else if (units=="d") {
			if (cas==5) toadd = 7*toadd
			if (cas!=4) return(-2)
		}
		else if (units=="w") {
			if (cas!=5) return(-2)
		}
		else if (units=="m") {
			if (cas!=6) return(-2)
		}
		else if (units=="q") {
			if (cas!=7) return(-2)
		}
		else if (units=="h") {
			if (cas!=8) return(-2)
		}
		else if (units=="y") {
			if (cas!=9) return(-2)
		}
		else	return(-2) /* Not reached */
		i++
	}

	/* ------------------------------------------------------------ */
				/* verify results and return		*/
	if (toadd >= .) return(-1) /* TS_GENERIC_ERR */
	d = d + toadd
	return(i)
}



real scalar _TS_p_delta_getnumb(
	real scalar toadd, 		// increment (output value)
	string rowvector t, 		// t[] to be parsed
	real scalar useri)		// where to start
{
	real scalar	i, np, rc
	string scalar	expr, tname

	i = useri
	/* ------------------------------------------------------------ */
				/* <elit> := <#>			*/

	if (t[i] != "(") { 
		toadd = strtoreal(t[i])
		return(toadd>=. ? -1 : i)  /* TS_GENERIC_ERR */
	}

	/* ------------------------------------------------------------ */
				/* <elit> := <expr>			*/
	expr = ""
	np=1
	for(++i; np; i++) {
		if (t[i]=="(") np++
		else {
			if (t[i]==")") np--
			if (np) expr = expr + t[i]
		}
	}
	tname = st_tempname()
	if (rc=_stata("scalar " + tname + "=" + expr, 0)) exit(rc)
	toadd = st_numscalar(tname)
	if (rc=_stata("scalar drop " + tname, 0)) exit(rc)

	return(toadd>=. ? -1 : i-1) /* TS_GENERIC_ERR */
}

void _TS_p_delta2str(
	string scalar strname,		// name of scalar to return string
	real   scalar delta,		// time delta (integer)
	string scalar tvarname) 	// name of time variable
{
	
	real scalar	t, mult
	string scalar 	adds, deltas, fmt, units, phrase

	units = "g"
	if (_st_varindex(tvarname)!=.) {
		fmt = st_varformat(tvarname)
		if (bsubstr(fmt,2,1)=="t") units = bsubstr(fmt, 3, 1)
		else if (bsubstr(fmt,2,1)=="d") units = "d"
	}
	
	adds = (delta > 1 ? "s" : "")
	deltas = strofreal(delta)
	if (units=="g") {
		st_strscalar(strname, deltas + " unit" + adds)
		return
	}
	else if (units=="d") {
		st_strscalar(strname, deltas + " day" + adds)
		return
	}
	else if (units=="w") {
		st_strscalar(strname, deltas + " week" + adds)
		return
	}
	else if (units=="m") {
		st_strscalar(strname, deltas + " month" + adds)
		return
	}
	else if (units=="q") {
		st_strscalar(strname, deltas + " quarter" + adds)
		return
	}
	else if (units=="h") {
		st_strscalar(strname, deltas + " halfyear" + adds)
		return
	}
	else if (units=="y") {
		st_strscalar(strname, deltas + " year" + adds)
		return
	}
	else if (units=="b") { // added for -bcal- (business calendars)
		st_strscalar(strname, deltas + " day" + adds)
		return
	}

	// At this point, we are a %tc or %tC -- return
	// weeks, days, hours, minutes, seconds

	phrase = ""
	mult = 604800000	// weeks
	t = trunc(delta / mult)
	if (t > 0) {
		phrase = phrase + 
			 strofreal(t) + " week" + ((t>1) ? "s" : "") + " "
		delta = delta - mult*t
	}
	
	mult = 86400000		// days
	t = trunc(delta / mult)
	if (t > 0) {
		phrase = phrase + 
			 strofreal(t) + " day" + ((t>1) ? "s" : "") + " "
		delta = delta - mult*t
	}
	
	mult = 3600000		// hours
	t = trunc(delta / mult)
	if (t > 0) {
		phrase = phrase +
			 strofreal(t) + " hour" + ((t>1) ? "s" : "") + " "
		delta = delta - mult*t
	}

	mult = 60000		// minutes
	t = trunc(delta / mult)
	if (t > 0) {
		phrase = phrase +
			 strofreal(t) + " minute" + ((t>1) ? "s" : "") + " "
		delta = delta - mult*t
	}

	mult = 1000		// seconds
	t = delta / mult
	if (t > 0) {
		phrase = phrase +
			 strofreal(t) + " second" + ((t!=1) ? "s" : "")
	}

	st_strscalar(strname, strrtrim(phrase))
}




end


exit




----------------------------------------------------------------------------
Undocs:  nocheck interval(#)

----------------------------------------------------------------------------

lines w/ `interva' for interval if interval added

----------------------------------------------------------------------------

----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

tsset t
     panel variable:  panelvar (unbalanced)
     panel variable:  panelvar (balanced)
     panel variable:  panelvar (weakly balanced)
     panel variable:  panelvar (strongly balanced)
      time variable:  timevar, 1956.2 to 1999.4, but with gaps

     panel variable:  panelvar, ### to ###
      time variable:  timevar, 1956.2 to 1999.4, but with gaps

     Panel/ID variable:  panelvar   (#### , ####)
  Time-series variable:  timevar1   (1956.2 , 1988.4)

  Time-series variable:  tsvar
     Panel/ID variable:  idvar
  Range of time series:  1956.2 to 1988.4  (panels are not balanced)

