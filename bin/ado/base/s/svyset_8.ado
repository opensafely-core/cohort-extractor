*! version 2.1.2  29sep2004
program define svyset_8
	version 8, missing
	if _caller() < 8 {
		svyset_7 `0'
		Clear
		exit
	}
	syntax [pweight iweight/]	/*
	*/ [,				/*
	*/ STRata(varname)		/*
	*/ psu(varname)			/*
	*/ fpc(varname)			/*
	*/ SRS				/*
	*/ *				/*
	*/ ]

	local wtype `weight'
	local wexp `exp'

	local 0 , `options'
	capture syntax [, clear ]	/* shortcut for clear(all) */
	if _rc {
		syntax [, clear(string) ]
	}

	/* check options */
	if _N == 0 {
		di as err "no variables defined"
		exit 111
	}
	if `"`clear'"' != "" {
		Clear , `clear'
	}
	if `"`wtype'"' != "" {
		Check_weight `wtype' `wexp'
		Set `wtype' `wexp'
	}
	if `"`strata'"' != "" {
		Check_var `strata'
		Set strata `strata'
	}
	if `"`psu'"' != "" {
		Check_var `psu'
		Set psu `psu'
	}
	if `"`fpc'"' != "" {
		Check_fpc `fpc'
		Set fpc `fpc'
	}
	if `"`srs'"' != "" {
		Set srs __srs__
	}
	Display
end

program define Clear
	syntax , [IWeight PWeight STRata psu fpc SRS all clear]
	if `"`iweight'`pweight'"' != "" {
		local svysets iweight pweight
	}
	if `"`all'"' != "" | `"`clear'"' != "" {
		local svysets iweight pweight strata psu fpc srs
	}
	else	local svysets `svysets' `strata' `psu' `fpc' `srs'
	foreach name of local svysets {
		char _dta[`name']
	}
	/* clear _svy characteristic if not SRS and no vars are set */
	Get
end

program define Set
	if `"`0'"' == "" {
		di as error "svyset:  error in subroutine Set"
		exit 198
	}
	args setting varlist
	gettoken setting 0 : 0
	if "`varlist'" != "__srs__" {
		syntax varname
	}
	Clear , `setting'
	char _dta[`setting'] `varlist'
	SVYFlag 1
end

program define SVYFlag, rclass
	args set
	if `"`set'"' == "?" {
		local set : char _dta[_svy]
		return local _svy `set'
	}
	else if  `set' {
		char _dta[_svy] set
		return local _svy set
	}
	else    char _dta[_svy]
end

program define Check_srs
	args strata psu 

	if "`strata'" != "" {
		di as err ///
	"a strata variable may not be set with simple random sampling (SRS)"
		exit 198
	}
	if "`psu'" != "" {
		di as err ///
	"a psu variable may not be set with simple random sampling (SRS)"
		exit 198
	}
end

program define Check_fpc
	syntax varname
	capture confirm string variable `varlist'
	if _rc==0 {
		di as error "fpc may not be a string variable"
		exit 109
	}
end

program define Check_var
	args var
	capture confirm variable `var'
	if _rc {
		di as err "`var' found where variable expected"
		exit 198
	}
end

program define Check_weight
	gettoken weight exp : 0
	Check_var `exp'
	capture confirm numeric variable `exp'
	if _rc {
		di as error "`exp' found where numeric variable expected"
		exit 198
	}
	if `"`weight'"' == "pweight" {
		capture assert `exp' >= 0
		if _rc {
			di as txt "note:  negative pweight(s)"
		}
	}
end

/*
	returns in r():
		r(_svy)		"set"				or ""
		r(wexp)		"= <varname>"			or ""
		r(iweight)	varname				or ""
		r(pweight)	varname 			or ""
		r(wtype)	"pweight" or "iweight"		or ""
		r(strata)	strata varname			or ""
		r(psu)		psu varname			or ""
		r(fpc)		fpc varname			or ""
		r(srs)		"__srs__"			or ""
		r(settings)	svyset command to reproduce current settings
*/
program define Get, rclass
	local iweight : char _dta[iweight]
	local pweight : char _dta[pweight]

	if `"`iweight'"' != "" & `"`pweight'"' != "" {
		di as error "error in setting of weights," /*
		*/ " both pweights and iweights are currently set"
		exit 198
	}
	if `"`iweight'"' != "" {
		quietly Check_weight iweight `iweight'
		return local wtype iweight
		return local iweight `iweight'
		return local wexp "= `iweight'"
		local settings "[iweight=`iweight']"
	}
	if `"`pweight'"' != "" {
		quietly Check_weight pweight `pweight'
		return local wtype pweight
		return local pweight `pweight'
		return local wexp "= `pweight'"
		local settings "[pweight=`pweight']"
	}
	local comma ","
	local strata : char _dta[strata]
	if `"`strata'"' != "" {
		Check_var `strata'
		return local strata `strata'
		local settings "`settings'`comma' strata(`strata')"
		local comma
	}
	local psu : char _dta[psu]
	if `"`psu'"' != "" {
		Check_var `psu'
		return local psu `psu'
		local settings "`settings'`comma' psu(`psu')"
		local comma
	}
	local fpc : char _dta[fpc]
	if `"`fpc'"' != "" {
		Check_fpc `fpc'
		return local fpc `fpc'
		local settings "`settings'`comma' fpc(`fpc')"
		local comma
	}
	local srs : char _dta[srs]
	if `"`srs'"' != "" {
		Check_srs "`strata'" "`psu'"
		return local srs `srs'
		local settings "`settings'`comma' srs"
		local comma
	}
	if `"`iweight'`pweight'`strata'`psu'`fpc'`srs'"' != "" {
		SVYFlag 1
		return add
	}
	else {
		SVYFlag 0
	}
	return local settings "`settings'`comma' clear(all)"
end

program define Display
	Get
	if `"`r(wtype)'"' != "" {
		di as txt "`r(wtype)' is `r(`r(wtype)')'"
	}
	if `"`r(strata)'"' != "" {
		di as txt "strata is `r(strata)'"
	}
	if `"`r(psu)'"' != "" {
		di as txt "psu is `r(psu)'"
	}
	if `"`r(fpc)'"' != "" {
		di as txt "fpc is `r(fpc)'"
	}
	if `"`r(srs)'"' != "" {
		di as txt "simple random sample (SRS)"
	}
	else if `"`r(_svy)'"' == "" {
		Clear , all
		di as txt "no variables are set"
		exit
	}
end
exit
