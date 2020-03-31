*! version 1.0.1  05jun1998
program define _getrhs /* lclmacname [lclmacname] */ 
	version 6
	args where lcons
	tempname b 
	mat `b' = get(_b)
	local rhs : colnames `b'
	mat drop `b'
	local n : word count `rhs'
	tokenize `rhs'
	if "``n''"=="_cons" {
		local `n'
		local cons 1
	}
	else	local cons 0
	c_local `where' "`*'"
	if "`lcons'" != "" {
		c_local `lcons' `cons'
	}
end
exit
