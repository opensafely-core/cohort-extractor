*! version 1.0.1  09feb2012
program _assert_mreldifs
	version 8
	syntax anything [, tol(real 1e-8) noNames noList ]
			
	gettoken matexp1 matexp2 : anything, match(parens)
	if `"`matexp2'"' == "" {
		dis as err "two matrix expressions expected"
		exit 198
	}	
		
	tempname M1 M2
	matrix `M1' = `matexp1'
	matrix `M2' = `matexp2' 
	
	if ( (rowsof(`M1') != rowsof(`M2')) | ///
	     (colsof(`M1') != colsof(`M2')) ) {
	    	dis as err "nonconformable matrices or matrix expressions" 
	    	dis as err `"  {ralign 12:`matexp1'} = "' rowsof(`M1') ///
	    	                                    " x " colsof(`M1')
	    	dis as err `"  {ralign 12:`matexp2'} = "' rowsof(`M2') ///
	    	                                    " x " colsof(`M2')
	    	exit 503
	}
	
	// for speed, first straight test 
	capture assert mreldif(`M1',`M2') < `tol' 
	if _rc {
		// test by column, up to sign
		tempname  M1_j M2_j M2m_j
		
		local c = colsof(`M1')
		forvalues j = 1/`c' { 
			matrix `M1_j'  = `M1'[1...,`j']
			matrix `M2_j'  = `M2'[1...,`j']
			matrix `M2m_j' = - `M2_j'
		
			capture assert ///
			   (mreldif(`M1_j',`M2_j' ) < `tol') | ///
			   (mreldif(`M1_j',`M2m_j') < `tol')
		               
			if _rc {
				dis as err "assert failed: " /// 
				    `"mreldif(`matexp1',`matexp2') < `tol'"'
				    
				if "`list'" == "" { 
					matlist `M1', title(`matexp1')
					matlist `M2', title(`matexp2')
				}
				
				exit 9
			}
		}	
	}
	
	if "`names'" == "" {
		_assert_streq `"`:rowfullnames `M1''"' /// 
		              `"`:rowfullnames `M2''"'
		              
		_assert_streq `"`:colfullnames `M1''"' /// 
		              `"`:colfullnames `M2''"'
	}
end
exit
