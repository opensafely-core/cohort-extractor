*! version 1.0.1  24jul2006
*! convert float variable to binary 0 or !0

program _float2binary, sclass
	version 10
	syntax varlist(min=1), [ noLOg ]

	tokenize `varlist'
	local y `1'
	macro shift
	local f `*'

	qui count if `y'!=0 & `y'!=1 
	if r(N) > 0 {
		tempname feps

		local type : type `y'
		if "`type'"=="float" | "`type'"=="double" {
			scalar `feps' = 1/sqrt(c(max`type'))
		}
		else scalar `feps' = 0

		if ("`log'"=="") di as text ///
			"{p}note: recoding `y' to be 0/1{p_end}"

		qui replace `y' = (abs(`y')>`feps')
		sreturn local converted converted
	}
	qui recast byte `y'
	/* let the user see the recoded depvar	*/
	/*  to make sure it is what is expected	*/
	if "`feps'"!="" & "`log'"=="" { 
		if ("`f'"!= "") tabulate `y' [fw=`f']
		else tabulate `y'
	}
end

exit
