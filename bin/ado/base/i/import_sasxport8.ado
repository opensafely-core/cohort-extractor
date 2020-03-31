*! version 1.0.4  01sep2019
program define import_sasxport8, rclass
	version 16

	gettoken filename rest : 0, parse(" ,")
	gettoken comma : rest, parse(" ,")

	if (`"`filename'"' != "" & (trim(`"`comma'"') == "," |		///
		trim(`"`comma'"') == "")) {
		local 0 `"using `0'"'
	}

	syntax using/ [, clear case(string) vlabfile(string)]

	return clear

	mata: import_sasx8_import_file()

	return add

	qui compress
end

local SASX8I	struct _import_sasx8_info scalar

version 16.0

mata:
mata set matastrict on

struct _import_sasx8_info
{
	string scalar		filename
	real scalar		op_clear
	string scalar		op_case
	string scalar		op_vlabfile
	string scalar		vlab_filename
}

void import_sasx8_import_file()
{
	`SASX8I'		sasx8i

	import_sasx8_info_init(sasx8i)
	import_sasx8_parse_syntax(sasx8i)
	import_sasx8_load_file(sasx8i)
}

void import_sasx8_info_init(`SASX8I' sasx8i)
{
	sasx8i.filename = ""
	sasx8i.op_clear = .
	sasx8i.op_case = "preserve"
	sasx8i.op_vlabfile = ""
	sasx8i.vlab_filename = ""
}

void import_sasx8_parse_syntax(`SASX8I' sasx8i)
{
	string scalar filename

	sasx8i.op_vlabfile = st_local("vlabfile")
	if (sasx8i.op_vlabfile != "") {
		sasx8i.vlab_filename = 
			__import_check_using_file(sasx8i.op_vlabfile,
			".v8xpt")
	}

	filename = st_local("using")
	sasx8i.filename = __import_check_using_file(filename, ".v8xpt")
	sasx8i.op_case = __import_parse_case_opt()
	sasx8i.op_clear = (st_local("clear") != "")
}

void import_sasx8_load_file(`SASX8I' sasx8i)
{
	real scalar		rc
	string scalar		cmd 
	string scalar		quote

	quote = `"""'

	__import_handle_clear_option(sasx8i.op_clear)

	if (sasx8i.vlab_filename != "") {
		cmd=sprintf("_readstat_import using %s%s%s,file(%ssasxport%s)",
			quote, sasx8i.vlab_filename, quote, quote, quote)
//		printf("cmd=|%s|\n", cmd)
		rc = _stata(cmd)
		if (rc) {
			exit(rc)
		}
//		import_sasx8_store_value_labels(sasx8i)
	}

	cmd = sprintf("_readstat_import using %s%s%s, file(%ssasxport%s)",
		quote, sasx8i.filename, quote, quote, quote)

//	printf("cmd=|%s|\n", cmd)		
	rc = _stata(cmd)
	if (rc) {
		exit(rc)
	}
/*
	if (sasx8i.vlab_filename != "") {
		import_sasx8_apply_value_labels(sasx8i)
	}
*/
	if (sasx8i.op_case == "lower") {
		rc = _stata("rename _all, lower")
		if (rc) {
			stata("clear", 1)
			exit(rc)
		}
	}
	else if (sasx8i.op_case == "upper") {
		rc = _stata("rename _all, upper")
		if (rc) {
			stata("clear", 1)
			exit(rc)
		}
	}

	__import_output_vars_obs()
}
/*
void import_sasx8_store_value_labels(`SASX8I' sasx8i)
{
	// NOT KNOW YET
}

void import_sasx8_apply_value_labels(`SASX8I' sasx8i)
{
	// NOT KNOW YET
}
*/

end
exit
