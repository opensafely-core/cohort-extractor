*! version 1.0.6  20jan2015
program ds_util, rclass
	version 8
	syntax [varlist] [, HAS(str asis) NOT(str asis) NOT2 INSEnsitive ///
	Detail Alpha Varwidth(int 12) Skip(int 2) INDENT(int 0)] 

	if "`varlist'" == "" {
		exit
	}

	// presentation options
	if !inrange(`indent',0,244) {
		di as err "indent() should be in the range 0..244"
		exit 198
	}

	if !inrange(`varwidth',5,32) {
		di as err "varwidth() should be in the range 5..32"
		exit 198
	}

	if !inrange(`skip',1,10) {
		di as err "skip() should be in the range 1..10"
		exit 198
	}

	// checking has() and not() and not 
	local nopts = (`"`has'"' != "") + (`"`not'"' != "") + ("`not2'" != "") 
	if `nopts' == 3 {
		di as err "may not combine options has(), not(), and not" 
		exit 198 
	}
	else if `nopts' == 2 {
		if (`"`has'"' == "") {
			di as err "may not combine options not() and not" 
			exit 198 
		}
		else if (`"`not'"' == "") {
			di as err "may not combine options has() and not" 
			exit 198 
		}
		else if (`"`not2'"' == "") {
			di as err "may not combine options has() and not()" 
			exit 198 
		}
	}

	if `"`not'"' != "" { 
		local has `"`not'"'
		local opt "not" 
	}   
	else if `"`has'"' != "" { 
		local opt "has"
	}

	local inse = "`insensitive'" != "" 

	// implement has() and not()
	if `"`has'"' != "" { 	
		CheckHas `"`has'"' "`opt'" "`inse'"
		// variable or value labels 
		if "`what'" == "varl" | "`what'" == "vall" { 
			VarlVall "`what'" `"`which'"' "`varlist'" "`inse'" 
		} 	
		// formats 
		else if "`what'" == "f" { 
			Format `"`which'"' "`varlist'" "`inse'" 
		}	
		// characteristics 
		else if "`what'" == "c" {  
			Char `"`which'"' "`varlist'" "`inse'" 
		}	
		// types 
		else if "`what'" == "t" {  
			Type `"`which'"' "`varlist'" 
		} 
		
		if `"`not'"' != "" {    
			local varlist : list varlist - vlist 
		}
		else if `"`has'"' != ""  { 
			local varlist "`vlist'" 
		} 
	}

	// implement not 
	if `"`not2'"' != "" { 
		unab all : * 
		local varlist : list all - varlist 
	}

	if "`varlist'" == "" { 
		exit 
	}   
	 
	// presentation:
	if "`alpha'" != "" {
		local varlist : list sort varlist 
	}

	if "`detail'" != "" { 
		describe `varlist' 
	}
	else {
		local nvar : word count `varlist'
		local ncol = int((`:set linesize' + `skip') / (`varwidth' + `skip'))
		local i 0

		local vlist 
		foreach v of local varlist {
			local vlist `"`vlist' `= abbrev("`v'",`varwidth')'"' 
		}

		DisplayInCols txt `indent' `skip' 0 `vlist'
	}    

	return local varlist `varlist'
end

program CheckHas 
	args has opt inse  

        // what kind of thing? which particular thing(s)? 
	gettoken what which : has

	if trim(`"`which'"') == "" {
		local which ""
	}

        // first element should start var | val | f | c | t 
        local what = lower("`what'")
        local l = length("`what'") 
        
        if "`what'" == bsubstr("varlabel",1,max(4,`l')) { 
        	local what "varl" 
        } 
        else if "`what'" == bsubstr("vallabel",1,max(4,`l')) {
        	local what "vall" 
        } 
        else if "`what'" == bsubstr("format",1,max(1,`l')) { 
        	if `"`which'"' == "" { 
                	BadHasNot `opt' 
        	} 
            	local what "f" 
        } 
        else if "`what'" == bsubstr("char",1,max(1,`l')) { 
        	local what "c" 
        }    
        else if "`what'" == bsubstr("type",1,max(1,`l')) { 
        	local what "t"
        	if `"`which'"' == "" { 
                	BadHasNot `opt' 
        	} 
        	CheckType `which' 
        }     
        else BadHasNot `opt' 

        // to lower case: fewer problems if `which' is longer than 80 chars 
        if `inse' { 
        	foreach w of local which { 
                	local lower = lower("`w'") 
                	local which2 `"`which2' "`lower'""'
        	} 
            	local which `"`which2'"'
        }     

	c_local what "`what'"
	c_local which `"`which'"' 
end 

program BadHasNot
	args opt 
	di as err "invalid `opt'() option" 
	exit 198
end     

program CheckType 
	// We remove allowed type names from the argument. 
	// Whatever remains should be the elements of a numlist. 
	// Note that a numlist may include embedded spaces. 
	// A side-effect is to allow e.g. "1 byte / 80".

	local which `"`*'"'
	local which : list uniq which 
	local types "byte int long float double string str# strL numeric"
	local which2 : list which - types
	     
	if `"`which2'"' != "" {  
		capture numlist `"`which2'"', integer range(>=1 <=`c(maxstrvarlen)')
		if _rc { 
			di as err "invalid variable type(s)" 
			exit 198 
		}  
	} 

	local which : list which - which2 
	c_local which `"`which' `r(numlist)'"'
end   

program VarlVall
	args what which varlist inse
        local kind = cond("`what'" == "varl", "variable", "value")
        if `"`which'"' == "" { 
        // any label 
        	foreach x of local varlist { 
                	local lbl : `kind' label `x' 
	                if `"`lbl'"' != "" { 
                        	local vlist "`vlist'`x' " 
                	} 
            	}
        }    
        else { 
        // some label pattern 
        	foreach x of local varlist { 
                	local lbl : `kind' label `x' 
                	if `inse' { 
                		local lbl = lower(`"`lbl'"') 
	                } 
                	foreach w of local which { 
                    		if match(`"`lbl'"',`"`w'"') { 
                        		local vlist "`vlist'`x' " 
		                        continue, break 
                        	} 
                	} 
            	}
        } 
	c_local vlist "`vlist'" 
end

program Format
	args which varlist inse 
        foreach x of local varlist { 
                local fmt : format `x' 
                if `inse' { 
                	local fmt = lower(`"`fmt'"') 
                } 
                foreach w of local which { 
                	if match(`"`fmt'"',`"`w'"') ///
			| match(`"`fmt'"',`"%`w'"') { 
                        	local vlist "`vlist'`x' " 
	                        continue, break 
         		} 
                } 
         }
	 c_local vlist "`vlist'" 
end

program Char 
	args which varlist inse 
        if `"`which'"' == "" { 
        // any char 
                foreach x of local varlist { 
                	local chr : char `x'[] 
                        if `"`chr'"' != "" { 
                        	local vlist "`vlist'`x' " 
                    	} 
                }
        }    
        else {
        // some char pattern 
                foreach x of local varlist { 
                	local chr : char `x'[] 
                    	local found 0 
                    	foreach c of local chr { 
                        	if `inse' { 
                            		local c = lower(`"`c'"') 
	                        } 
                        	foreach w of local which { 
                        		if match(`"`c'"',`"`w'"') { 
                                		local found 1 
		                                local vlist "`vlist'`x' " 
        		                        continue, break 
                		         } 
                        	} 
                        	if `found' { 
                                	continue, break 
                        	} 
                    	}    
		}    
        } 
	c_local vlist "`vlist'" 
end 

program Type
	args which varlist inse 

        foreach x of local varlist {
                foreach w of local which {
                	if `"`w'"' == "string" | `"`w'"' == "numeric" {
                        	capture confirm `w' variable `x'
	                        if _rc == 0 { 
                            		local vlist "`vlist'`x' " 
	                        }    
                        }
			else if `"`w'"' == "str#" {
                        	capture confirm str# variable `x'
	                        if _rc == 0 { 
                            		local vlist "`vlist'`x' " 
	                        }    
			}
                        else {
                        	local t : type `x' 
                        	if "`t'" == `"str`w'"' | "`t'" == `"`w'"' { 
                            		local vlist "`vlist'`x' "
	                        } 
                        }     
               } 
        }
	c_local vlist "`vlist'" 
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
			local col "_column(`=`indent'+1')"
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
