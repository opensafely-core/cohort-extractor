*! version 1.0.0  29jan2015

program define _stteffects_ra, byable(onecall)
	version 14.0

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	if replay() {
		if ("`e(cmd)'" != "stteffects") error 301
		if ("`e(subcmd)'" != "ra") error 301
		if (_by()) error 190

		_stteffects_replay `0'
		exit
	}
	_teffects_parse_canonicalize st ra : `0'
	if `s(eqn_n)' == 1 {
		/* missing 1 model specification  			*/
		_stteffects_error_msg, cmd(ra) case(1) extra(one)
		/* not reached */
	}		
	if `s(eqn_n)' > 2 {
		/* only 2 model specifications allowed			*/
		_stteffects_error_msg, cmd(ra) case(2) extra(two)
		/* not reached */
	}
	local omodel `"`s(eqn_1)'"'
	local tmodel `"`s(eqn_2)'"'
	local if `"`s(if)'"'
	local in `"`s(in)'"'
	local wt `"`s(wt)'"'
	local options `"`s(options)'"'

	`BY' Estimate `if'`in' `wt', omodel(`omodel') tmodel(`tmodel') `options'
end

program define Estimate, eclass byable(recall)
	syntax [if] [in] [fw iw pw/], omodel(passthru) tmodel(passthru) ///
			[ AEQuations * ]

	_get_diopts diopts options, `options'
	local diopts `diopts' `aequations'

	if ("`weight'"!="") local wopt [`weight'=`exp']

	marksample touse
	_stteffects_estimate ra `touse': `wopt', `omodel' `tmodel' `options'

	ereturn local cmd stteffects
	ereturn local subcmd ra
	ereturn local title "Survival treatment-effects estimation"

	_stteffects_replay, `diopts'
end

exit
