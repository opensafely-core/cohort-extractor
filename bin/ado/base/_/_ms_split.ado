*! version 1.0.0  22apr2009
program _ms_split
	version 11
	syntax anything(id="matrix name" name=mname)	///
		[,	row				///
			abbrev				///
			width(integer 0)		///
			noCOLon				///
		]

	confirm matrix `mname'
	local row	: list sizeof row
	local abbrev	: list sizeof abbrev
	local colon	= "`colon'" == ""
	if `width' < 5 {
		local width 12
	}
	mata: _ms_split_wrk("`mname'",`width', `row',`abbrev',`colon')
end

mata:

void _ms_split_wrk(	string	scalar mname,
			real	scalar width,
			real	scalar row,
			real	scalar abbrev,
			real	scalar colon)
{
	string	matrix	S
	real	scalar	kr, r, kc, c
	string	scalar	rname

	if (abbrev) {
		if (row) {
			S = st_matrixrowstripe_abbrev(mname, width, colon)
		}
		else {
			S = st_matrixcolstripe_abbrev(mname, width, colon)
		}
	}
	else {
		if (row) {
			S = st_matrixrowstripe_split(mname, width, colon)
		}
		else {
			S = st_matrixcolstripe_split(mname, width, colon)
		}
	}
	kr	= rows(S)
	kc	= cols(S)
	st_rclear()
	st_numscalar("r(k_rows)", kr)
	st_numscalar("r(k_cols)", kc)
	for (r=1; r<=kr; r++) {
		for (c=1; c<=kc; c++) {
			rname = sprintf("r(str%g_%g)", r, c)
			st_global(rname, S[r,c])
		}
	}
}

end
exit
