*! version 2.5.3  15oct2019
program define stsplit
	version 7, missing

	u_mi_not_mi_set stsplit other

	if _caller() < 6 {
		ztspli_5 `0'
		exit
	}
	st_is 2 full

	if `"`_dta[st_id]'"' == "" {
		di as err /*
		*/ "{bf:stsplit} requires that you have previously {bf:stset} an {bf:id()} variable"
		exit 198
	}

	capture svyset
	if "`r(_svy)'" ~= "" {
		di as err "{bf:stsplit} not allowed with survey data"
		exit 498
	}

	syntax [newvarname(numeric)] [=exp] [if], [AT(str) EVery(str) *]

	if `"`at'"' == "" & `"`every'"' == "" {
		di as err "options {bf:at()} or {bf:every()} should be specified"
		exit 198
	}
	else if `"`at'"' != "" & `"`every'"' != "" {
		di as err "options {bf:at()} and {bf:every()} may not be specified together"
		exit 198
	}

	* n0 = n-of-obs before expansion
	local n0 = _N

	if `"`every'"' != "" {
		confirm num `every'
		Every `typlist' `varlist' `exp' `if' , every(`every') `options'
	}
	else if `"`at'"' == bsubstr("failures",1,length(`"`at'"')) {
		AtFailures `typlist' `varlist' `exp' `if' , `options'
	}
	else {
		AtNumList `typlist' `varlist' `exp' `if' , at(`at') `options'
	}
	if ("`varlist'" != "") {
		label variable `varlist' "observation interval"
	}

	Created `n0'
end

* ============================================================================
* AtFailures -- performs episode splitting at the failure times
* ============================================================================

program define AtFailures
	syntax [if/], [ STrata(varlist min=1 max=5) COdesplit(passthru) /*
	*/ Riskset(str) List Fast noPREserve  ]

	if `"`riskset'"' != "" {
		local 0 `riskset'
		syntax newvarname
		local rname `varlist'
		local rtype `typlist'
	}

	* sample selection (beware: touse is -1/0 coded)
	* ----------------------------------------------

quietly {
	tempvar touse
	gen byte `touse' = _st
	if `"`if'"' != "" {
		replace `touse' = 0 if !(`if')
	}

	if "`strata'" == "" {
		replace `touse' = -`touse'
	}
	else {
		markout `touse' `strata' , strok
		count if `touse' == 0 & _st == 1
		if r(N) > 0 {
			noi di as txt r(N) /*
	*/ " records marked _st==0 because of missings in strata (`strata')"
			replace _st = 0 if `touse' == 0
		}
		replace `touse' = -`touse'

		* strata() are identified by a single variable 
		* referred to by the tempvar -Strata-, coded 1 2 ...
		tempvar Strata
		bys `touse' `strata' : gen `c(obs_t)' `Strata' = _n==1 if `touse'
		replace `Strata' = sum(`Strata')
		compress `Strata'
	}

	* identify  the distinct failure times T()
	* ----------------------------------------

	* leave data so that the failure times T[1]<T[2]<..T[nevent] are sorted
	* and in the first nevent observations
	*
	* if strata() are specified, the sorted failure times are in subsequent
	* (sets of) observations per stratum
		
	tempvar event
	bys `touse' `Strata' _t (_d) : gen byte `event' = cond(_n==_N & _d==1, -1, .) if `touse'
	
	sort `touse' `event' `Strata' _t

	local nobs = _N
	count if `event' == -1
	local nevent = r(N)
	if `nevent' == 0 {
		noi di as txt "(there are no failures)"
		exit 0
	}

	* count distinct failure times within strata
	* nEventStrata = #failures per stratum (may be 0)
	if "`strata'" != "" {
		tempname nEventStrata mfail
		gen byte `mfail' = `event' == -1
		tab `Strata', matcell(`nEventStrata') subpop(`mfail')
		local nStrata = rowsof(`nEventStrata')
		drop `mfail'

		forv is = 1/`nStrata' {
			if `nEventStrata'[`is',1] == 0 {
				local zerofound 1
			}
		}
		if "`zerofound'" != "" {
			noi di as txt "note: there are strata without failures"
		}
	}

	* use obs 1/nevent of tempvar T as an array with failure times
	* this facilitates efficient code below
	tempvar T
	gen double `T' = _t in 1/`nevent'
	compress `event' `T'
} /* quietly */

	* list the failure times
	* ----------------------

	di as txt "(`nevent' failure time" cond(`nevent'>1, "s)", ")")
	if "`list'" != "" {
		local lsize : set linesize
		local ncol = int((`lsize'-1)/9)

		if "`strata'" == "" {
			forv ev = 1/`nevent' {
				di %9.0g `T'[`ev'] _c
				if mod(`ev',`ncol') == 0 { di }
			}
			if mod(`ev'-1,`ncol') != 1 { di }
			di
		}
		else {
			local ev2 0
			forv is = 1/`nStrata' {
				di as txt _n "stratum `is'"
				if `nEventStrata'[`is',1] > 0 {
					local ev1 = `ev2' + 1
					local ev2 = `ev1' + `nEventStrata'[`is',1] - 1
					local ev `ev1'
					while `ev' <= `ev2' {
						di as res %9.0g `T'[`ev'] _c
						local ev = `ev' + 1
						if mod(`ev'-`ev1',`ncol') == 0 { di }
					}
					if mod(`ev'-`ev1'+1,`ncol') != 1 { di }
				}
				else	di as res _col(9) "no failures"
			}
		}
	}

	* ---------------------------------------------------------------------
	* failure times in the interior of an episode are indexed ifirst..ilast
	* within the list T of failure times (strata are accounted for)
	*
	* ifirst/ilast are missing if no internal failure time
	*
	* algorithm: bisection, which is much faster than a linear search to
	* determine the smallest T > _t0 and the largest T < _t.
	* ---------------------------------------------------------------------

quietly {
	tempvar ifirst ilast ilow ihigh il ih im busy

	* ilow .. ihigh is range of T-values to be scanned. While this range is
	* stratum specific, the rest of the code need no longer reflect strata.
	if "`strata'" == "" {
		gen long `ilow'  = 1
		gen long `ihigh' = `nevent'
	}
	else {
		gen long `ilow'  = .
		gen long `ihigh' = .
		local Ihigh 0
		forv is = 1/`nStrata' {
			if `nEventStrata'[`is',1] > 0 {
				local Ilow  = `Ihigh' + 1
				local Ihigh = `Ilow' + `nEventStrata'[`is',1] - 1
				replace `ilow'  = `Ilow'  if `Strata'==`is'
				replace `ihigh' = `Ihigh' if `Strata'==`is'
			}
		}
	}

	* binary search : ifirst = index smallest T > _t0
	gen long `il' = `ilow'
	gen long `ih' = `ihigh'
	gen long `im' = .
	gen byte `busy' = (`T'[`ih'] > _t0) & (`ih' > `il') if `touse'
	count if `busy' == 1
	while r(N) > 0 {
		replace `im'   = int((`il'+`ih')/2)           if `busy'==1
		replace `ih'   = `im'      if `T'[`im'] >  _t0 & `busy'==1
		replace `il'   = `im'      if `T'[`im'] <= _t0 & `busy'==1
		replace `busy' = `ih' - `il' > 1              if `busy'==1
		count if `busy' == 1
	}
	replace `ih' = `ih'-1 if `ih'>`ilow' & `T'[`ih'-1]>_t0 & `touse'
	gen long `ifirst' = cond(`T'[`ih'] > _t0, `ih', .)    if `touse'

	/*
	Assert 1   _t0 <  `T'[`ifirst']   if `ifirst'<.                    & `touse'
	Assert 2   _t0 >= `T'[`ifirst'-1] if `ifirst'<.  & `ifirst'>`ilow' & `touse'
	Assert 3   _t0 <= `T'[`ihigh']    if `ifirst'>=.                   & `touse'
	*/

	* binary search : ilast = index largest T < _t
	drop `il' `ih' `im' `busy'
	gen long `il' = `ilow'
	gen long `ih' = `ihigh'
	gen long `im' = .
	gen byte `busy' = (`T'[`il'] < _t) & (`ih' > `il') if `touse'
	count if `busy' == 1
	while r(N) > 0 {
		replace `im'   = int((`il'+`ih')/2)          if `busy'==1
		replace `il'   = `im'      if `T'[`im'] <  _t & `busy'==1
		replace `ih'   = `im'      if `T'[`im'] >= _t & `busy'==1
		replace `busy' = `ih' - `il' > 1             if `busy'==1
		count if `busy' == 1
	}
	replace `il' = `il'+1 if `il'<`ihigh' & `T'[`il'+1]<_t & `touse'
	gen long `ilast' = cond(`T'[`il'] < _t, `il', .)     if `touse'

	/*
	Assert 4   `T'[`ilast']   <  _t if `ilast'<.       & `touse'
	Assert 5   `T'[`ilast'+1] >= _t if `ilast'<`ihigh' & `touse'
	Assert 6   `T'[`ilow']    >= _t if `ilast'>=.      & `touse'
	*/

	* set ifirst/ilast to missing if not both in the interior
	replace `ilast'  = . if `ifirst' >= . | `ilast' < `ifirst'
	replace `ifirst' = . if `ilast' >= .

	* perform episode splitting at the marked failure times
	* -----------------------------------------------------

	tempvar xid evid nrec markfl firstn

	count if `touse'
	local n0 = r(N)
	gen long `nrec'   = cond(`ifirst'< .,`ilast'-`ifirst'+2, 1) in 1/`n0'
	gen `c(obs_t)' `xid' = _n in 1/`n0'  /* identifier for split records */
	gen `c(obs_t)' `firstn' = _n in 1/`nevent'

	drop `busy' `il' `ih' `im' `ilow' `ihigh' `ilast'
	if "`preserve'" == "" & "`fast'" == "" {
		preserve
		local Done "restore, not"
	}
	compress `firstn' `nrec' `ifirst' `xid'

	noi SaveExpand = `nrec' in 1/`n0'

	if `n0' < _N {
		local n1 = `n0'+1
		replace `firstn' = . in `n1' / l
	}

	sort `xid'
	* mark episodes first=1, last=2, inbetween=0
	by `xid' : gen byte `markfl' = 1*(_n==1) + 2*(_n==_N) if `nrec' > 1
	* mark episode with nr of failure time being split on
	by `xid' : gen `c(obs_t)' `evid' = `ifirst' + _n - 1
	* all split episodes are ended by non-failure, marked -1 for now
	by `xid' : replace _d = -1 if _n < _N

	* ensure that T is correctly index (sorted)
	sort `firstn'
	recast double _t0
	recast double _t
	* replace _t0 in all but the first record within xid
	replace _t0 = `T'[`evid'-1] if `markfl'==0 | `markfl'==2
	* replace _t in all but the last record within xid
	replace _t  = `T'[`evid']   if `markfl'==0 | `markfl'==1

	* modify user variables, reset _d
	ModifyUserVars, `codesplit'
	compress _t0 _t

	* identifier for risk sets
	* ------------------------

	if "`riskset'" != "" {
		tempvar mind x
		gen byte `mind' = - _d
		bys `touse' `Strata' _t (`mind') : gen `x' = cond(_n==1 & _d==1, 1, .) if `touse'
		gen `rtype' `rname' = sum(`x') if `touse'
		* risk set is missing at times without failures
		by `touse' `Strata' _t (`mind') : replace `rname' = . if _d[1]==0
		label var `rname' "identifier of risk sets"
		compress `rname'
	}

	`Done'
} /* quietly */
end

* ============================================================================
* AtNumlist -- performs at() episode splitting
* ============================================================================

program define AtNumList
	syntax newvarname(numeric) [=exp] [if], at(str) /*
	*/ [ AFter(passthru) COdesplit(passthru) noPREserve Fast TRIM ]

	local vname `varlist'
	local vtype `typlist'

quietly {
	marksample touse, novar
	replace `touse' = 0 if _st == 0

	if `"`exp'`after'"' != "" {
		tempvar Base
		After `Base' `exp' if `touse', `after'
	}
	else {
		local Base 0
		local range "range(>=0)"  /* at() should be positive */
	}

	* parse at()
	* ----------

	* substitute max in -at-
	local tmp : subinstr local at "max" "", count(local nch)
	if `nch' > 0 {
		tempvar basetime
		gen `basetime' = _t + `Base'
		summ `basetime' if _st, meanonly
		local maxp = r(max)+1
		local at : subinstr local at "max" "`maxp'" , all
		drop `basetime'
	}

	numlist "`at'" , sort `range'
	DropDup at : "`r(numlist)'"
	* store at into at1, at2, ...
	tokenize `at'
	local nat : word count `at'
	forv i = 1/`nat' {
		local at`i' ``i''
	}

	* determine internal split times
	* ------------------------------

	* ifirst = min_j { _t0+Base > a_j }  (missing if set is empty)
	* ilast  = max_j { _t +Base < a_j }  (missing if set is empty)

	tempvar ifirst ilast
	gen long `ifirst' = .
	gen long `ilast'  = .
	forv i = 1/`nat' {
		replace `ifirst' = `i' if `ifirst' >= . & /*
		  */ (float(`at`i'') > float(_t0+`Base')) & `touse'
	}
	forv i = `nat'(-1)1 {
		replace `ilast' = `i' if `ilast' >= . & /*
		  */ (float(`at`i'') < float(_t+`Base')) & `touse'
	}

	* perform episode splitting
	* -------------------------

	tempvar xid evid nrec markfl
	gen long `nrec' = cond(`ilast'-`ifirst'< .,`ilast'-`ifirst'+2, 1) if `touse'
	gen `c(obs_t)' `xid' = _n if `touse'

	if "`preserve'" == "" & "`fast'" == "" {
		preserve
		local Done "restore, not"
	}
	drop `ilast'
	compress `firstn' `nrec' `ifirst'
	recast double _t0
	recast double _t

	noi SaveExpand = `nrec' if `touse'

	sort `xid'
	* mark episodes first=1, last=2, inbetween=0
	by `xid' : gen byte `markfl' = 1*(_n==1) + 2*(_n==_N) if `nrec' > 1
	* mark episode with nr of time being split on
	local obstype = c(obs_t)
	if "`obstype'" != "double" {
		local obstype "long"
	}
	by `xid' : gen `obstype' `evid' = `ifirst' + _n - 1
	* all split episodes are ended by non-failure, marked -1 for now
	by `xid' : replace _d = -1 if _n < _N & `touse'

	* Update _t0, _t, and the episode marker vname
	* --------------------------------------------

	* use variable T to efficiently implement indexed access to at()
	* sometimes _N may be smaller than -nat- !
	if `nat' > _N {
		* extra cases !
		local extra 1
		local Nplus1 = _N+1
		expand =`nat'-`Nplus1'+2 in l
		replace `touse' = 0 in `Nplus1'/l
	}
	tempvar T
	gen `T' = .
	forv i = 1/`nat' {
		replace `T' = `at`i'' in `i'
	}

	* replace _t0 in all but the first record within xid
	replace _t0 = -`Base'+`T'[`evid'-1] if (`markfl'==0 | `markfl'==2) & `touse'
	* replace _t in all but the last record within xid
	replace _t  = -`Base'+`T'[`evid']   if (`markfl'==0 | `markfl'==1) & `touse'
	* episode marker
	gen `vtype' `vname' = cond(`at1'>0,0,`at1'-1) if `evid'==1 & `touse'
	replace     `vname' = `T'[`evid'-1]           if `evid'!=1 & `touse'
	replace     `vname' = `T'[`nat']              if `evid'>=. & `touse'

	if "`extra'" != "" {
		drop in `Nplus1'/l
	}

	* modify user variables, reset _d
	ModifyUserVars, `codesplit'
	compress _t0 _t `vname'

	* trim (set _st to 0) episodes before at_min and after at_max
	* ----

	if "`trim'" != "" {
		local atmin `at1'
		local atmax `at`nat''

		count if float(`vname') < float(`atmin')  & `touse'
		local lb = r(N)
		count if float(`vname') == float(`atmax') & `touse'
		local ub = r(N)

		if `lb' | `ub' {
			replace _st = 0 if float(`vname') < float(`atmin') /*
			  */ | float(`vname') == float(`atmax')
			noi di as txt "(" `lb' " + " `ub' /*
			  */ " obs. trimmed due to lower and upper bounds)"
			if `lb' & `ub' {
				st_note `"`vname'<=`atmin' & `vname'>`atmax' trimmed"'
			}
			else if `lb' {
				st_note `"`vname'<=`atmin' trimmed"'
			}
			else 	st_note `"`vname'>`atmax' trimmed"'
		}
		else {
			noi di as txt "(no obs. trimmed because none out of range)"
		}
	}

	`Done'
} /* quietly */
end

* ============================================================================
* Every -- performs every() episode splitting
* ============================================================================

program define Every
	syntax newvarname(numeric) [=exp] [if] , Every(str) /*
	*/ [ AFter(passthru) COdesplit(passthru) noPREserve Fast ]

	local vname `varlist'
	local vtype `typlist'

quietly {
	tempname e ie it0 it nt xid

	marksample touse, novar
	replace `touse' = 0 if _st == 0

	if `"`exp'`after'"' != "" {
		tempvar Base
		After `Base' `exp' if `touse', `after'
	}
	else	local Base 0

	qui gen `e' = `every' if `touse'
	capt assert !missing(`e') if `touse'
	if _rc {
		noi di as err "option {bf:every()} must be nonmissing"
		exit 498
	}
	capt assert `e' > 0 if `touse'
	if _rc {
		noi di as err "option {bf:every()} must be strictly positive"
		exit 498
	}

	* in which intervals are _t0 and _t
	* coding: 1 [0,e)  2 [e,2e)  3 [2e,3e) etc
	gen `it0' = 1 + int((_t0+`Base')/`e')       if `touse'
	gen `it'  = 1 + int(((_t+`Base')/`e')-1E-8) if `touse'

	* number of intervals [_t0,_t)
	gen `nt'  = `it'-`it0'+1 if `touse' & _t >-`Base'
	gen `xid' = _n           if `touse'

	* expand!
	if "`preserve'" == "" & "`fast'" == "" {
		preserve
		local Done "restore, not"
	}
	drop `it'
	compress `e' `it0' `nt' `xid'
	recast double _t0
	recast double _t

	noi SaveExpand = `nt' if `touse'

	// intervals of size every
	// _t0 <= -`Base' < _t
	// indexed intervals start at 1 - # intervals between _t0 and -`Base'
	//		`it0'
	// -`Base' < _t0 <= _t
	// indexed intervals start at 1 + # intervals between _t0 and -`Base'
	//		`it0'
	// in both cases, `it' is 1 + # intervals between _t and  -`Base'
	
	// so nt = `it'-`it0' + 1 is the number of every intervals [_t0,t)
	// the extra + 1 accounts for overlap in the same interval and 
	// the final interval t )

	// fractional intervals are rounded to the closest integer toward zero
	// so the intervals will not over-partition [_t0,_t)
		
	// non-expanded
	// _to <= _t  < -`Base'
	// `it0' 1 - # intervals between _t0 and -`Base'
	// `it' 1 - # intervals between _t and -`Base'
	// not really relevant as no expansion
	// but `it0' value is used for episode marker

	// `ie', begins at `it0' and is incremented over each expanded
	// observation
	// so first _t will be -`Base' + Every*`it0'
	// second              -`Base' + Every*(`it0' + 1)
	// up to nit - 1
	// then _t = 	-`Base' + Every*((`it'-`it0'+1)-1)
	//		-`Base' + Every*`it' - Every*`it0'
	// episode marker is set as `Every'*(`it0'+_n-1)

	* adjust key-variables
	sort `xid'
	local obstype = c(obs_t)
	if "`obstype'" != "double" {
		local obstype "long"
	}
	by `xid' : gen `obstype' `ie'= `it0' + _n - 1      if `touse'
	by `xid' : replace _t0  = -`Base' + `e' * (`ie'-1) if _n > 1  & `touse'
	by `xid' : replace _t   = -`Base' + `e' * `ie'     if _n < _N & `touse'
	by `xid' : replace _d   = -1                       if _n < _N & `touse'

	* set episode marker
	gen `vtype' `vname' = 0 if `touse'
	by `xid' : replace `vname' = `e' * (`ie'-1)        if `touse'

	* adjust user variables, reset _d
	ModifyUserVars, `codesplit'

	compress _t0 _t `vname'
	`Done'
} /* quietly */
end

* ===========================================================================
* utility routines
* ===========================================================================

program define After
	syntax newvarname [=/exp] [if] [, AFter(str) ]

	local v `varlist'
	marksample touse, novarlist

	if `"`exp'"' != "" & `"`after'"' != "" {
		di as err "={it:exp} and {bf:after()} may not be specified together"
		exit 198
	}
	else if `"`exp'"' != "" {
		* for backward compatibility with version 1.*.*
		local Exp   `exp'
		local ttime time
		local how   min
	}
	else {
		local 0 `"= `after'"'
		capt syntax =/exp
		if !_rc {
			local Exp   `exp'
			local ttime time
			local how   asis
		}
		else {
			gettoken ttime rest : after , parse("= ")
			if `"`ttime'"' != "time" & `"`ttime'"' != "t" /*
			*/ & `"`ttime'"' != "_t" {
				di as err `"invalid option {bf:after()}: `ttime'"'
				exit 198
			}
			gettoken op fexp : rest , parse("=")
			if "`op'" != "=" {
				di as err `"invalid option {bf:after()}: "=" expected"'
				exit 198
			}
			local 0 `"= `fexp'"'
			capt syntax =/exp
			if !_rc {
				local Exp  `exp'
				local how  const
			}
			else {
				gettoken func exp : fexp, parse("(")
				if "`func'" == "asis" | "`func'" == "min" {
					local how `func'
					gettoken Exp rest : exp, parse("(") match(paren)
					if `"`rest'"' != "" | "`paren'" != "(" {
						di as err `"invalid {it:exp} in option {bf:after()}: `fexp'"'
						exit 198
					}
				}
				else {
					di as err "invalid option {bf:after()}: {bf:asis()} or {bf:min()} expected"
					di as err `"found: `fexp'"'
					exit 198
				}
			}
		}
	}

	*di in re "exp   : `Exp'"
	*di in re "ttime : `ttime'"
	*di in re "how   : `how'"

	* Base will contain the "age" at 0 in analysis t units
	local id `_dta[st_id]'

	sort `touse' `id' _t
	gen double `v' = `Exp' if `touse'

	if "`how'" == "min" {
		* we take earliest value of time/date
		* to avoid sorting, the min is stored in last element
		by `touse' `id' : /*
		*/ replace `v' = `v'[_n-1] if `v'[_n-1]<`v' & `touse'
	}
	else if "`how'" == "const" {
		* verify that base() is constant within id
		capt by `touse' `id' : assert `v' == `v'[1] if `touse'
		if _rc {
			di as err "option {bf:after()} must be constant within {bf:`id'}"
			exit 198
		}
	}

	if "`ttime'" == "time" {
		local o `_dta[st_o]'
		local s `_dta[st_s]'

	}
	else {
		local o 0
		local s 1
	}
	by `touse' `id' : replace `v' = (`o'-`v'[_N])/`s' if `touse'
	compress `v'
end

* SaveExpand =exp [if] [in]
* wrapper around -expand-, producing message on memory requirement
program define SaveExpand
	syntax =/exp [if] [in]

	marksample touse
	capt expand =`exp' if `touse'
	if _rc {
		tempvar nrec
		quiet gen long `nrec' = cond(`touse', int(`exp'), 1)
		quiet summ `nrec', meanonly
		local nobs = r(sum)

		* compute memory requirement (in kb)
		quiet des, short
		local kb = int((`nobs' * r(width))/1024 + 1)

		di _n as err "impossible to split episodes -- probably too little memory"
		di
		local nobs = string(`nobs',"%14.0fc")
		di as txt "expanded dataset would have {res:`nobs'} observations"
		di as txt "memory should be set to at least {res:`kb'} Kb " /*
			*/ "at the current data width"
		di as txt "with extra memory for additional variables"
		exit 950
	}
end

* Created n0
* Reports number of created obs since n0
program define Created
	args n0

	if `n0' != _N {
		local s = cond(_N-`n0'>1, "s", "")
		local nobs = string(_N - `n0', "%14.0fc")
		di as txt "(`nobs' observation`s' (episode`s') created)"
	}
	else {
		di as txt "(no new episodes generated)"
	}
end

* IsVar vname
* returns in s(exist) whether vname is an existing variable
program define IsVar, sclass
	nobreak {
		capture confirm new var `1'
		if _rc {
			capture confirm var `1'
			if _rc == 0 {
				sreturn local exists 1
				exit
			}
		}
	}
	sreturn local exists 0
end

* ModifyUserVars, codesplit(.|#)
* - modifies user variables for _t/_t0 and for event type (failure())
* - recodes -1 to 0 in _d
program define ModifyUserVars
	syntax [, COdesplit(str)]

	IsVar `_dta[st_bt]'
	if `s(exists)' {
		qui replace `_dta[st_bt]'  = _t  * `_dta[st_s]' + `_dta[st_o]' if _st
	}

	IsVar `_dta[st_bt0]'
	if `s(exists)' {
		qui replace `_dta[st_bt0]' = _t0 * `_dta[st_s]' + `_dta[st_o]' if _st
	}

	IsVar `_dta[st_bd]'
	if `s(exists)' {
		if `"`codesplit'"' == "" | `"`codesplit'"' == "." {
			local c .
		}
		else {
			capt confirm number `codesplit'
			if _rc {
				di as err "codesplit() must be a number"
				exit 198
			}
			local c `codesplit'
		}
		qui replace `_dta[st_bd]' = `c' if _d == -1
	}
	qui replace _d = 0 if _d==-1
end

* DropDup newlist : list
* drops all duplicate tokens from list -- copied from hausman.ado
program define DropDup
	args newlist	/*  name of macro to store new list
	*/   colon	   /*  ":"
	*/   list	   /*  list with possible duplicates */

	gettoken token list : list
	while "`token'" != "" {
		local fixlist `fixlist' `token'
		local list : subinstr local list "`token'" "", word all
		gettoken token list : list
	}

	c_local `newlist' `fixlist'
end

* Assert label exp
program define Assert
	gettoken lab 0 : 0
	capt noi assert `0'
	if _rc {
		di as err "assert `lab' failed"
		exit 9
	}
end

exit

History
-------

2.2.0  update using features of Stata 7 (smcl, forvalues); 
       no functional changes

2.1.2  changed the type of various internally used variables from -int- 
       to -long- to fix invalid splitting in large datasets

2.1.0  totally new version by jw/ics
       - added splitting at failure times
       - new implementation of at()
       - added every()
       - more features in after(), replacing the old =exp syntax
