*! version 1.0.1  09feb2012
program _assert_mreldifp
	version 8
	
	syntax anything [, tol(real 1e-8) noNames noList ]
			
	gettoken matexp1 matexp2 : anything, match(parens)
	if `"`matexp2'"' == "" {
		dis as err "two matrix expressions expected"
		exit 198
	}	
		
	tempname M1 M2 L2norm Z Z1 Z2
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
		 		
	matrix `Z1' = `M1' * syminv(`M1''*`M1') * `M1'' 
	matrix `Z2' = `M2' * syminv(`M2''*`M2') * `M2''
		
	quietly assert mreldif(`Z1',`Z2') < `tol' 
	if _rc { 
		if "`list'" == "" { 
			matlist `M1' , title(M1 = `matexp1')
			matlist `M2' , title(M2 = `matexp2')
			
			matlist `Z1' , title(ortho projection on M1)
			matlist `Z2' , title(ortho projection on M2)
		}
		exit 7
	}	
	
	if "`names'" == "" {
		_assert_streq `"`:rowfullnames `M1''"' /// 
		              `"`:rowfullnames `M2''"'
		              
		_assert_streq `"`:colfullnames `M1''"' /// 
		              `"`:colfullnames `M2''"'
	}
end
exit
