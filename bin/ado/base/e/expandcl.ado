*! version 1.0.4  09feb2015
program expandcl, sortpreserve
	version 9
	gettoken equal : 0, parse("=")
	if "`equal'" != "=" {
		local 0 `"= `0'"'
	}
	syntax =exp [if] [in],		///
		GENerate(name)		///
		CLuster(varlist)

	confirm new variable `generate'

	marksample touse, novarlist

	tempvar vexp oid cid eid

quietly {

	gen long `vexp' `exp'

	// generate cluster id variable that contains the contiguous integers
	// 1, ..., `ncl'; where `ncl' is the number of clusters

	sort `touse' `cluster', stable
	capture by `touse' `cluster': ///
		assert `vexp' == `vexp'[1] if `touse'
	if c(rc) {
		di as err "expression is not constant within clusters"
		exit 198
	}

	by `touse' `cluster': gen `cid' = _n==1
	replace `cid' = sum(`cid')
	local ncl = `cid'[_N]
	gen `c(obs_t)' `oid' = _n

	drop `vexp'
	noisily expand `exp' if `touse'

	// generate the cluster id variable that is unique between the copies
	// of the original clusters

	sort `touse' `cluster' `oid', stable
	by `touse' `cluster' `oid': gen `c(obs_t)' `eid' = _n
	sort `touse' `cluster' `eid', stable
	drop `oid'
	by `touse' `cluster' `eid': gen `oid' = _n==1 if `touse'
	replace `eid' = sum(`oid') if `touse'
	rename `eid' `generate'

} // quietly

end
exit
