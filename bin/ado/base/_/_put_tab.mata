*! version 1.0.2  25aug2017
version 15

/* _put_tab::post_results() stores the following in r():
 *
 * Scalars
 *
 * 	r(PT_k_ctitles)	number of column titles macros;
 * 			r(PT_corner1), r(PT_corner2), ...;
 * 			r(PT_ctitles1), r(PT_ctitles2), ...;
 * 			r(PT_cspans1), r(PT_cspans2), ...
 * 	r(PT_has_cnotes) indicates presence of r(PT_cnotes#) macros
 * 	r(PT_has_legend) indicates that -r(PT_rnotes)- are for a legend
 *
 * Macros
 *
 *	r(put_tables)	list of put table matrix names; default is "PT"
 * 	r(PT_corner#)	#th corner title piece
 * 	r(PT_ctitles#)	#th quote-bound column titles
 * 	r(PT_cspans#)	#th quote-bound column spans
 * 	r(PT_cformats)	quote-bound numeric formats for columns
 * 	r(PT_rtitles)	quote-bound row titles
 * 	r(PT_rformats)	quote-bound numeric formats for rows
 * 	r(PT_raligns)	quote-bound row title alignments
 * 	r(PT_rnotes)	quote-bound row notes, R elements
 * 	r(PT_cnotes#)	quote-bound cell notes for row #, C elements
 * 	r(PT_rseps)	quote-bound row separator codes
 *
 * Matrices
 *
 * 	r(PT)		R by C matrix of the reported cell values;
 * 			.b is used for blank cells;
 * 			R does not include blank rows between terms
 *
 * Details:
 *
 * r(PT) represents the cells of the coefficient table as it was
 * displayed, meaning that R corresponds with rows of the reported table
 * and C correspond with the columns of the reported table.  In
 * contrast, r(table) posted by 'class _b_stat' is transposed and has
 * more information that is reported.
 *
 * The default name for this matrix is "PT", but there is support to add
 * a prefix and suffix.  The most common suffixes are "_vs", as in
 * "PT_vs", or an index for multiple-group results, as in "PT_m1",
 * "PT_m2", ...
 *
 * r(put_tables) lists the names of the put table matrices.
 *
 * r(PT_k_ctitles) is usually 1, but can be 2 or more depending on super
 * column titles such as the vcetype "Robust" and "Bootstrap".
 *
 * r(PT_ctitles1) is the first row of quote-bound column titles.  There
 * should be C quote-bound titles in this macro.  Without super column
 * titles, this macro usually contains the following quote-bound column
 * titles:
 *
 * 	`"Coef."' `"Std. Err."' `"z"' `"P>|z|"' `"[95% Conf. Interval]"' `""'
 *
 * r(PT_cspans1) is the quote-bound list of column spans corresponding
 * with the first row of column titles.  There should be C quote-bound
 * integer numbers in this macro.  For the above column titles, this
 * macro should be:
 *
 * 	`"1"' `"1"' `"1"' `"1"' `"2"' `"0"'
 *
 * The `"2"' for column 5 means that the title for the confidence
 * intervals spans 2 columns.
 *
 * r(PT_ctitle#) and r(PT_cspans#) mean the same as above but for the
 * #th row of the column titles.  In the case of multiple rows of column
 * titles, the above examples would most likely be in the final row of
 * the column titles.
 *
 * r(PT_cformats) are the numeric formats for each column.  This macro
 * is empty when r(PT_rformats) is present, otherwise there should be
 * C quote-bound numeric formats.
 *
 * r(PT_rtitles) is the quote-bound list of row titles.  There should be
 * R quote-bound titles in this macro.
 *
 * r(PT_rformats) are the numeric formats for each row.  This macro is
 * empty when r(PT_cformats) is present, otherwise there should be R
 * quote-bound numeric formats.  This macro is typically produced by
 * -estimates table-.
 *
 * r(PT_raligns) is the quote-bound list of row title alignments.  There
 * should be R quote-bound row title alignments.  The quote-bound
 * alignments should be from the following list:
 *
 * left		used for equation names and free parameter group
 * 		names
 *
 * right	used for coefficients, intercepts, free parameters, ...
 *
 * operator	used for time-series operators on a single non-factor
 * 		variable, behaves like 'right'
 *
 * level	used for levels from factor variables and interactions
 * 		containing factor variables, the indent alignment is
 * 		right but with one space for padding
 *
 * r(PT_rnotes) is the quote-bound list of row notes.  These are the notes
 * identifying base levels, omitted coefficients, and otherwise
 * constrained parameter estimates.  These are intended to be left
 * aligned and placed in the first empty cell.  There should be R
 * quote-bound row notes.  The most common of these notes follow.
 *
 * (omitted)		omitted coefficient
 *
 * (base)		base level for a factor variable or interaction
 *
 * (empty)		empty level for a factor variable or interaction
 *
 * (note estimable)	margin, contrast, or pairwise comparison that is
 * 			not estimable
 *
 * (constrained)	coefficient is constrained to a constant
 *
 * r(PT_cnotes#) is the quote-bound list of cells notes for row #.
 * These macros are basically created for/by -estimates table-.  These
 * notes are intended to be right aligned with padding for stars '*'.
 * There should be C quote-bound cell notes.  See r(PT_rnotes) for some
 * examples, but additionally these can contain stars, '*', '**', and
 * '***'.
 *
 * r(PT_rseps) is the quote-bound list of row separator codes.  A
 * separator is just a line between rows of the table.  The codes are
 *
 * ""		indicates no separator, empty string
 *
 * sep		indicates a separator above this row
 *
 */

mata:

class _put_tab {

protected:

	string	scalar		dflt_fmt	// default numeric format

	real	scalar		cols		// # of columns
	real	scalar		rows		// # of rows

	string	scalar		sep		// separator indicator

	string	colvector	corners		// corner title pieces
	string	matrix		ctitles		// column titles
	real	matrix		cspans		// column spans
	string	rowvector	cfmts		// num formats for columns
	string	matrix		rtitles		// row titles
	string	colvector	rfmts		// num formats for rows
	string	colvector	ralign		// row title alignments
	string	colvector	rnotes		// row notes
	string	matrix		cnotes		// cell notes
	string	colvector	rseps		// row separators
	real	matrix		values		// cell values

	real	scalar		has_cnotes
	real	scalar		has_rfmts
	real	scalar		has_legend

	string	scalar		quote_bind()

public:

	// NOTE: See also st_put_tab.mata for Stata friendly companion
	// functions that correspond with the following member
	// functions.

	void			init()
	void			reset()

	void			status()

	void			add_ctitles()
	void			reset_cspans()
	void			set_cformats()
	void			set_legend()
	void			add_row()
	void			set_rformat()
	void			add_rtitle()
	void			add_ralign()
	void			add_note()
	void			add_cnotes()
	void			set_sep()
	void			add_values()

	void			after_ms_eq_display()
	void			after_ms_display()

	void			post_results()

}

// protected functions ------------------------------------------------------

string scalar _put_tab::quote_bind(string rowvector v)
{
	string	scalar	q0
	string	scalar	q1
	string	scalar	mac

	q0 = char(96) + char(34)
	q1 = char(34) + char(39)
	mac = invtokens(v, q1+" "+q0)
	mac = sprintf("%s%s%s", q0, mac, q1)
	return(mac)
}

// public member functions --------------------------------------------------

void _put_tab::init(real scalar cols)
{
	reset(cols)
}

void _put_tab::reset(real scalar cols)
{
	if (cols < 1 | missing(cols)) {
		errprintf("invalid number of columns\n")
		exit(198)
	}

	dflt_fmt = "%9.0g"

	this.cols	= cols
	rows		= 0

	corners	= J(0,1,"")
	ctitles	= J(0,cols,"")
	cspans	= J(0,cols,1)
	cfmts	= J(1,cols,dflt_fmt)
	rtitles	= J(0,1,"")
	rfmts	= J(0,1,"")
	ralign	= J(0,1,"")
	rnotes	= J(0,1,"")
	cnotes	= J(0,cols,"")
	rseps	= J(0,1,"")
	values	= J(0,cols,.)

	has_cnotes = 0
	has_rfmts = 0
	has_legend = 0
}

void _put_tab::status(string scalar note)
{
	errprintf("%s: cols = %f\n", note, cols) ;
	errprintf("%s: rows = %f\n", note, rows) ;
	errprintf("%s: corners\n", note); corners
	errprintf("%s: ctitles\n", note); ctitles
	errprintf("%s: cspans\n", note); cspans
	errprintf("%s: cfmts\n", note); cfmts
	errprintf("%s: rtitles\n", note); rtitles
	errprintf("%s: rfmts\n", note); rfmts
	errprintf("%s: ralign\n", note); ralign
	errprintf("%s: rnotes\n", note); rnotes
	errprintf("%s: cnotes\n", note); cnotes
	errprintf("%s: rseps\n", note); rseps
	errprintf("%s: values\n", note); values
}

void _put_tab::add_ctitles(
	string	vector	corner,
	string	vector	titles,
	|real	vector	spans)
{
	real	vector	myspans

	corners = corners \ corner
	ctitles = ctitles \ titles

	myspans = J(1,cols,1)
	if (args() == 3) {
		if (missing(spans) == 0) {
			if (floor(spans) == spans) {
				if (sum(spans) == cols) {
					myspans = spans
				}
			}
		}
	}
	cspans = cspans \ myspans
}

void _put_tab::reset_cspans(real vector spans)
{
	real	scalar	r
	real	vector	myspans

	r = rows(cspans)

	myspans = cspans[r,]
	if (missing(spans) == 0) {
		if (floor(spans) == spans) {
			if (sum(spans) == cols) {
				myspans = spans
			}
		}
	}
	cspans[r,] = myspans
}

void _put_tab::set_cformats(string rowvector fmts)
{
	real	scalar	dim
	real	scalar	i

	dim = cols(fmts)
	for (i=1; i<=dim; i++) {
		if (fmts[i] != "") {
			cfmts[i] = fmts[i]
		}
	}
}

void _put_tab::set_legend(real scalar arg)
{
	if (missing(arg) | arg == 0) {
		has_legend = 0
	}
	else {
		has_legend = 1
	}
}

void _put_tab::add_row()
{
	rows++
	rtitles	= rtitles \ ""
	rfmts	= rfmts \ dflt_fmt
	ralign	= ralign \ "right"
	rnotes	= rnotes \ ""
	cnotes	= cnotes \ J(1,cols,"")
	if (rows > 1) {
		rseps	= rseps \ sep
	}
	else {
		rseps	= rseps \ ""
	}
	sep	= ""
	values	= values \ J(1,cols,.b)
}

void _put_tab::set_rformat(string scalar fmt)
{
	rfmts[rows] = fmt
	has_rfmts = 1
}

void _put_tab::add_rtitle(string scalar title)
{
	rtitles[rows] = title
}

void _put_tab::add_ralign(string scalar align)
{
	ralign[rows] = align
}

void _put_tab::add_note(string scalar note)
{
	rnotes[rows] = strtrim(note)
}

void _put_tab::add_cnotes(string vector notes)
{
	cnotes[rows,] = strtrim(notes)
	has_cnotes = 1
}

void _put_tab::set_sep()
{
	sep = "sep"
}

void _put_tab::add_values(real vector values)
{
	this.values[rows,] = values
}

void _put_tab::after_ms_eq_display(string scalar type)
{
	real	scalar	k
	real	scalar	i

	k = st_numscalar("r(k)")
	for (i=1; i<=k; i++) {
		add_row()
		if (type == "eq") {
			add_ralign("left")
		}
		else {
			add_ralign("right")
		}
		add_rtitle(st_global(sprintf("r(eq%f)",i)))
	}
}

void _put_tab::after_ms_display(|string scalar first)
{
	real	scalar	k
	real	scalar	i

	if (st_numscalar("r(skip)") == 1) {
		add_row()
	}
	if (st_numscalar("r(first)") == 1 | first == "first") {
		k = st_numscalar("r(k_term)")
		if (k == 0 & strlen(st_global("r(term)"))) {
			add_row()
			add_rtitle(st_global("r(term)"))
		}
		for (i=1; i<=k; i++) {
			add_row()
			add_rtitle(st_global(sprintf("r(term%f)",i)))
		}
	}
	if (st_global("r(level)") != "") {
		k = st_numscalar("r(k_level)")
		if (k == 0) {
			add_row()
			add_ralign("level")
			add_rtitle(st_global("r(level)"))
		}
		for (i=1; i<=k; i++) {
			add_row()
			add_ralign("level")
			add_rtitle(st_global(sprintf("r(level%f)",i)))
		}
	}
	if (st_global("r(operator)") != "") {
		k = st_numscalar("r(k_operator)")
		if (k == 0) {
			add_row()
			add_ralign("operator")
			add_rtitle(st_global("r(operator)"))
		}
		for (i=1; i<=k; i++) {
			add_row()
			add_ralign("operator")
			add_rtitle(st_global(sprintf("r(operator%f)",i)))
		}
	}
	add_note(st_global("r(note)"))
}

void _put_tab::post_results(
	|string	scalar	prefix,
	string	scalar	suffix)
{
	string	scalar	name
	string	scalar	rname
	string	scalar	mac
	real	scalar	dim
	real	scalar	i

	if (length(values) == 0) {
		// nothing to post
		return
	}
	name = sprintf("%sPT%s", prefix, suffix)

	st_global("r(put_tables)", name, "hidden")

	// matrix for table values
	rname = sprintf("r(%s)", name)
	st_matrix(rname, values, "hidden")

	// macros for column titles
	dim = rows(ctitles)
	rname = sprintf("r(%s_k_ctitles)", name)
	st_numscalar(rname, dim, "hidden")
	for (i=1; i<=dim; i++) {
		rname = sprintf("r(%s_corner%f)", name, i)
		st_global(rname, corners[i], "hidden")

		rname = sprintf("r(%s_ctitles%f)", name, i)
		mac = quote_bind(ctitles[i,])
		st_global(rname, mac, "hidden")

		rname = sprintf("r(%s_cspans%f)", name, i)
		mac = quote_bind(strofreal(cspans[i,]))
		st_global(rname, mac, "hidden")
	}

	if (has_rfmts == 0) {
		// macro for numeric formats of columns
		rname = sprintf("r(%s_cformats)", name)
		mac = quote_bind(cfmts)
		st_global(rname, mac, "hidden")
	}
	else {
		// macro for numeric formats of rows
		rname = sprintf("r(%s_rformats)", name)
		mac = quote_bind(rfmts')
		st_global(rname, mac, "hidden")
	}

	// macro for row titles
	rname = sprintf("r(%s_rtitles)", name)
	mac = quote_bind(rtitles')
	st_global(rname, mac, "hidden")

	// macro for row alignments
	rname = sprintf("r(%s_raligns)", name)
	mac = quote_bind(ralign')
	st_global(rname, mac, "hidden")

	// macro for row notes
	rname = sprintf("r(%s_rnotes)", name)
	mac = quote_bind(rnotes')
	st_global(rname, mac, "hidden")

	// macros for column element notes
	rname = sprintf("r(%s_has_cnotes)", name)
	st_numscalar(rname, has_cnotes, "hidden")
	if (has_cnotes) {
		for (i=1; i<=rows; i++) {
			rname = sprintf("r(%s_cnotes%f)", name, i)
			mac = quote_bind(cnotes[i,])
			st_global(rname, mac, "hidden")
		}
	}

	// macro for row separators
	rname = sprintf("r(%s_rseps)", name)
	mac = quote_bind(rseps')
	st_global(rname, mac, "hidden")

	// scalar for legend
	dim = rows(ctitles)
	rname = sprintf("r(%s_has_legend)", name)
	st_numscalar(rname, has_legend, "hidden")
}

end
