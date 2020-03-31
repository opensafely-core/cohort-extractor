*! version 1.0.0  27mar2015
program define z_unicode
	version 14
	local version : di "version " string(_caller()) ":"

	gettoken subcmd 0 : 0, parse(", ")

	local len = strlen(`"`subcmd'"') 
	
	if (`len' >= 3) & `"`subcmd'"' == bsubstr("locale", 1, `len') {
		`version' Ulocale `0'
	}
	else if (`len' >= 2) & `"`subcmd'"' == bsubstr("uipackage", 1, `len') {
		`version' Uuipackage `0'
	}
	else if (`len' >= 3) & `"`subcmd'"' == bsubstr("encoding", 1, `len') {
		`version' Uencoding `0'
	}
	else if (`len' >= 4) & `"`subcmd'"' == bsubstr("collator", 1, `len') {
		`version' Ucollator `0'
	}
	else if (`len' >= 4) & `"`subcmd'"' == bsubstr("convertfile", 1, `len') {
		`version' _unicode_convertfile `0'		
	}
	else if (`len' >= 4) & `"`subcmd'"' == bsubstr("fixvariable", 1, `len') {
		`version' Ufixvar			
	}
	else {
		di as error `"subcommand {bf:"`subcmd'"} unknown"'
		exit 198
	}
end

/*---------------------------------------------------------------------------*/
	/* Fix variable with invalid UTF-8 sequence */
program Ufixvar
	version 14
	args nothing
	
	capture confirm existence `nothing'
	if _rc==0 { 
		di as error `"{bf:`nothing'} found where nothing expected"'
		exit 198
	}
	
	mata:_unicode_fixvar()
end

mata:
void _unicode_fixvar_error(string scalar name) 
{
	errprintf("error happened during fixing variable {bf:%s}\n", name)   
}

string scalar _unicode_fixvar_underscore(string scalar newname, string scalar name)
{
	string scalar res 
	
	res = ""
	if(bsubstr(newname, 1, 2)=="__") {
		if(bsubstr(name, 1, 1) !="_") {
			res = "v"+ bsubstr(newname, 2, .)
		}
		else {
			res = "_v"+ bsubstr(newname, 3, .)		
		}
		return(res) 
	}
	else {
		return(newname)
	}
}

string scalar _unicode_fixvar_unique(string scalar newname)
{
	string scalar res, prefix
	real scalar clen, cidx, suflen
	real scalar namelen, s1, s2, i
	
	res    = "" 
	prefix = "" 
	clen = ustrlen(newname)
	namelen = st_numscalar("c(namelenchar)")
	if(clen < 0 || clen > namelen) {
		/* should not happen */
		return("")
	}
	
	cidx = _st_varindex(newname)
	if(cidx >= .) {
		return(newname) 
	}	

	s1 = s2 = 0 
	for(suflen=1; suflen<=5; suflen++) {
		prefix = usubstr(newname, 1, 32-suflen)
		s1  = 10^(suflen-1)
		if(s1==1) {
			s1 = 0
		}
		s2    = 10^(suflen)
		for(i=s1; i<s2; i++) {
			res = prefix+sprintf("%g",i) 
			cidx = _st_varindex(res)
			if(cidx >= .) {
				return(res) 
			}	
		}
	}
	return("") 
}

void _unicode_fixvar() 
{
	real scalar kvar, i
	string scalar name, newname, cmd
	real scalar cnt, rc
	
	kvar = st_nvar()
	for(i=1; i<=kvar; i++) {
		name = st_varname(i) 
		cnt = ustrinvalidcnt(name) 
		if(cnt < 0) {
			/* error happened, exit */ 
			_unicode_fixvar_error(name)
			exit(198)
		}
		
		if(cnt > 0) {
			/* name contains invalid UTF-8 sequence, fix */
			newname = ustrfix(name, "_") 
			if(newname == "") {
				_unicode_fixvar_error(name)
				exit(198)
			}
			
			/* make sure newname does not start with two 
			   underscores */
			newname = _unicode_fixvar_underscore(newname, name)

			/* make newname unique */
			newname = _unicode_fixvar_unique(newname) 
			if(newname == "") {
				_unicode_fixvar_error(name)
				exit(198)			
			}
			cmd  = sprintf("_rename %s %s", name, newname)  
			if (rc=_stata(cmd)) {
				exit(rc)
			}
		}
	}
}	
end
/*---------------------------------------------------------------------------*/

program Ulocale
	version 14
	local version : di "version " string(_caller()) ":"

	gettoken subcmd 0 : 0, parse(", ")

	local len = strlen(`"`subcmd'"') 

	if `"`subcmd'"' == "list" {
		`version' Ulocale_list `0'
	}
	else {
		di as error `"subcommand {bf:"`subcmd'"} unknown"'
		exit 198
	}	
end

program Uuipackage
	version 14
	local version : di "version " string(_caller()) ":"

	gettoken subcmd 0 : 0, parse(", ")

	local len = strlen(`"`subcmd'"') 

	if `"`subcmd'"' == "list" {
		`version' Uuipackage_list `0'
	}
	else {
		di as error `"subcommand {bf:"`subcmd'"} unknown"'
		exit 198
	}	
end

program Uencoding
	version 14
	local version : di "version " string(_caller()) ":"

	gettoken subcmd 0 : 0, parse(", ")

	local len = strlen(`"`subcmd'"') 

	if `"`subcmd'"' == "list" {
		`version' Uencoding_list `0'
	}
	else if `"`subcmd'"' == "alias" {
		`version' Uencoding_alias `0'
	}
	else {
		di as error `"subcommand {bf:"`subcmd'"} unknown"'
		exit 198
	}	
end

program Ucollator
	version 14
	local version : di "version " string(_caller()) ":"

	gettoken subcmd 0 : 0, parse(", ")

	local len = strlen(`"`subcmd'"') 

	if `"`subcmd'"' == "list" {
		`version' Ucollator_list `0'
	}
	else {
		di as error `"subcommand {bf:"`subcmd'"} unknown"'
		exit 198
	}	
end

program Ulocale_list
	version 14
	local version : di "version " string(_caller()) ":"

	if `"`0'"' == "_all" | `"`0'"' == "" | `"`0'"' == "*" {
		cap noi mata: uloc_display("", 0)
		local rc = _rc
		if (`rc') {
			if (`rc' != 1) {
				di as error "{cmd:unicode locale list} failed"
				exit 198	
			}
			else {
				exit `rc'
			}
		}
	}
	else {
		if bsubstr(`"`0'"',1,1) == "*" & bsubstr(`"`0'"',-1,1) == "*" {
			/* contain */
			cap noi mata: uloc_display(bsubstr(`"`0'"', 2, bstrlen(`"`0'"')-2), 1)
			local rc = _rc
			if (`rc') {
				if (`rc' != 1) {
				  di as error "{cmd:unicode locale list} failed"
				  exit 198	
				}
				else {
				  exit `rc'
				}
			}
		}
		else  if bsubstr(`"`0'"',1,1) == "*" {
			/* end with */		
			cap noi mata: uloc_display(bsubstr(`"`0'"', 2, bstrlen(`"`0'"')-1), 2)
			local rc = _rc
			if (`rc') {
				if (`rc' != 1) {
				  di as error "{cmd:unicode locale list} failed"
				  exit 198	
				}
				else {
				  exit `rc'
				}
			}
		}
		else if bsubstr(`"`0'"',-1,1) == "*" {
			/* start with */
			cap noi mata: uloc_display(bsubstr(`"`0'"', 1, bstrlen(`"`0'"')-1), 3)
			local rc = _rc
			if (`rc') {
				if (`rc' != 1) {
				  di as error "{cmd:unicode locale list} failed"
				  exit 198	
				}
				else {
				  exit `rc'
				}
			}
		}
		else {
			di as error `"invalid pattern {bf:"`0'"}"'
			di as error "{p 4 4 2}"
			di as error "{bf:unicode} {bf:locale} {bf:list}"
			di as error "requires that you specify a {it:pattern}"
			di as error "which is one of"
			di as error "{bf:_all}, {bf:*},"
			di as error "{bf:*}{it:name}{bf:*},"
			di as error "{bf:*}{it:name}, or"
			di as error "{it:name}{bf:*}."
			di as error "{p_end}"
			exit 199
		}	
	}
end

program Uuipackage_list
	version 14
	local version : di "version " string(_caller()) ":"

	if strtrim(`"`0'"') != "" {
		di as error `"argument {bf:"`0'"} not allowed"'
		exit 198	
	}
	else {
		cap noi mata: uui_display()
		local rc = _rc
		if (`rc') {
			if (`rc' != 1) {
				di as err "{cmd:unicode uipackage list} failed"
				exit 198	
			}
			else {
				exit `rc'
			}
		}
	}
end

program Uencoding_list
	version 14
	local version : di "version " string(_caller()) ":"


	if `"`0'"' == "_all" | `"`0'"' == "" | `"`0'"' == "*" {
		cap noi mata: uencoding_display("", 0)
		local rc = _rc
		if (`rc') {
			if (`rc' == 111) {
				exit `rc'
			}
			else if (`rc' == 1) {
				exit `rc'
			}
			else {
				di as error "{cmd:unicode encoding list} failed"
				exit 198	
			}
		}
	}
	else {
		if bsubstr(`"`0'"',1,1) == "*" & bsubstr(`"`0'"',-1,1) == "*" {
			cap noi mata: uencoding_display(bsubstr(`"`0'"', 2, bstrlen(`"`0'"')-2), 1)
			local rc = _rc
			if (`rc') {
				if (`rc' == 111) {
				  exit `rc'
				}
				else if (`rc' == 1) {
				  exit `rc'
				}
				else {
				  di as err "{cmd:unicode encoding list} failed"
				  exit 198	
				}
			}
		}
		else  if bsubstr(`"`0'"',1,1) == "*" {
			cap noi mata: uencoding_display(bsubstr(`"`0'"', 2, bstrlen(`"`0'"')-1), 2)
			local rc = _rc
			if (`rc') {
				if (`rc' == 111) {
				  exit `rc'
				}
				else if (`rc' == 1) {
				  exit `rc'
				}
				else {
				  di as err "{cmd:unicode encoding list} failed"
				  exit 198	
				}
			}
		}
		else if bsubstr(`"`0'"',-1,1) == "*" {
			cap noi mata: uencoding_display(bsubstr(`"`0'"', 1, bstrlen(`"`0'"')-1), 3)
			local rc = _rc
			if (`rc') {
				if (`rc' == 111) {
				  exit `rc'
				}
				else if (`rc' == 1) {
				  exit `rc'
				}
				else {
				  di as err "{cmd:unicode encoding list} failed"
				  exit 198	
				}
			}
		}
		else {
			cap noi mata: uencoding_display(`"`0'"', 4)
			local rc = _rc
			if (`rc') {
				if (`rc' == 111) {
				  exit `rc'
				}
				else if (`rc' == 1) {
				  exit `rc'
				}
				else {
				  di as err "{cmd:unicode encoding list} failed"
				  exit 198	
				}
			}
		}
	}	
end

program Uencoding_alias
	version 14
	local version : di "version " string(_caller()) ":"

	cap noi mata: uencoding_aliases_display(`"`0'"')
	local rc = _rc
	if (`rc') {
		if (`rc' != 1) {
			di as error `"{bf:unicode encoding alias} failed"'
			exit 198	
		}
		else {
			exit `rc'
		}
	}
end

program Ucollator_list
	version 14
	local version : di "version " string(_caller()) ":"

	if `"`0'"' == "_all" | `"`0'"' == "" | `"`0'"' == "*"{
		cap noi mata: ucoll_display("", 0)
		local rc = _rc
		if (`rc') {
			if (`rc' != 1) {
				di as error "{bf:unicode collator list} failed"
				exit 198	
			}
			else {
				exit `rc'
			}
		}
	}
	else {
		if bsubstr(`"`0'"',1,1) == "*" & bsubstr(`"`0'"',-1,1) == "*" {
			cap noi mata: ucoll_display(bsubstr(`"`0'"', 2, bstrlen(`"`0'"')-2), 1)
			local rc = _rc
			if (`rc') {
				if (`rc' != 1) {
				  di as err "{bf:unicode collator list} failed"
				  exit 198	
				}
				else {
				  exit `rc'
				}
			}
		}
		else  if bsubstr(`"`0'"',1,1) == "*" {
			cap noi mata: ucoll_display(bsubstr(`"`0'"', 2, bstrlen(`"`0'"')-1), 2)
			local rc = _rc
			if (`rc') {
				if (`rc' != 1) {
				  di as err "{bf:unicode collator list} failed"
				  exit 198	
				}
				else {
				  exit `rc'
				}
			}
		}
		else if bsubstr(`"`0'"',-1,1) == "*" {
			cap noi mata: ucoll_display(bsubstr(`"`0'"', 1, bstrlen(`"`0'"')-1), 3)
			local rc = _rc
			if (`rc') {
				if (`rc' != 1) {
				  di as err "{bf:unicode collator list} failed"
				  exit 198	
				}
				else {
				  exit `rc'
				}
			}
		}
		else {
			di as error `"invalid pattern {bf:"`0'"}"'
			di as error "{p 4 4 2}"
			di as error "{bf:unicode} {bf:collator} {bf:list}"
			di as error "requires that you specify a {it:pattern}"
			di as error "which is one of"
			di as error "{bf:_all}, {bf:*},"
			di as error "{bf:*}{it:name}{bf:*},"
			di as error "{bf:*}{it:name}, or"
			di as error "{it:name}{bf:*}."
			di as error "{p_end}"
			exit 199
		}
	}	
end

mata:
/*
	mode :  	
		1       contain match
		2       end match
		3	start match
		4       exact match 
	otherwise	all
*/
string matrix string_filter(string matrix s, real scalar col, string scalar tomatch, real scalar mode)
{
	string matrix res
	real scalar r, c, i, j, pos
	string scalar match
	
	r = rows(s) 
	c = cols(s) 
		
	if(r<=0 || c <= 0) {
		return(J(0, 0, ""))
	}
	
	if(c < col) {
		return(J(0, 0, ""))	
	}
	
	match = strlower(tomatch)
	if((mode != 1 && mode != 2 && mode != 3 && mode != 4 ) || strlen(match) == 0) {
		return(s) ;
	}
	
	res = J(0, c, "") 
	for(i=1; i<=r; i++) {
		for(j=1; j<=col; j++) {
			if(mode == 1) {
				if(strpos(strlower(s[i, j]), match)>0) {
					res = (res\s[i, .]) 
					j = col+1 
				}
			}
		
			if(mode == 2) {
				pos = strrpos(strlower(s[i, j]), match)
				if((pos > 0) && (pos == (strlen(s[i, j])-strlen(match)+1))) {
					res = (res\s[i, .]) 
					j = col+1
				}			
			}
		
			if(mode == 3) {
				if(strpos(strlower(s[i, j]), match) == 1) {
					res = (res\s[i, .]) 
					j = col+1
				}		
			}
			
			if(mode == 4) {
				if(strlower(s[i,j]) == match) {
					res = (res\s[i, .]) 
					j = col+1
				}				
			}
		}
	}
	return(res) 
}

/*
	mode :  	
		1       contain match
		2       end match
		3	start match
	otherwise	all
*/
void uloc_display(string scalar match, real scalar mode)
{
	string matrix locs  
	real scalar r, c, i

	locs = getlocale(1) 
	r = rows(locs) 
	c = cols(locs) 

	
	if(r==0 || c != 3) {
		printf("{p 0 6 2}\n")
		printf("{txt}note: no locale found {p_end}\n")
		return 
	}


	/*----------------------------- match ------------------------------*/	
	if((mode == 1 || mode == 2 || mode == 3) && strlen(match) > 0) {
		locs = string_filter(locs, 1, match, mode)
	}	

	r = rows(locs) 
	c = cols(locs) 
	
	if(r == 0 || c != 3) {
		printf("{p 0 6 2}\n")
		printf("{txt}note: no matching locale found {p_end}\n")
		return 
	}

	/*----------------------------- header ------------------------------*/
	printf("\n") 
	printf("{txt}%4s", "#") 
	printf("%12s", "Locale") 
	printf("%30s", "Language") 
	printf("%32s", "Country") 
	printf("\n") 
	printf("{hline 79}\n") 

	/*----------------------------- table ------------------------------*/
	for(i=1; i<=r; i++) {
		printf("%4s", strofreal(i)) 
		printf("%12s", locs[i,1]) 
		printf("%30s", locs[i,2]) 
		printf("%32s", locs[i,3]) 
		printf("\n")
	} 
	printf("{hline 79}\n") 
	return 
}	

void uui_display()
{
	string matrix locs  
	real scalar r, c, i

	locs = getlangpackage() 
	r = rows(locs) 
	c = cols(locs) 

	
	if(r==0 || c != 3) {
		printf("{p 0 6 2}\n")
		printf("{txt}note: no UI package found {p_end}\n")
		return 
	}

	/*----------------------------- header ------------------------------*/
	printf("\n") 
	printf("{txt}%4s", "#") 
	printf("%12s", "Locale") 
	printf("%30s", "Language") 
	printf("%32s", "Country") 
	printf("\n") 
	printf("{hline 79}\n") 

	/*----------------------------- table ------------------------------*/
	for(i=1; i<=r; i++) {
		printf("%4s", strofreal(i)) 
		printf("%12s", locs[i,1]) 
		printf("%30s", locs[i,2]) 
		printf("%32s", locs[i,3]) 
		printf("\n")
	} 
	printf("{hline 79}\n") 
	return 
}	

string matrix get_encodings()
{
        string matrix enc, enc_a, encs
        real scalar r, i, r1, j
        encs = J(0, 2, "")
        enc = getconverter()

        r   = rows(enc)
        for(i=1; i<=r; i++) {
                enc_a = getaliases(enc[i])
                r1 = rows(enc_a)
                if(r1==0) {
                        encs = (encs\(enc[i], ""))
                }
                for(j=1; j<=r1; j++) {
                        encs = (encs\(enc[i], enc_a[j]))
                }
        }
        return(encs)
}


/*
	mode :  	
		1       alias
	otherwise	all
*/
void uencoding_display(string scalar match, real scalar mode)
{
	string matrix locs  
	real scalar r, c, i, grcnt
	string scalar gr
	
	locs = get_encodings() 
	r = rows(locs) 
	c = cols(locs) 

	if(r==0 || c != 2) {
		printf("{p 0 6 2}\n")
		printf("{txt}note: no encoding found {p_end}\n")
		return 
	}

	/*----------------------------- match ------------------------------*/	
	if((mode == 1 || mode == 2 || mode == 3 || mode == 4) && strlen(match) > 0) {
		locs = string_filter(locs, 2, match, mode)
	}	

	r = rows(locs) 
	c = cols(locs) 
	
	if(r==0 || c != 2) {
		if(mode == 4) {
			errprintf("encoding {bf:%s} not found\n", match)
		}
		else {
			errprintf("encoding matching {bf:%s} not found\n", match)		
		}
		exit(111)
		return 
	}

	/*----------------------------- header ------------------------------*/
	printf("\n") 
	printf("{txt}%4s", "#") 
	printf(" ") 	
	printf("%29s", "Encoding") 
	printf(" ") 
	printf("%44s", "Alias") 
	printf("\n") 
	printf("{hline 79}\n") 

	/*----------------------------- table ------------------------------*/
	gr    = "" 
	grcnt = 1 
	for(i=1; i<=r; i++) {
		if(locs[i, 1] != gr ) {
			/* new group */
			printf("%4s", strofreal(grcnt)) 
			printf(" ") 	
			printf("%29s", locs[i,1]) 
			gr = locs[i, 1]
			grcnt++
		}
		else {
			printf("%4s", "") 
			printf(" ") 	
			printf("%29s", "") 			
		}
		printf(" ")
		printf("%44s", locs[i,2]) 
		printf("\n")
	} 
	printf("{hline 79}\n") 
	return 
}	

void uencoding_aliases_display(string scalar sconv)
{
	string matrix locs  
	real scalar r, c, i
	
	locs = getaliases(sconv) 
	r = rows(locs) 
	c = cols(locs) 

	if(r<=0 || c!=1) {
		printf("{p 0 6 2}\n")
		printf("{txt}note: no alias of encoding {bf:%s} found{p_end}\n", sconv)
		return 
	}

	if(r==1 && c==1) {
		if(locs[1] == "") {
			printf("{p 0 6 2}\n")
			printf("{txt}note: no alias of encoding {bf:%s} found{p_end}\n", sconv)
			return 
		}		
	}
	
	/*----------------------------- header ------------------------------*/
	printf("\n") 
	printf("{txt}%5s", "#") 
	printf("  Aliases of %s", sconv) 
	printf("\n") 
	printf("{hline 79}\n") 

	/*----------------------------- table ------------------------------*/
	for(i=1; i<=r; i++) {
		printf("%5s", strofreal(i)) 
   	        printf("  ")
		printf("%-60s", locs[i,1]) 
		printf("\n")
	} 
	printf("{hline 79}\n") 
	return 
}	

/*
	mode :  	
		1       contain match
		2	start match
		3       end match
	otherwise	all
*/
void ucoll_display(string scalar match, real scalar mode)
{
	string matrix locs  
	real scalar r, c, i
	
	locs = icu_col_locale() 
	r = rows(locs) 
	c = cols(locs) 
	
	if(r==0 || c != 3) {
		printf("{p 0 6 2}\n")
		printf("{txt}note: no locale for collation service found {p_end}\n")
		return 
	}

	/*----------------------------- match ------------------------------*/	
	if((mode == 1 || mode == 2 || mode == 3) && strlen(match) > 0) {
		locs = string_filter(locs, 1, match, mode)
	}	

	r = rows(locs) 
	c = cols(locs) 
	
	if(r==0 || c != 3) {
		printf("{p 0 6 2}\n")
		printf("{txt}note: no matching locale for collation service found {p_end}\n")
		return 
	}

	/*----------------------------- header ------------------------------*/
	printf("\n") 
	printf("{txt}%4s", "#") 
	printf("%12s", "Locale") 
	printf("%30s", "Language") 
	printf("%32s", "Country") 
	printf("\n") 
	printf("{hline 79}\n") 

	/*----------------------------- table ------------------------------*/
	for(i=1; i<=r; i++) {
		printf("%4s", strofreal(i)) 
		printf("%12s", locs[i,1]) 
		printf("%30s", locs[i,2]) 
		printf("%32s", locs[i,3]) 
		printf("\n")
	} 
	printf("{hline 79}\n") 
	return 
}	
end

exit
