*! version 1.2.2  16sep2019
program hsearch
	version 9

	syntax [anything(equalok everything)] [, BUILD]

	local didsomething 0
	if ("`build'"!="") {
		mata: hsearch_build()
		local didsomething 1
	}

	if (`"`anything'"' != "") {
		local didsomething 1
		tempfile fn
		mata: hsearch_search(`"`anything'"', `"`fn'"')
		if ("$S_CONSOLE"=="") view `"`fn'"', smcl
		else 		      type `"`fn'"', smcl
	}
	if (`didsomething'==0) {
		di as err ///
"type {cmd:hsearch} followed by keyword(s), such as {cmd:hsearch Mills' ratio}"
		exit 198
	}
end

/* -------------------------------------------------------------------- */
local PARSECHARS	`"" ()[]:;,+-/{}\'.<=>?^|~#" + char(96)"'
local IDXFILENAME	`""sthlpindex.idx""'
local SIGNATURE		`""sthlpindex.idx 1.02""'

version 9

mata: 

void hsearch_build()
{
	real scalar		fh, i, target, incr, inccnt
	string scalar		tmpfile
	string colvector	filenames
	string colvector	uniq, line5
	real colvector		cnt


	fh = hsearch_fopenidx("w")

	filenames = uniqrows(dirsearch("*.sthlp") \ dirsearch("*.hlp"))
	tmpfile = st_tempfilename()

	printf("{txt}(building index ") 
	displayflush()

	incr = target = round(rows(filenames)/50, 1)
	inccnt = 0

	for (i=1; i<=rows(filenames); i++) {
		filenames[i] = FindHelpFile(filenames[i])
		if (i >= target) {
			if (mod(2*(++inccnt), 10)==0) {
				printf("%g%%", 2*inccnt)
			}
			else	printf(".")
			displayflush() 
			target = target + incr
		}
		pragma unset uniq
		pragma unset cnt
		pragma unset line5
		hsearch_build_1(findfile(filenames[i]), tmpfile, 
							uniq, cnt, line5)
		fputmatrix(fh, filenames[i])
		fputmatrix(fh, line5)
		fputmatrix(fh, uniq)
		fputmatrix(fh, cnt)
	}
	fclose(fh)
	printf(")\n")
}


void hsearch_search(string scalar txt, string scalar logfilename)
{
	real scalar		i, j, nh, builton, days
	real scalar		fh, score
	transmorphic		filename
	string colvector	uniq, resfn, line5
	string matrix		rescm
	real colvector		cnt, ressc, idx
	string rowvector	ctxt

	ctxt = hsearch_search_cleantxt(txt)

	resfn = J(0, 1, "")
	ressc = J(0, 1, .)
	rescm = J(0, 5, "")

	pragma unset builton
	fh = hsearch_fopenidx("r", builton)

	nh = 0 
	while ( (filename=_fgetmatrix(fh))!=J(0,0,.) ) {
		nh++
		line5= fgetmatrix(fh)
		uniq = fgetmatrix(fh)
		cnt  = fgetmatrix(fh)
		if (score = hsearch_search_score(ctxt, uniq, cnt)) {
			if (strpos(filename, "whatsnew")) score = 0
			resfn = resfn \ filename
			ressc = ressc \ score
			rescm = rescm \ line5'
		}
	}
	fclose(fh)
	idx = order(ressc, -1)
	_collate(ressc, idx)
	_collate(resfn, idx)
	_collate(rescm, idx)


	/* --------------------------------------------------------------- */

	fh = fopen(logfilename, "w")

	fput(fh, "{smcl}")
	fput(fh, "")

	fput(fh, "        {c TLC}{hline 60}{c TRC}")
	fwrite(fh, "hsearch {c |}")
	st_global("HSEARCH_QUERY", txt)
	fwrite(fh, sprintf(`"{bf:{dialog hsearch:%s}}"', txt))
	fput(fh, "{col 70}{c |}")

	fput(fh, "        {c BLC}{hline 60}{c BRC}")

	fput(fh, sprintf(
		"{col 9}{rm}(%g help files searched; %g matches found)",
		nh, rows(ressc)))

	days = hsearch_todaysdate()-builton
	fput(fh, "")
	fput(fh, "{p 8 9 2}")
	fwrite(fh, "(results based on help index built ")
	if (days==0) fput(fh, "today;")
	else if (days==1) fput(fh, "yesterday;")
	else	fput(fh, sprintf("%g days ago;", days))
	fput(fh, `"type -{bf:{stata "hsearch, build"}}- to rebuild index.)"')
	fput(fh, "{p_end}")

	fput(fh, "{rm}{hline}")
	fput(fh, "")

	
	for (i=1; i<=rows(ressc); i++) {

		if (i<10) fput(fh, sprintf("{p 6 10 2}"))
		else if (i<100)  fput(fh, sprintf("{p 5 10 2}"))
		else if (i<1000) fput(fh, sprintf("{p 4 10 2}"))
		else 		 fput(fh, sprintf("{p 3 10 2}"))
		fwrite(fh, sprintf("{txt}"))
		fput(fh, sprintf("%g.", i))
		fput(fh, sprintf("{ul:{bf:{help %s}}}{break}", 
				pathrmsuffix(resfn[i])
				))
		fput(fh, sprintf("(score %g){break}", ressc[i]) )
		for (j=1; j<cols(rescm); j++) {
			fput(fh, sprintf("%s /", rescm[i,j]))
		}
		fput(fh, sprintf("%s", rescm[i,j]))
		fput(fh, "")
	}
	fclose(fh)
}

/* ----------------------------------------------------------------------- */

real scalar hsearch_fopenidx(string scalar mode, |builton)
{
	real scalar	fh, done
	string scalar	basedir, idxfullname, signature
	
	basedir     = pathsubsysdir("PERSONAL")
	idxfullname = pathjoin(basedir, `IDXFILENAME')
	signature   = `SIGNATURE'

	/* ------------------------------------------------------------ */
	if (mode=="w") {
		if (fileexists(idxfullname)) unlink(idxfullname)
		recursive_mkdir(basedir)
		fh = fopen(idxfullname, "w")
		fput(fh, signature)
		fputmatrix(fh, hsearch_todaysdate())
		return(fh)
	}
	/* ------------------------------------------------------------ */

	for (done=0; 1; done=1) {
		if ( (fh = _fopen(idxfullname, "r")) >= 0) {
			if (fget(fh) == signature) { 
				builton = fgetmatrix(fh)
				if (builton >= hsearch_updatedate()) return(fh)
			}
			fclose(fh)
		}
		if (done) _error("hsearch failure")
		hsearch_build()
	}
	/*NOTREACHED*/
}

real scalar hsearch_todaysdate() return(hsearch_dmy(c("current_date")))

real scalar hsearch_updatedate()
{
	real scalar	fh, res
	string scalar	s

	if ((fh = _fopen(findfile("update"), "r"))<0) return(0) 
	s = fget(fh)
	fclose(fh)

	res = hsearch_dmy(s)
	return(res<. ? res : 0)
}

real scalar hsearch_dmy(string scalar dmystr)
{
	real scalar	result
	string scalar 	name

	name = st_tempname()
	stata("scalar " + name + `"=date(""' + dmystr + `"", "dmy")"')
	result = st_numscalar(name)
	stata("scalar drop " + name)
	return(result)
}


/*                                                     ____  ___  _____
	(void) hsearch_build_1(fullfilename, tempname, uniq, cnt, line5)
			       ------------  --------
*/
	
void hsearch_build_1(string scalar fullfilename, string scalar tmpname, 
		uniq, cnt, line5)
{
	real scalar		i, k, n
	real scalar		complete
	real scalar		fh
	string scalar		str, line, parse, base
	string colvector	words

	parse = `PARSECHARS'

	stata(`"quietly translate ""' + 
		fullfilename + `"" ""' + 
		tmpname + `"", trans(smcl2txt) logo(off)"')

	str = ""
	line5 = J(5,1,"")
	fh = fopen(tmpname, "r")
	i = 1
	while ((line=fget(fh))!=J(0,0,"")) {
		line = strtrim(line)
		if (line != "") {
			if (line != strlen(line)*"-") {
				if (i<=5) line5[i++] = strtrim(line)
				line = subinstr(line, `"""', "")
				str = str + " " + strlower(line)
			}
		}
	}
	fclose(fh)
	unlink(tmpname)
	words = sort(tokens(str, parse)', 1)

	uniq = J(rows(words), 1, "")
	cnt  = J(rows(words), 1, 0)
	if (rows(words)==0) return

	k = n = 0 
	base = words[1]
	for (i=2; i<=rows(words)+1; i++) {
		if (i>rows(words)) 	 complete = 2 
		else if (words[i]!=base) complete = 1 
		else 			 complete = 0 

		if (complete) {
			if (strlen(base)==0) complete = 0 
			else if (strlen(base)==1) {
				if (strpos(parse, base)) complete = 0
			}
			if (complete) {
				uniq[++k] = base
				cnt[k]    = n
			}
			if (i<=rows(words)) {
				base = words[i]
				n    = 1 
			}
		}
		else	n = n + 1
	}
	uniq = uniq[|1 \ k|]
	cnt  = cnt[|1 \ k|]
}

/* ----------------------------------------------------------------------- */

string colvector dirsearch(string scalar pattern, |string scalar upath)
{
	real scalar		i
	string rowvector	path, tok
	string colvector	res
	
	/* ----------------------------------------------- obtain path --- */
	if (upath=="") path = pathlist() 
	else {
		tok = tokens(upath)
		res = J(1, 0, "")
		for (i=1; i<=length(tok); i++) {
			if (tok[i]!=";") path = path, tok[i]
		}
	}
	/* --------------------------------------------------------------- */

	res = J(0, 1, "")
	for (i=1; i<=length(path); i++) {
		res = res \ dirsearch_dir(path[i], pattern)
	}
	return(uniqrows(res))
}

/*static*/ string colvector dirsearch_dir(string scalar udir, 
						string scalar pattern)
{
	real scalar		i
	string scalar		dir, c
	string colvector	subdirs, res, files
	real scalar		lenext

	dir = (udir=="." ? "." : pathsubsysdir(udir))

	res = J(0, 1, "")
	if (pattern=="") return(res)


	c = bsubstr(pattern,1,2)
	lenext = strlen(pattern) - 1
	if (c=="*.") {
		subdirs = dir(dir, "dirs", "*")
		for (i=1; i<=length(subdirs); i++) {
			if (strlen(subdirs[i])==1) {
				files = dir(pathjoin(dir, subdirs[i]), "files",
								pattern)
				if (length(files) > 0) {
					res = res \
						bsubstr(files, 1,
							 strlen(files):-lenext)
				}
			}
		}
	}
	else 	{
		errprintf("hsearch: assumption failure")
		exit(9653)
	}

	files = dir(dir, "files", pattern)
	if (length(files) > 0) {
		return(uniqrows(res\ bsubstr(files, 1, strlen(files):-lenext)))
	}
	return(uniqrows(res))
}

/* ----------------------------------------------------------------------- */

string scalar FindHelpFile(string scalar fname, |string scalar upath)
{
	real scalar		i
	string rowvector	path, tok
	string scalar		res
	
	/* ----------------------------------------------- obtain path --- */
	if (upath=="") path = pathlist() 
	else {
		tok = tokens(upath)
		for (i=1; i<=length(tok); i++) {
			if (tok[i]!=";") path = path, tok[i]
		}
	}
	/* --------------------------------------------------------------- */

	for (i=1; i<=length(path); i++) {
		res = FindHelpFileWrk(path[i], fname)
		if (res != "") {
			return(res)
		}
	}
	return(fname+".sthlp")	// should be rare, and will cause an error
				// message later
}

/*static*/ string scalar FindHelpFileWrk(string scalar udir,
						string scalar fname)
{
	string scalar		dir
	string scalar		totry1, totry2, totry3

	dir = (udir=="." ? "." : pathsubsysdir(udir))

	// main directory search
	totry2 = fname + ".sthlp"
	totry3 = pathjoin(dir, totry2)
	if (fileexists(totry3)) {
		return(totry2)
	}
	totry2 = fname + ".hlp"
	totry3 = pathjoin(dir, totry2)
	if (fileexists(totry3)) {
		return(totry2)
	}

	// lettered subdirectory search
	totry1 = pathjoin(dir, adosubdir(fname))
	totry2 = fname + ".sthlp"
	totry3 = pathjoin(totry1, totry2)
	if (fileexists(totry3)) {
		return(totry2)
	}
	totry2 = fname + ".hlp"
	totry3 = pathjoin(totry1, totry2)
	if (fileexists(totry3)) {
		return(totry2)
	}

	// not found
	return("")
}

/* ----------------------------------------------------------------------- */

void recursive_mkdir(string scalar path, |real scalar pub)
{
	real scalar		i
	string scalar		head, tail
	string colvector	pieces

	if (!strlen(pieces = path)) return
	if (pathisurl(pieces)) _error("URL found where path required")
	if (direxists(pieces)) return	

	pragma unset head
	pragma unset tail

	mypathsplit(pieces, head, tail)
	while (strlen(head)) {
		pieces = pieces \ head
		mypathsplit(head, head, tail)
	}

	if (args()==1) pub = 0
	for (i=rows(pieces); i; i--) {
		if (!direxists(pieces[i])) mkdir(pieces[i], pub)
	}
}

/*
	what follows is official replacement code for built-in function 
	pathsplit().
*/

void mypathsplit(string scalar upath, ulhs, urhs)
{
	real scalar 	len, i1, i2, i
	string scalar	path
	string scalar	c

	len = strlen(path = upath)
	if (!len) {
		ulhs = urhs = ""
		return
	}
	if (len==1) {
		ulhs = ""
		urhs = path
		return 
	}

	/* ------------------------------------------------------------ */
	if (pathisurl(path)) {
		c = bsubstr(path, 1, 7)
		mypathsplit(bsubstr(path, 8, .), ulhs, urhs)
		if (ulhs!="") ulhs = c + ulhs
		else	      urhs = c + urhs
		return 
	}
	if (bsubstr(path, 2, 1)==":") {
		c = bsubstr(path, 1, 2)
		mypathsplit(bsubstr(path, 3, .), ulhs, urhs)
		if (ulhs!="") ulhs = c + ulhs
		else	      urhs = c + urhs
		return 
	}
	if (bsubstr(path,1,1)=="\" & bsubstr(path,2,1)=="\") {
		mypathsplit(bsubstr(path, 3, .), ulhs, urhs)
		if (ulhs!="") ulhs = "\\" + ulhs
		else	      urhs = "\\" + urhs
		return 
	}
	/* ------------------------------------------------------------ */


	path = strreverse(path)
	c = bsubstr(path, 1, 1)
	if (c=="/" | c=="\") path = bsubstr(path, 2, .)

	i1 = strpos(path, "/")
	i2 = strpos(path, "\") 

	if (!i1 & !i2) {
		ulhs = ""
		urhs = strreverse(path)
		return 
	}
	i = (i1 ? (i2 ? (i1<i2 ? i1: i2) : i1) : i2)

	urhs = strreverse(bsubstr(path, 1, i-1))
	if ((ulhs = strreverse(bsubstr(path, i+1, .)))=="") {
		ulhs = bsubstr(path, i, 1)
	}
}



/* ----------------------------------------------------------------------- */


string rowvector hsearch_search_cleantxt(string scalar txt)
{
	string scalar	s

	s = subinstr(strlower(txt), `"""', "")
	s = subinstr(s, `"'"', "")
	return(tokens(s, `PARSECHARS'))
}


real scalar hsearch_search_score(string vector words, 
			string vector uniq, real vector cnt)
{
	real scalar	i, m, a
	real scalar	idx
	
	m = 1 
	a = 0
	for (i=1; i<=length(words); i++) {
		if (idx=hsearch_binsearch(words[i], uniq)) {
			m = m * cnt[idx]
			a = a + cnt[idx]
		}
		else {
			m = 0 
		}
	}
	// return(trunc((100*m+a)/sqrt(colsum(cnt))))
	return(100*m+a)
}
		

real scalar hsearch_binsearch(string scalar word, string vector list)
{
	real scalar	top, bot, k

	bot = 1 
	top = length(list)

	while (bot <= top) {
		k = trunc((top+bot)/2)
		if (word==list[k]) return(k)
		if (word < list[k]) top = k - 1
		else 		    bot = k + 1
	}
	return(0) 
}

end
