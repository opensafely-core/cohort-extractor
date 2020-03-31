*! version 1.0.4  01sep2019
program define import_spss, rclass
	version 16

	gettoken filename rest : 0, parse(" ,")
	gettoken comma : rest, parse(" ,")

	if (`"`filename'"' != "" & (trim(`"`comma'"') == "," |		///
		trim(`"`comma'"') == "")) {
		local 0 `"using `0'"'
	}

	syntax anything(everything id=using)				///
		[, clear case(string) zsav ENCoding(string)]

	return clear

	mata: import_spss_import_file()

	return add

	qui compress
end

local SPSSI	struct _import_spss_info scalar

version 16.0

mata:
mata set matastrict on

struct _import_spss_info
{
	string scalar		filename
	real scalar		op_clear
	real scalar		op_zsav
	string scalar		op_case
	string scalar		op_varlist_if_in
	string scalar		op_encoding
}

void import_spss_import_file()
{
	`SPSSI'			spssi

	import_spss_info_init(spssi)
	import_spss_parse_syntax(spssi)
	import_spss_load_file(spssi)
}

void import_spss_info_init(`SPSSI' spssi)
{
	spssi.filename = ""
	spssi.op_clear = .
	spssi.op_zsav = .
	spssi.op_case = "preserve"
	spssi.op_varlist_if_in = ""
	spssi.op_encoding = ""
}

void import_spss_parse_syntax(`SPSSI' spssi)
{
	string scalar filename

	filename = __import_parse_using_from_any()
	spssi.op_varlist_if_in = st_local("varlist_if_in")
	spssi.op_zsav = (st_local("zsav") != "")
	if (spssi.op_zsav) {
		spssi.filename = __import_check_using_file(filename, ".zsav")
	}
	else {
		spssi.filename = __import_check_using_file(filename, ".sav")
	}
	spssi.op_case = __import_parse_case_opt()
	spssi.op_clear = (st_local("clear") != "")
	spssi.op_encoding = st_local("encoding")
}

void import_spss_load_file(`SPSSI' spssi)
{
	real scalar		rc
	string scalar		cmd, opts, tmp
	string scalar		quote

	quote = `"""'

	__import_handle_clear_option(spssi.op_clear)

	opts = ""
	if (strlen(spssi.op_encoding) > 0) {
		tmp = sprintf("encoding(%s%s%s)",
			quote, spssi.op_encoding, quote)
		opts = opts + tmp
	}

	cmd = sprintf("_readstat_import %s using %s%s%s, file(%sspsssav%s) %s",
		spssi.op_varlist_if_in, quote, spssi.filename, quote,
		quote, quote, opts)

//	printf("cmd=|%s|\n", cmd)			//Debug
	rc = _stata(cmd)
	if (rc) {
		exit(rc)
	}

	if (spssi.op_case == "lower") {
		rc = _stata("rename _all, lower")
		if (rc) {
			stata("clear", 1)
			exit(rc)
		}
	}
	else if (spssi.op_case == "upper") {
		rc = _stata("rename _all, upper")
		if (rc) {
			stata("clear", 1)
			exit(rc)
		}
	}

	__import_output_vars_obs()
}

end
exit
