*! version 1.0.4  13feb2015
program define clslistarray
	version 8.2

	gettoken array 0 : 0

	if "`.`array'.isa'" != "array" {
		exit 
	}

	syntax [, Lines(integer -1) ]

	if `lines' == -1 { 
		local lines = `.`array'.arrnels' 
	}

	forvalues i = 1/`lines' {
	    scalar val = `"`.`array'[`i']'"'
	    if `"`= bsubstr(val,1,6)'"' != `"__key("' {
		if "`.`array'[`i'].isa'" == "class" {
		    di "[" %3.0f `i' `"] (`.`array'[`i'].isa') "'	 /*
				*/ `"`.`array'[`i'].classname' "' 	 /* 
				*/ `"`.`array'[`i'].objkey'"'
		}
		else {
			di "[" %3.0f `i' 				///
				`"] (`.`array'[`i'].isa') `.`array'[`i']'"' 
		}
	    }
	    else {
	    	if "`.`.`array'[`i']'.classname'" == "" {
	    	    di "[" %3.0f `i' 					///
		    	`"] (`.`.`array'[`i']'.isa') `.`array'[`i']'"'
		}
		else {
	    	    di "[" %3.0f `i' `"] (`.`.`array'[`i']'.isa') `.`.`array'[`i']'.classname'"'
		}
	    }
	}

end
