*! version 1.1.4  23oct2017
program define unzipfile
	version 11.0
	syntax anything(everything id=zipfile) [, replace]

	gettoken ZipFileName rest : anything

	if (`"`rest'"' != "") {
		di as error "invalid syntax"
		exit 198
	}

	if (c(userversion) < 15.1) {
		if (`"`replace'"' != "") {
			local overwrite "overwrite"
		}
		mata : zipfile_cmd()
	}
	else {
		mata : unzipfile_cmd()
	}
end

version 15.0
mata:
mata set matastrict on

void zipfile_cmd()
{
	string scalar		file, suffix, cmd, overwrite 
	real scalar		rc
	
	file = st_local("ZipFileName")
	overwrite = st_local("overwrite")

	suffix = pathsuffix(file)
	if(suffix == "") {
		file = file + ".zip"
	}

	if (overwrite != "") {
		cmd = sprintf(`"_unzipfile "%s",  overwrite"', file)
	}
	else {
		cmd = sprintf(`"_unzipfile "%s""', file)
	}

	rc = _stata(cmd)
	if (rc) {
		exit(601)
	}
}

void unzipfile_cmd()
{
	string scalar		filename, suffix, cmd, op_replace, tmp_file
	real scalar		rc
	
	filename = st_local("ZipFileName")
	op_replace = st_local("replace")

	suffix = pathsuffix(filename)
	if(suffix == "") {
		filename = filename + ".zip"
	}

	if (pathisurl(filename)) {
		tmp_file = st_tempfilename()
		rc =  _stata(sprintf(`"copy `"%s"' `"%s"'"', filename,
			tmp_file))
		if (rc) {
			errprintf("could not open url\n")
			exit(603)
		}
		filename = tmp_file
	}

	st_local("j_replace", op_replace)
	st_rclear()
cmd = sprintf(`"javacall com.stata.plugins.zip.StUnzipfile unzipfile, jars(libstata-plugin.jar) args("%s")"', filename)
	rc = _stata(cmd)
	exit(rc)
}

end
exit


