*! version 1.0.2  09sep2019
program _frget
	version 16

	tempname vals text
	capture noisily __frget `vals' `text' `0'
	local rc = c(rc)
	mata: _frget_cleanup("`vals'","`text'")
	exit `rc'
end

program __frget
	version 16
	args vals text linkvar newvar EQUALS srcvar

	confirm variable `linkvar'
	if "`EQUALS'" != "=" {
		di as err ///
		`"{bf:`EQUALS'} found where equal sign, {bf:=}, expected"'
		exit 198
	}
	confirm new variable `newvar'
	frlink_dd get frame : `linkvar' fname2

	frame `frame' {
		local type	: type `srcvar'
		local format	: format `srcvar'
		local label	: variable label `srcvar'
		local chars	: char `srcvar'[]
		local i 0
		foreach ch of local chars {
			local ++i
			local ch`i' : char `srcvar'[`ch']
		}
		local vl	: value label `srcvar'
		mata: _frget_vlload("`vl'","`vals'","`text'")
	}

	generate `type' `newvar' = frval(`linkvar', `srcvar')
	format `newvar' `format'
	label variable `newvar' `"`label'"'
	local i 0
	foreach ch of local chars {
		local ++i
		char `newvar'[`ch'] `"`ch`i''"'
	}
	mata: _frget_vlgen("`newvar'","`vl'","`vals'","`text'")
end

mata:

void _frget_cleanup(
	string	scalar	vals,
	string	scalar	text)
{
	rmexternal(vals)
	rmexternal(text)
}

void _frget_vlload(
	string	scalar	vl,
	string	scalar	vals,
	string	scalar	text)
{
	pointer	scalar	pv
	pointer	scalar	pt

	if (vl == "") {
		return
	}

	if (st_vlexists(vl) == 0) {
		return
	}

	pv = crexternal(vals)
	pt = crexternal(text)

	st_vlload(vl, *pv, *pt)
}

real scalar _frget_vlequal(
	string	scalar	vl,
	real	vector	v,
	string	vector	t)
{
	real	vector	v2
	string	vector	t2
	real	scalar	len
	pragma unset v2
	pragma unset t2

	if (st_vlexists(vl) == 0) {
		return(0)
	}
	st_vlload(vl, v2, t2)

	len = length(v)
	if (len != length(t)) {
		return(0)
	}
	if (len != length(v2)) {
		return(0)
	}
	if (len != length(t2)) {
		return(0)
	}
	if (any(t:!=t2)) {
		return(0)
	}
	if (any(v:!=v2)) {
		return(0)
	}

	return(1)
}

void _frget_vlgen(
	string	scalar	newvar,
	string	scalar	vl,
	string	scalar	vals,
	string	scalar	text)
{
	pointer	scalar	pv
	pointer	scalar	pt
	real	scalar	hasvl
	string	vector	vlnames
	real	scalar	i
	real	scalar	n
	real	scalar	len
	string	scalar	usevl
	string	scalar	tryvl
	real	scalar	newvl
	real	scalar	rc

	if (vl == "") {
		return
	}

	pv = findexternal(vals)
	pt = findexternal(text)

	if (pv == NULL | pt == NULL) {
		return
	}

	hasvl = 0
	rc = _stata("label dir", 1)
	if (rc) exit(rc)
	vlnames = tokens(st_global("r(names)"))
	if (anyof(vlnames, vl)) {
		hasvl = selectindex(vlnames:==vl)
		vlnames[(1,hasvl)] = vlnames[(hasvl,1)]
	}

	usevl = ""
	n = cols(vlnames)
	for (i=1; i<=n; i++) {
		if (_frget_vlequal(vlnames[i], *pv,*pt)) {
			usevl = vlnames[i]
		}
	}

	newvl = 0
	if (usevl == "") {
		if (hasvl == 0) {
			usevl = vl
		}
		newvl = 1
	}
	len = ustrlen(vl)
	i = 0
	while (usevl == "") {
		i++
		tryvl = sprintf("%s%f", vl, i)
		n = ustrlen(tryvl) - c("namelen")
		if (n > 0) {
			tryvl = sprintf("%s%f", substr(vl,1,len-n), i)
		}
		if (!anyof(vlnames, tryvl)) {
			usevl = tryvl
		}
	}
	if (newvl) {
		st_vlmodify(usevl, *pv, *pt)
	}
	rc = _stata(sprintf("label values %s %s, nofix", newvar, usevl))
	if (rc) exit(rc)
}


end

exit
