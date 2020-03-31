*! version 1.0.1  15oct2019
program estimates_sample, rclass
	version 10
	gettoken COLON rest : 0, parse(":")
	if `"`COLON'"' == ":" {
		SetEsample `rest'
		exit
	}
	CheckEsample `0'
	return add
end

program CheckEsample, rclass
	syntax
	if `"`e(_estimates_sample)'"' == "user" {
		di as txt "{bf:e(sample)} set by user"
		return local who "user"
	}
	else {
		Check4Esample
		if r(hasesample) {
			di as txt "{bf:e(sample)} set by estimation command"
			return local who "cmd"
		}
		else {
			di as txt "{bf:e(sample)} not set (0 assumed)"
			return local who "zero'd"
		}
	}
end

program SetEsample, eclass
	syntax [varlist(default=none)]		///
		[if] [in] [fw aw iw pw] [,	///
		STRingvars(varlist)		///
		ZEROweight			///
		replace				///
	]

	marksample touse, `zeroweight'

	if `:length local stringvars' {
		markout `touse' `stringvars', strok
	}
	if !`:length local replace' {
		Check4Esample
		if r(hasesample) {
			di as err "no; {bf:e(sample)} already set"
			exit 322
		}
	}
	ereturn repost, esample(`touse')
	ereturn local _estimates_sample "user"
end

program Check4Esample, rclass
	quietly describe, short
	local k = r(k)
	quietly describe, short all
	return scalar hasesample = `k' != r(k)
end

exit
