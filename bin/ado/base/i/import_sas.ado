*! version 1.0.5  01sep2019
program define import_sas, rclass
	version 16

	gettoken filename rest : 0, parse(" ,")
	gettoken comma : rest, parse(" ,")

	if (`"`filename'"' != "" & (trim(`"`comma'"') == "," |		///
		trim(`"`comma'"') == "")) {
		local 0 `"using `0'"'
	}

	syntax anything(everything id=using)				///
		[, clear case(string) bcat(string) ENCoding(string)]

	return clear

	mata: import_sas_import_file()

	return add

	qui compress
end

local SASI	struct _import_sas_info scalar

version 16.0

mata:
mata set matastrict on

struct _import_sas_info
{
	string scalar		filename
	real scalar		op_clear
	string scalar		op_case
	string scalar		op_varlist_if_in
	string scalar		op_bcat
	string scalar		bcat_filename
	string scalar		op_encoding
}

void import_sas_import_file()
{
	`SASI'			sasi

	import_sas_info_init(sasi)
	import_sas_parse_syntax(sasi)
	import_sas_load_file(sasi)
}

void import_sas_info_init(`SASI' sasi)
{
	sasi.filename = ""
	sasi.op_clear = .
	sasi.op_case = "preserve"
	sasi.op_varlist_if_in = ""
	sasi.op_bcat = ""
	sasi.bcat_filename = ""
	sasi.op_encoding = ""
}

void import_sas_parse_syntax(`SASI' sasi)
{
	string scalar filename

	filename = __import_parse_using_from_any()
	sasi.op_varlist_if_in = st_local("varlist_if_in")
	sasi.op_bcat = st_local("bcat")
	if (sasi.op_bcat != "") {
		sasi.bcat_filename = __import_check_using_file(sasi.op_bcat,
			".sas7bcat")
	}
	sasi.filename = __import_check_using_file(filename, ".sas7bdat")
	sasi.op_case = __import_parse_case_opt()
	sasi.op_clear = (st_local("clear") != "")
	sasi.op_encoding = st_local("encoding")
}

void import_sas_load_file(`SASI' sasi)
{
	real scalar		rc
	string scalar		cmd, opts, tmp
	string scalar		quote

	quote = `"""'

	__import_handle_clear_option(sasi.op_clear)

	opts = ""
	if (strlen(sasi.op_encoding) > 0) {
		tmp = sprintf("encoding(%s%s%s)",
			quote, sasi.op_encoding, quote)
		opts = opts + tmp
	}

	cmd = sprintf("_readstat_import %s using %s%s%s, file(%ssas7bdat%s) %s",
		sasi.op_varlist_if_in, quote, sasi.filename, quote,
		quote, quote, opts)

//	printf("cmd=|%s|\n", cmd)		
	rc = _stata(cmd)
	if (rc) {
		exit(rc)
	}

	if (sasi.op_bcat != "") {
	cmd=sprintf("_readstat_import using %s%s%s,file(%ssas7bcat%s) %s",
			quote, sasi.bcat_filename, quote,
			quote, quote, opts)
//		printf("cmd=|%s|\n", cmd)
		rc = _stata(cmd)
		if (rc) {
			exit(rc)
		}

	}

	if (sasi.op_case == "lower") {
		rc = _stata("rename _all, lower")
		if (rc) {
			stata("clear", 1)
			exit(rc)
		}
	}
	else if (sasi.op_case == "upper") {
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
