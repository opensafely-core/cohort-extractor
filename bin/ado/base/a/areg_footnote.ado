*! version 1.2.0  25apr2018
program areg_footnote
	version 12

	if `"`e(prefix)'"' != "" | `"`e(vcetype)'"' == "Robust" { 
		/* No footer output */
	}
	else {
		Footer  
	}
end

program Footer
       di as txt `"F test of absorbed indicators: F("'	/*
		*/ as res `e(df_a)' as txt ", "		/*                
		*/ as res `e(df_r)' as txt ") = " 	/*           
        	*/ as res %4.3f `e(F_absorb)'		/*                    
		*/ _col(62) as txt " Prob > F = " 	/*
	 	*/ as res  %4.3f `e(p_absorb)' 
end

exit

