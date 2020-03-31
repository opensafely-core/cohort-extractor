*! version 1.0.0  29jan2015

program define _stteffects_ipwra, byable(onecall)
	version 14.0

	if _by() {
		local BY `"by `_byvars'`_byrc':"'
	}

	if replay() {
		if ("`e(cmd)'" != "stteffects") error 301
		if ("`e(subcmd)'" != "ipwra") error 301
		if (_by()) error 190

		_stteffects_replay `0'
		exit
	}
	_teffects_parse_canonicalize st ipwra : `0'
	if `s(eqn_n)' == 1 {
		/* missing 1 model specifications			*/
		_stteffects_error_msg, cmd(ipwra) case(1) extra(one or two)
		/* not reached */
	}		
	if `s(eqn_n)' > 3 {
		/* only 2 or 3 model specifications allowed		*/
		_stteffects_error_msg, cmd(ipwra) case(2) extra(two or three)
		/* not reached */
	}
	local omodel `"`s(eqn_1)'"'
	local tmodel `"`s(eqn_2)'"'
	if `s(eqn_n)' == 3 {
		local cmodel `"`s(eqn_3)'"'
	}
	
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
	_stteffects_estimate ipwra `touse': `wopt', `omodel' `tmodel' ///
		`cmodel' `options'

	ereturn local cmd stteffects
	ereturn local subcmd ipwra
	ereturn local title "Survival treatment-effects estimation"

	_stteffects_replay, `diopts'
end

exit
