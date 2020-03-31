*! version 1.0.2  21feb2015
version 11

local vcerep	`"tokens("bootstrap jackknife")"'

mata:

class _sum_table {

protected:

	string	scalar	_bmat
	string	scalar	_vmat
	string	scalar	_emat
	real	scalar	_df
	real	scalar	_level

	string	scalar	cformat

	real	matrix	bmat
	real	matrix	vmat
	real	matrix	emat

	real	scalar	has_bmat
	real	scalar	has_vmat
	real	scalar	has_emat
	real	scalar	has_se

	real	scalar	_z
	string	matrix	stripe
	real	scalar	eq_info
	string	matrix	notes

class	_tab	scalar	Tab

	void		cluster()

public:

	void		new()
			set_b()
			set_V()
			set_errmat()
			set_df()
			set_level()

			set_cformat()

	void		validate()

	void		di_titles()
	void		di_eq()

	void		sep()
	void		finish()

}

// subroutines --------------------------------------------------------------

void _sum_table::cluster()
{
	string	scalar	msg
	string	scalar	clustvar
	string	scalar	nclust
	real	scalar	w

	if (any(strmatch(st_global("e(prefix)"), `vcerep'))) {
		msg	= "Replications based on"
		nclust	= "e(N_clust)"
	}
	else {
		msg	= "Std. Err. adjusted for"
		nclust	= "e(N_clust)"
	}
	clustvar = st_global("e(clustvar)")
	if (strlen(clustvar)) {
		w	= Tab.width_of_table()
		displayas("txt")
		if (length(st_numscalar(nclust))) {
			printf("{ralign %f:(%s {res:%f} clusters in %s)}\n",
				w,
				msg,
				st_numscalar(nclust),
				clustvar)
		}
		else {
			printf("{ralign %f:(%s clustering on %s)}\n",
				w,
				msg,
				clustvar)
		}
	}
}

// callable subroutines -----------------------------------------------------

void _sum_table::new()
{
	_df		= .
	_level		= c("level")
	cformat		= c("cformat")
}

function _sum_table::set_b(|string scalar bmat)
{
	if (args() == 0) {
		return(_bmat)
	}
	_bmat = bmat
}

function _sum_table::set_V(|string scalar vmat)
{
	if (args() == 0) {
		return(_vmat)
	}
	_vmat = vmat
}

function _sum_table::set_errmat(|string scalar emat)
{
	if (args() == 0) {
		return(_emat)
	}
	_emat = emat
}

function _sum_table::set_df(|real scalar df)
{
	if (args() == 0) {
		return(_df)
	}
	if (missing(df)) {
		_df = .
	}
	else {
		_df = floor(df)
	}
}

function _sum_table::set_level(|real scalar level)
{
	if (args() == 0) {
		return(_level)
	}
	if (missing(level)) {
		_level = c("level")
	}
	else {
		if (level < 10 | level > 99.99) {
		    errprintf("level must be between 10 and 99.99 inclusive\n")
		    exit(198)
		}
		_level = level
	}
}

function _sum_table::set_cformat(|string scalar fmt)
{
	if (args() == 0) {
		return(cformat)
	}
	if (strlen(fmt)) {
		cformat = fmt
	}
	else {
		cformat = c("cformat")
	}
}

void _sum_table::validate()
{
	if (strlen(cformat) == 0) {
		cformat = "%9.0g"
	}
	if (fmtwidth(cformat) > 9) {
		errprintf("invalid cformat;\nwidth too large\n")
		exit(198)
	}

	if (strlen(_bmat)) {
		bmat = st_matrix(_bmat)
	}
	else {
		_bmat = "e(b)"
	}
	if (strlen(_vmat) == 0) {
		if (st_macroexpand("`"+"e(V)"+"'") == "matrix") {
			_vmat = "e(V)"
		}
	}
	if (strlen(_vmat)) {
		vmat = sqrt(diagonal(st_matrix(_vmat)))'
	}
	if (strlen(_emat)) {
		emat = st_matrix(_emat)
	}

	Tab.init(5)
	Tab.set_lmargin(0)
	Tab.set_width((13,11,11,14,12))
	Tab.set_vbar((0,1,0,0,0,0))
	Tab.set_ignore(J(1,5,".b"))
	Tab.set_format_title(("%12s","%11s","%12s","%13s","%12s"))
	Tab.set_format_string(("","%11s","%1s","",""))
	Tab.set_format_number(J(1,5,cformat))
	Tab.set_color_string(("","result","","",""))

	_z = (_df > 2e17
	   ? invnormal((100+_level)/200)
	   : invttail(_df, (100-_level)/200))
	stripe	= st_matrixcolstripe(_bmat)
	eq_info = panelsetup(stripe, 1)

	has_bmat = cols(bmat)
	has_vmat = cols(vmat)
	has_emat = cols(emat)
	if (has_vmat | strlen(_vmat)) {
		has_se = 1
	}
	else {
		has_se = 0
	}

	notes	= J(1,8,"")
	notes[1] = "(no observations)"
	notes[2] = "(stratum with 1 PSU detected)"
	notes[3] = "(sum of weights equals zero)"
	notes[4] = "(denominator estimate equals zero)"
	notes[5] = "(omitted)"
	notes[6] = "(base)"
	notes[7] = "(empty)"
	notes[8] = "(not estimable)"
}

void _sum_table::di_titles()
{
	string	scalar	dv
	string	scalar	coefttl
	string	scalar	vce
	string	scalar	mse
	string	scalar	vcettl
	real	scalar	vcewd
	string	scalar	vcefmt
	string	scalar	obs
	string	scalar	ttl4
	string	scalar	ttl5
	real	scalar	ciwd
	string	scalar	name
	real	scalar	plus
	real	scalar	rc
		vector	hold
	real    scalar  dppos 
	
	if (strlen(st_global("e(over)"))) {
		dv = "Over"
	}
	coefttl = strproper(st_global("e(cmd)"))
	vcettl	= st_global("e(vcetype)")

	cluster()

	Tab.sep("top")

	if (strlen(vcettl)) {
		vce	= st_global("e(vce)")
		mse	= st_global("e(mse)")
		obs	= ""
		ttl4	= ""
		ttl5	= ""
		if (vce == "bootstrap") {
			obs = "Observed"
			if (vcettl == "Bootstrap") {
				ttl5 = "Normal-based"
			}
		}
		plus	= 0
		vcewd	= strlen(vcettl)
		if (strlen(mse)) {
			name = sprintf("%s_%s", vce, mse)
			stata(sprintf("capture which %s.sthlp", name))
			rc = c("rc")
			if (rc) {
				stata(sprintf("capture which %s.hlp", name))
				rc = c("rc")
			}
			if (!rc) {
				vcettl = sprintf(	"{help %s##|_new:%s}",
							name,
							vcettl)
				plus = strlen(vcettl) - vcewd
			}
			stata("capture")
		}
		vcewd	= vcewd + plus + ceil((12 - vcewd)/2+1)
		vcefmt	= sprintf("%%%fs", vcewd)
		ciwd = udstrlen(ttl5)
		if (ciwd > 2) {
			ciwd  = ceil((ciwd-2)/2) - 1
			ttl4  = udsubstr(ttl5, 1, ciwd)	
			dppos = ustrlen(ttl4)
			ttl5  = usubstr(ttl5, dppos+1, .)	
		}
		hold = Tab.set_format_title()
		Tab.set_format_title(("%-12s","",vcefmt,"","%1s"))
		Tab.titles(("", obs, vcettl, ttl4, ttl5))
		Tab.set_format_title(hold)
	}

	if (has_se) {
		ttl4	= sprintf("[%g%% Con", _level) 
		ttl5	= "f. Interval]"
		hold	= Tab.set_width()
		Tab.set_width(hold + (0,0,1,-1,0))
		Tab.titles((	dv,
				coefttl,
				"Std. Err.",
				ttl4,
				ttl5))
		Tab.set_width(hold)
	}
	else {
		Tab.titles((	dv,
				coefttl,
				"",
				"",
				""))
	}
}

void _sum_table::di_eq(real scalar eq)
{
	string	scalar	eqname
	real	scalar	i0
	real	scalar	k
	real	scalar	output
	string	scalar	first
	string	scalar	ms_di
	real	scalar	i, j
	string	scalar	matopt
	real	scalar	census
	real	scalar	b
	real	scalar	se
	real	scalar	z
	real	scalar	ll
	real	scalar	ul
	real	scalar	err
	string	scalar	note
	string	vector	nfmt
		vector	nhold
		vector	shold

	if (eq < 1 | eq > rows(eq_info)) {
		exit(error(303))
	}

	census	= 0
	if (st_global("e(prefix)") == "svy") {
		if (length(st_numscalar("e(census)"))) {
			census = st_numscalar("e(census)")
		}
	}

	Tab.sep()

	i0	= eq_info[eq,1]
	k	= eq_info[eq,2] - i0 + 1
	eqname	= stripe[i0,1]

	if (eqname == "_") {
		eqname = ""
	}
	matopt	= sprintf("mat(%s)", _bmat)
	if (strlen(eqname)) {
		stata(sprintf("_ms_eq_display, eq(%f) %s", eq, matopt))
		printf("\n")
	}
	output	= 0
	first	= ""
	ms_di	= "_ms_display, eq(#%f) el(%f) %s %s"
	nfmt	= J(1,5,"")
	nhold	= Tab.set_format_number()
	shold	= Tab.set_format_string()
	Tab.set_format_string(("","%-11s","","",""))
	Tab.set_skip1(1)
	z	= _z
	j	= i0
	for (i=1; i<=k; i++,j++) {
		stata(sprintf(ms_di, eq, i, first, matopt))
		if (st_numscalar("r(output)")) {
			first = ""
			if (!output) {
				output = 1
			}
		}
		else {
			if (st_numscalar("r(first)")) {
				first = "first"
			}
			continue
		}
		note	= st_global("r(note)")

		if (has_bmat) {
			b	= bmat[1,j]
			if (has_vmat) {
				se	= vmat[1,j]
			}
			else {
				se	= 0
			}
		}
		else {
			b	= st_numscalar("r(b)")
			se	= st_numscalar("r(se)")
		}

		if (has_se & se == 0 & census) {
			ll	= .
			ul	= .
		}
		else {
			if (se == 0) {
				if (length(st_numscalar("e(singleton)"))) {
					if (st_numscalar("e(singleton)") == 1) {
						se = .
					}
				}
				else if (st_global("e(singleton)") == "1") {
					se = .
				}
				ll	= .
				ul	= .
			}
			else {
				ll = b - se*z
				ul = b + se*z
			}
		}

		if (b == 0) {
			if (has_se & missing(se)) {
				if (strlen(note) == 0) {
					note = notes[5]
				}
			}
		}
		else {
			note = ""
		}
		if (has_emat) {
			err	= emat[1,j]
			if (err >=1 & err <= 8 & floor(err) == err) {
				note = notes[err]
			}
		}
		if (strlen(note)) {
			note = "  " + note
		}
		if (strlen(note)) {
			Tab.row((.b,.b,.b,.b,.b),
				("",note,"","",""))
		}
		else {
			Tab.set_format_number(nfmt)
			if (!has_se) {
				Tab.row((.b,b,J(1,3,.b)))
			}
			else {
				Tab.row((.b,b,se,ll,ul))
			}
		}
	}
	Tab.set_format_number(nhold)
	Tab.set_format_string(shold)
	Tab.set_skip1(.)
}

void _sum_table::sep(|string scalar type)
{
	if (args() == 0) {
		type = "middle"
	}
	Tab.sep(type)
}

void _sum_table::finish()
{
	Tab.sep("bottom")
	st_sclear()
	st_global("s(width)", strofreal(Tab.width_of_table()))
}

end
