*! version 1.1.5  16sep2019
program adoupdate, rclass
	version 9

	syntax [anything(name=pkglist id="package list")] [, 	///
		ALL			///
		DIR(string)		///
		SSConly 		///
		UPDATE			///
		VERBOSE			///
	       ]

	local upd      = cond("`update'"=="", 0, 1)
	local bos      = cond("`ssconly'"=="", 0, 1)
	local notall   = cond("`all'"=="", 1, 0)
	local noisily  = cond("`verbose'"=="", 0, 1)

	set more off
	mata: pkg_chk_and_update("`dir'", "`pkglist'", ///
			`upd', `bos', `notall', `noisily')
	return local pkglist "`pkglist'"
end


/* ==================================================================== */

version 9

local CMDNAME		"ado update"
local DEFAULT_DIR	"PLUS"

local SJupfile		`""http://www.stata-journal.com/software/filelist.php""'
local SJbasesrc		`""http://www.stata-journal.com/software/""'
local STBupfile		`""http://www.stata.com/stb/filelist.php""'
local STBbasesrc	`""http://www.stata.com/stb/""'
local SSCupfile		`""http://repec.org/docs/sscDD.php""'

local NEGRC_NORESPONSE	(-677)
local NEGRC_NOHOST	(-631)
local NEGRC_NOFILE	(-601)


local boolean		real scalar

local instpkg		string colvector
local instlist		pointer(`instpkg') colvector
local EL_relno		1
local EL_upsrc		2
local EL_uppkgname	3
local EL_FIRST		4

local updlist		pointer(string colvector) colvector
local L_SJ		1
local L_STB		2
local L_SSC		3
local UPDLIST_DIM	3

local pkgcode		real scalar
local PKG_OKAY		0
local PKG_NOLONGER	1
local PKG_NORESPONSE	2
local PKG_CANNOTOPEN	3
local PKG_UNKNOWN	4
local PKG_UPDATED	5

local pkgtype		real scalar
local PT_INSTALLED	1
local PT_NET		2

mata:

/* -------------------------------------------------------------------- */

void pkg_chk_and_update(
		string scalar dir, string scalar pkglist,
		`boolean' update, `boolean' ssconly, `boolean' certainonly,
		`boolean' noisily)
{
	`instlist'	trk
	`updlist'	upd
	string scalar	click

	/* ------------------------------------------------------------ */
	openingmsg()
	upd = J(`UPDLIST_DIM', 1, NULL)

	/* ------------------------------------------------------------ */
	find_and_uninst_dups(dir, 1)

	/* ------------------------------------------------------------ */
	trk = read_statatrk(dir)
	if (ssconly)     trk = extract_ssc(trk)
	if (pkglist!="") trk = extract_matches(trk, pkglist)

	/* ------------------------------------------------------------ */
	if (rows(trk)==0) {
		printf("{txt}")
		if ("pkglist"!="") {
			printf(`"(no packages match "%s")\n"', pkglist)
		}
		else if (ssconly) {
			printf("(no packages installed from SSC\n")
		}
		else {
			printf("(no community-contributed packages installed)\n")
		}
		st_local("pkglist", "")
		return
	}

	/* ------------------------------------------------------------ */
	printf("\n") 
	printf("{txt}Checking status of ")
	printf(pkglist=="" ?  "installed packages...\n":
			      "specified packages...\n")
	trk = extract_update_exists(trk, upd, certainonly)

	/* ------------------------------------------------------------ */
	printf("\n")
	if (rows(trk)==0) {
		printf("{txt}(no packages require updating)\n")
		st_local("pkglist", "")
		return
	}

	printf(update ?  "{txt}Packages to be updated are...\n" :
			 "{txt}Packages that need to be updated are...\n"
	      )
	printf("\n")
	list_packages(trk)
	set_local_pkglist(trk)
	displayflush()

	/* ------------------------------------------------------------ */
	printf("\n") 
	if (!update) {
		click = rebuildcmdwupdate(dir, pkglist, ssconly, certainonly)
		printf("{txt}Recommendation:  type\n")
		printf(`"    {stata `"%s"':%s}\n"', click, click)
		return
	}

	/* ------------------------------------------------------------ */
	printf("{txt}Installing updates...\n")
	printf("\n")
	update_packages(dir, trk, noisily)

	/* ------------------------------------------------------------ */
	printf("\n")
	printf("{txt}Cleaning up...")
	displayflush()
	find_and_uninst_dups(dir, 0)
	printf("{txt} Done\n")
	displayflush()
}

void openingmsg()
{
	printf("{txt}{p 0 7 2}\n")
	printf("(note: {cmd:`CMDNAME'} updates community-contributed files;\n")
	printf("type -{cmd:update}- to check for updates to official Stata)\n")
	printf("{p_end}\n")
}

string scalar rebuildcmdwupdate(
		string scalar dir, string scalar pkglist,
		`boolean' ssconly, `boolean' certainonly)
{
	string scalar	cmd

	cmd = "`CMDNAME'"
	if (strtrim(pkglist)!="") cmd = cmd + " " + strtrim(pkglist)
	cmd = cmd + ","
	if (dir!="") cmd = cmd + " dir(" + dir + ")"
	if (ssconly) cmd = cmd + " ssconly"
	if (!certainonly) cmd = cmd + " all"
	return(cmd + " update")
}


/* -------------------------------------------------------------------- */

`instlist' extract_ssc(`instlist' trk)
{
	real scalar	i
	`instlist'	b

	pragma unset b

	for (i=1; i<=rows(trk); i++) {
		if (isssc(srcof(*trk[i]))) b = b \ trk[i]
	}
	return(b)
}

`instlist' extract_matches(`instlist' trk, string scalar pkglist)
{
	real scalar		i, j
	`instlist'		in
	string rowvector	pat

	pragma unset in

	pat = tokens(pkglist)
	for (i=1; i<=rows(trk); i++) {
		for (j=1; j<=cols(pat); j++) {
			if (strmatch(pkgnameof(*trk[i]), pat[j])) {
				in = in \ trk[i]
				break 
			}
		}
	}
	return(in)
}

/* -------------------------------------------------------------------- */


void update_packages(string scalar dir, `instlist' trk, 
						`boolean' noisily)
{
	real scalar	i
	string scalar	names

	names = ""
	for (i=1; i<=rows(trk); i++) {
		if (netinstall(dir, *trk[i], noisily)) {
			names = names + " " + pkgnameof(*trk[i])
		}
	}
	st_local("pkgname", strtrim(names))
}

`boolean' netinstall(string scalar dir, `instpkg' pkg, `boolean' noisily)
{
	string scalar	uppkgname, pkgname, upsrc, cmd, cmd0
	real scalar	rc, relno

	pkgname   = pkgnameof(pkg)
	uppkgname = uppkgnameof(pkg)
	upsrc     = upsrcof(pkg)
	relno     = relnoof(pkg)

	printf("{txt}")
	printf(relno<10 ? "    " : (relno<100 ? "   " : "  "))

	if (pkgname == uppkgname) {
		printf("[%g] {res:%s}\n", relno, pkgname)
	}
	else {
		printf("[%g] {res:%s} using {res:%s}\n",  
				relno, pkgname, uppkgname)
	}
	displayflush()

	cmd0 = sprintf("net set ado %s", dir=="" ? "`DEFAULT_DIR'" : dir)

	if (isssc(upsrc)) {
		cmd = sprintf("ssc install %s, replace", uppkgname)
	}
	else {
		cmd  = sprintf("net install %s, from(%s) replace force",
				uppkgname, upsrc)
	}

	if (noisily) {
		printf("\n")
		printf("{txt}{hline}\n")
		printf("{txt}-> . %s\n", cmd0) 
		if ((rc = _stata(cmd0))) exit(rc)
		printf("{txt}-> . %s\n", cmd)
		rc = _stata(cmd)
		printf("{txt}{hline}\n")
	}
	else {
		if ((rc = _stata(cmd0, 1))) {
			if (rc==1) exit(1)
			(void) _stata(cmd0)
			exit(rc)
			/*NOTREACHED*/
		}
		rc = _stata(cmd, 1)
	}
		
	if (rc) {
		if (rc==1) exit(1)
		printf("{p 8 8 2}\n")
		printf("{txt}{res:%s} not updated; return code was %g{break}\n",
							pkgname, rc)
		printf("Try updating {res:%s} again later,\n", pkgname)
		printf("type -{cmd:`CMDNAME' %s, update}-.\n", pkgname)
		printf("If that still does not work, type\n")
		printf("-{cmd:`CMDNAME' %s, update verbose}-.\n", pkgname)
		printf("\n")
		return(0)
	}
	return(1)
}


void set_local_pkglist(`instlist' trk)
{
	real scalar	i
	string scalar	list

	list = pkgnameof(*trk[1])
	for (i=2; i<=rows(trk); i++) list = list + " " + pkgnameof(*trk[i])
	st_local("pkglist", list)
}


void list_packages(`instlist' trk)
{
	real scalar	i, n, relno
	string scalar	pkgname, pad

	for (i=1; i<=rows(trk); i++) {
		pkgname = pkgnameof(*trk[i])

		if ((n = 12 - strlen(pkgname)) > 0) {
			pad = "{bind:" + n*" " + "}"
		}
		else	pad = ""

		relno = relnoof(*trk[i])
		if (relno<10) 		printf("{p 4 24 2}\n")
		else if (relno<100) 	printf("{p 3 24 2}\n")
		else 			printf("{p 2 24 2}\n")

		printf("[%g] {res:%s}%s -- %s\n",  relno, pkgname, pad,
				titleof(*trk[i]))
		printf("{p_end}\n")
	}
}

`instlist' extract_update_exists(`instlist' trk, `updlist' upd, 
						`boolean' certainonly)
{
	real scalar	i
	`pkgcode'	status
	`instlist'	res

	pragma unset res

	status = J(rows(trk), 1, .)
	for (i=1; i<=rows(trk); i++) {
		status = pkg_update_status_noisily(*trk[i], upd)
		if (status==`PKG_UPDATED' | 
		   (certainonly==0 & status==`PKG_UNKNOWN')) {
			res = res \ trk[i]
		}
	}

	return(res)
}

`pkgcode' pkg_update_status_noisily(`instpkg' pkg, `updlist' upd)
{
	real scalar	relno
	`pkgcode'	res

	printf("\n")
	relno = relnoof(pkg)
	if (relno<10)       printf("{p 4 8 2}\n")
	else if (relno<100) printf("{p 3 8 2}\n")
	else 		    printf("{p 2 8 2}\n")
	printf("{txt}[%g] {res:%s} at %s:{break}\n", 
				relno, pkgnameof(pkg), srcof(pkg))
	displayflush()

	res = pkg_update_status(pkg, upd)

	if (res==`PKG_OKAY') {
		printf("installed package is up to date\n") 
	}
	else if (res==`PKG_CANNOTOPEN') {
		printf(
		"server not responding or package is no longer available\n")
	}
	else if (res==`PKG_NOLONGER') {
		printf("package no longer available\n")
	}
	else if (res==`PKG_NORESPONSE') {
		printf("server not responding\n") 
	}
	else if (res==`PKG_UPDATED') {
		printf("{res:package has been updated on server}\n")
	}
	else {
		printf(
		"cannot tell because distribution dates not provided by source\n")
	}
	printf("{p_end}\n")
	displayflush()

	return(res)
}

`pkgcode' pkg_update_status(`instpkg' pkg, `updlist' upd)
{
	string scalar	src

	src = srcof(pkg)
	if (isssc(src))          return(pkg_update_status_ssc(pkg, upd))
	if (isstatajournal(src)) return(pkg_update_status_sj( pkg, upd))
	if (isstb(src))          return(pkg_update_status_stb(pkg, upd))

	return(pkg_update_status_default(pkg))
}

`boolean' isstb(string scalar s)
{
	string scalar sl

	sl = strlower(s)
	if (pstrcmp("http://www.stata.com/stb/", sl)) return(1)
	return(0)
}

`boolean' isstatajournal(string scalar s)
{	
	string scalar sl

	sl = strlower(s)
	if (pstrcmp("http://www.stata-journal.com/software/", sl)) return(1)
	if (pstrcmp("http://www.statajournal.com/software/",  sl)) return(1)
	if (pstrcmp("http://www.stata-journal.org/software/", sl)) return(1)
	if (pstrcmp("http://www.statajournal.org/software/",  sl)) return(1)
	return(0)
}

`boolean' isssc(string scalar s)
{
	string scalar	sl

	sl = strlower(s)
	if (pstrcmp("http://fmwww.bc.edu/repec/", sl)) return(1)
	return(0)
}
	
`boolean' pstrcmp(string scalar substr, string scalar fullstr)
{
	return( (substr == bsubstr(fullstr, 1, strlen(substr))) )
}

`pkgcode' pkg_update_status_ssc(`instpkg' pkg, `updlist' upd)
{
	real scalar	dinstalled, dnet
	string scalar	strdate

	if (upd[`L_SSC']==NULL) {
		upd[`L_SSC'] = &(loadsscupfile())
		/*
		testing of bsearch:
		printf("\n")
		i = rows(*upd[`L_SSC'])
		i
		(*upd[`L_SSC'])[1]
		(*upd[`L_SSC'])[i]
		bsearch_ssclist("_gclsort", *upd[`L_SSC'], 0)
		bsearch_ssclist("ztg", *upd[`L_SSC'], 0)
		*/
	}


	strdate = search_ssclist(pkgnameof(pkg), *upd[`L_SSC'])
	if (strdate=="") return(`PKG_NOLONGER')

	dinstalled = distributiondateof(pkg, `PT_INSTALLED')
	dnet       = edateofstr(strdate)

	if (dinstalled<. & dnet<.) {
		if (dinstalled<dnet) {
			set_upinfoof(pkg, srcof(pkg), pkgnameof(pkg))
			return(`PKG_UPDATED')
		}
		return(`PKG_OKAY')
	}

	if (dnet<. & dinstalled>=.) {
		set_upinfoof(pkg, srcof(pkg), pkgnameof(pkg))
		return(`PKG_UPDATED')
	}
	return(`PKG_UNKNOWN')
}

string scalar search_ssclist(string scalar pkgname, string colvector ssclist)
{
	real scalar	i

	if (i = bsearch_ssclist(strlower(pkgname), ssclist, 0)) {
		return(tokens(ssclist[i])[2])
	}
	return("")
}

/*
	i = bsearch_ssclist(name, ssclist, i0)

        Look for name in strictly ascending ssclist[] between i0 and 
	end-of-list.  Specify i0=0 to search entire list.
*/

real scalar bsearch_ssclist(string scalar name,
			   string vector ssclist, 
			   real scalar j0)
{
	real scalar	n, jl, ju, jm

	jl = j0   
	ju = (n=length(ssclist)) + 1 

	while (ju-jl>1) {
		jm = trunc((ju+jl)/2)
		if ( name > (tokens(ssclist[jm])[1]) ) 	jl = jm 
		else 					ju = jm 
	}
	if (jl<n) { 
		ju = jl
		if ( name == (tokens(ssclist[++ju])[1]) ) return(ju)
	}
	return(0)
}

	
`pkgcode' pkg_update_status_default(`instpkg' pkg)
{
	string colvector	net
	string scalar		ffn
	real scalar		dinstalled, dnet
	real scalar		negrc

	ffn = srcffnof(pkg)

	pragma unset net
	if ((negrc=read_pkg_file(ffn, net))) {
		if (negrc==`NEGRC_NORESPONSE') return(`PKG_NORESPONSE')
		if (negrc==`NEGRC_NOHOST')     return(`PKG_NORESPONSE')
		if (negrc==`NEGRC_NOFILE')     return(`PKG_NOLONGER')
		return(`PKG_CANNOTOPEN')
	}

	dinstalled = distributiondateof(pkg, `PT_INSTALLED')
	dnet       = distributiondateof(net, `PT_NET')

	if (dinstalled<. & dnet<.) {
		if (dinstalled<dnet) {
			set_upinfoof(pkg, srcof(pkg),pkgnameof(pkg))
			return(`PKG_UPDATED')
		}
		return(`PKG_OKAY')
	}

	if (dnet<. & dinstalled>=.) {
		set_upinfoof(pkg, srcof(pkg), pkgnameof(pkg))
		return(`PKG_UPDATED')
	}
	return(`PKG_UNKNOWN')
}

`pkgcode' pkg_update_status_stb(`instpkg' pkg, `updlist' upd)
{
	real scalar	idx
	string scalar	pkgname

	if (pkg_update_status_sj(pkg, upd)==`PKG_UPDATED') {
		return(`PKG_UPDATED')
	}

	pkgname = pkgnameof(pkg)
	if (upd[`L_STB']==NULL) upd[`L_STB'] = &loadupfile(`STBupfile')

	if (idx = findbestinlist(pkgname, *upd[`L_STB'])) {
		set_upinfo_fromupd(pkg, upd, `L_STB', idx, `STBbasesrc')
		return(`PKG_UPDATED')
	}
	return(`PKG_OKAY')
}


`pkgcode' pkg_update_status_sj(`instpkg' pkg, `updlist' upd)
{
	real scalar		idx
	string scalar		pkgname

	pkgname = pkgnameof(pkg)
	if (upd[`L_SJ']==NULL) upd[`L_SJ'] = &loadupfile(`SJupfile')
	if (idx = findbestinlist(pkgname, *upd[`L_SJ'])) {
		set_upinfo_fromupd(pkg, upd, `L_SJ', idx, `SJbasesrc')
		return(`PKG_UPDATED')
	}
	return(`PKG_OKAY')
}

void set_upinfo_fromupd(`instpkg' pkg, 
		`updlist' upd, real scalar l, real scalar i, 
		string scalar basesrc)
{
	string rowvector	toks

	toks = tokens((*upd[l])[i])
	set_upinfoof(pkg, pathjoin(basesrc,toks[1]), toks[2])
}


string colvector loadupfile(string scalar ffn)
{
	real scalar		fh
	string scalar		line
	string colvector	res

	fh = fopen(ffn, "r")

	pragma unset res
	while ((line=fget(fh))!=J(0,0,"")) {
		if (strpos(line, "_")) res = res \ line
	}
	fclose(fh)
	return(res)
}

string colvector loadsscupfile()
{
	real scalar	fh
	string scalar	line
	string colvector res

	fh = fopen(`SSCupfile', "r")

	pragma unset res
	while ((line=fget(fh))!=J(0,0,"")) {
		if (line!="") {
			res = res \ strlower(subinstr(line,":","",1))
		}
	}
	fclose(fh)
	_sort(res, 1)
	return(res)
}


real scalar findbestinlist(string scalar name, string colvector list)
{
	string scalar	curlhs, newlhs, newname
	real scalar	currhs, newrhs
	real scalar	i, bestidx, bestrhs

	pragma unset newlhs
	pragma unset newrhs
	pragma unset curlhs
	pragma unset currhs

	splitname(name, curlhs, currhs)

	bestrhs = currhs
	bestidx = 0
	for (i=1; i<=rows(list); i++) {
		newname = tokens(list[i])[2]
		splitname(newname, newlhs, newrhs)
		if (newlhs == curlhs) {
			if (newrhs>bestrhs) {
				bestrhs = newrhs
				bestidx = i 
			}
		}
	}
	return(bestidx)
}

void splitname(string scalar name, lhs, rhs)
{
	real scalar	i

	if (i = strpos(name, "_")) {
		lhs = bsubstr(name, 1, i-1)
		rhs = strtoreal(bsubstr(name, i+1, .))
		if (rhs<.) return
	}
	lhs = name
	rhs = -1
}
		

string scalar basepkgname(string scalar name)
{
	real scalar	i

	i = strpos(name, "_")
	return(i ? bsubstr(name, 1, i-1) : name)
}
	
	
/* -------------------------------------------------------------------- */

void find_and_uninst_dups(string scalar dir, `boolean' noisily)
{
	while (1) {
		if (find_and_uninst_1dup_std(dir, noisily)==0) break
	}

	while (1) {
		if (find_and_uninst_1dup_sjstb(dir, noisily)==0) break
	}

	while (1) {
		if (find_and_uninst_1dup_ssc(dir, noisily)==0) break
	}
}

`boolean' find_and_uninst_1dup_std(string scalar dir, `boolean' noisily)
{
	`instlist'		trk
	string colvector	lcffn
	real scalar		i, j

	trk = read_statatrk(dir)

	lcffn = J(rows(trk), 1, "")
	for (i=1; i<=rows(trk); i++) lcffn[i] = strlower(srcffnof(*trk[i]))

	for (i=1; i<rows(lcffn) /*sic*/; i++) {
		for (j=i+1; j<=rows(lcffn); j++) {
			if (lcffn[i]==lcffn[j]) {
				rmdup(dir, trk, i, j, noisily)
				return(1)
			}
		}
	}
	return(0)
}

`boolean' find_and_uninst_1dup_ssc(string scalar dir, `boolean' noisily)
{
	`instlist'		trk
	real colvector		isssc
	string colvector	lcpkgname
	real scalar		i, j

	trk = read_statatrk(dir)

	isssc = J(rows(trk), 1, .)
	lcpkgname = J(rows(trk), 1, "")
	for (i=1; i<=rows(trk); i++) {
		isssc[i] = isssc(srcof(*trk[i]))
		lcpkgname[i] = strlower(pkgnameof(*trk[i]))
	}

	for (i=1; i<rows(trk) /*sic*/; i++) {
		if (isssc[i]) {
			for (j=i+1; j<=rows(trk); j++) {
				if (isssc[j]) {
					if (lcpkgname[i]==lcpkgname[j]) {
						rmdup(dir, trk, i, j,
								noisily)
						return(1)
					}
				}
			}
		}
	}
	return(0)
}

`boolean' find_and_uninst_1dup_sjstb(string scalar dir, `boolean' noisily)
{
	`instlist'		trk
	string colvector	lhs
	real colvector		rhs
	string scalar		pkgname, curlhs, src
	`boolean'		touse, hassjstb
	real scalar		i, j, currhs, torm

	trk = read_statatrk(dir)

	lhs = J(rows(trk), 1, "")
	rhs = J(rows(trk), 1, .)
	hassjstb = 0
	for (i=1; i<=rows(trk); i++) {
		src = srcof(*trk[i])
		touse = 0
		if (isstatajournal(src)) touse = 1 
		else if (isstb(src)) touse = 1 
		if (touse) {
			hassjstb = 1
			pkgname = pkgnameof(*trk[i])
			pragma unset curlhs
			pragma unset currhs
			splitname(pkgname, curlhs, currhs)
			lhs[i] = curlhs
			rhs[i] = currhs
		}
	}

	if (!hassjstb) return(0)

	for (i=1; i<rows(trk) /*sic*/; i++) {		
		if (rhs[i]<.) {
			for (j=i+1; j<=rows(trk); j++) {
				if (rhs[j]<.) {
					if (lhs[i]==lhs[j]) {
						torm = (rhs[i]>rhs[j] ? j:i)
						netrm(dir, *trk[torm], noisily)
						return(1)
					}
				}
			}
		}
	}
	return(0)
}

void rmdup(string scalar dir, `instlist' trk, real scalar i, 
					real scalar j, `boolean' noisily)
{
	real scalar	idate, jdate, torm

	idate = installdateof(*trk[i])
	jdate = installdateof(*trk[j])

	if (idate>jdate) 	torm = j
	else if (idate<jdate)	torm = i
	else {
		if (uniqidof(*trk[i])>uniqidof(*trk[j])) torm = j
		else				         torm = i 
	}

	netrm(dir, *trk[torm], noisily)
}

void netrm(string scalar dir, `instpkg' pkg, `boolean' noisily)
{
	string scalar	cmd

	if (noisily) {
		printf("{p}\n")
		printf(
		"{txt}(note: package {res:%s} was installed more than once;\n", 
		 		pkgnameof(pkg))
		printf("older copy removed)\n")
		printf("{p_end}\n") 
	}

	cmd = sprintf("quietly ado uninstall [%g]", relnoof(pkg))
	if (dir!="") cmd = cmd + ", from("+dir+")"
	stata(cmd)
}
/* -------------------------------------------------------------------- */


`instlist' read_statatrk(string scalar dir)
{
	real scalar	fh, i
	string scalar	element
	`instlist'	res
	
	res = J(0,1,NULL)

	if ((fh = _fopen(ffn_of_statatrk(dir), "r")) < 0) {
		errprintf(
		"directory %s does not have user-installed files\n", dir)
		exit(601)
	}

	i = 0
	while((element=read_statatrk_element(fh, ++i))!=J(0,1,"")) {
		res = res \ &acopy(element)
	}
	fclose(fh)
	return(res) 
}


string scalar ffn_of_statatrk(string scalar dir)
{
	string scalar	basedir

	basedir = pathsubsysdir(dir=="" ? "`DEFAULT_DIR'" : dir)
	return(pathjoin(basedir, "stata.trk"))
}

transmorphic matrix acopy(transmorphic matrix x)
{
	transmorphic matrix copy 
	copy = x 
	return(copy)
}

void read_statatrk_skiphdr(real scalar fh)
{
	string scalar	line
	real scalar	pos

	pos = ftell(fh)
	while ((line=fget(fh))!=J(0,0,"")) {
		if (!(bsubstr(line,1,1)=="*" | strtrim(line)=="")) {
			fseek(fh, pos, -1)
			return
		}
		pos = ftell(fh)
	}
}


`instpkg' read_statatrk_element(real scalar fh, real scalar i)
{
	`instpkg' 	res
	string scalar	line

	res = J(`EL_FIRST', 1, "")
	res[`EL_relno'] = sprintf("%g", i)

	read_statatrk_skiphdr(fh)
	if ((line = fget(fh))==J(0,0,"")) return(J(0,1,""))

	if (bsubstr(line, 1, 1)!="S") {
		errprintf("stata.trk file invalid header\n") 
		exit(610)
	}
	res[`EL_FIRST'] = line

	while ((line=fget(fh))!=J(0,0,"")) {
		if (line!="" & bsubstr(line,1,1)!="*") {
			res = res \ strrtrim(line)
			if (bsubstr(line,1,1)=="e") return(res)
		}
	}
	errprintf("stata.trk file invalid contents\n") 
	exit(610)
	/*NOTREACHED*/
}



/* -------------------------------------------------------------------- */

real scalar read_pkg_file(string scalar ffn, string colvector res)
{
	real scalar 	fh

	if ((fh = _fopen(ffn, "r")) < 0) {
		res = J(0, 1, "")
		return(fh)
	}
	res = read_pkg_element(fh)
	fclose(fh)
	return(0)
}


string colvector read_pkg_element(real scalar fh)
{
	string colvector res
	string scalar	line

	pragma unset res
	while ((line=fget(fh))!=J(0,0,"")) {
		if (line!="" & bsubstr(line,1,1)!="*") {
			res = res \ strrtrim(line)
		}
	}
	return(res)
}

/* -------------------------------------------------------------------- */

string scalar srcof(`instpkg' pkg)
{
	return(subelementof(pkg, "S"))
}

string scalar titleof(`instpkg' pkg)
{
	string colvector	res

	res = subelementof(pkg, "d")
	return(rows(res)==0 ? "" : res[1])
}

string scalar upsrcof(`instpkg' pkg)
{
	return(pkg[`EL_upsrc'])
}

string scalar srcffnof(`instpkg' pkg)
{
	string scalar	src, fn

	src = srcof(pkg)
	fn  = subelementof(pkg, "N")

	if (rows(src)!=1 | rows(fn)!=1) return("")
	return(pathjoin(src, fn))
}

string scalar pkgnameof(`instpkg' pkg)
{
	string colvector	res
	real scalar		len

	res = subelementof(pkg, "N")
	if (rows(res)!=1) return("")

	len = strlen(res)
	if (bsubstr(res, len-3, .) == ".pkg") return(bsubstr(res, 1, len-4))
	return(res)
}

string scalar uppkgnameof(`instpkg' pkg)
{
	return(pkg[`EL_uppkgname'])
}


real scalar uniqidof(`instpkg' pkg)
{
	string colvector	res
	real scalar		uid

	res = subelementof(pkg, "U")
	if (rows(res)==1) {
		uid = strtoreal(res)
		if (uid<.) return(uid)
	}
		
	pkg_corrupt()
	/*NOTREACHED*/
}

real scalar relnoof(`instpkg' pkg)
{
	real scalar	rel

	if ((rel = strtoreal(pkg[`EL_relno'])) < .) return(rel)
	pkg_corrupt()
	/*NOTREACHED*/
}


real scalar installdateof(`instpkg' pkg)
{
	string colvector	res
	real scalar		edate

	res = subelementof(pkg, "D")
	if (rows(res)==1) {
		edate = date(res, "dmy")
		if (edate<.) return(edate)
	}
	pkg_corrupt()
	/*NOTREACHED*/
}
		

real scalar distributiondateof(`instpkg' pkg, `pkgtype' ptype)
{
	real scalar		i
	string colvector	d
	real scalar		e, emax

	d = distributiondatesof(pkg, ptype)
	
	emax = 0
	for (i=1; i<=rows(d); i++) {
		e = edateofstr(d[i])
		if (e>emax & e<.) emax = e
	}
	return(emax ? emax : .)
}

	
string colvector distributiondatesof(`instpkg' pkg, `pkgtype' ptype)
{
	real scalar		i
	string colvector	d
	string colvector	res

	d = (ptype==`PT_INSTALLED' ? 
		subelementof(pkg, "d") : 
		subelementnet(pkg, "d")
	    )

	pragma unset res
	for (i=1; i<=rows(d); i++) {
		/* ----+----1----+--- */
                /* Distribution-Date: */
		if (strlower(bsubstr(d[i], 1, 18))=="distribution-date:") {
			res = res \ strlower(strtrim(bsubstr(d[i], 19, .)))
		}
	}
	return(res)
}
		

string colvector subelementof(`instpkg' pkg, string scalar ltr)
{
	real scalar		i
	string colvector	res

	pragma unset res
	for (i=`EL_FIRST'; i<=rows(pkg); i++) {
		if (bsubstr(pkg[i],1,1)==ltr) {
			res = res \ strtrim(bsubstr(pkg[i],2,.))
		}
	}
	return(res)
}

string colvector subelementnet(string colvector gel, string scalar ltr)
{
	real scalar		i
	string colvector	res

	pragma unset res
	for (i=1; i<=rows(gel); i++) {
		if (bsubstr(gel[i],1,1)==ltr) {
			res = res \ strtrim(bsubstr(gel[i],2,.))
		}
	}
	return(res)
}

void set_upinfoof(`instpkg' pkg, string scalar src, string scalar pkgname)
{
	pkg[`EL_upsrc']     = src
	pkg[`EL_uppkgname'] = pkgname
}

void pkg_corrupt()
{
	errprintf("stata.trk file invalid or corrupted\n")
	errprintf("no action taken\n")
	exit(610)
	/*NOTREACHED*/
}


/* -------------------------------------------------------------------- */

real scalar edateofstr(string scalar s)
{
	real scalar	res
	real scalar	yr, mo, da

	if (strlen(s)==8) {
		yr = strtoreal(bsubstr(s, 1, 4))
		mo = strtoreal(bsubstr(s, 5, 2))
		da = strtoreal(bsubstr(s, 7, 2))
		if (yr<. & mo<. & da<.) {
			res = mdy(mo, da, yr)
			if (res!=.) return(res)
		}
	}
	return(date(s, "dmy"))
}


real scalar docmd(string scalar rhs)
{
	real scalar	res
	
	stata("scalar DoCmdStringScalar = " + rhs)
	res = st_numscalar("DoCmdStringScalar")
	stata("scalar drop DoCmdStringScalar")
	return(res)
}
	

/*
real scalar mdy(real mo, real da, real yr)
{
	return(docmd(sprintf("mdy(%g, %g, %g)", mo, da, yr)))
}

real scalar date(string scalar str, string scalar pattern)
{
	return(docmd(sprintf(`"date("%s", "%s")"', str, pattern)))
}
*/



/* -------------------------------------------------------------------- */

end
