*! version 1.0.1  14jun2019
program _dslasso_clean
	version 16.0

	syntax , rc_now(string) 

	if (`rc_now') {
		ereturn clear
		cap esrf clear 
		exit `rc_now'
	}
end
