*! version 1.0.6  08oct2019
program define _sep_varsylags , 

	version 9.1

	tempname exvars exlags exlags2 lagmat

	syntax varlist(ts) [, noConstant ]

	_rmcoll `varlist', `constant'
	local varlist `r(varlist)'

	mata: `exvars' = " "
	mata: `exlags' = J(0, 1, "")

	tsunab vlist : `varlist'

	local mlag 0
	
	foreach v of varlist `varlist' {
		gettoken tsops vname:v , parse(".")

		if "`vname'" == "" {
			local vname `tsops'
			local tsops ""
		}

		if "`tsops'" == "" {
			_my_post `vname' , lag(0) exvars(`exvars') 	///
				exlags(`exlags')
		}
		else {
			mata: LagsInTsop("`tsops'", "lags", "tsops2")
			local newv `tsops2'`vname'
			_my_post `newv' , lag(`lags') exvars(`exvars') 	///
				exlags(`exlags')
			if `lags' > `mlag' {
				local mlag `lags'
			}	
		}

	}

	mata: _VAR_sortlags(`exlags')

	mata: `lagmat' = .
	mata: _VAR_mklmat(`exlags', `lagmat', `mlag')

	mata: st_rclear()

	mata: st_global("r(basevars)", `exvars')
	mata: mata drop `exvars'

	mata: _VAR_m2s(`exlags', `exlags2'="")
	mata: st_global("r(lags)", `exlags2')
	mata: mata drop `exlags'
	mata: mata drop `exlags2'

	mata: st_matrix("r(lagsm)", `lagmat')
	mata: mata drop `lagmat'

	local exlags "`r(lags)'"
	foreach v of varlist `r(basevars)' {
		gettoken lags exlags:exlags , parse(":")
		if "`lags'" == ":" {
			gettoken lags exlags:exlags , parse(":")
			if "`lags'" == ":" | "`lags'" == "" {
				di as err "cannot obtain lag list for `v'"
				exit 498
			}	
		}

		local newlist `newlist' L(`lags').`v'
	}
	mata: st_global("r(newlist)", "`newlist'")
end

program define _my_post 

	syntax anything(name=vname), lag(integer) exvars(name) exlags(name)

	if `lag' < 0 {
		di as err "cannot add leads to varlist"
		exit 498
	}
	mata: st_local("vlist", `exvars')

	local vname = regexr("`vname'", "^\.", "")

	local pos : list posof "`vname'" in vlist

	if `pos' == 0 {
		mata: `exvars' = `exvars' + " `vname'"
		mata: `exlags' = `exlags' \ "`lag'"
	}
	else {
		mata: `exlags'[`pos',1] = `exlags'[`pos', 1] + " `lag'"
	}

end

mata:

void _VAR_sortlags(string colvector vname)
{
	real scalar 	i, j
	string scalar	nstring
	string vector	svec
	real vector	rowi

	for(i=1; i<=rows(vname); i++) {
		
		rowi = strtoreal(tokens(vname[i,1])')
		_sort(rowi,1)
		svec = strofreal(rowi')
		
		nstring = ""
		for(j=1; j<=cols(svec); j++) {
			nstring = nstring + " " + svec[1,j] 
		}
		vname[i,1] = strtrim(nstring)
	}
}

void _VAR_mklmat(string colvector vname, real matrix lagmat, real scalar mlag)
{
	real scalar	i,j, nvars
	string vector	svec
	
	nvars = rows(vname)
	lagmat = J(nvars, mlag+1, 0)
	
	for(i=1; i<=nvars; i++) {
		svec = (sort((tokens(vname[i,1]))', 1))'
		for(j=1; j<=cols(svec); j++) {
			lagmat[i, strtoreal(svec[1,j])+1] = 1
		}
	}
}

void _VAR_m2s(string colvector vname, string scalar sname) 
{
	real scalar 	i

	if (rows(vname) < 1) {
		printf("{err}cannot make colon separated string\n")
		exit(error(498))
	}

	sname = vname[1,1]
	for(i=2; i<=rows(vname); i++) {
		sname = sname + ":" + vname[i,1]
	}
}

void LagsInTsop(string scalar tsops, string scalar lag_mne, 
	string scalar tsops2_mne)
{
	string scalar 	nchar, lag
	real scalar	i

	nchar = bsubstr(tsops, 1, 1)

	if (nchar == "L") {		// use fact that L is always first in 
					// canonical form
		nchar = bsubstr(tsops, 2, 1)
		if ( regexm(nchar, "[0-9]") ) {
			lag = nchar
			i=3; 
			while(i<=strlen(tsops) & regexm(
				bsubstr(tsops, i, 1), "[0-9]") ) {
				nchar = bsubstr(tsops, i, 1)
				lag = lag + nchar	
				++i
			}
			st_local(lag_mne, lag)
			st_local(tsops2_mne, bsubstr(tsops,i,bstrlen(tsops)-i+1))
		}
		else {
			st_local(lag_mne, "1")
			st_local(tsops2_mne, bsubstr(tsops, 2, bstrlen(tsops)-1))
		}	
	}
	else {
		st_local(lag_mne, "0")
		st_local(tsops2_mne, tsops)
	}
}

end
