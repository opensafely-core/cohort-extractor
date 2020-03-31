*! version 1.0.8  30jul2013
program define findit_7
	version 7
					/* extended error message for
					   novices
					*/
	if `"`0'"'=="" {
		capture noi error 198
		di as err "{txt}Type {cmd:findit} followed by the keywords" _c
		di as err "{txt} you wish to search for."
		di as err "{txt}See " _c
		if "$S_CONSOLE"=="" {
			di as err "{stata view help findit:help findit}" _c
		}
		else	di as err "{stata help findit}" _c
		di as err "{txt} for more information."
		exit 198
	}

					/* parse command		*/


	gettoken tok : 0, parse(" ,") quotes
	while `"`tok'"' != "" & `"`tok'"' != "," {
		gettoken tok 0 : 0, parse(" ,") quotes
		local key `"`key' `tok'"'
		gettoken tok : 0, parse(" ,") quotes
	}
	if `"`key'"' == "" {
		di as err "must specify keywords for search"
		exit 198
	}
	Fix_keywords `key'
	local key "`s(keywords)'"
	sret clear

	syntax [, Local OR SAVing(string asis) noView Web Historical ]
	parse_saving `saving'
	local saving `"`s(filename)'"'
	local replace `"`s(replace)'"'
	sret clear
	if `"`saving'"' == "" {
		if `"$FINDIT_DIR"' != "" {
			local sep : dirsep
			local saving `"$FINDIT_DIR`sep'_finditresults.smcl"'
		}
		else {
			local saving "_finditresults.smcl"
		}
		local replace replace
		local donotmention 1
	}
	else {
		gettoken j1 j2 : saving, parse(".")
		if `"`j2'"' != "." {
			local saving `"`j1'.smcl"'
		}
	}
	if "`replace'" == "" {
		confirm new file `"`saving'"'
	}
	else 	capture erase `"`saving'"'

					/* parsing complete 	*/
	if "$S_CONSOLE"!="" | "`view'"!="" {
		makelog `"`key'"', `local' `web' `or' `historical'
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
			log using `"`saving'"', smcl
			noisily makelog `"`key'"', nomore `local' `web' `or' /*
						*/ `historical'
			if "`donotmention'"=="" {
				noi di as txt _n /*
*/ "(note:  results of this search saved in " as res `"`saving'"' as txt ")"
			}
		}
		local rc = _rc
		qui log close
		if "`logtype'" != "" {
			qui log using `"`logfn'"', append `logtype'
			if "`logstatus'" != "on" {
				qui log off
			}
		}
	}
	if `rc' {
		exit `rc'
	}
	view `"`saving'"', smcl
end


program define makelog
	gettoken key 0 : 0
	syntax [, OR noMORE Local Web Historical ]
	if "`local'"=="" & "`web'"=="" {
		local local local
		local web web
	}
	if "`more'"!="" {
		set more off
	}
	if "`historical'"!="" {
		local hnote " (including those marked historical)"
	}

	di as txt "{right:$S_DATE $S_TIME}"
	di as txt "{title:Keyword search}" _n
	di as txt "{p 8 19}"
	di as txt "Keywords:  " as res `"`key'"'
	di as txt "{p_end}"

	local n : word count `key'
	if `n'>1 {
		di as txt "{p 7 19}"
		di as txt "Criterion:"
		if "`or'"=="" {
			di as res /*
*/ "Select only entries that have ALL the above words (*)"
		}
		else {
			di as res /*
			*/ "Select entries that have ANY of the above words (*)"
		}
		di as txt "{p_end}"
	}
	di as txt "{p 10 19}"
	di as txt "Search:"
	if "`local'" != "" {
		if "`web'"!="" {
			local p1 "(1) "
			local p2 "(2) "
		}
		di as res "`p1'Official help files`hnote', FAQs, and STBs"
		if "`web'"!="" {
			di "{break}"
		}
	}
	if "`web'" != "" {
		di as res "`p2'Web resources from Stata and from other users"
	}
	di _n "{p 8 10}"
	if `n' > 1 {
		if "`or'"=="" {
			di as txt "*  To search entries that have ANY of the "
			di as txt "above words, type{break}"
			di as txt "{stata findit `key', or}"
		}
		else {
			di as txt "*  To search entries that have ALL of the "
			di as txt "above words, type{break}"
			di as txt "{stata findit `key'}"
		}
		di
	}

	if "`local'"!="" {
		di as txt _n /*
		  */ "{title:Search of official help files, FAQs, and STBs}"
		search `key' , `or' `historical'
		search `key' , `or' `historical' author
		search `key' , `or' `historical' entry
		if "`web'"!="" {
			di
		}
	}
	if "`web'"!="" {
		di as txt _n "{title:Web resources from Stata and other users}"
		di
		net search `key' , `or' nostb
	}
	di as txt _n "(end of search)"
end


program define parse_saving, sclass
	sret clear
	gettoken fn 0 : 0, parse(" ,")
	if `"`fn'"' == "" {
		exit
	}
	gettoken rest 0 : 0, parse(" ,")
	if `"`rest'"'=="," {
		gettoken rest 0 : 0, parse(" ,")
	}
	if `"`rest'"' != "" {
		if `"`rest'"' != "replace" {
			di as err "saving():  syntax error"
			exit 198
		}
		local replace replace
	}
	gettoken rest : 0
	if `"`rest'"' != "" {
		di as err "saving():  syntax error"
		exit 198
	}
	sret local filename `"`fn'"'
	sret local replace `replace'
end

program define Fix_keywords, sclass
	local pchars "-&+/:;"
	sret clear
	tokenize `"`0'"', parse(" `pchars'")
	local i 1
	while "``i''" != "" {
		if index("`pchars'", "``i''")==0 {
			local el = lower("``i''")
			Checkword "`el'"
			if `s(useword)' {
				local list `list' `el'
			}
		}
		local i = `i' + 1
	}
	if "`list'"=="" {
		di as err "{p}"
		di as err "the characters `pchars' are ignored when searching,"
		di as err "as are the prepositions into, of, on, to, and"
		di as err "with; must specify keywords for search"
		di as err "{p_end}"
		exit 198
	}
	sret local keywords `list'
end

program define Checkword, sclass
	args wrd
	sret local useword 1
	local wordlist "into of on to with"
	foreach word of local wordlist {
		if "`wrd'"=="`word'" {
			sret local useword 0
			continue, break
		}
	}
end
exit
