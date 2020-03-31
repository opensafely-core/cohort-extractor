*! version 1.3.1  12sep2019
program define import_delimited, rclass
	local ver : display "version " string(_caller()) ", missing:"
	
	version 14

	gettoken filename rest : 0, parse(" ,")
	gettoken comma : rest, parse(" ,")

	if (`"`filename'"' != "" & (trim(`"`comma'"') == "," |		///
		trim(`"`comma'"') == "")) {
		local 0 `"using `0'"'
	}

	capture syntax using/						///
		[, DELIMiters(string asis)				///
		ROWRange(string)					///
		COLRange(string)					///
		VARNames(string)					///
		case(string)						///
		ASDOUBle						///
		ASFLOat							///
		clear							///
		BINDQuotes(string)					///
		STRIPQuotes(string)					///
		NUMERICCols(string)					///
		STRINGCols(string)					///
		CHARSET(string)						///
		ENCoding(string)					///
		PARSELocale(string)					///
		GROUPSeparator(string)					///
		DECIMALSeparator(string)				///
		MAXQUOTEDRows(string)					///
		COLLAPSEDelimiters]
	if _rc {
		syntax [anything(name=vlist id="vlist")] using/		///
			[, DELIMiters(string asis)			///
			ROWRange(string)				///
			COLRange(string)				///
			VARNames(string)				///
			case(string)					///
			ASDOUBle					///
			ASFLOat						///
			clear						///
			BINDQuotes(string)				///
			STRIPQuotes(string)				///
			NUMERICCols(string)				///
			STRINGCols(string)				///
			CHARSET(string)					///
			ENCoding(string)				///
			PARSELocale(string)				///
			GROUPSeparator(string)				///
			DECIMALSeparator(string)			///
			MAXQUOTEDRows(string)				///
			COLLAPSEDelimiters]
	}

	mata:import_delim_import_file()

	return add
end

version 13.0
mata:
mata set matastrict on

struct _import_delim_parse_info {
	string scalar		filename
	string rowvector	varlist
	string scalar		op_delimiters
	string scalar		op_delimiters_collapse
	string scalar		op_delimiters_asstring
	string scalar		firstrow
	string scalar		op_case
	string scalar		op_bindquotes
	string scalar		op_stripquotes
	string scalar		op_numericcols
	string scalar		op_stringcols
	string scalar		op_varnames_row
	string scalar		op_encoding
	string scalar		op_parse_locale
	string scalar		op_group_sep
	string scalar		op_decimal_sep
	string scalar		op_max_quoted_rows
	string scalar		start_row
	string scalar		end_row
	string scalar		start_col
	string scalar		end_col
	string scalar		s_version
	real scalar		op_asdouble
	real scalar		op_asfloat
	real scalar		op_clear
}

void import_delim_import_file()
{
	struct _import_delim_parse_info scalar pr

	import_delim_pr_init(pr)
	import_delim_parse_syntax(pr)
	import_delim_load_file(pr)
}

void import_delim_pr_init(struct _import_delim_parse_info scalar pr)
{
	pr.filename = ""
	pr.varlist = J(1,0,0)
	pr.op_delimiters = ""
	pr.op_delimiters_collapse = ""
	pr.op_delimiters_asstring = ""
	pr.firstrow = "auto"
	pr.op_case = "lower"
	pr.op_bindquotes = "loose"
	pr.op_stripquotes = "default"
	pr.op_numericcols = ""
	pr.op_stringcols = ""
	pr.op_varnames_row = ""
	pr.op_encoding = "latin1"
	pr.op_parse_locale = ""
	pr.op_group_sep = ""
	pr.op_decimal_sep = ""
	pr.op_max_quoted_rows = ""
	pr.start_row = ""
	pr.end_row = ""
	pr.start_col = ""
	pr.end_col = ""
	pr.s_version = ""
	pr.op_asdouble = .
	pr.op_asfloat = .
	pr.op_clear = .
}

void import_delim_parse_syntax(struct _import_delim_parse_info scalar pr)
{
	string scalar		filename

	filename = st_local("using")

	pr.filename =  __import_check_using_file(filename, ".csv")

	if (st_local("vlist") != "") {
		import_delim_check_varlist(pr)
	}

	if (st_local("delimiters") != "") {
		import_delim_parse_delimiters(pr)
	}

	if (st_local("rowrange") != "") {
		import_delim_parse_rowrange(pr)
	}

	if (st_local("colrange") != "") {
		import_delim_parse_colrange(pr)
	}

	if (st_local("varnames") != "") {
		import_delim_parse_varnames(pr)
	}

	if (st_local("numericcols") != "") {
		import_delim_parse_numericcols(pr)
	}

	if (st_local("stringcols") != "") {
		import_delim_parse_stringcols(pr)
	}

	if (st_local("charset") != "") {
		pr.op_encoding = strtrim(st_local("charset"))
	}
	if (st_local("encoding") != "") {
		pr.op_encoding = strtrim(st_local("encoding"))
	}

	if (pr.op_numericcols == "_all" & pr.op_stringcols == "_all") {
		errprintf("{bf:numericcols(_all)} cannot be combined with ")
		errprintf("{bf:stringcols(_all)}\n")
			exit(198)
	}

	pr.op_case = __import_parse_case_opt()

	if (st_local("bindquotes") != "") {
		import_delim_parse_bindquotes(pr)
	}

	if (st_local("stripquotes") != "") {
		import_delim_parse_stripquotes(pr)
	}

	pr.op_clear = (st_local("clear") != "")
	pr.s_version = st_local("ver")
	pr.op_asdouble = (st_local("asdouble") != "")
	pr.op_asfloat = (st_local("asfloat") != "")
	
	if (st_local("parselocale") != "") {
		pr.op_parse_locale = strtrim(st_local("parselocale"))
	}
	
	if (st_local("groupseparator") != "") {
		pr.op_group_sep = strtrim(st_local("groupseparator"))
		if (strlen(pr.op_group_sep) > 1) {
			errprintf("option {bf:groupseparator()} may contain only one character.\n")
			exit(198)
		}
	}
	
	if (st_local("decimalseparator") != "") {
		pr.op_decimal_sep = strtrim(st_local("decimalseparator"))
		if (strlen(pr.op_decimal_sep) > 1) {
			errprintf("option {bf:decimalseparator()} may contain only one character.\n")
			exit(198)
		}
	}
	
	if (st_local("maxquotedrows") != "") {
		real scalar r
		pr.op_max_quoted_rows = strtrim(st_local("maxquotedrows"))
		if (strmatch(pr.op_max_quoted_rows, "unlimited")) {
			pr.op_max_quoted_rows = "0"
		}
		r = strtoreal(pr.op_max_quoted_rows)
		if (r == . | floor(r) != r) {
			errprintf("option {bf:maxquotedrows()} incorrectly specified.\n")
			exit(198)
		}
	}

	if (pr.op_asfloat & pr.op_asdouble) {
errprintf("{bf:asfloat()} and {bf:asdouble()} are mutually exclusive options\n")
		exit(198)
	}
}

void import_delim_check_file(struct _import_delim_parse_info scalar pr)
{
	string scalar		default_filetype
	string scalar		using_file, basename
	real scalar		rc

	using_file = st_local("using")

	basename = pathbasename(using_file)
	if (basename=="") {
		errprintf("%s not a valid filename\n", using_file)
		exit(198)
	}

	if (pathisurl(using_file)) {
		pr.filename = st_tempfilename()
		rc =  _stata(sprintf(`"copy `"%s"' `"%s"'"', using_file,
			pr.filename))
		if (rc) {
			errprintf("could not open url\n")
			exit(603)
		}
		return
	}
/*
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
		}
		using_file = pathjoin(path, file)
	}
*/

	default_filetype = ".csv"
	if (pathsuffix(using_file) == "") {
		using_file = using_file + default_filetype
	}

	using_file = prochome(using_file, 0)

	if (!fileexists(using_file)) {
		errprintf("file %s not found\n", using_file)
		exit(601)
	}

	pr.filename = using_file
}

void import_delim_check_varlist(struct _import_delim_parse_info scalar pr)
{
	string rowvector	varlist
	real scalar		i

	varlist = tokens(st_local("vlist"))

	for (i=1; i<=cols(varlist); i++) {
		if (!st_isvarname(varlist[i])) {
			errprintf("{bf:%s}: invalid variable name\n",
				varlist[i])
			exit(198)
		}
	}

	pr.varlist = varlist
}

void import_delim_parse_delimiters(struct _import_delim_parse_info scalar pr)
{
	string scalar		delimiter, tmp
	real scalar		has_comma, has_quote
	transmorphic		t
	string scalar		shortcut, option

	delimiter = st_local("delimiters")

	has_comma = strpos(delimiter, ",")
	has_quote = strpos(delimiter, `"""')

	if (has_comma) {
		if (has_quote) {
			t = tokeninit("", `","', (`""""', `"`""'"'), 0, 0)
			tokenset(t, delimiter)
			tmp = tokengetall(t)
			delimiter = tmp[1]
			if (strpos(delimiter, "\t")>0) {
				delimiter = subinstr(delimiter,"\t",char(9), .)
			}
			delimiter = import_delim_strip_quotes(delimiter)
			if (cols(tmp)>3) {
				errprintf("invalid {bf:delimiter()} argument\n")
				exit(198)
			}

			if (cols(tmp)==3) {
				option = strtrim(tmp[3])
			}

			if (option != "") {
				if (option == "collapse" | option == "colla" |
				option == "collap" | option == "collaps") {
					pr.op_delimiters_collapse = "TRUE"
				}
				else if (option == "asstring" |
				option == "asstr" | option == "asstri" |
				option == "asstrin") {
					pr.op_delimiters_asstring = "TRUE"
				}
				else {
errprintf("{bf:%s}: invalid {bf:delimiter()} argument\n", option)
					exit(198)
				}
			}
		}
		else {
			t = tokeninit("", `","', (`""""', `"`""'"'), 0, 0)
			tokenset(t, delimiter)
			tmp = tokengetall(t)
			delimiter = strtrim(tmp[1])
			if (delimiter == ",") {
				errprintf("invalid {bf:delimiter()} argument\n")
				exit(198)
			}
			if (cols(tmp)>3) {
				errprintf("invalid {bf:delimiter()} argument\n")
				exit(198)
			}

			if (cols(tmp)==3) {
				option = strtrim(tmp[3])
			}
			else if (cols(tmp)==2 & tmp[1]==",") {
				option = strtrim(tmp[2])
			}

			delimiter = import_delim_check_shortcut(delimiter,
				has_quote)
			if (option == "collapse" | option == "colla" |
				option == "collap" | option == "collaps") {
				pr.op_delimiters_collapse = "TRUE"
			}
			else if (option == "asstring" | option == "asstr" |
				option == "asstri" | option == "asstrin") {
				pr.op_delimiters_asstring = "TRUE"
			}
			else {
errprintf("{bf:%s}: invalid {bf:delimiter()} argument; use {bf:collapse} or {bf:asstring}\n", option)
				exit(198)
			}
		}
	}
	else {
		t = tokeninit("", `","', (`""""', `"`""'"'), 0, 0)
		tokenset(t, delimiter)
		shortcut = tokenget(t)
		delimiter = import_delim_check_shortcut(shortcut,
			has_quote)
		delimiter = import_delim_strip_quotes(delimiter)
	}
	pr.op_delimiters = delimiter
}

string scalar import_delim_check_shortcut(string scalar shortcut,
	real scalar has_quote)
{
	string scalar		delimiter, trim_shortcut


	if (strpos(shortcut, "\t")>0) {
		shortcut = subinstr(shortcut, "\t", char(9), .)
	}

	trim_shortcut = strtrim(shortcut)

	if (trim_shortcut == "tab") {
		delimiter = char(9)
	}
	else if (trim_shortcut == "comma") {
		delimiter = ","
	}
	else if (trim_shortcut == "space") {
		delimiter = " "
	}
	else if (strtrim(shortcut) == "whitespace") {
		delimiter = char(9) + " "
	}
	else {
		if (!has_quote & trim_shortcut != ",") {
errprintf("{bf:%s}: invalid {bf:delimiter()} shortcut\n", shortcut)
			exit(198)
		}
		delimiter = shortcut
	}

	return(delimiter)
}

string scalar import_delim_strip_quotes(string scalar value)
{
	string scalar		rev

	if (bsubstr(value, 1, 1) == "`") {
		value = subinstr(value, "`", "", 1)
		value = subinstr(value, `"""', "", 1)
		rev = strreverse(value)
		rev = subinstr(rev, `"""', "", 1)
		rev = subinstr(rev, `"'"', "", 1)
		return(strreverse(rev))
	}
	if (bsubstr(value, 1, 1) == `"""') {
		value = subinstr(value, `"""', "", 1)
		rev = strreverse(value)
		rev = subinstr(rev, `"""', "", 1)
		return(strreverse(rev))
	}
	return(value)
}

void import_delim_parse_rowrange(struct _import_delim_parse_info scalar pr)
{
	string scalar		rowrange, s_start_row, s_end_row
	real scalar		start_row, end_row

	rowrange = st_local("rowrange")

	if (strpos(rowrange, ":") & strpos(rowrange, ":") != 1) {
		s_start_row = bsubstr(rowrange, 1, strpos(rowrange, ":")-1)
		if (strtrim(s_start_row) == "f") {
			start_row = 1
		}
		else {
			start_row = strtoreal(s_start_row)
		}
		if (start_row == . | start_row < 1 |
			strpos(s_start_row, ".") > 0) {
errprintf("{bf:%s} is an invalid start row in {bf:rowrange()} option\n",
	s_start_row)
			exit(198)
		}
		s_end_row = bsubstr(rowrange, strpos(rowrange, ":")+1, .)
		if (strtrim(s_end_row) == "l") {
			end_row = .
		}
		else if (strtrim(bsubstr(rowrange,
			strpos(rowrange, ":"), .))==":") {
			end_row = .
		}
		else {
			end_row = strtoreal(s_end_row)
			if (end_row == .) {
errprintf("{bf:%s}: invalid end row in {bf:rowrange()} option\n", s_end_row)
                        exit(198)
			}
		}

		if (start_row > end_row) {
errprintf("{bf:%s} is an invalid row range in {bf:rowrange()} option\n",
	rowrange)
errprintf("start row is greater than end row\n")
			exit(198)
		}
		pr.start_row = strofreal(start_row, "%30.0g")
		pr.end_row = strofreal(end_row, "%30.0g")
	}
	else if (strpos(rowrange, ":") == 1) {
		s_end_row = bsubstr(rowrange, strpos(rowrange, ":")+1, .)
		end_row = strtoreal(s_end_row)
		if (end_row == . | end_row < 1 |
			strpos(s_end_row, ".") > 0) {
errprintf("{bf:%s}: invalid end row in {bf:rowrange()} option\n", s_end_row)
			exit(198)
		}
		pr.end_row = strofreal(end_row, "%30.0g")
	}
	else {
		start_row = strtoreal(rowrange)
		if (start_row == . | start_row < 1 |
			strpos(rowrange, ".") > 0) {
errprintf("{bf:%s} is an invalid start row in {bf:rowrange()} option\n",
	rowrange)
			exit(198)
		}
		pr.start_row = strofreal(start_row, "%30.0g")
	}
}

void import_delim_parse_colrange(struct _import_delim_parse_info scalar pr)
{
	string scalar		colrange, s_start_col, s_end_col
	real scalar		start_col, end_col

	colrange = st_local("colrange")

	if (strpos(colrange, ":") & strpos(colrange, ":") != 1) {
		s_start_col = bsubstr(colrange, 1, strpos(colrange, ":")-1)
		if (strtrim(s_start_col) == "f") {
			start_col = 1
		}
		else {
			start_col = strtoreal(s_start_col)
		}
		if (start_col == . | start_col < 1 |
			strpos(s_start_col, ".") > 0) {
errprintf("{bf:%s} is an invalid start column in {bf:colrange()} option\n",
			s_start_col)
			exit(198)
		}

		s_end_col = bsubstr(colrange, strpos(colrange, ":")+1, .)
		if (strtrim(s_end_col) == "l") {
			end_col = .
		}
		else if (strtrim(bsubstr(colrange,
			strpos(colrange, ":"), .))==":") {
			end_col = .
		}
		else {
			end_col = strtoreal(s_end_col)
			if (end_col == .) {
errprintf("{bf:%s}: invalid end col in {bf:colrange()} option\n", s_end_col)
                        exit(198)
			}
		}

		if (start_col > end_col) {
errprintf("{bf:%s} is an invalid column range in {bf:colrange()} option\n",
	colrange)
errprintf("start column is greater than end column\n")
			exit(198)
		}

		pr.start_col = strofreal(start_col, "%30.0g")
		pr.end_col = strofreal(end_col, "%30.0g")
	}
	else if (strpos(colrange, ":") == 1 ) {
		s_end_col = bsubstr(colrange, strpos(colrange, ":")+1, .)
		end_col = strtoreal(s_end_col)
		if (end_col == . | end_col < 1 |
			strpos(s_end_col, ".") > 0) {
errprintf("{bf:%s} is an invalid end column in {bf:colrange()} option\n",
	s_end_col)
			exit(198)
		}
		pr.end_col = strofreal(end_col, "%30.0g")
	}
	else {
		start_col = strtoreal(colrange)
		if (start_col == . | start_col < 1 |
			strpos(colrange, ".") > 0) {
errprintf("{bf:%s} is an invalid start column in {bf:colrange()} option\n",
	colrange)
			exit(198)
		}
		pr.start_col = strofreal(start_col, "%30.0g")
	}
}

void import_delim_parse_varnames(struct _import_delim_parse_info scalar pr)
{
	string scalar		varnames_row
	real scalar		start_row

	varnames_row = strtrim(st_local("varnames"))

	if (varnames_row == "non" |
		varnames_row == "nona" |
		varnames_row == "nonam" |
		varnames_row == "noname" |
		varnames_row == "nonames") {
		pr.firstrow = "no"
		return
	}

	start_row = strtoreal(varnames_row)
	if (start_row == . | start_row < 1 | strpos(varnames_row, ".") > 0) {
errprintf("{bf:%s}: invalid row number in {bf:varnames()} option\n",
		varnames_row)
		exit(198)
	}

	pr.op_varnames_row = varnames_row
}

void import_delim_parse_numericcols(struct _import_delim_parse_info scalar pr)
{
	string scalar		cols
	real scalar		rc

	cols = st_local("numericcols")

	if (strtrim(cols) == "_all") {
		pr.op_numericcols = strtrim(cols)
		return
	}

	rc = _stata(sprintf(`"qui numlist "%s", integer range(>0) sort"',
		cols), 1)
	if (rc) {
errprintf("{bf:%s}: invalid numlist in {bf:numericcols()} option\n", cols)
		exit(198)
	}
	pr.op_numericcols = st_global("r(numlist)")
}

void import_delim_parse_stringcols(struct _import_delim_parse_info scalar pr)
{
	string scalar		cols
	real scalar		rc

	cols = st_local("stringcols")

	if (strtrim(cols) == "_all") {
		pr.op_stringcols = strtrim(cols)
		return
	}

	rc = _stata(sprintf(`"qui numlist "%s", integer range(>0) sort"',
		cols), 1)
	if (rc) {
errprintf("{bf:%s}: invalid numlist in {bf:stringcols()} option\n", cols)
		exit(198)
	}
	pr.op_stringcols = st_global("r(numlist)")
}

void import_delim_parse_bindquotes(struct _import_delim_parse_info scalar pr)
{
	string scalar		bquote

	bquote = st_local("bindquotes")

	if (bquote == "l" | bquote == "lo" | bquote == "loo" | bquote == "loos"
		| bquote == "loose") {
		pr.op_bindquotes = "loose"
	}
	else if (bquote == "s" | bquote == "st" | bquote == "str"
		| bquote == "stri" | bquote == "stric" | bquote == "strict") {
		pr.op_bindquotes = "strict"
	}
	else if (bquote == "nob" | bquote == "nobi" | bquote == "nobin" |
		bquote == "nobind") {
		pr.op_bindquotes = "nobind"
	}
	else {
		errprintf("{bf:%s} is an invalid {bf:bindquotes()} argument; ",
			bquote)
		errprintf("use {bf:loose}, {bf:strict}, or {bf:nobind}\n")
		exit(198)
	}
}

void import_delim_parse_stripquotes(struct _import_delim_parse_info scalar pr)
{
	string scalar		squote

	squote = st_local("stripquotes")

	if (squote == "y" | squote == "ye" | squote == "yes") {
		pr.op_stripquotes = "yes"
	}
	else if (squote == "n" | squote == "no") {
		pr.op_stripquotes = "no"
	}
	else if (squote == "def" | squote == "defa" | squote == "defau" |
		squote == "defaul" | squote == "default") {
		pr.op_stripquotes = "nobind"
	}
	else {
		errprintf("{bf:%s} is an invalid {bf:stripquotes()} argument; ",
			squote)
		errprintf("use {bf:yes}, {bf:no}, or {bf:default}\n")
		exit(198)
	}
}

void import_delim_load_file(struct _import_delim_parse_info scalar pr)
{
	real scalar		rc, i
	string scalar		varname, vtype, cmd

	__import_handle_clear_option(pr.op_clear)

	vtype = st_global("c(type)")

	if (pr.op_asdouble) {
		stata("set type double")
	}
	else if (pr.op_asfloat) {
		stata("set type float")
	}

	stata("preserve", 1)
	if (pr.op_clear) {
		stata("clear", 1)
	}

	/* Debugging */
/*
	printf("j_filename=|%s|\n", pr.filename)
	printf("j_vRange1=|%s|\n", pr.start_row)
	printf("j_vRange2=|%s|\n", pr.end_row)
	printf("j_hRange1=|%s|\n", pr.start_col)
	printf("j_hRange2=|%s|\n", pr.end_col)
	printf("j_caseType=|%s|\n", pr.op_case)
	printf("j_delimiter=|%s|\n", pr.op_delimiters)
	printf("j_firstrow=|%s|\n", pr.firstrow)
	printf("j_varnamerow=|%s|\n", pr.op_varnames_row)
	printf("j_bindquotes=|%s|\n", pr.op_bindquotes)
	printf("j_stripquotes=|%s|\n", pr.op_stripquotes)
	printf("j_sequential=|%s|\n", pr.op_delimiters_collapse)
	printf("j_multichardelim=|%s|\n", pr.op_delimiters_asstring)
	printf("j_numvars=|%s|\n", pr.op_numericcols)
	printf("j_strvars=|%s|\n", pr.op_stringcols)
	printf("j_charset=|%s|\n", pr.op_encoding)
	
	printf("j_numlocale=|%s|\n", pr.op_parse_locale)
	printf("j_groupsep=|%s|\n", pr.op_group_sep)
	printf("j_decimalsep=|%s|\n", pr.op_decimal_sep)
	printf("j_max_quoted_rows=|%s|\n", pr.op_max_quoted_rows)
*/

	/* Fill in local macros that will be parsed in
	 * StImportDelimited, main()
	 */

	st_local("j_filename", pr.filename)
	st_local("j_vRange1", pr.start_row)		// #
	st_local("j_vRange2", pr.end_row)		// #
	st_local("j_hRange1", pr.start_col)		// #
	st_local("j_hRange2", pr.end_col)		// #
	st_local("j_caseType", pr.op_case)		// lower|upper|preserve
	st_local("j_delimiter", pr.op_delimiters)	// chars
	st_local("j_firstrow", pr.firstrow)		// yes|no|auto
	st_local("j_varnamerow", pr.op_varnames_row)	// #
	st_local("j_bindquotes", pr.op_bindquotes)	// loose|strict|no
	st_local("j_stripquotes", pr.op_stripquotes)	// auto|yes|no
	st_local("j_sequential", pr.op_delimiters_collapse) // empty or not
	st_local("j_multichardelim", pr.op_delimiters_asstring) // empty or not
	st_local("j_numvars", pr.op_numericcols)	// <numlist>, _all
	st_local("j_strvars", pr.op_stringcols)		// <numlist>, _all
	st_local("j_charset", pr.op_encoding)		// "charset" "encoding"
	
	st_local("j_numlocale",  pr.op_parse_locale)
	st_local("j_groupsep",   pr.op_group_sep)
	st_local("j_decimalsep", pr.op_decimal_sep)
	
	st_local("j_max_quoted_rows", pr.op_max_quoted_rows) 
	// Default is currently 20 which is controlled by CSVParser.java
	
	cmd = pr.s_version +
		" javacall com.stata.plugins.imports.StImportDelimited main, jars(libstata-plugin.jar)"

	// debug
	// printf("cmd=|%s|\n", cmd)

	rc = _stata(sprintf("%s", cmd))
	if (rc) {
		exit(rc)
	}

	if (cols(pr.varlist) > st_nvar()) {
		stata("restore", 1)
		stata(sprintf("set type %s", vtype), 1)
		errprintf("too many variables specified\n")
		exit(103)
	}
	for(i=1; i<=cols(pr.varlist); i++) {
		varname = st_varname(i)
		rc = _stata(sprintf("rename %s %s", varname, pr.varlist[i]), 1)
		if (rc) {
			errprintf("could not name variables specified\n")
			exit(198)
		}
	}

	stata(sprintf("set type %s", vtype))

	if (rc == 0) {
		stata("restore, not", 1)
	}
	__import_output_vars_obs()
}

end

