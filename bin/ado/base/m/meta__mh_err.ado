*! version 1.0.0  18apr2019

program meta__mh_err
	
	syntax [, cmd(string)]
	
	di as txt "{p 0 6 2}"			///
		  "note: declared Mantel-Haenszel method not supported " ///
		  "with {bf:`cmd'}; using inverse-variance method{p_end}"
end