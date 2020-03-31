*! version 1.0.1  09sep2019

/* 
 * The purpose of this wrapper is to parse the arguments and options,
 * but primarily this code is used to handle filesystem-wildcard expansion
 * and to pass those files and/or directories to the zip utility.
 */

program define zipfile
	if (c(userversion) < 15.1) {
		zipfile_15 `macval(0)'
		exit
	}
	version 15.1
	syntax anything(everything id="files or directories"),		///
		SAVING(string asis)					///
		[COMPLevel(numlist integer >=0 <10 max=1 min=1)]

	tempname matname
	mata:zipfile_cr("`matname'")
	capture noisily mata:__zipfile("`matname'")
	mata:zipfile_rm("`matname'")
	exit _rc
end

local ZI struct zipfile_info scalar
local VEC_SIZE 1000

version 15.1
mata:
mata set matastrict on

struct zipfile_info {
	string scalar		filename
	real scalar		op_replace
	string scalar		op_complevel
	real scalar		files_to_zip_index
	string scalar		matrix_name
	pointer colvector	p_filelist
}

void zipfile_cr(string scalar name)
{
	(void) crexternal(name)
}

void zipfile_rm(string scalar name)
{
	rmexternal(name)
}

void __zipfile(string scalar matrix_name)
{
	`ZI' zi

	zipfile_init(zi,matrix_name)
	zipfile_parse_syntax(zi)
	zipfile_compress_files(zi)
}

void zipfile_init(`ZI' zi, string scalar matrix_name)
{
	zi.filename = ""
	zi.op_replace = 0
	zi.op_complevel = "5"
	zi.files_to_zip_index = 1
	zi.matrix_name = matrix_name
	
	zi.p_filelist = findexternal(matrix_name)
	if (zi.p_filelist==NULL) {
		errprintf("could not create file\n")
		exit(601)
	}
	*zi.p_filelist = J(`VEC_SIZE', 1, "")
}

void zipfile_parse_syntax(`ZI' zi)
{
	zi.op_complevel = st_local("complevel")
	zipfile_parse_saving(zi)
	zipfile_check_file(zi)
}

void zipfile_parse_saving(`ZI' zi)
{
	transmorphic		t
	string scalar		tmpstr, tok, rev

	tmpstr = st_local("saving")
	t = tokeninit("", `","', (`""""', `"`""'"'), 0, 0)
	tokenset(t, tmpstr)
	
	zi.filename = strtrim(tokenget(t))

	if (bsubstr(zi.filename, 1, 1) == char(96)) {
		zi.filename = subinstr(zi.filename, char(96), "", 1)
	}

	rev = strreverse(zi.filename)
	if (bsubstr(rev, 1, 1) == `"'"') {
		zi.filename = strreverse(subinstr(rev, `"'"', "", 1))
	}

	if (bsubstr(zi.filename, 1, 1) == `"""') {
		zi.filename = subinstr(zi.filename, `"""', "", 1)
	}

	rev = strreverse(zi.filename)
	if (bsubstr(rev, 1, 1) == `"""') {
		zi.filename = strreverse(subinstr(rev, `"""', "", 1))
	}

	tok = strtrim(tokenget(t))

	if (tok == ",") {
		tmpstr =  strtrim(tokenget(t))
		if (tmpstr != "replace") {
			errprintf("option {b:saving()} misspecified\n",
				zi.op_replace)
			exit(198)
		}
		zi.op_replace = 1
	}
}

void zipfile_check_file(`ZI' zi)
{
	string scalar		filename, path, fn, tmp, tmp_fn
	string scalar		basename

	path = ""
	fn = ""

	filename = zi.filename

	basename = pathbasename(filename)
	if (basename=="") {
		errprintf("invalid filename\n")
		exit(198)
	}

	pathsplit(filename, path, fn) 
	if (pathsuffix(fn) == "") {
		tmp = fn + ".zip"
		if (path != "") {
			path = path + "/"
		}
		tmp_fn = path + tmp
		if (fileexists(tmp_fn) & zi.op_replace == 0) {
			errprintf("file already exists\n")
			errprintf("    You must specify option {bf:replace} to overwrite the existing file.\n")
			exit(130)
		}
	}
	else {
		tmp_fn = filename
	}

	if (fileexists(tmp_fn) & zi.op_replace == 0) {
		errprintf("file already exists\n")
		errprintf("    You must specify option {bf:replace} to")
		errprintf(" overwrite the existing file.\n")
		exit(130)
	}

	filename = subinstr(tmp_fn, "\", "/")
	filename = prochome(filename, 0)

	zi.filename = filename
}

void zipfile_compress_files(`ZI' zi)
{
	real scalar		rc
	string scalar		to_zip, tok, cmd, rev
	transmorphic		t

	to_zip = st_local("anything")
	t = tokeninit(" ")
	tokenset(t, to_zip)

	for (tok=tokenget(t); tok != "";tok = tokenget(t)) {

		// left tick
		if (bsubstr(tok, 1, 1) == char(96)) {
			tok = subinstr(tok, char(96), "", 1)
		}

		rev = strreverse(tok)
		// right tick
		if (bsubstr(rev, 1, 1) == `"'"') {
			tok = strreverse(subinstr(rev, `"'"', "", 1))
		}

		// left quote
		if (bsubstr(tok, 1, 1) == `"""') {
			tok = subinstr(tok, `"""', "", 1)
		}

		// right quote
		rev = strreverse(tok)
		if (bsubstr(rev, 1, 1) == `"""') {
			tok = strreverse(subinstr(rev, `"""', "", 1))
		}
	
		if (tok==zi.filename) {
			errprintf("invalid filename\n")
			errprintf("    %s may not be the name of a file to compress and save.\n", zi.filename)
			exit(198)
		}
		zipfile_get_dir_files(zi, tok)
	}
	if (zi.files_to_zip_index == 1) {
		errprintf("invalid file specification\n")
		errprintf("    You must specify at least one valid file or folder to include\n")
		errprintf("    in the zip file.\n")
		exit(198)
	}

	*zi.p_filelist = (*zi.p_filelist)[1::zi.files_to_zip_index-1, 1]

	st_local("j_saving", zi.filename)
	st_local("j_replace", strofreal(zi.op_replace))
	st_local("j_compression_level", zi.op_complevel)

	st_rclear()
	cmd = sprintf(`"javacall com.stata.plugins.zip.StZipfile zipfile, jars(libstata-plugin.jar) args("%s")"', zi.matrix_name)
	rc = _stata(sprintf("%s", cmd))
	if (rc) {
		exit(rc)
	}
}

void zipfile_get_dir_files(`ZI' zi, string scalar Tok)
{
	real scalar		Rows, i, rc
	string scalar 		HoldPWD, ReverseTok, FilesOrDirs, Path, Dirs
	string colvector	DirsCVec, TmpFilesCVec, TmpDirsCVec

	Tok = subinstr(Tok, "\", "/")

	if (strpos(Tok, "/")) {
		/* We do not want to expand a path unless you are dealing with
		   ~.  The library can not handle a path starting with ~ on
                   Unix/Mac.
		*/
		if (bsubstr(Tok, 1, 1)=="~") {
			if (st_global("c(os)")!="Windows") {
				HoldPWD = pwd()
				ReverseTok = strreverse(Tok)
				FilesOrDirs = strreverse(bsubstr(ReverseTok, 1,
					strpos(ReverseTok, "/")-1))
				Path = strreverse(bsubstr(ReverseTok,
					strpos(ReverseTok, "/"), .))
				rc = _chdir(Path)
				if (rc == 0) {
					Path = pwd()
				}
				else {
					errprintf("invalid path :%s", Path)
					exit(170)
				}
				chdir(HoldPWD)
			}
			else {
				ReverseTok = strreverse(Tok)
				FilesOrDirs = strreverse(bsubstr(ReverseTok, 1,
					strpos(ReverseTok, "/")-1))
				Path = strreverse(bsubstr(ReverseTok,
					strpos(ReverseTok, "/"), .))
			}
		}
		else {
			ReverseTok = strreverse(Tok)
			FilesOrDirs = strreverse(bsubstr(ReverseTok, 1,
				strpos(ReverseTok, "/")-1))
			Path = strreverse(bsubstr(ReverseTok,
				strpos(ReverseTok, "/"), .))
		}
		if(strpos(Path, "*")>0 | strpos(Path, "?")>0 ) {
			DirsCVec = zipfile_get_dirs(Path, "")
			Rows = rows(DirsCVec)
			for(i=1; i<=Rows; i++) {
				Dirs = DirsCVec[i,1]
				TmpFilesCVec = dir(Dirs, "files", FilesOrDirs)
				TmpFilesCVec =  Dirs + "/" :+ TmpFilesCVec 

				zipfile_add_files(zi, TmpFilesCVec)

				TmpDirsCVec = dir(Dirs, "dirs", FilesOrDirs)
				TmpDirsCVec = Dirs + "/":+ TmpDirsCVec 

				zipfile_add_files(zi, TmpDirsCVec)
			}
		}
		else {
			TmpFilesCVec = dir(Path, "files", FilesOrDirs)
			TmpFilesCVec =  Path :+ TmpFilesCVec 
			zipfile_add_files(zi, TmpFilesCVec)

			TmpDirsCVec = dir(Path, "dirs", FilesOrDirs)
			TmpDirsCVec = Path :+ TmpDirsCVec
			zipfile_add_files(zi, TmpDirsCVec)
		}
	}
	else {
		TmpFilesCVec = dir(".", "files", Tok)
		zipfile_add_files(zi, TmpFilesCVec)
		TmpDirsCVec = dir(".", "dirs", Tok)
		zipfile_add_files(zi, TmpDirsCVec)
	}
}

string colvector zipfile_get_dirs(string scalar BasePath,
	string scalar RestOfPath)
{
	real scalar 		Rows, i
	real rowvector		all_question_marks
	string scalar		Dir, NewRestOfPath, BaseDirs, TmpBaseDir
	string colvector	PathsCVec, TmpPathsCVec1, TmpPathsCVec2

	PathsCVec = ("","")
	if (RestOfPath == "") {
		BasePath = strtrim(BasePath)
		/* Check for UNIX root path */
		if (bsubstr(BasePath, 1, 1) == "/") {
			TmpBaseDir = bsubstr(BasePath, 2, .)
			Dir = "/" + ///
			bsubstr(TmpBaseDir, 1, strpos(TmpBaseDir, "/")-1)
			NewRestOfPath = ///
			bsubstr(TmpBaseDir, strpos(TmpBaseDir, "/")+1, .)
		}
		else {
			Dir = bsubstr(BasePath, 1, strpos(BasePath, "/")-1)
			NewRestOfPath = ///
			bsubstr(BasePath, strpos(BasePath, "/")+1, .)
		}
		/* Check to see if first Dir is a wild card */
		if(strpos(Dir, "?") > 0) {
			all_question_marks = ascii(Dir)
			if((sum(all_question_marks:==63))==
				cols(all_question_marks)) {
				TmpPathsCVec1 = dir(".", "dirs", Dir)
				if (NewRestOfPath == "") {
					return(TmpPathsCVec1)
				}
				Rows = rows(TmpPathsCVec1)
				for(i=1; i<=Rows; i++) {
					TmpBaseDir = TmpPathsCVec1[i,1]
					TmpPathsCVec2 = ///
					zipfile_get_dirs(TmpBaseDir,
						NewRestOfPath)
					PathsCVec = PathsCVec \ TmpPathsCVec2
				}
			}
		}
		if (Dir == "*") {
			TmpPathsCVec1 = dir(".", "dirs", "*")
			if (NewRestOfPath == "") {
				return(TmpPathsCVec1)
			}
			Rows = rows(TmpPathsCVec1)
			for(i=1; i<=Rows; i++) {
				TmpBaseDir = TmpPathsCVec1[i,1]
				TmpPathsCVec2 = ///
				  zipfile_get_dirs(TmpBaseDir, NewRestOfPath)
				PathsCVec = PathsCVec \ TmpPathsCVec2
			}
		}
	}
	else {
		Dir = bsubstr(RestOfPath, 1, strpos(RestOfPath, "/")-1)
		NewRestOfPath = bsubstr(RestOfPath, strpos(RestOfPath, "/")+1,.)
		if (strpos(Dir, "?") > 0) {
		all_question_marks = ascii(Dir)
		if((sum(all_question_marks:==63))==cols(all_question_marks)) {
				TmpPathsCVec1 = dir(BasePath, "dirs", Dir)
				TmpPathsCVec1 = ///
					BasePath + "/" :+ TmpPathsCVec1
				if (NewRestOfPath == "") {
					return(TmpPathsCVec1)
				}
				Rows = rows(TmpPathsCVec1)
				for(i=1; i<=Rows; i++) {
					TmpBaseDir = TmpPathsCVec1[i,1]
					TmpPathsCVec2 = ///
					zipfile_get_dirs(TmpBaseDir,
						NewRestOfPath)
					PathsCVec = PathsCVec \ TmpPathsCVec2
				}
			}
		}
		if (Dir == "*") {
			TmpPathsCVec1 = dir(BasePath, "dirs", "*")
			TmpPathsCVec1 = ///
				BasePath + "/" :+ TmpPathsCVec1
			if (NewRestOfPath == "") {
				return(TmpPathsCVec1)
			}
			Rows = rows(TmpPathsCVec1)
			for(i=1; i<=Rows; i++) {
				TmpBaseDir = TmpPathsCVec1[i,1]
				TmpPathsCVec2 = ///
				zipfile_get_dirs(TmpBaseDir, NewRestOfPath)
				PathsCVec = PathsCVec \ TmpPathsCVec2
			}
		}
	}
	if(strpos(Dir, "*") > 0 | strpos(Dir, "?") > 0) {
		TmpPathsCVec1 = dir(BasePath, "dirs", Dir)
		BaseDirs = BasePath + "/"
		TmpPathsCVec1 = BaseDirs:+TmpPathsCVec1
		if (NewRestOfPath == "") {
			return(TmpPathsCVec1)
		}
		else {
			Rows = rows(TmpPathsCVec1)
			for(i=1; i<=Rows; i++) {
				TmpBaseDir = TmpPathsCVec1[i,1]
				TmpPathsCVec2 = ///
					zipfile_get_dirs(TmpBaseDir,
					NewRestOfPath)
				PathsCVec = PathsCVec \ TmpPathsCVec2
			}
		}
	}
	else if (Dir != "") {
		if (RestOfPath == "") {
			BaseDirs = Dir
		}
		else {
			BaseDirs = BasePath + "/" + Dir
		}
		if (NewRestOfPath == "") {
			PathsCVec = dir(BasePath, "dirs", Dir)
			BaseDirs = BasePath + "/"
			PathsCVec = BaseDirs:+PathsCVec
			return(PathsCVec)
		}
		PathsCVec = zipfile_get_dirs(BaseDirs, NewRestOfPath)
	}
	return(PathsCVec)
}

void zipfile_add_files(`ZI' zi, string colvector files_to_add)
{
	real scalar		added_rows, i, j, files_to_zip_rows
	string colvector	tmp

	added_rows = rows(files_to_add)
	if (!added_rows | missing(added_rows)) {
		return
	}
	
	files_to_zip_rows = rows(*zi.p_filelist)

	tmp = ("", "")
	if (added_rows + zi.files_to_zip_index >= files_to_zip_rows)  {
		swap(tmp, *zi.p_filelist)
		*zi.p_filelist = J(rows(tmp)+added_rows,1,"")
		(*zi.p_filelist)[1..rows(tmp)] = tmp
		files_to_zip_rows = rows(*zi.p_filelist)
	}

	j = 1
	added_rows = zi.files_to_zip_index + added_rows - 1
	for(i=zi.files_to_zip_index; i<=added_rows; i++) {
		(*zi.p_filelist)[i] = files_to_add[j]
		j++
	}
	zi.files_to_zip_index = i
}

end
exit
