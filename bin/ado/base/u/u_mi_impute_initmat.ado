*! version 1.1.0  09jun2011

program u_mi_impute_initmat, rclass
	version 11

	syntax [, Betas(string)		///
		  SDs(string)		///
		  VARs(string)		///
		  COV(string)		///
		  CORR(string)		///
		  p(integer 1)		///
		  q(integer 1)		///
		  name(string)		///
		]
	if ("`name'"=="") {
		local name {bf:init()}
	}
	if ("`cov'"!="" & ("`sds'`vars'`corr'"!="")) {
		di as err as smcl "{bf:cov()} cannot be "	///
		   "combined with {bf:sds()}, {bf:vars()} or {bf:corr()}"
		exit 198
	}
	if ("`sds'"!="" & "`vars'"!="") {
		di as err as smcl "{bf:sds()} and {bf:vars()}" ///
			"cannot be combined"
		exit 198
	}
	tempname m sd V
	mat `m' = J(`q',`p',0)
	mat `V' = I(`p')
	mat `sd' = J(1,`p',1)
	local rc = 0
	if ("`betas'"!="") {
		cap noi IsValidMatrix `m' : "b" "`betas'" `q' `p' `"`name'"'
		local rc = `rc'+ (_rc!=0)
	}
	if ("`cov'"!="") {
		cap confirm number `cov'
		if (_rc==0) {
			mat `V' = `cov'*I(`p')
		}
		else {
			cap noi IsValidMatrix "`V'" : ///
				"cov" "`cov'" `p' `p' `"`name'"' "lower" "matonly"
			local rc = `rc'+ (_rc!=0)
		}
	}
	else {
		if ("`sds'"!="") {
			cap noi IsValidMatrix `sd' : "sds" "`sds'" 1 `p' `"`name'"'
			local rc = `rc'+ (_rc!=0)
		}
		else if ("`vars'"!="") {
			cap noi IsValidMatrix `sd' : "vars" "`vars'" 1 `p' `"`name'"'
			local rc = `rc'+ (_rc!=0)
			mata: st_matrix("`sd'", sqrt(st_matrix("`sd'")))
		}
		if ("`corr'"!="") {
			cap noi IsValidMatrix `V' : ///
				"corr" "`corr'" `p' `p' `"`name'"' "lower"
			local rc = `rc'+ (_rc!=0)
			// make diagonal elements to be 1
			mat `V' = `V' - (`V'[1,1]-1)*I(`p')
		}
		mat `V' = diag(`sd')*`V'*diag(`sd')
	}
	if (`rc') {
		exit 198
	}
	//check that variance-covariance matrix is valid
	mata: st_local("err",strofreal(_isvalidVC("`V'")))
	if (`err') {
		if (`err'==1) {
			di as err ///
			`"`name': specified initial variance-covariance "' ///
			"matrix is not symmetric"
			exit 198
		}
		if (`err'==2) {
			di as err ///
			`"`name': specified initial variance-covariance "' ///
			"matrix is not positive definite"
			exit 198
		}
		if (`err'==3) {
			di as err ///
			`"`name': specified initial variance-covariance "' ///
			"matrix contains missing values"
			exit 198
		}
	}
	ret matrix Beta	 = `m'
	ret matrix Sigma = `V'
end


program IsValidMatrix
	args outmat colon optname opt rows cols name lower matonly

	if ("`matonly'"=="") {
		local ornumber " or number"
		cap confirm number `opt'
		if (_rc==0) {
			mat `outmat' = J(`rows',`cols',`opt')
			exit	
		}
	}
	tempname optval
	cap mat `optval' = `opt'
	if (_rc) {
		di as err as smcl "`name': {bf:`optname'()} must contain " ///
			"matrix`ornumber'"
		exit 198
	}
	mata: st_local("hasmis", strofreal(hasmissing(st_matrix("`optval'"))))
	if (`hasmis') {
		di as err `"`name': {bf:`optname'()} contains missing values "'
		exit 198
	}
	// check dimension
	local dim = `rows'*`cols'
	local c = colsof(`optval')
	local r = rowsof(`optval')
	if "`lower'"=="" & `dim'!=`r'*`c' {
		if ("`optname'"=="b" & `cols'!=1 & `rows'!=1) {
			di as err as smcl ///
				"`name': {bf:`optname'()} must contain " ///
				"vector of dimension `dim' or " 	  ///
				"`rows'x`cols' matrix"
		}
		else {
			di as err as smcl ///
				"`name': {bf:`optname'()} must contain " ///
				"vector of dimension `dim'"
		}
		exit 198
	}
	if (`c'==1 & `r'>`c') { //transpose to be a row vector
		mat `optval' = `optval''
		local c = colsof(`optval')
		local r = rowsof(`optval')
	}
	if ("`optname'"=="b" & `r'==1) {
		mata: 	///
		  st_matrix("`outmat'",colshape(st_matrix("`optval'"),`cols'))
		exit
	}
	if (`r'==`rows' & `c'==`cols') {
		mat `outmat' = `optval'
	}
	else if (`c'==`rows' & `r'==`cols') {
		mat `outmat' = `optval''
	}
	else if ("`lower'"!="") {
		local cols = `cols'*(`cols'+1)/2
		if (`r'==1 & `c'==`cols') {
			// create pxp matrix from a lower triangular matrix
mata: st_matrix(st_local("outmat"),invvech(st_matrix(st_local("optval"))'))
		}
		else {
			di as err as smcl ///
				"`name': {bf:`optname'()} must contain " ///
				"square (or lower triangular) matrix " ///
				"of dimension `rows'"
			exit 198
		}
	}
end

version 11.0
mata:

real scalar _isvalidVC(string scalar matname)
{
/*	0 - ok
	1 - not symmetric
	2 - not positive definite
	3 - has missing values
*/
	if (!issymmetriconly(st_matrix(matname))) {
		return(1)
	}
	if (hasmissing(st_matrix(matname))) return(3)
	if (!all(symeigenvalues(st_matrix(matname)):>0)) {
		return(2)
	}
	return(0)
}

end
exit
