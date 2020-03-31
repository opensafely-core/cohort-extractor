*! version 1.0.0  09jun2011
program u_mi_check_monotone, sclass
	version 12
	syntax [varlist(default=none numeric)] [if] [in] [, NOMONOTONECHK ///
							    ERRMONOTONE   ///
							    MUSTBEORDERED ///
							    name(string)]

	if ("`varlist'"=="") exit

	if ("`nomonotonechk'"!="") {
		local errmonotone
		local mustbeordered
	}

	local ivars `varlist'
	marksample touse, novarlist
	markout `touse' `ivars', sysmissok
	mata: _ordermissvars(	"`ivars'",			///
				"`touse'",			///
				("`nomonotonechk'"==""),	///
				"ivarsincord","ivarsc","orderid","monotone")
	if ("`errmonotone'"!="" & "`monotone'"=="nonmonotone") {
		di as err "{p 0 0 2}{bf:`ivars'}: not monotone;{p_end}" 
		di as err "{p 4 4 2}imputation variables must " /// 
		   "have a monotone-missing structure; see "	///
		   "{helpb mi_misstable:mi misstable nested}{p_end}"
		exit 459
	}
	local ivarsinc : list ivars - ivarsc
	if ("`mustbeordered'"!="" & !(`: list ivarsinc == ivarsincord')) {
		di as err "{bf:mi impute`name'}: incorrect equation order"
		di as err "{p 4 4 2}equations must be "	    		///
			   "listed in the monotone-missing order " 	///
			   "of the imputation variables (from "		///
			   "most observed to least observed); "		///
			   "{bf:`ivarsincord'}{p_end}"
		exit 198
	}
	sret clear
	sret local ivarsinc		"`ivarsinc'"
	sret local ivarsinc_ordered	"`ivarsincord'"
	sret local ivarsc		"`ivarsc'"
	sret local orderid		"`orderid'"
	sret local monotone		"`monotone'"
end

version 12
mata:

void _ordermissvars(	string scalar ivnames, 
			string scalar tousename, 
			real scalar monotonechk, 
			string scalar out1, 
			string scalar out2, 
			string scalar out3, 
			string scalar out4)
{
	real scalar		nzero, nvars
	real colvector		colmis, orderid
	real matrix		Ivars
	string rowvector	names

	names	= tokens(ivnames)
	nvars	= cols(names)

	st_view(Ivars=., ., names, tousename)

	colmis	= colmissing(Ivars)'
	nzero	= sum(colmis:==0)
	orderid = sort( (colmis,range(1,nvars,1)), (1,2))[.,2]
	names	= names[orderid]

	if (nzero<nvars) st_local(out1, invtokens(names[nzero+1..nvars]))
	if (nzero)	 st_local(out2, invtokens(names[1..nzero]))
	st_local(out3, invtokens(strofreal(orderid')))

	if (!monotonechk) return

	if (nzero==nvars) { // no ivars containing system missings
		st_local(out4, "monotone")
		return
	}

	// check if incomplete variables are monotone
	real scalar	i, ncols, ismonotone
	real colvector	obs, id1, id2
	
	Ivars = st_data(., names[nzero+1..nvars], tousename)
	ncols	= cols(Ivars)
	obs	= range(1, rows(Ivars),1)
	_sort(Ivars, -range(ncols, 1, -1)')
	id1	= select(obs, rowmissing(Ivars[.,ncols]))
	ismonotone = 1
	for (i=ncols-1; i>0; i--) {
		id2 = select(obs, rowmissing(Ivars[.,i]))
		ismonotone = all(id1[1..rows(id2)]:==id2)
		if (!ismonotone) break
		id1 = id2
	}
	if (ismonotone) st_local(out4, "monotone")
	else		st_local(out4, "nonmonotone")
}
end
