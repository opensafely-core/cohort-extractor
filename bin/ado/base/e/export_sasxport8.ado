*! version 1.0.4  01aug2019
program define export_sasxport8
	version 16

	capture syntax [varlist] using/ [if] [in] [, *]
	if _rc {
		local orig0 `"`0'"'
		local 0 `"using `0'"'
		capture syntax using/ [if] [in] [, *]
		if _rc {
			if (_rc == 111) {
				dis as err `"variable(s) not defined"'
				exit 111
			}
			local 0 `"`orig0'"'
			syntax [varlist] using/ [if] [in]		///
				[, REPLACE VALLabfile]
		}
		else {
			syntax using/ [if] [in]				///
				[, REPLACE VALLabfile]
		}
	}
	else {
		syntax [varlist] using/ [if] [in]			///
				[, REPLACE VALLabfile]
	}

	if ("`if'" != "" | "`in'" != "") { 
		marksample touse
	}

	mata: export_sasx8_export_file("`touse'")
end

local SASX8E    struct _export_sasx8_info scalar

version 16.0

mata:
mata set matastrict on

struct _export_sasx8_info
{
	string scalar		varlist
	string scalar		touse
	string scalar		filename
	real scalar		op_replace
	real scalar		op_vallabfile
	string scalar		vlab_filename
}

void export_sasx8_export_file(string scalar touse)
{
	`SASX8E'		sasx8e

	export_sasx8_info_init(sasx8e, touse)
	export_sasx8_parse_syntax(sasx8e)
	export_sasx8_save_files(sasx8e)
}

void export_sasx8_info_init(`SASX8E' sasx8e, string scalar touse)
{
	sasx8e.varlist = ""
	if (touse != "") {
		sasx8e.touse = "if " +  touse
	}
	else {
		sasx8e.touse = ""
	}
	sasx8e.filename = ""
	sasx8e.op_replace = .
	sasx8e.op_vallabfile = 0
	sasx8e.vlab_filename = ""
}

void export_sasx8_parse_syntax(`SASX8E' sasx8e)
{
	string scalar		filename
	string scalar		ext

	sasx8e.op_replace = (st_local("replace") != "")
	sasx8e.varlist = st_local("varlist")

	filename = st_local("using")
	sasx8e.filename = __export_check_using_file(filename, ".v8xpt",
		sasx8e.op_replace)
	sasx8e.op_vallabfile = (st_local("vallabfile") != "")
	if (sasx8e.op_vallabfile) {
		ext = pathsuffix(filename)
		if (strlen(ext) > 0 ) {
			filename = subinstr(filename, ext, ".sas")
		}
		sasx8e.vlab_filename = __export_check_using_file(filename,
			".sas", sasx8e.op_replace)
	}

}

void export_sasx8_save_files(`SASX8E' sasx8e)
{
	real scalar		rc
	string scalar		cmd

	__export_handle_replace_option(sasx8e.filename, sasx8e.op_replace)

cmd = sprintf(`"_readstat_export %s using "%s" %s, file("sasxport")"',
		sasx8e.varlist, sasx8e.filename, sasx8e.touse)

//	printf(`"cmd=|%s|\n"', cmd)

	rc = _stata(cmd)
	if (rc) {
		exit(rc)
	}

	printf("{txt}file %s saved\n", sasx8e.filename)

	if (sasx8e.op_vallabfile) {
		__export_handle_replace_option(sasx8e.vlab_filename,
			sasx8e.op_replace)
		export_sasx8_save_sas_file(sasx8e)
	}
}

void export_sasx8_save_sas_file(`SASX8E' sasx8e)
{
	real scalar		rc, fh, v_cols, i, j, z, v_min, v_max, len
	string scalar		value_labels, cmd, quote, fmt, text, line, t, _n
	string scalar		eoc
	string rowvector	value_label_names
	string matrix		map
	transmorphic colvector	C

	rc = _stata("label dir", 1)
	if (rc) {
		exit(rc)
	}
	value_labels = st_global("r(names)")

	if (ustrlen(value_labels)==0) {
printf("note: no value labels define in memory, therefore, no .sas file saved")
		exit(0)
	}

	fh = _fopen(sasx8e.vlab_filename, "w")
	if (fh < 0 ) {
		errprintf("file %s could not be opened\n", sasx8e.vlab_filename)
		exit(-fh)
	}

	st_numscalar("ExpXport8CleanUp", fh)

	C = bufio()
	t = char(09)
	_n = char(10)
	eoc = char(59)+ char(10) 

	value_label_names = tokens(value_labels)
	v_cols = cols(value_label_names)

	line = ""
	line = "libname datapath '" + pwd() + "' " + eoc
	len = strlen(line)
	fmt = "%" + strofreal(len) + "s"
	fbufput(C, fh, fmt, line)
	text = strtrim(pathbasename(sasx8e.filename))
	line = "libname xptfile xport '" + pwd() + text + "'"+ eoc
	len = strlen(line)
	fmt = "%" + strofreal(len) + "s"
	fbufput(C, fh, fmt, line)

	fbufput(C, fh, "%1s", _n)
	fbufput(C, fh, "%1s", _n)
	fbufput(C, fh, "%40s", "proc copy in = xptfile out = datapath ;" + _n)
	fbufput(C, fh, "%1s", _n)
	fbufput(C, fh, "%29s", "proc format library = work ;" + _n)

	for (i=1; i<=v_cols; i++) {
		//write label name
		line = t+ "value " + strupper(value_label_names[i]) + _n
		len = strlen(line)
		fmt = "%" + strofreal(len) + "s"
		fbufput(C, fh, fmt, line)
		cmd  = sprintf("label list %s", value_label_names[i])
		rc = _stata(cmd, 1)
		if (rc) {
			_fclose(fh)
			quote = `"""'
			cmd  = sprintf(`"erase %s%s%s"',
				quote, sasx8e.vlab_filename, quote)
			_stata(cmd, 1)
			exit(rc)
		}
		v_min = st_numscalar("r(min)")
		v_max = st_numscalar("r(max)")
		map = st_vlmap(value_label_names[i], (v_min..v_max))
		z = 1
		for (j=v_min; j<=v_max; j++) {
			text = map[z]
			if (strlen(text) > 0) {
				//write values
				line = t+t+strofreal(j)+" = '"+text+ "'"
				if (j==v_max) {
					line = line + " " + eoc
				}
				else {
					line = line + _n
				}
				len = strlen(line)
				fmt = "%" + strofreal(len) + "s"
				fbufput(C, fh, fmt, line)
			}
			z++
		}
	}

	fbufput(C, fh, "%7s", _n + "quit ;")

	rc = _fclose(fh)
	if (rc < 0 ) {
		errprintf("file %s could not be closed\n", sasx8e.vlab_filename)
		exit(-rc)
	}
	st_numscalar("ExpXport8CleanUp", -1)

	printf("{txt}file %s saved\n", sasx8e.vlab_filename)
}

end
exit

