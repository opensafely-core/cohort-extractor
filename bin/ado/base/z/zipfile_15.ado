*! version 2.0.1  09sep2019
program define zipfile_15
	version 11.0
	syntax anything(everything), SAVING(string asis)

	ParseSaving `saving'
	local overwrite  "`s(replace)'"
	mata : GetZipFileName()

	local files_dirs_size = 0
	gettoken tok rest : anything
	while `"`macval(tok)'"' != "" {
		mata: GetDirsFiles()
		local total_size = scalar(tozip_size) + `files_dirs_size'
		if (`total_size' >= `c(macrolen)') {
			di as error "too many files specified"
			exit 130
		}
		else {
			local files_dirs ///
			`"`macval(files_dirs)' `macval(tozip)'"'
			local files_dirs_size = ///
			scalar(tozip_size) + `files_dirs_size'
		}

		gettoken tok rest : rest
	}
	local zipfile_in_zipfile : list zipfilename in files_dirs
	if(`zipfile_in_zipfile') {
		di as error "`zipfilename' can not be the name of the zipfile and one of the files to zip"
		exit 130
	}
	_zipfile `"`zipfilename'"' `macval(files_dirs)', `overwrite'
end

program define ParseSaving, sclass
	* fn[,replace]

	sret clear
	if `"`0'"' == "" {
		exit
	}
	gettoken fn      0 : 0, parse(", ")
	gettoken comma   0 : 0, parse(", ")
	gettoken replace 0 : 0

	if `"`fn'"'!="" & `"`0'"'=="" {
		if `"`comma'"'=="" | (`"`comma'"'=="," & `"`replace'"'=="") {
			sret local fn `"`fn'"'
			exit
		}
		if `"`comma'"'=="," & `"`replace'"'=="replace" {
			sret local fn `"`fn'"'
			sret local replace "overwrite"
			exit
		}
	}
	di as err "option saving() misspecified"
	exit 198
end

version 11.0
mata:

void GetZipFileName()
{
	string scalar file, suffix

	file = st_global("s(fn)")
	suffix = pathsuffix(file)
	if(suffix == "") {
		file = file + ".zip"
		st_local("zipfilename", file)
	}
	else {
		st_local("zipfilename", file)
	}
}

void GetDirsFiles()
{
	real scalar Rows, i, rc
	string scalar Tok, HoldPWD, ToZip, ToZipFiles, ToZipDirs, ReverseTok
	string scalar FilesOrDirs, Path, Dirs
	string colvector DirsCVec, TmpFilesCVec, TmpDirsCVec

	Tok = st_local("tok")

	Tok = subinstr(Tok, "\", "/")
	ToZip = ""
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
			DirsCVec = GetDirs(Path, "")
			Rows = rows(DirsCVec)
			for(i=1; i<=Rows; i++) {
				Dirs = DirsCVec[i,1]
				TmpFilesCVec = dir(Dirs, "files", FilesOrDirs)
				TmpFilesCVec =  ///
	"`" + `"""' + Dirs + "/" :+ TmpFilesCVec :+ `"""' + "'"
				ToZipFiles = invtokens(TmpFilesCVec')
				TmpDirsCVec = dir(Dirs, "dirs", FilesOrDirs)
				TmpDirsCVec =  ///
	"`" + `"""' + Dirs + "/":+ TmpDirsCVec :+ `"""' + "'"
				ToZipDirs = invtokens(TmpDirsCVec')
				ToZip = strtrim(ToZip + " " + ToZipFiles ///
					+ " " + ToZipDirs)
			}
		}
		else {
			TmpFilesCVec = dir(Path, "files", FilesOrDirs)
			TmpFilesCVec =  ///
	"`" + `"""' + Path :+ TmpFilesCVec :+ `"""' + "'"
			ToZipFiles = invtokens(TmpFilesCVec')

			TmpDirsCVec = dir(Path, "dirs", FilesOrDirs)
			TmpDirsCVec = ///
	"`" + `"""' + Path :+ TmpDirsCVec :+ `"""' + "'"
			ToZipDirs = invtokens(TmpDirsCVec')

			ToZip = ToZipFiles + ToZipDirs
		}
	}
	else {
		TmpFilesCVec = dir(".", "files", Tok)
		TmpFilesCVec = ///
	"`" + `"""' :+ TmpFilesCVec :+ `"""' + "'"
		ToZipFiles = invtokens(TmpFilesCVec')

		TmpDirsCVec = dir(".", "dirs", Tok)
		TmpDirsCVec = ///
	"`" + `"""' :+ TmpDirsCVec :+ `"""' + "'"
		ToZipDirs = invtokens(TmpDirsCVec')

		ToZip = ToZipFiles + ToZipDirs
	}
	if (strlen(ToZip) > st_numscalar("c(macrolen)")) {
		errprintf("too many files specified\n")
		exit(130)
	}
	st_local("tozip", strtrim(ToZip))
	st_numscalar("tozip_size", strlen(ToZip))
}

string colvector GetDirs(string scalar BasePath, string scalar RestOfPath)
{
	real scalar Rows, i
	real rowvector all_question_marks
	string scalar Dir, NewRestOfPath, BaseDirs, TmpBaseDir
	string colvector PathsCVec, TmpPathsCVec1, TmpPathsCVec2

	PathsCVec = ("", "")
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
		if((sum(all_question_marks:==63))==cols(all_question_marks)) {
				TmpPathsCVec1 = dir(".", "dirs", Dir)
				if (NewRestOfPath == "") {
					return(TmpPathsCVec1)
				}
				Rows = rows(TmpPathsCVec1)
				for(i=1; i<=Rows; i++) {
					TmpBaseDir = TmpPathsCVec1[i,1]
					TmpPathsCVec2 = ///
					GetDirs(TmpBaseDir, NewRestOfPath)
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
				GetDirs(TmpBaseDir, NewRestOfPath)
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
					GetDirs(TmpBaseDir, NewRestOfPath)
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
				GetDirs(TmpBaseDir, NewRestOfPath)
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
					GetDirs(TmpBaseDir, NewRestOfPath)
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
		PathsCVec = GetDirs(BaseDirs, NewRestOfPath)
	}
	return(PathsCVec)
}

end
exit
