*! version 2.4.12  23oct2013
program varirf_ctable, rclass
	version 8.0
	syntax anything(name=tabspeclist id="table specifications")	/*
	*/ [,							/*
	*/ INdividual						/*
	*/ STep(numlist max=1 integer >0 <=500)			/* 
	*/ Level(passthru)					/*
	*/ noCI							/*
	*/ STDerror						/*
	*/ set(string)						/*
	*/ TItle(string)					/*
	*/ ]

	if "`ci'" != "" & "`level'" != "" {
		di as err "{cmd:noci} and {cmd:level()} cannot "	/*
			*/ "both be specified"
		exit 198
	}

	local zero `0'
	local 0 ", `level'"
	local backopt `options'
	syntax [, level(cilevel)]
	local 0 `zero'
	local options `backopt'

/* remap ci to g_ci and stderror -> g_stderror */
	if "`ci'" != "" {
		local g_ci noci
		local ci 
	}

	if "`stderror'" != "" {
		local g_stderror stderror
		local stderror 
	}

	/* check options */

	/* global options that conflict with options in `tabspeclist' are
	 * given the "g_" prefix
	 */

	local g_title `title'
	
	if "`level'" == "" {
		local g_level $S_level
	}
	else {
		local g_level `level'
	}

	/* set a new varirf data file */
	if `"`set'"' != "" {
		varirf set `set'
	}
	
	preserve
	_virf_use
	if "`step'" != "" {
		qui keep if step <= `step' + 1
	}	

	/* See NOTES at bottom of this file. */

	local k 0
	local k_u 0
	tempvar jvar
	qui gen int `jvar' = .
	local tspecid table specification

	/* BEGIN parse through the table specifications */
	while `"`tabspeclist'"' != "" {
		local ++k
		gettoken 0 tabspeclist : tabspeclist , match(parns)
		syntax anything(id="`tspecid'" name=tspec)	/*
		*/ [,						/*
		*/ noCI						/*
		*/ STDerror					/*
		*/ Level(passthru)				/*
		*/ ITItle(string)				/*
		*/ ]

		/* reset print ci flag to off */

		if "`g_stderror'" != "" | "`stderror'" != "" {
			local stderror stderror
		}
		else {
			local stderror 
		}

		if "`g_ci'" != "" | "`ci'" != "" {
			local ci noci
		}
		else {
			local ci 
		}

		if `"`ititle'"' != "" & "`individual'" == "" {
			di as err  "{cmd:individual} cannot be "	/*
				*/ "empty when {cmd:ititle()} is "	/*
				*/ "specified in a `tspecid'"
			exit 198
		}

		if `"`level'"' != "" & "`individual'" == "" {
			di as err "{cmd:individual} cannot be empty "	/*
				*/ "when {cmd:level()} is "	/*
				*/ "specified in `tspecid'"
			exit 198
		}

		if "`level'" != "" & "`g_ci'" != "" {
			di as err "{cmd:noci} and {cmd:level()} "	/*
				*/ "cannot both be specified"
			exit 198
		}	

		if "`level'" != "" & "`ci'" != "" {
			di as err "{cmd:noci} and {cmd:level()} "	/*
				*/ "cannot both be specified"
			exit 198
		}	

		if "`level'" != "`c(level)'" {
			local level `g_level'
		}

		local title`k' `"`ititle'"'

		/* check for error */
		gettoken tmp1 tmp2 : tspec , parse("()")
		local base `tspec'

		if `"`tmp2'"' != `""' {
			di as err `"tables not properly specified in `0'"'
			exit 198
		}

		gettoken irfname  base  : base
		if "`irfname'" == "" {
			di as err "{cmd:irfname} cannot be empty"
			exit 198
		}	
		local validirfs : char _dta[irfnames]
		local tmp_ck : subinstr local validirfs "`irfname'" 	/*
			*/ "`irfname'", count( local ck_found) word
		if `ck_found' < 1 {
			di as err "`irfname' is not a valid irfname"
			exit 498
		}	

		local ckvec : char _dta[`irfname'_model]
		if "`ckvec'" == "vec" {
			local ci noci
		}

		gettoken impulse base  : base
		if "`impulse'" == "" {
			di as err "{cmd:impulse} cannot be empty"
			exit 198
		}
		_irf_ops `impulse'
		local impulse `s(irfvar)'

		local validimps : char _dta[`irfname'_order]
		
		gettoken response stats : base
		if "`response'" == "" {
			di as err "{cmd:response} cannot be empty"
			exit 198
		}
		_irf_ops `response'
		local response `s(irfvar)'

		local tmp_ck : subinstr local validimps "`response'" 	/*
			*/ "`response'", count( local ck_found) word
		if `ck_found' < 1 {
			di as err "`response' is not a valid response"
			exit 498
		}	

		if "`stats'" == "" {
			di as err "{cmd:statlist} cannot be empty"
			exit 198
		}
		
		local stats `stats'
		local dmult dm cdm
		local dmult : list stats & dmult
		if "`dmult'" != "" {
			local exogvars : char _dta[`irfname'_exogvars]
			local validimps `validimps' `exogvars'
			local tmp_ck : subinstr local validimps "`impulse'" /*
				*/ "`impulse'", count( local ck_found) word
			if `ck_found' < 1 {
				di as err "`impulse' is not a valid impulse"
				exit 498
			}	
		}	
		else {
			local tmp_ck : subinstr local validimps "`impulse'" /*
				*/ "`impulse'", count( local ck_found) word
			if `ck_found' < 1 {
				di as err "`impulse' is not a valid impulse"
				exit 498
			}	
		}
		
		capture confirm variable `stats'
		if _rc > 0 {
			di as err "`stats' not valid"
			exit 198
		}

		local adj_level = `level'/100 + (100-`level')/200
		tempname zz
		scalar `zz' = invnorm(`adj_level')

		local uniqs : list uniq stats
		local uniq : list uniqs == stats
		if `uniq' != 1 {
			di as err "duplicate elements found in `stats'"
			exit 198
		}
		
		if "`e(cmd)'"=="arima" | "`e(cmd)'"=="arfima" {
			local tmp irf cirf oirf coirf sirf
			local out : list stats | tmp
			local out : list uniq out
			local out : list out - tmp
			if "`out'"!="" {
				di as err "{cmd:`out'} not available after " /*
					*/ "`e(cmd)'"
				exit 198
			}
		}
		
		local ns : word count `stats'
		if "`ci'" == "" {
			local ns = 3*`ns'
		}

		if "`ci'" == "" {
			local levlist `levlist' `level'	 
		}
		else {
			local levlist " `levlist' . " 
		}

		CheckTriple `irfname' `impulse' `response'
		local cond `r(condition)'
		sum `jvar' if `cond', meanonly
		if r(N) != 0 {
			/* current triple already seen */
			if r(min) == r(max) {
				local k_u = r(min)
				local irflist `irflist' `irfname'
				local impl `impl' `impulse'
				local resl `resl' `response'
			}
			else {	/* should never happen */
				di as err /*
*/ "internal varirf_ctable error, unique assumption invalid"
				exit 459
			}
		}
		else {
			/* current triple is new */
			qui count if `cond' & missing(`jvar')
			if r(N) > 0 {
				local ++k_u
				qui replace `jvar' = `k_u' if `cond'
				local irflist `irflist' `irfname'
				local impl `impl' `impulse'
				local resl `resl' `response'
			}
			else {	/* should never happen */
				di as err /*
*/ "internal varirf_ctable error, failed to catch invalid triple"
				exit 459
			}
		}
		/* build the column lists */
		foreach stat of local stats {

			local slist `slist' `stat'
			local nlist `nlist' `stat'
			local nsind `nsind' `ns'
			local k_ulist `k_ulist' `k_u'

			/* # of columns in the current block */
			local bcols  1

			if "`ci'" == "" {
				if "``stat'_ci'" == "" {
					capture confirm variable std`stat'
					tempvar `stat'_ll `stat'_ul
					qui gen double ``stat'_ll' = `stat' - /*
						*/ std`stat'*`zz'
					qui gen double ``stat'_ul' = `stat' + /*
						*/ std`stat'*`zz'
					local `stat'_ci created
				}
				local slist `slist' ``stat'_ll' ``stat'_ul'
				local nlist `nlist' Lower Upper
				local nsind `nsind' `ns' `ns'
				local k_ulist `k_ulist'  `k_u' `k_u'

				local bcols = `bcols' + 2
			}

			if "`stderror'" != "" {
				local slist `slist' std`stat'
				local nlist `nlist' S.E.
				local nsind `nsind' `ns'
				local k_ulist `k_ulist'  `k_u'

				local bcols = `bcols' + 1
			}

			forvalues cnt = 1/`bcols' {
				local k_list `k_list' `k'
				local blen `blen' `bcols'
			}
		}
	}
	local K `k'	/* number of tspecs */
	/* END parse through the table specifications */

	/* check that lists contain the same number of elements (columns) */
	local nnames : word count `nlist'
	local nstats : word count `slist'
	if `nnames' != `nstats' {
		di as error /*
*/ "internal varirf_ctable error, name and stat lists do not match "
		exit 498
	}
	local ncols : word count `k_ulist'
	if `ncols' != `nstats' {
		di as error /*
*/ "internal varirf_ctable error, name and k_u lists do not match "
		exit 498
	}

	local unique : list uniq slist
	qui drop if missing(`jvar')

	sum `jvar', meanonly
	local k_umax = r(max)
	keep `unique' step `jvar'
	qui reshape wide `unique', i(step) j(`jvar')

	/* set initial values for calculating column positions.  */
	local lstepc 10
	local lstepcm2 = `lstepc' -2
	local lstfmt 6
	local lcol 12
	local lcolm2 = `lcol' -2
	local lcolm1 = `lcol' -1
	local lcfmt 8

	local stind0 = int((`lstepc'-`lstfmt')/2)
	local linesize : set linesize
	local cpline = int((`linesize'-`lstepc')/`lcol')

	local linelen = `lstepc' + `cpline'*`lcol'
	local linelenm2 = `lstepc' + `cpline'*`lcol'-2

	sum step, meanonly
	local smax =r(max) + 1

	local cpos 0

	/* subtract 4 for step
	 *
	 * first column opens and closes itself all subsequent columns only
	 * close themselves.
	 */
	local hd2ind0 =int((`lstepc'-4)/2)+1

	/* calculate title offset and display title */

	if "`individual'" != "" {
		local mcols =0
		foreach ns of local nsind {
			local mcols = max(`mcols',`ns')
		}
	}
	else {
		local mcols = `ncols'
	}

	if `"`g_title'"' != "" {
		if `mcols' >= `cpline' {
			di
			di as txt `"{center: `g_title'}"'
		}
		else {

			di
			local t1len = length(`"`g_title'"')
			local t1ind = int( (`lstepc' + /*
				*/ `mcols'*`lcol'-`t1len')/2 )
			di as txt `"{col `t1ind'}`g_title'"'

		}
	}

	local col 1

	local ac = 1

	/* BEGIN table display **********************************************/
	local inew 1		/* start a new table */
	while `col' <= `ncols' {

		local bl : word `col' of `blen'
		local colp1 = `col' + 1
		local colm1 = `col' - 1
		local blP1 : word `colp1' of `blen'

		local k : word `col' of `k_list'
		local k `k'
		local nextc : word `colp1' of `k_list'
		if `colm1' > 0 {
			local lastc : word `colm1' of `k_list'
		}
		else {
			local lastc 0
		}
		local lastc `lastc'


		if "`nextc'" == "" {
			local nextc  0
		}

		if `inew' {
local tline "{c TLC}{hline `lstepcm2'}{c TT}"
local tline2 "{c LT}{hline `lstepcm2'}{c +}"
local bline "{c BLC}{hline `lstepcm2'}{c BT}"
local cpos `lstepc'
local hd1dis "{c |}{col `lstepc'}{c |}"
local hd2dis "{c |}{col `hd2ind0'}step{col `lstepc'}{c |}"
forvalues s=1/`smax'{
	local v : display %-`lstfmt'.0f step[`s']
	local dline`s' `"as txt "{c |}" as txt "{col `stind0'}`v'""'
	local dline`s' `"`dline`s'' as txt "{col `lstepc'}{c |}""'
}
local inew 0
local ac = 1

local tnotes2 `tnotes1'
if "`individual'" != "" {
	local tnotes1
}
		}
		else{
			if `ac' == `bl' {
				local endblock 1

				/* if end then check in same tbl cmd
				 *
				 * else check room for next block
				 */

				if "`blP1'" == "" {
					local inew 1
				}
				else	local inew = /*
				*/ (("`individual'" != "") /*
				*/ & (`k' != `nextc')) /*
				*/ | (`cpos' + (1+`blP1')*`lcol' > `linesize' )

				local ac 0
			}
			else {
				local endblock 0
			}
			local ++ac

			local npos = `cpos' + `lcol'
			if !`endblock' {
local tline "`tline'{hline `lcolm1'}{c -}"
local tline2 "`tline2'{hline `lcolm1'}{c -}"
local bline "`bline'{hline `lcolm1'}{c -}"
			}
			else {
if `inew' {
	local tline "`tline'{hline `lcolm1'}{c TRC}"
	local tline2 "`tline2'{hline `lcolm1'}{c RT}"
	local bline "`bline'{hline `lcolm1'}{c BRC}"
}
else {
	local tline "`tline'{hline `lcolm1'}{c TT}"
	local tline2 "`tline2'{hline `lcolm1'}{c +}"
	local bline "`bline'{hline `lcolm1'}{c BT}"
}
			}

			local k_ut : word `col' of `k_ulist'
			local tnotes1 `tnotes1' `k_ut'
			local hd1ind = int((`lcol'- length("`k_ut'"))/2 )
			local hd1p = `cpos' + `hd1ind'
			local k_udis "(`k_ut')"
			local hd1dis "`hd1dis'{col `hd1p'}`k_udis'"
			if `endblock' {
				local hd1dis "`hd1dis'{col `npos'}{c |}"
			}

			local sn : word `col' of `nlist'
			local hd2ind =  int((`lcol'-length("`sn'"))/2 )
			local hd2p = `cpos' + `hd2ind'
			local hd2dis "`hd2dis'{col `hd2p'}`sn'"
			if `endblock' {
				local hd2dis "`hd2dis'{col `npos'}{c |}"
			}


			local st : word `col' of `slist'
			local stind = `stind0' + `cpos'
			forvalues s=1/`smax'{
local v : display %-`lcfmt'.6g `st'`k_ut'[`s']
local tok1 "{col `stind'}`v'"
local tok2 "{col `npos'}{c |}"
local dline`s' `"`dline`s'' as res "`tok1'""'

if `endblock' {
	local dline`s' `"`dline`s'' as txt "`tok2'""'
}
			}
			local cpos = `cpos' + `lcol'

			local ++col

		}

		if `inew' {

			local llcpos `lcpos'
			local lcpos  `cpos'

			if "`k_head'" != "" {
				local k_headp `k_head'
			}
			else{
				local k_headp 0
			}
			local k_head `k'

			if `k_headp' > 0 & `k_headp' != `k_head' & /*
				*/ "`individual'" != "" {

				local tnotes2b : list uniq tnotes2
				local lev_k : word `k_headp' of `levlist'
				FootNote "`lev_k'" /*
					*/ "`tnotes2b'" "`irflist'" 	/*
					*/ "`impl'" "`resl'" 
				local r_tnotes `r_tnotes' `tnotes2'
			}
			if "`individual'" != "" {
				if `k_head' != `k_headp' {
					Title `"`title`k''"' `k'
				}
				else {
					Title `"`title`k''"' `k' /*
					*/ "(continued)"
				}
			}

			di
			di as txt "`tline'"
			di as txt "`hd1dis'"
			di as txt "`hd2dis'"
			di as txt "`tline2'"
			forvalues s=1/`smax'{
				di `dline`s''
				local dline`s'
			}
			di as txt "`bline'"

			local cpos 0
		}
	}
	/* END table display ************************************************/

	local tnotes2 : list uniq tnotes1

	local lev_k : word `k' of `levlist'
	FootNote "`lev_k'" "`tnotes2'" "`irflist'" "`impl'" "`resl'"
	local r_tnotes `r_tnotes' `tnotes1'

	/* saved results */
	return scalar k = `K'		/* number of tspecs		*/
	return scalar k_umax = `k_umax'	/* number of triples		*/
	return scalar ncols = `ncols'	/* number of columns		*/
	return local tnotes `r_tnotes'	/* triple id for each column	*/
	local k_ulist : list uniq k_ulist
	qui FootNote "0" "`k_ulist'" "`irflist'" "`impl'" "`resl'" 
	return add
end

/* check for invalid triples */
program CheckTriple, rclass
	args irfname impulse response

	local condition /*
*/ irfname  == "`irfname'" & impulse == "`impulse'" & response == "`response'"
	qui count if `condition'

	if r(N)== 0 {
		di as err /*
*/ `"There are no observations in which irfname is "`irfname'","' /*
*/ `" impulse is "`impulse'", and response is "`response'""'
		exit 2000
	}

	return local condition `condition'
end

/* display the table footnotes, i.e. key for the triples */
program FootNote, rclass
	args level tnotes irflist impl resl 

	if `level' < . {
di as txt "{p 0 4 4}`level'% lower and upper bounds reported{p_end}"
	}

	foreach k_u of local tnotes {
		local irf : word `k_u' of `irflist'
		local imp : word `k_u' of `impl'
		local res : word `k_u' of `resl'
		local key (`k_u') /*
		*/ irfname = `irf', /*
		*/ impulse = `imp', and /*
		*/ response = `res'
		di as txt `"{p 0 4 4}`key'{p_end}"'

		/* return the triple id and the triple */
		return local key`k_u' `irf' `imp' `res'
	}
end

program Title
	args title num cont
	if `"`title'"' == "" {
		local title Table `num'
	}
	di as txt _n `"`title' `cont'"'
end

exit


NOTES:

The syntax for a table specification (tspec) is:

	(<irfname> <impulse> <response> <stats> [, <options> ])

where <irfname> identifies a name contained in the -irfname- variable,
<impulse> identifies a name contained in the -impulse- variable , <response>
identifies a name contained in the -response- variable, and <stats> is a
non-empty list of statistics, i.e. at least one of irf, oirf, coirf, decomp.
The -irfname-, -impulse-, and -response- variables are contained in the
currently set varirf data file (along with the variables in <stats>).

Each tspec will result in at least 1 to at most 4 columns for the table,
depending upon what is in <options>.

Each table contains blocks that are not ment to be broken into separate
tables.  Each block is determined by the contents of <options> for each
statistic in <stats>, and is displayed in the table by

	<stat> [std<stat>] [<stat>_ll <stat>_ul]

where <stat> is one of the statistics in <stats>, std<stat> is the standard
error of <stat>, and <stat>_ll, <stat>_ul are the lower and upper confidence
limits for <stat>.  Blocks are uniquely identified by the k_u macro and
<stat>.

Macros:

	k	- indexes each table specification (tspec)
	k_u	- indexes each unique triple (<irfname> <impulse> <response>)

tspec lists:  Each of the following macros contains space delimited elements
corresponding to each value of k.  The element is described.

	levlist	- the value in the -level()- option

column lists:  Each of the following macros contains space delimited elements
corresponding to each column of the table.  The element is described.

	k_list	- value of k
	k_ulist	- value of k_u
	nlist	- display header
	slist	- variable name
	nsind	- # of stats to display for the current tspec
	blen	- number of columns in the current block

triple lists:  Each of the following macros contains space delimited elements
corresponding to each value of k_u (unique triple).  The element is described.

	irflist	- irfname
	impl	- impulse
	resl	- response

Temporary variables:

	jvar		- the -j()- identifier in the -reshape- command.  Here
			jvar equals the value of `k_u' for the triple (irfname
			impulse response) contained in the current tspec.

	<stat>_ll	- the lower CI limit for <stat> (see <stats> above)
	<stat>_ul	- the upper CI limit for <stat> (see <stats> above)

<end>
