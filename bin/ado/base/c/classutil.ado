*! version 1.0.9  13feb2015  
program classutil /* rclass via inheritance */
	version 8
	gettoken cmd 0 : 0, parse(" ,")
	local l = length("`cmd'")
	if `l'==0 { 
		error 198
	}

	if "`cmd'"=="drop" {
		Drop `0'
	}
	else if "`cmd'" == bsubstr("describe", 1, `l') {
		Describe `0'
	}
	else if "`cmd'"=="dir" {
		Dir `0'
	}
	else if "`cmd'"=="cdir" {
		Cdir `0'
	}
	else if "`cmd'"=="which" {
		Which `0'
	}
	else	error 198
end

program Drop, rclass

	if (`"`0'"' == "_all") {			// class drop _all
		_cls free _all
		exit
	}

	foreach ins of local 0 {
		GetObjectName `ins'
		local name "`r(name)'"
		local isa "`r(isa)'"
		Found    "`name'" "`isa'"
		NotClass "`name'" "`isa'" "cannot drop class definitions"
		TopLevel "`name'"         "can only drop top-level objects"
		if index("`name'","[") {
			di as err "`name':  cannot drop array elements"
			exit 459
		}
	}
	foreach ins of local 0 {
		GetObjectName `ins'
		_cls free `r(name)'
	}
end

program Describe, rclass
	syntax anything(name=name id="object name") [, Newok Recurse]
	GetObjectName `name'
	local name `r(name)'
	local isa  `r(isa)'

	if "`isa'"=="" {
		TopLevel "`name'"  "object not found"
		capture classutil which `name'
		if _rc { 
			NotFoundMsg "`name'" object
		}
		if "`newok'"=="" { 
			di as err "`name':  no instances of class found"
			di as txt "{p 4 4}"
			di "To describe a class, an instance of the class"
			di "must exist, if only temporarily."
			di "Either create an instance of the class or type"
			di `""{cmd:classutil describe `name', newok}""' 
			di "to indicate that {cmd:describe} can run"
			di "{cmd:.`name'.New}"
			di as txt "and then throw the resulting object away."
			di "{p_end}"
			exit 111
		}
		tempname phony
		capture .`phony' = .`name'.new
		if _rc { 
			NotFoundMsg "`name'" object
		}
		GetObjectName `name'
		local isa  `r(isa)'
		if "`isa'" != "classtype" {
			NotFoundMsg "`name'" object
		}
	}

	if "`isa'"=="classtype" {
		ret local type   "`name'"
		ret local bitype "class"
		DescribeClass `name', `new' `recurse'
		exit
	}
	if "`isa'"=="class" { 
		ret local type   `.`name'.classname'
		ret local bitype "instance"
		DescribeClassInstance `name', `recurse'
		exit
	}

	ret local type   "`isa'"
	ret local bitype "`isa'"
	DisplayObjectLine 0 `name' `name'
end



program DisplayObjectLine 
	args indent name dname
	local i `indent'
	local isa = "`.`name'.isa'"

	local col "_column(`=`indent'+1')"

	if "`isa'"=="classtype" {
		di as txt `col' "class {col `=`i'+14'} {res:`dname'}"
	}
	else if "`isa'"=="class" {
		local class `.`name'.classname'
		di as txt `col' "`class' {col `=`i'+14'}{res:.`dname'}"
	}
	else if "`isa'"=="array" {
		di as txt `col' ///
		"array {col `=`i'+14'}{res:.`dname'}{col `=`i'+14+17'}(.arrnels=`.`name'.arrnels')"
	}
	else if "`isa'"=="double" {
		di as txt `col' ///
		"double {col `=`i'+14'}{res:.`dname'}{col `=`i'+14+14'} = `.`name''"
	}
	else if "`isa'"=="string" { 
		local l2 = `indent'+14+16+1
		local sp = 14-length("`dname'")
		local sp = cond(`sp'<=0,1,`sp')
		di as txt "{p `indent' `l2'}"
		di "string{space 7}{res:.`dname'}{space `sp'}="
		di `""`.`name''""'
		di "{p_end}"
	}
	else {
		di as err `"unknown object type "`isa'""'
		exit 9384
	}
end



program DescribeClassInstance
	syntax anything(name=name) [, Recurse]
	local class `.`name'.classname'
	local dv 0`.`name'.dynamic.nels'
	di as txt _n "`class' {res:.`name'}:"

	local nc = 0`.`name'.classmv.arrnels'
	local ni = 0`.`name'.instancemv.arrnels'
	local nd = 0`.`name'.dynamicmv.arrnels'

	if `nc' {
		di as txt _col(4) "classwide:"
		DescribeClassI_u `nc' `name' classmv ""
	}
	if `ni' {
		if `nc' {
			di as txt _col(4) "instancespecific:"
		}
		DescribeClassI_u `ni' `name' instancemv ""
	}
	if `nd' {
		di as txt _col(4) ".Declare:"
		DescribeClassI_u `nd' `name' dynamicmv ".Declare "
	}

	if "`recurse'"=="" {
		exit
	}
	forvalues i=1(1)`nc' {
		if "`.`name'.classmv[`i'].isa'" == "class" {
			_cls nameof .`name' classmv[`i']
			local sname = cond(bsubstr("`r(name)'",1,1)==".", ///
				bsubstr("`r(name)'",2,.), "`r(name)'")
			local sname  `name'.`sname'
			DescribeClassInstance `sname', `recurse'
		}
	}
	forvalues i=1(1)`ni' {
		if "`.`name'.instancemv[`i'].isa'" == "class" {
			_cls nameof .`name' instancemv[`i']
			local sname = cond(bsubstr("`r(name)'",1,1)==".", ///
				bsubstr("`r(name)'",2,.), "`r(name)'")
			local sname  `name'.`sname'
			DescribeClassInstance `sname', `recurse'
		}
	}
	forvalues i=1(1)`nd' {
		if "`.`name'.dynamicmv[`i'].isa'" == "class" {
			_cls nameof .`name' dynamicmv[`i']
			local sname = cond(bsubstr("`r(name)'",1,1)==".", ///
				bsubstr("`r(name)'",2,.), "`r(name)'")
			local sname  `name'.`sname'
			DescribeClassInstance `sname', `recurse'
		}
	}
end

program DescribeClassI_u 
	args n name array prefix

	forvalues i=1(1)`n' {
		_cls nameof .`name' `array'[`i']
		local el "`r(name)'"
		DisplayObjectLine 8 `name'.`el' `el'
	}
end


program DescribeClass
	syntax anything(name=name) [, New Recurse]
	di as txt _n "class " as res "`name'" as txt " {c -(}"

	local nc = 0`.`name'.classmv.arrnels'
	local ni = 0`.`name'.instancemv.arrnels'
	local nd = 0`.`name'.dynamicmv.arrnels'
	if `nc' {
		di as txt _col(4) "classwide:"
		DescribeClass_u `nc' `name' classmv ""
	}
	if `ni' {
		if `nc' {
			di as txt _col(4) "instancespecific:"
		}
		DescribeClass_u `ni' `name' instancemv ""
	}
	di as txt "{c )-}"
	if `nd' {
		DescribeClass_u `nd' `name' dynamicmv ".Declare "
	}

	capture .`name'.`name'		// force program reload if nesc.
	_cls pgmdir `name'
	if "`r(names)'" != "" {
		local pgms "`r(names)'"
		local pgms : list sort pgms
		di "Member programs:"
		DisplayInCols res 4 0 0 `pgms'
	}

	if "`recurse'"=="" {
		exit
	}

	local tolist 

	forvalues i=1(1)`nc' {
		if "`.`name'.classmv[`i'].isa'" == "class" {
			local u "`.name'.classmv[`i'].uname'"
			local pos : list posof "`u'" in tolist
			if `pos'==0 {
				local tolist "`tolist' `u'"
				local els "`el' classmv[`i']"
			}
		}
	}
	forvalues i=1(1)`ni' {
		if "`.`name'.instancemv[`i'].isa'" == "class" {
			local u "`.name'.instancemv[`i'].uname'"
			local pos : list posof "`u'" in tolist
			if `pos'==0 {
				local tolist "`tolist' `u'"
				local els "`el' instancemv[`i']"
			}
		}
	}
	forvalues i=1(1)`ni' {
		if "`.`name'.dynamicmv[`i'].isa'" == "class" {
			local u "`.name'.dynamicmv[`i'].uname'"
			local pos : list posof "`u'" in tolist
			if `pos'==0 {
				local tolist "`tolist' `u'"
				local els "`el' dynamicmv[`i']"
			}
		}
	}

	foreach el of local els {
		Describe `.`name'.`el'.classname', `recurse' `new' 
	}
end

program DescribeClass_u 
	args n name array prefix

	forvalues i=1(1)`n' {
		_cls nameof .`name' `array'[`i']
		local el "`r(name)'"

		local isa `"`.`name'.`array'[`i'].isa'"'
		if "`isa'"=="class" {
			local type "`.`name'.`array'[`i'].classname'"
		}
		else	local type "`isa'"
		di as txt _col(8) "`type' {col 22}{res:`el'}"
	}
end


program Dir, rclass
	gettoken pat 0 : 0, parse(" ,")
	if `"`pat'"'=="," {
		local 0 `",`0'"'
		local pat 
	}
	syntax [, ALL Detail]

	local noclass = cond("`all'"=="", "noclasstype", "")

	_cls toplevel, `noclass' dots
	if "`pat'"== "" {
		local list `"`r(list)'"'
	}
	else {
		local pat = cond(bsubstr("`pat'",1,1)==".", "`pat'", ".`pat'")
		local master `"`r(list)'"'
		foreach el of local master {
			if match("`el'", "`pat'") {
				local list `list' `el'
			}
		}
	}

	if "`all'"!="" {
		local master `"`list'"'
		local list
		foreach el of local master {
			if "``el'.isa'" == "classtype" {
				local el = usubstr("`el'",2,.)
			}
			local list `list' `el'
		}
	}
			

	local list : list sort list
	ret local list `"`list'"'
	if "`detail'"=="" {
		DisplayInCols txt 0 0 0 `return(list)'
		exit
	}
	foreach el in `return(list)' {
		local el = cond(bsubstr("`el'",1,1)==".", ///
				bsubstr("`el'",2,.), "`el'")
		DisplayObjectLine 0 `el' `el'
	}
end

program Which, rclass
	syntax anything(name=name id="class name") [, ALL]
	GetClassName `name'
	local name `"`r(name)'"'
	if "`c(adoarchive)'"=="1" {
		if "`all'" == "" {
			cap _stfilearchive find "`name'.class"
			if `r(arvpos)' >=0 {
				ret local fn `"`r(arvfn)'"'			
				di as txt  `"`r(arvfn)':`r(arvname)'"'
			
			}
			else {
				findfile "`name'.class"
				ret local fn `"`r(fn)'"'
			}
			type `"`return(fn)'"', starbang
			exit
		}
		
		qui findfile "`name'.class", all
		cap qui _stfilearchive confirm "`name'.class"
		ret local fn `"`r(fn)'"' `"`r(arvfn)'"'
		foreach fi in `return(fn)' {
			di as txt _n `"`fi'"'
			type `"`fi'"', starbang
		}
	}
	else {
		if "`all'" == "" {
			findfile "`name'.class"
			ret local fn `"`r(fn)'"'
			type `"`return(fn)'"', starbang
			exit
		}
		qui findfile "`name'.class", all
		ret local fn `"`r(fn)'"'
		foreach fi in `return(fn)' {
			di as txt _n `"`fi'"'
			type `"`fi'"', starbang
		}	
	}
end
	
	
program GetClassName, rclass
	args name nothing
	if `"`name'"'=="" {
		di as err "nothing found where class name expected"
		exit 198
	}
	if "`nothing'"!="" {
		error 198
	}
	if bsubstr(`"`name'"',1,1)=="." {
		local name = bsubstr("`name'",2,.)
		if index("`name'",".") {
			di as err `"`name':  invalid class name"'
			exit 198
		}
	}
	ret local name `"`name'"'
end


program GetObjectName, rclass
	args name nothing
	if `"`name'"'=="" {
		di as err "nothing found where object name expected"
		exit 198
	}
	if "`nothing'"!="" {
		error 198
	}
	if bsubstr(`"`name'"',1,1)=="." {
		gettoken period name : name, parse(" .")
		if "`name'"=="" {
			di as err `""." invalid object name"'
			exit 198
		}
	}
	ret local name `"`name'"'
	ret local isa `"`.`name'.isa'"'
end

program Found 
	args name isa
	if "`isa'"=="" {
		di as err "{p 0 4}"
		di as err `".`name':  object not found"'
		di as err "{p_end}"
		exit 111
	}
end

program TopLevel
	args name msg
	if index("`name'", ".") {
		di as err "{p 0 4}"
		di as err "`name':  `msg'"
		di as err "{p_end}"
		exit 459
	}
end

program NotClass 
	args name isa msg
	if "`isa'"=="classtype" {
		di as err "{p 0 4}"
		di as err "`name':  `msg'"
		di as err "{p_end}"
		exit 459
	}
end

program NotFoundMsg
	args name what
	di as err "{p 0 4}"
	di as err "`name':  `what' not found"
	di as err "{p_end}"
	exit 111
end


program Cdir, rclass
	args pattern nothing 
	if `"`nothing'"' != "" {
		error 198
	}

	if bsubstr("`pattern'",1,1)=="." {
		local pattern = bsubstr("`pattern'",2,.)
	}

	if "`pattern'"=="" {
		local ltr "*"
		local pattern "*.class"
	}
	else {
		local ltr = bsubstr("`pattern'",1,1)
		if ~(("`ltr'">="a" && "`ltr'"<="z") | ///
		     ("`ltr'">="A" && "`ltr'"<="Z") | ///
		     "`ltr'"=="_" ///
		    ) {
			local ltr "*"
		}
		local pattern "`pattern'.class"
	}

	local path `"`c(adopath)'"'
	gettoken d path : path, parse(" ;")
	while `"`d'"' != "" {
		if `"`d'"' != ";" {
			local d : sysdir `"`d'"'
			DirSearch "`pattern'" "`d'" "`ltr'"
			local res `"`r(res)'"'
			local list : list list | res
		}
		gettoken d path : path, parse(" ;")
	}
	local list : list sort list
	local list : list clean list
	return local list "`list'"
	DisplayInCols txt 0 0 0 `list'
end

		

	
program DirSearch, rclass
	args pattern dir ltr 

	capture local x : dir "`dir'" files "`pattern'"
	if _rc { 
		if _rc!=601 {
			exit _rc
		}
	}
	local x : subinstr local x ".class" "", all
	if "`ltr'" != "*" {
		capture local x2 : dir "`dir'`ltr'" files "`pattern'"
		if _rc {
			if _rc!=601 {
				exit _rc
			}
			local x2
		}
		local x2 : subinstr local x2 ".class" "", all
		ret local res : list x | x2
		exit
	}
	foreach l in _ a b c d e f g h i j k l m n o p q r s t u v w x y z {
		capture local x2 : dir "`dir'`l'" files "`pattern'"
		if _rc {
			if _rc!=601 {
				exit _rc
			}
			local x2
		}
		local x2 : subinstr local x2 ".class" "", all
		local x : list x | x2
	}
	ret local res `"`x'"'
end


program DisplayInCols /* sty #indent #pad #wid <list>*/
	gettoken sty    0 : 0
	gettoken indent 0 : 0
	gettoken pad    0 : 0
	gettoken wid	0 : 0

	local indent = cond(`indent'==. | `indent'<0, 0, `indent')
	local pad    = cond(`pad'==. | `pad'<1, 2, `pad')
	local wid    = cond(`wid'==. | `wid'<0, 0, `wid')
	
	local n : list sizeof 0
	if `n'==0 { 
		exit
	}

	foreach x of local 0 {
		local wid = max(`wid', length(`"`x'"'))
	}

	local wid = `wid' + `pad'
	local cols = int((`c(linesize)'+1-`indent')/`wid')

	if `cols' < 2 { 
		if `indent' {
			local col "column(`=`indent'+1)"
		}
		foreach x of local 0 {
			di as `sty' `col' `"`x'"'
		}
		exit
	}
	local lines = `n'/`cols'
	local lines = int(cond(`lines'>int(`lines'), `lines'+1, `lines'))

	/* 
	     1        lines+1      2*lines+1     ...  cols*lines+1
             2        lines+2      2*lines+2     ...  cols*lines+2
             3        lines+3      2*lines+3     ...  cols*lines+3
             ...      ...          ...           ...               ...
             lines    lines+lines  2*lines+lines ...  cols*lines+lines

             1        wid
	*/


	* di "n=`n' cols=`cols' lines=`lines'"
	forvalues i=1(1)`lines' {
		local top = min((`cols')*`lines'+`i', `n')
		local col = `indent' + 1 
		* di "`i'(`lines')`top'"
		forvalues j=`i'(`lines')`top' {
			local x : word `j' of `0'
			di as `sty' _column(`col') "`x'" _c
			local col = `col' + `wid'
		}
		di as `sty'
	}
end
