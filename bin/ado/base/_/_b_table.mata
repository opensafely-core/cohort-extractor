*! version 2.4.8  03mar2020
version 12

local type_selegend	-2
local type_coeflegend	-1
local type_dflt		0
local type_beta		1
local type_ci		2
local type_pv		3
local type_dftable	4
local type_groups	5
local type_df		6
local type_dfci		7
local type_dfpv		8

local vcerep	bootstrap jackknife

local asfree	cmmprobit cmroprobit  
local ascmds	asmprobit asroprobit asclogit nlogit ///
                asmixlogit cmmixlogit cmxtmixlogit   ///
                `asfree' cmclogit

local varlen	5
local covlen	6

findfile _b_stat_include.mata
include `"`r(fn)'"'

qui findfile _clogitmodel_macros.ado
qui include `"`r(fn)'"'

mata:

class _b_table extends _b_stat {

protected:

	// settings
	real	scalar	_type
	real	scalar	_showginv
	real	scalar	_nofoot
	real	scalar	_sort

	string	vector	_offset

	string	scalar	_pisemat		// mi setting
	string	scalar	_extrarowmat		// mi setting for MCMC error

	string	scalar	_eqmat

	string	scalar	_diopts

	real	scalar	_markdown

	real	scalar	_separator

	string	scalar	_depname
	string	vector	_coefttl
	string	scalar	_pttl
	string	scalar	_cittl

	real	scalar	_mclegend
	string	scalar	_cnsreport
	real	scalar	_clreport

	string	scalar	cformat
	string	scalar	sformat
	string	scalar	pformat
	string	scalar	rowcformat
	string	scalar	rowsformat
	string	scalar	rowpformat

		vector	rowmatnfmt

	real	scalar	_plus
	real	scalar	_eq_hide
	real	scalar	_eq_hide_first

	real	scalar	_lstretch
	real	scalar	_fvignore
	real	scalar	_flignore

	// work space
	real	scalar	k_eq_base		// e(k_eq_base)

	real	scalar	k_lf
	real	scalar	k_fp

	real	scalar	_width
	real	scalar	_indent
	real	scalar	_is_var

	string	scalar	_ms_di
	string	scalar	_eq_di

	string	scalar	elSpec
	string	scalar	eqSpec

	real	scalar	is_legend
	real	scalar	is_cpg
	real	scalar	is_dfcp

	string	scalar	extra_opts

	real	matrix	pisemat
	real	scalar	dfmis
	real	scalar	has_pisemat

	real	matrix	extrarowmat
	real	scalar	has_extrarowmat
	real	scalar	_norowci

	string	matrix	eqmat_stripe
	real	matrix	eqmat
	real	scalar	has_eqmat

	real	matrix	el_info
	real	matrix	order
	real	matrix	sub_el_info
	real	matrix	sub_order

class	_tab	scalar	Tab

class _put_tab	scalar	putTab

	// private subroutines
	real	scalar	_find_min_width()
	real	scalar	_find_min_width4sem()
	real	scalar	_find_min_width4sem1()
	real	scalar	_find_min_width4gsem2()
	real	scalar	_find_min_width4mecmd()

	string	scalar	cititle()

	void		mclegend()

	void		init_table()

	void		cluster()
	void		titles()

	void		comment()
	void		di_comment()

	real	scalar	di_eqname()
	void		di_offset()
	void		di_eq_el()
	void		di_eq_el_u()
	void		di_eq()
	void		di_var_eq()
	void		di_cov_eq()
	void		do_equations()
	void		do_equations_grouped()
	void		do_equations_ascmd()
	void		do_equations_nlogit()
	real	vector	get_sem_ginv_blocks()
	void		do_equations_sem1()
	void		di_fp_sem()
	void		di_eq_sem()
	void		do_equations_sem()
	void		do_equations_gsem2()
	void		di_eq_gsem()
	void		do_equations_gsem()
	void		di_eq_mecmd()
	void		do_equations_mecmd()

	void		di_aux()
	void		do_aux()
	void		do_aux_ascmd1()
	void		do_aux_ascmd2()

	void		show_diparm()
	void		do_diparms()

	void		do_extra()

	void		sep()
	void		finish()
	void		blank()

public:

	void		new()
virtual	void		validate()
	void		fmm_check()

			set_type()
			set_showginv()
			set_nofoot()
			set_sort()

			set_offset()

			set_pisemat()
			set_extrarowmat()

			set_eqmat()

			set_diopts()

			set_markdown()

			set_separator()

			set_depname()
			set_coefttl()
			set_pttl()
			set_cittl()

			set_mclegend()
			set_cnsreport()
			set_clreport()

			set_cformat()
			set_sformat()
			set_pformat()
			set_rowcformat()
			set_rowsformat()
			set_rowpformat()

			set_plus()
			set_eq_hide()
			set_lstretch()
			set_fvignore()
			set_flignore()

	void		report_table()

virtual	void		post_results()

}

// private subroutines ------------------------------------------------------

real scalar _b_table::_find_min_width(	real	scalar	width,
					string	scalar	matname,
					|real	scalar	dolevels,
					string	scalar	extra)
{
	real	scalar	rc
	real	scalar	max
	real	scalar	w
	real	scalar	dim
	real	scalar	eq
	real	scalar	i
	real	scalar	k
	string	scalar	tname
	string	matrix	stripe
	string	scalar	text
	real	vector	sel

	if (_lstretch == 0) {
		return(12)
	}
	if (width < 12 | missing(width)) {
		return(12)
	}
	if (missing(dolevels)) {
		dolevels = 1
	}
	if (_cmd == "sem") {
		if (st_numscalar("e(sem_vers)") == 2) {
			return(_find_min_width4sem(	width,
							matname,
							dolevels,
							extra))
		}
		else {
			return(_find_min_width4sem1(	width,
							matname,
							dolevels,
							extra))
		}
	}
 	else if (anyof(tokens("gsem meglm"), _cmd) |
 	         anyof(tokens("gsem meglm"), _cmd2)) {
		if (st_numscalar("e(gsem_vers)") == 3) {
			if (is_me) {
				return(_find_min_width4mecmd(	width,
								matname,
								dolevels,
								extra))
			}
			return(_mc_find_min_width(	width,
							matname,
							dolevels,
							extra))
		}
		else {
			return(_find_min_width4gsem2(	width,
							matname,
							dolevels,
							extra))
		}
	}
	else {
		max = _mc_find_min_width(width, matname, dolevels, extra)
		if (_ndiparm) {
			tname = st_tempname()
			dim	= rows(diparm_stripe)
			st_matrix(tname, J(1,dim,0))
			stripe	= diparm_stripe
			sel	= strmatch(stripe[,1], "_diparm*")
			if (any(sel)) {
				sel	= selectindex(sel)
				stripe[sel,]	= stripe[sel,(2,1)]
			}
			st_matrixcolstripe(tname, stripe)
			for (eq=1; eq<=dim; eq++) {
				rc = _stata(sprintf(
"_ms_eq_display, diparm matrix(%s) width(%f) eq(%f)",
				tname, width, eq), 1)
				if (rc == 0 & st_numscalar("r(output)") == 1) {
					k = st_numscalar("r(k)")
					for (i=1; i<=k; i++) {
						text = sprintf("r(eq%f)", i)
						w = udstrlen(st_global(text))
						if (max < w) {
							max = w
						}
					}
				}
			}
		}
		return(max)
	}
}

real scalar _b_table::_find_min_width4sem1(
	real	scalar	width,
	string	scalar	matname,
	|real	scalar	dolevels,
	string	scalar	extra)
{
	real	scalar	rc
	real	vector	gib
	real	scalar	gidx
	string	scalar	block
	real	scalar	new_block
	string	scalar	old_name
	string	scalar	name
	real	scalar	pos
	real	scalar	el1
	real	scalar	el2
	real	scalar	nels
	real	scalar	max
	real	scalar	eq
	real	scalar	el
	real	scalar	k
	real	scalar	i
	real	scalar	w
	string	scalar	text
	string	scalar	eqextra
	string	scalar	myextra
	real	scalar	star
	real	scalar	ind
	real	scalar	ind2
	string	vector	coef
	string	vector	vcm

	pragma unset name

	coef = tokens("structural measurement")
	vcm = tokens("variance covariance mean")

	if (missing(dolevels)) {
		dolevels = 1
	}
	myextra = eqextra = extra
	if (strpos(extra, "sem")) {
		myextra	= myextra + " sem star"
	}

	gib	= get_sem_ginv_blocks()

	gidx	= .
	block	= ""
	old_name = ""
	pos	= 1
	max	= 0
	for (eq=1; eq<=neq; eq++) {
		el1 = eq_info[eq,1]
		el2 = eq_info[eq,2]
		nels = el2 - el1 + 1
		new_block = _sem_eq_block(	stripe[el1,1],
						stripe[el1,2],
						pclassmat[el1],
						block,
						name)
		if (new_block) {
			w = udstrlen(block)
			if (max < w) {
				max = w
			}
		}
		ind = 2
		if (anyof(coef, block) & old_name!=name) {
			old_name = name
			w = udstrlen(name) + 2
			if (max < w) {
				max = w
			}
		}
		if (anyof(vcm, block)) {
			rc = _stata(sprintf(
"_ms_eq_display, aux matrix(%s) width(%f) eq(%f) %s",
				matname, width, eq, eqextra), 1)
			if (rc == 0 & st_numscalar("r(output)") == 1) {
				k = st_numscalar("r(k)")
				for (i=1; i<=k; i++) {
					text = sprintf("r(eq%f)", i)
					w = udstrlen(st_global(text)) - 1
					if (max < w) {
						max = w
					}
				}
			}
			if (nels == 1) {
				nels = 0
			}
		}
		ind2 = ind + 2
		for (el=1; el<=nels; el++) {
			star = 0
			if (gib[pos]) {
				if (gidx != gib[pos]) {
					gidx = gib[pos]
					star = 1
				}
			}
			rc = _stata(sprintf(
"_ms_display, matrix(%s) width(%f) eq(#%f) el(%f) %s",
				matname, width, eq, el,
				(star ? myextra : extra)), 1)
			pos++
			if (st_numscalar("r(output)") == 0) {
				continue
			}
			if (rc == 0) {
				k = st_numscalar("r(k_term)")
				if (k == 0) {
					w = udstrlen(st_global("r(term)")) + ind
					if (max < w) {
						max = w
					}
				}
				for (i=1; i<=k; i++) {
					text = sprintf("r(term%f)", i)
					w = udstrlen(st_global(text)) + ind
					if (max < w) {
						max = w
					}
				}
				if (dolevels) {
				    k = st_numscalar("r(k_level)")
				    if (k == 0) {
					w = udstrlen(st_global("r(level)")) + ind2
					if (max < w) {
						max = w
					}
				    }
				    for (i=1; i<=k; i++) {
					text = sprintf("r(level%f)", i)
					w = udstrlen(st_global(text)) + ind2
					if (max < w) {
						max = w
					}
				    }
				}
			}
		}
	}

	if (max < 12) {
		return(12)
	}
	if (max > width) {
		return(width)
	}
	return(max)
}

real scalar _b_table::_find_min_width4sem(
	real	scalar	width,
	string	scalar	matname,
	|real	scalar	dolevels,
	string	scalar	extra)
{
	real	scalar	rc
	string	scalar	msdi
	string	vector	coef
	real	vector	gib
	real	scalar	gidx
	string	scalar	block
	string	scalar	old_name
	string	scalar	name
	real	scalar	max
	real	scalar	pos
	real	scalar	eq
	real	scalar	el1
	real	scalar	el2
	real	scalar	nels
	real	scalar	el
	real	scalar	k
	real	scalar	i
	real	scalar	star
	real	scalar	ind
	real	scalar	ind2
	string	scalar	myextra
	real	scalar	new_block
	real	scalar	w
	string	scalar	text

	msdi = "_ms_display, matrix(%s) width(%f) eq(#%f) el(%f) %s"
	coef = tokens("structural measurement")

	if (missing(dolevels)) {
		dolevels = 1
	}

	if (st_global("e(groupvar)") != "") {
		extra	= extra + " fvignore(1)"
		if (_flignore == 1) {
			extra	= extra + " flignore"
		}
	}
	myextra	= extra + " star"

	gib	= get_sem_ginv_blocks()

	gidx	= .
	block	= ""
	name	= ""
	old_name = ""
	pos	= 1
	max	= 0
	for (eq=1; eq<=neq; eq++) {
		el1 = eq_info[eq,1]
		el2 = eq_info[eq,2]
		nels = el2 - el1 + 1
		for (el=1; el<=nels; el++) {
			new_block = _sem_eq_block(	stripe[pos,1],
							stripe[pos,2],
							pclassmat[pos],
							block,
							name)
			if (new_block) {
				w = udstrlen(block)
				if (max < w) {
					max = w
				}
			}
			if (anyof(coef, block)) {
				ind	= 2
				ind2	= ind + 2
				if (old_name != name) {
					old_name = name
					w = udstrlen(name) + 2
					if (max < w) {
						max = w
					}
				}
			}
			else {
				ind	 = -1
				ind2	 = 2
			}
			star = 0
			if (gib[pos]) {
				if (gidx != gib[pos]) {
					gidx = gib[pos]
					star = 1
				}
			}
			rc = _stata(sprintf(	msdi,
						matname,
						width,
						eq,
						el,
						(star ? myextra : extra)), 1)
			if (rc != 0) {
				continue
			}
			if (st_numscalar("r(output)") == 0) {
				continue
			}
			k = st_numscalar("r(k_term)")
			if (k == 0) {
				text = st_global("r(term)")
				w = udstrlen(text) + ind
				if (max < w) {
					max = w
				}
			}
			for (i=1; i<=k; i++) {
				text = sprintf("r(term%f)", i)
				w = udstrlen(st_global(text)) + ind
				if (max < w) {
					max = w
				}
			}
			if (dolevels) {
			    k = st_numscalar("r(k_level)")
			    if (k == 0) {
				w = udstrlen(st_global("r(level)")) + ind2
				if (max < w) {
					max = w
				}
			    }
			    for (i=1; i<=k; i++) {
				text = sprintf("r(level%f)", i)
				w = udstrlen(st_global(text)) + ind2
				if (max < w) {
					max = w
				}
			    }
			}
			pos++
		}
	}

	if (max < 12) {
		return(12)
	}
	if (max > width) {
		return(width)
	}
	return(max)
}

real scalar _b_table::_find_min_width4gsem2(
	real	scalar	width,
	string	scalar	matname,
	|real	scalar	dolevels,
	string	scalar	extra)
{
	real	scalar	rc
	string	scalar	block
	real	scalar	new_block
	string	scalar	old_name
	string	scalar	prefix
	string	scalar	name
	string	scalar	name2
	real	scalar	pos
	real	scalar	el1
	real	scalar	el2
	real	scalar	nels
	real	scalar	max
	real	scalar	eq
	real	scalar	el
	real	scalar	k
	real	scalar	i
	real	scalar	w
	string	scalar	text
	string	scalar	eqextra
	real	scalar	ind
	real	scalar	ind2
	string	vector	coef
	string	vector	vcm

	pragma unset prefix
	pragma unset name
	pragma unset name2

	coef = tokens("coef structural measurement base")
	vcm = tokens("variance covariance mean")

	if (missing(dolevels)) {
		dolevels = 1
	}
	eqextra = extra

	block	= ""
	old_name = ""
	pos	= 1
	max	= 0
	for (eq=1; eq<=neq; eq++) {
		el1 = eq_info[eq,1]
		el2 = eq_info[eq,2]
		nels = el2 - el1 + 1
		new_block = _gsem_eq_block(	stripe[el1,1],
						eqprefix[el1],
						stripe[el1,2],
						pclassmat[el1],
						is_me,
						block,
						prefix,
						name,
						name2)
		if (new_block) {
			w = udstrlen(prefix)
			if (max < w) {
				max = w
			}
		}
		ind = 0
		if (anyof(coef, block) & old_name!=name) {
			old_name = name
			if (block == "base") {
				name = abbrev(name, width) 
			}
			else if (!is_me) {
				if (udstrlen(name) > width) {
					name = abbrev(name, width) 
				}
			}
			w = udstrlen(name)
			if (max < w) {
				max = w
			}
			if (block == "base") {
				continue
			}
		}
		if (anyof(vcm, block)) {
			rc = _stata(sprintf(
"_ms_eq_display, aux matrix(%s) width(%f) eq(%f) %s %s",
					matname,
					width,
					eq,
					eqextra,
					(is_me ? "mecmd" : "")),
				1)
			if (rc == 0 & st_numscalar("r(output)") == 1) {
				k = st_numscalar("r(k)")
				for (i=1; i<=k; i++) {
					text = sprintf("r(eq%f)", i)
					w = udstrlen(st_global(text)) - 1
					if (max < w) {
						max = w
					}
				}
			}
			if (nels == 1) {
				nels = 0
			}
		}
		ind2 = ind + 2
		for (el=1; el<=nels; el++) {
			rc = _stata(sprintf(
"_ms_display, matrix(%s) width(%f) eq(#%f) el(%f) %s gsem",
				matname, width, eq, el, extra), 1)
			pos++
			if (st_numscalar("r(output)") == 0) {
				continue
			}
			if (rc == 0) {
				k = st_numscalar("r(k_term)")
				if (k == 0) {
					w = udstrlen(st_global("r(term)")) + ind
					if (max < w) {
						max = w
					}
				}
				for (i=1; i<=k; i++) {
					text = sprintf("r(term%f)", i)
					w = udstrlen(st_global(text)) + ind
					if (max < w) {
						max = w
					}
				}
				if (dolevels) {
				    k = st_numscalar("r(k_level)")
				    if (k == 0) {
					w = udstrlen(st_global("r(level)")) + ind2
					if (max < w) {
						max = w
					}
				    }
				    for (i=1; i<=k; i++) {
					text = sprintf("r(level%f)", i)
					w = udstrlen(st_global(text)) + ind2
					if (max < w) {
						max = w
					}
				    }
				}
			}
		}
	}

	if (max < 12) {
		return(12)
	}
	if (max > width) {
		return(width)
	}
	return(max)
}

real scalar _b_table::_find_min_width4mecmd(
	real	scalar	width,
	string	scalar	matname,
	|real	scalar	dolevels,
	string	scalar	extra)
{
	real	scalar	max
	string	scalar	block
	real	scalar	new_block
	string	scalar	prefix
	string	scalar	name
	string	scalar	name2
	real	scalar	el1
	real	scalar	el2
	real	scalar	eq
	real	scalar	el
	real	scalar	w

	max = _mc_find_min_width(	width,
					matname,
					dolevels,
					extra + " mecmd")

	block	= ""
	prefix	= ""
	name	= ""
	name2	= ""
	for (eq=1; eq<=neq; eq++) {
		el1 = eq_info[eq,1]
		el2 = eq_info[eq,2]
		if (stripe[el1,1] != "/") {
			continue
		}
		for (el=el1; el<=el2; el++) {
			new_block = _gsem_eq_block(	stripe[el,1],
							eqprefix[el],
							stripe[el,2],
							pclassmat[el],
							is_me,
							block,
							prefix,
							name,
							name2)
			if (new_block) {
				w = udstrlen(prefix)
				if (max < w) {
					max = w
				}
			}
		}
	}

	if (max < 12) {
		return(12)
	}
	if (max > width) {
		return(width)
	}
	return(max)
}

string scalar _b_table::cititle()
{
	if (_citype == `ci_normal') {
		return("Normal")
	}
	if (_citype == `ci_logit') {
		return("Logit")
	}
	if (_citype == `ci_wilson') {
		return("Wilson")
	}
	if (_citype == `ci_exact') {
		return("Exact")
	}
	if (_citype == `ci_agresti') {
		return("Agresti-Coull")
	}
	if (_citype == `ci_jeffreys') {
		return("Jeffreys")
	}
	return("")
}

void _b_table::mclegend()
{
	real	scalar	whold
	real	vector	w
	real	vector	values
	string	vector	text
	string	scalar	ms_di
	string	scalar	first
	string	scalar	diopts
	real	scalar	i_term
	real	scalar	eq
	real	scalar	k
	real	scalar	i

	w	= J(1,2,0)
	w[2]	= 13
	w[1]	= _b_linesize() - sum(w) - 2
	whold = _width
	_width	= _find_min_width(w[1], _bmat, 0)
	w[1]	= _width + 1
	Tab.init(2)
	putTab.init(1)
	Tab.set_width(w)
	Tab.set_vbar((0,1,0))
	values	= J(1,2,.b)
	Tab.set_ignore(strofreal(values))
	text	= J(1,2,"")
	if (_mc_all) {
		text[1] = "%1s"
	}
	text[2]	= sprintf("%%%fs", w[2])
	Tab.set_format_title(text)
	Tab.set_format_string(text)
	text[1]	= ""
	text[2]	= ""
	Tab.set_format_number(text)
	putTab.set_cformats(text[2])
	Tab.set_lmargin(0)

	sep("top")
	text[1]	= ""
	text[2]	= "Number of"
	Tab.titles(text)
	putTab.add_ctitles("", text[2])
	text[2]	= "Comparisons"
	Tab.titles(text)
	putTab.add_ctitles("", text[2])

	if (_mc_all) {
		values[2] = info[1,3]
		text[1] = "All"
		text[2] = ""
		sep()
		Tab.row(values, text)
		putTab.add_row()
		putTab.add_rtitle(text[1])
		putTab.add_values(values[2])
	}
	else {
		ms_di	= sprintf("_ms_display, w(%f) mat(%s)", _width, _bmat)
		ms_di	= ms_di + " eq(#%f) el(%f) %s %s"

		first	= ""
		diopts	= "allbase joint nolevel vsquish"
		i_term	= 1
		Tab.set_skip1(1)
		for (eq=1; eq<=neq; eq++) {
			if (di_eqname(eq,_width)) {
				continue
			}

			k = term_index[eq_info[eq,2],2]
			for (i=1; i<=k; i++) {
				stata(sprintf(	ms_di,
						eq,
						info[i_term,2],
						first,
						diopts))
				values[2] = info[i_term,3]
				Tab.row(values)
				putTab.after_ms_display(first)
				putTab.add_values(values[2])
				i_term++
			}
		}
		Tab.set_skip1(.)
	}

	sep("bottom")

	printf("\n")
	_width = whold
}

void _b_table::init_table()
{
	real	vector	w
	string	vector	fmt
	string	scalar	n6
	string	scalar	n7
	real	scalar	p
		vector	T

	is_legend =	_type == `type_coeflegend' |
			_type == `type_selegend'
	is_cpg = 	_type == `type_ci' |
			_type == `type_df' |
			_type == `type_pv' |
			_type == `type_groups'
	is_dfcp = 	_type == `type_dfci' |
			_type == `type_dfpv'

	if (strlen(cformat) == 0) {
		cformat = "%9.0g"
	}
	else {
		if (fmtwidth(cformat) > 9) {
			cformat = "%9.0g"
			printf("{txt}note: invalid cformat(), using default\n")
		}
		p = strpos(cformat, ".")
		if (p == 0) {
			p = strpos(cformat, ",")
		}
		if (p) {
			if (bsubstr(cformat,1,2) == "%0") {
				cformat = "%09" + bsubstr(cformat, p, .)
			}
			else {
				cformat = "%9" + bsubstr(cformat, p, .)
			}
		}
	}

	if (strlen(sformat) == 0) {
		sformat = "%8.2f"
	}
	else {
		if (fmtwidth(sformat) > 8) {
			sformat = "%8.2f"
			printf("{txt}note: invalid sformat(), using default\n")
		}
		p = strpos(sformat, ".")
		if (p == 0) {
			p = strpos(sformat, ",")
		}
		if (p) {
			if (bsubstr(sformat,1,2) == "%0") {
				sformat = "%08" + bsubstr(sformat, p, .)
			}
			else {
				sformat = "%8" + bsubstr(sformat, p, .)
			}
		}
	}

	if (strlen(pformat) == 0) {
		pformat = "%5.3f"
	}
	else {
		if (fmtwidth(pformat) > 5) {
			pformat = "%5.3f"
			printf("{txt}note: invalid pformat(), using default\n")
		}
		p = strpos(pformat, ".")
		if (p == 0) {
			p = strpos(pformat, ",")
		}
		if (p) {
			if (bsubstr(pformat,1,2) == "%0") {
				pformat = "%05" + bsubstr(pformat, p, .)
			}
			else {
				pformat = "%5" + bsubstr(pformat, p, .)
			}
		}
	}

	if (strlen(rowcformat) == 0) {
		rowcformat = "%9.0g"
	}
	else {
		if (fmtwidth(rowcformat) > 9) {
			rowcformat = "%9.0g"
			printf("{txt}note: invalid rowcformat(), using default\n")
		}
		p = strpos(rowcformat, ".")
		if (p == 0) {
			p = strpos(rowcformat, ",")
		}
		if (p) {
			if (bsubstr(rowcformat,1,2) == "%0") {
				rowcformat = "%09" + bsubstr(rowcformat, p, .)
			}
			else {
				rowcformat = "%9" + bsubstr(rowcformat, p, .)
			}
		}
	}
	if (strlen(rowsformat) == 0) {
		rowsformat = "%8.2f"
	}
	else {
		if (fmtwidth(rowsformat) > 8) {
			rowsformat = "%8.2f"
			printf("{txt}note: invalid rowsformat(), using default\n")
		}
		p = strpos(rowsformat, ".")
		if (p == 0) {
			p = strpos(rowsformat, ",")
		}
		if (p) {
			if (bsubstr(rowsformat,1,2) == "%0") {
				rowsformat = "%08" + bsubstr(rowsformat, p, .)
			}
			else {
				rowsformat = "%8" + bsubstr(rowsformat, p, .)
			}
		}
	}

	if (strlen(rowpformat) == 0) {
		rowpformat = "%5.3f"
	}
	else {
		if (fmtwidth(rowpformat) > 7) {
			rowpformat = "%5.3f"
			printf("{txt}note: invalid rowpformat(), using default\n")
		}
		p = strpos(rowpformat, ".")
		if (p == 0) {
			p = strpos(rowpformat, ",")
		}
		if (p) {
			if (bsubstr(rowpformat,1,2) == "%0") {
				rowpformat = "%07" + bsubstr(rowpformat, p, .)
			}
			else {
				rowpformat = "%7" + bsubstr(rowpformat, p, .)
			}
		}
	}

	if (_type == `type_dftable' | _type == `type_df') {
		if (!is_mi) {
errprintf("dftable or dfonly settings require mi estimation results\n")
			exit(322)
		}
		if (_dfmat == "e(df_Q_mi)") {
			dfmis = st_numscalar("e(_dfnote_Q_mi)")
		}
		else {
			dfmis = st_numscalar("e(_dfnote_mi)")
		}
		if (length(dfmis) == 0) {
			dfmis = 0
		}
		if (_pisemat == "") {
			_pisemat = "e(pise_mi)"
		}
		pisemat	= st_matrix(_pisemat)
		n6 = "%9.1f"
		n7 = "%9.2f"
	}
	else if (is_dfcp) {
		n6 = "%9.1f"
	}
	else {
		n6 = cformat
		n7 = cformat
	}
	has_pisemat = length(pisemat)

	if (_sort) {
		real	scalar	i
		real	scalar	sub

		el_info	= st_matrixcolstripe_term_index(_bmat), bmat'
		neq	= rows(eq_info)
		sub	= J(2,2,1)
		order	= J(rows(el_info),1,.)
		for (i=1; i<=neq; i++) {
			sub[1,1] = eq_info[i,1]
			sub[2,1] = eq_info[i,2]
			order[|sub|] = order(
				panelsubmatrix(el_info,i,eq_info), (1..3))
		}
		el_info	= st_matrixcolstripe_term_index(_bmat)
	}

	if (_type == `type_ci') {
		// NOTE: search for _b_table::init_table()
		// in_prefix_display.ado to update the sumw macro if you
		// change the values in the 'w' vector
		w	= J(1,5,0)
		w[2]	= 11
		w[3]	= 11
		w[4]	= 14
		w[5]	= 12
		w[1]	= _b_linesize() - sum(w) - 2
		_width	= _find_min_width(w[1], _bmat, 1, extra_opts)
		w[1]	= _width + 1
		Tab.init(5)
		putTab.init(4)
		Tab.set_width(w)
		Tab.set_vbar((0,1,0,0,0,0))
		Tab.set_ignore(J(1,5,".b"))
		fmt	= J(1,5,"")
		fmt[2]	= sprintf("%%%fs", w[2])
		fmt[3]	= sprintf("%%%fs", w[3]+1)
		fmt[4]	= sprintf("%%%fs", w[4])
		fmt[5]	= sprintf("%%%fs", w[5])
		Tab.set_format_title(fmt)
		Tab.set_format_string(("","%11s","%1s","",""))
		Tab.set_format_number(("",cformat,cformat,cformat,cformat))
		putTab.set_cformats((cformat,cformat,cformat,cformat))
		rowmatnfmt = ("", J(1,4,rowcformat))
	}
	else if (_type == `type_dfci') {
		w	= J(1,6,0)
		w[2]	= 11
		w[3]	= 11
		w[4]	= 14
		w[5]	= 14
		w[6]	= 12
		w[1]	= _b_linesize() - sum(w) - 2
		_width	= _find_min_width(w[1], _bmat, 1, extra_opts)
		w[1]	= _width + 1
		Tab.init(6)
		putTab.init(5)
		Tab.set_width(w)
		Tab.set_vbar((0,1,0,0,0,0,0))
		Tab.set_ignore(J(1,6,".b"))
		fmt	= J(1,6,"")
		fmt[2]	= sprintf("%%%fs", w[2])
		fmt[3]	= sprintf("%%%fs", w[3]+1)
		fmt[4]	= sprintf("%%%fs", w[4])
		fmt[5]	= sprintf("%%%fs", w[5])
		fmt[6]	= sprintf("%%%fs", w[6])
		Tab.set_format_title(fmt)
		Tab.set_format_string(("","%11s","%1s","","",""))
		Tab.set_format_number(("",cformat,cformat,n6,cformat,cformat))
		putTab.set_cformats((cformat,cformat,n6,cformat,cformat))
		rowmatnfmt = ("", J(1,2,rowcformat), n6, J(1,2,rowcformat))
	}
	else if (_type == `type_df') {
		w	= J(1,5,0)
		w[2]	= 11
		w[3]	= 11
		w[4]	= 14
		w[5]	= 12
		w[1]	= _b_linesize() - sum(w) - 2
		_width	= _find_min_width(w[1], _bmat, 1, extra_opts)
		w[1]	= _width + 1
		Tab.init(5)
		putTab.init(4)
		Tab.set_width(w)
		Tab.set_vbar((0,1,0,0,0,0))
		Tab.set_ignore(J(1,5,".b"))
		fmt	= J(1,5,"")
		fmt[2]	= sprintf("%%%fs", w[2])
		fmt[3]	= sprintf("%%%fs", w[3]+1)
		fmt[4]	= sprintf("%%%fs", w[4])
		fmt[5]	= sprintf("%%%fs", w[5])
		Tab.set_format_title(fmt)
		Tab.set_format_string(("","%11s","%1s","",""))
		Tab.set_format_number(("",cformat,cformat,n6,n7))
		putTab.set_cformats((cformat,cformat,n6,n7))
		rowmatnfmt = ("", J(1,4,rowcformat))
	}
	else if (_type == `type_pv') {
		w	= J(1,5,0)
		w[2]	= 11
		w[3]	= 11
		w[4]	= 9
		w[5]	= 8
		w[1]	= _b_linesize() - sum(w) - 2
		_width	= _find_min_width(w[1], _bmat, 1, extra_opts)
		w[1]	= _width + 1
		Tab.init(5)
		putTab.init(4)
		Tab.set_width(w)
		Tab.set_vbar((0,1,0,0,0,0))
		Tab.set_ignore(J(1,5,".b"))
		fmt	= J(1,5,"")
		fmt[2]	= sprintf("%%%fs", w[2])
		fmt[3]	= sprintf("%%%fs", w[3]+1)
		fmt[4]	= "%7s"
		fmt[5]	= sprintf("%%%fs", w[5])
		Tab.set_format_title(fmt)
		Tab.set_format_string(("","%11s","%1s","",""))
		Tab.set_format_number(("",cformat,cformat,sformat,pformat))
		putTab.set_cformats((cformat,cformat,sformat,pformat))
		rowmatnfmt = ("", J(1,2,rowcformat), rowsformat, rowpformat)
	}
	else if (_type == `type_dfpv') {
		w	= J(1,6,0)
		w[2]	= 11
		w[3]	= 11
		w[4]	= 14
		w[5]	= 9
		w[6]	= 8
		w[1]	= _b_linesize() - sum(w) - 2
		_width	= _find_min_width(w[1], _bmat, 1, extra_opts)
		w[1]	= _width + 1
		Tab.init(6)
		putTab.init(5)
		Tab.set_width(w)
		Tab.set_vbar((0,1,0,0,0,0,0))
		Tab.set_ignore(J(1,6,".b"))
		fmt	= J(1,6,"")
		fmt[2]	= sprintf("%%%fs", w[2])
		fmt[3]	= sprintf("%%%fs", w[3]+1)
		fmt[4]	= sprintf("%%%fs", w[4]-1)
		fmt[5]	= sprintf("%%%fs", w[5]-1)
		fmt[6]	= sprintf("%%%fs", w[6])
		Tab.set_format_title(fmt)
		Tab.set_format_string(("","%11s","%1s","","",""))
		Tab.set_format_number(("",J(1,2,cformat),n6,sformat,pformat))
		putTab.set_cformats((J(1,2,cformat),n6,sformat,pformat))
		rowmatnfmt = ("", J(1,2,rowcformat), n6, rowsformat, rowpformat)
	}
	else if (_type == `type_groups') {
		if (!do_groups) {
			return
		}
		w	= J(1,5,0)
		w[2]	= 11
		w[3]	= 11
		w[4]	= 3
		w[5]	= max(strlen(groups))
		w[1]	= max((7, strlen(mctitle)))
		if (w[5] < w[1]) {
			w[5] = w[1]
		}
		w[1]	= 0
		w[1]	= _b_linesize() - sum(w) - 2
		if (w[1] < 12) {
			groups	= subinstr(groups, " ", "")
			w[5]	= max(strlen(groups))
			w[1]	= max((7, strlen(mctitle)))
			if (w[5] < w[1]) {
				w[5] = w[1]
			}
			w[1]	= 0
			w[1]	= _b_linesize() - sum(w) - 2
		}
		_width	= _find_min_width(w[1], _bmat, 1, extra_opts)
		w[1]	= _width + 1
		Tab.init(5)
		putTab.init(4)
		Tab.set_width(w)
		Tab.set_vbar((0,1,0,0,0,0))
		Tab.set_ignore(J(1,5,".b"))
		fmt	= J(1,5,"")
		fmt[2]	= sprintf("%%%fs", w[2])
		fmt[3]	= sprintf("%%%fs", w[3]+1)
		fmt[5]	= sprintf("%%%fs", w[5])
		Tab.set_format_title(fmt)
		fmt[3]	= "%1s"
		Tab.set_format_string(fmt)
		Tab.set_format_number(("",cformat,cformat,"",""))
		putTab.set_cformats((cformat,cformat,"",""))
	}
	else {
		Tab.init(7)
		putTab.init(6)
		w = J(1,7,0)
		w[2] = 11
		w[3] = 11
		w[4] = 9
		w[5] = 8
		w[6] = 13
		w[7] = 12
		w[1]	= _b_linesize() - sum(w) - 2
		_width	= _find_min_width(w[1], _bmat, 1, extra_opts)
		w[1]	= _width + 1
		Tab.set_width(w)
		Tab.set_vbar((0,1,0,0,0,0,0,0))
		Tab.set_ignore(J(1,7,".b"))
		fmt	= J(1,7,"")
		fmt[1]	= sprintf("%%%fs", w[1]-1)
		fmt[2]	= "%11s"
		fmt[3]	= "%12s"
		fmt[4]	= "%7s"
		fmt[5]	= "%8s"
		fmt[6]	= "%13s"
		fmt[7]	= "%12s"
		Tab.set_format_title(fmt)
		Tab.set_format_string(("","%11s","%1s","","","",""))
		Tab.set_format_number(
			("",cformat,cformat,sformat,pformat,n6,n7))
		putTab.set_cformats((cformat,cformat,sformat,pformat,n6,n7))
		rowmatnfmt = ("", J(1,2,rowcformat), rowsformat, rowpformat,
				J(1,2,rowcformat))
	}
	Tab.set_lmargin(0)
	_indent = 0
	_is_var = 0

	putTab.set_legend(is_legend)

	_ms_di = sprintf("_ms_display, mat(%s)", _bmat)
	_ms_di = _ms_di + " indent(%f) w(%f) eq(#%f) el(%f) %s %s %s"
	if (_markdown) {
		p = cols(w) - 1
		T = Tab.set_width()
		_ms_di = sprintf("%s  markdown nextra(%f)", _ms_di, p)
		T = Tab.set_vbar()
		T = J(1,cols(T), 1)
		T[1] = 0
		Tab.set_vbar(T)
		Tab.set_markdown("on")
	}

	_eq_di = sprintf("_ms_eq_display, aux width(%f) mat(%s)", _width, _bmat)
	_eq_di = _eq_di + " eq(%f)"
}

void _b_table::cluster()
{
	string	scalar	msg
	string	scalar	clustvar
	real	scalar	reps
	string	scalar	nclust
	string	scalar	cmd
	string	scalar	buf

	if (_cmdextras) {
		cmd = _cmd
	}
	if (_bmat == "e(b)") {
		cmd = st_global("e(cmd)")
	}
	if (is_mi) {
		msg	= "Within VCE adjusted for"
		reps	= 0
		nclust	= "e(N_clust_mi)"
		cmd	= st_global("e(cmd_mi)")
	}
	else if (anyof(tokens("`vcerep'"), st_global("e(prefix)"))) {
		msg	= "Replications based on"
		reps	= 1
		nclust	= "e(N_clust)"
	}
	else {
		msg	= "Std. Err. adjusted for"
		reps	= 0
		nclust	= "e(N_clust)"
	}
	clustvar = st_global("e(clustvar)")
	if (strlen(clustvar) == 0 & (reps | st_global("e(vce)") == "robust")) {
		if (bsubstr(cmd,1,2) == "xt") {
			stata(sprintf("is_xt %s", cmd))
			if (st_numscalar("r(is_xt)")) {
				clustvar = st_global("e(ivar)")
			}
		}
		else if (anyof(tokens("clogit rologit"), cmd)) {
			clustvar = st_global("e(group)")
		}
		else if (anyof(tokens("`ascmds'"), cmd)) {
			clustvar = st_global("e(case)")
		}
	}
	if (strlen(clustvar)) {
		displayas("txt")
		if (length(st_numscalar(nclust))) {
			buf = sprintf("%18.0gc", st_numscalar(nclust))
			printf("{ralign %f:(%s {res:%s} clusters in %s)}\n",
				Tab.width_of_table(),
				msg,
				strtrim(buf),
				clustvar)
		}
		else {
			printf("{ralign %f:(%s clustering on %s)}\n",
				Tab.width_of_table(),
				msg,
				clustvar)
		}
	}
}

void _b_table::titles()
{
	real	scalar	dfpos
	string	scalar	dv
	string	vector	op
	string	scalar	vce
	string	scalar	mse
	string	scalar	vcettl
	string	scalar	vcettl_str
	real	scalar	vcewd
	string	scalar	vcefmt
	string	scalar	ttl2
	string	scalar	ttl4
	string	scalar	ttl5
	string	scalar	ttl6
	string	scalar	ttl7
	string	scalar	ttl4_str
	string	scalar	ttl5_str
	string	scalar	ttl6_str
	string	scalar	ttl7_str
	real	scalar	span4
	real	scalar	span5
	real	scalar	span6
	real	scalar	span7
	string	scalar	fmt5
	string	scalar	fmt7
	real	scalar	wd
	string	scalar	name
	string	scalar	stat
	real	scalar	p
	real	scalar	plus
	real	scalar	n, i
	real	scalar	rc
	string	vector	text
	real	scalar	has_super_ttl
	real	scalar	showcns
	string	scalar	pval_string
		vector	hold
		vector	fhold

	if (_markdown) {
		printf("\n")
	}

	if (is_cpg) {
		text = J(1,5,"")
	}
	else if (is_dfcp) {
		text = J(1,6,"")
	}
	else {
		text = J(1,7,"")
	}

	if (has_vmat == 0) {
		mctitle = ""
	}

	if (strlen(_pttl) == 0) {
		_pttl = mctitle
	}
	if (strlen(_cittl) == 0) {
		_cittl = mctitle
	}

	if (strlen(_depname) == 0) {
		dv = st_global("e(depvar)")
	}
	else {
		dv = _depname
	}
	if (cols(tokens(dv)) > 1) {
		if (is_me) {
			if (!anyof((_cmd, _cmd2), "meintreg")) {
				is_me = 0
			}
		}
		dv = ""
	}
	if (strlen(dv)) {
		stata(sprintf("_msparse %s, ivar", dv))
		dv = st_global("r(stripe)")
		p  = strpos(dv, ".")
		if (p & udstrlen(dv) > _width) {
			op = J(1,0,"")
			_b_compute_multi_line_tsop(op, dv, p, _width)
		}
		else {
			dv = abbrev(dv, _width)
		}
	}

	if (_cmd == "proportion") {
		if (strlen(_cittl) == 0) {
			_cittl = ttl7_str = ttl7 = cititle()
		}
	}

	if (!is_mi & has_vmat) {
		vcettl_str = vcettl = st_global("e(vcetype)")
		vce	= st_global("e(vce)")
	}

	if (_type == `type_selegend') {
		_coefttl[1] = "Std. Err."
	}
	else if (strlen(_coefttl[1]) == 0) {
		_coefttl[1] = "Coef."
	}

	if (vce == "bootstrap") {
		if (strlen(_coefttl[2]) == 0) {
			if (_type != `type_selegend') {
				_coefttl[2] = "Observed"
			}
			else {
				_coefttl[2] = vcettl
			}
		}
		if (vcettl == "Bootstrap") {
			if (strlen(_cittl) == 0 & has_cimat == 0) {
				_cittl = "Normal-based"
			}
		}
	}

	if (is_legend) {
		has_super_ttl = strlen(_coefttl[2])
		vcettl = ""
		_cittl = ""
	}
	if (_type == `type_beta') {
		has_super_ttl = strlen(_coefttl[2]) | strlen(vcettl) 
		_pttl = ""
		_cittl = ""
	}
	if (_type == `type_groups') {
		has_super_ttl = strlen(_coefttl[2]) |
				strlen(vcettl) |
				strlen(mctitle)
		_pttl = ""
		_cittl = ""
	}
	else {
		has_super_ttl = strlen(_coefttl[2]) |
				strlen(vcettl) |
				strlen(_pttl) |
				strlen(_cittl)
	}

	showcns = bsubstr(_cnsreport,1,2) != "no"
	if (showcns) {
		if (cols(bmat) > c("max_matdim")) {
			showcns = 0
		}
	}
	if (showcns) {
		stata(sprintf("_makecns, displaycns nullok %s", _cnsreport))
	}

	if (_clreport) {
		cluster()
	}

	sep("top")
	n = length(op)
	if (n) {
		hold = Tab.set_format_title()
		text[1] = sprintf("%%-%fs", _width)
		Tab.set_format_title(text)
		for (i=1; i<n; i++) {
			text[1] = op[1]
			Tab.titles(text)
		}
		if (has_super_ttl) {
			op = op[n]
		}
		else {
			text[1] = op[n]
			Tab.titles(text)
			op = ""
		}
		text[1] = ""
		Tab.reset_format_title(hold)
	}
	else {
		op = ""
	}

	span4 = 1
	span5 = 1
	span6 = 1
	span7 = 1
	if (_type == `type_dftable' | _type == `type_df' | has_super_ttl) {
		mse	= st_global("e(mse)")
		ttl2	= ""
		ttl4_str = ttl4	= ""
		ttl5_str = ttl5	= ""
		ttl6_str = ttl6	= ""
		ttl7_str = ttl7	= ""
		fmt5	= ""
		fmt7	= ""
		if (_type == `type_dftable' | _type == `type_df') {
			ttl7_str = ttl7 = "% Increase"
			fmt7 = "%12s"
		}
		else if (_type == `type_dflt' |
			 _type == `type_ci' |
			 _type == `type_dfci') {
			if (vce == "bootstrap") {
				ttl2 = "Observed"
				if (vcettl == "Bootstrap") {
				    if (strlen(_cittl) == 0 & has_cimat == 0) {
					ttl7_str = ttl7 = "Normal-based"
				    }
				    else {
						ttl7_str = ttl7 = _cittl
				    }
				}
			}
		}
		if (_type == `type_groups') {
			ttl7_str = ttl7 = mctitle
		}
		if (strlen(_coefttl[2])) {
			ttl2 = _coefttl[2]
		}
		vcewd	= strlen(vcettl)
		vcefmt	= ""
		if (vcewd & strlen(mse)) {
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
				plus = strlen(vcettl) + ceil((12 - vcewd)/2+1)
				vcefmt = sprintf("%%%fs", plus)
			}
			stata("capture")
		}
		if (vcewd & vcefmt == "") {
			vcewd	= vcewd + ceil((12 - vcewd)/2+1)
			vcefmt	= sprintf("%%%fs", vcewd)
		}
		if (strlen(_pttl)) {
			ttl5_str = ttl5 = _pttl
		}
		if (strlen(_cittl)) {
			ttl7_str = ttl7 = _cittl
		}
		if (_type != `type_dftable' & _type != `type_groups' &
		    _type != `type_df') {
			wd = strlen(ttl5)
			if (wd > 2) {
				wd = ceil((wd-2)/2) - 1
				swap(ttl4_str, ttl5_str)
				span4 = 2
				span5 = 0
				ttl4 = substr(ttl5, 1, wd)
				ttl5 = substr(ttl5, wd+1, .)
			}
			fmt5 = "%1s"
			wd = strlen(ttl7)
			if (wd > 2) {
				swap(ttl6_str, ttl7_str)
				span6 = 2
				span7 = 0
				wd = ceil((wd-2)/2) - 1
				ttl6 = substr(ttl7, 1, wd)
				ttl7 = substr(ttl7, wd+1, .)
			}
			fmt7 = "%1s"
		}
		hold	= Tab.set_format_title()
		fhold	= Tab.set_width()
		text[1] = sprintf("%%-%fs", _width)
		text[3] = vcefmt
		if (_type == `type_ci') {
			if (vcewd > fhold[3]) {
				plus = fhold[4] - (vcewd - fhold[3])
				text[4] = sprintf("%%%fs", plus)
			}
			text[5] = fmt7
			Tab.set_format_title(text)
			text[4] = ""
			text[5] = ""
			Tab.titles((op, ttl2, vcettl, ttl6, ttl7))
			putTab.add_ctitles(
				op,
				(ttl2, vcettl_str, ttl6_str, ttl7_str),
				(1,1,span6,span7))
		}
		else if (_type == `type_dfci') {
			if (vcewd > fhold[3]) {
				plus = fhold[4] - (vcewd - fhold[3])
				text[4] = sprintf("%%%fs", plus)
			}
			text[6] = fmt7
			Tab.set_format_title(text)
			text[4] = ""
			text[6] = ""
			Tab.titles((op, ttl2, vcettl, "", ttl6, ttl7))
			putTab.add_ctitles(
				op,
				(ttl2, vcettl_str, "", ttl6_str, ttl7_str),
				(1,1,1,span6,span7))
		}
		else if (_type == `type_df') {
			if (vcewd > fhold[3]) {
				plus = fhold[4] - (vcewd - fhold[3])
				text[4] = sprintf("%%%fs", plus)
			}
			text[5] = fmt7
			Tab.set_format_title(text)
			text[4] = ""
			text[5] = ""
			Tab.titles((op, ttl2, vcettl, ttl6, ttl7))
			putTab.add_ctitles(
				op,
				(ttl2, vcettl_str, ttl6_str, ttl7_str),
				(1,1,span6,span7))
		}
		else if (_type == `type_pv') {
			if (vcewd > fhold[3]) {
				plus = fhold[4] - (vcewd - fhold[3])
				text[4] = sprintf("%%%fs", plus)
			}
			else {
				text[4] = sprintf("%%%fs", fhold[4])
			}
			text[5] = fmt5
			Tab.set_format_title(text)
			text[4] = ""
			text[5] = ""
			Tab.titles((op, ttl2, vcettl, ttl4, ttl5))
			putTab.add_ctitles(
				op,
				(ttl2, vcettl_str, ttl4_str, ttl5_str),
				(1,1,span4,span5))
		}
		else if (_type == `type_dfpv') {
			if (vcewd > fhold[3]) {
				plus = fhold[5] - (vcewd - fhold[4])
				text[5] = sprintf("%%%fs", plus)
			}
			else {
				text[5] = sprintf("%%%fs", fhold[5])
			}
			text[6] = fmt5
			Tab.set_format_title(text)
			text[4] = ""
			text[6] = ""
			Tab.titles((op, ttl2, vcettl, "", ttl4, ttl5))
			putTab.add_ctitles(
				op,
				(ttl2, vcettl_str, "", ttl4_str, ttl5_str),
				(1,1,1,span4,span5))
		}
		else if (_type == `type_groups') {
			Tab.set_format_title(text)
			Tab.titles((op, ttl2, vcettl, "", ttl7))
			putTab.add_ctitles(
				op,
				(ttl2, vcettl_str, "", ttl7_str),
				(1,1,1,span7))
		}
		else {
			if (vcewd > fhold[3]) {
				plus = fhold[4] - (vcewd - fhold[3])
				text[4] = sprintf("%%%fs", plus)
			}
			else {
				text[4] = sprintf("%%%fs", fhold[4])
			}
			text[5] = fmt5
			text[7] = fmt7
			Tab.set_format_title(text)
			text[4] = ""
			text[5] = ""
			text[7] = ""
			Tab.titles((op, ttl2, vcettl, ttl4, ttl5, ttl6, ttl7))
			putTab.add_ctitles(
				op,
				(ttl2, vcettl_str, ttl4_str, ttl5_str, ttl6_str, ttl7_str),
				(1,1,span4,span5,span6,span7))
		}
		Tab.reset_format_title(hold)
		text[1] = ""
		text[3] = ""
		fhold = J(1,0,.)
	}
	if (_markdown) {
		text[1] = "%-1s"
		Tab.set_format_title(text)
	}
	if (is_legend) {
		text[3] = "%8s"
		Tab.set_format_title(text)
		text[1] = dv
		text[2] = _coefttl[1]
		text[3] = "Legend"
		Tab.titles(text)
		putTab.add_ctitles(dv, text[|2\.|])
		text[1] = ""
		text[2] = ""
		text[3] = ""
	}
	else if (has_vmat) {
		ttl6_str = ttl6	= ""
		ttl7_str = ttl7	= ""
		if (is_mi) {
			stat = "t"
		}
		else if (has_dfmat) {
			stat = "t"
		}
		else {
			stat	= missing(_df) ? "z" : "t"
		}
		if (_markdown) {
			pval_string = sprintf("P>\\|%s\\|", stat)
		}
		else {
			pval_string = sprintf("P>|%s|", stat)
		}
		if (_type == `type_dftable' | _type == `type_df') {
			if (_type == `type_dftable') dfpos = 6
			else dfpos = 4
			ttl6_str = "DF"
			if (dfmis) {
				ttl6	= "{help mi_missingdf##|_new:DF}"
				fhold	= Tab.set_format_title()
				plus	= fmtwidth(fhold[dfpos])+strlen(ttl6)-2
				text[dfpos] = sprintf("%%%fs", plus)
				Tab.set_format_title(text)
				text[dfpos] = ""
			}
			else {
				ttl6	= "DF"
			}
			ttl7_str = ttl7	= "Std. Err."
		}
		else if (_type == `type_beta') {
			ttl6	= ""
			if (_cmd == "sem") {
				ttl7_str = ttl7	= "Std. Coef."
			}
			else {
				ttl7_str = ttl7	= "Beta"
			}
		}
		else if (_type == `type_groups') {
			ttl6	= ""
			ttl7	= ""
		}
		else if (_markdown) {
			ttl6_str = sprintf("[%g%% Conf. Interval]", _level) 
			ttl7_str = ""
			span6	= 2
			span7	= 0
			ttl6	= sprintf("[%g%% Conf. Interval]", _level) 
			ttl7	= ""
		}
		else {
			ttl6_str = sprintf("[%g%% Conf. Interval]", _level) 
			ttl7_str = ""
			span6	= 2
			span7	= 0
			ttl6	= sprintf("[%g%% Con", _level) 
			ttl7	= "f. Interval]"
		}
		hold	= Tab.set_width()
		if (_type == `type_ci') {
			if (_markdown) {
				Tab.set_width(hold + (0,0,1,hold[5]-1,-hold[5]))
			}
			else {
				Tab.set_width(hold + (0,0,1,-1,0))
			}
			fhold	= Tab.set_format_title()
			plus	= fmtwidth(fhold[4]) - 1
			text[4] = sprintf("%%%fs", plus)
			Tab.set_format_title(text)
			text[4] = ""
			Tab.titles((	dv,
					_coefttl[1],
					"Std. Err.",
					ttl6,
					ttl7))
			putTab.add_ctitles(
				dv,
				(_coefttl[1], "Std. Err.", ttl6_str, ttl7_str),
				(1,1,span6,span7))
		}
		else if (_type == `type_dfci') {
			if (_markdown) {
				Tab.set_width(hold + (0,0,1,-1,hold[6],-hold[6]))
			}
			else {
				Tab.set_width(hold + (0,0,1,-1,0,0))
			}
			fhold	= Tab.set_format_title()
			plus	= fmtwidth(fhold[4]) - 1
			text[4] = sprintf("%%%fs", plus)
			Tab.set_format_title(text)
			text[4] = ""
			Tab.titles((	dv,
					_coefttl[1],
					"Std. Err.",
					"DF",
					ttl6,
					ttl7))
			putTab.add_ctitles(
				dv,
				(_coefttl[1], "Std. Err.", "DF", ttl6_str, ttl7_str),
				(1,1,1,span6,span7))
		}
		else if (_type == `type_df') {
			Tab.set_width(hold + (0,0,1,-1,0))
			fhold	= Tab.set_format_title()
			plus	= fmtwidth(fhold[4]) - 1
			text[4] = sprintf("%%%fs", plus)
			Tab.set_format_title(text)
			text[4] = ""
			Tab.titles((	dv,
					_coefttl[1],
					"Std. Err.",
					ttl6,
					ttl7))
			putTab.add_ctitles(
				dv,
				(_coefttl[1], "Std. Err.", ttl6_str, ttl7_str),
				(1,1,span6,span7))
		}
		else if (_type == `type_pv') {
			Tab.set_width(hold + (0,0,1,-1,0))
			Tab.titles((	dv,
					_coefttl[1],
					"Std. Err.",
					stat,
					pval_string))
			putTab.add_ctitles(dv, (
					_coefttl[1],
					"Std. Err.",
					stat,
					pval_string))
		}
		else if (_type == `type_dfpv') {
			Tab.set_width(hold + (0,0,1,-1,0,0))
			Tab.titles((	dv,
					_coefttl[1],
					"Std. Err.",
					"DF",
					stat,
					pval_string))
			putTab.add_ctitles(dv, (
					_coefttl[1],
					"Std. Err.",
					"DF",
					stat,
					pval_string))
		}
		else if (_type == `type_groups') {
			Tab.set_width(hold + (0,0,1,-1,0))
			Tab.titles((	dv,
					_coefttl[1],
					"Std. Err.",
					"",
					"Groups"))
			putTab.add_ctitles(dv, (
					_coefttl[1],
					"Std. Err.",
					"",
					"Groups"))
		}
		else {
			if (_markdown) {
				Tab.set_width(hold + (0,0,0,0,0,hold[7],-hold[7]))
			}
			else {
				Tab.set_width(hold + (0,0,1,-1,0,0,0))
			}
			Tab.titles((	dv,
					_coefttl[1],
					"Std. Err.",
					stat,
					pval_string,
					ttl6,
					ttl7))
			putTab.add_ctitles(dv, (
					_coefttl[1],
					"Std. Err.",
					stat,
					pval_string,
					ttl6_str,
					ttl7_str),
				(1,1,1,1,span6,span7))
		}
		Tab.set_width(hold)
		if (length(fhold)) {
			Tab.reset_format_title(fhold)
		}
	}
	else {
		text[1] = dv
		text[2] = _coefttl[1]
		Tab.titles(text)
		putTab.add_ctitles(dv, text[|2\.|])
		text[1] = ""
		text[2] = ""
	}
	if (_markdown) {
		// This is the explicit separator line between headers
		// and table content.

		Tab.sep()
	}
}

void _b_table::comment(	string	scalar	id,
			real	scalar	value,
			string	scalar	comment,
			real	scalar	header,
			|real	scalar	vbar)
{
	real	vector	values
	string	vector	text
	real	scalar	len
	string	vector	split
	real	scalar	k, i
	real	vector	slen
		vector	chold
		vector	fhold
		vector	vhold

	chold	= Tab.set_color_string()
	fhold	= Tab.set_format_string()
	values	= J(1,cols(chold),.b)
	text	= J(1,cols(chold),"")
	if (header) {
		text[1] = sprintf("%%-%fs", _width)
	}
	text[2] = "%1s"
	Tab.set_format_string(text)
	text[2] = ""
	if (header == 1 || header == 3) {
		text[1] = "result"
		Tab.set_color_string(text)
	}
	if (vbar == 0) {
		vhold = Tab.set_vbar()
		Tab.set_vbar(0:*vhold)
		text[1] = id
	}
	else {
		if (header == 3) {
			len = strlen(id)
			k = 1
			if (len > _width) {
				split = tokens(id, ">")
				k = cols(split)
			}
			if (k > 1) {
				slen = strlen(split)
				text[1]	= ""
				for (i=1; i<k;) {
					text[1] = sprintf("%s>",
						abbrev(split[i],_width))
					len = _width - strlen(text[1])
					i = i + 2
					for (; i<k;) {
						if (slen[i] >= len) {
					    		break
						}
						text[1] = sprintf("%s%s>",
								text[1],
								split[i])
						len = len - slen[i] - 1
						i = i + 2
					}
					Tab.row(values, text)
					putTab.add_row()
					putTab.add_rtitle(text[1])
				}
				text[1] = abbrev(split[k], _width)
			}
			else {
				text[1] = abbrev(id, _width)
			}
		}
		else if (header == 4) {
			stata(sprintf("_ms_parse_parts %s", id))
			if (st_global("r(type)") == "factor") {
				text[1] = abbrev(st_global("r(name)"), _width)
				Tab.row(values, text)
				putTab.add_row()
				putTab.add_rtitle(text[1])
				text[1] = sprintf(" %f",
						st_numscalar("r(level)"))
			}
			else {
				text[1] = abbrev(id, _width)
			}
		}
		else {
			text[1] = abbrev(id, _width)
		}
		if (value == .b) {
			text[2] = comment
		}
		else {
			values[2] = value
			text[3] = comment
		}
	}
	Tab.row(values, text)
	putTab.add_row()
	putTab.add_values(values[|2\.|])
	putTab.add_note(comment)
	putTab.add_rtitle(text[1])
	if (header) {
		putTab.add_ralign("left")
	}

	Tab.reset_color_string(chold)
	Tab.reset_format_string(fhold)
	if (vbar == 0) {
		Tab.set_vbar(vhold)
	}
}

void _b_table::di_comment(	string	vector	idlist,
				string	scalar	comment)
{
	real	scalar	k
	real	scalar	i

	k = length(idlist)
	if (k==1 & strlen(idlist) == 0) {
		comment("", .b, comment, 1)
	}
	else {
		if (k == 1) {
			comment(idlist[1], .b, comment, 1)
		}
		else {
			comment(idlist[1], .b, "", 0)
		}
		for (i=2; i<=k; i++) {
			comment(idlist[i], .b, comment, 0)
		}
	}
}

real scalar _b_table::di_eqname(real	scalar	eq,
				real	scalar	width,
				|string	scalar	comment,
				real	scalar	dosep)
{
	real	scalar	ec
	real	scalar	not_fp

	eqSpec = ""
	if (eq < 1 | eq > rows(eq_info)) {
		exit(error(303))
	}

	eqSpec	= stripe[eq_info[eq,1],1]
	if (strlen(comment)) {
		if (dosep) {
			sep()
		}
		di_comment(eqSpec, comment)
		return(1)
	}

	ec = _stata(sprintf("_ms_parse_parts %s", eqSpec), 1)
	if (ec == 0) {
	    if (	st_numscalar("r(omit)") &
	    		st_global("r(type)") != "interaction") {
		if (length(st_numscalar("r(base)"))) {
			if (st_numscalar("r(base)")) {
				eqSpec = sprintf("%f%s.%s",
					st_numscalar("r(level)"),
					st_global("r(ts_op)"),
					st_global("r(name)"))
				comment	= "  (base outcome)"
			}
		}
		else if (!strpos(_diopts, "noomitted")) {
			eqSpec = st_global("r(ts_op)")
			if (strlen(eqSpec)) {
				eqSpec = sprintf("%s.%s",
					eqSpec,
					st_global("r(name)"))
			}
			else {
				eqSpec = st_global("r(name)")
			}
			comment = "(omitted)"
		}
		else {
			return(1)
		}
		if (strlen(comment)) {
			if (dosep) {
				sep()
			}
			di_comment(eqSpec, comment)
			return(1)
		}
	    }
	}

	if (eqSpec == "/_") {
		eqSpec = "/"
	}
	not_fp = substr(eqSpec,1,1) != "/"
	if (eqSpec == "_") {
		eqSpec = ""
	}
	else if (_eq_hide == 1) {
		if (not_fp | _neq == 1) {
			eqSpec = ""
		}
	}
	else if (eq == 1 & _eq_hide_first == 1) {
		if (not_fp) {
			eqSpec = ""
		}
	}

	if (dosep) {
		sep()
	}
	if (eqSpec != "" & (eqSpec != "/" | k_fp == 0)) {
		stata(sprintf(	"_ms_eq_display, w(%f) eq(%f) mat(%s)",
				width,
				eq,
				_bmat))
		if (st_numscalar("r(output)") == 1) {
			printf("\n")
			eqSpec = st_global("r(eq)")
			putTab.after_ms_eq_display("eq")
		}
	}
	return(0)
}

void _b_table::di_offset(string scalar offset)
{
	real	scalar	len
	string	scalar	name
	string	scalar	type
	real	vector	values
	string	vector	text
		vector	fhold

	if (cols(_eqselect)) {
		return
	}
	len	= strlen(offset)
	if (len == 0) {
		return
	}
	if (bsubstr(offset,1,3) == "ln(") {
		name = bsubstr(offset,4,len-4)
		if (strlen(offset) > _width) {
			name = abbrev(name, _width-4)
		}
		name = "ln(" + name + ")"
		type = "  (exposure)"
	}
	else {
		name = offset
		type = "  (offset)"
	}

	if (is_cpg) {
		values	= J(1,5,.b)
		text	= J(1,5,"")
	}
	else if (is_dfcp == 2) {
		values	= J(1,6,.b)
		text	= J(1,6,"")
	}
	else {
		values	= J(1,7,.b)
		text	= J(1,7,"")
	}
	fhold	= Tab.set_format_string()
	text[3] = "%1s"
	Tab.set_format_string(text)
	text[1]		= name
	values[2]	= 1
	text[3]		= type
	Tab.row(values, text)
	Tab.reset_format_string(fhold)
	putTab.add_row()
	putTab.add_rtitle(name)
	putTab.add_note(type)
	putTab.add_values(values[|2\.|])
}

void _b_table::di_eq_el(real	scalar	eq,
			real	scalar	el,
			real	scalar	oldterm,
			string	scalar	first,
			real	scalar	output,
			string	scalar	diopts)
{
	real	scalar	rc
	real	scalar	pos
	real	scalar	term
	real	scalar	j
	string	scalar	nameopt

	nameopt = ""
	elSpec = ""
	if (_sort) {
		nameopt = "noname"
		pos = sub_order[el]
		term = sub_el_info[pos,2]
		if (term != oldterm) {
			rc = _stata(sprintf(	_ms_di,
						_indent,
						_width,
						eq,
						el,
						first,
						diopts,
						"nolev"))
			if (rc) exit(rc)
			elSpec = st_global("r(term)")
			oldterm = term
			if (st_numscalar("r(output)")) {
				if (st_numscalar("r(k)")) {
					printf("\n")
				}
				putTab.after_ms_display(first)
				first = ""
			}
			else {
				first = "first"
				return
			}
		}
	}
	else {
		pos = el
	}

	j = eq_info[eq,1] + el - 1
	if (_cmd != "sem") {
	    if (pclassmat[j] == PC.value("ignore")) {
		rc = _stata(sprintf(	_ms_di,
					_indent,
					_width,
					eq,
					pos,
					first,
					diopts,
					(strlen(first) ? "" : nameopt)), 1)
		if (rc) exit(rc)
		if (st_numscalar("r(first)")) {
			first = "first"
		}
		return
	    }
	}

	rc = _stata(sprintf(	_ms_di,
				_indent,
				_width,
				eq,
				pos,
				first,
				diopts,
				(strlen(first) ? "" : nameopt)))
	if (rc) exit(rc)
	elSpec = st_global("r(term)")
	if (st_numscalar("r(output)")) {
		putTab.after_ms_display(first)
		first = ""
		if (!output) {
			output = 1
			diopts = _diopts
		}
	}
	else {
		if (st_numscalar("r(first)")) {
			first = "first"
		}
		return
	}

	di_eq_el_u(eq,pos)
}

void _b_table::di_eq_el_u(	real	scalar	eq,
				real	scalar	el)
{
	real	scalar	j
	real	scalar	b
	real	scalar	beta
	real	scalar	stderr
	real	scalar	ll
	real	scalar	ul
	string	scalar	note
	string	scalar	name
	string	scalar	exp
	string	vector	text
	real	vector	values
	real	scalar	reset_nfmt
	string	vector	mystripe
		vector	nhold
		vector	nfmt

	j = eq_info[eq,1] + el - 1

	if (_is_var) {
		stat[j] = .b
		pvalue[j] = .b
	}

	b	= bmat[j]
	if (has_vmat) {
		stderr	= se[j]
		if (!is_groups) {
			ll	= ci[1,j]
			ul	= ci[2,j]
		}
	}
	note	= label[j]

	reset_nfmt = 0
	if (strlen(note)) {
		note = "  " + note
	}
	if (is_legend) {
		if (_type == `type_selegend') {
			b = stderr
			exp = "_se"
		}
		else {
			exp = "_b"
		}
		if (rows(altstripe)) {
			mystripe = altstripe[j,]
		}
		else {
			mystripe = stripe[j,]
		}
		if (c("userversion") < 15) {
			if (rows(eq_info) > 1 & strlen(mystripe[1])) {
				name = sprintf(	"  %s[%s:%s]",
						exp,
						mystripe[1],
						mystripe[2])
			}
			else {
				name = sprintf(	"  %s[%s]",
						exp,
						mystripe[2])
			}
		}
		else if (eqSpec == "/" | mystripe[1] == "/") {
			name = sprintf(	"  %s[/%s]",
					exp,
					mystripe[2])
		}
		else if (eqSpec != "") {
			name = sprintf(	"  %s[%s:%s]",
					exp,
					mystripe[1],
					mystripe[2])
		}
		else {
			name = sprintf(	"  %s[%s]",
					exp,
					mystripe[2])
		}
		values	= J(1,7,.b)
		text	= J(1,7,"")
		text[3]	= name
		values[2] = b
		Tab.row(values, text)
		putTab.add_values(values[|2\.|])
		putTab.add_note(name)
	}
	else if (strlen(note)) {
		if (is_cpg) {
			values	= J(1,5,.b)
			text	= J(1,5,"")
		}
		else if (is_dfcp) {
			values	= J(1,6,.b)
			text	= J(1,6,"")
		}
		else {
			values	= J(1,7,.b)
			text	= J(1,7,"")
			if (_type == `type_beta') {
				if (has_bstdmat) {
					beta = bstdmat[j]
				}
				else {
					beta = _b_get_scalar("r(beta)")
				}
				values[7] = beta
			}
		}
		values[2] = b
		text[3] = note
		Tab.row(values, text)
		putTab.add_values(values[|2\.|])
		putTab.add_note(note)
	}
	else if (_type == `type_groups') {
		values	= J(1,5,.b)
		text	= J(1,5,"")
		values[2] = b
		values[3] = stderr
		text[5]	= groups[j]
		Tab.row(values, text)
		putTab.add_values(values[|2\.|])
		putTab.add_note(groups[j])
	}
	else {
		if (_type != `type_ci' & _type != `type_dfci') {
			if (!missing(stat[j]) & abs(stat[j]) > 9999) {
				nhold	= Tab.set_format_number()
				nfmt	= nhold
				if (_type == `type_dfpv') {
					nfmt[5] = "%8.2e"
				}
				else {
					nfmt[4] = "%8.2e"
				}
				Tab.set_format_number(nfmt)
				reset_nfmt = 1
			}
		}

		if (is_cpg) {
			values	= J(1,5,.b)
			text	= J(1,5,"")
		}
		else if (is_dfcp) {
			values	= J(1,6,.b)
			text	= J(1,6,"")
		}
		else {
			values	= J(1,7,.b)
			text	= J(1,7,"")
		}
		values[2] = b
		if (has_vmat) {
			values[3] = stderr
			if (_type == `type_beta') {
				values[4] = stat[j]
				values[5] = pvalue[j]
				if (has_bstdmat) {
					beta = bstdmat[j]
				}
				else {
					beta = _b_get_scalar("r(beta)")
				}
				values[7] = beta
			}
			else if (_type == `type_ci') {
				values[4] = ll
				values[5] = ul
			}
			else if (_type == `type_dfci') {
				if (j <= cols(dfmat)) {
					values[4] = dfmat[j]
				}
				else {
					values[4] = _df
				}
				values[5] = ll
				values[6] = ul
			}
			else if (_type == `type_df') {
				if (j <= cols(dfmat)) {
					values[4] = dfmat[j]
				}
				else {
					values[4] = .
				}
				if (j <= cols(pisemat)) {
					values[5] = pisemat[j]
				}
				else {
					values[5] = .
				}
			}
			else if (_type == `type_pv') {
				values[4] = stat[j]
				values[5] = pvalue[j]
			}
			else if (_type == `type_dfpv') {
				if (j <= cols(dfmat)) {
					values[4] = dfmat[j]
				}
				else {
					values[4] = _df
				}
				values[5] = stat[j]
				values[6] = pvalue[j]
			}
			else if (_type == `type_dftable') {
				values[4] = stat[j]
				values[5] = pvalue[j]
				if (j <= cols(dfmat)) {
					values[6] = dfmat[j]
				}
				else {
					values[6] = .
				}
				if (j <= cols(pisemat)) {
					values[7] = pisemat[j]
				}
				else {
					values[7] = .
				}
			}
			else {
				values[4] = stat[j]
				values[5] = pvalue[j]
				values[6] = ll
				values[7] = ul
			}
		}
		Tab.row(values)
		putTab.add_values(values[|2\.|])
		if (has_extrarowmat) { //display extra row
			values = (.b, extrarowmat[j,.])
			printf("{txt}{col %g}{c |}", _width+2)
			if (pclassmat[j] == PC.value("aux")) {
				values[4] = .b
				values[5] = .b
			}

			if (!reset_nfmt) {	
				nhold = Tab.set_format_number()
				reset_nfmt = 1
			}
			Tab.set_format_number(rowmatnfmt)
			Tab.row(values)
			putTab.add_row()
			putTab.add_values(values[|2\.|])

			if (el < eq_info[eq,2]-eq_info[eq,1]+1) blank(0)
		}
		if (reset_nfmt) {
			Tab.set_format_number(nhold)
		}
	}
}

void _b_table::di_eq(	real	scalar	eq,
			string	scalar	comment,
			|real	scalar	dosep)
{
	real	scalar	i0
	real	scalar	k
	real	scalar	output
	string	scalar	first
	string	scalar	diopts
	real	scalar	i
	string	vector	sfmt
		vector	shold
	real	scalar	pclass

	real	scalar	oldterm

	if (eq < 1 | eq > rows(eq_info)) {
		exit(error(303))
	}

	if (eq == k_eq_base & strlen(comment) == 0) {
		comment = "  (base outcome)"
	}

	i0	= eq_info[eq,1]
	k	= eq_info[eq,2] - i0 + 1
	if (di_eqname(eq, _width, comment, dosep)) {
		return
	}

	output	= 0
	first	= ""
	diopts	= _diopts
	if (!strpos(diopts, "vsquish")) {
		diopts = diopts + " vsquish"
	}
	if (is_cpg) {
		sfmt	= J(1,5,"")
	}
	else if (is_dfcp) {
		sfmt	= J(1,6,"")
	}
	else {
		sfmt	= J(1,7,"")
	}
	sfmt[2] = "%1s"
	sfmt[3] = "%1s"
	shold = Tab.set_format_string()
	Tab.set_format_string(sfmt)
	Tab.set_skip1(1)
	if (_sort) {
		sub_order	= panelsubmatrix(order, eq, eq_info)
		sub_el_info	= panelsubmatrix(el_info, eq, eq_info)
	}
	oldterm	= .
	if (stripe[i0,1] == "/") {
		pclass = pclassmat[i0]
		for (i=1; i<=k; i++, i0++) {
			if (pclass != pclassmat[i0]) {
				pclass = pclassmat[i0]
				sep()
			}
			di_eq_el(eq, i, oldterm, first, output, diopts)
		}
	}
	else {
		for (i=1; i<=k; i++) {
			di_eq_el(eq, i, oldterm, first, output, diopts)
		}
	}
	Tab.set_format_string(shold)
	Tab.set_skip1(.)
	if (substr(eqSpec,1,1) == "/") {
		return
	}
	if (eq <= length(_offset)) {
		di_offset(_offset[eq])
	}
}

void _b_table::di_var_eq(
	real	scalar	eq,
	string	scalar	name)
{
	real	scalar	w

	w = Tab.set_width()[1]
	displayas("txt")
	if (strlen(name) + `varlen' <= w) {
		printf("var(%s)", name)
	}
	else {
		printf("var(%s)", abbrev(name, w-`varlen'))
	}
	di_eq_el_u(eq,1)
}

void _b_table::di_cov_eq(
	real	scalar	eq,
	string	scalar	name,
	string	scalar	name2)
{
	real	scalar	w

	w = Tab.set_width()[1]
	displayas("txt")
	if (strlen(name) + strlen(name2) + `covlen' <= w) {
		printf("cov(%s,%s)", name, name2)
	}
	else {
		printf("cov(%s,", abbrev(name, w-`varlen'))
		blank()
		printf("    %s)", abbrev(name2, w-`varlen'))
	}
	di_eq_el_u(eq,1)
}

void _b_table::do_equations_grouped()
{
	real	scalar	k
	real	scalar	eq
	real	scalar	i
	real	scalar	j

	titles()

	k = cols(eqmat)
	eq = 0
	for (i=1; i<=k; i++) {
		if (eqmat_stripe[i,1] != "") {
			sep("bottom")	
			comment(eqmat_stripe[i,1], .b, "", 1, 0)
			sep("top")
		}
		else {
			sep()
		}
		for (j=1; j<=eqmat[i]; j++) {
			eq++
			di_eq(eq, "", j>1)
		}
	}
}

void _b_table::do_equations()
{
	real	scalar	i
	real	scalar	k

	titles()

	if (k_fp & (k_lf == k_fp)) {
		k = length(_offset)
		for (i=1; i<=k; i++) {
			if (strlen(_offset[i])) {
				sep()
				di_offset(_offset[i])
			}
		}
	}

	for (i=1; i<=_neq; i++) {
		di_eq(i, "")
	}
	if (_neq == 0) {
		k = length(_offset)
		for (i=1; i<=k; i++) {
			if (strlen(_offset[i])) {
				sep()
				di_offset(_offset[i])
			}
		}
	}
}

void _b_table::do_equations_ascmd()
{
	real	scalar	i
	real	scalar	j
	real	scalar	k_indvars
	real	scalar	has_const
	real	scalar	k_casevars
	real	scalar	i_base
	real	scalar	k_alt
	real	scalar	k_eq
	string	vector	alteqs

	titles()

	k_indvars = _b_get_scalar("e(k_indvars)")
	if (missing(k_indvars)) {
		k_indvars = 0
	}

	has_const = _b_get_scalar("e(const)")
	if (missing(has_const)) {
		has_const = 0
	}

	k_casevars = _b_get_scalar("e(k_casevars)")
	if (missing(k_casevars)) {
		k_casevars = 0
	}

	i_base = _b_get_scalar("e(i_base)")
	if (missing(i_base)) {
		i_base = 0
	}

	k_alt = _b_get_scalar("e(k_alt)")
	if (missing(k_alt)) {
		k_alt = 0
	}

	alteqs = tokens(st_global("e(alteqs)"))

	j = 1
	if (k_indvars) {
		k_eq = _b_get_scalar("e(k_eqfr)")
		if (missing(k_eq)) {
			k_eq = 1
		}
		for (j=1; j<=k_eq; j++) {
			di_eq(j, "")
		}
	}
	if (k_indvars == 0) {
		if (strlen(_offset[1])) {
			sep()
			comment(st_global("e(altvar)"), .b, "", 1)
			di_offset(_offset[1])
		}
	}
	_offset = ""

	if (has_const + k_casevars > 0) {
		for (i=1; i<=k_alt; i++) {
			if (i == i_base) {
				sep()
				comment(alteqs[i], .b, "  (base alternative)",
					1)
			}
			else {
				di_eq(j, "")
				j++
			}
		}
	}
	if (anyof(tokens("`asfree'"), _cmd)) {
		k_eq = _b_get_scalar("e(k_eq)")
		if (j <= k_eq) {
			di_eq(j, "")
		}
	}
}

void _b_table::do_equations_nlogit()
{
	real	scalar	i
	real	scalar	ii
	real	scalar	j
	real	scalar	jj
	real	scalar	el
	real	scalar	k_indvars
	real	scalar	has_const
	real	scalar	k_levels
	real	scalar	k_ind2vars
	string	scalar	ename
	real	matrix	altmat
	real	matrix	k_altern
	string	vector	alteqs
	string	vector	ind2vars
	real	scalar	k_alteqs
	real	scalar	i_base
	string	scalar	buf
	real	scalar	inc_j
	string	scalar	diopts
	string	scalar	first
	real	scalar	output
	real	scalar	mver

	titles()

	k_indvars	= _b_get_scalar("e(k_indvars)", 0)
	has_const	= _b_get_scalar("e(const)", 0)
	k_levels	= _b_get_scalar("e(levels)", 0)
	mver		= _b_get_scalar("e(mversion)")
	if (missing(mver)) { 
		mver = `CLOGIT_VERSION_AS_BASE'
	}

	diopts	= _diopts
	if (!strpos(diopts, "vsquish")) {
		diopts = diopts + " vsquish"
	}

	j = 1
	if (k_indvars) {
		di_eq(j, "")
		j++
	}
	for (i=1; i<=k_levels; i++) {
		if (i < k_levels) {
			ename = sprintf("e(const%f)", i)
			has_const = _b_get_scalar(ename, 0)
			ename = sprintf("e(ind2vars%f)", i)
			ind2vars = tokens(st_global(ename))
		}
		else {
			has_const = _b_get_scalar("e(const)", 0)
			ind2vars = tokens(st_global("e(ind2vars)"))
		}
		k_ind2vars = length(ind2vars)

		if (k_ind2vars + has_const == 0) {
			continue
		}

		if (i < k_levels) {
			if (k_ind2vars) {
				ename = sprintf("e(alt_ind2vars%f)", i)
				altmat = st_matrix(ename)
			}

			ename = sprintf("e(alteqs%f)", i)
			alteqs = tokens(st_global(ename))

			ename = sprintf("e(i_base%f)", i)
			i_base = _b_get_scalar(ename, 0)

			ename = sprintf("e(altvar%f)", i)
			buf = st_global(ename) + " equations"
		}
		else {
			if (k_ind2vars) {
				altmat = st_matrix("e(alt_ind2vars)")
			}

			alteqs = tokens(st_global("e(alteqs)"))

			i_base = _b_get_scalar("e(i_base)", 0)

			buf = st_global("e(altvar)") + " equations"
		}
		k_alteqs = length(alteqs)
		if (rows(altmat) != k_alteqs) {
			altmat = J(k_alteqs, k_ind2vars, 1)
		}

		sep("bottom")
		comment(buf, .b, "", 1, 0)
		sep("top")

		first = "first"
		output = 0
		for (ii=1; ii<=k_alteqs; ii++) {
			if (ii == i_base) {
				if (ii > 1) {
					sep()
				}
				comment(alteqs[ii], .b, "", 1)
				inc_j = 0
				el = 1
				for (jj=1; jj<=k_ind2vars; jj++) {
					if (altmat[ii,jj]) {
						Tab.set_skip1(1)
						di_eq_el(	j,
								el,
								.,
								first,
								output,
								diopts)
						el++
						Tab.set_skip1(.)
						inc_j = 1
					}
					else {
						comment(ind2vars[jj],
							0,
							"  (base)",
							0)
					}
				}
				if (has_const) {
					comment("_cons", 0, "  (base)", 0)
				}
				if (inc_j) {
					j++
				}
			}
			else {
				di_eq(j, "", ii > 1)
				j++
			}
		}
	}
	if (k_levels > 1) {
		if (_b_get_scalar("e(rum)", 0)) {
			buf = "dissimilarity parameters"
		}
		else {
			buf = "inclusive-value parameters"
		}
		sep("bottom")
		comment(buf, .b, "", 1, 0)
		sep("top")
		if (mver >= `CLOGIT_VERSION_CM_BASE') {
			/* free parameters				*/
			for (i=1; i<k_levels; i++) {
				di_eq(j, "", (i>1))
				++j
			}
		}
		else {
			k_altern = st_matrix("e(k_altern)")
			for (i=1; i<k_levels; i++) {
				ename = sprintf("e(altvar%f)", i)
				buf = st_global(ename)
				if (i > 1) {
					sep()
				}
				comment(buf, .b, "", 1)
				Tab.set_skip1(1)
				for (ii=1; ii<=k_altern[1,i]; ii++) {
					di_aux(j)
					j++
				}
				Tab.set_skip1(.)
			}
		}
	}
}

real vector _b_table::get_sem_ginv_blocks()
{
	real	scalar	ng
	real	vector	gib
	real	scalar	k_cns
	real	matrix	C
	real	scalar	i
	real	scalar	k
	real	matrix	sub
	real	scalar	i0
	real	scalar	i1
	real	vector	Cg
	real	scalar	gidx
	real	scalar	dp1
	real	scalar	doit
	real	scalar	kg
	real	scalar	j
	real	scalar	j0
	real	scalar	j1

	gib = J(1,dim,0)
	if (!has_Cnsmat | _showginv) {
		return(gib)
	}
	ng = _b_get_scalar("e(N_groups)", 1)
	if (ng == 1) {
		return(gib)
	}
	k_cns = rows(Cnsmat)
	if (k_cns == 0) {
		return(gib)
	}

	k = dim/ng		// # of parameters within each group
	if (dim != k*ng) {
		return(gib)
	}

	dp1	= dim+1
	i1	= 0
	gidx	= 0
	for (i=1; i<=k; i++) {
		i0 = i1 + 1
		i1 = i*ng
		Cg	= Cnsmat[|_2x2(1,i0,k_cns,i1)|]
		sub	= rowsum(Cg :!= 0) :!= 0
		kg	= sum(sub)
		if (kg != ng & kg != ng-1) {
			// not the correct number of constraints
			continue
		}
		Cg	= select(Cnsmat, sub)
		if (mreldif(Cg[.,dp1], J(kg,1,Cg[1,dp1])) > 1e-13) {
			// 'r' values differ
			continue
		}

		doit	= 0
		if (kg == ng) {
			// constant constraints
			C	= Cg[|_2x2(1,1,kg,dim)|]
			sub	= (rowsum(C :!= 0) :== 1)
			doit	= (sum(sub) == ng)
		}
		else if (Cg[1,dp1] == 0) {
			// equality constraints
			doit	= 1
			j1	= 0
			for (j=1; j<=k; j++) {
				j0 = j1 + 1
				j1 = j*ng
				C = Cg[|_2x2(1,j0,kg,j1)|]
				if (any(C)) {
					if (!allof(rowsum(C :!= 0), 2)) {
						doit = 0
						break
					}
					else if (!allof(rowsum(C),0)) {
						doit = 0
						break
					}
				}
			}
		}

		if (doit) {
			gidx++
			gib[|_2x2(1,i0,1,i1)|] = J(1,ng,gidx)
		}
	}

	return(gib)
}

void _b_table::do_equations_sem1(real scalar has_ginv)
{
	real	vector	gib
	real	scalar	noomit
	real	scalar	gidx
	real	scalar	output
	string	scalar	first
	string	scalar	diopts
	string	scalar	block
	real	scalar	eq
	real	scalar	el1
	real	scalar	el2
	real	scalar	nels
	real	scalar	new_block
	real	vector	widths
	real	scalar	oldterm
	real	scalar	el
	string	scalar	old_name
	string	scalar	name
	real	scalar	pos
		vector	hold
	string	vector	coef
	string	vector	vcm

	pragma unset name

	coef = tokens("structural measurement")
	vcm = tokens("variance covariance mean")

	gib	= get_sem_ginv_blocks()
	has_ginv= any(gib)
	titles()

	output	= 0
	first	= ""
	if (st_global("e(groupvar)") != "") {
		_diopts	= _diopts + " sem"
	}
	diopts	= _diopts
	if (!strpos(diopts, "vsquish")) {
		diopts = diopts + " vsquish"
	}
	noomit = 0
	if (strpos(diopts, "noomitted")) {
		noomit = 1
	}

	gidx	= .
	block	= ""
	old_name = ""
	pos	= 1
	for (eq=1; eq<=neq; eq++) {
		el1 = eq_info[eq,1]
		el2 = eq_info[eq,2]
		nels = el2 - el1 + 1
		new_block = _sem_eq_block(	stripe[el1,1],
						stripe[el1,2],
						pclassmat[el1],
						block,
						name)
		if (new_block) {
			sep()
			if (anyof(coef, block)) {
				comment(strproper(block), .b, "", 1)
			}
			if (block == "variance") {
				_is_var = 1
			}
			else {
				_is_var = 0
			}
		}
		if (anyof(coef, block) & old_name!=name) {
			hold = Tab.set_width()
			widths = hold
			widths[1] = widths[1] - 2
			_width = widths[1] - 1
			Tab.set_width(widths)
			Tab.set_lmargin(2)
			if (!new_block) {
				sep()
			}
			eqSpec = name
			old_name = name
			if (strlen(name) > _width) {
				name = abbrev(name, _width) 
			}
			comment(name, .b, "", 2)
			Tab.set_width(hold)
			_width = hold[1] - 1
			Tab.set_lmargin(0)
		}
		oldterm	= .
		Tab.set_skip1(1)
		if (anyof(vcm, block)) {
			stata(sprintf(_eq_di, eq))
			putTab.after_ms_eq_display("freeparm")

			if (nels == 1) {
				di_eq_el_u(eq,1)
			}
			else {
			    printf("\n")
			    for (el=1; el<=nels; el++) {
				if (gib[pos]) {
					if (gidx != gib[pos]) {
						gidx = gib[pos]
						di_eq_el(eq,
							el,
							oldterm,
							first,
							output,
							diopts + " star")
					}
				}
				else {
					di_eq_el(	eq,
							el,
							oldterm,
							first,
							output,
							diopts)
				}
				pos++
			    }
			}
			Tab.set_skip1(.)

			continue
		}
		_indent = 2
		_width = _width - _indent
		for (el=1; el<=nels; el++) {
			if (!(noomit & label[pos] == "(no path)")) {
				if (gib[pos]) {
					if (gidx != gib[pos]) {
						gidx = gib[pos]
						di_eq_el(eq,
							el,
							oldterm,
							first,
							output,
							diopts + " star")
					}
				}
				else {
					di_eq_el(	eq,
							el,
							oldterm,
							first,
							output,
							diopts)
				}
			}
			pos++
		}
		_width = _width + _indent
		_indent = 0
		Tab.set_skip1(.)
	}
}

void _b_table::di_fp_sem(real scalar eq, real vector gib)
{
	real	scalar	gidx
	real	scalar	output
	string	scalar	first
	string	scalar	diopts
	string	scalar	block
	real	scalar	el1
	real	scalar	el2
	real	scalar	nels
	real	scalar	new_block
	real	scalar	oldterm
	real	scalar	el
	string	scalar	name
	real	scalar	pos

	output	= 0
	first	= ""
	diopts	= _diopts

	gidx	= .
	block	= ""
	name	= ""

	el1	= eq_info[eq,1]
	el2	= eq_info[eq,2]
	nels	= el2 - el1 + 1
	pos	= el1
	oldterm	= .
	Tab.set_skip1(1)
	for (el=1; el<=nels; el++) {
		new_block = _sem_eq_block(	stripe[pos,1],
						stripe[pos,2],
						pclassmat[pos],
						block,
						name)
		if (new_block) {
			sep()
			if (block == "variance") {
				_is_var = 1
			}
			else {
				_is_var = 0
			}
		}
	
		if (gib[pos]) {
			if (gidx != gib[pos]) {
				gidx = gib[pos]
				di_eq_el(	eq,
						el,
						oldterm,
						first,
						output,
						diopts + " star")
			}
		}
		else {
			di_eq_el(	eq,
					el,
					oldterm,
					first,
					output,
					diopts)
		}
		pos++
	}
	Tab.set_skip1(.)
}

void _b_table::di_eq_sem(	real	scalar	eq,
				real	vector	gib,
				string	scalar	block,
				string	scalar	old_name)
{
	real	scalar	noomit
	real	scalar	gidx
	real	scalar	output
	string	scalar	first
	string	scalar	diopts
	real	scalar	el1
	real	scalar	el2
	real	scalar	nels
	real	scalar	new_block
	real	vector	widths
	real	scalar	oldterm
	real	scalar	el
	string	scalar	name
	real	scalar	pos
		vector	hold

	pragma unset name

	output	= 0
	first	= ""
	diopts	= _diopts
	if (!strpos(diopts, "vsquish")) {
		diopts = diopts + " vsquish"
	}
	noomit = 0
	if (strpos(diopts, "noomitted")) {
		noomit = 1
	}

	gidx	= .

	_is_var = 0

	el1 = eq_info[eq,1]
	el2 = eq_info[eq,2]
	nels = el2 - el1 + 1
	new_block = _sem_eq_block(	stripe[el1,1],
					stripe[el1,2],
					pclassmat[el1],
					block,
					name)
	if (new_block) {
		sep()
		comment(strproper(block), .b, "", 1)
	}
	if (old_name!=name) {
		hold = Tab.set_width()
		widths = hold
		widths[1] = widths[1] - 2
		_width = widths[1] - 1
		Tab.set_width(widths)
		Tab.set_lmargin(2)
		if (!new_block) {
			sep()
		}
		eqSpec = name
		old_name = name
		if (strlen(name) > _width) {
			name = abbrev(name, _width) 
		}
		comment(name, .b, "", 2)
		Tab.set_width(hold)
		_width = hold[1] - 1
		Tab.set_lmargin(0)
	}
	_indent = 2
	_width = _width - _indent
	Tab.set_skip1(1)
	pos = el1
	oldterm	= .
	for (el=1; el<=nels; el++) {
		if (!(noomit & label[pos] == "(no path)")) {
			if (gib[pos]) {
				if (gidx != gib[pos]) {
					gidx = gib[pos]
					di_eq_el(eq,
						el,
						oldterm,
						first,
						output,
						diopts + " star")
				}
			}
			else {
				di_eq_el(	eq,
						el,
						oldterm,
						first,
						output,
						diopts)
			}
		}
		pos++
	}
	_width = _width + _indent
	_indent = 0
	Tab.set_skip1(.)
}

void _b_table::do_equations_sem(real scalar has_ginv)
{
	string	scalar	block
	string	scalar	old_name
	real	vector	gib
	real	scalar	i

	if (!strpos(_diopts, "vsquish")) {
		_diopts = _diopts + " vsquish"
	}
	if (st_global("e(groupvar)") != "") {
		_diopts	= _diopts + " fvignore(1)"
		if (_flignore == 1) {
			_diopts	= _diopts + " flignore"
		}
	}

	block	= ""
	old_name = ""
	gib	= get_sem_ginv_blocks()
	has_ginv= any(gib)
	titles()

	for (i=1; i<=_neq; i++) {
		if (stripe[eq_info[i,1],1] == "/") {
			di_fp_sem(i, gib)
		}
		else {
			di_eq_sem(i, gib, block, old_name)
		}
	}
}

void _b_table::do_equations_gsem2()
{
	real	scalar	noomit
	real	scalar	output
	string	scalar	first
	string	scalar	diopts
	string	scalar	block
	real	scalar	eq
	real	scalar	el1
	real	scalar	el2
	real	scalar	nels
	real	scalar	new_block
	real	scalar	oldterm
	real	scalar	el
	string	scalar	old_name
	string	scalar	prefix
	string	scalar	name
	string	scalar	name2
	real	scalar	pos
		vector	hold
	string	scalar	note
	string	vector	coef
	string	vector	mvarcov
	string	vector	depvars
	real	scalar	is_mlogit
	real	scalar	gaussvar

	pragma unset prefix
	pragma unset name
	pragma unset name2

	depvars = tokens(st_global("e(depvar)"))
	coef = tokens("coef structural measurement base")
	mvarcov = tokens("mean variance covariance")
	titles()

	is_mlogit = is_me
	if (is_mlogit) {
		is_mlogit = tokens(st_global("e(family)"))[1] == "multinomial"
	}

	output	= 0
	first	= ""

	noomit = 0
	if (strpos(_diopts, "noomitted")) {
		noomit = 1
	}

	if (is_me) {
		_eq_di = _eq_di + " mecmd"
	}
	gaussvar = 0
	block	= ""
	old_name = ""
	pos	= 1
	for (eq=1; eq<=neq; eq++) {
		el1 = eq_info[eq,1]
		el2 = eq_info[eq,2]
		nels = el2 - el1 + 1
		new_block = _gsem_eq_block(	stripe[el1,1],
						eqprefix[el1],
						stripe[el1,2],
						pclassmat[el1],
						is_me,
						block,
						prefix,
						name,
						name2)

		// block header output
		if (new_block) {
			if (block == "variance") {
				_is_var = 1
			}
			else {
				_is_var = 0
			}
			if (new_block == 2) {
				sep()
			}
			else if (strlen(prefix)) {
				sep()
			}
			else if (_is_var) {
				sep()
			}
			if (strlen(prefix)) {
				comment(prefix, .b, "", 3)
			}
		}
		if (!anyof(coef, block)) {
			diopts = _diopts + " gsem"
		}
		else {
			diopts = _diopts
		}
		note	= ""
		if (old_name!=name & anyof(coef, block)) {
			old_name = name
			if (block == "base") {
				name = abbrev(name, _width) 
				note = "  (base outcome)"
			}
			else if (!is_me) {
				if (strlen(name) > _width) {
					name = abbrev(name, _width) 
				}
			}
			if (!is_me | is_mlogit) {
				if (!new_block) {
					sep()
				}
				comment(name, .b, note, 1)
			}
			if (block == "base") {
				continue
			}
		}
		if (strlen(note)) {
			continue
		}

		if (anyof(mvarcov, block)) {
			if (gaussvar == 0) {
				if (strmatch(name, "e.*")) {
					name = bsubstr(name,3,.)
					gaussvar = anyof(depvars,name)
				}
				if (gaussvar) {
					if (new_block == 0) {
						sep()
					}
				}
			}

			hold = _width
			_width++

			Tab.set_skip1(1)
			stata(sprintf(_eq_di, eq))
			putTab.after_ms_eq_display("freeparm")
			di_eq_el_u(eq,1)
			Tab.set_skip1(.)

			_width = hold

			continue
		}

		// equation element output
		oldterm	= .
		Tab.set_skip1(1)
		for (el=1; el<=nels; el++) {
			if (!(noomit & label[pos] == "(no path)")) {
				di_eq_el(	eq,
						el,
						oldterm,
						first,
						output,
						diopts)
			}
			pos++
		}
		Tab.set_skip1(.)
		if (eq <= length(_offset)) {
			di_offset(_offset[eq])
		}
	}
}

void _b_table::di_eq_gsem(real scalar eq)
{
	real	scalar	i0
	real	scalar	k
	real	scalar	output
	string	scalar	first
	string	scalar	diopts
	real	scalar	i
	string	vector	sfmt
		vector	shold
	real	scalar	oldterm
	string	vector	varcov
	string	vector	depvars
	real	scalar	new_block
	string	scalar	block
	string	scalar	prefix
	string	scalar	name
	string	scalar	name2
	real	scalar	gaussvar

	varcov = tokens("variance covariance")
	depvars = tokens(st_global("e(depvar)"))

	if (eq < 1 | eq > rows(eq_info)) {
		exit(error(303))
	}

	i0	= eq_info[eq,1]
	k	= eq_info[eq,2] - i0 + 1

	first	= ""
	if (is_cpg) {
		sfmt	= J(1,5,"")
	}
	else if (is_dfcp) {
		sfmt	= J(1,6,"")
	}
	else {
		sfmt	= J(1,7,"")
	}
	sfmt[2] = "%1s"
	sfmt[3] = "%1s"
	shold = Tab.set_format_string()
	Tab.set_format_string(sfmt)
	Tab.set_skip1(1)
	if (_sort) {
		sub_order	= panelsubmatrix(order, eq, eq_info)
		sub_el_info	= panelsubmatrix(el_info, eq, eq_info)
	}
	oldterm	= .
	gaussvar = 0
	block	= ""
	prefix	= ""
	name	= ""
	name2	= ""
	for (i=1; i<=k; i++, i0++) {
		new_block = _gsem_eq_block(	stripe[i0,1],
						eqprefix[i0],
						stripe[i0,2],
						pclassmat[i0],
						is_me,
						block,
						prefix,
						name,
						name2)
		if (new_block) {
			output	= 0
			diopts	= _diopts
			if (!strpos(diopts, "vsquish")) {
				diopts = diopts + " vsquish"
			}
			if (new_block == 2) {
				sep()
			}
			else if (anyof(varcov, block)) {
				sep()
			}
			if (gaussvar == 0) {
				if (strmatch(name, "e.*")) {
					name = bsubstr(name,3,.)
					gaussvar = anyof(depvars,name)
				}
			}
		}
		else if (anyof(varcov, block)) {
			if (gaussvar == 0) {
				if (strmatch(name, "e.*")) {
					name = bsubstr(name,3,.)
					gaussvar = anyof(depvars,name)
				}
				if (gaussvar) {
					sep()
					output	= 0
					diopts	= _diopts
					if (!strpos(diopts, "vsquish")) {
						diopts = diopts + " vsquish"
					}
				}
			}
		}
		di_eq_el(eq, i, oldterm, first, output, diopts)
	}
	Tab.set_format_string(shold)
	Tab.set_skip1(.)
}

void _b_table::do_equations_gsem()
{
	real	scalar	i

	titles()

	if (_fvignore) {
		_diopts	= sprintf("%s fvignore(%f)", _diopts, _fvignore) 
		if (_flignore == 1) {
			_diopts	= _diopts + " flignore"
		}
	}

	for (i=1; i<=_neq; i++) {
		if (eq_select[i] == 0) {
			continue
		}
		if (stripe[eq_info[i,1],1] == "/") {
			di_eq_gsem(i)
		}
		else {
			di_eq(i, "")
		}
	}
}

void _b_table::di_eq_mecmd(real scalar eq)
{
	real	scalar	i0
	real	scalar	k
	real	scalar	output
	string	scalar	first
	string	scalar	diopts
	real	scalar	i
	string	vector	sfmt
		vector	shold
	real	scalar	oldterm
	string	vector	varcov
	string	vector	depvars
	real	scalar	new_block
	string	scalar	block
	string	scalar	prefix
	string	scalar	name
	string	scalar	name2
	real	scalar	gaussvar

	varcov = tokens("variance covariance")
	depvars = tokens(st_global("e(depvar)"))

	if (eq < 1 | eq > rows(eq_info)) {
		exit(error(303))
	}

	i0	= eq_info[eq,1]
	k	= eq_info[eq,2] - i0 + 1

	output	= 0
	first	= ""
	_diopts	= _diopts + " mecmd"
	diopts	= _diopts
	if (!strpos(diopts, "vsquish")) {
		diopts = diopts + " vsquish"
	}
	if (is_cpg) {
		sfmt	= J(1,5,"")
	}
	else if (is_dfcp) {
		sfmt	= J(1,6,"")
	}
	else {
		sfmt	= J(1,7,"")
	}
	sfmt[2] = "%1s"
	sfmt[3] = "%1s"
	shold = Tab.set_format_string()
	Tab.set_format_string(sfmt)
	Tab.set_skip1(1)
	if (_sort) {
		sub_order	= panelsubmatrix(order, eq, eq_info)
		sub_el_info	= panelsubmatrix(el_info, eq, eq_info)
	}
	oldterm	= .
	gaussvar = 0
	block	= ""
	prefix	= ""
	name	= ""
	name2	= ""
	for (i=1; i<=k; i++, i0++) {
		new_block = _gsem_eq_block(	stripe[i0,1],
						eqprefix[i0],
						stripe[i0,2],
						pclassmat[i0],
						is_me,
						block,
						prefix,
						name,
						name2)
		if (new_block) {
			if (new_block == 2) {
				sep()
			}
			else if (anyof(varcov, block)) {
				sep()
			}
			if (strlen(prefix)) {
				Tab.set_skip1(.)
				comment(prefix, .b, "", 3)
				Tab.set_skip1(1)
			}
		}
		else if (anyof(varcov, block)) {
			if (gaussvar == 0) {
				if (strmatch(name, "e.*")) {
					name = bsubstr(name,3,.)
					gaussvar = anyof(depvars,name)
				}
				if (gaussvar) {
					sep()
				}
			}
		}
		di_eq_el(eq, i, oldterm, first, output, diopts)
	}
	Tab.set_format_string(shold)
	Tab.set_skip1(.)
}

void _b_table::do_equations_mecmd()
{
	real	scalar	i

	titles()

	for (i=1; i<=_neq; i++) {
		if (stripe[eq_info[i,1],1] == "/") {
			di_eq_mecmd(i)
		}
		else {
			di_eq(i, "")
		}
	}
}

void _b_table::di_aux(real scalar eq, |real scalar sep, real scalar covsep)
{
	real	scalar	el
	real	scalar	notest
	string	scalar	name
	string	scalar	exp
	string	vector	text
	real	vector	values
		vector	nhold

	if (_type == `type_selegend') {
		exp	= "_se"
	}
	else {
		exp	= "_b"
	}

	if (is_cpg) {
		values	= J(1,5,.b)
		text	= J(1,5,"")
	}
	else if (is_dfcp) {
		values	= J(1,6,.b)
		text	= J(1,6,"")
	}
	else {
		values	= J(1,7,.b)
		text	= J(1,7,"")
	}
	stata(sprintf(_eq_di, eq))
	putTab.after_ms_eq_display("aux")
	sep	= _b_get_scalar("r(sep)", 0)
	covsep	= _b_get_scalar("r(covsep)", 0)
	el	= eq_info[eq,2]
	if (is_legend) {
		if (strlen(stripe[el,1])) {
			name = sprintf(	"  %s[%s:%s]",
					exp,
					stripe[el,1],
					stripe[el,2])
		}
		else {
			name = sprintf(	"  %s[%s]",
					exp,
					stripe[el,2])
		}
		if (_type == `type_selegend') {
			values[2] = se[el]
		}
		else {
			values[2] = bmat[el]
		}
		text[3] = name
		Tab.row(values, text)
		putTab.add_note(name)
		putTab.add_values(values[|2\.|])
	}
	else if (_type == `type_beta') {
		values[2] = bmat[el]
		values[3] = se[el]
		values[4] = stat[el]
		values[5] = pvalue[el]
		values[7] = .
		Tab.row(values)
		putTab.add_rtitle(text[1])
	}
	else if (_type == `type_df') {
		values[2] = bmat[el]
		values[3] = se[el]
		if (el <= cols(dfmat)) {
			values[4] = dfmat[el]
		}
		else {
			values[4] = .
		}
		if (el <= cols(pisemat)) {
			values[5] = pisemat[el]
		}
		else {
			values[5] = .
		}
		Tab.row(values)
		putTab.add_values(values[|2\.|])
	}
	else if (_type == `type_dftable') {
		values[2] = bmat[el]
		values[3] = se[el]
		values[4] = stat[el]
		values[5] = pvalue[el]
		if (el <= cols(dfmat)) {
			values[6] = dfmat[el]
		}
		else {
			values[6] = .
		}
		if (el <= cols(pisemat)) {
			values[7] = pisemat[el]
		}
		else {
			values[7] = .
		}
		Tab.row(values)
		putTab.add_values(values[|2\.|])
	}
	else {
		text[3] = label[el]
		values = J(1,cols(values),.b)
		if (strlen(text[3])) {
			text[3] = "  " + text[3]
			values[2] = bmat[el]
		}
		else {
			values[2] = bmat[el]
			values[3] = has_vmat ? se[el] : .
			if (_type == `type_ci') {
				values[4] = ci[1,el]
				values[5] = ci[2,el]
			}
			else if (_type == `type_dfci') {
				if (el <= cols(dfmat)) {
					values[4] = dfmat[el]
				}
				else {
					values[4] = _df
				}
				values[5] = ci[1,el]
				values[6] = ci[2,el]
			}
			else if (_type == `type_pv') {
				values[4] = stat[el]
				values[5] = pvalue[el]
			}
			else if (_type == `type_dfpv') {
				if (el <= cols(dfmat)) {
					values[4] = dfmat[el]
				}
				else {
					values[4] = _df
				}
				values[5] = stat[el]
				values[6] = pvalue[el]
			}
			else {
				values[4] = stat[el]
				values[5] = pvalue[el]
				values[6] = ci[1,el]
				values[7] = ci[2,el]
			}
		}
		Tab.row(values, text)
		putTab.add_note(text[3])
		putTab.add_values(values[|2\.|])
		text[3] = ""
	}
	if (has_extrarowmat) {	// display extra row
		notest = (values[4]==.b)
		values = (.b, extrarowmat[el,.])
		if (notest) values[4] = values[5] = .b

		printf("{txt}{col %g}{c |}", _width+2)

		nhold = Tab.set_format_number()
		Tab.set_format_number(rowmatnfmt)
		Tab.row(values)
		Tab.set_format_number(nhold)
		putTab.add_row()
		putTab.add_values(values[|2\.|])

		if (el<dim) blank(0)
	}
}

void _b_table::do_aux()
{
	real	scalar	i0
	real	scalar	i1
	real	scalar	isep
	real	scalar	i
	real	scalar	sep
	real	scalar	covsep
	real	vector	widths
		vector	hold

	if (k_aux == 0) {
		return
	}

	sep()
	Tab.set_skip1(1)
	i0	= _neq + k_eq_skip + 1
	i1	= _neq + k_eq_skip + k_aux
	isep	= 0
	sep	= 0
	covsep	= 0
	for (i=i0; i<=i1; i++, isep++) {
		if (isep & mod(isep, _separator) == 0) {
			sep()
		}
		else if (sep) {
			sep()
		}
		else if (covsep) {
			hold = Tab.set_width()
			widths = hold
			widths[1] = widths[1] - 2
			_width = widths[1] - 1
			Tab.set_width(widths)
			Tab.set_lmargin(2)
			sep()
			Tab.set_width(hold)
			_width = hold[1] - 1
			Tab.set_lmargin(0)
		}
		di_aux(i, sep, covsep)
	}
	Tab.set_skip1(.)
}

void _b_table::do_aux_ascmd1()
{
	real	scalar	start
	real	scalar	i
	real	scalar	j
	real	scalar	k_alt
	real	scalar	k_sigma
	real	scalar	k_rho
	real	scalar	k_eq
	real	scalar	k_indvars
	real	scalar	k_casevars
	real	scalar	has_const

	k_alt = _b_get_scalar("e(k_alt)")
	if (missing(k_alt)) {
		k_alt = 0
	}

	k_sigma = _b_get_scalar("e(k_sigma)")
	if (missing(k_sigma)) {
		k_sigma = 0
	}

	k_rho = _b_get_scalar("e(k_rho)")
	if (missing(k_rho)) {
		k_rho = 0
	}
	k_eq	= k_sigma + k_rho
	if (k_eq == 0) {
		return
	}

	k_indvars = _b_get_scalar("e(k_indvars)")
	if (missing(k_indvars)) {
		k_indvars = 0
	}
	k_casevars = _b_get_scalar("e(k_casevars)")
	if (missing(k_casevars)) {
		k_casevars = 0
	}
	has_const = _b_get_scalar("e(const)")
	if (missing(has_const)) {
		has_const = 0
	}
	start = (k_indvars != 0)
	if (k_casevars+has_const) start = start + k_alt - 1

	Tab.set_skip1(1)
	j = start
	for (i=1; i<=k_eq; i++) {
		if (i== 1 | i == k_sigma + 1) {
			sep()
		}
	    	j++
		di_aux(j)
	}
	Tab.set_skip1(.)
}

void _b_table::do_aux_ascmd2()
{
	real	scalar	start
	real	scalar	i
	real	scalar	j
	real	scalar	k_alt
	real	scalar	structcov
	real	scalar	k_factors
	real	vector	stdfixed
	real	scalar	k_indvars
	real	scalar	k_eq
	real	scalar	k_casevars
	real	scalar	has_const

	k_factors = _b_get_scalar("e(k_factors)")
	if (missing(k_factors)) {
		return
	}
	if (k_factors == 0) {
		return
	}

	k_alt = _b_get_scalar("e(k_alt)")
	if (missing(k_alt)) {
		return
	}
	if (k_alt == 0) {
		return
	}

	k_indvars = _b_get_scalar("e(k_indvars)")
	if (missing(k_indvars)) {
		k_indvars = 0
	}
	k_casevars = _b_get_scalar("e(k_casevars)")
	if (missing(k_casevars)) {
		k_casevars = 0
	}
	has_const = _b_get_scalar("e(const)")
	if (missing(has_const)) {
		has_const = 0
	}
	start = (k_indvars != 0)
	if (k_casevars+has_const) start = start + k_alt - 1

	structcov = _b_get_scalar("e(structcov)")
	if (missing(structcov)) {
		structcov = 0
	}
	if (structcov == 0) {
		k_alt--
	}

	stdfixed = st_matrix("e(stdfixed)")
	if (length(stdfixed) == 0) {
		return
	}

	k_eq = 0
	for (i=1; i<=k_alt; i++) {
		if (missing(stdfixed[i])) {
			k_eq = k_eq + k_factors
		}
	}
	if (k_eq == 0) {
		return
	}

	sep()
	Tab.set_skip1(1)
	j = start
	for (i=1; i<=k_eq; i++) {
	    	j++
		di_aux(j)
	}
	Tab.set_skip1(.)
}

void _b_table::show_diparm(real scalar i)
{
	real	scalar	rc
	real	scalar	code
	string	scalar	exp
	real	scalar	el
	real	scalar	j
	real	scalar	ieq
	real	scalar	pise
	real	scalar	df
	string	scalar	note
	real	vector	values
	string	vector	text
		vector	chold
		vector	fhold
	real	scalar	dim
	string	scalar	tname

	if (is_cpg) {
		dim = 5
	}
	else if (is_dfcp) {
		dim = 6
	}
	else {
		dim = 7
	}
	values = J(1,dim,.b)
	text = J(1,dim,"")

	code	= diparm_info[1,i]
	el	= diparm_info[2,i]
	if (code == `diparm_sep') {
		sep()
	}
	else if (code == `diparm_bot') {
		sep("bottom")
	}
	else if (code == `diparm_label') {
		/* NOTE: look at use of -_mse_eq_display- below if
		 * labels here get more complicated.
		 */
		text[1]	= diparm_label[1,i]
		text[3]	= diparm_label[2,i]
		Tab.row(values, text)
		putTab.add_row()
		putTab.add_rtitle(text[1])
		putTab.add_note(text[3])
		putTab.add_values(values[|2\.|])
	}
	else if (code == `diparm_eqlab') {
		/* NOTE: look at use of -_mse_eq_display- below if
		 * labels here get more complicated.
		 */
		chold = Tab.set_color_string()
		fhold = Tab.set_format_string()
		text[1] = "result"
		Tab.set_color_string(text)
		text[1] = sprintf("%%-%fs", _width)
		Tab.set_format_string(text)

		text[1]	= diparm_label[1,i]
		text[3]	= diparm_label[2,i]
		Tab.row(values, text)
		putTab.add_row()
		putTab.add_rtitle(text[1])
		putTab.add_ralign("left")
		putTab.add_note(text[3])
		putTab.add_values(values[|2\.|])

		Tab.reset_color_string(chold)
		Tab.reset_format_string(fhold)
	}
	else if (code == `diparm_aux') {
		ieq	= 1
		for (j=1; j<=neq; j++) {
			if (el <= eq_info[j,2]) {
				ieq = j
				break
			}
		}
		stata(sprintf("_ms_eq_display, width(%f) mat(%s) eq(%f) aux",
			_width,
			_bmat,
			ieq))

		if (is_legend) {
			if (_type == `type_selegend') {
				values[2] = diparm_table[2,i]
				exp = "_se"
			}
			else {
				values[2] = diparm_table[1,i]
				exp = "_b"
			}
			if (strlen(stripe[el,1])) {
				text[3] = sprintf(	"  %s[%s:%s]",
							exp,
							stripe[el,1],
							stripe[el,2])
			}
			else {
				text[3] = sprintf(	"  %s[%s]",
							exp,
							stripe[el,2])
			}
		}
		else if (_type == `type_beta') {
			values[2] = diparm_table[1,i]
			values[3] = diparm_table[2,i]
			values[4] = diparm_table[3,i]
			values[5] = diparm_table[4,i]
			values[7] = .
			text[1]	= diparm_label[1,i]
		}
		else if (_type == `type_dftable' | _type == `type_df') {
			df	= .b
			pise	= .b
			if (el & !missing(el)) {
				if (el <= cols(dfmat)) {
					df	= dfmat[1,el]
				}
				else {
					df	= .
				}
				if (el <= cols(pisemat)) {
					pise	= pisemat[1,el]
				}
				else {
					pise	= .
				}
			}
			values[2] = diparm_table[1,i]
			values[3] = diparm_table[2,i]
			if (_type == `type_dftable') {
				values[4] = diparm_table[3,i]
				values[5] = diparm_table[4,i]
				values[6] = df
				values[7] = pise
			}
			else if (_type == `type_df') {
				values[4] = df
				values[5] = pise
			}
			text[1]	= diparm_label[1,i]
		}
		else {
			note = diparm_label[2,i]
			if (strlen(note)) {
				values[2] = diparm_table[1,i]
				text[3] = "  " + note
			}
			else if (diparm_Cns[i]) {
				values[2] = diparm_table[1,i]
				text[3] = "  " + notes[9]
			}
			else {
				values[2] = diparm_table[1,i]
				values[3] = diparm_table[2,i]
				if (_type == `type_ci') {
					values[4] = diparm_table[5,i]
					values[5] = diparm_table[6,i]
				}
				else if (_type == `type_dfci') {
					if (el & !missing(el)) {
						if (el <= cols(dfmat)) {
							values[4] = dfmat[1,el]
						}
						else {
							values[4] = _df
						}
					}
					values[5] = diparm_table[5,i]
					values[6] = diparm_table[6,i]
				}
				else if (_type == `type_pv') {
					values[4] = diparm_table[3,i]
					values[5] = diparm_table[4,i]
				}
				else if (_type == `type_dfpv') {
					if (el & !missing(el)) {
						if (el <= cols(dfmat)) {
							values[4] = dfmat[1,el]
						}
						else {
							values[4] = _df
						}
					}
					values[5] = diparm_table[3,i]
					values[6] = diparm_table[4,i]
				}
				else {
					values[4] = diparm_table[3,i]
					values[5] = diparm_table[4,i]
					values[6] = diparm_table[5,i]
					values[7] = diparm_table[6,i]
				}
			}
		}

		Tab.set_skip1(1)
		Tab.row(values, text)
		Tab.set_skip1(.)
		putTab.after_ms_eq_display("aux")
		putTab.add_note(text[3])
		putTab.add_values(values[|2\.|])
	}
	else if (code == `diparm_trans') {
		if (is_legend) {
			if (_type == `type_selegend') {
				values[2] = diparm_table[2,i]
			}
			else {
				values[2] = diparm_table[1,i]
			}
		}
		else if (_type == `type_beta') {
			values[2] = diparm_table[1,i]
			values[3] = diparm_table[2,i]
			values[4] = diparm_table[3,i]
			values[5] = diparm_table[4,i]
			values[7] = .
			text[1]	= diparm_label[1,i]
		}
		else if (_type == `type_dftable' | _type == `type_df') {
			df	= .b
			pise	= .b
			if (el & !missing(el)) {
				if (el <= cols(dfmat)) {
					df	= dfmat[1,el]
				}
				else {
					df	= .
				}
				if (el <= cols(pisemat)) {
					pise	= pisemat[1,el]
				}
				else {
					pise	= .
				}
			}
			values[2] = diparm_table[1,i]
			values[3] = diparm_table[2,i]
			if (_type == `type_dftable') {
				values[4] = diparm_table[3,i]
				values[5] = diparm_table[4,i]
				values[6] = df
				values[7] = pise
			}
			else if (_type == `type_df') {
				values[4] = df
				values[5] = pise
			}
			text[1]	= diparm_label[1,i]
		}
		else {
			note = diparm_label[2,i]
			if (strlen(note)) {
				values[2] = diparm_table[1,i]
				text[3] = "  " + note
			}
			else if (diparm_Cns[i]) {
				values[2] = diparm_table[1,i]
				text[3] = "  " + notes[9]
			}
			else {
				values[2] = diparm_table[1,i]
				values[3] = diparm_table[2,i]
				if (_type == `type_ci') {
					values[4] = diparm_table[5,i]
					values[5] = diparm_table[6,i]
				}
				else if (_type == `type_dfci') {
					values[4] = .b
					values[5] = diparm_table[5,i]
					values[6] = diparm_table[6,i]
				}
				else if (_type == `type_pv') {
					values[4] = diparm_table[3,i]
					values[5] = diparm_table[4,i]
				}
				else if (_type == `type_dfpv') {
					values[4] = .b
					values[5] = diparm_table[3,i]
					values[6] = diparm_table[4,i]
				}
				else {
					values[4] = diparm_table[3,i]
					values[5] = diparm_table[4,i]
					values[6] = diparm_table[5,i]
					values[7] = diparm_table[6,i]
				}
			}
		}

		/* NOTE: using -_ms_eq_display- to get better output when the
		 * label takes on some special forms, e.g.
		 * 	var(e.varname)
		 * 	sd(e.varname)
		 * 	mean(varname)
		 * 	cov(e.v1,e.v2)
		 * 	corr(e.v1,e.v2)
		 */
		tname = st_tempname()
		st_matrix(tname, J(1,1,0))
		st_matrixcolstripe(tname, (diparm_label[1,i], "_cons"))
		rc = _stata(sprintf(
"_ms_eq_display, diparm matrix(%s) indent(%f) width(%f) eq(1)",
				tname, _indent, _width))
		if (rc) exit(rc)
		putTab.after_ms_eq_display("diparm")
		Tab.set_skip1(1)
		Tab.row(values, text)
		Tab.set_skip1(.)
		putTab.add_note(text[3])
		putTab.add_values(values[|2\.|])
	}
	else if (code == `diparm_vlabel') {
		/* NOTE: look at use of -_mse_eq_display- above if
		 * labels here get more complicated.
		 */
		fhold = Tab.set_format_string()

		values[2] = diparm_table[1,i]
		text[1]	= diparm_label[1,i]
		text[3]	= diparm_label[2,i]
		Tab.row(values, text)
		putTab.add_row()
		putTab.add_rtitle(text[1])
		putTab.add_note(text[3])
		putTab.add_values(values[|2\.|])
	}
	else if (code == `diparm_veqlab') {
		/* NOTE: look at use of -_mse_eq_display- above if
		 * labels here get more complicated.
		 */
		chold = Tab.set_color_string()
		fhold = Tab.set_format_string()
		text[1] = "result"
		Tab.set_color_string(text)
		text[1] = sprintf("%%-%fs", _width)
		Tab.set_format_string(text)

		values[2] = diparm_table[1,i]
		text[1]	= diparm_label[1,i]
		text[3]	= diparm_label[2,i]
		Tab.row(values, text)

		Tab.reset_color_string(chold)
		Tab.reset_format_string(fhold)
		putTab.add_row()
		putTab.add_rtitle(text[1])
		putTab.add_ralign("left")
		putTab.add_note(text[3])
		putTab.add_values(values[|2\.|])
	}
	else {
		exit(error(198))
	}
}

void _b_table::do_diparms()
{
	if (_ndiparm == 0) {
		return
	}
	real	scalar	i

	sep()
	for (i=1; i<=_ndiparm; i++) {
		show_diparm(i)
	}
}

void _b_table::do_extra()
{
	real	scalar	i0
	real	scalar	i1
	real	scalar	i

	i0	= _neq + k_eq_skip + k_aux + 1
	i1	= i0 + k_extra - 1
	for (i=i0; i<=i1; i++) {
		di_eq(i, "")
	}
}

void _b_table::sep(|string scalar type)
{
	if (_markdown) {
		return
	}
	if (args() == 0) {
		type = "middle"
	}
	Tab.sep(type)
	if (substr(type,1,1) == "m") {
		putTab.set_sep()
	}
}

void _b_table::finish()
{
	if (_plus) {
		sep()
	}
	else {
		sep("bottom")
	}
	st_sclear()
	st_global("s(width)", strofreal(Tab.width_of_table()))
	st_global("s(width_col1)", strofreal(Tab.set_width())[1])
}

void _b_table::blank(|real scalar skip1)
{
	real	vector	w
	real	scalar	hold

	hold = Tab.set_skip1()
	if (args()) {
		Tab.set_skip1(skip1)
	}
	w = J(1,length(Tab.set_width()),.b)
	Tab.row(w)
	if (args()) {
		Tab.set_skip1(hold)
	}
}

// public subroutines -------------------------------------------------------

void _b_table::new()
{
	_type		= `type_dflt'
	_sort		= 0

	_separator	= 0
	_coefttl	= J(1,2,"")
	_mclegend	= 1
	_clreport	= 1

	cformat		= c("cformat")
	sformat		= c("sformat")
	pformat		= c("pformat")
	rowcformat	= cformat
	rowsformat	= sformat
	rowpformat	= pformat

	_plus		= 0
	_eq_hide	= .
	_eq_hide_first	= .

	_fvignore	= 0
	_flignore	= 0

	k_lf		= 0
	k_fp		= 0

	_norowci	= 0

	_ndiparm	= 0
	_markdown	= 0
}

void _b_table::fmm_check()
{
	string	vector	sv
	real	scalar	dim
	real	scalar	i

	sv = tokens(st_global("e(depvar)"))
	dim = cols(sv)
	for (i=1; i<=dim; i++) {
		if (st_global(sprintf("e(model%f)",i)) != "intreg") {
			return
		}
	}
	if (!allof(sv, sv[1])) {
		return
	}
	_eq_hide_first = 1
}

void _b_table::validate()
{
	if (_type == `type_selegend' | _type == `type_coeflegend') {
		if (_eform) {
			_eform = 0
			_coefttl[1] = ""
		}
	}
	super.validate()

	k_lf = st_matrixcolnlfs(_bmat)
	k_fp = st_matrixcolnfreeparms(_bmat)

	is_groups = _type == `type_groups'
	if (is_groups) {
		do_groups = 1
	}
	if (_cmd == "gsem") {
		if (is_me) {
			_eq_hide = 1
		}
		else {
			_eq_hide = 0
		}
		if (st_numscalar("e(fmmcmd)") == 1) {
			fmm_check()
		}
	}
	else if (_cmd == "eintreg" | _cmd == "xteintreg") {
		_eq_hide_first = 1
	}
	else if (_neq == 1 & k_extra == 0) {
		if (_eq_hide != 0) {
			if (c("userversion") < 15) {
				_eq_hide = 1
			}
			else if (substr(stripe[1,1],1,1) != "/") {
				_eq_hide = 1
			}
		}
	}
	if (_eq_check) {
		k_eq_base = _b_get_scalar("e(k_eq_base)")
	}
	if (_neq > neq) {
		_neq = neq
	}
	if (_cmdextras) {
		if (_cmd == "sem") {
			if (_type == `type_beta') {
				if (has_bstdmat == 0) {
					bstdmat = st_matrix("e(b_std)")
				}
				has_bstdmat = cols(bstdmat)
			}
			if (_semstd & strlen(_depname) == 0) {
				_depname = "Standardized"
			}
			else {
				_depname = " "
			}
			if (st_global("e(groupvar)") != "") {
				extra_opts = extra_opts + " sem"
			}
		}
		if (anyof(tokens("gsem meglm"), _cmd) |
		    anyof(tokens("gsem meglm"), _cmd2)) {
			if (!is_me) {
				_depname = " "
			}
		}
		if (anyof(tokens("`ascmds'"), _cmd)) {
			_eq_hide = 0
		}
		if (_cmd == "menl") {
			_eq_hide = 0
		}
	}
	if (has_bstdmat) {
		if (has_bstdmat != dim) {
			has_bstdmat = 0
		}
	}
	if (missing(_eq_hide)) {
		if (k_lf - k_fp == 1 & k_extra == 0) {
			_eq_hide = 1
		}
		else {
			_eq_hide = 0
		}
	}

	if (_extrarowmat !="") 
		extrarowmat = st_matrix(_extrarowmat)
	has_extrarowmat = length(extrarowmat)
	if (has_extrarowmat) {
		if (_type == `type_coeflegend') {
errprintf("only one of {bf:rowmatrix()} or {bf:coeflegend} is allowed\n")
			exit(198)
		}
		else if (_type == `type_selegend') {
errprintf("only one of {bf:rowmatrix()} or {bf:selegend} is allowed\n")
			exit(198)
		}
		else if (_type == `type_beta') {
errprintf("only one of {bf:rowmatrix()} or {bf:beta} is allowed\n")
			exit(198)
		}
		else if (_type == `type_groups') {
errprintf("only one of {bf:rowmatrix()} or {bf:groups} is allowed\n")
			exit(198)
		}
		_b_check_rows(_extrarowmat, extrarowmat, dim)
		if (_type == `type_dflt' | _type == `type_dftable') 
			_b_check_cols(_extrarowmat, extrarowmat, 6)
		else _b_check_cols(_extrarowmat, extrarowmat, 4)
		if (_norowci) { // for types displaying CIs
			extrarowmat = (extrarowmat[.,1..cols(extrarowmat)-2],
					J(dim,1,.b), J(dim,1,.b))
		}
	}
	has_eqmat = strlen(_eqmat)
	if (has_eqmat) {
		if (_cmdextras) {
			errprintf("option eqmatrix() not allowed\n")
			exit(198)
		}
		eqmat_stripe = st_matrixcolstripe(_eqmat)
		eqmat = st_matrix(_eqmat)
		if (rows(eqmat) != 1) {
			errprintf("invalid eqmatrix() option;\n")
			errprintf("only row vectors are allowed\n")
			exit(198)
		}
		if (any(eqmat :!= floor(eqmat))) {
			errprintf("invalid eqmatrix() option;\n")
			errprintf("non-integer values not allowed\n")
			exit(198)
		}
		if (any(eqmat :< 0)) {
			errprintf("invalid eqmatrix() option;\n")
			errprintf("negative values not allowed\n")
			exit(198)
		}
		if (sum(eqmat) != _neq) {
			errprintf("invalid eqmatrix() option;\n")
			errprintf("values not conformable with the equations\n")
			exit(198)
		}
	}

	if (_markdown) {
		if (!strpos(_diopts, "vsquish")) {
			_diopts = _diopts + " vsquish"
		}
	}
}

function _b_table::set_type(|string scalar type)
{
	if (args() == 0) {
		if (_type == `type_beta') {
			return("beta")
		}
		if (_type == `type_ci') {
			return("nopvalues")
		}
		if (_type == `type_dfci') {
			return("dfci")
		}
		if (_type == `type_df') {
			return("dfonly")
		}
		if (_type == `type_pv') {
			return("noci")
		}
		if (_type == `type_dfpv') {
			return("dfpvalues")
		}
		if (_type == `type_groups') {
			return("groups")
		}
		if (_type == `type_dftable') {
			return("dftable")
		}
		if (_type == `type_coeflegend') {
			return("coeflegend")
		}
		if (_type == `type_selegend') {
			return("selegend")
		}
		return("")
	}
	if (type == "beta") {
		_type = `type_beta'
	}
	else if (type == "nopvalues") {
		_type = `type_ci'
	}
	else if (type == "dfci") {
		_type = `type_dfci'
	}
	else if (type == "dfonly") {
		_type = `type_df'
	}
	else if (type == "noci") {
		_type = `type_pv'
	}
	else if (type == "dfpvalues") {
		_type = `type_dfpv'
	}
	else if (type == "dftable") {
		_type = `type_dftable'
	}
	else if (type == "groups") {
		_type = `type_groups'
	}
	else if (type == "selegend") {
		_type = `type_selegend'
	}
	else if (type == "coeflegend") {
		_type = `type_coeflegend'
	}
	else {
		_type = `type_dflt'
	}
}

function _b_table::set_showginv(|string scalar onoff)
{
	if (args() == 0) {
		if (_showginv) {
			return("on")
		}
		return("off")
	}
	if (onoff == "on") {
		_showginv = 1
	}
	else {
		_showginv = 0
	}
}

function _b_table::set_nofoot(|string scalar onoff)
{
	if (args() == 0) {
		if (_nofoot) {
			return("on")
		}
		return("off")
	}
	if (onoff == "on") {
		_nofoot = 1
	}
	else {
		_nofoot = 0
	}
}

function _b_table::set_sort(|string scalar sort)
{
	if (args() == 0) {
		if (_sort) {
			return("on")
		}
		return("off")
	}
	if (sort == "on") {
		_sort = 1
	}
	else {
		_sort = 0
	}
}

function _b_table::set_offset(real scalar i, |string scalar text)
{
	if (args() == 1) {
		return(_offset[i])
	}
	real	scalar	k
	transmorphic	t
	pragma unset t

	k = length(_offset)
	if (k == 0) {
		_offset = J(1,i,"")
	}
	else if (i > k) {
		swap(t, _offset)
		_offset = J(1,i,"")
		_offset[|1\k|] = t
	}
	_offset[i] = text
}


function _b_table::set_pisemat(|string scalar name)
{
	if (args() == 0) {
		return(_pisemat)
	}
	_pisemat = name
}

function _b_table::set_extrarowmat(|string scalar name, string scalar noci)
{
	if (args() == 0) {
		return(_extrarowmat)
	}
	_extrarowmat = name
	_norowci = (noci != "")
}

function _b_table::set_eqmat(|string scalar name)
{
	if (args() == 0) {
		return(_eqmat)
	}
	_eqmat = name
}

function _b_table::set_diopts(|string scalar diopts)
{
	if (args() == 0) {
		return(_diopts)
	}
	string	scalar	t

	t = st_tempname()
	if (_stata(sprintf("_get_diopts %s, %s", t, diopts))) {
		exit(198)
	}
	_diopts = st_local(t)
	extra_opts = sprintf("%s %s",	extra_opts, _diopts)
}

function _b_table::set_markdown(|string scalar onoff)
{
	if (args() == 0) {
		if (_markdown) {
			return("on")
		}
		return("off")
	}

	if (onoff == "on") {
		_markdown = 1
	}
	else {
		_markdown = 0
	}
}

function _b_table::set_separator(|real scalar n)
{
	if (args() == 0) {
		return(_separator)
	}
	if (n < 1) {
		_separator = 0
	}
	else {
		_separator = floor(n)
	}
}

function _b_table::set_depname(|string scalar text)
{
	if (args() == 0) {
		return(_depname)
	}
	_depname = text
}

function _b_table::set_coefttl(|string vector text)
{
	if (args() == 0) {
		return(_coefttl)
	}
	if (length(text) < 2) {
		_coefttl = text, ""
	}
	else {
		_coefttl = text
	}
}

function _b_table::set_pttl(|string scalar text)
{
	if (args() == 0) {
		return(_pttl)
	}
	_pttl = text
}

function _b_table::set_cittl(|string scalar text)
{
	if (args() == 0) {
		return(_cittl)
	}
	_cittl = text
}

function _b_table::set_mclegend(|string scalar onoff)
{
	if (args() == 0) {
		if (_mclegend) {
			return("on")
		}
		return("off")
	}
	if (onoff == "on") {
		_mclegend = 1
	}
	else {
		_mclegend = 0
	}
}

function _b_table::set_cnsreport(|string scalar cnsreport)
{
	if (args() == 0) {
		return(_cnsreport)
	}
	_cnsreport = cnsreport
}

function _b_table::set_clreport(|string scalar onoff)
{
	if (args() == 0) {
		if (_clreport) {
			return("on")
		}
		return("off")
	}
	if (onoff == "on") {
		_clreport = 1
	}
	else {
		_clreport = 0
	}
}

function _b_table::set_cformat(|string scalar fmt)
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

function _b_table::set_sformat(|string scalar fmt)
{
	if (args() == 0) {
		return(sformat)
	}
	if (strlen(fmt)) {
		sformat = fmt
	}
	else {
		sformat = c("sformat")
	}
}

function _b_table::set_pformat(|string scalar fmt)
{
	if (args() == 0) {
		return(pformat)
	}
	if (strlen(fmt)) {
		pformat = fmt
	}
	else {
		pformat = c("pformat")
	}
}

function _b_table::set_rowcformat(|string scalar fmt)
{
	if (args() == 0) {
		return(rowcformat)
	}
	if (strlen(fmt)) {
		rowcformat = fmt
	}
	else {
		rowcformat = c("cformat")
	}
}

function _b_table::set_rowsformat(|string scalar fmt)
{
	if (args() == 0) {
		return(rowsformat)
	}
	if (strlen(fmt)) {
		rowsformat = fmt
	}
	else {
		rowsformat = c("sformat")
	}
}

function _b_table::set_rowpformat(|string scalar fmt)
{
	if (args() == 0) {
		return(rowpformat)
	}
	if (strlen(fmt)) {
		rowpformat = fmt
	}
	else {
		rowpformat = c("pformat")
	}
}

function _b_table::set_plus(|string scalar onoff)
{
	if (args() == 0) {
		if (_plus) {
			return("on")
		}
		return("off")
	}
	if (onoff == "on") {
		_plus = 1
	}
	else {
		_plus = 0
	}
}

function _b_table::set_eq_hide(|string scalar onoff)
{
	if (args() == 0) {
		if (_eq_hide == 1) {
			return("on")
		}
		if (_eq_hide == 0) {
			return("off")
		}
		return("")
	}
	if (onoff == "on") {
		_eq_hide = 1
	}
	else if (onoff == "") {
		_eq_hide = .
	}
	else {
		_eq_hide = 0
	}
}

function _b_table::set_lstretch(|string scalar onoff)
{
	if (args() == 0) {
		if (_lstretch == 1) {
			return("on")
		}
		if (_lstretch == 0) {
			return("off")
		}
		return("")
	}
	if (onoff == "on") {
		_lstretch = 1
	}
	else {
		_lstretch = 0
	}
}

function _b_table::set_fvignore(|real scalar k)
{
	if (args() == 0) {
		return(_fvignore)
	}
	if (missing(k) | k < 0) {
		_fvignore = 0
	}
	else {
		_fvignore = k
	}
}

function _b_table::set_flignore(|string scalar onoff)
{
	if (args() == 0) {
		if (_flignore == 1) {
			return("on")
		}
		if (_flignore == 0) {
			return("off")
		}
		return("")
	}
	if (onoff == "on") {
		_flignore = 1
	}
	else {
		_flignore = 0
	}
}

void _b_table::report_table()
{
	real	scalar	has_ginv
	string	scalar	name

	if (allof(eq_select,0)) {
		return
	}
	if (c("noisily") == 0) {
		return
	}

	if (is_groups) {
		if (length(groups) == 0) {
			displayas("txt")
printf("{p 0 6 2}Note: Too many groups to be reported in a table.{p_end}\n")
			return
		}
	}
	if (set_mcompare() != "noadjust") {
		if (_mclegend) {
			mclegend()
		}
	}
	init_table()
	has_ginv = 0
	if (anyof(tokens("`ascmds'"), _cmd)) {
		if (_cmd == "nlogit") {
			do_equations_nlogit()
		}
		else {
			do_equations_ascmd()
			if (!anyof(tokens("`asfree'"), _cmd)) {
				if (missing(_b_get_scalar("e(k_factors)"))) {
					do_aux_ascmd1()
				}
				else {
					do_aux_ascmd2()
				}
			}
		}
	}
	else if (_cmd == "sem") {
		if (st_numscalar("e(sem_vers)") == 2) {
			do_equations_sem(has_ginv)
		}
		else {
			do_equations_sem1(has_ginv)
		}
	}
	else if (anyof(tokens("gsem meglm"), _cmd) |
	         anyof(tokens("gsem meglm"), _cmd2)) {
		if (st_numscalar("e(gsem_vers)") == 3) {
			if (is_me) {
				do_equations_mecmd()
			}
			else {
				do_equations_gsem()
			}
		}
		else {
			do_equations_gsem2()
		}
	}
	else if (has_eqmat) {
		do_equations_grouped()
	}
	else {
		do_equations()
		do_aux()
	}
	do_diparms()
	do_extra()
	finish()
	if (has_ginv & !_nofoot) {
		displayas("txt")
printf("{p 0 6 0 %s}Note: [*] ", st_global("s(width)"))
printf("identifies parameter estimates constrained to be equal ")
printf("across groups.")
printf("{p_end}\n")
	}
	if (is_groups) {
		if (_cmd == "pwmean") {
			name = "Means"
		}
		else {
			name = "Margins"
		}
		displayas("txt")
printf("{p 0 6 0 %s}Note: ", st_global("s(width)"))
printf("%s sharing a letter in the group label are ", name)
printf("not significantly different at the %g%% level. ", 100-_level)
printf("{p_end}\n")
	}
}

void _b_table::post_results(string scalar prefix, string scalar suffix)
{
	super.post_results(prefix, suffix)
	putTab.post_results(prefix, suffix)
}

end
