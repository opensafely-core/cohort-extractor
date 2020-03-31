*! version 2.1.1  09nov2016
version 11

mata:

class _tab {

protected:

	real	scalar	dflt_lmargin	// default left margin
	real	scalar	dflt_width	// default width
	string	scalar	dflt_c_outline	// default outline color
	string	scalar	dflt_c_ttl	// default title color
	string	scalar	dflt_c_num	// default number color
	string	scalar	dflt_c_str	// default string color

	real	scalar	_cols		// # of columns
	real	scalar	_lmargin	// left margin
	real	scalar	_comma		// use comma in numeric formats
	string	scalar	_c_outline	// color of outline
	real	scalar	_sep		// add separator every # rows
	real	scalar	_skip1

	real	vector	_width		// column widths
	real	vector	_diwidth	// display column widths
	real	vector	_vbar		// vertical separator bars
	string	vector	_fmt_ttl	// column title formats
	string	vector	_fmt_num	// column numeric formats
	string	vector	_fmt_str	// column string formats
	string	vector	_c_ttl		// column title colors
	string	vector	_c_num		// column numeric colors
	string	vector	_c_str		// column string colors
	string	vector	_ignore		// ignore strings
	real	vector	_pad		// column padding 
	real	vector	_start		// column starting position

	real	scalar	_markdown

	real	scalar	_rows		// # of rows displayed
	real	scalar	valid

	void		check_dim()
	string	scalar	get_fmt_ttl()
	string	scalar	get_fmt_num()
	string	scalar	get_fmt_str()
	string	scalar	get_nformat()
	string	scalar	get_sformat()
	void		validate()
	void		do_lmargin()
	void		do_cell()
	void		do_leftborder()

public:

	void		init()
	void		reset()
			set_lmargin()
			set_width()
			set_diwidth()
			set_vbar()
			set_format_title()
			reset_format_title()
			set_format_number()
			reset_format_number()
			set_format_string()
			reset_format_string()
			set_color_title()
			reset_color_title()
			set_color_number()
			reset_color_number()
			set_color_string()
			reset_color_string()
			set_ignore()
			set_skip1()
			set_markdown()
			width_of_table()
	void		sep()
	void		titles()
	void		row()
}

void _tab::init(real scalar cols)
{
	if (cols < 1) {
		errprintf("invalid number of columns\n")
		exit(198)
	}

	dflt_lmargin	= 2
	dflt_width	= 12
	dflt_c_outline	= "text"
	dflt_c_ttl	= "text"
	dflt_c_num	= "result"
	dflt_c_str	= "text"

	_cols		= floor(cols)

	reset()
}

void _tab::reset()
{
	_lmargin	= dflt_lmargin
	_comma		= 0
	_c_outline	= dflt_c_outline
	_sep		= 0

	_width		= J(1, _cols,	dflt_width)
	_diwidth	= J(1, _cols,	.)
	_vbar		= J(1, _cols+1,	0)
	_fmt_ttl	= J(1, _cols,	"")
	_fmt_num	= J(1, _cols,	"")
	_fmt_str	= J(1, _cols,	"")
	_pad		= J(1, _cols,	0)
	_c_ttl		= J(1, _cols,	dflt_c_ttl)
	_c_num		= J(1, _cols,	dflt_c_num)
	_c_str		= J(1, _cols,	dflt_c_str)
	_ignore		= J(1, _cols,	"")
	_skip1		= 0

	_markdown	= 0

	_rows		= 0

	valid		= .
}

// subroutines --------------------------------------------------------------

void _tab::validate()
{
	if (!missing(valid)) {
		return
	}
	real	scalar	i
	real	scalar	pos
	string	scalar	fmt

	_pad	= J(1,_cols,0)
	_start	= J(1,_cols+1,0)
	pos	= _lmargin + 1

	for (i=1; i<=_cols; i++) {
		fmt = get_fmt_num(i)
		if (_diwidth[i] < _width[i] & bsubstr(fmt,1,2) == "%-") {
			_pad[i] = _width[i] - _diwidth[i] - _vbar[i+1]
		}
		else {
			_pad[i] = _width[i] - fmtwidth(fmt) - _vbar[i+1]
		}
		
		if (_pad[i] < 0) {
			_pad[i] = 0
		}
		_start[i] = pos
		pos = pos + _width[i] + _vbar[i]
	}
	_start[_cols+1] = pos
	valid = 1
}

void _tab::check_dim(matrix X, |real scalar extra)
{
	if (args() == 1) {
		extra = 0
	}
	if (length(X) != _cols+extra) {
		exit(error(503))
	}
}

string scalar _tab::get_fmt_ttl(real scalar i)
{
	if (strlen(_fmt_ttl[i])) {
		return(_fmt_ttl[i])
	}
	return(sprintf("%%%fs", _width[i]-1))
}

string scalar _tab::get_fmt_num(real scalar i)
{
	if (strlen(_fmt_num[i])) {
		return(_fmt_num[i])
	}
	return(sprintf("%%%f.0g", _width[i]-1))
}

string scalar _tab::get_fmt_str(real scalar i)
{
	if (strlen(_fmt_str[i])) {
		return(_fmt_str[i])
	}
	return(sprintf("%%%fs", _width[i]-1))
}

string scalar _tab::get_nformat(real scalar i)
{
	return(sprintf(" %%%fs", _width[i]-1))
}

string scalar _tab::get_sformat(real scalar i)
{
	return(sprintf("%%-%fs", _width[i]))
}

void	_tab::do_leftborder()
{
	if(_markdown) {
		displayas(_c_outline)
		printf("|")	
	}	
}

void _tab::do_lmargin()
{
	if (_lmargin) {
		printf("{space %f}", _lmargin)
	}
}

void _tab::do_cell(	real	scalar	i,
			real	scalar	type,
			string	scalar	s,
			real	scalar	x)
{
	real	scalar	start
	string	scalar	format
	string	scalar	color
	string	scalar	cell

	if (i==1) {
		if (_skip1) {
			return
		}
	}
	start	= _start[i]
	if (type == 3) {
		if (_vbar[i]) {
			displayas(_c_outline)
			printf("{col %f}{c |}", start)
		}
		return
	}
	if (type) {
		if (type == 2) {
			format	= get_fmt_ttl(i)
			color	= _c_ttl[i]
		}
		else {
			format	= get_fmt_str(i)
			color	= _c_str[i]
		}
		format	= substr(format, 1, strlen(format)-1) + "uds"
		cell	= strtrim(sprintf(format, s))
	}
	else {
		format	= get_fmt_num(i)
		color	= _c_num[i]
		cell	= strtrim(sprintf(format, x))
		if (cell == _ignore[i]) {
			cell = ""
		}
	}
	if (_vbar[i] | strlen(cell)) {
		printf("{col %f}", start)
	}
	if (_vbar[i]) {
		if (i!=2 | !_skip1) {
			displayas(_c_outline)
			printf("{c |}")
		}
	}
	if (strlen(cell)) {
		if (strlen(color)) {
			displayas(color)
		}
		if (type) {
			printf(format, s)
		}
		else {
			if (_pad[i]) {
				printf("{space %f}", _pad[i])
			}
			printf(format, x)
		}
	}
}

// callable routines --------------------------------------------------------

function _tab::set_lmargin(|real scalar lmargin)
{
	if (args() == 0) {
		return(lmargin)
	}
	if (lmargin < 0) {
		errprintf("invalid left margin value\n")
		exit(198)
	}
	if (missing(lmargin)) {
		_lmargin = dflt_lmargin
	}
	else {
		_lmargin = floor(lmargin)
	}
	valid	= .
}

function _tab::set_width(|real vector width)
{
	if (args() == 0) {
		return(_width)
	}
	real	scalar	i

	check_dim(width)
	for (i=1; i<=_cols; i++) {
		if (!missing(width[i])) {
			if (width[i] < 0) {
				errprintf("invalid width value\n")
				exit(198)
			}
			_width[i] = floor(width[i])
		}
	}
	valid	= .
}

function _tab::set_diwidth(|real vector width)
{
	if (args() == 0) {
		return(_diwidth)
	}
	real	scalar	i

	check_dim(width)
	for (i=1; i<=_cols; i++) {
		if (!missing(width[i])) {
			if (width[i] < 0) {
				errprintf("invalid width value\n")
				exit(198)
			}
			_diwidth[i] = floor(width[i])
		}
	}
	valid	= .
}

function _tab::set_vbar(|real vector vbar)
{
	if (args() == 0) {
		return(_vbar)
	}
	real	scalar	dim, i

	check_dim(vbar, 1)
	dim	= _cols + 1
	for (i=1; i<=dim; i++) {
		if (!missing(vbar[i])) {
			_vbar[i] = vbar[i] != 0
		}
	}
	valid	= .
}

function _tab::set_format_title(|string vector format)
{
	if (args() == 0) {
		return(_fmt_ttl)
	}
	real	scalar	i

	check_dim(format)
	for (i=1; i<=_cols; i++) {
		if (strlen(format[i])) {
			_tab_check_sformat(format[i])
			_fmt_ttl[i] = format[i]
		}
	}
	valid	= .
}

function _tab::reset_format_title(|string vector format)
{
	if (args() == 0) {
		return(_fmt_ttl)
	}
	real	scalar	i

	check_dim(format)
	for (i=1; i<=_cols; i++) {
		if (strlen(format[i])) {
			_tab_check_sformat(format[i])
		}
		_fmt_ttl[i] = format[i]
	}
	valid	= .
}

function _tab::set_format_number(|string vector format)
{
	if (args() == 0) {
		return(_fmt_num)
	}
	real	scalar	i

	check_dim(format)
	for (i=1; i<=_cols; i++) {
		if (strlen(format[i])) {
			_tab_check_nformat(format[i])
			_fmt_num[i] = format[i]
		}
	}
	valid	= .
}

function _tab::reset_format_number(|string vector format)
{
	if (args() == 0) {
		return(_fmt_num)
	}
	real	scalar	i

	check_dim(format)
	for (i=1; i<=_cols; i++) {
		if (strlen(format[i])) {
			_tab_check_nformat(format[i])
		}
		_fmt_num[i] = format[i]
	}
	valid	= .
}

function _tab::set_format_string(|string vector format)
{
	if (args() == 0) {
		return(_fmt_str)
	}
	real	scalar	i

	check_dim(format)
	for (i=1; i<=_cols; i++) {
		if (strlen(format[i])) {
			_tab_check_sformat(format[i])
			_fmt_str[i] = format[i]
		}
	}
	valid	= .
}

function _tab::reset_format_string(|string vector format)
{
	if (args() == 0) {
		return(_fmt_str)
	}
	real	scalar	i

	check_dim(format)
	for (i=1; i<=_cols; i++) {
		if (strlen(format[i])) {
			_tab_check_sformat(format[i])
		}
		_fmt_str[i] = format[i]
	}
	valid	= .
}

function _tab::set_color_title(|string vector color)
{
	if (args() == 0) {
		return(_c_ttl)
	}
	real	scalar	i

	check_dim(color)
	for (i=1; i<=_cols; i++) {
		if (!missing(color[i])) {
			_c_ttl[i] = _tab_check_color(color[i])
		}
	}
	valid	= .
}

function _tab::reset_color_title(|string vector color)
{
	if (args() == 0) {
		return(_c_ttl)
	}
	real	scalar	i

	check_dim(color)
	for (i=1; i<=_cols; i++) {
		if (!missing(color[i])) {
			_c_ttl[i] = _tab_check_color(color[i])
		}
	}
	valid	= .
}

function _tab::set_color_number(|string vector color)
{
	if (args() == 0) {
		return(_c_num)
	}
	real	scalar	i

	check_dim(color)
	for (i=1; i<=_cols; i++) {
		if (!missing(color[i])) {
			_c_num[i] = _tab_check_color(color[i])
		}
	}
	valid	= .
}

function _tab::reset_color_number(|string vector color)
{
	if (args() == 0) {
		return(_c_num)
	}
	real	scalar	i

	check_dim(color)
	for (i=1; i<=_cols; i++) {
		if (!missing(color[i])) {
			_c_num[i] = _tab_check_color(color[i])
		}
	}
	valid	= .
}

function _tab::set_color_string(|string vector color)
{
	if (args() == 0) {
		return(_c_str)
	}
	real	scalar	i

	check_dim(color)
	for (i=1; i<=_cols; i++) {
		if (strlen(color[i])) {
			_c_str[i] = _tab_check_color(color[i])
		}
	}
	valid	= .
}

function _tab::reset_color_string(|string vector color)
{
	if (args() == 0) {
		return(_c_str)
	}
	real	scalar	i

	check_dim(color)
	for (i=1; i<=_cols; i++) {
		if (strlen(color[i])) {
			_c_str[i] = _tab_check_color(color[i])
		}
	}
	valid	= .
}

function _tab::set_ignore(|string vector ignore)
{
	if (args() == 0) {
		return(_ignore)
	}
	real	scalar	i

	check_dim(ignore)
	for (i=1; i<=_cols; i++) {
		_ignore[i] = ignore[i]
	}
	valid	= .
}

function _tab::set_skip1(|real scalar skip1)
{
	if (args() == 0) {
		return(_skip1)
	}
	if (missing(skip1)) {
		_skip1 = 0
	}
	else {
		_skip1	= skip1 != 0
	}
}

function _tab::set_markdown(|string scalar onoff)
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

function _tab::width_of_table()
{
	real	scalar	i, w

	w = _lmargin
	if(_markdown) {
		/* an extra vbar for left border */
		w++ 
	}
	for (i=1; i<=_cols; i++) {
		w = w + _width[i]
		if (_vbar[i]) {
			w++
		}
	}
	if (_vbar[1+_cols]) {
		w++
	}
	return(w)
}

void _tab::sep(|string scalar type)
{
	real	scalar	len
	string	scalar	left
	string	scalar	middle
	string	scalar	right
	real	scalar	i

	if (args() == 0) {
		type = "middle"
	}
	len = strlen(type)
	if (_markdown) {
		left	= ""
		middle	= "|"
		right	= "|"
	}
	else if (type == bsubstr("top", 1, max((1,len)))) {
		left	= "{c TLC}"
		middle	= "{c TT}"
		right	= "{c TRC}"
	}
	else if (type == bsubstr("middle", 1, max((1,len)))) {
		left	= "{c LT}"
		middle	= "{c +}"
		right	= "{c RT}"
	}
	else if (type == bsubstr("bottom", 1, max((1,len)))) {
		left	= "{c BLC}"
		middle	= "{c BT}"
		right	= "{c BRC}"
	}
	else {
		exit(error(198))
	}
	
	do_lmargin()
	displayas(_c_outline)
	if (_vbar[1]) {
		printf(left)
	}
	printf("{hline %f}", _width[1])
	for (i=2; i<=_cols; i++) {
		if (_vbar[i]) {
			printf(middle)
		}
		printf("{hline %f}", _width[i])
	}
	if (_vbar[_cols+1]) {
		printf(right)
	}
	printf("\n")
}

void _tab::titles(string vector titles)
{
	real	scalar	i

	check_dim(titles)
	validate()
	do_leftborder()
	do_lmargin()
	for (i=1; i<=_cols; i++) {
		do_cell(i, 2, titles[i], .)
	}
	do_cell(_cols+1,3,"", .)
	printf("\n")
}

void _tab::row(real vector num,| string vector str)
{
	if (args() == 1) {
		str = J(1,_cols,"")
	}
	real	scalar	i

	check_dim(num)
	check_dim(str)
	validate()
	do_lmargin()
	for (i=1; i<=_cols; i++) {
		if (strlen(str[i])) {
			do_cell(i, 1, str[i], .)
		}
		else {
			do_cell(i, 0, "", num[i])
		}
	}
	do_cell(_cols+1,3,"",.)
	printf("\n")
}

end
