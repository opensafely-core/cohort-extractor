*! version 2.1.9  11sep2019
program define putexcel
	version 13

	if ("`c(excelsupport)'" != "1") {
		dis as err "putexcel is not supported on this platform."
		exit 198
	}
	if (_caller()<14.1) {
		cap syntax 						///
			anything(name=cellexplist id="cellexplist" equalok)  ///
			using/						///
			[, SHeet(string)				///
			COLWise						///
			MODify						///
			KEEPCELLFormat					///
			locale(string)					///
			REPLACE]
		if _rc {
			if ("`1'" == "set") {
				gettoken subcmd 0 : 0, parse(" ,")
				local 0 `"using `0'"'
				syntax using / [,MODify REPLACE		///
					SHeet(string)			///
					KEEPCELLFormat locale(string)]
				mata : putexcel_adv_set()
			}
			else if ("`1'" == "describe") {
				if ("`2'" != "") {
					di as err "invalid syntax"
					exit 198
				}
				mata : putexcel_adv_describe()
			}
			else if ("`1'" == "clear") {
				if ("`2'" != "") {
					di as err "invalid syntax"
					exit 198
				}
				mata : putexcel_adv_clear()
			}
			else {
				syntax					///
			anything(name=cellexplist id="cellexplist" equalok) ///
				[, SHeet(string)			///
				COLWise]
				mata : putexcel_adv_cellexplist()
			}
		}
		else {
			mata : putexcel()
		}
	}
	else {
		if ("`1'" == "set") {
			gettoken subcmd 0 : 0, parse(" ,")
			local 0 `"using `0'"'
			syntax using / [, REPLACE MODify		///
				SHeet(string asis) locale(string) OPEN]
			mata : putexcel_set_new()
		}
		else if ("`1'" == "describe") {
			if ("`2'" != "") {
				di as err "invalid syntax"
				exit 198
			}
			mata : putexcel_describe_new()
		}
		else if ("`1'" == "clear") {
			if ("`2'" != "") {
				di as err "invalid syntax"
				exit 198
			}
			mata : putexcel_clear_new()
		}
		else if ("`1'" == "close") {
			if ("`2'" != "") {
				di as err "invalid syntax"
				exit 198
			}
			mata : putexcel_close_new()
		}
		else if ("`1'" == "save") {
			if ("`2'" != "") {
				di as err "invalid syntax"
				exit 198
			}
			mata : putexcel_close_new()
		}
		else {
			syntax						///
		anything(name=cellexplist id="cellexplist" equalok)	///
			[,						///
			OVERWRitefmt					///
			asdate						///
			asdatetime					///
			asdatenum					///
			asdatetimenum					///
			names						///
			rownames					///
			colnames					///
			COLWise						///
			NFORmat(string)					///
			script(string)					///
			nobold						///
			noitalic					///
			noUNDERLine					///
			noSTRIKEout					///
			notxtwrap					///
			noSHRINKfit					///
			noFMTLock					///
			noFMTHidden					///
			hcenter						///
			left						///
			right						///
			bottom						///
			top						///
			vcenter						///
			TXTINdent(integer -1)				///
			TXTROtate(integer -1)				///
			font(string asis)				///
			BORDer(string asis)				///
			DBORDer(string asis)				///
			FPATtern(string asis)				///
			merge						///
			unmerge						///
			]
			mata : putexcel_cellexplist_new()
		}
	}
end

local True		1
local False		0

local IS_EXP		0
local IS_MATRIX		1
local IS_RESULTSET	2
local IS_PICTURE	3
local IS_FORMAT_NEW	4
local IS_ETABLE		5

local FMT_NFORMAT	20
local FMT_VALIGN	21
local FMT_HALIGN	22
local FMT_FORMULA	23
local FMT_BORDER	24
local FMT_DBORDER	25
local FMT_FPATTERN	26
local FMT_FONT		27
local FMT_BOLD		28
local FMT_ITALIC	29
local FMT_STRIKEOUT	30
local FMT_UNDERLINE	31
local FMT_SCRIPT	32
local FMT_TXTWRAP	33
local FMT_SHRINKFIT	34
local FMT_TXTROTATE	35
local FMT_TXTINDENT	36
local FMT_FMTLOCK	37
local FMT_FMTHIDDEN	38

local XL class xl scalar 
local CEI struct cellexp_info scalar
local EI struct exp_info scalar
local EVI struct eval_info scalar
local MI struct matrix_info scalar
local RSI struct resultset_info scalar
local RI struct return_info scalar
local PI struct picture_info scalar
local FI struct format_info scalar
local BI struct border_info scalar
local DBI struct dborder_info scalar
local FPI struct fpattern_info scalar
local FTI struct font_info scalar
local PIN struct parse_info scalar 
local PEI struct parse_export_info scalar 
local FIN struct format_info_new scalar 
local ETABI struct etable_info scalar 
local ETI struct _etable_info scalar
local ETIR struct _etable_info vector

version 12.0

mata:
mata set matastrict on


// ============================================================================
// Structures
// ============================================================================

struct parse_info {
	pointer(`XL') scalar  		xl_class
	string scalar			filename
	string scalar			op_sheet
	string scalar			op_locale
	real scalar			op_sheetreplace
	real scalar			op_sheetnogrid
	real scalar			op_colwise
	real scalar			op_modify
	real scalar			op_replace
	real scalar			op_keepcellformat
	real scalar			op_open
	real scalar			is_xlsx
	real scalar			is_new_syntax
	pointer(`FIN') scalar		fin
	pointer(`PEI') scalar		pei
	pointer(`CEI') rowvector	cei
}

struct cellexp_info {
	struct cell_info scalar ci
	struct exp_info scalar ei
}

struct cell_info {
	string scalar		cell
	real scalar		ul_cell_col
	real scalar		ul_cell_row
	real scalar		lr_cell_col
	real scalar		lr_cell_row
}

struct exp_info {
	string scalar		expression
	real scalar		exp_type
	pointer(`EVI') scalar	evi
	pointer(`MI') scalar	mi
	pointer(`RSI') scalar	rsi
	pointer(`FI') scalar	fi		//NOT USED IN 14.1
	pointer(`PI') scalar	pi
	pointer(`ETABI') scalar	etab
}

struct eval_info {
	string scalar		eval_str_scalar
	real scalar		eval_num_scalar
	real scalar		is_str_scalar
	real scalar		asdate
	real scalar		asdatetime
	real scalar		asdatenum
	real scalar		asdatetimenum
}

struct matrix_info {
	real matrix		eval_mat
	string matrix		eval_mat_row_stripes
	string matrix		eval_mat_col_stripes
	real scalar		names
	real scalar		rownames
	real scalar		colnames
}

struct resultset_info {
	string scalar		resultset_cat
	string scalar		resultset_subcat
	real scalar		is_resultset_names
	pointer(`RI') rowvector ri
}

struct return_info {
	string scalar		type
	string scalar		name
	real scalar		ret_scalar
	string scalar		ret_macro
	real matrix		ret_matrix
	string colvector	return_names
	real scalar		cell_ul_col
	real scalar		cell_ul_row
	real scalar		cell_lr_col
	real scalar		cell_lr_row
}

struct picture_info {
	string scalar		pfile
}

struct format_info {
	string scalar		fmt
	real scalar		format_num_arg
	pointer(`BI') scalar	bi
	pointer(`DBI') scalar	dbi
	pointer(`FPI') scalar	fpi
	pointer(`FTI') scalar	fti
}

struct border_info {
	string scalar		border
	string scalar		style
	string scalar		color
}

struct dborder_info {
	string scalar		direction
	string scalar		style
	string scalar		color
}

struct fpattern_info {
	string scalar		pattern
	string scalar		fg_color
	string scalar		bg_color
}

struct font_info {
	string scalar		name
	real scalar		size
	string scalar		color
}

// ============================================================================
// New Syntax Structures
// ============================================================================

struct parse_export_info {
	real scalar		op_overwrite_fmt
	real scalar		op_asdate
	real scalar		op_asdatetime
	real scalar		op_asdatenum
	real scalar		op_asdatetimenum
	real scalar		op_names
	real scalar		op_rownames
	real scalar		op_colnames
}

struct format_info_new {
	string scalar		op_nformat
	string scalar		op_bold
	string scalar		op_italic
	string scalar		op_underline
	string scalar		op_script
	string scalar		op_txtwrap
	string scalar		op_shrinkfit
	string scalar		op_strikeout
	string scalar		halign
	string scalar		valign
	string scalar		op_fmtlock
	string scalar		op_fmthidden
	real scalar		op_txtindent
	real scalar		op_txtrotate
	real scalar		op_merge
	pointer(`BI') scalar	bi
	pointer(`DBI') scalar	dbi
	pointer(`FPI') scalar	fpi
	pointer(`FTI') scalar	fti
}

struct etable_info {
	real scalar		etcount
	`ETIR'			etir
}

// ============================================================================
// Main
// ============================================================================

void putexcel()
{
	struct parse_info scalar pr

	(void) putexcel_parse_info_init(pr)
	(void) putexcel_parse_syntax(pr)
//	(void) putexcel_dump_parse_info(pr)
	(void) putexcel_write_data(pr)
}

// ============================================================================
// Initializations
// ============================================================================

void putexcel_parse_info_init(struct parse_info scalar pr)
{
	class xl		xl

	xl = xl()

	pr.xl_class = &xl
	pr.filename = ""
	pr.op_sheet = "Sheet1"
	pr.op_locale = "UTF-8"
	pr.op_sheetreplace = 0
	pr.op_sheetnogrid = .
	pr.op_colwise = 0
	pr.op_modify = 0
	pr.op_replace = 0
	pr.op_keepcellformat = 0
	pr.op_open = 0
	pr.is_xlsx = 1
	pr.is_new_syntax = 0
}

void putexcel_cellexp_info_init(`CEI' cei)
{
	cei.ci.cell = ""
	cei.ci.ul_cell_col = -1
	cei.ci.ul_cell_row = -1
	cei.ci.lr_cell_col = -1
	cei.ci.lr_cell_row = -1

	cei.ei.expression = ""
	cei.ei.exp_type = 0
	cei.ei.evi = J(1, 1, NULL)
	cei.ei.mi = J(1, 1, NULL)
	cei.ei.rsi = J(1, 1, NULL)
	cei.ei.fi = J(1, 1, NULL)
}

void putexcel_eval_info_init(`EVI' evi)
{
	evi.eval_str_scalar = ""
	evi.eval_num_scalar = .
	evi.is_str_scalar = 0
	evi.asdate = 0
	evi.asdatetime = 0
	evi.asdatenum = 0
	evi.asdatetimenum = 0
}

void putexcel_matrix_info_init(`MI' mi)
{
	mi.eval_mat = J(0,0,.)
	mi.eval_mat_row_stripes = J(0,0,"")
	mi.eval_mat_col_stripes = J(0,0,"")
	mi.names = 0
	mi.rownames = 0
	mi.colnames = 0
}

void putexcel_resultset_info_init(`RSI' rsi)
{
	rsi.resultset_cat = ""
	rsi.resultset_subcat = ""
	rsi.is_resultset_names = 0
}

void putexcel_return_info_init(`RI' ri)
{
	ri.type = ""
	ri.name = ""
	ri.ret_scalar = .
	ri.ret_macro = ""
	ri.ret_matrix = J(0,0,.)
	ri.return_names = J(0,1,"")
	ri.cell_ul_col = .
	ri.cell_ul_row = .
	ri.cell_lr_col = .
	ri.cell_lr_row = .
}

void putexcel_picture_info_init(`PI' pi)
{
	pi.pfile = ""
}

void putexcel_format_info_init(`FI' fi)
{
	fi.fmt = ""
	fi.format_num_arg = .
	fi.bi = J(1, 1, NULL)
	fi.dbi = J(1, 1, NULL)
	fi.fpi = J(1, 1, NULL)
	fi.fti = J(1, 1, NULL)
}

// ============================================================================
// Parsing options
// ============================================================================

void putexcel_parse_syntax(struct parse_info scalar pr)
{
	(void) putexcel_build_filename(pr)

	pr.op_colwise = (st_local("colwise") != "")
	pr.op_modify = (st_local("modify") != "")
	pr.op_keepcellformat = (st_local("keepcellformat") != "")
	pr.op_replace = (st_local("replace") != "")

	if (pr.op_modify & pr.op_replace) {
		errprintf(`"options {bf:modify} and {bf:replace} "')
		errprintf(`"are mutually exclusive\n"')
		exit(198)
	}
	if (st_local("sheet") != "") {
		(void) putexcel_parse_sheet(pr)
	}
	if (st_local("locale") != "") {
		pr.op_locale = st_local("locale")
	}

	(void) putexcel_parse_cellexplist(pr)
}

void putexcel_build_filename(struct parse_info scalar pr)
{
	string scalar		default_filetype
	string scalar		using_file, file, path, ext
	string scalar		HoldPWD, basename
	real scalar		rc

	using_file = st_local("using")
	basename = pathbasename(using_file)

	if (basename=="") {
		errprintf("%s not a valid filename\n", using_file)
		exit(198)
	}

	if (bsubstr(using_file, 1, 1)=="~") {
		if (st_global("c(os)") != "Windows") {
			path = ""
			file = ""
			(void) pathsplit(using_file, path, file)
			HoldPWD = pwd()
			rc = _chdir(path)
			if (rc == 0) {
				path = pwd()
			}
			else {
				errprintf("invalid path :%s", path)
				exit(170)
			}
			chdir(HoldPWD)
			using_file = path + file
		}
	}

	default_filetype = ".xlsx"
	if (pathsuffix(using_file) == "") {
		using_file = using_file + default_filetype
	}
	pr.filename = using_file
	ext =  strlower(strreverse(pr.filename))
	if (bsubstr(ext, 1, 4)=="slx.") {
		pr.is_xlsx = 0
	}
	else {
		pr.is_xlsx = 1
	}
}

void putexcel_parse_sheet(struct parse_info scalar pr)
{
	transmorphic		t
	string scalar		tmpstr, token, sheet

	tmpstr = st_local("sheet")
	t = tokeninit("", `","', (`""""', `"`""'"'), 0, 0)
	tokenset(t, tmpstr)
	sheet = strtrim(tokenget(t))
	sheet = putexcel_remove_quote(sheet)

	pr.op_sheet = sheet
	(void) tokenget(t) // comma

	tokenwchars(t, `" "')
	tokenpchars(t, `" "')

	for (token=tokenget(t); token != "";token = tokenget(t)) {
		if (token == "replace") {
			pr.op_sheetreplace = 1
		}
		else if (token == "nogrid") {
			pr.op_sheetnogrid = 1
		}
		else if (token == "grid") {
			pr.op_sheetnogrid = 0
		}
		else {
errprintf("{bf:%s}: is invalid {bf:sheet()} argument; use {bf:replace}", token)
			 exit(198)
		}
	}
}

// ============================================================================
// Parsing cellexplist --- (cell)=(exp)|matrix(exp)|resultset|etable(string)
// ============================================================================

void putexcel_parse_cellexplist(struct parse_info scalar pr)
{
	transmorphic		t
	string scalar		cellexplist, token, cell
	real scalar		fmtid

	cellexplist = st_local("cellexplist")

	if (cellexplist == "") {
		errprintf("{bf:cellexplist} is required\n")
		exit(198)
	}
	if (pr.is_new_syntax) {
		t = tokeninit(" ", `"="', (`"()"', `""""',  `"`""'"'))
	}
	else {
		t = tokeninit(" ", `"="', (`"()"', `""""'))
	}
	tokenset(t, cellexplist)

	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (tokenpeek(t)=="=") {
			(void) tokenget(t)
			cell = token
			token = tokenget(t)
			if (token=="") {
	errprintf("nothing found where expression expected\n")
				exit(198)
			}
			else if (token == "mat" | token == "matr" |
				token == "matri" | token == "matrix") {
				token = tokenget(t)
				if (!putexcel_check_paren(token)) {
	errprintf("%s: matrix expression must be enclosed in ()\n", token)
					exit(198)
				}
				(void) putexcel_add_cellexplist(pr, cell, token,
					`IS_MATRIX')
			}
			else if (token == "etable") {
				if (pr.is_new_syntax) {
					token = tokenget(t)
					(void) putexcel_add_cellexplist(pr,
						cell, token, `IS_ETABLE')
				}	
			}
			else if (putexcel_get_resultset(token)) {
				(void) putexcel_add_cellexplist(pr, cell, token,
					`IS_RESULTSET')
			}
			else if (fmtid = putexcel_get_format_option(token)) {
				token = tokenget(t)
				if (!putexcel_check_paren(token)) {
	errprintf("%s: format must be enclosed in ()\n", token)
					exit(198)
				}
				if (pr.is_new_syntax && fmtid !=`FMT_FORMULA') {
					errprintf("invalid syntax\n")
					exit(198)
					
				}
				(void) putexcel_add_cellexplist(pr, cell, token,
					fmtid)
			}
			else if (token == "pic" | token == "pict" |
				token == "pictu" | token == "pictur" |
				token == "picture" | token == "image") {
				token = tokenget(t)
				if (!putexcel_check_paren(token)) {
	errprintf("%s: picture must be enclosed in ()\n", token)
					exit(198)
				}
				(void) putexcel_add_cellexplist(pr, cell, token,
					`IS_PICTURE')
			}
			else {
				(void) putexcel_add_cellexplist(pr,
						cell, token, `IS_EXP')
			}
		}
		else {
			if (pr.is_new_syntax) {
				(void) putexcel_add_cellexplist(pr, token,
					"", `IS_FORMAT_NEW')
			}
			else {
				errprintf("{bf:%s}: invalid cell name\n", token)
				exit(198)
			}
		}
	}
}

real putexcel_get_resultset(string scalar token)
{
	real scalar		bool

	bool = `False'

	if (token == "escal" | token == "escala" | token == "escalar" |
		token == "escalars" | token == "rscal" | token == "rscala" |
		token == "rscalar" | token == "rscalars" | token == "emac" |
		token == "emacr" | token == "emacro" | token == "emacros" |
		token == "rmac" | token == "rmacr" | token == "rmacro" |
		token == "rmacros" | token == "emat" | token == "ematr" |
		token == "ematri" | token == "ematric" | token == "ematrice" |
		token == "ematrices" | token == "rmat" | token == "rmatr" |
		token == "rmatri" | token == "rmatric" | token == "rmatrice" |
		token == "rmatrices" | token == "e*" | token == "r*" |
		token == "escalarn" | token == "escalarna" |
		token == "escalarnam" | token  == "escalarname" |
		token  == "escalarnames" | token == "rscalarn" |
		token == "rscalarna" | token == "rscalarnam" |
		token  == "rscalarname" | token  == "rscalarnames" |
		token == "emacron" | token == "emacrona" |
		token == "emacronam" | token  == "emacroname" |
		token  == "emacronames" | token == "rmacron" |
		token == "rmacrona" | token == "rmacronam" |
		token  == "rmacroname" | token  == "rmacronames" |
		token == "ematrixn" | token == "ematrixna" |
		token == "ematrixnam" | token  == "ematrixname" |
		token  == "ematrixnames" | token == "rmatrixn" |
		token == "rmatrixna" | token == "rmatrixnam" |
		token  == "rmatrixname" | token  == "rmatrixnames" |
		token == "ena" | token == "enam" |
		token == "ename" | token  == "enames" |
		token == "rna" | token == "rnam" |
		token == "rname" | token  == "rnames") {
		bool = `True'
	}
	return(bool)
}

real putexcel_get_format_option(string scalar token)
{
	real scalar		fmtid

	fmtid = 0

	if (token == "nfor" | token == "nform" |
		token == "nforma" | token == "nformat") {
		fmtid = `FMT_NFORMAT'
	}
	else if(token == "vali" | token == "valig" |
		token == "valign") {
		fmtid = `FMT_VALIGN'
	}
	else if (token == "hali" | token == "halig" |
		token == "halign") {
		fmtid = `FMT_HALIGN'
	}
	else if (token == "form" | token == "formu" |
		token == "formul" | token == "formula") {
		fmtid = `FMT_FORMULA'
	}
	else if (token == "bor" | token == "bord" |
		token == "borde" | token == "border") {
		fmtid = `FMT_BORDER'
	}
	else if (token == "dbor" | token == "dbord" |
		token == "dborde" | token == "dborder") {
		fmtid = `FMT_DBORDER'
	}
	else if (token == "fpat" | token == "fpatt" |
		token == "fpatte" | token == "fpatter" |
		token == "fpattern") {
		fmtid = `FMT_FPATTERN'
	}
	else if (token == "fon" | token == "font") {
		fmtid = `FMT_FONT'
	}
	else if (token == "bol" | token == "bold") {
		fmtid = `FMT_BOLD'
	}
	else if (token == "ital" | token == "itali" |
		token == "italic") {
		fmtid = `FMT_ITALIC'
	}
	else if (token == "strike" | token == "strikeo" |
		token == "strikeou" | token == "strikeout") {
		fmtid = `FMT_STRIKEOUT'
	}
	else if (token == "under" | token == "underl" |
		token == "underli" | token == "underlin" |
		token == "underline") {
		fmtid = `FMT_UNDERLINE'
	}
	else if (token == "scri" | token == "scrip" |
		token == "script") {
		fmtid = `FMT_SCRIPT'
	}
	else if (token == "txtwr" | token == "txtwra" |
		token == "txtwrap") {
		fmtid = `FMT_TXTWRAP'
	}
	else if (token == "shrink" | token == "shrinkf" |
		token == "shrinkfi" | token == "shrinkfit") {
		fmtid = `FMT_SHRINKFIT'
	}
	else if (token == "txtro" | token == "txtrot" |
		token == "txtrota" | token == "txtrotat" |
		token == "txtrotate") {
		fmtid = `FMT_TXTROTATE'
	}
	else if (token == "txtin" | token == "txtind" |
		token == "txtinde" | token == "txtinden" |
		token == "txtindent") {
		fmtid = `FMT_TXTINDENT'
	}
	else if (token == "fmtl" | token == "fmtlo" |
		token == "fmtloc" | token == "fmtlock") {
		fmtid = `FMT_FMTLOCK'
	}
	else if (token == "fmth" | token == "fmthi" |
		token == "fmthid" | token == "frthidd" |
		token == "fmthidde" | token == "fmthidden") {
		fmtid = `FMT_FMTHIDDEN'
	}

	return(fmtid)
}

void putexcel_add_cellexplist(struct parse_info scalar pr,
	string scalar cell, string scalar expression, real scalar exp_type)
{
	real scalar		i

	i = length(pr.cei)
	i++
	pr.cei = pr.cei, J(1, 1, NULL)
	pr.cei[i] = &(cellexp_info())

	(void) putexcel_cellexp_info_init(*(pr.cei[i]))

	pr.cei[i]->ci.cell = putexcel_remove_paren(strtrim(cell))
	pr.cei[i]->ei.expression = strtrim(expression)
	pr.cei[i]->ei.exp_type = exp_type

	(void) putexcel_get_cell_info(*(pr.cei[i]), pr.xl_class, pr.is_xlsx)
	(void) putexcel_get_exp_info(*(pr.cei[i]), pr)
}

// ============================================================================
// Parse cell info
// ============================================================================

void putexcel_get_cell_info(`CEI' cei, pointer(`XL') scalar xl_class,
        real scalar is_xlsx)
{
	real rowvector		col_row
	string scalar		cells, cell1, cell2

	cells = cei.ci.cell

	if (strpos(cells, ":")>0) {
		cell1 = bsubstr(cells, 1, strpos(cells, ":")-1)

		col_row = putexcel_get_col_row_from_cell(xl_class, cell1)
		(void) putexcel_check_cell_range(is_xlsx, xl_class,
			col_row, cell1)

		cei.ci.ul_cell_col = col_row[1,1]
		cei.ci.ul_cell_row = col_row[1,2]

		cell2 = bsubstr(cells, strpos(cells, ":")+1, .)

		col_row = putexcel_get_col_row_from_cell(xl_class, cell2)
		(void) putexcel_check_cell_range(is_xlsx, xl_class,
			col_row, cell2)

		cei.ci.lr_cell_col = col_row[1,1]
		cei.ci.lr_cell_row = col_row[1,2]

		if (cei.ci.ul_cell_col > cei.ci.lr_cell_col) {
			errprintf("{bf:%s} invalid column range\n", cells)
		errprintf("upper left column is right of lower right column\n")
			 exit(198)
		}

		if (cei.ci.ul_cell_row > cei.ci.lr_cell_row) {
			errprintf("{bf:%s} invalid row range in\n", cells)
			errprintf("upper left row is after lower right row\n")
			exit(198)
		}
	}
	else {
		col_row = putexcel_get_col_row_from_cell(xl_class, cells)
		(void) putexcel_check_cell_range(is_xlsx, xl_class,
			col_row, cells)

		cei.ci.ul_cell_col = col_row[1,1]
		cei.ci.ul_cell_row = col_row[1,2]
	}
}

// ============================================================================
// Parse exp info
// ============================================================================

void putexcel_get_exp_info(`CEI' cei, struct parse_info scalar pr)
{

	if (cei.ei.exp_type == `IS_EXP') {
		(void) putexcel_is_exp(cei.ei, pr)
	}
	else if (cei.ei.exp_type == `IS_MATRIX') {
		if (cei.ci.lr_cell_row != -1) {
			errprintf("Cannot use a cell range with matrix()\n")
			exit(198)
		}
		(void) putexcel_is_matrix(cei, pr)
	}
	else if (cei.ei.exp_type == `IS_RESULTSET') {
		if (cei.ci.lr_cell_row != -1) {
		errprintf("Cannot use a cell range with a resultset()\n")
			exit(198)
		}
		(void) putexcel_is_resultset(cei.ei)
		(void) putexcel_get_return_info(cei, pr.xl_class,
			pr.is_xlsx, pr.op_colwise)
	}
	else if (cei.ei.exp_type >= `FMT_NFORMAT') {
		putexcel_is_format(cei.ei, pr.xl_class, pr.is_new_syntax)
	}
	else if (cei.ei.exp_type == `IS_FORMAT_NEW') {
		if (!putexcel_is_new_format(*(pr.fin))) {
			errprintf("no format option specified\n")
			exit(198)
		}
	}
	else if (cei.ei.exp_type == `IS_PICTURE') {
		if (cei.ci.lr_cell_row != -1) {
			errprintf("Cannot use a cell range with picture()\n")
			exit(198)
		}
		(void) putexcel_is_picture(cei.ei)
	}
	else if (cei.ei.exp_type == `IS_ETABLE') {
		if (cei.ci.lr_cell_row != -1) {
			errprintf("Cannot use a cell range with etable()\n")
			exit(198)
		}
		(void) putexcel_is_new_etable(cei)
	}
	else {
		errprintf("invalid cellexplist()\n")
		exit(198)
	}
}

void putexcel_is_exp(`EI' ei, struct parse_info scalar pr)
{
	string scalar		expression, rev, new_exp, tmpname
	real scalar		rc

	expression = ei.expression

	if (!pr.is_new_syntax) {
		if (!putexcel_check_paren(expression)) {
		errprintf("%s: expression must be enclosed in ()\n", expression)
			exit(198)
		}
	}

	rev = strreverse(expression)
	rev = subinstr(bsubstr(rev, 1, strpos(rev, ",")-1), " ", "", .)

	ei.evi = &(eval_info())
	(void) putexcel_eval_info_init(*(ei.evi))

	if (pr.is_new_syntax) {
		if (pr.pei->op_asdate) {
			ei.evi->asdate = 1
		}
		else if (pr.pei->op_asdatetime) {
			ei.evi->asdatetime = 1
		}
		else if (pr.pei->op_asdatenum) {
			ei.evi->asdatenum = 1
		}
		else if (pr.pei->op_asdatetimenum) {
			ei.evi->asdatetimenum = 1
		}
	}
	else {
		if (rev == ")etadsa") {
			ei.evi->asdate = 1
		}
		else if (rev == ")emitetadsa") {
			ei.evi->asdatetime = 1
		}
		if (ei.evi->asdate | ei.evi->asdatetime) {
			rev =  strreverse(expression)
			new_exp = strreverse(bsubstr(rev,strpos(rev, ",")+1,.))
			expression = new_exp
		}
	}

	expression = putexcel_remove_paren(expression)

	tmpname = st_tempname()
	rc = _stata(sprintf("scalar %s = %s", tmpname, expression))
	if (rc) {
		exit(rc)
	}

	if (st_numscalar(tmpname)==J(0,0,.)) {
		if (ei.evi->asdate | ei.evi->asdatetime | ei.evi->asdatenum | 
			ei.evi->asdatetimenum) {
			errprintf("%s: invalid date\n", expression)
			exit(198)

		}
		ei.evi->eval_str_scalar = st_strscalar(tmpname)
		ei.evi->is_str_scalar = 1
	}
	else {
		ei.evi->eval_num_scalar = st_numscalar(tmpname)
	}
}

void putexcel_is_matrix(`CEI' cei, struct parse_info scalar pr)
{
	real scalar		rc
	string scalar		expression, new_exp, rev, tmpname
	real scalar		row_stripe_space, col_stripe_space, rows, cols

	expression = cei.ei.expression
	rev = strreverse(expression)
	rev = stritrim(strtrim(bsubstr(rev, 1, strpos(rev, ",")-1)))

	cei.ei.mi = &(matrix_info())
	(void) putexcel_matrix_info_init(*(cei.ei.mi))

	if (pr.is_new_syntax) {
		if (pr.pei->op_names) {
			cei.ei.mi->names = 1
		}
		else if (pr.pei->op_rownames) {
			cei.ei.mi->rownames = 1
		}
		else if (pr.pei->op_colnames) {
			cei.ei.mi->colnames = 1
		}
	}
	else {
		if (rev == ")seman") {
			cei.ei.mi->names = 1
		}
		else if (rev == ")semanwor") {
			cei.ei.mi->rownames = 1
		}
		else if (rev == ")semanloc") {
			cei.ei.mi->colnames = 1
		}
		if (cei.ei.mi->names | cei.ei.mi->colnames |
			cei.ei.mi->rownames) {
			rev = strreverse(expression)
			new_exp = strreverse(bsubstr(rev,strpos(rev, ",")+1, .))
			new_exp = bsubstr(new_exp, strpos(new_exp, "(") +1, .)
			expression = new_exp
		}
	}

	tmpname = st_tempname()

	rc = _stata(sprintf("matrix define %s = %s", tmpname, expression))
	if (rc) {
		exit(rc)
	}

	cei.ei.mi->eval_mat = st_matrix(tmpname)

	row_stripe_space = 0
	col_stripe_space = 0

	if (cei.ei.mi->names) {
		cei.ei.mi->eval_mat_row_stripes=putexcel_get_matrix_stripes(
			tmpname,0)
		cei.ei.mi->eval_mat_col_stripes=putexcel_get_matrix_stripes(
			tmpname,1)
		row_stripe_space = cols(cei.ei.mi->eval_mat_row_stripes)
		col_stripe_space = rows(cei.ei.mi->eval_mat_col_stripes)
	}
	else if (cei.ei.mi->rownames) {
		cei.ei.mi->eval_mat_row_stripes=putexcel_get_matrix_stripes(
			tmpname,0)
		row_stripe_space = cols(cei.ei.mi->eval_mat_row_stripes)
	}
	else if (cei.ei.mi->colnames) {
		cei.ei.mi->eval_mat_col_stripes=putexcel_get_matrix_stripes(
			tmpname,1)
		col_stripe_space = rows(cei.ei.mi->eval_mat_col_stripes)
	}

	rows = cei.ci.ul_cell_row + rows(cei.ei.mi->eval_mat) +
		col_stripe_space - 1
	cei.ci.lr_cell_row = rows

	if (!(pr.xl_class->is_valid_row(pr.is_xlsx, rows))) {
		errprintf("matrix rows out of Excel file range\n")
		exit(198)
	}

	cols = cei.ci.ul_cell_col + cols(cei.ei.mi->eval_mat) +
		row_stripe_space - 1
	cei.ci.lr_cell_col = cols
	if (!(pr.xl_class->is_valid_col(pr.is_xlsx, cols))) {
		errprintf("matrix columns out of Excel file range\n")
		exit(198)
	}
}

string matrix putexcel_get_matrix_stripes(string scalar matname,
	real scalar col_stripes)
{
	real scalar		i
	real rowvector		sums
	string matrix		stripes, ret_mat

	if (col_stripes) {
		stripes = st_matrixcolstripe(matname)
	}
	else {
		stripes = st_matrixrowstripe(matname)
	}

	sums = colsum(strlen(stripes))
	ret_mat = J(rows(stripes),0,"")

	for(i=1; i<=cols(sums); i++) {
		if (sums[i] != 0) {
			ret_mat = ret_mat, stripes[.,i]
		}
	}
	if(col_stripes) {
		ret_mat = ret_mat'
	}

	return(ret_mat)
}

void putexcel_is_resultset(`EI' ei)
{
	string scalar		resultset

	ei.rsi = &(resultset_info())
	resultset = ei.expression

	if (resultset == "escal" | resultset == "escala" |
		resultset == "escalar" | resultset == "escalars") {
		ei.rsi->is_resultset_names = `False'
		ei.rsi->resultset_cat = "e()"
		ei.rsi->resultset_subcat = "numscalar"
	}
	else if (resultset == "rscal" | resultset == "rscala" |
		resultset == "rscalar" | resultset == "rscalars") {
		ei.rsi->is_resultset_names = `False'
		ei.rsi->resultset_cat = "r()"
		ei.rsi->resultset_subcat = "numscalar"
	}
	else if (resultset == "emac" | resultset == "emacr" |
		resultset == "emacro" | resultset == "emacros") {
		ei.rsi->is_resultset_names = `False'
		ei.rsi->resultset_cat = "e()"
		ei.rsi->resultset_subcat = "macro"
	}
	 else if (resultset == "rmac" | resultset == "rmacr" |
		resultset == "rmacro" | resultset == "rmacros") {
		ei.rsi->is_resultset_names = `False'
		ei.rsi->resultset_cat = "r()"
		ei.rsi->resultset_subcat = "macro"
	}
	 else if (resultset == "emat" | resultset == "ematr" |
		resultset == "ematri" | resultset == "ematric" |
		resultset == "ematrice" | resultset == "ematrices") {
		ei.rsi->is_resultset_names = `False'
		ei.rsi->resultset_cat = "e()"
		ei.rsi->resultset_subcat = "matrix"
	}
	 else if (resultset == "rmat" | resultset == "rmatr" |
		resultset == "rmatri" | resultset == "rmatric" |
		resultset == "rmatrice" | resultset == "rmatrices") {
		ei.rsi->is_resultset_names = `False'
		ei.rsi->resultset_cat = "r()"
		ei.rsi->resultset_subcat = "matrix"
	}
	 else if (resultset == "e*") {
		ei.rsi->is_resultset_names = `False'
		ei.rsi->resultset_cat = "e()"
		ei.rsi->resultset_subcat = "all"
	}
	else if (resultset == "r*") {
		ei.rsi->is_resultset_names = `False'
		ei.rsi->resultset_cat = "r()"
		ei.rsi->resultset_subcat = "all"
	}
	else if (resultset == "escalarn" | resultset == "escalarna" |
		resultset == "escalarnam" | resultset  == "escalarname" |
		resultset  == "escalarnames") {
		ei.rsi->is_resultset_names = `True'
		ei.rsi->resultset_cat = "e()"
		ei.rsi->resultset_subcat = "numscalar"
	}
	else if (resultset == "rscalarn" | resultset == "rscalarna" |
		resultset == "rscalarnam" | resultset  == "rscalarname" |
		resultset  == "rscalarnames") {
		ei.rsi->is_resultset_names = `True'
		ei.rsi->resultset_cat = "r()"
		ei.rsi->resultset_subcat = "numscalar"
	}
	else if (resultset == "emacron" | resultset == "emacrona" |
		resultset == "emacronam" | resultset  == "emacroname" |
		resultset  == "emacronames") {
		ei.rsi->is_resultset_names = `True'
		ei.rsi->resultset_cat = "e()"
		ei.rsi->resultset_subcat = "macro"
	}
	else if (resultset == "rmacron" | resultset == "rmacrona" |
		resultset == "rmacronam" | resultset  == "rmacroname" |
		resultset  == "rmacronames") {
		ei.rsi->is_resultset_names = `True'
		ei.rsi->resultset_cat = "r()"
		ei.rsi->resultset_subcat = "macro"
	}
	else if (resultset == "ematrixn" | resultset == "ematrixna" |
		resultset == "ematrixnam" | resultset  == "ematrixname" |
		resultset  == "ematrixnames") {
		ei.rsi->is_resultset_names = `True'
		ei.rsi->resultset_cat = "e()"
		ei.rsi->resultset_subcat = "matrix"
	}
	else if (resultset == "rmatrixn" | resultset == "rmatrixna" |
		resultset == "rmatrixnam" | resultset  == "rmatrixname" |
		resultset  == "rmatrixnames") {
		ei.rsi->is_resultset_names = `True'
		ei.rsi->resultset_cat = "r()"
		ei.rsi->resultset_subcat = "matrix"
	}
	else if (resultset == "ena" | resultset == "enam" |
		resultset == "ename" | resultset  == "enames") {
		ei.rsi->is_resultset_names = `True'
		ei.rsi->resultset_cat = "e()"
		ei.rsi->resultset_subcat = "all"
	}
	else if (resultset == "rna" | resultset == "rnam" |
		resultset == "rname" | resultset  == "rnames") {
		ei.rsi->is_resultset_names = `True'
		ei.rsi->resultset_cat = "r()"
		ei.rsi->resultset_subcat = "all"
	}
}

void putexcel_get_return_info(`CEI' cei, pointer(`XL') scalar xl_class,
	real scalar is_xlsx, real scalar colwise)
{
	real scalar		i, start_col, start_row
	pointer scalar		pstart_col, pstart_row
	string scalar		cat, subcat

	i = length(cei.ei.rsi->ri)

	if (i == 0) {
		start_col = cei.ci.ul_cell_col
		start_row = cei.ci.ul_cell_row
	}
	else {
		start_col = cei.ei.rsi->ri[i]->cell_lr_col
		start_row = cei.ei.rsi->ri[i]->cell_lr_row
		if (colwise) {
			start_col++
		}
		else {
			start_row++
		}
	}

	pstart_col = &start_col
	pstart_row = &start_row

	cat = cei.ei.rsi->resultset_cat
	subcat = cei.ei.rsi->resultset_subcat

	if (cei.ei.rsi->is_resultset_names) {
		(void) putexcel_add_returnnames_info(cei.ei.rsi->ri, cat,
			subcat, start_row, start_col, colwise, xl_class,
			is_xlsx)
	}
	else if (subcat == "all") {
		(void) putexcel_add_return_info(cei.ei.rsi->ri, cat,
			"numscalar", *pstart_row, *pstart_col, colwise,
			xl_class, is_xlsx)
		(void) putexcel_add_return_info(cei.ei.rsi->ri, cat, "macro",
			*pstart_row, *pstart_col, colwise, xl_class, is_xlsx)
		(void) putexcel_add_return_info(cei.ei.rsi->ri, cat, "matrix",
			*pstart_row, *pstart_col, colwise, xl_class, is_xlsx)
	}
	else {
		(void) putexcel_add_return_info(cei.ei.rsi->ri, cat, subcat,
			*pstart_row, *pstart_col, colwise, xl_class, is_xlsx)
	}
}

void putexcel_add_returnnames_info(pointer(`RI') rowvector ri,string scalar cat,
	string scalar subcat, real scalar start_row, real scalar start_col,
	real scalar colwise, pointer(`XL') scalar xl_class,
	real scalar is_xlsx)
{
	real scalar		i, rows, cols
	string colvector	return_names, tmp_return_names

	if (subcat == "all" ) {
		return_names = st_dir(cat, "numscalar", "*")
		tmp_return_names =  st_dir(cat, "macro", "*")
		return_names = return_names \ tmp_return_names
		tmp_return_names =  st_dir(cat, "matrix", "*")
		return_names = return_names \ tmp_return_names
	}
	else {
		return_names = st_dir(cat, subcat, "*")
	}

	if (!rows(return_names)) {
		return
	}

	i = length(ri)
	i++

	ri = ri, J(1, 1, NULL)
	ri[i] = &(return_info())
	(void) putexcel_return_info_init(*(ri[i]))

	ri[i]->return_names = return_names
	ri[i]->cell_ul_col = start_col
	ri[i]->cell_ul_row = start_row

	rows = start_row + rows(return_names)
	cols = start_col + rows(return_names)

	if (colwise) {
		if (!(xl_class->is_valid_col(is_xlsx, cols))) {
	errprintf("return values columns out of Excel file range\n")
			exit(198)
		}
		ri[i]->cell_lr_col = cols
	}
	else {
		if (!(xl_class->is_valid_row(is_xlsx, rows))) {
	errprintf("return values rows out of Excel file range\n")
			exit(198)
		}
		ri[i]->cell_lr_row = rows
	}
}

void putexcel_add_return_info(pointer(`RI') rowvector ri, string scalar cat,
	string scalar subcat, real scalar start_row, real scalar start_col,
	real scalar colwise, pointer(`XL') scalar xl_class, real scalar is_xlsx)
{
	real scalar		i, j, col, row, mat_cols, mat_rows, rc
	real scalar		is_eclass, vals
	string scalar		return_name, tmpname
	string colvector	return_names

	return_names = st_dir(cat, subcat, "*")

	if (!rows(return_names)) {
		return
	}

	is_eclass = 0
	if (cat=="e()") {
		is_eclass = 1
	}

	i = length(ri)
	i++
	col = start_col
	row = start_row
	j = 1

	vals = i + length(return_names)

	for (i; i<vals; i++) {
		ri = ri, J(1, 1, NULL)
		ri[i] = &(return_info())
		(void) putexcel_return_info_init(*(ri[i]))
		if (is_eclass) {
			return_name = "e(" + return_names[j] + ")"
		}
		else {
			return_name = "r(" + return_names[j] + ")"
		}
		ri[i]->type = subcat
		ri[i]->name = return_name

		tmpname = st_tempname()

		if (subcat == "matrix") {
			rc = _stata(sprintf("matrix define %s = %s",
				tmpname, return_name))
			if (rc) {
				exit(rc)
			}

			ri[i]->ret_matrix = st_matrix(tmpname)
			mat_cols = cols(ri[i]->ret_matrix)
			mat_rows = rows(ri[i]->ret_matrix)

			ri[i]->cell_ul_col = col
			ri[i]->cell_ul_row = row
			ri[i]->cell_lr_col = col + mat_cols
			ri[i]->cell_lr_row = row + mat_rows

			if (colwise) {
				col = col + mat_cols + 1
			}
			else {
				row = row + mat_rows + 1
			}
		}
		else if (subcat == "numscalar") {
			ri[i]->ret_scalar = st_numscalar(return_name)

			ri[i]->cell_ul_col = col
			ri[i]->cell_ul_row = row
			ri[i]->cell_lr_col = col
			ri[i]->cell_lr_row = row

			if (colwise) {
				col++
			}
			else {
				row++
			}
		}
		else {
			ri[i]->ret_macro = st_global(return_name)

			ri[i]->cell_ul_col = col
			ri[i]->cell_ul_row = row
			ri[i]->cell_lr_col = col
			ri[i]->cell_lr_row = row

			if (colwise) {
				col++
			}
			else {
				row++
			}
		}

		if (!(xl_class->is_valid_col(is_xlsx, col))) {
	errprintf("return values columns out of Excel file range\n")
				exit(198)
		}
		if (!(xl_class->is_valid_row(is_xlsx, row))) {
	errprintf("return values rows out of Excel file range\n")
				exit(198)
		}
		j++
	}
	if (colwise) {
		start_col = col + 1
	}
	else {
		start_row = row + 1
	}
}
real scalar putexcel_is_new_format(`FIN' fin)
{
	if (fin.op_nformat == "" && fin.op_bold == "" && fin.op_italic == "" &&
		fin.op_underline == "" && fin.op_script == "" &&
		fin.op_txtwrap == "" && fin.op_shrinkfit == "" &&
		fin.op_strikeout == "" && fin.halign == "" &&
		fin.valign == "" && fin.op_fmtlock == "" &&
		fin.op_fmthidden == "" && fin.op_txtrotate == . &&
		fin.op_txtindent == . &&  fin.bi == J(1, 1, NULL) &&
		fin.op_merge == . && fin.dbi == J(1, 1, NULL) && 
		fin.fpi == J(1, 1, NULL) && fin.fti == J(1, 1, NULL)) {
			return(`False')
	}
	return(`True')
}

void putexcel_is_format(`EI' ei, pointer(`XL') scalar xl_class,
	real scalar is_new_syntax)
{
	real scalar		fmtid, num
	string scalar		fmt

	ei.fi = &(format_info())
	(void) putexcel_format_info_init(*(ei.fi))

	fmtid = ei.exp_type
	fmt = putexcel_remove_paren(ei.expression)
	num = .

	if (strtrim(fmt)=="") {
		errprintf("no format argument specified\n")
		exit(198)
	}

	if (fmtid == `FMT_NFORMAT') {
		(void) putexcel_check_nformat(ei, xl_class)
	}
	else if(fmtid == `FMT_VALIGN') {
		fmt = putexcel_remove_quote(fmt)
		if (fmt!="top" & fmt!="center" & fmt!="bottom" &
			fmt!="justify" & fmt!="distributed") {
			errprintf("{bf:%s}: invalid valign() argument\n", fmt)
			exit(198)
		}
		ei.fi->fmt = fmt
	}
	else if (fmtid == `FMT_HALIGN') {
		fmt = putexcel_remove_quote(fmt)
		if (fmt!="left" & fmt!="center" & fmt!="right" &
			fmt!="fill" & fmt!="justify" & fmt!="distributed" &
			fmt!="merge") {
			errprintf("{bf:%s}: invalid halign() argument\n", fmt)
			exit(198)
		}
		ei.fi->fmt = fmt
	}
	else if (fmtid == `FMT_FORMULA') {
		fmt = strtrim(fmt)
		if (bsubstr(fmt, 1, 1) == "`") {
			fmt = subinstr(fmt, "`", "", 1)
			if (bsubstr(fmt, 1, 1) == `"""') {
				fmt = subinstr(fmt, `"""', "", 1)
			}
			fmt = strreverse(fmt)
			if (bsubstr(fmt, 1, 1) == "'") {
				fmt = subinstr(fmt, "'", "", 1)
			}
			if (bsubstr(fmt, 1, 1) == `"""') {
				fmt = subinstr(fmt, `"""', "", 1)
			}
			fmt = strreverse(fmt)
		}
		else {
			if (bsubstr(fmt, 1, 1) == `"""') {
				fmt = subinstr(fmt, `"""', "", 1)
			}
			fmt = strreverse(fmt)
			if (bsubstr(fmt, 1, 1) == `"""') {
				fmt = subinstr(fmt, `"""', "", 1)
			}
			fmt = strreverse(fmt)
		}
		ei.fi->fmt = fmt
	}
	else if (fmtid == `FMT_BORDER') {
		ei.fi->bi = &(border_info())
		(void) putexcel_check_border(
			putexcel_remove_paren(ei.expression),
			*(ei.fi->bi), xl_class, is_new_syntax)
	}
	else if (fmtid == `FMT_DBORDER') {
		ei.fi->dbi = &(dborder_info())
		(void) putexcel_check_dborder(
			putexcel_remove_paren(ei.expression),
			*(ei.fi->dbi), xl_class, is_new_syntax)
		
	}
	else if (fmtid == `FMT_FPATTERN') {
		ei.fi->fpi = &(fpattern_info())
		(void) putexcel_check_fpattern(
			putexcel_remove_paren(ei.expression),
			*(ei.fi->fpi), xl_class, is_new_syntax)
	}
	else if (fmtid == `FMT_FONT') {
		ei.fi->fti = &(font_info())
		(void) putexcel_check_font(
			putexcel_remove_paren(ei.expression),
			*(ei.fi->fti), xl_class, is_new_syntax)
	}
	else if (fmtid == `FMT_BOLD') {
		fmt = putexcel_remove_quote(fmt)
		(void) putexcel_check_on_off(fmt)
		ei.fi->fmt = fmt
	}
	else if (fmtid == `FMT_ITALIC') {
		fmt = putexcel_remove_quote(fmt)
		(void) putexcel_check_on_off(fmt)
		ei.fi->fmt = fmt
	}
	else if (fmtid == `FMT_STRIKEOUT') {
		fmt = putexcel_remove_quote(fmt)
		(void) putexcel_check_on_off(fmt)
		ei.fi->fmt = fmt
	}
	else if (fmtid == `FMT_UNDERLINE') {
		fmt = putexcel_remove_quote(fmt)
		(void) putexcel_check_on_off(fmt)
		ei.fi->fmt = fmt
	}
	else if (fmtid == `FMT_SCRIPT') {
		fmt = putexcel_remove_quote(fmt)
		if (fmt!="sub" & fmt!="super" & fmt!="normal") {
			errprintf("{bf:%s}: invalid script() argument\n", fmt)
			exit(198)
		}
		ei.fi->fmt = fmt
	}
	else if (fmtid == `FMT_TXTWRAP') {
		fmt = putexcel_remove_quote(fmt)
		(void) putexcel_check_on_off(fmt)
		ei.fi->fmt = fmt
	}
	else if (fmtid == `FMT_SHRINKFIT') {
		fmt = putexcel_remove_quote(fmt)
		(void) putexcel_check_on_off(fmt)
		ei.fi->fmt = fmt
	}
	else if (fmtid == `FMT_TXTROTATE') {
		fmt = putexcel_remove_quote(fmt)
		num = strtoreal(fmt)
		if (missing(num)) {
			errprintf("{bf:%s}: invalid txt_rotate() argument\n",
				fmt)
			exit(198)
		}
		if (num < 0 | num > 180) {
			if (num != 255) {
		errprintf("{bf:%s}: invalid txt_rotate() argument\n", fmt)
				exit(198)
			}
		}
		ei.fi->format_num_arg = num
	}
	else if (fmtid == `FMT_TXTINDENT') {
		fmt = putexcel_remove_quote(fmt)
		num = strtoreal(fmt)
		if (missing(num) | num < 0 | num > 15) {
			errprintf("{bf:%s}: invalid txtindent() argument\n",
				fmt)
			exit(198)
		}

		ei.fi->format_num_arg = num
	}
	else if (fmtid == `FMT_FMTLOCK') {
		fmt = putexcel_remove_quote(fmt)
		(void) putexcel_check_on_off(fmt)
		ei.fi->fmt = fmt
	}
	else if (fmtid == `FMT_FMTHIDDEN') {
		fmt = putexcel_remove_quote(fmt)
		(void) putexcel_check_on_off(fmt)
		ei.fi->fmt = fmt
	}
}

void putexcel_check_nformat(`EI' ei, pointer(`XL') xl_class)
{
	string scalar		tmpstr

	tmpstr = putexcel_remove_paren(ei.expression)
	tmpstr = putexcel_remove_quote(tmpstr)

	if (!xl_class->is_valid_number_format(tmpstr)) {
errprintf("{bf:%s}: invalid number format specified in nformat()\n", tmpstr)
		exit(198)
	}

	ei.fi->fmt = tmpstr
}

void putexcel_check_border(string scalar tmpstr, `BI' bi, 
	pointer(`XL') scalar xl_class, real scalar is_new_syntax)
{
	transmorphic		t
	string scalar		token, border, style, color
	real scalar		args

	t = tokeninit(" ", `","',  (`""""', `"`""'"'), 0, 0)
	tokenset(t, tmpstr)

	args = 1
	border = ""
	style = ""
	color = ""

	for (token=tokenget(t); token != "";token = tokenget(t)) {
		(void) tokenget(t)
		if (args == 1) {
			border = putexcel_remove_quote(token)
		}
		else if (args == 2) {
			style = putexcel_remove_quote(token)
		}
		else if (args == 3) {
			color = putexcel_remove_quote(token)
		}
		else if (args > 3) {
	errprintf("too many arguments specified in border()\n")
			exit(198)
		}
		args++
	}

	if (border != "all" & border != "top" & border != "bottom" &
		border != "left" & border != "right") {
errprintf("{bf:%s}: invalid border specified in border()\n", border)
			exit(198)
	}
	if (style=="") {
		if (is_new_syntax) {
			style="thin"
		}
	}
	if (!xl_class->is_valid_border_style(style)) {
errprintf("{bf:%s}: invalid border style specified in border()\n", style)
		exit(198)
	}

	if (color != "") {
		if (!xl_class->is_valid_color(color)) {
errprintf("{bf:%s}: invalid border color specified in border()\n", color)
		exit(198)
		}
	}

	bi.border = border
	bi.style = style
	bi.color = color
}

void putexcel_check_dborder(string scalar tmpstr, `DBI' dbi,
	pointer(`XL') scalar xl_class, real scalar is_new_syntax)
{
	transmorphic		t
	string scalar		token, direction, style, color
	real scalar		args

	t = tokeninit(" ", `","', (`""""', `"`""'"'), 0, 0)
	tokenset(t, tmpstr)

	args = 1
	direction = ""
	style = ""
	color = ""

	for (token=tokenget(t); token != "";token = tokenget(t)) {
		(void) tokenget(t)
		if (args == 1) {
			direction = putexcel_remove_quote(token)
		}
		else if (args == 2) {
			style = putexcel_remove_quote(token)
		}
		else if (args == 3) {
			color = putexcel_remove_quote(token)
		}
		else if (args > 3) {
	errprintf("too many arguments specified in dborder()\n")
			exit(198)
		}
		args++
	}
	if (!xl_class->is_valid_border_direction(direction)) {
errprintf("{bf:%s}: invalid border direction specified in dborder()\n",
		direction)
		exit(198)
	}
	if (style=="") {
		if (is_new_syntax) {
			style="thin"
		}
	}
	if (!xl_class->is_valid_border_style(style)) {
errprintf("{bf:%s}: invalid border style specified in dborder()\n", style)
		exit(198)
	}
	if (color != "") {
		if (!xl_class->is_valid_color(color)) {
errprintf("{bf:%s}: invalid border color specified in dborder()\n", color)
		exit(198)
		}
	}

	dbi.direction = direction
	dbi.style = style
	dbi.color = color
}

void putexcel_check_fpattern(string scalar tmpstr, `FPI' fpi,
	pointer(`XL') scalar xl_class, real scalar is_new_syntax)
{
	transmorphic		t
	string scalar		token, pattern, fgcolor, bgcolor
	real scalar		args

	t = tokeninit(" ", `","', (`""""', `"`""'"'), 0, 0)
	tokenset(t, tmpstr)

	args = 1
	pattern = ""
	fgcolor = ""
	bgcolor = ""

	for (token=tokenget(t); token != "";token = tokenget(t)) {
		(void) tokenget(t)
		if (args == 1) {
			pattern = putexcel_remove_quote(token)
		}
		else if (args == 2) {
			fgcolor = putexcel_remove_quote(token)
		}
		else if (args == 3) {
			bgcolor = putexcel_remove_quote(token)
		}
		else if (args > 3) {
	errprintf("too many arguments specified in fpattern()\n")
			exit(198)
		}
		args++
	}

	if (!xl_class->is_valid_fill_pattern(pattern)) {
errprintf("{bf:%s}: invalid fill pattern specified in fpattern()\n", pattern)
		exit(198)
	}
	if (fgcolor=="") {
		if (is_new_syntax) {
			fgcolor="black"
		}
	}
	if (!xl_class->is_valid_color(fgcolor)) {
errprintf("{bf:%s}: invalid foreground color specified in fpattern()\n",
		fgcolor)
		exit(198)
	}
	if (bgcolor != "") {
		if (!xl_class->is_valid_color(bgcolor)) {
errprintf("{bf:%s}: invalid background color specified in fpattern()\n",
		bgcolor)
		exit(198)
		}
	}

	fpi.pattern = pattern
	fpi.fg_color = fgcolor
	fpi.bg_color = bgcolor
}

void putexcel_check_font(string scalar tmpstr, `FTI' fti,
	pointer(`XL') scalar xl_class, real scalar is_new_syntax)
{
	transmorphic		t
	string scalar		token, font, size, color
	real scalar		args

	t = tokeninit(" ", `","', (`""""', `"`""'"'), 0, 0)
	tokenset(t, tmpstr)

	args = 1
	font = ""
	size = ""
	color = ""

	for (token=tokenget(t); token != "";token = tokenget(t)) {
		(void) tokenget(t)
		if (args == 1) {
			font = putexcel_remove_quote(token)
		}
		else if (args == 2) {
			size = putexcel_remove_quote(token)
		}
		else if (args == 3) {
			color = putexcel_remove_quote(token)
		}
		else if (args > 3) {
	errprintf("too many arguments specified in font()\n")
			exit(198)
		}
		args++
	}
	if (font == "") {
errprintf("invalid font name specified in font()\n")
		exit(198)
	}

	if (size == "") {
		if (is_new_syntax) {
			size="12"
		}
		else {
errprintf("invalid font size specified in font()\n")
			exit(198)
		}
	}
	if (size != "") {
		if (missing(strtoreal(size))) {
errprintf("{bf:%s}: invalid font size specified in font()\n", size)
			exit(198)
		}
	}

	if (color != "") {
		if (!xl_class->is_valid_color(color)) {
errprintf("{bf:%s}: invalid color specified in font()\n", color)
		exit(198)
		}
	}

	fti.name = font
	fti.size = strtoreal(size)
	fti.color = color
}

void putexcel_is_picture(`EI' ei)
{
	string scalar		pfile, quote
	real scalar		rc

	if (!putexcel_check_paren(ei.expression)) {
		errprintf("%s: picture must be enclosed in ()\n", ei.expression)
		exit(198)
	}
	ei.pi = &(picture_info())
	(void) putexcel_picture_info_init(*(ei.pi))

	pfile = putexcel_remove_paren(ei.expression)

	if (strtrim(pfile)=="") {
		errprintf("no picture file specified \n")
		exit(198)
	}


	if (pathsuffix(pfile) == "") {
		pfile = pfile + ".png"
	}
	pfile = putexcel_remove_quote(pfile)
	quote = `"""'
	rc = _stata(sprintf("qui confirm file %s%s%s", quote, pfile, quote), 1)
	if (rc) {
		errprintf("file {bf:%s} not found\n\n", pfile)
		exit(rc)
	}

	ei.pi->pfile = pfile
}

void putexcel_is_new_etable(`CEI' cei)
{
	real scalar		i, etcount
	string scalar		tetables, tename

	cei.ei.etab = &(etable_info())
	tetables = strtrim(cei.ei.expression)

	cei.ei.etab->etcount = etcount = put_get_etable_count()
	if (etcount == 0) {
		if (st_global("e(cmd)") == "") {
			errprintf("last estimates not found\n")
			exit(301)
		}
		else {
			if (put_check_etable() != 0) {
errprintf("{bf:etable} is not supported for last estimation command\n")
				exit(198)
			}
			else {
errprintf("information for the estimation table not found;\n")
errprintf("{p 4 4 2}Please {helpb estcom##remarks19:replay} estimation results and try again{p_end}")
				exit(111)
			}
		}
	}

	if (tetables=="") {
		tename = "tbl"
		cei.ei.etab->etir = _etable_info(etcount)
		for(i=1; i<=etcount; i++) {
			if (etcount==1) {
				(void) put_get_etable_data(
					cei.ei.etab->etir[i], i, tename, 1)
			}
			else {
				(void) put_get_etable_data(
					cei.ei.etab->etir[i], i, 
					tename+strofreal(i), 1)
			}
		}
	}
	else {
		tetables = tokens(putexcel_remove_paren(tetables))
		for(i=1; i<=cols(tetables); i++) {
			if (strtoreal(tetables[i]) > etcount) {
errprintf("table index out of range;\n")
errprintf("{p 4 4 2}%g found where index value from 1 to %g were expected{p_end}", strtoreal(tetables[i]), etcount)
				exit(125)
			}
		}

		cei.ei.etab->etcount = etcount = cols(tetables)
		cei.ei.etab->etir =  _etable_info(etcount)
		for(i=1; i<=etcount; i++) {
			if (etcount==1) {
				(void) put_get_etable_data(cei.ei.etab->etir[i],
					strtoreal(tetables[i]), tename, 1)
			}
			else {
				(void) put_get_etable_data(cei.ei.etab->etir[i],
				strtoreal(tetables[i]), tename+tetables[i], 1)
			}
		}
	}
}

// ============================================================================
// Write data
// ============================================================================

void putexcel_write_data(struct parse_info scalar pr)
{
	string scalar		filename

	if (pr.is_new_syntax) {
		if (!(pr.op_open)) {
			(void) putexcel_open_file(pr)
		}
		else {
			filename = pr.xl_class->query("filename")
			if (filename == "") {
				(void) putexcel_open_file(pr)
			}
		}
	}
	else {
		(void) putexcel_open_file(pr)
	}

	(void) putexcel_write_values(pr)

	if (pr.is_new_syntax) {
		if (!(pr.op_open)) {
			(void) putexcel_close_file(pr)
		}
	}
	else {
		(void) putexcel_close_file(pr)
	}
}

void putexcel_open_file(struct parse_info scalar pr)
{
	real scalar		rc, newsheet, newfile
	string scalar		quote, errmsg

	newfile = newsheet = 0

	quote = `"""'
	rc = _stata(sprintf("quietly confirm new file %s%s%s",
		quote, pr.filename, quote), 1)
	if (rc==0) {
		newfile = 1
	}

	if (pr.op_replace) {
		newfile = 1
	}

	pr.xl_class->set_mode("open")
	pr.xl_class->set_error_mode("off")

	if (pr.op_keepcellformat) {
		pr.xl_class->set_keep_cell_format("on")
	}
	else {
		pr.xl_class->set_keep_cell_format("off")
	}

	if (newfile) {
		if (pr.is_xlsx) {
			pr.xl_class->create_book(pr.filename, pr.op_sheet,
				"xlsx", pr.op_locale)
			if (pr.xl_class->get_last_error()) {
				errprintf("file {bf:%s} could not be created\n",
					pr.filename)
				exit(603)
			}
		}
		else {
			pr.xl_class->create_book(pr.filename, pr.op_sheet,
				"xls", pr.op_locale)
			if (pr.xl_class->get_last_error()) {
				errprintf("file {bf:%s} could not be created\n",
					pr.filename)
				exit(603)
			}
		}
	}
	else {
		if (!pr.op_modify & !pr.op_replace ) {
			errprintf("file already exists\n")
			errprintf("you must specify either the {bf:modify} ")
			errprintf("or {bf:replace} option\n")
			exit(198)
		}

		pr.xl_class->load_book(pr.filename, pr.op_locale)
		if (pr.xl_class->get_last_error()) {
			errprintf("workbook {bf:%s} could not be loaded\n",
				pr.filename)
			exit(603)
		}

		if (pr.op_sheet != "") {
			pr.xl_class->set_sheet(pr.op_sheet)
			if (pr.xl_class->get_last_error_message()!="") {
				pr.xl_class->add_sheet(pr.op_sheet)
				if (pr.xl_class->get_last_error_message()!="") {
errmsg = sprintf("worksheet {bf:%s} could not be created\n", pr.op_sheet)
					putexcel_error_close_file(pr.xl_class,
						errmsg, 603)
				}
				newsheet = 1
			}
		}

		if (newsheet == 0 & !pr.op_modify) {
errmsg = sprintf("worksheet {bf:%s} already exists, must specify modify\n",
			pr.op_sheet)
			putexcel_error_close_file(pr.xl_class, errmsg, 602)
		}
		if (pr.op_sheetreplace & newsheet == 0) {
			pr.xl_class->clear_sheet(pr.op_sheet)
			if (pr.xl_class->get_last_error_message()!="") {
errmsg = sprintf("worksheet {bf:%s} could not be opened\n", pr.op_sheet)
				putexcel_error_close_file(pr.xl_class,
					errmsg, 603)
			}
			if (pr.is_new_syntax) {
				st_global("PUTEXCEL_SHEET_REPLACE", "")
			}
		}
		if (pr.op_sheetnogrid != .) {
			if (pr.op_sheetnogrid = 1) {
				pr.xl_class->set_sheet_gridlines(pr.op_sheet,
					"off")
			}
			else if (!pr.op_sheetnogrid) {
				pr.xl_class->set_sheet_gridlines(pr.op_sheet,
					"on")
			}
		}
	}
}

void putexcel_write_values(struct parse_info scalar pr)
 {
	real scalar		i
	real rowvector		cols, rows

	for (i=1; i<=length(pr.cei); i++) {
		if (pr.fin != J(1, 1, NULL)) {
			if (putexcel_is_new_format(*(pr.fin))) {
				if (pr.cei[i]->ci.lr_cell_col == -1) {
					cols = pr.cei[i]->ci.ul_cell_col
					rows = pr.cei[i]->ci.ul_cell_row
				}
				else {
					cols = (pr.cei[i]->ci.ul_cell_col,
						pr.cei[i]->ci.lr_cell_col)
					rows = (pr.cei[i]->ci.ul_cell_row,
						pr.cei[i]->ci.lr_cell_row)
				}
				(void) putexcel_write_format_new(rows, cols,
					*(pr.fin), pr.xl_class, pr.op_sheet,
					pr.op_keepcellformat)
			}
		}

		if (pr.cei[i]->ei.exp_type == `IS_EXP') {
			(void) putexcel_write_exp(*(pr.cei[i]), pr.xl_class)
		}
		else if (pr.cei[i]->ei.exp_type == `IS_MATRIX') {
			(void) putexcel_write_matrix(*(pr.cei[i]), pr.xl_class)
		}
		else if (pr.cei[i]->ei.exp_type == `IS_RESULTSET') {
			(void) putexcel_write_return_vals(pr.cei[i]->ei.rsi->ri,
				pr.cei[i]->ei.rsi->is_resultset_names, pr)
		}
		else if (pr.cei[i]->ei.exp_type >= `FMT_NFORMAT') {
			(void) putexcel_write_format(*(pr.cei[i]), pr.xl_class)
		}
		else if (pr.cei[i]->ei.exp_type == `IS_PICTURE') {
			(void) putexcel_write_picture(*(pr.cei[i]), pr.xl_class)
		}
		else if (pr.cei[i]->ei.exp_type == `IS_FORMAT_NEW') {
			//do nothing format already apply in first if branch
		}
		else if (pr.cei[i]->ei.exp_type == `IS_ETABLE') {
			(void) putexcel_write_etables(*(pr.cei[i]), 
				pr.xl_class, pr.op_sheet)
		}
		else {
			errprintf("invalid cellexplist()\n")
			exit(198)
		}
	}
}

void putexcel_write_exp(`CEI' cei, pointer (`XL') scalar xl_class)
{
	real scalar		ul_col, ul_row, lr_row, lr_col, rows, cols
	real matrix		num_temp
	string matrix		str_temp
	string scalar		errmsg

	ul_col = cei.ci.ul_cell_col
	ul_row = cei.ci.ul_cell_row

	lr_col = cei.ci.lr_cell_col
	lr_row = cei.ci.lr_cell_row

	if (lr_col == -1) {
		num_temp = cei.ei.evi->eval_num_scalar
		str_temp = cei.ei.evi->eval_str_scalar
	}
	else {
		rows = lr_row-ul_row+1
		cols = lr_col-ul_col+1
		num_temp = J(rows, cols, cei.ei.evi->eval_num_scalar)
		str_temp = J(rows, cols, cei.ei.evi->eval_str_scalar)
	}

	errmsg = sprintf("could not write to file\n")
	if (cei.ei.evi->asdatenum) {
		xl_class->put_number(ul_row, ul_col, num_temp, "asdatenum")
		if (xl_class->get_last_error()) {
			putexcel_error_close_file(xl_class, errmsg, 691)
		}
	}
	else if (cei.ei.evi->asdatetimenum) {
		xl_class->put_number(ul_row, ul_col, num_temp, "asdatetimenum")
		if (xl_class->get_last_error()) {
			putexcel_error_close_file(xl_class, errmsg, 691)
		}
	}
	else if (cei.ei.evi->asdate) {
		xl_class->put_number(ul_row, ul_col, num_temp, "asdate")
		if (xl_class->get_last_error()) {
			putexcel_error_close_file(xl_class, errmsg, 691)
		}
	}
	else if (cei.ei.evi->asdatetime) {
		xl_class->put_number(ul_row, ul_col, num_temp, "asdatetime")
		if (xl_class->get_last_error()) {
			putexcel_error_close_file(xl_class, errmsg, 691)
		}
	}
	else if (cei.ei.evi->is_str_scalar) {
		xl_class->put_string(ul_row, ul_col, str_temp)
		if (xl_class->get_last_error()) {
			putexcel_error_close_file(xl_class, errmsg, 691)
		}
	}
	else {
		xl_class->put_number(ul_row, ul_col, num_temp)
		if (xl_class->get_last_error()) {
			putexcel_error_close_file(xl_class, errmsg, 691)
		}
	}
}

void putexcel_write_matrix(`CEI' cei, pointer(`XL') scalar xl_class)
{
	real scalar		ul_col, ul_row
	real scalar		row_stripe_space, col_stripe_space
	string scalar		errmsg

	ul_col = cei.ci.ul_cell_col
	ul_row = cei.ci.ul_cell_row

	row_stripe_space = 0
	col_stripe_space = 0

	if (cei.ei.mi->rownames | cei.ei.mi->names) {
		row_stripe_space = cols(cei.ei.mi->eval_mat_row_stripes)
	}

	if (cei.ei.mi->colnames | cei.ei.mi->names) {
		col_stripe_space = rows(cei.ei.mi->eval_mat_col_stripes)
	}

	errmsg = sprintf("could not write to file\n")
	if (cei.ei.mi->names) {
		xl_class->put_string(ul_row+col_stripe_space, ul_col,
			cei.ei.mi->eval_mat_row_stripes)
		if (xl_class->get_last_error()) {
			putexcel_error_close_file(xl_class, errmsg, 691)
		}
		xl_class->put_string(ul_row, ul_col+row_stripe_space,
			cei.ei.mi->eval_mat_col_stripes)
		if (xl_class->get_last_error()) {
			putexcel_error_close_file(xl_class, errmsg, 691)
		}
		xl_class->put_number(ul_row+col_stripe_space,
			ul_col+row_stripe_space,
			cei.ei.mi->eval_mat)
		if (xl_class->get_last_error()) {
			putexcel_error_close_file(xl_class, errmsg, 691)
		}
	}
	else if (cei.ei.mi->rownames) {
		xl_class->put_string(ul_row, ul_col,
			cei.ei.mi->eval_mat_row_stripes)
		if (xl_class->get_last_error()) {
			putexcel_error_close_file(xl_class, errmsg, 691)
		}
		xl_class->put_number(ul_row, ul_col+row_stripe_space,
			cei.ei.mi->eval_mat)
		if (xl_class->get_last_error()) {
			putexcel_error_close_file(xl_class, errmsg, 691)
		}
	}
	else if (cei.ei.mi->colnames) {
		xl_class->put_string(ul_row, ul_col,
			cei.ei.mi->eval_mat_col_stripes)
		if (xl_class->get_last_error()) {
			putexcel_error_close_file(xl_class, errmsg, 691)
		}
		xl_class->put_number(ul_row+col_stripe_space, ul_col,
			cei.ei.mi->eval_mat)
		if (xl_class->get_last_error()) {
			putexcel_error_close_file(xl_class, errmsg, 691)
		}
	}
	else {
		xl_class->put_number(ul_row, ul_col, cei.ei.mi->eval_mat)
		if (xl_class->get_last_error()) {
			putexcel_error_close_file(xl_class, errmsg, 691)
		}
	}
}

void putexcel_write_return_vals(pointer(`RI') rowvector ri,
	real scalar is_resultset_names, struct parse_info scalar pr)
{
	real scalar		i, tmp
	real rowvector		cols, rows
	string scalar		errmsg

	for (i=1; i<=length(ri); i++) {
		rows = ri[i]->cell_ul_row
		cols = ri[i]->cell_ul_col

		if (is_resultset_names) {
			if (pr.op_colwise) {
				pr.xl_class->put_string(rows, cols,
					ri[i]->return_names')
				if (pr.is_new_syntax) {
					tmp = cols + cols(ri[i]->return_names')
					cols = (cols, tmp)
					(void) putexcel_write_format_new(rows,
						cols, *(pr.fin), pr.xl_class,
						pr.op_sheet,
						pr.op_keepcellformat)
				}
			}
			else {
				pr.xl_class->put_string(rows, cols,
					ri[i]->return_names)
				if (pr.is_new_syntax) {
					tmp = rows + rows(ri[i]->return_names)
					rows = (rows, tmp)
					(void) putexcel_write_format_new(rows,
						cols, *(pr.fin), pr.xl_class,
						pr.op_sheet,
						pr.op_keepcellformat)
				}
			}
		}
		else if (ri[i]->type == "numscalar") {
			pr.xl_class->put_number(rows, cols, ri[i]->ret_scalar)
			if (pr.is_new_syntax) {
				(void) putexcel_write_format_new(rows, cols,
					*(pr.fin), pr.xl_class, pr.op_sheet,
						pr.op_keepcellformat)
			}
		}
		else if (ri[i]->type == "macro") {
			pr.xl_class->put_string(rows, cols, ri[i]->ret_macro)
			if (pr.is_new_syntax) {
				(void) putexcel_write_format_new(rows, cols,
					*(pr.fin), pr.xl_class, pr.op_sheet,
						pr.op_keepcellformat)
			}
		}
		else if (ri[i]->type == "matrix") {
			pr.xl_class->put_number(rows, cols, ri[i]->ret_matrix)
			tmp = rows + rows(ri[i]->ret_matrix)
			if (pr.is_new_syntax) {
				tmp = rows + rows(ri[i]->ret_matrix)
				rows = (rows, tmp)
				tmp = cols + cols(ri[i]->ret_matrix)
				cols = (cols, tmp)
				(void) putexcel_write_format_new(rows, cols,
					*(pr.fin), pr.xl_class, pr.op_sheet,
						pr.op_keepcellformat)
			}
		}
		else {
			errmsg = sprintf("invalid return type\n")
			putexcel_error_close_file(pr.xl_class, errmsg, 198)
		}

		if (pr.xl_class->get_last_error()) {
			errmsg = sprintf("could not write to file\n")
			putexcel_error_close_file(pr.xl_class, errmsg, 691)
		}
	}
}

void putexcel_write_format(`CEI' cei, pointer(`XL') scalar xl_class)
{
	real scalar		fmtid
	real rowvector		rows, cols
	string scalar		fmt, border, style, color, err, errmsg
	string matrix		str_temp

	fmt = cei.ei.fi->fmt
	fmtid = cei.ei.exp_type
	if (cei.ci.lr_cell_col == -1) {
		cols = cei.ci.ul_cell_col
		rows = cei.ci.ul_cell_row
	}
	else {
		cols = (cei.ci.ul_cell_col, cei.ci.lr_cell_col)
		rows = (cei.ci.ul_cell_row, cei.ci.lr_cell_row)
	}

	if (fmtid == `FMT_NFORMAT') {
		xl_class->set_number_format(rows, cols, fmt)
		err = "nformat()"
	}
	else if (fmtid == `FMT_VALIGN') {
		xl_class->set_vertical_align(rows, cols, fmt)
		err = "valign()"
	}
	else if (fmtid == `FMT_HALIGN') {
		xl_class->set_horizontal_align(rows, cols, fmt)
		err = "halign()"
	}
	else if (fmtid == `FMT_FORMULA') {
		if (cei.ci.lr_cell_row == -1) {
			str_temp = fmt
		}
		else {
			str_temp = J(cei.ci.lr_cell_row-cei.ci.ul_cell_row+1,
				cei.ci.lr_cell_col-cei.ci.ul_cell_col+1, fmt)
		}
		xl_class->put_formula(rows[1], cols[1], str_temp)
		err = "formula()"
	}
	else if (fmtid == `FMT_BORDER') {
		border = cei.ei.fi->bi->border
		style = cei.ei.fi->bi->style
		color = cei.ei.fi->bi->color
		if (border == "all") {
			if (color == "") {
				xl_class->set_border(rows, cols, style)
			}
			else {
				xl_class->set_border(rows, cols, style, color)
			}
		}
		if (border == "left") {
			if (color =="") {
				xl_class->set_left_border(rows, cols, style)
			}
			else {
				xl_class->set_left_border(rows, cols, style,
					color)
			}
		}
		if (border == "right") {
			if (color =="") {
				xl_class->set_right_border(rows, cols, style)
			}
			else {
				xl_class->set_right_border(rows, cols, style,
					color)
			}
		}
		if (border == "top") {
			if (color == "") {
				xl_class->set_top_border(rows, cols, style)
			}
			else {
				xl_class->set_top_border(rows, cols, style,
					color)
			}
		}
		if (border == "bottom") {
			if (color == "") {
				xl_class->set_bottom_border(rows, cols, style)
			}
			else {
				xl_class->set_bottom_border(rows, cols, style,
					color)
			}
		}
		err = "border()"
	}
	else if (fmtid == `FMT_DBORDER') {
		if (cei.ei.fi->dbi->color =="") {
			xl_class->set_diagonal_border(rows, cols,
				cei.ei.fi->dbi->direction,
				cei.ei.fi->dbi->style)
		}
		else {
			xl_class->set_diagonal_border(rows, cols,
				cei.ei.fi->dbi->direction,
				cei.ei.fi->dbi->style,
				cei.ei.fi->dbi->color)
		}
		err = "dborder()"
	}
	else if (fmtid == `FMT_FPATTERN') {
		if (cei.ei.fi->fpi->bg_color =="") {
			xl_class->set_fill_pattern(rows, cols,
				cei.ei.fi->fpi->pattern,
				cei.ei.fi->fpi->fg_color)
		}
		else {
			xl_class->set_fill_pattern(rows, cols,
				cei.ei.fi->fpi->pattern,
				cei.ei.fi->fpi->fg_color,
				cei.ei.fi->fpi->bg_color)
		}
		err = "fpattern()"
	}
	else if (fmtid == `FMT_FONT') {
		if (cei.ei.fi->fti->color =="") {
			xl_class->set_font(rows, cols, cei.ei.fi->fti->name,
				cei.ei.fi->fti->size)
		}
		else {
			xl_class->set_font(rows, cols, cei.ei.fi->fti->name,
				cei.ei.fi->fti->size, cei.ei.fi->fti->color)
		}
		err = "font()"
	}
	else if (fmtid == `FMT_BOLD') {
		xl_class->set_font_bold(rows, cols, fmt)
		err = "bold()"
	}
	else if (fmtid == `FMT_ITALIC') {
		xl_class->set_font_italic(rows, cols, fmt)
		err = "italic()"
	}
	else if (fmtid == `FMT_STRIKEOUT') {
		xl_class->set_font_strikeout(rows, cols, fmt)
		err = "strikeout()"
	}
	else if (fmtid == `FMT_UNDERLINE') {
		xl_class->set_font_underline(rows, cols, fmt)
		err = "underline()"
	}
	else if (fmtid == `FMT_SCRIPT') {
		xl_class->set_font_script(rows, cols, fmt)
		err = "script()"
	}
	else if (fmtid == `FMT_TXTWRAP') {
		xl_class->set_text_wrap(rows, cols, fmt)
		err = "txtwrap()"
	}
	else if (fmtid == `FMT_SHRINKFIT') {
		xl_class->set_shrink_to_fit(rows, cols, fmt)
		err = "shrinkfit()"
	}
	else if (fmtid == `FMT_TXTROTATE') {
		xl_class->set_text_rotate(rows, cols, cei.ei.fi->format_num_arg)
		err = "txtrotate()"
	}
	else if (fmtid == `FMT_TXTINDENT') {
		xl_class->set_text_indent(rows, cols, cei.ei.fi->format_num_arg)
		err = "txtindent()"
	}
	else if (fmtid == `FMT_FMTLOCK') {
		xl_class->set_format_lock(rows, cols, fmt)
		err = "fmtlock"
	}
	else if (fmtid == `FMT_FMTHIDDEN') {
		xl_class->set_format_hidden(rows, cols, fmt)
		err = "fmthidden()"
	}

	if (xl_class->get_last_error()) {
		errmsg = sprintf("could not write %s format to file\n", err)
		putexcel_error_close_file(xl_class, errmsg, 691)
	}
}

void putexcel_write_format_new(real rowvector rows, real rowvector cols,
	`FIN' fin, pointer(`XL') scalar xl_class, string scalar sheet,
	real scalar keepcellformat)
{
	string scalar		border, style, color, err, errmsg

	if (keepcellformat==0) {
		putexcel_write_format_fmtid(rows, cols, fin, xl_class, sheet)
		return
	}

	if (fin.op_nformat != "") {
		xl_class->set_number_format(rows, cols, fin.op_nformat)
		err = "nformat()"
	}
	if (fin.valign != "") {
		xl_class->set_vertical_align(rows, cols, fin.valign)
		err = "valign()"
	}
	if (fin.halign != "") {
		xl_class->set_horizontal_align(rows, cols, fin.halign)
		err = "halign()"
	}
	if (fin.bi != J(1, 1, NULL)) {
		border = fin.bi->border
		style = fin.bi->style
		color = fin.bi->color
		if (border == "all") {
			if (color == "") {
				xl_class->set_border(rows, cols, style)
			}
			else {
				xl_class->set_border(rows, cols, style, color)
			}
		}
		if (border == "left") {
			if (color =="") {
				xl_class->set_left_border(rows, cols, style)
			}
			else {
				xl_class->set_left_border(rows, cols, style,
					color)
			}
		}
		if (border == "right") {
			if (color =="") {
				xl_class->set_right_border(rows, cols, style)
			}
			else {
				xl_class->set_right_border(rows, cols, style,
					color)
			}
		}
		if (border == "top") {
			if (color == "") {
				xl_class->set_top_border(rows, cols, style)
			}
			else {
				xl_class->set_top_border(rows, cols, style,
					color)
			}
		}
		if (border == "bottom") {
			if (color == "") {
				xl_class->set_bottom_border(rows, cols, style)
			}
			else {
				xl_class->set_bottom_border(rows, cols, style,
					color)
			}
		}
		err = "border()"
	}
	if (fin.dbi != J(1, 1, NULL)) {
		if (fin.dbi->color =="") {
			xl_class->set_diagonal_border(rows, cols,
				fin.dbi->direction,
				fin.dbi->style)
		}
		else {
			xl_class->set_diagonal_border(rows, cols,
				fin.dbi->direction,
				fin.dbi->style,
				fin.dbi->color)
		}
		err = "dborder()"
	}
	if (fin.fpi != J(1, 1, NULL)) {
		if (fin.fpi->bg_color =="") {
			xl_class->set_fill_pattern(rows, cols,
				fin.fpi->pattern,
				fin.fpi->fg_color)
		}
		else {
			xl_class->set_fill_pattern(rows, cols,
				fin.fpi->pattern,
				fin.fpi->fg_color,
				fin.fpi->bg_color)
		}
		err = "fpattern()"
	}
	if (fin.fti != J(1, 1, NULL)) {
		if (fin.fti->color =="") {
			xl_class->set_font(rows, cols, fin.fti->name,
				fin.fti->size)
		}
		else {
			xl_class->set_font(rows, cols, fin.fti->name,
				fin.fti->size, fin.fti->color)
		}
		err = "font()"
	}
	if (fin.op_bold!="") {
		xl_class->set_font_bold(rows, cols, fin.op_bold)
		err = "bold()"
	}
	if (fin.op_italic!="") {
		xl_class->set_font_italic(rows, cols, fin.op_italic)
		err = "italic()"
	}
	if (fin.op_strikeout!="") {
		xl_class->set_font_strikeout(rows, cols, fin.op_strikeout)
		err = "strikeout()"
	}
	if (fin.op_underline!="") {
		xl_class->set_font_underline(rows, cols, fin.op_underline)
		err = "underline()"
	}
	if (fin.op_script!="") {
		xl_class->set_font_script(rows, cols, fin.op_script)
		err = "script()"
	}
	if (fin.op_txtwrap!="") {
		xl_class->set_text_wrap(rows, cols, fin.op_txtwrap)
		err = "txtwrap()"
	}
	if (fin.op_shrinkfit!="") {
		xl_class->set_shrink_to_fit(rows, cols, fin.op_shrinkfit)
		err = "shrinkfit()"
	}
	if (fin.op_txtrotate!=.) {
		xl_class->set_text_rotate(rows, cols, fin.op_txtrotate)
		err = "txtrotate()"
	}
	if (fin.op_txtindent!=.) {
		xl_class->set_text_indent(rows, cols, fin.op_txtindent)
		err = "txtindent()"
	}
	if (fin.op_fmtlock!="") {
		xl_class->set_format_lock(rows, cols, fin.op_fmtlock)
		err = "fmtlock"
	}
	if (fin.op_fmthidden!="") {
		xl_class->set_format_hidden(rows, cols, fin.op_fmthidden)
		err = "fmthidden()"
	}
	if (fin.op_merge!=.) {
		if (fin.op_merge==1) {
			xl_class->set_sheet_merge(sheet, rows, cols)
			err = "merge"
		}
		else {
			xl_class->delete_sheet_merge(sheet, rows[1], cols[1])
			err = "unmerge"
		}
	}
	if (xl_class->get_last_error()) {
		errmsg = sprintf("could not write %s format to file\n", err)
		putexcel_error_close_file(xl_class, errmsg, 691)
	}
}

void putexcel_write_format_fmtid(real rowvector rows, real rowvector cols,
	`FIN' fin, pointer(`XL') scalar xl_class, string scalar sheet)
{
	string scalar		border, style, color, err, errmsg
	real scalar		fmt_id, font_id

	fmt_id = -1
	font_id = -1

	fmt_id = xl_class->add_fmtid()

	if (fin.op_nformat != "") {
		xl_class->fmtid_set_number_format(fmt_id, fin.op_nformat)
		err = "nformat()"
	}
	if (fin.valign != "") {
		xl_class->fmtid_set_vertical_align(fmt_id, fin.valign)
		err = "valign()"
	}
	if (fin.halign != "") {
		xl_class->fmtid_set_horizontal_align(fmt_id, fin.halign)
		err = "halign()"
	}
	if (fin.bi != J(1, 1, NULL)) {
		border = fin.bi->border
		style = fin.bi->style
		color = fin.bi->color
		if (border == "all") {
			if (color == "") {
				xl_class->fmtid_set_border(fmt_id, style)
			}
			else {
				xl_class->fmtid_set_border(fmt_id, style, color)
			}
		}
		if (border == "left") {
			if (color =="") {
				xl_class->fmtid_set_left_border(fmt_id, style)
			}
			else {
				xl_class->fmtid_set_left_border(fmt_id, style,
					color)
			}
		}
		if (border == "right") {
			if (color =="") {
				xl_class->fmtid_set_right_border(fmt_id, style)
			}
			else {
				xl_class->fmtid_set_right_border(fmt_id, style,
					color)
			}
		}
		if (border == "top") {
			if (color == "") {
				xl_class->fmtid_set_top_border(fmt_id, style)
			}
			else {
				xl_class->fmtid_set_top_border(fmt_id, style,
					color)
			}
		}
		if (border == "bottom") {
			if (color == "") {
				xl_class->fmtid_set_bottom_border(fmt_id, style)
			}
			else {
				xl_class->fmtid_set_bottom_border(fmt_id, style,
					color)
			}
		}
		err = "border()"
	}
	if (fin.dbi != J(1, 1, NULL)) {
		if (fin.dbi->color =="") {
			xl_class->fmtid_set_diagonal_border(fmt_id,
				fin.dbi->direction,
				fin.dbi->style)
		}
		else {
			xl_class->fmtid_set_diagonal_border(fmt_id,
				fin.dbi->direction,
				fin.dbi->style,
				fin.dbi->color)
		}
		err = "dborder()"
	}
	if (fin.fpi != J(1, 1, NULL)) {
		if (fin.fpi->bg_color =="") {
			xl_class->fmtid_set_fill_pattern(fmt_id,
				fin.fpi->pattern,
				fin.fpi->fg_color)
		}
		else {
			xl_class->fmtid_set_fill_pattern(fmt_id,
				fin.fpi->pattern,
				fin.fpi->fg_color,
				fin.fpi->bg_color)
		}
		err = "fpattern()"
	}
	if (fin.op_txtwrap!="") {
		xl_class->fmtid_set_text_wrap(fmt_id, fin.op_txtwrap)
		err = "txtwrap()"
	}
	if (fin.op_shrinkfit!="") {
		xl_class->fmtid_set_shrink_to_fit(fmt_id, fin.op_shrinkfit)
		err = "shrinkfit()"
	}
	if (fin.op_txtrotate!=.) {
		xl_class->fmtid_set_text_rotate(fmt_id, fin.op_txtrotate)
		err = "txtrotate()"
	}
	if (fin.op_txtindent!=.) {
		xl_class->fmtid_set_text_indent(fmt_id, fin.op_txtindent)
		err = "txtindent()"
	}
	if (fin.op_fmtlock!="") {
		xl_class->fmtid_set_format_lock(fmt_id, fin.op_fmtlock)
		err = "fmtlock"
	}
	if (fin.op_fmthidden!="") {
		xl_class->fmtid_set_format_hidden(fmt_id, fin.op_fmthidden)
		err = "fmthidden()"
	}
	if (fin.fti != J(1, 1, NULL) | fin.op_bold!="" | fin.op_italic!=""
		| fin.op_strikeout!="" | fin.op_underline!=""
		| fin.op_script!="") {
		font_id = xl_class->add_fontid()
	}
	if (fin.fti != J(1, 1, NULL)) {
		if (fin.fti->color =="") {
			xl_class->fontid_set_font(font_id, fin.fti->name,
				fin.fti->size)
		}
		else {
			xl_class->fontid_set_font(font_id, fin.fti->name,
				fin.fti->size, fin.fti->color)
		}
		err = "font()"
	}
	if (fin.op_bold!="") {
		xl_class->fontid_set_font_bold(font_id, fin.op_bold)
		err = "bold()"
	}
	if (fin.op_italic!="") {
		xl_class->fontid_set_font_italic(font_id, fin.op_italic)
		err = "italic()"
	}
	if (fin.op_strikeout!="") {
		xl_class->fontid_set_font_strikeout(font_id, fin.op_strikeout)
		err = "strikeout()"
	}
	if (fin.op_underline!="") {
		xl_class->fontid_set_font_underline(font_id, fin.op_underline)
		err = "underline()"
	}
	if (fin.op_script!="") {
		xl_class->fontid_set_font_script(font_id, fin.op_script)
		err = "script()"
	}
	if (fin.op_merge!=.) {
		if (fin.op_merge==1) {
			xl_class->set_sheet_merge(sheet, rows, cols)
			err = "merge"
		}
		else {
			xl_class->delete_sheet_merge(sheet, rows[1], cols[1])
			err = "unmerge"
		}
	}
	if (font_id > -1) {
		xl_class->fmtid_set_fontid(fmt_id, font_id)
	}

	xl_class->set_fmtid(rows, cols, fmt_id)

	if (xl_class->get_last_error()) {
		errmsg = sprintf("could not write %s format to file\n", err)
		putexcel_error_close_file(xl_class, errmsg, 691)
	}
	xl_class->set_keep_cell_format("on")
}

void putexcel_write_picture(`CEI' cei, pointer(`XL') scalar xl_class)
{
	real scalar		ul_col, ul_row
	string scalar		errmsg

	ul_col = cei.ci.ul_cell_col
	ul_row = cei.ci.ul_cell_row

	xl_class->put_picture(ul_row, ul_col, cei.ei.pi->pfile)
	if (xl_class->get_last_error()) {
		errmsg =  sprintf("could not write picture to file\n")
		putexcel_error_close_file(xl_class, errmsg, 691)
	}
}

void putexcel_write_etables(`CEI' cei, pointer(`XL') scalar xl_class,
	string scalar sheet)
{
	real scalar		i, etcount
	real scalar		start_col, start_row, end_col, end_row
	string scalar		tnames, rname
	
	etcount = cei.ei.etab->etcount 
	tnames = ""

	start_col = 0
	start_row = 0

	st_rclear()
	start_row = cei.ci.ul_cell_row + start_row
	for(i=1; i<=etcount; i++) {
		start_col = cei.ci.ul_cell_col

		(void) putexcel_write_etable(start_row, start_col, 
			cei.ei.etab->etir[i], xl_class, sheet)

		tnames = tnames + " " + cei.ei.etab->etir[i].tname

		end_col = start_col + cei.ei.etab->etir[i].ncol - 1

		end_row = start_row + cei.ei.etab->etir[i].nrow - 1
		rname = sprintf("r(tbl%g_ul_col)", i)
		st_numscalar(rname, start_col)

		rname = sprintf("r(tbl%g_ul_row)", i)
		st_numscalar(rname, start_row)

		rname = sprintf("r(tbl%g_lr_col)", i)
		st_numscalar(rname, end_col)

		rname = sprintf("r(tbl%g_lr_row)", i)
		st_numscalar(rname, end_row)

		start_row = start_row + cei.ei.etab->etir[i].nrow + 1
	}

	if (etcount > 1) {
		printf("{txt}(note: tables " + "{cmd:" + ustrtrim(tnames) + "} have been added)\n")
	}
}

void putexcel_write_etable(real scalar ul_row, real scalar ul_col, 
	`ETI' eti, pointer(`XL') scalar xl_class, string scalar sheet)
{
	real scalar		i, j, row, col
	real scalar		ktitle,  nrow, ncol, num, nspan, halignv

	nrow = eti.nrow
	ncol = eti.ncol
	row = ul_row
	col = ul_col
	ktitle = eti.ktitle

	xl_class->set_top_border(row, (ul_col,ul_col+ncol-1), "thin")

	for(i=1; i<=nrow; i++) {
		for(j=1; j<=ncol; j++) {
			num = strtoreal(eti.val[i,j])
			if (!missing(num)) {
				xl_class->put_number(row, col, num)
			}
			else {
				xl_class->put_string(row, col, eti.val[i, j])
			}
			halignv = eti.halign[i, j]
			if (missing(halignv)) {
				xl_class->set_horizontal_align(row, col,
					"right")
			}
			nspan = eti.hspan[i, j]
			if (!missing(nspan)) {
				xl_class->set_sheet_merge(sheet, row, col)
			}
			if (i<=ktitle) {
				if (i==ktitle) {
					xl_class->set_bottom_border(row, col,
						"thin")
				}
			}
			else {
				if (eti.vsep[1, i-ktitle]==1) {
					xl_class->set_top_border(row, col,
						"thin")
				}
			}
			
			if (j==1) {
				xl_class->set_right_border(row, col, "thin")
			}
			col = col + 1
		}
		col = ul_col
		row = row + 1
	}
	xl_class->set_bottom_border(ul_row+nrow-1, (ul_col,ul_col+ncol-1),
		"thin")
}

void putexcel_close_file(struct parse_info scalar pr)
{
	if (pr.op_replace) {
		(void)  _stata(sprintf(`"quietly erase "%s""', pr.filename), 1)
	}

	pr.xl_class->close_book()

	if (pr.xl_class->get_last_error()) {
		errprintf("file {bf:%s} could not be saved\n", pr.filename) ;
		exit(603)
	}

	printf("{txt}file %s saved\n", pr.filename)
}

// ============================================================================
// Advanced syntax
// ============================================================================

void putexcel_adv_set()
{
	struct parse_info scalar	pr
	string scalar			ftype, fmode, fmtmode

	(void) putexcel_parse_info_init(pr)
	(void) putexcel_build_filename(pr)

	if (pr.is_xlsx) {
		ftype = "xlsx"
	}
	else {
		ftype = "xls"
	}

	if (st_local("modify") != "" & st_local("replace")!="") {
		errprintf(`"options {bf:modify} and {bf:replace} "')
		errprintf(`"are mutually exclusive\n"')
		exit(198)
	}

	if (st_local("modify") != "") {
		fmode = "modify"
	}
	else if (st_local("replace") != "") {
		fmode = "replace"
	}
	else {
		fmode = "create"
	}

	if (st_local("keepcellformat") != "") {
		fmtmode = "on"
	}
	else {
		fmtmode = "off"
	}

	if (st_local("sheet") != "") {
		putexcel_parse_sheet(pr)
	}
	if (st_local("locale") != "") {
		pr.op_locale = st_local("locale")
	}

	(void) putexcel_adv_set_file_info(pr.filename, ftype, fmode,
		pr.op_sheet, fmtmode, pr.op_locale)
}

void putexcel_adv_set_file_info(string scalar filename, string scalar filetype,
	string scalar filemode, string scalar sheetname, 
	string scalar fmtmode, string scalar locale)
{
	st_global("PUTEXCEL_FILE_NAME", filename)
	st_global("PUTEXCEL_FILE_TYPE", filetype)
	st_global("PUTEXCEL_FILE_MODE", filemode)
	st_global("PUTEXCEL_SHEET_NAME", sheetname)
	st_global("PUTEXCEL_KEEP_CELL_FORMAT", fmtmode)
	st_global("PUTEXCEL_LOCALE", locale)
}

void putexcel_adv_describe()
{
	real scalar		maxlen
	string colvector	file_info

	file_info = putexcel_adv_get_file_info()

	displayas("txt")
	printf("\n")
	maxlen = 11
	maxlen = strlen(file_info[1])
	if (maxlen < 11) maxlen = 11
	if (maxlen > 60) maxlen = 60
	printf("  {hline %g}{c +}{hline %g}\n", 11, maxlen+3)
	printf("  {cmd:Filename}   {c |}  %s\n", file_info[1])
	printf("  {cmd:Filetype}   {c |}  %s\n", file_info[2])
	printf("  {cmd:Write mode} {c |}  %s\n", file_info[3])
	printf("  {cmd:Sheetname}  {c |}  %s\n", file_info[4])
	printf("  {cmd:Locale}     {c |}  %s\n", file_info[6])
}

void putexcel_adv_clear()
{
	(void) putexcel_adv_set_file_info("", "", "", "", "", "")
}

void putexcel_adv_cellexplist()
{
	struct parse_info scalar	pr
	string scalar			file_info

	file_info = putexcel_adv_get_file_info()
	(void) putexcel_parse_info_init(pr)

	pr.filename = file_info[1]

	if (file_info[3] == "replace") {
		pr.op_modify = 0
		pr.op_replace = 1
		(void) putexcel_adv_set_file_info(pr.filename, file_info[2],
			"modify", file_info[4], file_info[5], file_info[6])
	}
	else if (file_info[3] == "create") {
		pr.op_modify = 0
		pr.op_replace = 0
		(void) putexcel_adv_set_file_info(pr.filename, file_info[2],
			"modify", file_info[4], file_info[5], file_info[6])
	}
	else {
		pr.op_modify = 1
		 pr.op_replace = 0
	}

	if (file_info[2] == "xlsx") {
		pr.is_xlsx = 1
	}
	else {
		pr.is_xlsx = 0
	}

	if (file_info[4]!="") {
		pr.op_sheet = file_info[4]
	}

	if (st_local("sheet") != "") {
		putexcel_parse_sheet(pr)
		file_info = putexcel_adv_get_file_info()
		(void) putexcel_adv_set_file_info(file_info[1], file_info[2],
			file_info[3], pr.op_sheet, file_info[5], file_info[6])
	}

	if (file_info[5]=="on") {
		pr.op_keepcellformat = 1
	}

	pr.op_colwise = (st_local("colwise") != "")
	(void) putexcel_parse_cellexplist(pr)
	(void) putexcel_write_data(pr)
}

string colvector putexcel_adv_get_file_info()
{
	string scalar           tmp
	string colvector        file_info

	file_info = J(6,1,"")

	tmp = st_global("PUTEXCEL_FILE_NAME")

	if (tmp == "") {
		errprintf("no Excel file specified\n")
		exit(198)
	}
	file_info[1,1] = tmp
	tmp = st_global("PUTEXCEL_FILE_TYPE")
	file_info[2,1] = tmp
	tmp = st_global("PUTEXCEL_FILE_MODE")
	file_info[3,1] = tmp
	tmp = st_global("PUTEXCEL_SHEET_NAME")
	file_info[4,1] = tmp
	tmp = st_global("PUTEXCEL_KEEP_CELL_FORMAT")
	file_info[5,1] = tmp
	tmp = st_global("PUTEXCEL_LOCALE")
	file_info[6,1] = tmp

	return(file_info)
}

// ============================================================================
// Utilities
// ============================================================================

real rowvector putexcel_get_col_row_from_cell(pointer(`XL') scalar xl_class,
	string scalar cell)
{
	real rowvector		col_row
	string scalar		column
	string scalar		str_row
	string scalar		c1
	real scalar		i
	real scalar		len
	real scalar		num_c

	col_row = J(1, 2, .)

	cell = strupper(cell)
	len = strlen(cell)
	if (len < 2) {
		return(col_row)
	}

	column = ""
	for (i=1;i<=len;i++) {
		c1 = bsubstr(cell, i, 1)
		num_c = ascii(c1)
		if (num_c < 65 | num_c > 90) {
			if (i==1) {
				return(col_row)
			}
			break
		}
		else {
			column = column + c1
		}
	}

	col_row[1,1] = xl_class->get_colnum(column)

	str_row = bsubstr(cell, i, .)
	col_row[1,2] = strtoreal(str_row)

	return(col_row)
}

void putexcel_check_cell_range(real scalar is_xlsx, 
	pointer(`XL') scalar xl_class,
	real rowvector col_row, string scalar cell)
{
	if (missing(col_row[1,1]) | missing(col_row[1,2])) {
		errprintf("{bf:%s}: invalid cell name\n", cell)
		exit(198)
	}

	if (!(xl_class->is_valid_col(is_xlsx, col_row[1,1]))) {
		errprintf("{bf:%s}: Excel column out of range\n", cell)
		exit(198)
	}

	if (!(xl_class->is_valid_row(is_xlsx, col_row[1,2]))) {
		errprintf("{bf:%s}: Excel row out of range\n", cell)
		exit(198)
	}
}

real scalar putexcel_check_paren(string scalar expression)
{
	if (bsubstr(expression, 1, 1) != "(") {
		return(`False')
	}
	if (bsubstr(expression, strlen(expression), 1) != ")") {
		return(`False')
	}
	return(`True')
}

string scalar putexcel_remove_paren(string scalar value)
{
	string scalar		rev

	if (bsubstr(value, 1, 1) == "(") {
		value = subinstr(value, "(", "", 1)
	}

	rev = strreverse(value)
	if (bsubstr(rev, 1, 1) == ")") {
		value = strreverse(subinstr(rev, ")", "", 1))
	}
	return(value)
}

string scalar putexcel_remove_quote(string scalar value)
{
	string scalar			s_quote, e_quote

	s_quote = char(96) + char(34)
	e_quote = char(34) + char(39)

	if (strpos(value, s_quote) > 0) {
		value = subinstr(value, s_quote, "")
	}
	if (strpos(value, e_quote) > 0) {
		value = subinstr(value, e_quote, "")
	}

	if (strpos(value, `"""') > 0) {
		value = subinstr(value, `"""', "")
	}
	return(value)
}

void putexcel_check_on_off(string scalar value)
{
	if (value != "on" & value != "off") {
		errprintf("{bf:%s}: invalid format argument\n", value)
		exit(198)
	}
}

void putexcel_dump_parse_info(struct parse_info scalar pr)
{
	real scalar		i

	printf("Parsing info\n")
	printf("-------------------------------------------------\n")
	printf("           filename = %s\n", pr.filename)
	printf("           op_sheet = %s\n", pr.op_sheet)
	printf("    op_sheetreplace = %g\n", pr.op_sheetreplace)
	printf("         op_colwise = %g\n", pr.op_colwise)
	printf("          op_modify = %g\n", pr.op_modify)
	printf("         op_replace = %g\n", pr.op_replace)
	printf("            is_xlsx = %g\n", pr.is_xlsx)

	for (i=1; i<=length(pr.cei); i++) {
		putexcel_dump_cellexp(i, *(pr.cei[i]))
	}
}

void putexcel_dump_cellexp(real scalar i, `CEI' cei)
{
	real scalar		j

	printf("\n")
	printf("%g Cell=Expression\n", i)
	printf("-------------------------------------------------\n")
	printf("              cell = %s\n", cei.ci.cell)
	printf("          ul_cell_col = %g\n", cei.ci.ul_cell_col)
	printf("          ul_cell_row = %g\n", cei.ci.ul_cell_row)
	printf("          lr_cell_col = %g\n", cei.ci.lr_cell_col)
	printf("          lr_cell_row = %g\n", cei.ci.lr_cell_row)
	printf("\n")

	printf("        expression = %s\n", cei.ei.expression)

	printf("\n")
	if (cei.ei.exp_type == `IS_EXP') {
		printf("%g Exp eval Info\n", i)
		printf("   eval_str_scalar = %s\n", cei.ei.evi->eval_str_scalar)
		printf("   eval_num_scalar = %g\n", cei.ei.evi->eval_num_scalar)
	}
	else if (cei.ei.exp_type == `IS_MATRIX') {
		printf("%g Matrix Info\n", i)
		cei.ei.mi->eval_mat
		cei.ei.mi->eval_mat_row_stripes
		cei.ei.mi->eval_mat_col_stripes
	}
	else if (cei.ei.exp_type == `IS_RESULTSET') {
		printf("%g Resultset Info\n", i)
		printf("      resultset_cat = %s\n", cei.ei.rsi->resultset_cat)
		printf("   resultset_subcat = %s\n",
			cei.ei.rsi->resultset_subcat)
		for (j=1; j<length(cei.ei.rsi->ri); j++) {
			putexcel_dump_return_info(j, *(cei.ei.rsi->ri[j]))
		}
	}
}

void putexcel_dump_return_info(real scalar j, `RI' ri)
{
	printf("%g Return value\n", j)
	printf("-------------------------------------------------\n")
	printf("              type = %s\n", ri.type)
	printf("              name = %s\n", ri.name)
	printf("        ret_scalar = %g\n", ri.ret_scalar)
	printf("         ret_macro = %s\n", ri.ret_macro)
	//      printf("        ret_matrix = %s\n", ri.tmpname)
	printf("\n")
	printf("        cell_ul_col = %g\n", ri.cell_ul_col)
	printf("        cell_lr_col = %g\n", ri.cell_lr_col)
	printf("        cell_ul_row = %g\n", ri.cell_ul_row)
	printf("        cell_lr_row = %g\n", ri.cell_lr_row)
	printf("\n")
}

void putexcel_error_close_file(pointer (`XL') scalar xl_class,
	string scalar errmsg, real scalar errcode)
{
	string scalar			tmp

	errprintf("%s\n", errmsg)
	tmp = st_global("PUTEXCEL_OPEN_FHANDLE")
	if (tmp != "yes") {
		xl_class->close_book()
	}
	exit(errcode)
}

// ============================================================================
// New syntax
// ============================================================================

void putexcel_set_new()
{
	struct parse_info scalar	pr
	string scalar			quote, fopen
	real scalar			rc, fh
	pointer(`XL') scalar		p

	quote = `"""'
	fopen = st_global("PUTEXCEL_OPEN_FHANDLE")
	if (fopen == "yes") {
		errprintf(`"Excel file open\n"')
		errprintf(`"{p 4 4 2}"')
		errprintf(`"Type {bf:putexcel save} to save the existing open file. Type"')
		errprintf(`"{p_end}\n\n"')
		errprintf(`"        {bf:putexcel describe}\n\n"')
		errprintf(`"{p 4 4 2}"')
		errprintf(`"to see current settings."')
		errprintf(`"{p_end}\n\n"')
		exit(198)
	}

	(void) putexcel_parse_info_init_new(pr)
	(void) putexcel_build_filename(pr)

	if (st_local("modify") != "" & st_local("replace")!="") {
		errprintf(`"options {bf:modify} and {bf:replace} "')
		errprintf(`"are mutually exclusive\n"')
		exit(198)
	}
	if (st_global("c(os)")=="Windows") {
		rc = _stata(sprintf("quietly confirm new file %s%s%s",
                        quote, pr.filename, quote), 1)
                if (rc==602) {
			fh = _fopen(pr.filename, "a")
			if (fh < 0) {
		errprintf("file {bf:%s} is open in another application\n",
				pr.filename)
				exit(603)
			}
			fclose(fh)
		}
	}
	if (st_local("replace") != "") {
		pr.op_replace = 1
		if (st_local("open") != "") {
			printf(`"{txt}Note: file will be replaced when {cmd:putexcel save} command is issued\n"')
		}
		else {
			printf(`"{txt}Note: file will be replaced when the first {cmd:putexcel} command is issued\n"')
		}
	}
	else if (st_local("modify") != "") {
		if (st_local("open") != "") {
			printf(`"{txt}Note: file will be modified when {cmd:putexcel save} command is issued\n"')
		}
		pr.op_modify = 1
	}
	else {
		rc = _stata(sprintf("quietly confirm new file %s%s%s",
			quote, pr.filename, quote), 1)
		if (rc) {
			errprintf("file already exists\n")
			errprintf("you must specify either the {bf:modify} ")
			errprintf("or {bf:replace} option\n")
			exit(602)
		}
	}

	pr.op_open = (st_local("open") != "")
	if (pr.op_open) {
		p = crexternal("__putexcel_open_fhandle")
		*p = *pr.xl_class
	}

	if (st_local("sheet") != "") {
		putexcel_parse_sheet(pr)
	}
	if (st_local("locale") != "") {
		pr.op_locale = st_local("locale")
	}

	(void) putexcel_set_file_info_new(pr, `False')
}

void putexcel_set_file_info_new(`PIN' pr, real scalar clear)
{
	string scalar			ftype, fmode, s_replace, open
//	string scalar			fmtmode
	string scalar			filename

	if (clear) {
		open = st_global("PUTEXCEL_OPEN_FHANDLE")
		if (open == "yes") {
			pr.xl_class = findexternal("__putexcel_open_fhandle")
			if (pr.xl_class == NULL) {
				errprintf(`"file handle not found\n"')
				exit(198)
			}
			filename = pr.xl_class->query("filename")
			if (filename != "") {
				pr.xl_class->set_mode("closed")
				pr.xl_class->close_book()
			}

			rmexternal("__putexcel_open_fhandle")
		}
		st_global("PUTEXCEL_FILE_NAME", "")
		st_global("PUTEXCEL_FILE_TYPE", "")
		st_global("PUTEXCEL_FILE_MODE", "")
		st_global("PUTEXCEL_SHEET_NAME", "")
		st_global("PUTEXCEL_SHEET_REPLACE", "")
//		st_global("PUTEXCEL_KEEP_CELL_FORMAT", "")
		st_global("PUTEXCEL_LOCALE", "")
		st_global("PUTEXCEL_OPEN_FHANDLE", "")
	}
	else {
		if (pr.is_xlsx) {
			ftype = "xlsx"
		}
		else {
			ftype = "xls"
		}

		if (pr.op_replace) {
			fmode = "replace"
		}
		else if (pr.op_modify) {
			fmode = "modify"
		}
		else {
			fmode = "create"
		}
		
		if (pr.op_sheetreplace) {
			s_replace = "replace"
		}
		else {
			s_replace = ""
		}

		if (pr.op_open) {
			open = "yes"
		}
		else {
			open = "no"
		}

		st_global("PUTEXCEL_FILE_NAME", pr.filename)
		st_global("PUTEXCEL_FILE_TYPE", ftype)
		st_global("PUTEXCEL_FILE_MODE", fmode)
		st_global("PUTEXCEL_SHEET_NAME", pr.op_sheet)
		st_global("PUTEXCEL_SHEET_REPLACE", s_replace)
	//	st_global("PUTEXCEL_KEEP_CELL_FORMAT", fmtmode)
		st_global("PUTEXCEL_LOCALE", pr.op_locale)
		st_global("PUTEXCEL_OPEN_FHANDLE", open)
	}
}

void putexcel_describe_new()
{
	`PIN'				pr
	string scalar			ftype, fmode, open
	real scalar			maxlen

	(void) putexcel_get_file_info_new(pr)

	if (pr.is_xlsx) {
		ftype = "xlsx"
	}
	else {
		ftype = "xls"
	}

	if (pr.op_replace) {
		fmode = "replace"
	}
	else if (pr.op_modify) {
		fmode = "modify"
	}
	else {
		fmode = "create"
	}

	if (pr.op_open) {
		open = "yes"
	}
	else {
		open = "no"
	}

	displayas("txt")
	printf("\n")
	maxlen = 11
	maxlen = strlen(pr.filename)
	if (maxlen < 11) maxlen = 11
	if (maxlen > 60) maxlen = 60
	printf("  {hline %g}{c +}{hline %g}\n", 17, maxlen+3)
	printf("  {cmd:Filename}         {c |}  %s\n", pr.filename)
	printf("  {cmd:Filetype}         {c |}  %s\n", ftype)
	printf("  {cmd:Write mode}       {c |}  %s\n", fmode)
	printf("  {cmd:Sheetname}        {c |}  %s\n", pr.op_sheet)
	printf("  {cmd:Locale}           {c |}  %s\n", pr.op_locale)
	printf("  {cmd:Open file handle} {c |}  %s\n", open)
}

void putexcel_clear_new()
{
	`PIN'			pr

	(void) putexcel_set_file_info_new(pr, `True')
}

void putexcel_close_new()
{
	`PIN'			pr
	string scalar		filename

	(void) putexcel_parse_info_init_new(pr)
	(void) putexcel_get_file_info_new(pr)

	if (pr.op_open) {
		st_global("PUTEXCEL_OPEN_FHANDLE", "no")
		filename = pr.xl_class->query("filename")
		if (filename == "") {
			printf("{txt}no data written\n")
		}
		else {
			(void) putexcel_close_file(pr)
		}
		rmexternal("__putexcel_open_fhandle")
	}
}

void putexcel_cellexplist_new()
{
	`PIN'			pr

	(void) putexcel_parse_info_init_new(pr)
	(void) putexcel_get_file_info_new(pr)
	(void) putexcel_parse_syntax_new(pr)
	(void) putexcel_write_data(pr)

	// after replacing file mode switches to modify
	st_global("PUTEXCEL_FILE_MODE", "modify")
}

void putexcel_get_file_info_new(`PIN' pr)
{
	string scalar           tmp

	tmp = st_global("PUTEXCEL_FILE_NAME")
	if (tmp == "") {
		errprintf("no Excel file specified\n")
		exit(198)
	}
	pr.filename = tmp
	tmp = st_global("PUTEXCEL_FILE_TYPE")
	if (tmp == "xlsx") {
		pr.is_xlsx = 1
	}
	else {
		pr.is_xlsx = 0
	}

	tmp = st_global("PUTEXCEL_FILE_MODE")
	if (tmp == "replace") {
		pr.op_replace = 1
		pr.op_modify = 0
	}
	else if (tmp == "modify") {
		pr.op_replace = 0
		pr.op_modify = 1
	}
	else {
		pr.op_replace = 0
		pr.op_modify = 0
	}

	tmp = st_global("PUTEXCEL_SHEET_NAME")
	pr.op_sheet = tmp
	tmp = st_global("PUTEXCEL_SHEET_REPLACE")
	if (tmp == "replace") {
		pr.op_sheetreplace = 1
	}
	else {
		pr.op_sheetreplace = 0
	}
	tmp = st_global("PUTEXCEL_LOCALE")
	pr.op_locale = tmp

	tmp = st_global("PUTEXCEL_OPEN_FHANDLE")
	if (tmp == "yes") {
		pr.op_open = 1
	}
	else {
		pr.op_open = 0
	}
}

void putexcel_parse_info_init_new(`PIN' pr)
{
	string scalar				tmp
	class xl 				b

	tmp = st_global("PUTEXCEL_OPEN_FHANDLE")
	if (tmp == "yes") {
		pr.op_open = 1
	}
	else {
		pr.op_open = 0
	}

	if (pr.op_open) {
		pr.xl_class = findexternal("__putexcel_open_fhandle")
		if (pr.xl_class == NULL) {
			errprintf(`"file handle not found\n"')
			exit(604)
		}
	}
	else {
		b = xl()
		pr.xl_class = &b
	}
	pr.filename = ""
	pr.op_sheet = "Sheet1"
	pr.op_locale = "UTF-8"
	pr.op_sheetreplace = 0
	pr.op_sheetnogrid = .
	pr.op_colwise = 0
	pr.op_modify = 0
	pr.op_replace = 0
	pr.op_keepcellformat = 0
	pr.is_xlsx = 1
	pr.is_new_syntax = 1

	pr.pei = &(parse_export_info())
	(void) putexcel_export_info_init(*(pr.pei))
	pr.fin = &(format_info_new())
	(void) putexcel_format_info_init_new(*(pr.fin))
}

void putexcel_format_info_init_new(`FIN' fin)
{
	fin.op_nformat = ""
	fin.op_bold = ""
	fin.op_italic = ""
	fin.op_underline = ""
	fin.op_script = ""
	fin.op_txtwrap = ""
	fin.op_shrinkfit = ""
	fin.op_strikeout = ""
	fin.halign = ""
	fin.valign = ""
	fin.op_fmtlock = ""
	fin.op_fmthidden = ""
	fin.op_txtindent = .
	fin.op_txtrotate = .
	fin.op_merge = .
	fin.bi = J(1, 1, NULL)
	fin.dbi = J(1, 1, NULL)
	fin.fpi = J(1, 1, NULL)
	fin.fti = J(1, 1, NULL)
}

void putexcel_export_info_init(`PEI' pei)
{
	pei.op_overwrite_fmt = 0
	pei.op_asdate = 0
	pei.op_asdatetime = 0
	pei.op_asdatenum = 0
	pei.op_asdatetimenum = 0
	pei.op_names = 0
	pei.op_rownames = 0
	pei.op_colnames = 0
}

void putexcel_parse_syntax_new(`PIN' pr)
{
	string scalar		anything, zero, options, tmpstr
	real scalar		num

	zero = st_local("0")
	anything = st_local("anything")
	options = substr(zero, strlen(anything)+1, .)

	if (st_local("sheet") != "") {
		(void) putexcel_parse_sheet(pr)
	}
	if (st_local("locale") != "") {
		pr.op_locale = st_local("locale")
	}

	pr.pei->op_overwrite_fmt = (st_local("overwritefmt") != "")
	if (pr.pei->op_overwrite_fmt) {
		pr.op_keepcellformat = 0
	}
	else {
		pr.op_keepcellformat = 1
	}
	pr.pei->op_asdate = (st_local("asdate") != "")
	pr.pei->op_asdatetime = (st_local("asdatetime") != "")
	pr.pei->op_asdatenum = (st_local("asdatenum") != "")
	pr.pei->op_asdatetimenum = (st_local("asdatetimenum") != "")
	if (pr.pei->op_asdate && (pr.pei->op_asdatetime || 
		pr.pei->op_asdatetimenum || pr.pei->op_asdatenum)) {
		errprintf(`"option {bf:asdate} cannot be combined with "')
errprintf(`"{bf:asdatetime}, {bf:asdatetimenum}, or {bf:asdatenum}\n"')
		exit(198)
	}
	if (pr.pei->op_asdatetime && (pr.pei->op_asdate || 
		pr.pei->op_asdatetimenum || pr.pei->op_asdatenum)) {
		errprintf(`"option {bf:asdatetime} cannot be combined with "')
errprintf(`"{bf:asdate}, {bf:asdatetimenum}, or {bf:asdatenum}\n"')
		exit(198)
	}
	if (pr.pei->op_asdatenum && (pr.pei->op_asdate || 
		pr.pei->op_asdatetime || pr.pei->op_asdatetimenum)) {
		errprintf(`"option {bf:asdatenum} cannot be combined with "')
errprintf(`"{bf:asdatetime}, {bf:asdatetimenum}, or {bf:asdate}\n"')
		exit(198)
	}

	pr.pei->op_names = (st_local("names") != "")
	pr.pei->op_rownames = (st_local("rownames") != "")
	pr.pei->op_colnames = (st_local("colnames") != "")

	if (pr.pei->op_names && pr.pei->op_rownames) {
		errprintf(`"options {bf:names} and {bf:rownames} "')
		errprintf(`"are mutually exclusive\n"')
		exit(198)
	}
	if (pr.pei->op_names && pr.pei->op_colnames) {
		errprintf(`"options {bf:names} and {bf:colnames} "')
		errprintf(`"are mutually exclusive\n"')
		exit(198)
	}
	if (pr.pei->op_colnames && pr.pei->op_rownames) {
		errprintf(`"options {bf:rownames} and {bf:colnames} "')
		errprintf(`"are mutually exclusive\n"')
		exit(198)
	}

	pr.op_colwise = (st_local("colwise") != "")

	if (st_local("nformat") != "") {
		pr.fin->op_nformat = st_local("nformat")
	}
	if (strpos(options, "bold") > 0) {
		pr.fin->op_bold = "on"
	}
	if (st_local("bold") != "") {
		pr.fin->op_bold = "off"
	}
	if (strpos(options, "italic") > 0) {
		pr.fin->op_italic = "on"
	}
	if (st_local("italic") != "") {
		pr.fin->op_italic = "off"
	}
	if (strpos(options, "underline") > 0) {
		pr.fin->op_underline = "on"
	}
	if (st_local("underline") != "") {
		pr.fin->op_underline = "off"
	}
	if (strpos(options, "strikeout") > 0) {
		pr.fin->op_strikeout = "on"
	}
	if (st_local("strikeout") != "") {
		pr.fin->op_strikeout = "off"
	}
	if (strpos(options, "txtwrap") > 0) {
		if (strpos(options, "shrinkfit") > 0) {
			errprintf(`"options {bf:txtwrap} and {bf:shrinkfit} "')
			errprintf(`"are mutually exclusive\n"')
			exit(198)
		}
		pr.fin->op_txtwrap = "on"
	}
	if (st_local("txtwrap") != "") {
		pr.fin->op_txtwrap = "off"
	}
	if (strpos(options, "shrinkfit") > 0) {
		pr.fin->op_shrinkfit = "on"
	}
	if (st_local("shrinkfit") != "") {
		pr.fin->op_shrinkfit = "off"
	}
	if (strpos(options, "fmtlock") > 0) {
		pr.fin->op_fmtlock = "on"
	}
	if (st_local("fmtlock") != "") {
		pr.fin->op_fmtlock = "off"
	}
	if (strpos(options, "fmthidden") > 0) {
		pr.fin->op_fmthidden = "on"
	}
	if (st_local("fmthidden") != "") {
		pr.fin->op_fmthidden = "off"
	}
	if (st_local("hcenter") != "" || st_local("left") != "" ||
		st_local("right") != "") {
		tmpstr = st_local("hcenter")
		if (tmpstr != "" && st_local("left") != "") {
		errprintf("only one horizontal alignment may be specified\n")
			exit(198)
		}
		if (tmpstr != "" && st_local("right") != "") {
		errprintf("only one horizontal alignment may be specified\n")
			exit(198)
		}
		tmpstr = st_local("left")
		if (tmpstr != "" && st_local("right") != "") {
		errprintf("only one horizontal alignment may be specified\n")
			exit(198)
		}
		if (st_local("hcenter") != "") {
			tmpstr = "center"
		}
		else if (st_local("right") != "") {
			tmpstr = "right"
		}
		else {
			tmpstr = "left"
		}
		pr.fin->halign = tmpstr
	}
	if (st_local("vcenter") != "" || st_local("top") != "" ||
		st_local("bottom") != "") {
		tmpstr = st_local("vcenter")
		if (tmpstr != "" && st_local("top") != "") {
		errprintf("only one vertical alignment may be specified\n")
			exit(198)
		}
		if (tmpstr != "" && st_local("bottom") != "") {
		errprintf("only one vertical alignment may be specified\n")
			exit(198)
		}
		tmpstr = st_local("top")
		if (tmpstr != "" && st_local("bottom") != "") {
		errprintf("only one vertical alignment may be specified\n")
			exit(198)
		}
		if (st_local("vcenter") != "") {
			tmpstr = "center"
		}
		else if (st_local("top") != "") {
			tmpstr = "top"
		}
		else {
			tmpstr = "bottom"
		}
		pr.fin->valign = tmpstr
	}
	if (st_local("script") != "") {
		tmpstr = st_local("script")
		if (tmpstr!="sub" & tmpstr!="super" & tmpstr!="normal") {
			errprintf("{bf:%s}: invalid script() argument\n",
				tmpstr)
			exit(198)
		}
		pr.fin->op_script = tmpstr
	}
	if (st_local("font") != "") {
		tmpstr = st_local("font")
		pr.fin->fti = &(font_info())
		putexcel_check_font(tmpstr, *(pr.fin->fti), pr.xl_class,
			pr.is_new_syntax)
	}
	if (st_local("border") != "") {
		tmpstr = st_local("border")
		pr.fin->bi = &(border_info())
		putexcel_check_border(tmpstr, *(pr.fin->bi), pr.xl_class,
			pr.is_new_syntax)
	}
	if (st_local("dborder") != "") {
		tmpstr = st_local("dborder")
		pr.fin->dbi = &(dborder_info())
		putexcel_check_dborder(tmpstr, *(pr.fin->dbi), pr.xl_class,
			pr.is_new_syntax)
	}
	if (st_local("fpattern") != "") {
		tmpstr = st_local("fpattern")
		pr.fin->fpi = &(fpattern_info())
		putexcel_check_fpattern(tmpstr, *(pr.fin->fpi), pr.xl_class,
			pr.is_new_syntax)
	}
	if (st_local("txtrotate") != "-1") {
		num = strtoreal(st_local("txtrotate"))
		if (missing(num)) {
			errprintf("{bf:%f}: invalid txtrotate() argument\n",
				num)
			exit(198)
		}
		if (num < 0 | num > 180) {
			if (num != 255) {
		errprintf("{bf:%f}: invalid txtrotate() argument\n", num)
				exit(198)
			}
		}
		pr.fin->op_txtrotate = num
	}
	if (st_local("txtindent") != "-1") {
		num = strtoreal(st_local("txtindent"))
		if (missing(num) | num < 0 | num > 15) {
			errprintf("{bf:%f}: invalid txtindent() argument\n",
				num)
			exit(198)
		}
		pr.fin->op_txtindent = num
	}
	if (st_local("merge") != "") {
		if (st_local("unmerge") != "") {
			errprintf(`"options {bf:merge} and {bf:unmerge} "')
			errprintf(`"are mutually exclusive\n"')
			exit(198)
		}
		pr.fin->op_merge = 1
	}
	if (st_local("unmerge") != "") {
		pr.fin->op_merge = 0
	}

	(void) putexcel_parse_cellexplist(pr)
}

end

