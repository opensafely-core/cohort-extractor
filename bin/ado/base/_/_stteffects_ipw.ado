*! version 1.0.0  29jan2015

program define _stteffects_ipw, byable(onecall)
	version 14.0

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	if replay() {
		if ("`e(cmd)'" != "stteffects") error 301
		if ("`e(subcmd)'" != "ipw") error 301
		if (_by()) error 190

		_stteffects_replay `0'
		exit
	}
	_teffects_parse_canonicalize st ipw : `0'
	if `s(eqn_n)' == 0 {
		/* missing 1 or 2 model specifications			*/
		_stteffects_error_msg, cmd(ipw) case(1) extra(one or two)
		/* not reached */
	}		
	if `s(eqn_n)' > 2 {
		/* only 1 or 2 model specifications allowed		*/
		_stteffects_error_msg, cmd(ipw) case(2) extra(one or two)
		/* not reached */
	}
	local tmodel `"`s(eqn_1)'"'
	if `s(eqn_n)' == 2 {
		local cmodel `"`s(eqn_2)'"'
	}
	local if `"`s(if)'"'
	local in `"`s(in)'"'
	local wt `"`s(wt)'"'
	local options `"`s(options)'"'

	`BY' Estimate `if'`in' `wt', tmodel(`tmodel') cmodel(`cmodel') `options'
end

program define Estimate, eclass byable(recall)
	syntax [if] [in] [fw iw pw/], tmodel(passthru) [ cmodel(passthru) ///
			AEQuations * ]

	_get_diopts diopts options, `options'
	local diopts `diopts' `aequations'

	if ("`weight'"!="") local wopt [`weight'=`exp']

	marksample touse
	_stteffects_estimate ipw `touse': `wopt', `tmodel' `cmodel' `options'

	ereturn local cmd stteffects
	ereturn local subcmd ipw
	ereturn local title "Survival treatment-effects estimation"

	_stteffects_replay, `diopts'
end

exit
