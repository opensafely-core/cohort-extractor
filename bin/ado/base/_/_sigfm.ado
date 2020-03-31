program define _sigfm, sclass
        args    digits          /* significant digits to be printed
        */      slength         /* string length for output
        */      number           /* the input number */

	sret clear
        tempname a b output input y
        scalar `input' = abs(`number')
        scalar `a' = log10(`input')
        if ( `a' < 0 ) & ( int(`a') != `a' ) { scalar `a' = `a' - 1 }
        if `a' > `digits ' {
                scalar `b' = int(`a') - `digits' + 1
		scalar `y' = 10^`b'
                local output = round(`input', `y')
		if `a' >= `slength' - 2 {
			if sign(`number') == -1 { local output "-`output'" }	
			sret clear
			sreturn local output "`output'"
			sreturn local code 0			/* number */
		}
		else {
			sret clear
                	sreturn local output "`number'"
                	sreturn local code 0			/* string */
		}
        }
	else if `a' < -`digits' {
		scalar `y' = 10^(-`digits')
		local output = round(`input', `y')
		if "`output'"== "0" {
			local output "."
			local i = 1
			while `i' < = `digits' {
				local output "`output'0"
				local i = `i' + 1
			}
			if sign(`number') == -1 { local output "-`output'" }	
			sret clear
                	sreturn local output "`output'"
                	sreturn local code 1			/* string */
		}
		else {
			if sign(`number') == -1 { local output "-`output'" }	
			sret clear
			sreturn local output "`output'"
			sreturn local code 0			/* number */
		}
	}
	else {
		if int(`a') > 0 { scalar `y' = 10^(-(`digits'-int(`a')-1)) }
		else scalar `y' = 10^(-`digits')
		local output = round(`input', `y')
		if sign(`number') == -1 { local output "-`output'" }	
		sret clear
               	sreturn local output "`output'"
               	sreturn local code 0			/* string */
	}	
end

