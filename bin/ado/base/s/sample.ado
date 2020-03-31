*! version 2.3.0  19feb2019
program define sample, byable(onecall)
	version 7, missing

	if _caller()<7 {		/* deal with prior versions 	*/
		local c = string(_caller())
		if _by() {
			di as err /*
*/ "sample may not be combined with by when run under version `c'"
			exit 190
		}
		version `c', missing: Sample6 `0'
		exit
	}

					/* parse			*/
	local 0 `"=`0'"'
	syntax =/exp [if] [in] [, BY(varlist) Count PDUPlicates(real 1e-4)]
	if _by() {
		if "`by'"!="" {
			di as err /*
			*/ "by varlist: and by() option may not be combined"
			exit 190
		}
		local by `_byvars'
	}

	confirm number `exp'
	if "`count'"=="" {
		if (`exp'<0 | `exp'>=100) {
			if `exp'==100 { exit }
			di as err "{p 0 4}"
			di as err "`exp':"
			di as err /*
*/ "# must be between 0 and 100 and is interpreted as a percent unless" _n /*
*/ "option count is also specified, in which case # is interpreted as" _n /*
*/ "the number of observations to be drawn" _n /*
*/ "{p_end}"
			error 198
		}
	}
	else {
		confirm integer number `exp'
		if `exp'<0 | `exp'>=_N {
			if `exp'>=_N { exit }
			di as err "{p 0 4}"
			di as err "`exp':"
			di as err /*
*/"# must be 0 or positive; with the count option, it represents the" _n /*
*/ "# of observations to be drawn" _n /*
*/ "{p_end}"
		}
	}
					/* parsing complete except for
					   in with by()			*/
	tempvar tokeep u1 u2

	qui gen byte `tokeep' = 0 `if' `in'
	quietly count if `tokeep'==0
	if r(N)==0 { exit }

	if "`count'"=="" {
		local N = int(r(N)*(`exp')/100+.5)
	}
	else	local N = `exp'

	if c(userversion) < 14 & _N < 2^31 {
		local type float
		local d1 23	// unused
		local k 2
	}
	else {
		local type double
		local rng = c(rng_current)
		if `"`rng'"' == "mt64" {
			local d1 52
		}
		else	local d1 32
		k_uniforms k : `type' `d1' `pduplicates' `N'
	}
	local ulist
	forval i = 1/`k' {
		tempname u`i'
		qui gen `type' `u`i'' = uniform()
		local ulist `ulist' `u`i''
	}

					/* does not have by()		*/
	if "`by'"=="" {
		sort `tokeep' `ulist'
		qui replace `tokeep'=1 if `tokeep'==0 & _n<=`N'
		drop if `tokeep'==0
		exit
	}

					/* does have by()		*/
	if _by()==0 & "`in'"!="" {
		di in red "in may not be combined with by()"
		exit 190
	}

	sort `by' `tokeep' `ulist'
	quietly {
		if "`count'"=="" {
			tempvar N
			by `by': gen long `N'=sum(`tokeep'==0)
			replace `tokeep'=1 if `tokeep'>=.
			by `by': replace `N'=int(`N'[_N]*`exp'/100+.5)
		}
		else	local N = `exp'
		by `by': replace `tokeep'=1 if `tokeep'==0 & _n<=`N'
	}
	drop if `tokeep'==0
end

program k_uniforms
	args c_k COLON type d1 pdups nobs

	capture confirm integer number `nobs'
	if _rc {
		sum `nobs'
		local nobs = r(max)
	}

	if "`type'" != "double" & `nobs' < 2^31 {
		return scalar k = 2
		exit
	}

	local d = log(-log1m(`pdups'))
	local d = ceil((2*log(`nobs') - `d')/log(2) - 1)
	local d = ceil(`d'/`d1')
	c_local `c_k' = max(2,`d')
end

* Sample 6 is version 1.1.4  03oct2000/22dec1998
program define Sample6
	version 6, missing
	local 0 `"=`0'"'
	syntax =/exp [if] [in] [, BY(varlist)]

	if "`by'"~="" {
		if "`in'"!="" {
			di in red "in may not be combined with by()"
			exit 190
		}
		local sort "sort `by'"
		local byp "by `by':"
	}
	confirm number `exp'
	if `exp'<0 | `exp'>100 { error 198 }
	if `exp'==100 { exit }

	tempvar TOKEEP RANDOM N
	quietly {
		`sort'
		`byp' gen byte `TOKEEP' = 0 `if' `in'
		count if `TOKEEP'==0
		if r(N)==0 { exit }
		`byp' gen long `N' = sum(`TOKEEP'==0)
		replace `TOKEEP' = 1 if `TOKEEP'>=.
		`byp' replace `N' = int(`N'[_N]*`exp'/100+.5)
	}
	if _caller()<4.0 {
		gen float `RANDOM' = uniform0()
	}
	else	gen float `RANDOM' = uniform()
	sort `by' `TOKEEP' `RANDOM'
	quietly `byp' replace `TOKEEP'=1 if `TOKEEP'==0 & _n<=`N'
	drop if `TOKEEP'==0
end
exit

Sat Feb 17 12:19:27 CST 2001
----------------------------

Comments by William Gould, wgould@stata.com:

The version 7 sample is oddly written in that it is struggling to preserve
compatibility with the pre-version 7 versions of -sample-; the same samples
are returned by pre-version 7 and version 7 whenever that is possible.


The problem
-----------

Define "reproducibility" as obtaining the same results from -sample-
if you set the random-number seed before hand.

Concerning the pre version 7 -sample-, there are the following problems:

	1.  -sample, by()- is not reproducible because, early in the
	    code, -sample- sorts by by().

	2.  In all cases, there is another problem with reproducibility
	    when -sample- is used with large datasets.  -sample- stores
	    random numbers as floats.  One must worry that the same random
	    number is drawn for two or more observations.

	    Your first take is that this must be a zero-probability event.
	    Not true.

		                 sims	             (stored as float)
		   obs   sims   w/ dups   med dups
		----------------------------------
		 2,500	  100      12        0
		 5,000    100      42        0
		10,000    100      86        1
		20,000    100      99        7
		40,000    100     100       32
	       100,000    100     100      197

	    Storing uniform() as double does not really solve the problem,
	    because the float rounding is losing only one hex digit:

		                 sims                 (stored as double)
		   obs   sims   w/ dups   med dups
		----------------------------------
		 2,500	  100       0        0
		 5,000    100       0        0
		10,000    100       1        0
		20,000    100       6        0
		40,000    100      22        0
	       100,000    100      64        1

	    What will solve the problem is generating two uniform()s
	    (and in that case, both can be stored as floats).

	    The above tables concerning dups may concern you more than
	    is justified; remember, for the problem to affect -sample-,
	    a duplicate must occur and it must occur at the cutoff
	    point.  This is why the problem has gone undiscovered for
	    so long.


Backwards compatibility
-----------------------

The code has been modified with an eye to backwards compatibility.

Using -sample- without -by()-, results will be the same if the above
problem did not previously occur.  In cases where the problem did
previously occur, the samples will be nearly identical; the tie will now
be broken deterministically.   The above applies when you set the
random-number seed immediately before use of -sample-.  Consider

	. set seed ...
	. sample 5 if group==1
	. sample 5 if group==2
	. sample 5 if group==3

The samples you will now obtain for groups 2 and 3 will be different
because each -sample- will leave the random-number generator in a different
state.  All is deterministic, it is just different.

Concerning use of -sample- with the -by()- option, that is now different
due to the bug previously mentioned.  You will, however, obtain the same
results in the case where the data was already in the order of -by()-
(whether the sort markers were set or not).


Version control
---------------

If you set -version 6- or earlier, you get the old -sample-.  Results will
be the same as they can be.  The problem with -sample- has nothing to do
with it not pulling a random sample, but being able to set the seed and
pull the same random sample.

-sample- existed for years before anyone noticed the reproducibility problem.
It is therefore judged that backwards compatibility is more important than
fixing a reproducibility problem.

<end>
