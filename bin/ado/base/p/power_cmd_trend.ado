*! version 1.0.0  08dec2014
program define power_cmd_trend
	version 14.0

	syntax [anything], [ test ci * ]

	pss_trend_test `anything', `options'
end

program define pss_trend_test
	_pss_syntax SYNOPTS : multitest
	syntax [anything(name=args)], pssobj(string)	///
		[	`SYNOPTS'		///
			cc			///
			*			///
		]

	/* pssobj.Nargs is the number of levels				*/
	mata: st_local("N",strofreal(`pssobj'.Nargs))
	forvalues i=1/`N' {
	      local OOPS `"`OOPS' expos`i'(numlist max=1) n`i'(numlist max=1)"'
	      local OOPS `"`OOPS' grwgt`i'(numlist max=1)"'
	}
	local 0, `options'
	syntax, [ `OOPS' * ]

	local sn = 0
	tempname d1 di pi eps pi2
	scalar `di' = .
	/* constant used in Mata _PSS_trend_test object; keep in sync	*/
	scalar `eps' = 1e-6
	local nxz = 0
	local npz = 0
	forvalues i=1/`N' {
		if "`expos`i''" != "" {
			local X `"`X' `expos`i''"'
			if `i' > 1 {
				scalar `di' = `expos`i''-`expos`=`i'-1''
				if (`di'<`eps') {
					local X : list retokenize X
					di as err "{p}invalid " ///
					"{bf:exposure(`X')}: exposure " ///
					"levels are not monotonically " ///
					" increasing with a minimum " ///
					"difference 1e-6{p_end}"
					exit 498
				}
			}
			if "`cc'"!="" & `i'>2 {
				if abs(`di'-`d1') > `eps' {
					di as err "{p}covariates are not " ///
					 "evenly spaced; option "          ///
					 "{bf:continuity} may not be used" ///
				 	 "{p_end}"

					exit 498
				}
			}
			scalar `d1' = `di'
		}
		if ("`n`i''"!="") local Nj `"`Nj' `n`i''"'
		if ("`grwgt`i''"!="") local grweights `"`grweights' `grwgt`i''"'
		local a`i' : word `i' of `args'
		if `i' > 2 {
			scalar `pi2' = `a`i''-`a`=`i'-1''
			if (((`a2'-`a1' > `eps' & `pi2'<`eps') | ///
				(`a2'-`a1' < -`eps' & `pi2' > -`eps') | ///
				abs(`a2'-`a1') < `eps') ) {
				local mono_warn = 1
			}
		}
	}

	local Nj : list retokenize Nj
	local grweights : list retokenize grweights
	if ("`Nj'"=="") local Nj `npergroup'

	mata: `pssobj'.init(`alpha',"`power'","`beta'","`n'",`"`args'"', ///
		`"`grweights'"',`"`Nj'"',"`X'"', "`mono_warn'" != "");  ///
		`pssobj'.compute();				///
		`pssobj'.rresults()
end

