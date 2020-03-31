*! version 1.1.6  15oct2019
program define ssc
	version 7
	gettoken cmd 0 : 0, parse(" ,")

	di as txt "" _c		/* work around for net display problem */

	if `"`cmd'"'=="" {
		di as txt "ssc commands are"
		di as txt "    {cmd:ssc new}"
		di as txt "    {cmd:ssc hot}"
		di
		di as txt "    {cmd:ssc describe}  {it:pkgname}"
		di as txt "    {cmd:ssc describe}  {it:letter}"
		di
		di as txt "    {cmd:ssc install}   {it:pkgname}"
		di as txt "    {cmd:ssc uninstall} {it:pkgname}"
		di
		di as txt "    {cmd:ssc type}      {it:filename}  (less used)"
		di as txt "    {cmd:ssc copy}      {it:filename}  (less used)"
		di as txt "see help {help ssc##|_new:ssc}"
		exit 198
	}


	local l = length(`"`cmd'"')
	if `"`cmd'"' == bsubstr("whatsnew",1,max(4,`l')) {
		sscwhatsnew `0'
		exit
	}
	if `"`cmd'"' == "new" { 
		sscwhatsnew `0'
		exit
	}
	if `"`cmd'"' == bsubstr("whatshot",1,max(6,`l')) {
		ssc_whatshot `0'
		exit
	}
	if `"`cmd'"' == "hot" { 
		ssc_whatshot `0'
		exit
	}
	if `"`cmd'"' == bsubstr("describe",1,max(1,`l')) {
		sscdescribe `0'
		exit
	}
	if `"`cmd'"' == bsubstr("install",1,max(4,`l')) {
		sscinstall `0'
		exit
	}
	if `"`cmd'"' == "uninstall" {
		sscuninstall `0'
		exit
	}
	if `"`cmd'"'=="copy" | `"`cmd'"'=="cp" {
		ssccopy `0'
		exit
	}
	if `"`cmd'"'=="type" | `"`cmd'"'=="cat" {
		ssctype `0'
		exit
	}
	di as err `"{bf:ssc `cmd'}: invalid subcommand"'
	exit 198
end

program define sscwhatsnew
	syntax [, SAVing(string asis) TYPE]

	if `"`saving'"' != "" {
		ProcSaving `saving'
		local fn `"`r(fn)'"'
		local replace `"`r(replace)'"'
		SuffixFilename `"`fn'"'
		local fn `"`r(fn)'"'
		if "`replace'"!="" {
			capture erase "`fn'"
		}
		else {
			confirm new file "`fn'"
		}
	}
	else {
		local fn "ssc_results.smcl"
		capture erase "`fn'"
	}

	di in gr "(contacting http://repec.org)"
	copy http://repec.org/docs/smcl.php "`fn'", text 

	if "$S_CONSOLE"!="" | "`type'"!="" {
		type "`fn'"
	}
	else	view "`fn'", smcl
end
	

program define SuffixFilename, rclass
	args fn
	local lp = index("`fn'", ".")
	if index(`"`fn'"', ".")==0 {
		ret local fn `"`fn'.smcl"'
	}
	else	ret local fn `"`fn'"'
end
	
		

program define ProcSaving, rclass
	local saving `"`0'"'
	gettoken fn saving : saving, parse(" ,")
	gettoken comma saving : saving, parse(" ,")
	gettoken replace saving : saving, parse(" ,")
	gettoken nothing saving : saving, parse(" ,")

	if "`fn'"=="" {
		InvalidSaving `0'
	}
	ret local fn "`fn'"
	if "`comma'"=="" {
		exit
	}
	if "`comma'"!="," {
		InvalidSaving `0'
	}
	if "`replace'"!="replace" {
		InvalidSaving `0'
	}
	if "`nothing'"!="" {
		InvalidSaving `0'
	}
	ret local replace "replace"
end
	

program define InvalidSaving
	di as err `"option {bf:saving(`0')}:  invalid syntax"'
	exit 198
end
		





program define sscdescribe
	* ssc describe <package>|<ltr> [, saving(<filename>[,replace]) ]
	gettoken pkgname 0 : 0, parse(" ,")
	if length(`"`pkgname'"')==1 {
		local pkgname = lower(`"`pkgname'"')
		if !index("abcdefghijklmnopqrstuvwxyz_",`"`pkgname'"') {
			di as err "{bf:ssc describe}: letter must be a-z or _"
			exit 198
		}
	}
	else {
		CheckPkgname "ssc describe" `"`pkgname'"'
		local pkgname `"`s(pkgname)'"'
	}
	syntax [, SAVING(string asis)]
	LogOutput `"`saving'"' sscdescribe_u `"`pkgname'"'
	if `"`s(loggedfn)'"' != "" {
		di as txt `"(output saved in `s(loggedfn)')"'
	}
end

program define sscdescribe_u
	args pkgname
	local ltr = bsubstr(`"`pkgname'"',1,1)
	if length(`"`pkgname'"')==1 {
		net from http://fmwww.bc.edu/repec/bocode/`ltr'
		di as txt /*
*/ "(type {cmd:ssc describe} {it:pkgname} for more information on {it:pkgname})"
	}
	else {
		qui net from http://fmwww.bc.edu/repec/bocode/`ltr'
		capture net describe `pkgname'
		local rc = _rc
		if _rc==601 | _rc==661  {
			di as err /*
*/ `"{bf:ssc describe}: "{bf:`pkgname'}" not found at SSC, type {stata search `pkgname'}"'
			di as err /*
*/ "(To find all packages at SSC that start with `ltr', type {stata ssc describe `ltr'})"
		}
		if _rc==0 {
			net describe `pkgname'
			di as txt /*
			*/ "(type {stata ssc install `pkgname'} to install)"
		}
		exit `rc'
	}
end


program define sscinstall
	* ssc install <package> [, <net_install_options>]
	gettoken pkgname 0 : 0, parse(" ,")
	CheckPkgname "ssc install" `"`pkgname'"'
	local pkgname `"`s(pkgname)'"'
	syntax [, ALL REPLACE]
	local ltr = bsubstr("`pkgname'",1,1)
	qui net from http://fmwww.bc.edu/repec/bocode/`ltr'
	capture net describe `pkgname'
	local rc = _rc
	if _rc==601 | _rc==661 {
		di as err /*
*/ `"{bf:ssc install}: "{bf:`pkgname'}" not found at SSC, type {stata search `pkgname'}"'
		di as err /*
*/ "(To find all packages at SSC that start with `ltr', type {stata ssc describe `ltr'})"
		exit `rc'
	}
	if _rc {
		error `rc'
	}
	capture noi net install `pkgname', `all' `replace'
	local rc = _rc
	if _rc==601 | _rc==661 {
		di
		di as err /*
*/ `"{p}{bf:ssc install}: apparent error in package file for {bf:`pkgname'}; please notify {browse "mailto:repec@repec.org":repec@repec.org}, providing package name{p_end}"'
	}
	exit `rc'
end

program define sscuninstall
	* ssc uninstall <package>
	gettoken pkgname 0 : 0, parse(" ,")
	CheckPkgname "ssc install" `"`pkgname'"'
	local pkgname `"`s(pkgname)'"'
	if trim(`"`0'"')!="" {
		exit 198
	}

	ado uninstall `pkgname'
end

program define ssccopy
	* ssc copy <filename> [, plus personal <copy_options>]
	*
	* backwards compatibility: sjplus and stbplus are synonyms for plus

	gettoken fn 0 : 0, parse(" ,")
	CheckFilename "ssc copy" `"`fn'"'
	local fn `"`s(fn)'"'
	syntax [, PUBlic BINary REPLACE STBplus SJplus PLus Personal]

	local text = cond("`binary'"=="","text","")

	local op "stbplus"
	if "`sjplus'" != "" {
		local stbplus stbplus
		local op "sjplus"
	}
	if "`plus'" != "" {
		local stbplus stbplus
		local op "plus"
	}
	if "`stbplus'"!="" & "`personal'"!="" {
		di as err "options {bf:`op'} and {bf:personal} may not be specified together"
		exit 198
	}
	local ltr = bsubstr(`"`fn'"',1,1)


	if "`stbplus'"!="" {
		local dir : sysdir STBPLUS
		local dirsep : dirsep
		local dir `"`dir'`ltr'`dirsep'"'
		local dfn `"`dir'`fn'"'
	}
	else if "`personal'" != "" {
		local dir : sysdir PERSONAL
		local dfn `"`dir'`fn'"'
	}
	else {
		local dir "current directory"
		local dfn `"`fn'"'
	}

	capture copy `"http://fmwww.bc.edu/repec/bocode/`ltr'/`fn'"' /*
		*/ `"`dfn'"' , `public' `text' `replace'
	local rc = _rc
	if _rc==601 | _rc==661 {
		di as err /*
	*/ `"{bf:ssc copy}: "{bf:`fn'}" not found at SSC, type {stata search `fn'}"'
		exit `rc'
	}
	if _rc {
		error `rc'
	}
	di as txt "(file `fn' copied to `dir')"
end


program define ssctype
	gettoken fn 0 : 0, parse(" ,")
	syntax [, ASIS]
	CheckFilename "ssc type" `"`fn'"'
	local fn `"`s(fn)'"'
	local ltr = bsubstr(`"`fn'"',1,1)
	capture type `"http://fmwww.bc.edu/repec/bocode/`ltr'/`fn'"'
	local rc = _rc
	if _rc==601 | _rc==661 {
		di as err /*
	*/ `"{bf:ssc type}: "{bf:`fn'}" not found at SSC, type {stata search `fn'}"'
		exit `rc'
	}
	if _rc {
		error `rc'
	}
	type `"http://fmwww.bc.edu/repec/bocode/`ltr'/`fn'"', `asis'
end


program define CheckPkgname, sclass
	args id pkgname
	sret clear
	if `"`pkgname'"' == "" {
		di as err `"{bf:`id'}: nothing found where package name expected"'
		exit 198
	}
	if length(`"`pkgname'"')==1 {
		di as err `"{bf:`id'}: "{bf:`pkgname'}" invalid SSC package name"'
		exit 198
	}
	local pkgname = lower(`"`pkgname'"')
	if !index("abcdefghijklmnopqrstuvwxyz_",bsubstr(`"`pkgname'"',1,1)) {
		di as err `"{bf:`id'}: "{bf:`pkgname'}" invalid SSC package name"'
		exit 198
	}
	sret local pkgname `"`pkgname'"'
end

program define CheckFilename, sclass
	args id fn
	sret clear
	if `"`fn'"'=="" {
		di as err `"{bf:`id'}: nothing found where filename expected"'
		exit 198
	}
	if length(`"`fn'"')==1 {
		di as err `"{bf:`id'}: "{bf:`fn'}" invalid SSC filename"'
		exit 198
	}
	local fn = lower(`"`fn'"')
	if !index("abcdefghijklmnopqrstuvwxyz_",bsubstr(`"`fn'"',1,1)) {
		di as err `"{bf:`id'}: "{bf:`fn'}" invalid SSC filename"'
		exit 198
	}
	sret local fn `"`fn'"'
end


program define LogOutput, sclass
	gettoken saving 0 : 0

	sret clear
	ParseSaving `saving'
	local fn      `"`s(fn)'"'
	local replace  "`s(replace)'"
	sret clear

	if `"`fn'"'=="" {
		`0'
		exit
	}

	quietly log
	local logtype   `"`r(type)'"'
	local logstatus `"`r(status)'"'
	local logfn     `"`r(filename)'"'

	nobreak {
		if `"`logtype'"' != "" {
			qui log close
		}
		capture break {
			capture log using `"`fn'"' , `replace'
			if _rc {
				noisily log using `"`fn'"', `replace'
				/*NOTREACHED*/
			}
			local loggedfn `"`r(filename)'"'
			noisily `0'
		}
		local rc = _rc
		capture log close
		if "`logtype'" != "" {
			qui log using `"`logfn'"', append `logtype'
			if "`logstatus'" != "on" {
				qui log off
			}
		}
	}
	sret local loggedfn `"`loggedfn'"'
	exit `rc'
end


program define ParseSaving, sclass
	* fn[,replace]
	sret clear
	if `"`0'"' == "" {
		exit
	}
	gettoken fn      0 : 0, parse(", ")
	gettoken comma   0 : 0
	gettoken replace 0 : 0

	if `"`fn'"'!="" & `"`0'"'=="" {
		if `"`comma'"'=="" | (`"`comma'"'=="," & `"`replace'"'=="") {
			sret local fn `"`fn'"'
			exit
		}
		if `"`comma'"'=="," & `"`replace'"'=="replace" {
			sret local fn `"`fn'"'
			sret local replace "replace"
			exit
		}
	}
	di as err "option {bf:saving()} misspecified"
	exit 198
end
