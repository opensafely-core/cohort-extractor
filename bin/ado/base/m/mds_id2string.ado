*! version 1.1.1  09sep2019

// mds_id2string turns the identification variable -id- into the string
// variable ID, unmodified strings at full length in r(labels), and the
// associated codes (suitable for use as matrix stripes) in r(codes).

program mds_id2string, rclass sortpreserve
	version 10
	syntax varname, touse(varname) gen(str) [ nosortid ]
	
	local id `varlist'
	local ID `gen'

	_nostrl nostrl : `id'
	if `nostrl' {
		di as err as smcl "type mismatch"
		di as err as smcl "{p 4 4 2}"
		di as err as smcl "strLs not allowed with this command."
		di as err as smcl "{p_end}"
		exit 109
	}
	
	confirm new var `ID'

	capt assert !missing(`id') if `touse'
	if _rc {
		dis as err "id() has missing values"
		exit 198
	}	
	
	// if you change the logic here be sure to change it in mds_p

	local type : type `id'
	local idtype = bsubstr("`type'",1,3)
	if "`sortid'" == "" {
		sort `id', stable
	}	
	if "`idtype'" != "str" {
		local label : value label `id'
		tempname idc
		mata: NumValues("`id'","`touse'","`idc'")
			
		if "`label'" != "" {
			// id is value labeled
			qui decode `id' if `touse', gen(`ID')
			local idtype label
			local id1 `ID'
		}
		else {
			// is unlabeled numeric
			local fmt: format `id'
			capt assert `id'==round(`id') if `touse'
			if _rc == 0 {
				local idtype int
				qui gen `ID' = string(`id',"`fmt'") if `touse'
				local id1 `ID'
			}
			else {
				local idtype float
				tempvar id1
				qui gen `id1' = string(`id',"`fmt'") if `touse'
			}
		}
	}
	else {
		local id1 `id'
	}

	// duplicates in id values
	
	Duplicates `touse' `id'
	local duplicates = (_rc > 0)
	
	// now id1 denotes a string versions of id-values
	
	if `duplicates'==0  {
		// collect id1 values in macro _labels,
	        // embedded in compounded quotes

		mata: PasteLabels("`id1'","`touse'","labels","mxlen")
		if `"`labels'"' != "" {
			return local labels `"`labels'"'
			return local mxlen = `mxlen'
		}
		else {
			// could not paste
			dis as txt "exceeded maximum macro length " ///
			           "to store id labels"
			local duplicates = 1
		}
	}

	// write cleanup labels in id1 into ID
	mata: CleanLabels("`id1'", "`touse'", "`ID'")

	// make sure CleanLabels has not created duplicates
	// otherwise, ID is modified
	qui EnsureUnique `ID' `touse'
			
	// collect ID values, cleaned to be appropriate for use
	// in matrix stripes, in macro _codes, sep by blank
	mata: PasteCodes("`ID'","`touse'","codes")

	if "`idtype'" != "str" {
		matrix rownames `idc' = `codes'
		return matrix idcoding = `idc'
	}	
	return local codes `"`codes'"'
	
	return local duplicates `duplicates'
	return local idtype     `idtype'
end


// Displays a warning message if duplicates
//
program Duplicates, sortpreserve
	args touse id

	capt bys `touse' `id': assert _N==1 if `touse'
	if _rc {
		dis as txt "(id() has duplicate values)"
	}
end


program EnsureUnique, sortpreserve
	args id touse

	tempvar j tmp
	gen int `j' = _n

	sort `touse' `id', stable
	capt by `touse' `id': assert _N==1 if `touse'
	if (_rc == 0) {
		exit 0
	}	

	// keep a copy of id for -rare- problem below
	gen `tmp' = `id'

    if c(userversion) < 15 {
	// tag #`j' on duplicates
	by `touse' `id': replace `id' = `id'+"#"+string(`j') if `touse' & _N>1
    }
    else {
	// tag _`j' on duplicates
	by `touse' `id': replace `id' = `id'+"_"+string(`j') if `touse' & _N>1
    }

	// probably unique now
	capt bys `touse' `id': assert _N==1 if `touse'
	if (_rc == 0) {
		exit 0
	}	

    if c(userversion) < 15 {
	// in very rare cases  old-string + tag may coincide with other
	// old-string; in such a case, we add tag #`j' to all codes
	replace `id' = `tmp'+"#"+string(`j') if `touse'
    }
    else {
	// in very rare cases  old-string + tag may coincide with other
	// old-string; in such a case, we add tag _`j' to all codes
	replace `id' = `tmp'+"_"+string(`j') if `touse'
    }
end


mata:

// cleans up for use as matrix stripes the strings in string variable _sid
// in sample _stourse, returning results in the string variable _sID
//
void CleanLabels( string scalar _sid, string scalar _stouse ,
	string scalar _sID )
{
	real scalar       i, n, mxl
	string colvector  vID

	vID = st_sdata(., _sid, _stouse)
	n = rows(vID)
	if (n == 0)
	return

	mxl = 0
	for (i=1; i<=n; i++) {
		vID[i] = _mds_strcleanup(vID[i])
		mxl = max((mxl,strlen(vID[i])))
	}

	if (_sid != _sID)	
	i = _st_addvar("str" + strofreal(mxl), _sID)
	st_sstore(., _sID, _stouse, vID)
}


void NumValues( string scalar _sid, string scalar _stouse,
	string scalar _smatname)
{
	st_matrix(_smatname, st_data(., _sid, _stouse))
}


// returns in local _smac the strings in the cleaned-for-use-in-stripes
// variable _sid in the sample _stouse.
//
void PasteCodes( string scalar _sid,  string scalar _stouse,
	string scalar _smac )
{
	real   scalar    i, n
	string scalar    names
	string colvector vnames

	vnames = st_sdata(., _sid, _stouse)
	n = rows(vnames)
	if (n == 0)
	return

	names = vnames[1]
	for (i=2; i<=n; i++)
	names = names + " " + vnames[i]

	st_local(_smac, names)
}


void PasteLabels( string scalar _sid,  string scalar _stouse,
	string scalar _smac, string scalar _smxlen )
{
	real scalar       i, n, nmax, l, li, mxl
	string scalar     strs
	string colvector  vid

	vid = st_sdata(., _sid, _stouse)
	n = rows(vid)
	if (n == 0)
	return

	nmax = st_numscalar("c(max_macrolen)")
	strs = char(96) + char(34) + vid[1] + char(34) + char(39)
	mxl = strlen(vid[1])
	l   = mxl + 4
	for (i=2; i<=n; i++) {
		strs = strs + char(32) + char(96) + char(34) +
		vid[i] + char(34) + char(39)
		li = strlen(vid[i])
		mxl = max((mxl,li))
		l = l + li + 5
		if (l > nmax)
		exit(0)
	}

	st_local(_smac,   strs)
	st_local(_smxlen, strofreal(mxl))
}

end

