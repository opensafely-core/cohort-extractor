*! version 1.1.0  13feb2015
program define bs_7
	version 6, missing
	local version : di "version " string(_caller()) ", missing:"
	gettoken cmd   0: 0
	gettoken stats 0: 0

	if `"`cmd'"'==`""' { error 198 }
	if `"`stats'"'==`""' {
		di in red `"list of statistics not found"'
		exit 111
	}
	tokenize `"`stats'"'

/* Display command and list of statistics. */

	di in gr _n `"command:     `cmd'"'

	if `"`2'"'==`""' { di in gr `"statistic:   `stats'"' }
	else	           di in gr `"statistics:  `stats'"'

/* Run command to see if it runs without error. */

	capture `version' `cmd'
	if _rc {
		if _rc==1 { error 1 }
		di in red `"error when command executed on original dataset"'
		error _rc
	}

/* Check list of statistics. */

	tempname x
	local stats /* erase macro */
	local i 1
	while `"``i''"'!=`""' {
		local vl     `"`vl' bs`i'"'
		local labs   `"`labs' ``i''"'
		local stats  `"`stats' (``i'')"'

		Dollar ``i''

		capture scalar `x' = `s(mac)'
		if _rc {
			sret clear
			di in red `"error in statistic: ``i''"'
			exit 198
		}
		local i = `i' + 1
	}
	sret clear

/* Stuff in `0', if anything, should be options. */

	capture syntax [, NOWARN NOESAMPLE *]
	if _rc {
		di in red `"must enclose command in quotes and "' /*
		*/ `"list of statistics in quotes"'
		exit _rc
	}
	local 0 , `options'

/* do the resample check */
	_resamplecheck bs "`cmd'" "`nowarn'"
	if `"`s(needpreserve)'"' != "" & `"`noesample'"' == "" {
		preserve
		keep if e(sample)
	}

	global S_bs_vl  `"`vl'"'
	global S_bs_lab `"`labs'"'
	global S_bs_cmd `"`cmd'"'
	global S_bs_ver `"`version'"'
	global S_bs_st  `"`stats'"'

	bstrap _BS `0' /* program _BS is in bstrap.ado file */

	global S_bs_st
	global S_bs_ver
	global S_bs_cmd
	global S_bs_lab
	global S_bs_vl
	global S_bs_noi
end

program define Dollar, sclass /* put $ in front of any S_ */
	args mac
	sret clear
	local i = index(`"`mac'"',`"S_"')
	local n = length(`"`mac'"')
	local j 1
	while `i' != 0 & `j' <= `n' {
		local front = bsubstr(`"`mac'"',1,`i'-1)
		local back  = bsubstr(`"`mac'"',`i',.)
		local mac `"`front'$`back'"'
		local i = index(`"`mac'"',`"S_"')
		local j = `j' + 1 /* prevents infinite loop if error */
	}
	sret local mac `"`mac'"'
end

program define _resamplecheck, sclass
	version 7, missing
	args caller cmd nowarn
	if `"`nowarn'"'!="nowarn" {
		local nowarn warn
	}
	cap est hold __j_resample
	cap `cmd'
	/* let the caller handle any errors */
	if ! _rc {
		if `"`e(cmd)'"' == "" { /* cmd is not eclass */
			`nowarn' "`caller'" "`cmd'"
		}
		else { /* check for unused observations */
			cap assert e(sample)==1
			if _rc {
				cap assert e(sample)==0
				if _rc {
/***				caller should preserve then keep if e(sample) */
					sret local needpreserve yes
					cap est drop __j_resample
				}
				else {
					`nowarn' "`caller'" "`cmd'"
				}
			}
		}
	}
	cap est unhold __j_resample
end

program define nowarn
	version 7
end

program define warn
	version 7
	args caller command

	gettoken cmd : command
  di in smcl as txt ""
  di `"{p 0 10} Warning:  Since {cmd:`cmd'} is not an estimation command "' _c
  di `"or does not set {cmd:e(sample)}, "' _c
  di `"{cmd:`caller'} has no way to determine which observations are used "' _c
  di `"in calculating the statistics and so assumes that all observations "' _c
  di `"are used.  This means no observations will be excluded from the "' _c
  di `"resampling due to missing values or other reasons."' _n

  di `"{p 10 10} If the assumption is not true, press Break, save the "' _c
  di `"data, and drop the observations that are to be excluded. "'
  di `"Be sure the dataset in memory contains only the relevant data."' _n

end

exit

------------------------------------------------------------------------------
NOTES
------------------------------------------------------------------------------

This command is to be used with resampling routines that accept Stata
commands.  The problem here is that there may be some missing values in a
variable in the model, thus the actual number of data observations is not
equal to the number of observations used in estimation.

Saved Results:

-_resamplecheck- is an -sclass- command:

Macros:

  s(needpreserve)     "yes" or ""

When -s(needpreserve)- is "yes", the caller should do the following before
it starts resampling.

     . preserve
     . keep if e(sample)

<end>

