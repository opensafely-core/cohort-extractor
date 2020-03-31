*! version 2.0.14  17dec2018
program notes
	version 10

	if (`"`0'"' == "") {
		notelist 
		exit
	}

	gettoken one rest : 0, parse(" :")
	if (`"`one'"' == bsubstr("list", 1, max(1,strlen(`"`one'"')))) {
		notelist `rest'
		exit
	}
	
	
	local vv : display "version " string(_caller()) ", missing:"
	._NOTES_VV = `"`vv'"'

	if (`"`one'"' == "drop") { 
		notedrop `rest'
		_cls free ._NOTES_VV
		exit
	}
	if (`"`one'"' == "search") { 
		notesearch `rest'
		_cls free ._NOTES_VV
		exit
	}
	if (`"`one'"' == "replace") { 
		notereplace `rest'
		_cls free ._NOTES_VV
		exit
	}
	if (`"`one'"'==":") {
		noteadd _dta: `rest'
		_cls free ._NOTES_VV
		exit
	}
	if (`"`one'"' == "renumber") { 
		noterenumber `rest'
		_cls free ._NOTES_VV
		exit
	}
	if (`"`one'"'=="_count") {
		note_count `rest'
		`toxeq'
		_cls free ._NOTES_VV
		exit
	}
	if (`"`one'"'=="_fetch") {
		note_fetch `rest'
		`toxeq'
		_cls free ._NOTES_VV
		exit
	}
	if (`"`one'"'=="_dir") {
		note_dir `rest'
		`toxeq'
		_cls free ._NOTES_VV
		exit
	}

	gettoken two rest : rest, parse(" :")
	if (`"`two'"' == ":") {
		noteadd `one' : `rest'
		_cls free ._NOTES_VV
		exit
	}
	notelist `0'
	_cls free ._NOTES_VV
end


program noteadd /* <name> : ... */
	gettoken name 0 : 0, parse(" :")
	if (`"`name'"' != "_dta") { 
		getvarname name : `name'
	}

	gettoken colon 0 : 0, parse(" :")
	if (`"`colon'"' != ":") { 
		error 198
	}
	mata: trimmacro("0")
	if (`"`0'"' == "") { 
		di as txt "  (no note added)"
		exit
	}
	local n : char `name'[note0]
	cap confirm integer number `n'
	if _rc { 
		local n 1
	}
	else {
		if (`n'>=9999) { 
			di as err "too many notes"
			exit 103
		}
		local ++n
	}

	local ts = bsubstr("$S_DATE $S_TIME", 1, 17)
	local text : subinstr local 0 "TS" "`ts'", all word

	nobreak { 
		`._NOTES_VV' char `name'[note0] `n'
		`._NOTES_VV' char `name'[note`n'] `"`text'"'
	}
end

program notelist /* [evarlist] [in ...] */
	parsenotesyntax haslist hasin list in1 in2 : `"`0'"'
	foreach name of local list {
		notelist_u `name' `in1' `in2'
	}
end

program notesearch 
	tokenize `"`0'"'
	local sometext `"`1'"'
	local sometext2 `"`2'"'
	
	if ("`sometext'"=="") {
		di as err "something required"
		exit 100
	}
	if ("`sometext2'"!="") {
		di as err "invalid syntax"
		exit 198
	} 	

	local found 0
	local n :char _dta[note0]

	if ("`n'" !="") {
		notesearch_u "_dta" `n' `sometext' 
		if (r(found)==1) {
			local found 1
		}
	}

	foreach var of varlist _all { 
		local n : char `var'[note0]
		if `"`n'"' != "" {
			notesearch_u `var' `n' `sometext' 
			if (r(found)==1) {
				local found 1
			}
		}
	}
	if ("`found'"=="0") {
                di as text "`sometext': not found"
        }

end

program notedrop
	parsenotesyntax haslist hasin list in1 in2 : `"`0'"'
/*
	di as txt `"haslist `haslist'"'
	di as txt `"hasin   `hasin'"'
	di as txt `"list   |`list'|"'
	di as txt `"in1     `in1'"'
	di as txt `"in2     `in2'"'
*/

	if (`haslist'==0) { 
		error 198
	}

	local N 0
	foreach name of local list {
		notedrop_u n : `name' `in1' `in2'
		local N = `N' + `n'
	}
	local note = cond(`N'==1, "note", "notes")
	di as txt "  (`N' `note' dropped)"
end

program noterenumber /* name|_dta */
	/* ------------------------------------------------------------ */
						/* parse		*/
	gettoken evarname rest : 0 
	if ("`evarname'"=="") {
		di as smcl as err ///
		"nothing found where {it:varname} or {bf:_dta} expected"
		exit 198
	}
	if ("`rest'"!="") {
		local rest = strtrim("`rest'")
		di as smcl as err "{bf:`rest'} found where nothing expected"
		exit 198
	}
	if ("`evarname'"=="_dta") { 
		local varlist "_dta"
	}
	else {
		capture syntax varname
		if (_rc) { 
			di as smcl as err ///
		"{bf:`evarname'} found where {it:varname} or {bf:_dta} expected"
			exit 111
		}
	}

	local n `"``varlist'[note0]'"'
	if ("`n'"=="") {
		exit
	}
	confirm integer number `n'
	if (`n'<=0) {
		exit
	}
		
						/* parse		*/
	/* ------------------------------------------------------------ */
	nobreak {
		`._NOTES_VV' mata: renumber("`varlist'", `n')
	}
end



program notereplace /* evarname in # : */
	gettoken evarname rest : 0 
	gettoken in rest : rest
	gettoken num rest : rest, parse(" :")
	gettoken colon text : rest, parse(":")
/*
	di as txt `"evarname `evarname'"'
	di as txt `"in     `in'"'
	di as txt `"num    `num'"'
	di as txt `"colon  `colon'"'
	di as txt `"text   `text'"'
*/

	if (`"`evarname'"'=="") {
		error 198
	}
	if (`"`in'"'!="in") {
		error 198
	}

	if (`"`num'"'=="") {
		error 198
	}
	cap confirm integer number `num'
	if _rc {
		exit 198
	}

	if (`"`colon'"'!=":") {
		error 198
	}

	if (`"`evarname'"' != "_dta") {
		cap noi confirm variable `evarname'
		if _rc {
			exit 198
		}	
	}

	mata: trimmacro("text")
        if (`"`text'"' == "") {
		di as txt "  (no note replaced)"
		exit
	}
	local is_note : char `evarname'[note`num']

	if (`"`is_note'"' == "") {
		di as txt "  (no note replaced)"
		exit
        }

	local ts = bsubstr("$S_DATE $S_TIME", 1, 17)
	local text : subinstr local text "TS" "`ts'", all word
	nobreak {
		`._NOTES_VV' char `evarname'[note`num'] `"`text'"'
	}

	di as txt "  (note `num' for `evarname' replaced)"
end

program parsenotesyntax
	args haslist hasin list in1 in2 colon rest

	mata: splitstring("rawlist", "rawin", "rest")
	if "`rawlist'" == "" { 
		c_local `haslist' 0
		local 0 _all
		syntax varlist 
		c_local `list' _dta `varlist'
	}
	else {
		c_local `haslist' 1
		local _dta "_dta"
		local has_dta : list _dta in rawlist
		if (`has_dta') {
			local rawlist : list rawlist - _dta
		}
		local 0 `rawlist'
		nobreak {
			if (`has_dta' == 1 & `"`rawlist'"' == "") {
				local rc = 0
			}
			else {
				cap noi syntax varlist
				local rc = _rc
			}
		}
		if (`rc') { 
			exit `rc'
		}
		if (`has_dta' == 1 | `"`rawlist'"' == "_all") {
			mata:add_dta("varlist")
		}
		c_local `list' `varlist'
	}

	if (`"`rawin'"'=="") {
		c_local `hasin' 0
		c_local `in1' 1
		c_local `in2' 9999
		exit
	}

	c_local `hasin' 1 
	gettoken el rest : rawin, parse(" /")
	isvalidel r1 : `"`el'"'
	gettoken el rest : rest, parse(" /") 
	if (`"`el'"'=="") { 
		c_local `in1' `r1'
		c_local `in2' `r1'
		exit
	}
	if (`"`el'"'=="/") { 
		gettoken el rest : rest, parse(" /")
		isvalidel r2 : `"`el'"'
		if (`r1'<=`r2') {
			gettoken el rest : rest, parse(" /")
			if "`el'"=="" { 
				c_local `in1' `r1'
				c_local `in2' `r2'
				exit
			}
		}
	}
	di as err `"in `rawin':  invalid"'
	exit 198
end

program getvarname
	gettoken dest 0  : 0, parse(" :")
	gettoken colon 0 : 0, parse(" :")
	if (`"`colon'"' != ":") { 
		error 198
	}
	syntax varname
	c_local `dest' `varlist'
end

program notedrop_u
	args n colon name in1 in2
	
        /* di as txt "name=|`name'| in1=`in1' in2=`in2'" */
	firstlastnote i1 i2 : `name' `in1' `in2'
	/* di as txt "name=|`name'| i1=`i1' i2=`i2'" */

	if (`i1' < 0) {
		c_local n 0 
		exit
	}


	local dropped 0
	forvalues i=`i1'/`i2' { 
		local thenote : char `name'[note`i']
		if (`"`thenote'"' != "") {
			`._NOTES_VV' char `name'[note`i']
			local ++dropped
		}
	}
	c_local `n' `dropped'

	actuallastnote N : `name'
	if (`N') {
		`._NOTES_VV' char `name'[note0] `N'
	}
	else { 
		`._NOTES_VV' char `name'[note0]
	}
end

program isvalidel
	args res colon el 
	if (`"`el'"' == "f" | `"`el'"'=="F") { 
		c_local `res' 1
		exit
	}
	if (`"`el'"' == "l" | `"`el'"'=="L") { 
		c_local `res' 10000
		exit
	}
	cap confirm integer number `el'
	if _rc==0 { 
		if (`el'>=1 & `el'<=9999) { 
			c_local `res' `el'
			exit
		}
	}
	di as err `"`el':  invalid range element"'
	exit 198
end

program notelist_u
	args name i1 i2

	local n : char `name'[note0]
	cap confirm number `n'
	if _rc { 
		exit
	}

	local n = min(`n', `i2')
	if (`i1'>`n') { 
		exit
	}
	local j -1
	forvalues i=`i1'/`n' { 
		local thenote : char `name'[note`i']
		if (`"`thenote'"' != "") {
			local j `i'
			continue, break
		}
	}
	if (`j'==-1) { 
		exit
	}

	di as txt
	di as res "`name':"
	forvalues i=`j'/`n' {
		local thenote : char `name'[note`i']
		if (`"`thenote'"' != "") {
			local k = strlen("`i'")
			local p0 = max(3-`k', 0)
			local p1 = cond(`k'>3, 7, 6)
			di as txt "{p `p0' `p1'}"
			di as txt "`i'."
			di as txt `"`thenote'"'
			di as txt "{p_end}"
		}
	}
end

program notesearch_u, rclass
	args var n sometext
	local v ""
	forvalues i=1/`n' {
		local thenote : char `var'[note`i']
               	mata: findnote(`"`thenote'"', `"`sometext'"')
		if (r(found)) {
			if (!strmatch ("`var'", "`v'")) {
				di as txt
				di as res "`var':"
			}
			local k = strlen("`i'")
			local p0 = max(3-`k', 0)
			local p1 = cond(`k'>3, 7, 6)
			di as txt "{p `p0' `p1'}"
			di as txt "`i'."
			di as txt `"`thenote'"'
			di as txt "{p_end}"	
			local v `var'
		}	
	}
	if ("`v'"!="") {
		return scalar found = 1
	}
end

program firstlastnote 
	args first last colon name i1 i2

	local n : char `name'[note0]
	if ("`n'"=="") { 
		c_local `first' -1
		c_local `last'   0
		exit
	}

	local n = min(`i2', `n')
	c_local `last' `n'
	if (`i1'==10000) {
		local i1 `n'
	}

	local j -1
	forvalues i=`i1'/`n' {
		local thenote : char `name'[note`i']
		if (`"`thenote'"' != "") {
			local j `i'
			continue, break 
		}
	}
	c_local `first' `j'
end

program actuallastnote
	args last colon name

	local n : char `name'[note0]
	if "`n'"=="" {
		c_local `last' 0
		exit 
	}
	local j 0
	forvalues i = `n'(-1)1 { 
		local thenote : char `name'[note`i']
		if (`"`thenote'"' != "") {
			local j `i'
			continue, break
		}
	}
	c_local `last' `j'
end

program note_count
	args dest colon name

	local n : char `name'[note0]
	if ("`n'"=="") {
		local n 0
	}
	c_local toxeq `"c_local `dest' `n'"'
end

program note_fetch
	args dest colon name number

	c_local toxeq `"c_local `dest' `"``name'[note`number']'"'"'
end

program note_dir
	args dest
	mata: note_dir("res")
	c_local toxeq `"c_local `dest' `"`res'"'"'
end
	


version 10
local SS	string scalar
local RS	real scalar
mata:

void note_dir(`SS' macname)
{
	`RS' 			i, nvar
	`RS'			hasdta
	`SS'			name, toret
	string colvector 	res

	hasdta = note_dir_u("_dta")
	nvar = st_nvar()
	res = J(0, 1, "")
	for (i=1; i<=nvar; i++) { 
		if (note_dir_u(name=st_varname(i))) res = res \ name
	}
	toret = (length(res) ? invtokens(sort(res, 1)') : "")
	if (hasdta) toret = "_dta " + toret
	st_local(macname, toret)
}

`RS' note_dir_u(`SS' name)
{
	`SS' 	cnts
	
	if ((cnts = st_global(name+"[note0]"))=="") return(0)
	return(cnts!="0")
}
		

void splitstring(`SS' lname, `SS' rname, `SS' strname)
{
	`SS' 	str
	`RS'	p

	str = " " + strtrim(st_local(strname)) + " "
	if (p   = strpos(str, " in ")) { 
		st_local(lname, strtrim(bsubstr(str, 1, p-1)))
		st_local(rname, strtrim(bsubstr(str, p+4, .)))
	}
	else {
		st_local(lname, strtrim(str))
		st_local(rname, "")
	}
}

void trimmacro(`SS' mname)
{
	st_local(mname, strtrim(st_local(mname)))
}

void findnote(`SS' nstr, `SS' p)
{
	st_numscalar("r(found)", strpos(nstr, p))
}

void add_dta(`SS' mname)
{
	st_local(mname, (st_local(mname) + " _dta "))
}

void renumber(string scalar name, real scalar n)
{
	real scalar	i, j
	string scalar	fn
	string vector 	notes

	notes = J(n, 1, "")
	j = 1 
	for (i=1; i<=n; i++) { 
		notes[j] = st_global(fn = sprintf("%s[note%g]", name, i))
		if (notes[j]!="") ++j
		st_global(fn, "")
	}
	st_global(sprintf("%s[note0]", name), strofreal(--j))
	for (i=1; i<=j; i++) {
		st_global(sprintf("%s[note%g]", name, i), notes[i])
	}
}

end
