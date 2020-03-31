*! version 2.3.8  16feb2015
program define xpose
	version 7.0
	syntax [, CLEAR Format(string) Format1 PROMote Varname ]
	if "`clear'"=="" {
		di as err "you must specify ', clear'"
		exit 198
	}
	if "`format'"!="" & "`format1'"!="" {
		di as err "format() and format are mutually exclusive"
		exit 198
	}
	if (_N==0) {
		error 2000
	}
	quietly describe
	if r(k)==0 {
		di as txt "(no variables)"
		exit 2000
	}
	local nv = r(N)

	capture confirm var _varname
	if _rc == 0 {
		local i = 1
		while (`i' <= `nv') {
			local vn = _varname[`i']
			local vns "`vns' `vn'"
			local i = `i' + 1
		}
	}

	preserve
	quietly {
		capture drop _varname

		if "`varname'"!="" {
			local 0 "_all"
			syntax varlist
		}
		
		if "`format1'"!="" {
			unab vars : _all
			local fmtmax 0
			foreach var of local vars {
				local fmthold : format `var'
				if index("`fmthold'", "s")==0 /*
					*/ & index("`fmthold'", "d")==0 /*
					*/ & index("`fmthold'", "D")==0 /*
					*/ & index("`fmthold'", "m")==0 /*
					*/ & index("`fmthold'", "M")==0 /*
					*/ & index("`fmthold'", "y")==0 /*
					*/ & index("`fmthold'", "Y")==0 {
					if index("`fmthold'", "-")!=0 {
						local fmthold = subinstr( /*
						*/ "`fmthold'", "-", "", .)
					}
					local fmthold = bsubstr("`fmthold'" /*
						*/ , 2, 2)
					local fmthold = subinstr("`fmthold'" /*
						*/ , ".", "", .)
					if `fmtmax' < `fmthold' {
						local fmtmax = `fmthold'
						local fmt : format `var'
					}
				}
			}
		}
		else {
			if "`format'"!="" {
				local fmt = "`format'"
			}
		}
		if "`promote'"!="" {
			local bytetype 0
			local inttype 0
			local longtype 0
			local floattype 0
			local doubletype 0
			unab vars : _all
			foreach var of local vars {
				local type : type `var'
				if index("`type'", "str")==0 {
					if "`type'"=="double" {
						local doubletype 1
					}
					else if "`type'"=="float" {
						local floattype 1
					}
					else if "`type'"=="long" {
						local longtype 1
					}
					else if "`type'"=="int" {
						local inttype 1
					}
					else if "`type'"=="byte" {
						local bytetype 1
					}
				}
			}
			if `doubletype' {
				local newtype "double"
			}
			else if `floattype' & `longtype' {
				local newtype "double"
			}
			else if `floattype' & !`longtype' {
				local newtype "float"
			}
			else if `longtype' {
				local newtype "long"
			}
			else if `inttype' {
				local newtype "int"
			}
			else if `bytetype' {
				local newtype "byte"
			}
			if "`newtype'" == "" {  /* all vars must be string */
				local newtype "byte"
			}
		}
		else {
			local newtype "`c(type)'"			
		}
		
		unab invars : _all
		local c : word count `invars'
		local r = _N	
			
		tempfile dataset
		
		Read_out `c' `r' `"`dataset'"'
		
		drop _all
		
		if "`vns'"!= "" {
			local isvns = 1	
		}
		else {
			local isvns = 0
		}
		
		Read_in `c' `r' `"`dataset'"' `"`newtype'"' `isvns' `"`vns'"' 		
		
		if ("`format1'"!="" | "`format'"!="") & "`fmt'"!="" {
			format _all `fmt'
		}
		if "`varname'"!="" {
			gen str8 _varname=""
			local i 1
			tokenize `invars'
			local stop = `c'
			while `i' <= `stop'  {
				replace _varname = "``i''" in `i'
				local i = `i' + 1
			}
		}
		restore, not
	}
	
end


program define Read_out
	args c r dataset
	
	unab varlist : _all
	foreach var of local varlist {
		if bsubstr("`: type `var''",1 ,3) == "str" {
			/* all strings become missing values */
			drop `var'
			gen byte `var' = .
		}
	}
	
	tempname hdl ob
	file open `hdl' using `"`dataset'"',  write binary replace 
	foreach var of local varlist {
		forvalues i = 1/`r' {
			scalar `ob' = `var'[`i']
			file write `hdl' %8z (`ob')
		}
	}
	file close `hdl'
end

program define Read_in
	args c r dataset type isvns vns
	set obs `c'
	forvalues i = 1(1)`r'{
		qui gen `type' v`i' = .
	}		
	
	tempname hdl2
	file open `hdl2' using `"`dataset'"',  read binary
	tempname val
	file read `hdl2' %8z  `val'
	
	forvalues j = 1/`c' {
		forvalues i = 1(1)`r' {
			qui replace v`i' = `val' in `j'
			file read `hdl2' %8z `val'
		}	
	
	}
	if `isvns' == 1 {
		tokenize `vns'
		local i = 1
		while `i' <= `r' {
			local varname "v`i'"
			if "`varname'" != "``i''" {
				rename v`i' ``i''	
			}
		local i = `i' + 1
		}
	}
	file close `hdl2'
end

