*! version 1.0.5  24oct2002
program define _at, rclass
	version 6 
	args cmd opt

* syntax for _at are of two parts, cmd part and opt part.
* usage of _at 
*	_at "mean mpg = 20 price = 2000" "[if] [in], noEsample noWght"

					/* the option part */
	local 0 "`opt'"
	syntax [if] [in] [, noEsample noWght]

	marksample touse
	if "`esample'" == "" {
		qui count if e(sample)
		if r(N) != 0 {
			qui replace `touse' = 0 if ~ e(sample)
		}
	}

	if "`wght'" == "" {
	        if "`e(wexp)'" != "" { 
                        local weight "[aweight`e(wexp)']"
                }
        }

					/* the command part */
* syntax 1
*	 _at 	mean   
*		median	[ var = # [[var = #] ....]]
*		zero 	
* syntax 2
*	 _at	numlist			for one equation only
* syntax 3
*	 _at	matname			for one equation only.

	local 0 "`cmd'"
	tempname M
	gettoken thing1 rest : 0 , parse(" ,=")
	if "`thing1'" == "mean" | "`thing1'" == "median" | 	/*
	*/ "`thing1'" == "zero" {
		Parse1 `M' "`0'" `touse' "`weight'"	/* syntax 1 */
		return mat at  `M'
		exit
	}
	cap confirm number `thing1'
	if _rc == 0 {
		Parse2 `M' "`0'"			/* syntax 2 */
		return mat at  `M'
		exit
	}
	cap qui mat list `thing1'
	if _rc == 0 {
		Parse3 `M' "`0'"			/* syntax 3 */
		return mat at  `M'
		exit
	}
	cap confirm var `thing1'
	if _rc == 0 {
		local 0 mean `0'
		Parse1 `M' "`0'" `touse' "`weight'"	/* syntax 1 */
		return mat at  `M'
		exit
	}
	
	dis in red "at(`0'): invalid syntax "
	exit 198
end							

program define Parse1
	args M opt touse weight
	local 0 "`opt'"
	tempname B
	mat `B' = e(b)
	local cnum = colsof(`B')
	local cname : colnames `B'
	gettoken stat left: 0, parse(" ,") 
	mat `M' = `B' 
 	local i 1
	while `i' <= `cnum' {
		local name : word `i' of `cname'
		cap tsrevar `name'
		if _rc ==0 {
			if "`stat'" == "zero" {
				mat `M'[1, `i'] = 0
			}
			else {
				qui sum `name' `weight' if `touse', detail
				if "`stat'" == "mean" {
					mat `M'[1,`i'] = r(mean)
				}
				else mat `M'[1,`i'] = r(p50)
			}
		}
		else mat `M'[1, `i'] = 1
		local i = `i' + 1
	}	
	
	gettoken first vlist: left, parse(" ,")
	if "`first'" != "," {
		local vlist "`left'"
	}
	if "`first'" != "" {
		gettoken thing1 vlist : vlist, parse(" =,")
		while "`thing1'" != "" {
			cap tsrevar `thing1'
			if _rc { 
				dis in red "`thing1' not found" 
				exit 198
			}
			unab thing1 : `r(varlist)'
			gettoken equal vlist : vlist, parse(" =,")
			IsToken = `equal'
			gettoken thing2 vlist : vlist, parse(" =,")
			IsThing "" number `thing2'
			local i = 1
			while `i' <= `cnum' {
				local name : word `i' of `cname'
				cap tsrevar `name'
				if !_rc & ("`r(varlist)'" == "`thing1'") {
					mat `M'[1,`i'] = `thing2'
				}
				local i = `i' + 1
			}
			gettoken comma rest: vlist, parse(" =,")
			if "`comma'" == "," {
				local vlist `rest'
			}
			gettoken thing1 vlist: vlist, parse(" =,")
		}
end

program define IsThing
	args type1 type2 opt
	confirm `type1' `type2' `opt'
end

program define IsToken
	args exp opt
	if "`exp'" != "`opt'" {
		dis in red "`opt' found where `exp' expected in at()"
		exit 198
	}
end

program define Parse2
	args M opt
	tempname B
	mat `B' = e(b)
	local eqname : coleq `B'
	tokenize `eqname'
	if (("`1'" != "") & ("`1'" != "_")) | "`e(cmd)'"=="tobit" {
		dis in red "multiple equations, numlist not allowed"
		exit 198
	}
	numlist "`opt'"
	local nlist `r(numlist)'
	tempname T
	_mkvec `T', from(`nlist', copy) error( "at(numlist)")
	Parse3 `M' `T'
end

program define Parse3
	args M opt
	tempname B
	mat `B' = e(b)
	local eqname : coleq `B'
	tokenize `eqname'
	if ("`1'" != "") & ("`1'" != "_") {
		dis in red "multiple equations, matname not allowed"
		exit 198
	}
	_at "mean"
	mat `M' = r(at) 
	cap _mkvec `M', from(`opt') update
	if _rc == 111 {
		_mkvec `M', from(`opt', copy) update error("at(matname)")
	}
	else _mkvec `M', from(`opt') update error("at(matname)")
	local cnum = colsof(`M')
	local cname : colnames `M'
	local i 1
	while `i' <= `cnum' {
		local vname : word `i' of `cname'
		cap tsrevar `vname'
		if _rc != 0 {
			mat `M'[1, `i'] = 1
		}
		local i = `i' + 1
	}
end 
