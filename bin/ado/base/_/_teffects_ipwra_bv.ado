*! version 1.0.2  10sep2019

program define _teffects_ipwra_bv, rclass
	version 13
	syntax [ namelist(max=1) ],  kpar(integer) komit(integer)         ///
		index(numlist) tvar(varname) tlevels(string) stat(string) ///
		[ omodel(string) tmodel(string) control(string)           ///
		fvdvlist(string) fvhdvlist(string) fvtvlist(string)       ///
		fvhtvlist(string) enseparator dconstant(integer 0)        ///
		tconstant(integer 0)]

	local tlab : variable label `tvar'

	if "`enseparator'" != "" {
		local ens "_"
	}
	local init = ("`namelist'"!="")

	if ("`stat'"=="att") local stat atet
	
	local tlevnoc : list tlevels - control
	local klev : list sizeof tlevels
	local keq = 1
	if "`stat'" == "pomeans" {
		/* mean equation					*/
		foreach lev of local tlevels {
			local names `"`names' POmeans:`lev'.`tvar'"'
		}
	}
	else {
		/* TE equation						*/
		local STAT = upper("`stat'")
		foreach lev of local tlevnoc {
			local names `"`names' `STAT':r`lev'vs`control'.`tvar'"'
		}
		local names `"`names' POmean:`control'.`tvar'"'
		local `++keq'
	}
	gettoken k1 ind : ind
	if "`omodel'" != "" {
		local keq = `keq' + `klev'
		/* RA equations						*/
		foreach lev of local tlevels {
			foreach vi of local fvdvlist {
				local names `"`names' OME`ens'`lev':`vi'"'
			}
			if `dconstant' {
				local names `"`names' OME`ens'`lev':_cons"'
			}
		}
		if ("`omodel'" == "hetprobit"|"`omodel'" == "fhetprobit") {
			foreach lev of local tlevels {
				foreach vi of local fvhdvlist {
					local ni `"OME`ens'`lev'_lnsigma:`vi'"'
					local names `"`names' `ni'"'
				}
				local `++keq'
			}
		}
	}
	if "`tmodel'" != "" {
		local keq = `keq' + `klev' - 1
		/* IPW equations					*/
		foreach lev of local tlevnoc {
			foreach vi of local fvtvlist {
				local names `"`names' TME`ens'`lev':`vi'"'
			}
			if `tconstant' {
				local names `"`names' TME`ens'`lev':_cons"'
			}
		}
		if "`tmodel'" == "hetprobit" {
			/* only one element in tlevnoc			*/
			local lev `tlevnoc'
			foreach vi of local fvhtvlist {
				local names `"`names' TME`ens'`lev'"'
				local names `"`names'_lnsigma:`vi'"'
			}
			local `++keq'
		}
	}
	return local keq = `keq'
	if `init' {
		local b `namelist'
	}
	else {
		tempname b V
		matrix `b' = e(b)
		matrix `V' = e(V)
	}
	local pivot = ("`stat'"!="pomeans")
	if `komit' | `pivot' {
		if `pivot' {
			local pivot : list posof "`control'" in tlevels
			local pivot (`pivot',`klev')
		}
		else local pivot

		mata: _teffects_fill_bV(`kpar',"`b'","`V'","`index'",`pivot')
	}
	matrix colnames `b' = `names'
	return mat b = `b'
	return local enseparator `ens'
	if !`init' {
		matrix colnames `V' = `names'
		matrix rownames `V' = `names'
		return mat V = `V'
	}
end

mata:

void _teffects_fill_bV(real scalar k, string scalar sb, string scalar sV, 
		string scalar sind, | real rowvector p)
{
	real scalar i1, i2, j1, j2, bv
	real rowvector j
	real rowvector b
	real matrix V

	j = strtoreal(tokens(sind))
	b = J(1,k,0)
	b[j] = st_matrix(sb)
	if (bv=(strlen(sV))) {
		V = J(k,k,0)
		 V[j,j] = st_matrix(sV)
	}
	if (length(p) == 2) {
		if (p[1] < p[2]) {
			j = J(1,0,0)
			i1 = p[1]-1
			i2 = p[1]+1
			j1 = p[2]
			j2 = p[2]+1
			if (i1) j = (1..i1)
			j = (j,i2..j1,p[1],j2..k)
	
			b[.] = b[j]
			if (bv) V[.,.] = V[j,j']
		}
	}

	st_matrix(sb,b)
	if (bv) st_matrix(sV,V)
}
end
exit
