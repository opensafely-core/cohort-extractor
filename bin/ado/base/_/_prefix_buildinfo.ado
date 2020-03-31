*! version 1.2.1  30may2017
program _prefix_buildinfo, eclass
	syntax name(name=cmdname) [, h(name) i(name)]
	if "`h'`i'" != "" {
		if "`h'" != "" {
			_post_fvinfo `h'
		}
		if "`i'" != "" {
			mata: st_matrixcolstripe_fvinfo("e(b)",	///
					st_matrix("`i'"))
		}
		exit
	}
	_ms_op_info e(b)
	if r(tsops) {
		quietly tsset, noquery
	}
	if "`cmdname'" == "cox" {
		local cmdname stcox
	}

	// NOTE: fvaddcons is no longer used by official estimation
	// commands, but this program property was shared with
	// user-programmers so we need to continue supporting it here.

	local fvaddcons fvaddcons
	local props : properties `cmdname'
	local addcons addcons
	local mprops `"`e(marginsprop)'"'
	if `:list fvaddcons in props' | `:list addcons in mprops' {
		local ADDCONS ADDCONS
	}
	if inlist("`cmdname'", "mlogit", "mprobit") {
		local fveq = e(k_eq) - (e(k_eq) == e(k_eq_base))
		local fveq fvinfoeq(`fveq')
	}
	else if inlist("`cmdname'", "manova", "mvreg") {
		local fveq fvinfoeq(1)
	}
	// the following -capture- is on purpose, if there is an error for any
	// reason then we just want to return without building the FV
	// information
	if "`e(wexp)'" != "" {
		local wgt "[`e(wtype)'`e(wexp)']"
	}
	capture ereturn repost `wgt' , buildfvinfo `ADDCONS' `fveq'
end
