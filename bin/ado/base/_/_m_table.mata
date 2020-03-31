*! version 1.4.0  20apr2019
version 12

mata:

class _m_table extends _b_table {

protected:

	// settings
	string	scalar	_mat			// matrix to display
	string	vector	_format
	real	scalar	do_titles
	real	scalar	puttab
	string	scalar	puttabsuffix
	real	scalar	codes
	real	scalar	center

	// work space
	real	vector	mat
	real	scalar	cols
	string	matrix	cstripe

	real	scalar	ignore

	// private subroutines

	void		init_table()

	void		titles()

	real	scalar	di_eqname()
	void		di_eq_el()
	void		di_eq_el_u()
	void		di_eq()
	void		do_equations()
	void		do_equations_sem1()
	void		di_eq_sem()
	void		di_fp_sem()
	void		do_equations_sem()
	void		di_eq_mecmd()
	void		do_equations_mecmd()

public:

	void		new()

			set_mat()
			set_format()
			set_do_titles()
			set_puttab()
			set_puttabsuffix()
			set_codes()
			set_center()

	void		validate()

	void		labels_for_notes()

	void		report_table()

}

// private subroutines ------------------------------------------------------

void _m_table::init_table()
{
	real	vector	w
	real	vector	vbar
	string	vector	fmt
	real	scalar	k
	real	scalar	i
	real	scalar	sub

	if (_sort) {
		el_info	= st_matrixrowstripe_term_index(_mat), mat[,1]
		sub	= J(2,2,1)
		order	= J(rows(el_info),1,.)
		for (i=1; i<=neq; i++) {
			sub[1,1] = eq_info[i,1]
			sub[2,1] = eq_info[i,2]
			order[|sub|] = order(
				panelsubmatrix(el_info,i,eq_info), (1..3))
		}
		el_info	= st_matrixcolstripe_term_index(_mat)
	}

	fmt	= J(1,cols,"%9.0g")
	k	= min((cols-1,length(_format)))
	for (i=1; i<=k; i++) {
		if (strlen(_format[i])) {
			fmt[i+1] = _format[i]
		}
	}

	// column widths
	w = rowshape(rowmax(strlen(cstripe)),1)
	for (i=2; i<=cols; i++) {
		if (w[i] < fmtwidth(fmt[i])) {
			w[i] = fmtwidth(fmt[i])
		}
	}
	w = w :+ 2
	w[2]	= w[2] - 1
	w[1]	= 0
	if (codes) {
		w[1]	= c("linesize") - sum(w) - 2
	}
	else {
		w[1]	= _b_linesize() - sum(w) - 2
	}
	_width	= _find_min_width(w[1], _mat, 1, extra_opts)
	w[1]	= _width + 1

	Tab.init(cols)
	putTab.init(cols-1)
	Tab.set_width(w)

	Tab.set_format_number(fmt)
	putTab.set_cformats(fmt[|_2x2(1,2,1,cols)|])

	fmt	= J(1,cols,"")
	fmt[2]	= "%1s"
	Tab.set_format_string(fmt)

	fmt	= "%" :+ strofreal(w) :+ "s"
	fmt[1]	= sprintf("%%%fs", w[1]-1)
	Tab.set_format_title(fmt)

	if (center) {
		fmt	= "%~" :+ strofreal(w) :+ "s"
		fmt[1]	= ""
		Tab.set_format_string(fmt)
		fmt[1]	= sprintf("%%%fs", w[1]-1)
		Tab.set_format_title(fmt)
	}
	else if (codes) {
		fmt	= "%" :+ strofreal(w) :+ "s"
		fmt[1]	= ""
		Tab.set_format_string(fmt)
	}

	vbar = J(1,cols+1,0)
	vbar[2] = 1
	Tab.set_vbar(vbar)

	if (codes) {
		ignore = .z
	}
	else {
		ignore = .b
	}
	Tab.set_ignore(strofreal(J(1,cols,ignore)))

	Tab.set_lmargin(0)
	_indent = 0

	_ms_di = sprintf("_ms_display, mat(%s)", _mat)
	_ms_di = _ms_di + " row indent(%f) w(%f) eq(#%f) el(%f) %s %s %s"

	_eq_di = sprintf("_ms_eq_display, aux width(%f) mat(%s)", _width, _mat)
	_eq_di = _eq_di + " row eq(%f)"
}

void _m_table::titles()
{
	Tab.sep("top")
	if (any(strlen(cstripe[,1]))) {
		Tab.titles(cstripe[,1])
		putTab.add_ctitles("", cstripe[|_2x2(2,1,cols,1)|]')
	}
	Tab.titles(cstripe[,2])
	putTab.add_ctitles("", cstripe[|_2x2(2,2,cols,2)|]')
}

real scalar _m_table::di_eqname(real	scalar	eq,
				real	scalar	width,
				|real	scalar	dosep)
{
	string	scalar	eqname

	if (eq < 1 | eq > rows(eq_info)) {
		exit(error(303))
	}

	eqname	= stripe[eq_info[eq,1],1]

	if (eqname == "_") {
		eqname = ""
	}

	if (dosep) {
		Tab.sep()
	}
	if (strlen(eqname)) {
		stata(sprintf(	"_ms_eq_display, w(%f) eq(%f) mat(%s) row",
				width,
				eq,
				_mat))
		printf("\n")
	}
	putTab.after_ms_eq_display("eq")
	return(0)
}

void _m_table::di_eq_el(real	scalar	eq,
			real	scalar	el,
			real	scalar	oldterm,
			string	scalar	first,
			real	scalar	output,
			string	scalar	diopts)
{
	real	scalar	pos
	real	scalar	term
	string	scalar	nameopt

	if (_sort) {
		nameopt = "noname"
		pos = sub_order[el]
		term = sub_el_info[pos,2]
		if (term != oldterm) {
			stata(sprintf(	_ms_di,
					_indent,
					_width,
					eq,
					el,
					first,
					diopts,
					"nolev"))
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
	stata(sprintf(	_ms_di,
			_indent,
			_width,
			eq,
			pos,
			first,
			diopts,
			(strlen(first) ? "" : nameopt)))
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

	di_eq_el_u(eq, pos)
}

void _m_table::di_eq_el_u(	real	scalar	eq,
				real	scalar	el)
{
	real	scalar	j
	real	vector	values
	string	vector	text
	string	scalar	note
	real	scalar	i

	j = eq_info[eq,1] + el - 1
	note	= label[j]

	if (strlen(note)) {
		note	= "  " + note
		values	= J(1,cols,.b)
		text	= J(1,cols,"")
		text[2]	= note
		Tab.row(values, text)
		putTab.add_note(note)
	}
	else if (codes) {
		values	= .z, mat[j,]
		text	= J(1,cols,"")
		for (i=1; i<cols; i++) {
			if (mat[j,i] == ignore) {
				continue
			}
			if (missing(mat[j,i])) {
				text[i+1] = substr(sprintf("%f",mat[j,i]),2,.)
			}
		}
		Tab.row(values, text)
		putTab.add_values(mat[j,])
		putTab.add_cnotes(text[|2\cols|])
	}
	else {
		values	= .b, mat[j,]
		Tab.row(values)
		putTab.add_values(mat[j,])
	}
}

void _m_table::di_eq(real scalar eq, |real scalar dosep)
{
	real	scalar	i0
	real	scalar	k
	real	scalar	output
	string	scalar	first
	string	scalar	diopts
	real	scalar	i

	real	scalar	oldterm

	if (eq < 1 | eq > rows(eq_info)) {
		exit(error(303))
	}

	i0	= eq_info[eq,1]
	k	= eq_info[eq,2] - i0 + 1
	if (di_eqname(eq, _width, dosep)) {
		return
	}

	output	= 0
	first	= ""
	diopts	= _diopts
	if (!strpos(diopts, "vsquish")) {
		diopts = diopts + " vsquish"
	}
	if (_sort) {
		sub_order	= panelsubmatrix(order, eq, eq_info)
		sub_el_info	= panelsubmatrix(el_info, eq, eq_info)
	}
	oldterm	= .
	Tab.set_skip1(1)
	for (i=1; i<=k; i++) {
		di_eq_el(eq, i, oldterm, first, output, diopts)
	}
	Tab.set_skip1(.)
}

void _m_table::do_equations()
{
	real	scalar	i

	if (do_titles) {
		titles()
	}

	for (i=1; i<=neq; i++) {
		di_eq(i)
	}

	finish()
}

void _m_table::do_equations_sem1()
{
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
		vector	hold
	string	vector	coef
	string	vector	vcm

	pragma unset name

	coef = tokens("structural measurement")
	vcm = tokens("variance covariance mean")

	titles()

	output	= 0
	first	= ""
	_diopts	= _diopts + " sem"
	diopts	= _diopts
	if (!strpos(diopts, "vsquish")) {
		diopts = diopts + " vsquish"
	}

	block	= ""
	old_name = ""
	for (eq=1; eq<=neq; eq++) {
		el1 = eq_info[eq,1]
		el2 = eq_info[eq,2]
		nels = el2 - el1 + 1
		new_block = _sem_eq_block(	stripe[el1,1],
						stripe[el1,1],
						pclassmat[el1],
						block,
						name)
		if (new_block) {
			sep()
			if (anyof(coef, block)) {
				comment(strproper(block), .b, "", 1)
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
				Tab.sep()
			}
			old_name = name
			if (strlen(name) > _width - 3) {
				name = abbrev(name, _width-3) 
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
			putTab.after_ms_eq_display("eq")

			if (nels == 1) {
				di_eq_el_u(eq,1)
			}
			else {
				printf("\n")
				for (el=1; el<=nels; el++) {
					di_eq_el(	eq,
							el,
							oldterm,
							first,
							output,
							diopts)
				}
			}
			Tab.set_skip1(.)

			continue
		}
		_indent = 2
		_width = _width - _indent
		for (el=1; el<=nels; el++) {
			di_eq_el(eq, el, oldterm, first, output, diopts)
		}
		_width = _width + _indent
		_indent = 0
		Tab.set_skip1(.)
	}
	finish()
}

void _m_table::di_fp_sem(real scalar eq)
{
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

	pragma unset name

	output	= 0
	first	= ""
	diopts	= _diopts

	block	= ""

	el1	= eq_info[eq,1]
	el2	= eq_info[eq,2]
	nels	= el2 - el1 + 1
	pos	= el1
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
		oldterm	= .
	
		di_eq_el(	eq,
				el,
				oldterm,
				first,
				output,
				diopts)
		pos++
	}
	Tab.set_skip1(.)
}

void _m_table::di_eq_sem(	real	scalar	eq,
				string	scalar	block,
				string	scalar	old_name)
{
	real	scalar	noomit
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
			Tab.sep()
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
			di_eq_el(	eq,
					el,
					oldterm,
					first,
					output,
					diopts)
		}
		pos++
	}
	_width = _width + _indent
	_indent = 0
	Tab.set_skip1(.)
}

void _m_table::do_equations_sem()
{
	string	scalar	block
	string	scalar	old_name
	real	scalar	i

	if (!strpos(_diopts, "vsquish")) {
		_diopts = _diopts + " vsquish"
	}
	if (st_global("e(groupvar)") != "") {
		_diopts	= _diopts + " fvignore(1)"
	}

	block	= ""
	old_name = ""

	titles()

	for (i=1; i<=neq; i++) {
		if (stripe[eq_info[i,1],1] == "/") {
			di_fp_sem(i)
		}
		else {
			di_eq_sem(i, block, old_name)
		}
	}

	finish()
}

void _m_table::di_eq_mecmd(real scalar eq)
{
	real	scalar	i0
	real	scalar	k
	real	scalar	output
	string	scalar	first
	string	scalar	diopts
	real	scalar	i
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
	Tab.set_skip1(.)
}

void _m_table::do_equations_mecmd()
{
	real	scalar	i

	if (do_titles) {
		titles()
	}

	for (i=1; i<=neq; i++) {
		if (stripe[eq_info[i,1],1] == "/") {
			di_eq_mecmd(i)
		}
		else {
			di_eq(i)
		}
	}

	finish()
}

// public subroutines -------------------------------------------------------

void _m_table::new()
{
	_sort		= 0

	_cmdextras	= 0

	extra_opts	= "row"

	do_titles	= 1

	puttab		= 0
	puttabsuffix	= ""
	codes		= 0
	center		= 0
}

function _m_table::set_mat(|string scalar name)
{
	if (args() == 0) {
		return(_mat)
	}
	_mat = name
}

function _m_table::set_format(|string vector fmts)
{
	if (args() == 0) {
		return(_format)
	}
	_format = fmts
}

function _m_table::set_do_titles(|string scalar onoff)
{
	if (args() == 0) {
		if (do_titles) {
			return("on")
		}
		return("off")
	}
	if (onoff == "on") {
		do_titles = 1
	}
	else {
		do_titles = 0
	}
}

function _m_table::set_puttab(|string scalar onoff)
{
	if (args() == 0) {
		if (puttab) {
			return("on")
		}
		return("off")
	}
	if (onoff == "on") {
		puttab = 1
	}
	else {
		puttab = 0
	}
}

function _m_table::set_puttabsuffix(|string scalar suffix)
{
	if (args() == 0) {
		return(puttabsuffix)
	}
	puttabsuffix = suffix
}

function _m_table::set_codes(|string scalar onoff)
{
	if (args() == 0) {
		if (codes) {
			return("on")
		}
		return("off")
	}
	if (onoff == "on") {
		codes = 1
	}
	else {
		codes = 0
	}
}

function _m_table::set_center(|string scalar onoff)
{
	if (args() == 0) {
		if (center) {
			return("on")
		}
		return("off")
	}
	if (onoff == "on") {
		center = 1
	}
	else {
		center = 0
	}
}

void _m_table::validate()
{
	is_me = 0
	if (strlen(_mat)) {
		mat = st_matrix(_mat)
	}
	if (cols(mat) == 0) {
		errprintf("matrix required\n")
		exit(198)
	}

	stripe	= st_matrixrowstripe(_mat)
	eq_info	= panelsetup(stripe, 1)
	neq	= rows(eq_info)
	dim	= rows(mat)
	cols	= cols(mat) + 1
	cstripe	= J(cols, 2, "")
	cstripe[|_2x2(2,1,cols,2)|] = st_matrixcolstripe(_mat)

	if (_cmdextras) {
		_cmd = st_global("e(cmd)")
		_cmd2 = st_global("e(cmd2)")
		if (_cmd == "sem") {
			if (_pclassmat == "") {
				_pclassmat = "e(b_pclass)"
			}
			if (strlen(_pclassmat)) {
				pclassmat = st_matrix(_pclassmat)
			}
			if (cols(pclassmat) == 0) {
				pclassmat = J(1,dim,0)
			}
			else {
				if (cols(pclassmat) == 1) {
					pclassmat = rowshape(pclassmat, 1)
				}
				_b_check_rows(_pclassmat, pclassmat, 1)
				_b_check_cols(_pclassmat, pclassmat, dim)
			}
			extra_opts = extra_opts + " sem"
		}
		else if (anyof(tokens("gsem meglm"), _cmd) |
		         anyof(tokens("gsem meglm"), _cmd2)) {
			is_me = _b_get_scalar("e(mecmd)", 0)
			if (_pclassmat == "") {
				_pclassmat = "e(b_pclass)"
			}
			eqprefix= st_matrixcolprefixnames("e(b)")'
			if (strlen(_pclassmat)) {
				pclassmat = st_matrix(_pclassmat)
			}
			if (cols(pclassmat) == 0) {
				pclassmat = J(1,dim,0)
			}
			else {
				if (cols(pclassmat) == 1) {
					pclassmat = rowshape(pclassmat, 1)
				}
				_b_check_rows(_pclassmat, pclassmat, 1)
				_b_check_cols(_pclassmat, pclassmat, dim)
			}
			extra_opts = extra_opts + " mecmd"
		}
	}
}

void _m_table::labels_for_notes()
{
	real	scalar	i
	real	scalar	k
	real	scalar	eq
	real	scalar	el
	string	scalar	ms_info

	ms_info	= sprintf("_ms_element_info, mat(%s) row", _mat)
	ms_info	= ms_info + " eq(#%f) el(%f)"

	label	= J(1,dim,"")

	i = 0
	for (eq=1; eq<=neq; eq++) {
		k = eq_info[eq,2] - eq_info[eq,1] + 1
		for (el=1; el<=k; el++) {
			i++
			stata(sprintf(ms_info, eq, el))
			label[i] = st_global("r(note)")
		}
	}
}

void _m_table::report_table()
{
	init_table()
	if (_cmd == "sem") {
		if (st_numscalar("e(sem_vers)") == 2) {
			do_equations_sem()
		}
		else {
			do_equations_sem1()
		}
	}
	else if (is_me) {
		do_equations_mecmd()
	}
	else {
		do_equations()
	}
	if (puttab) {
		st_rclear()
		putTab.post_results("", puttabsuffix)
	}
}

end
