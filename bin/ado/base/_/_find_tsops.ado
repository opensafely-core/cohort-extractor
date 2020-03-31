*! version 1.0.1  29jan2007

/* (undocumented)

	Takes as input a varlist and looks to see if any elements
	contain time-series operators.

	Syntax
	
		_find_tsops <varlist>
		
	Returns
	
		r(tsops) = 1 	if any element of <varlist> contains
				time-series operators
			   0	otherwise
	
	<varlist> is assumed to be a valid list of variables already
	processed by -syntax- or some equivalent procedure.
	
*/

program _find_tsops, rclass

	version 9

	local tsops 0
	tokenize `*'
	while (`tsops' == 0 & "`1'" != "") {
		local tsops = ( index("`1'", ".") > 0 )
		macro shift
	}
	
	return scalar tsops = `tsops'
	
end
