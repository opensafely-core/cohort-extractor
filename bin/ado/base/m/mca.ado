*! version 1.3.2  09sep2019
program mca, eclass byable(onecall)
	version 10

	if (replay()) {
		if (_by()) {
			error 190
		}
		if ("`e(cmd)'"!="mca") {
			error 301
		}
		Display `0'
		exit
	}

	if (_by()) {
		local By "by `_byvars'`_byrc0':"
	}
	`By' Estimate `0'
	ereturn local cmdline `"mca `0'"'

	foreach v of global mca_dropvars {
		capt drop `v'
		capt label drop `v'
	}
	global mca_dropvars
end


program Estimate, eclass byable(recall)
	#del ;
	syntax  anything  [if] [in] [fw]
	[,
		REPort(passthru)
		LENgth(passthru)
		MISSing
		DIMensions(numlist max=1)
		NORMalize(str) // norm(pr) norm(st) documented to agree with ca
		SUPplementary(str)
	        METHod(str)
	        noADJust
	        LOg
		ITERate(numlist integer max=1 >0)
		TOLerance(numlist max=1 >0)
	        DDIMensions(passthru)
		POInts(passthru)
		COMPact
		PLOt
		MAXlength(passthru)
	] ;
	#del cr

	if strpos("`anything'",":") == 0 { 
		unab anything : `anything'
	}

	tempname active Coding coding nCat wvar Mnames

// parsing ---------------------------------------------------------------------

	local dim `dimensions'
	if "`dim'" != "" {
		capture confirm integer number `dim'
		local rc = _rc
		capture assert `dim' > 0
		local rc = `rc' + _rc
		if `rc' {
			di as err "dimensions() must be a positive integer"
			exit 198
		}
	}

	mca_parse_normalize `normalize'
	local norm `s(norm)'

	Parse_method `method'
	local method `s(method)'
	local methopt method(`method')
	CheckOpt `method' "[no]log"     `"`log'"'
	CheckOpt `method' "iterate()"   `"`iterate'"'
	CheckOpt `method' "tolerance()" `"`tolerance'"'

	if ("`dim'"      =="") local dim       2
	if ("`iterate'"  =="") local iterate   250
	if ("`tolerance'"=="") local tolerance 1E-5
	local Adjust = "`adjust'"==""
	if "`method'" != "burt" & "`adjust'"=="noadjust" {
		di as err "noadjust only valid with method(burt)"
		exit 198
	}
	local Log    = "`log'"   !=""

	local disp_opts `ddimensions' `points' `compact' `plot' `maxlength'

// sample ----------------------------------------------------------------------

	if ("`weight'"!="") {
		qui gen double `wvar' `exp'
	}
	else 	gen byte `wvar' = 1
	local sweight "`weight'"
	local sexp `"`exp'"'

	if ("`missing'"!="") {
		local keyword keyword
		local msopt novarlist
	}
	marksample touse, `msopt' strok

// parse variable specifications -----------------------------------------------

	local signvars  // all variables used
	local names     // names used by mca to refer to variables
	local defs      // crossing definitions, separated by slash (/)

	local i       = 0
	local crossed = 0
	gettoken term anything: anything, match(parens)
	while (`"`term'"'!="") {
		local ++i
		if ("`parens'"!="") {
			// (1) parenthesized term : (newvar: varlist, *)
			gettoken newvar spec : term, parse(" :")
			gettoken tok vlist   : spec, parse(" :")
			if (`"`tok'"'!=":") {
				dis as err "spec `i' invalid; colon expected"
				exit 198
			}
			local crossed  = 1
			local exist`i' = 0

			local 0 `newvar'
			syntax newvarname
			local name`i' `varlist'
			if "`holdsupp'" != "" {
				local supp `supp' `name`i''
			}
			else {
				local actvar `actvar' `name`i''
			}
			tempvar usevar`i'
			local usenames `usenames' `usevar`i''

			local 0 `vlist'
			syntax varlist(numeric) [,*]

			local defvar`i'  `usevar`i''
			local defvars`i' `varlist'
			local defopts`i' `options'

			local nv : list sizeof varlist
			if ("`missing'" == "") markout `touse' `defvars`i''
			local signvars `signvars' `varlist'
			local names `names' `name`i''
			if (`i'==1) {
				local defs `defvars1'
			}
			else 	local defs `defs' / `defvars`i''
		}
		else if (`"`term'"'!="") {
			// (2) varlist
			local 0 `term'
			syntax varlist(numeric)
			tokenize `varlist'
			local --i
			while "`1'" != "" {
				local ++i
				local exist`i' = 1
				local usevar`i'  `1'
				local defvars`i' `1'
				if ("`missing'" == "") 			///
					markout `touse' `usevar`i''
				local signvars `signvars' `1'
				local usenames `usenames' `usevar`i''
				local names `names' `usevar`i''
				if "`holdsupp'" !="" {
					local supp `supp' `usevar`i''
				}
				else {
					local actvar `actvar' `name`i''
				}
				if (`i'==1) {
					local defs `defvars1'
				}
				else 	local defs `defs' / `defvars`i''
				macro shift
			}
		}
		gettoken term anything: anything, match(parens)
		if "`term'" == "" {
			local anything `supplementary'
			local holdsupp `supplementary'
			local supplementary
			gettoken term anything: anything, match(parens)
		}
	}
	local nvar = `i'

	if (`nvar'<2) {
		dis as err "too few variables specified"
		exit 102
	}
	if ("`:list dups names'" != "") {
		if "`supp'" =="" {
			dis as err "duplicates found among the MCA variables"
		}
		else {
			dis as err ///
		   "duplicates found among the MCA and supplementary variables"
		}
		exit 198
	}
	if ("`:list dups signvars'" != "") {
		dis as txt "(duplicates among the crossing variables)"
	}

	qui summ `touse' `wght', meanonly
	local N = r(sum)
	if (`N' <= 1) error 2001

// create crossed variables ----------------------------------------------------

	local vars // actual variables used by MCA
	global mca_dropvars
	forvalues i = 1/`nvar' {
		tempname Coding`i'
		if (!`exist`i'') {
			tempvar  u`i'
			_mkcross `defvars`i'' if `touse', `missing' 	///
			    gen(`usevar`i'') genname(`name`i'')		///
			    coding(`Coding`i'') sep("/")  `keyword' 	///
			    `report' `length' `defopts`i''

			local vars `vars' `usevar`i''
			global mca_dropvars $mca_dropvars `usevar`i''
		}
		else {
			// get coding matrix
			qui tab `usevar`i'' if `touse', ///
			   matrow(`Coding`i'') `missing'

			// add row/column names
			matrix colnames `Coding`i'' = `usevar`i''
			local ncat = rowsof(`Coding`i'')
			numlist "1/`ncat'"
			matrix rownames `Coding`i'' = `r(numlist)'

			local vars `vars' `usevar`i''
		}
	}

// supplementary variables -----------------------------------------------------
/*
	if ("`supplementary'" != "") {
		local notfound : list supplementary - names
		if "`notfound'" != "" {
			dis as err ///
			    "supplementary() invalid: `notfound' not found"
			exit 198
		}
		local actvar : list names - supplementary
		if `:list sizeof actvar' < 2 {
			dis as err "at least two active variables required"
			exit 102
		}
		local supp supp(`supplementary')
	}
*/
	local supplementary `supp'
	local supp supp(`supp')
// run, possibly with -by-, stacked variables created on pooled data -----------

	GetCoding `vars' if `touse', usenames(`usenames') names(`names') ///
							`supp' `missing'
	matrix `nCat'   = r(nCat)
	matrix `coding' = r(coding)
	matrix `active' = r(active)
	matrix `Mnames' = r(names)
	// Compute in Mata; results are returned in e()
	mata: _mca("`coding'", "`Mnames'", "`nCat'", "`active'", "`touse'", ///
		  "`wvar'", `dim', "`norm'", "`method'", `Adjust', `Log',  ///
		  `iterate', `tolerance' )

// save stuff on data preprocessing in e() ---------------------

	ereturn repost, esample(`touse')

	ereturn local names `names'
	ereturn local supp `supplementary'
	ereturn local defs `defs'
	ereturn local missing `missing'
	ereturn local crossed `crossed'
	forvalues i = 1/`nvar' {
		ereturn matrix Coding`i' = `Coding`i''
	}
	ereturn scalar N = `N'
	ereturn local wtype `"`sweight'"'
	ereturn local wexp `"`sexp'"'
	ereturn local predict mca_p
	ereturn local estat_cmd mca_estat
	ereturn local method "`method'"
	ereturn local title "Multiple/Joint correspondence analysis"
	ereturn local marginsnotok _ALL
	ereturn local cmd mca

	foreach v of global mca_dropvars {
		capt drop `v'
		capt label drop `v'
	}
	global mca_dropvars

// and display ...

	Display , `disp_opts'
end


program Parse_method, sclass
	local 0 ,`0'
	syntax [, Burt Indicator Joint ]

	local meth `burt' `indicator' `joint'
	local nmeth : list sizeof meth
	if (`nmeth' > 1) {
		dis as err "method() invalid"
		dis as err "Burt, indicator, and joint are exclusive"
		exit 198
	}
	else if (`nmeth'==0) {
		local meth burt
	}

	sreturn clear
	sreturn local method `meth'
end


program CheckOpt
	args method optname optval

	if ("`method'"!="joint" & `"`optval'"'!="") {
		dis as err "option `optname' allowed only with method(joint)"
		exit 198
	}
end


program LabelList, rclass
	args v RV

	forvalues i = 1/`=rowsof(`RV')' {
		local val = `RV'[`i',1]
		local ll : label (`v') `val'
		if (`val'==.) {
			local ll sysmiss
		}
		else if ((`val'>.) & (string(`val')=="`ll'")) {
			// extended missing, not value labeled
			local ll = "dot" + bsubstr(`"`ll'"',2,1)
		}
		else {
			local ll : subinstr local ll `" "' `"_"', all
			local ll : subinstr local ll `"""' `""' , all
			local ll : subinstr local ll `"."' `""' , all
			local ll = usubstr(`"`ll'"',1,32)
		}
		local lab `lab' `ll'
	}
	return local lab `lab'
end


program GetCoding, rclass
	syntax  varlist(numeric min=2) if, ///
	  usenames(namelist) names(namelist) [ supp(namelist) MISSing ]

	tempname active C Ci nC N CiN

	local nvar : list sizeof varlist
	tokenize `varlist'

	matrix `nC' = J(1,`nvar',0)
	matrix rownames `nC' = ncat
	matrix colnames `nC' = `usenames'

	matrix `active' = J(1,`nvar',1)
	matrix rownames `active' = active
	matrix colnames `active' = `names'

	forvalues i = 1/`nvar' {
		local usenamei : word `i' of `usenames'
		local namei : word `i' of `names'

		// all variables should be integer valued
		capture assert ``i'' == round(``i'') `if'
		if (_rc) {
			dis as err "`usenamei' is not integer valued"
			exit 198
		}
		qui tab ``i'' `if', `missing' matrow(`Ci')
		if (rowsof(`Ci')==1) {
			dis as err "`usenamei' does not vary"
			exit 198
		}
		matrix `nC'[1,`i'] = rowsof(`Ci')

		LabelList ``i'' `Ci'
		matrix rownames `Ci' = `r(lab)'
		matrix roweq    `Ci' = `usenamei'
		matrix `CiN' = `Ci'
		matrix roweq `CiN' = `namei'

		matrix `C' = nullmat(`C') \ `Ci'
		matrix `N' = nullmat(`N') \ `CiN'

		if (`:list namei in supp') {
			matrix `active'[1,`i'] = 0
		}
	}

	return matrix nCat   = `nC'
	return matrix coding = `C'
	return matrix names = `N'
	return matrix active = `active'
end


program Display
	#del ;
	syntax [, DDimensions(numlist max=1)
		  POInts(namelist)
		  COMPact
		  PLOt
		  MAXlength(passthru) ] ;
	#del cr

	local ddim `ddimensions'
	if "`ddim'" != "" {
		capture confirm integer number `ddim'
		local rc = _rc
		capture assert `ddim' > 0
		local rc = `rc' + _rc
		if `rc' > 0 {
			di as err "ddimensions() must be a positive integer"
			exit 198
		}
	}

	if ("`ddim'" == "") {
		local ddim = colsof(e(Ev))
	}
	else {
		local ddim = min(`ddim',colsof(e(Ev)))
	}
	if ("`points'"!="") {
		foreach word of local points {
			capture confirm variable `word'
			if _rc==0 {
				unab word : `word'
			}
			local points2 `points2' `word'
		}
		local points `points2'
		local enames `e(names)'
		local diff : list points - enames
		if "`diff'" != "" {
			dis as err "points() invalid: `diff' not found"
			exit 198
		}
	}

	if ("`e(converged)'"=="0") {
		dis _n as txt "(Warning: JCA convergence not achieved)"
	}
	if (!e(ev_unique)) {
		dis _n as txt "(Warning: eigenvalues not distinct)"
	}

	if ("`e(method)'" == "burt") {
		if ("`e(adjust)'"=="1") {
			local mtitle "Burt/adjusted inertias"
		}
		else	local mtitle "Burt/unadjusted inertias"
	}
	else if ("`e(method)'" == "joint") {
		local mtitle "Joint (JCA)"
	}
	else	local mtitle "Indicator matrix"

	dis _n       as txt "`e(title)'" ///
	    _col(48) as txt "Number of obs     = " as res %10.0fc e(N)
	dis _col(48) as txt "Total inertia     = " as res %10.0g e(inertia)
	dis _col( 5) as txt "Method: " as res `"`mtitle'"' ///
	    _col(48) as txt "Number of axes    = " as res %10.0fc `e(f)'

	tempname cum GS

	scalar `cum' = 0
	dis
	dis as txt _col(7) "          {c |}   principal               cumul "
	dis as txt _col(7) "Dimension {c |}    inertia     percent   percent"
	dis as txt _col(5) "{hline 12}{c +}{hline 34}"
	forvalues i = 1/`ddim' {
		scalar `cum' = `cum' + el(e(inertia_e),1,`i')
		dis as txt _col( 4) "{ralign 12:dim `i'} {c |}"  ///
		    as res _col(21) %9.0g  el(e(Ev),1,`i')   ///
		           _col(33) %7.2f  el(e(inertia_e),1,`i')  ///
		           _col(44) %7.2f  `cum'
	}
	dis as txt _col( 5) "{hline 12}{c +}{hline 34}"
	dis as txt _col( 5) "{ralign 11:Total} {c |}"  ///
		    as res _col(21) %9.0g  e(inertia)  ///
		    _col(33) %7.2f  100


	matrix `GS' = e(cGS)
	if ("`points'"!="") {
		tempname GSc GSi
		foreach name of local points {
			matrix `GSi' = `GS'["`name':",.]
			matrix `GSc' = nullmat(`GSc') \ `GSi'
		}
		matrix `GS'= `GSc'
	}

	mata: st_replacematrix("`GS'",editmissing(st_matrix("`GS'"),.z))
	if ("`compact'"=="") {
		local title "{help ca_statistics##|_new:Statistics} for column categories in `e(norm)' normalization"
		Table `GS' "`title'"
	}
	else {
		local title "{help ca_statistics##|_new:Statistics} (x1000) for column categories in `e(norm)' normalization"
		mata: mca_ctable("`GS'","`title'")
	}
	local nsupp: word count `e(supp)'
	if (`nsupp') {
		local vars = plural(`nsupp',"variable")
		dis as txt "{p 4 6 2}supplementary `vars': `e(supp)'{p_end}"
	}
	dis

	if ("`plot'"!="") {
		mcaplot, `maxlength'
	}
end


program Table
	args X title

	tempname Z
	matrix `Z' = `X'
	local ceq : coleq `Z'
	local ceq : subinstr local ceq "dim" "dimension_", all
	matrix coleq `Z' = `ceq'

	dis _n as txt "`title'"
	matlist `Z', left(4) format(%7.3f) rowtitle(Categories) ///
	   border(bottom) showcoleq(combine) keepcoleq underscore nodotz
end


mata:

void mca_ctable(string scalar _GS, string scalar _title)
{
	real scalar f, i, j, ilow, ihigh, k, ncol
	real matrix X
	string req, reqold
	string matrix X_stripe

	printf("\n{txt}%s\n", _title)

	X = st_matrix(_GS)
	X_stripe = st_matrixrowstripe(_GS)
	f = (cols(X)/3)-1

	ncol = floor((st_numscalar("c(linesize)")-17)/20)
	ihigh = 0
	for (ilow=0; ilow<=f; ilow=ihigh+1)
	{
		ihigh = min((ilow+ncol-1,f))

		printf("\n    {hline 13}")
		for (j=ilow; j<= ihigh; j++)
			if (j == 0)
				printf("{c TT}{hline 5} overall {hline 6}")
			else
				printf("{c TT}{hline 3} dimension %f {hline %f}", j, 2+(j<10))

		printf("\n{txt}       Categories")
		for (j=ilow; j<=ihigh; j++)
			if (j == 0)
				printf("{c |}  mass qualt %%inert ")
			else
				printf("{c |} coord sqcor contr ")
		printf("\n")

		req = reqold = ""
		for (i=1; i<=rows(X); i++) {
			req = X_stripe[i,1]
			if (req != reqold) {
				printf("{txt}    {hline 13}")
				printf("{txt}{c +}{hline 20}")
				for (j=ilow + 1; j<=ihigh; j++) 
					printf("{txt}{c +}{hline 19}")
				printf("\n")

				printf("{res}    {lalign 12:%s} ",
							udsubstr(req,1,12))
				printf("{txt}{c |}{space 20}")
				for (j=ilow+1; j<=ihigh; j++)
					printf("{txt}{c |}{space 19}")
				printf("\n")
				reqold = req
			}

			printf("{txt}    {ralign 12:%s}",
				subinstr(udsubstr(X_stripe[i,2],1,12),"_"," "))
			for (j=ilow; j<=ihigh; j++) {
				printf(" {txt}{c |}{res}")
				if (j!=ilow) {
					for (k=1; k<=3; k++)
						if (X[i,3*j+k] != .z)
							printf("%6.0f", 1000*X[i,3*j+k])
						else
							printf("      ")
				}
				else {
					for (k=1; k<=2; k++)
						if (X[i,3*j+k] != .z)
							printf("%6.0f", 1000*X[i,3*j+k])
						else
							printf("      ")
					k = 3
					if (X[i,3*j+k] != .z)
						printf("%6.0f ", 1000*X[i,3*j+k])
					else
						printf("       ")
				}
			}
			printf("\n")
		}

		printf("{txt}    {hline 13}")
		printf("{txt}{c BT}{hline 20}")
		for (j=ilow+1;  j<=ihigh; j++)
			printf("{txt}{c BT}{hline 19}")
		printf("\n")
	}
}
end
exit
