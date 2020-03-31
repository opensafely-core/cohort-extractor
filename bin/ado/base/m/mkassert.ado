*! version 1.4.0  30nov2018
program define mkassert
	version 8

	local lsize : set linesize
	capture noisily {   // ensure Ctrl-Break is properly handled

		set linesize 255
		gettoken subcmd 0 : 0, parse(" ,")

		local len = length(`"`subcmd'"')
		if `"`subcmd'"' == bsubstr("rclass", 1, `len') {
			RCLASS `0'
		}
		else if `"`subcmd'"' == bsubstr("eclass", 1, `len') {
			ECLASS `0'
		}
		else if `"`subcmd'"' == bsubstr("sclass", 1, max(3,`len')) {
			SCLASS `0'
		}
		else if `"`subcmd'"' == bsubstr("obs", 1, `len') {
			OBS `0'
		}
		else if `"`subcmd'"' == bsubstr("matrix", 1, `len') {
			MATRICES `0'
		}
		else if `"`subcmd'"' == bsubstr("scalar", 1, max(3,`len')) {
			SCALARS `0'
		}
		else if `"`subcmd'"' == bsubstr("char", 1, `len') {
			CHARS `0'
		}
		else if `"`subcmd'"' == bsubstr("format", 1, `len') {
			FORMATS `0'
		}
		else {
			di as err `"unknown subcommand `subcmd'"'
			exit 198
		}

	} /* capture */

	nobreak {
		local rc = _rc
		CloseFile
		mac drop T_mkassert*
		set linesize `lsize'
		exit `rc'
	}
end

// ----------------------------------------------------------------------------
// handlers for subcommands
// ----------------------------------------------------------------------------

program define RCLASS
	syntax [, MFmt(str) MTol(str) SFmt(str) STol(str) MWrap(int 5)  ///
	          Name(str) SAVing(str) NOSTRIPEs TMPnames]
	tempname foo
	_return hold `foo'
	OpenFile `saving'
	_return restore `foo'
	IncludeReference `name'

	ClassMacros   "r"
	ClassScalars  "r" "`sfmt'" "`stol'"
	ClassMatrices "r" "`mfmt'" "`mtol'" "`mwrap'" "`nostripes'" "`tmpnames'"

end /* RCLASS */


program define ECLASS
	syntax [, MFmt(str) MTol(str) SFmt(str) STol(str) MWrap(int 5)   ///
	          Name(str) SAVing(str) NOSTRIPEs TMPnames ]

	OpenFile `saving'
	IncludeReference `name'

	ClassMacros   "e"
	ClassScalars  "e" "`sfmt'" "`stol'"
	ClassMatrices "e" "`mfmt'" "`mtol'" "`mwrap'" "`nostripes'" "`tmpnames'"

end /* ECLASS */


program define SCLASS
	syntax [, Name(str) SAVing(str) ]

	OpenFile `saving'
	IncludeReference `name'

	ClassMacros "s"

end /* SCLASS */


program define FORMATS
	syntax [varlist(default=none)] [, Name(str) SAVing(str) ]

	OpenFile `saving'
	IncludeReference `name'

	foreach v of local varlist {
		Format "`v'"
	}

end /* FORMAT */


program define CHARS
	syntax [varlist(default=none)] [, dta Name(str) SAVing(str) sort]

	OpenFile `saving'
	IncludeReference `name'

	if "`dta'" != "" {
		Char "_dta" "`sort'"
	}
	foreach v of local varlist {
		Char "`v'" "`sort'"
	}

end /* CHAR */


program define SCALARS

	syntax anything(id="scalars") [, SFmt(str) STol(str) Name(str) SAVing(str) ]

	local names `"`anything'"'
	confirm names `names'

	NumFmt fmt : `sfmt'
	SetTol tol nametol : `stol'

	NameLength `names'
	local col = 23 + $T_mkassert_length
	local col2 = `col' + 22

	OpenFile `saving'
	IncludeReference `name'

	if "`nametol'" != "" {
		di _n "{txt}local {res:`nametol' `tol'}  /* tolerance for scalars */"
		local tol "{c 'g}`nametol''"
	}

	foreach s of local names {
		if scalar(`s') == int(scalar(`s')) {
			// assert scalar(s) == value

			di "{txt}assert{space 9}scalar({res:`s'}) " ///
			   "{col `col'}== {res}" scalar(`s') _c
			WriteReference
		}
		else {
			// assert reldif( scalar(s) , value ) < tol

			local value : display `fmt' scalar(`s')
			di `"{txt}assert reldif( scalar({res:`s'}) {col `col'} , {res}"' ///
			   trim("`value'") `"{txt}{col `col2'}) < {res}`tol'"' _c
			WriteReference
		}
	}

end /* SCALARS */


program define MATRICES

	syntax anything(id="matrix") [, MFmt(str) MTol(str) MWrap(int 5) Name(str) SAVing(str) NOSTRIPEs TMPnames ]

	local names `anything'
	confirm names `names'

	NumFmt fmt : `mfmt'
	SetTol tol nametol : `mtol'

	OpenFile `saving'
	IncludeReference `name'

	if "`nametol'" != "" {
		di _n "{txt}local {res:`nametol' `tol'}  /* tolerance for matrices */" _n
		local tol "{c 'g}`nametol'"
	}

	if ("`tmpnames'"!="") {
		local qq1 "{c 'g}"
		local qq2 "'"
	}
	foreach m of local names {
		// define the temp matrix T_M as a copy of m,
		WriteMatrix "T_`m'" "`m'" "`fmt'" "`mwrap'" "`tmpnames'"

		// saves row and col labels in locals
		local rfn : rowfullnames `m'
		local cfn : colfullnames `m'

		// assert mreldif( m, T_m) < tol
		di `"{txt}assert mreldif( {res:`m'} , "' ///
		   `"`qq1'{res:T_`m'}`qq2' ) < {res:`tol'}"' _c
		WriteReference

		if !`:length local nostripes' {
			// check row and column labels
			di `"{txt}_assert_streq `"{c 'g}: rowfullnames {res:`m'}'"' `"{res:`rfn'}"'"' _c
			WriteReference
			di `"{txt}_assert_streq `"{c 'g}: colfullnames {res:`m'}'"' `"{res:`cfn'}"'"' _c
			WriteReference
		}

		// drop T_m
		di "{txt}mat drop `qq1'{res:T_`m'}`qq2'" _n
	}
end /* MATRICES */


program define OBS

	syntax [varlist] [if] [in], id(passthru) [ ///
          Computed(passthru) Name(str) SAVing(str) ]

	OpenFile `saving'
	IncludeReference `name'

	// verify data definitions
	_assert_obs define `varlist' , `id' `computed'

	// write data definition globals
	di "{txt}global T_mkassert_obs_n{col 28}{res}$T_mkassert_obs_n"
	di "{txt}global T_mkassert_obs_id{col 28}{res}$T_mkassert_obs_id"

	forvalues iv = 1 / $T_mkassert_obs_n {

		di "{txt}global T_mkassert_obs_v`iv'{col 28}{res}${T_mkassert_obs_v`iv'}"
		di "{txt}global T_mkassert_obs_vt`iv'{col 28}{res}${T_mkassert_obs_vt`iv'}"
		if "${T_mkassert_obs_tol`iv'}" != "" {
			di "{txt}global T_mkassert_obs_tol`iv'{col 28}{res}${T_mkassert_obs_tol`iv'}"
		}

		if `"${T_mkassert_obs_vl`iv'}"' != "" {
			di `"{txt}global T_mkassert_obs_vl`iv'{col 28}{res}`"${T_mkassert_obs_vl`iv'}"'"'
		}

	}
	di _n "{txt}_assert_obs begincheck"

	local N = _N
	di "{txt}assert _N==`N'"

	marksample touse , novarlist
	forvalues i = 1/`N' {
		if !`touse'[`i'] {
			continue
		}

		local values
		forvalues iv = 1 / $T_mkassert_obs_n {
			if "${T_mkassert_obs_vt`iv'}" == "string" {
				local value = ${T_mkassert_obs_v`iv'}[`i']
				local values `"`values'  `"`value'"'"'
			}

			else if "${T_mkassert_obs_vt`iv'}" == "integer" {
				local value = ${T_mkassert_obs_v`iv'}[`i']
				local values `"`values'  `value'"'
			}

			else if "${T_mkassert_obs_vt`iv'}" == "real" {
				local value : display %18.0g ${T_mkassert_obs_v`iv'}[`i']
				local value = trim("`value'")
				local values `"`values'  `value'"'
			}

			else {
				di as err "mkassert OBS : this should not happen"
				exit 9999
			}
		}
		di as txt `"_assert_obs check `i' `values'"'
	}

	di as txt "_assert_obs endcheck"
end /* OBS */


// ----------------------------------------------------------------------------
// subroutines / utility commands
// ----------------------------------------------------------------------------


/* ClassMacros type := < r | e | s >

   processes the macros in r(), e(), or s().
   no error checking on type
*/
program define ClassMacros
	args type

	local mac : `type'(macros)
	local exclude marginsprop
	local mac : list mac - exclude
	if "`mac'" == "" {
		exit
	}

	NameLength `mac'
	local col = 18 + $T_mkassert_length

	// check that no unexpected scalar is returned
	// di as txt "local mac0 : `type'(macros)"
	// di as txt `"assert `"\`mac0'"' {col `col'}== `"`mac'"' "'

	di
	foreach m of local mac {
		local macn `type'(`m')
		local value "``macn''"
		/*
		capt confirm number `value'
		
		if !_rc {
			if `value' == int(`value') {
				di `"{txt}assert   {c 'g}{res:`macn'}' "' ///
				   `"{col `col'}== {res:`value'}"' _c
			}
			else {
				di `"{txt}assert float({c 'g}{res:`macn'}') "' ///
			       `"{col `col'}== float({res:`value'})"' _c
			}
		}
		else 
		*/
		if length(`"`value'"') > 75 {
			di `"{txt}_assert_streq `"{c 'g}{res:`macn'}'"' "' ///
			   `"`"{res:`value'}"'"' _c
		}
		else {
			di `"{txt}assert `"{c 'g}{res:`macn'}'"' "' ///
			   `"{col `col'}== `"{res:`value'}"'"' _c
		}
		WriteReference
	}
end


program define ClassScalars
	args type sfmt stol

	local scalars : `type'(scalars)
	local exclude ic
	local scalars : list scalars - exclude
	if "`scalars'" == "" {
		exit
	}

	NumFmt fmt : `sfmt'
	SetTol tol nametol : `stol'

	NameLength `scalars'
	local col = 20 + $T_mkassert_length
	local col2 = `col' + 21

	// check that no unexpected scalar is returned
	// di as txt "local scalars0 : `type'(scalars)"
	// di as txt `"assert `"\`scalars0'"' == `"`scalars'"'"'

	if "`nametol'" != "" {
		* local stol 1e-8
		di _n "{txt}local {res:`nametol' `tol'}  /* tolerance for scalars */"
		local tol "{c 'g}`nametol''"
	}

	di
	foreach s of local scalars {
		local stat `type'(`s')
		if `stat' == int(`stat') {
			// assert t(s) == value
			di "{txt}assert{space 9}`type'({res:`s'}) " ///
			   "{col `col'}== {res}" `stat' _c
		}
		else {
			// assert reldif( t(s) , value ) < tol
			local value : display `fmt' `type'(`s')
			di "{txt}assert reldif( `type'({res:`s'}) {col `col'} , {res}" /*
			 */ trim("`value'") "{txt}{col `col2'}) < {res} `tol'" _c
		}
		WriteReference
	}
end /* ClassScalars */


program define ClassMatrices
	args type mfmt mtol mwrap nostripes tmpnames

	local matrices : `type'(matrices)
	local exclude ilog
	local matrices : list matrices - exclude
	if "`matrices'" == "" {
		exit
	}

	NumFmt fmt : `mfmt'
	SetTol tol nametol : `mtol'

	// check that no unexpected matrix is returned
	// di as txt "local matrices0 : `type'(matrices)"
	// di as txt `"assert `"\`matrices0'"' == `"`matrices'"' "'

	if "`nametol'" != "" {
		di _n "{txt}local {res:`nametol' `tol'}  /* tolerance for matrices */"
		local tol "{c 'g}`nametol''"
	}

	if ("`tmpnames'"!="") {
		local qq1 "{c 'g}"
		local qq2 "'"
	}
	tempname M
	foreach m of local matrices {
		di
		mat `M' = `type'(`m')
		WriteMatrix "T_`m'" "`M'" "`fmt'" "`mwrap'" "`tmpnames'"

		// saves row and col labels in locals
		local rfn : rowfullnames `M'
		local cfn : colfullnames `M'

		if ("`tmpnames'"!="") {
			// tempname C_m
			di "{txt}tempname {res}C_`m'"
		}

		// matrix C_m = type(m)
		di "{txt}matrix `qq1'{res:C_`m'}`qq2' = `type'({res:`m'})"

		// assert mreldif(C_m,T_m) < tol
		local value = "`type'(`m')"
		di `"{txt}assert mreldif( `qq1'{res:C_`m'}`qq2' , "' ///
		   `"`qq1'{res:T_`m'}`qq2' ) < {res:`tol'}"' _c
		WriteReference

		if !`:length local nostripes' {
			// check row and column labels
			di `"{txt}_assert_streq `"{c 'g}: rowfullnames `qq1'{res:C_`m'}`qq2''"' `"{res:`rfn'}"'"' _c
			WriteReference
			di `"{txt}_assert_streq `"{c 'g}: colfullnames `qq1'{res:C_`m'}`qq2''"' `"{res:`cfn'}"'"' _c
			WriteReference
		}

		// drop C_m T_m
		di "{txt}mat drop `qq1'{res:C_`m'}`qq2' `qq1'{res:T_`m'}`qq2'"
	}
	mac drop T_mkassert_row T_mkassert_col
end /* ClassMatrices */


program define Format
	args name

	capture local format : format `name'
	if "`format'" == "" {
		exit
	}

	di _n "{res}* `name' format"
	// * assert format of `name' is "value"
	di `"{txt}_assert_streq `"{res:{c 'g}:format `name''}"' "' ///
	   `"`"{res:`:format `name''}"'"' _c
	WriteReference
end /* Format */


program define Char
	args name sort

	local chlist : char `name'[]
	if "`chlist'" == "" {
		exit
	}

	NameLength `chlist'
	local col = 17 + length("`name'") + $T_mkassert_length

	if "`sort'" != "" {
		local chlist : list sort chlist
	}

	di _n "{res}* `name'[] characteristics"
	foreach ch of local chlist {
		// * assert name[ch] == "value"
		di `"{txt}_assert_streq `"{res:{c 'g}`name'[`ch']'}"' "' ///
		   `"`"{res:``name'[`ch']'}"'"' _c
		WriteReference
	}
end /* Char */


program define WriteMatrix
	args name M mfmt nwrap tmpnames

	local nr = rowsof(matrix(`M'))
	local nc = colsof(matrix(`M'))

	if ("`tmpnames'"!="") {
		di "{txt}tempname {res:`name'} "
		local qq1 "{c 'g}"
		local qq2 "'"
	}

	if `nr'`nc' == 11 {
		di as txt "mat `qq1'{res:`name'}`qq2'= " ///
		   as res `mfmt' `M'[1,1]
		exit
	}
	di "{txt}qui {"
	di "{txt}mat `qq1'{res:`name'}`qq2' = J(`nr',`nc',0)"

	forval i = 1/`nr' {
		forval j = 1/`nc' {
		    if `M'[`i',`j'] {
			di as txt "mat `qq1'{res:`name'}`qq2'[`i',`j'] = " ///
			   as res `mfmt' `M'[`i',`j']
		    }
		}
	}
	di "{txt}}"

end /* WriteMatrix */


/* NameLength unquoted-list

   return the max length of the arguments in the global
   T_mkassert_length (in order not to disturb other objects).
*/
program define NameLength
	tempname len
	scalar `len' = 0
	local i 1
	while `"``i''"' != "" {
		scalar `len' = max(`len',length(`"``i''"'))
		local ++i
	}
	global T_mkassert_length = `len'
end /* NameLength */


/* NumFmt lname1 : lname2

   return in local lname1 lname2 if it is a valid numerical format, the
   default format (18.0g) if lname2 is not defined, and displays an error
   message if lname2 is not a valid display format.

   Space around the colon are required! lname1/lname2 may not be the same.
*/
program define NumFmt
	args efmt colon fmt

	if "`fmt'" != "" {
		// forces an error message
		local tmp : display `fmt' 1
	}
	else	local fmt %18.0g

	c_local `efmt' `fmt'
end


program define SetTol
	args etol ntol colon tol dtol

	if "`colon'" != ":" {
		di as err "SetTol: syntax error"
		exit 198
	}

	if `"`tol'"' != "" {
		capt confirm number `tol'
		if _rc {
			confirm name `tol'
			local n `tol'
			if "`dtol'" != "" {
				confirm number `dtol'
				local t `dtol'
			}
			else 	local t 1E-8 /* default  tolerance */
		}
		else	local t `tol'
	}
	else 	local t 1E-8

	c_local `etol' `t'	// tolerance to be used
	c_local `ntol' `n'	// name of tolerance, or empty
end


/* OpenLog filename [, append replace]

   Opens an text log in file name, storing information about a possibly
   open log in global T_mkassert macros.
*/
program define OpenFile
	if `"`0'"' == "" {
		exit
	}

	local 0 using `0'
	syntax using [, append replace ]

	quietly {
		log
		ret list
		if "`r(type)'" != "" {
			global T_mkassert_logtype      `r(type)'
			global T_mkassert_logstatus    `r(status)'
			global T_mkassert_logfilename  `"`r(filename)'"'
			log close
		}
	}
	global T_mkassert_restorelog 1   // flag for CloseLog

	quietly log `using' , `append' `replace' text
end /* OpenLog */


/* CloseFile

   Closes the file for mkassert, restoring the original
   log file if any.
*/
program define CloseFile

	if "$T_mkassert_restorelog" == "" {
		exit
	}

	// close log file with assert -output
	quietly log
	local fn `"`r(filename)'"'
	quietly log close

	di _n as txt `"(text output was written to file `fn')"'

	// re-open former logfile
	if "$T_mkassert_logtype" != "" {
		quietly log using `"$T_mkassert_logfilename"' , ///
			append $T_mkassert_logtype
		if "$T_mkassert_logtype" == "off" {
			quietly log off
		}
	}
end /* CloseFile */


/* IncludeReference name
   sets globals for writing references to assert statements
*/
program define IncludeReference
	args name

	if "`name'" != "" {
		global T_mkassert_name `name'
		global T_mkassert_counter 0
	}
end


/* WriteReference

   Writes a references to an assert statement

   We expect assert statements to be written with a line continuation marker,
   thus even if no reference has to be written, we have to write a newline.
*/
program define WriteReference
	if "$T_mkassert_name" != "" {
		global T_mkassert_counter = $T_mkassert_counter + 1
		di _col(80) as txt `"  /* $T_mkassert_name$T_mkassert_counter */"'
	}
	else display
end

exit
