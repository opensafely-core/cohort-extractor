*! version 1.0.0  29jan2015

program define _stteffects_wra, byable(onecall)
	version 14.0

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	if replay() {
		if ("`e(cmd)'" != "stteffects") error 301
		if ("`e(subcmd)'" != "wra") error 301
		if (_by()) error 190

		_stteffects_replay `0'
		exit
	}
	_teffects_parse_canonicalize st wra : `0'
	if `s(eqn_n)' == 1 {
		/* missing 2 model specifications			*/
		_stteffects_error_msg, cmd(wra) case(1) extra(two)
		/* not reached */
	}		
	if `s(eqn_n)' == 2 {
		/* missing 1 model specification			*/
		_stteffects_error_msg, cmd(wra) case(1) extra(one)
		/* not reached */
	}
	if `s(eqn_n)' > 3 {
		/* only 3 model specifications allowed			*/
		_stteffects_error_msg, cmd(wra) case(2) extra(three)
		/* not reached */
	}
	local omodel `"`s(eqn_1)'"'
	local tmodel `"`s(eqn_2)'"'
	local cmodel `"`s(eqn_3)'"'
	local if `"`s(if)'"'
	local in `"`s(in)'"'
	local wt `"`s(wt)'"'
	local options `"`s(options)'"'

	`BY' Estimate `if'`in' `wt', omodel(`omodel') tmodel(`tmodel') ///
			cmodel(`cmodel') `options'
end

program define Estimate, eclass byable(recall)
	syntax [if] [in] [fw iw pw/], omodel(passthru) tmodel(passthru) ///
			[ cmodel(passthru) AEQuations * ]

	_get_diopts diopts options, `options'
	local diopts `diopts' `aequations'

	if ("`weight'"!="") local wopt [`weight'=`exp']

	marksample touse
	_stteffects_estimate wra `touse': `wopt', `omodel' `tmodel' ///
		`cmodel' `options'

	ereturn local cmd stteffects
	ereturn local subcmd wra
	ereturn local title "Survival treatment-effects estimation"

	_stteffects_replay, `diopts'
end

exit
