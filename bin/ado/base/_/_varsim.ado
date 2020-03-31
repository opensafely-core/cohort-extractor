*! version 1.5.1  18dec2002
program define _varsim
	version 8.0
	syntax varlist , neqs(integer) b(string) fsamp(varname) /*
		*/ eqlist(string) [ bsp corr(string)]
			/*
			the varlist contains the list of endogenous variables
				in the VAR
			neqs is the number of equations in the VAR
			b contains the name of coefficient matrix to be used	
			bsp stands for parametric bootstrap
				otherwise the default residual bootstrap 
				is used to obtain the simulated data 
			*/	

	if "`e(cmd)'" != "var" & "`e(cmd)'" != "svar" {
		di as err "_varsim only works after var and svar"
		exit 198
	}

	if "`e(cmd)'" == "svar" {
		local svar "_var"
	}	

	local vlist "`varlist'"

	if "`bsp'" == "" {
		local i 1
		forvalues i = 1(1)`neqs' {
			tempname res`i'
						/* the next line work with
						 * both var and svar because
						 * predict will call the 
						 * correct predict routine for
						 * each model
						 */
			qui predict double `res`i'', res equation(#`i')
			local reslist `reslist' `res`i''
		}	

		forvalues i = 1(1)`neqs' {
			tempname bsres`i' 
			qui gen double `bsres`i''=.
			local rvarlist `rvarlist `bsres`i''
		}	

		tempname bsresin bsresin2
		gen byte `bsresin' = 1 
		markout `bsresin' `reslist'
		gen `bsresin2' = -1*`bsresin'
		local sortvars : sortedby
		sort `bsresin2' `sortvars'
		qui count if `bsresin2' == -1
	
		local robmax = r(N)
		

		tempname rob
		local out 1
		qui capture drop `rob'
		qui gen `rob' = .

		qui replace `rob'=int(1+uniform()*`robmax')  if `fsamp' 

		forvalues i = 1(1)`neqs' {
			qui replace `bsres`i''=`res`i''[`rob']  if `fsamp' 
			qui count if `bsres`i'' >= . & `fsamp'
			if r(N) > 0 {
				di as err "error drawing bootstrap sample"
				exit 498
			}	
		}

		sort `sortvars'
	}
	else {
		if "`corr'" != "" {
			local cmat "corr(`corr')"
		}	
		else {
			tempname sigma_u
			mat `sigma_u'=e(Sigma)
			local cmat "cov(`sigma_u')"
		}

		forvalues i = 1(1)`neqs' {
			tempname bsres`i'
			local resvars "`resvars' `bsres`i'' "
		}
		qui drawnorm `resvars' , `cmat' double
		foreach v2 of local resvars {	 	
			qui replace `v2'= . if `fsamp' !=1
		}	
	}
	
	
	recast double `vlist'
	local j 1
	foreach v of local vlist {
		local eqj : word `j' of `eqlist'
		local a`j' "score `v' = `b', eq(#`j') "
		local b`j' "update `v'=`v' + `bsres`j''"
		local j = `j' + 1
	}

	_byobs {
		 `a1'
		 `b1'
		 `a2'
		 `b2'
		 `a3'
		 `b3'
		 `a4'
		 `b4'
		 `a5'
		 `b5'
		 `a6'
		 `b6'
		 `a7'
		 `b7'
		 `a8'
		 `b8'
		 `a9'
		 `b9'
		 `a10'
		 `b10'
		 `a11'
		 `b11'
		 `a12'
		 `b12'
		 `a13'
		 `b13'
		 `a14'
		 `b14'
		 `a15'
		 `b15'
		 `a16'
		 `b16'
		 `a17'
		 `b17'
		 `a18'
		 `b18'
		 `a19'
		 `b19'
		 `a20'
		 `b20'
		 `a21'
		 `b21'
		 `a22'
		 `b22'
		 `a23'
		 `b23'
		 `a24'
		 `b24'
		 `a25'
		 `b25'
		 `a26'
		 `b26'
		 `a27'
		 `b27'
		 `a28'
		 `b28'
		 `a29'
		 `b29'
		 `a30'
		 `b30'
		 `a31'
		 `b31'
		 `a32'
		 `b32'
		 `a33'
		 `b33'
		 `a34'
		 `b34'
		 `a35'
		 `b35'
		 `a36'
		 `b36'
		 `a37'
		 `b37'
		 `a38'
		 `b38'
		 `a39'
		 `b39'
		 `a40'
		 `b40'
		 `a41'
		 `b41'
		 `a42'
		 `b42'
		 `a43'
		 `b43'
		 `a44'
		 `b44'
		 `a45'
		 `b45'
		 `a46'
		 `b46'
		 `a47'
		 `b47'
		 `a48'
		 `b48'
		 `a49'
		 `b49'
		 `a50'
		 `b50'
		 `a51'
		 `b51'
		 `a52'
		 `b52'
		 `a53'
		 `b53'
		 `a54'
		 `b54'
		 `a55'
		 `b55'
		 `a56'
		 `b56'
		 `a57'
		 `b57'
		 `a58'
		 `b58'
		 `a59'
		 `b59'
		 `a60'
		 `b60'
		 `a61'
		 `b61'
		 `a62'
		 `b62'
		 `a63'
		 `b63'
		 `a64'
		 `b64'
		 `a65'
		 `b65'
		 `a66'
		 `b66'
		 `a67'
		 `b67'
		 `a68'
		 `b68'
		 `a69'
		 `b69'
		 `a70'
		 `b70'
		 `a71'
		 `b71'
		 `a72'
		 `b72'
		 `a73'
		 `b73'
		 `a74'
		 `b74'
		 `a75'
		 `b75'
		 `a76'
		 `b76'
		 `a77'
		 `b77'
		 `a78'
		 `b78'
		 `a79'
		 `b79'
		 `a80'
		 `b80'
		 `a81'
		 `b81'
		 `a82'
		 `b82'
		 `a83'
		 `b83'
		 `a84'
		 `b84'
		 `a85'
		 `b85'
		 `a86'
		 `b86'
		 `a87'
		 `b87'
		 `a88'
		 `b88'
		 `a89'
		 `b89'
		 `a90'
		 `b90'
		 `a91'
		 `b91'
		 `a92'
		 `b92'
		 `a93'
		 `b93'
		 `a94'
		 `b94'
		 `a95'
		 `b95'
		 `a96'
		 `b96'
		 `a97'
		 `b97'
		 `a98'
		 `b98'
		 `a99'
		 `b99'
		 `a100'
		 `b100'
		 `a101'
		 `b101'
		 `a102'
		 `b102'
		 `a103'
		 `b103'
		 `a104'
		 `b104'
		 `a105'
		 `b105'
		 `a106'
		 `b106'
		 `a107'
		 `b107'
		 `a108'
		 `b108'
		 `a109'
		 `b109'
		 `a110'
		 `b110'
		 `a111'
		 `b111'
		 `a112'
		 `b112'
		 `a113'
		 `b113'
		 `a114'
		 `b114'
		 `a115'
		 `b115'
		 `a116'
		 `b116'
		 `a117'
		 `b117'
		 `a118'
		 `b118'
		 `a119'
		 `b119'
		 `a120'
		 `b120'
		 `a121'
		 `b121'
		 `a122'
		 `b122'
		 `a123'
		 `b123'
		 `a124'
		 `b124'
		 `a125'
		 `b125'
		 `a126'
		 `b126'
		 `a127'
		 `b127'
		 `a128'
		 `b128'
	} if `fsamp' 

end

