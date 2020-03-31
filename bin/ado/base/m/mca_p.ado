*! version 1.0.4  21oct2019
program mca_p
	version 10
	
	if ("`e(cmd)'"!="mca") {
		error 301
	}
	local f = e(f)

	ParseNewVars `0'
	local varspec `s(varspec)'
	local mvarlist `s(varlist)'
	local mtyplist `s(typlist)'
	local nvars : word count `varlist'
	local holdif `"`s(if)'"'
	local holdin `"`s(in)'"'
	local options `"`s(options)'"'
	
	local 0 , `options'
	#del ;
	syntax
	[,
		DIMensions(numlist integer max=`f' >=1 <=`f') // doc as dim()
		SCores(name)
		ROWscores
		NORMalize(str)
	];
	#del cr
	local varlist `mvarlist'
	local typlist `mtyplist'
	local if `holdif'
	local in `holdin'

	local score `"`scores'"'
	if `"`rowscores'"' == "" & `"`score'"' == "" {
		local rowscores rowscores
		noi di in green "(option {bf:rowscores} assumed)"
	}

	local dim `dimensions'
	
	local nvar : list sizeof varlist
	if (`nvar'>`f') {
		dis as err "at most `f' scores can be generated"
		exit 198
	}
	
	if ("`score'"!="" & "`rowscores'"!="") {
		dis as err "options {bf:score()} and {bf:rowscores} may not be specified together"
		exit 198
	}
	
	if ("`dim'"=="") {
		forvalues v = 1/`nvar' {
			local dim "`dim' `v'"
		}
	}
	
	if (`"`normalize'"'!="") {
		mca_parse_normalize `"`normalize'"'
		local norm `s(norm)'
	}
	else {
		// normalization during estimation
		local norm `e(norm)'
	}		
	
	marksample touse, novarlist	

	tempname C Coding Coord
	tempvar  g t

// ------------------------------------------------- scores for column variable

if (`"`score'"'!="") {
	local enames `e(names)'
	mca_lookup "`score'" "`enames'"
	local score `s(name)'
	local ip : list posof "`score'" in enames 		
		
	if ("`norm'"=="standard") {
		matrix `Coord' = e(A)
	}
	else {
		matrix `Coord' = e(F)
	}
	matrix `Coord' = `Coord'["`score':", 1...]
	
	matrix `C' = e(Coding`ip')
	qui _applycoding `t' if `touse', coding(`C') `e(missing)'
	if (r(unusedcodes)>0) {
		dis as txt "(unused codes for `score' in current data)"
	}			
	if (r(uncodedobs)>0) {
		dis as txt "(uncodable values for `score' in current data)"
	}
		
	foreach d of local dim {
		gettoken tp typlist : typlist
		gettoken g  varlist : varlist
		gen `tp' `g' = `Coord'[`t',`d'] if `touse'
		label var `g' "`score' score (dim=`d';`norm' norm.)" 	
	}
	exit
}	
	
// ------------------------------------------------------------------ rowscores

if (`"`rowscores'"'!="") {
	local enames `e(names)'
	local esupp  `e(supp)'
	
	local ip = 0
	foreach name of local enames {
		local ++ip
		if (`:list name in esupp') continue
		
		tempvar t`ip'
		local tlist `tlist' `t`ip''
		matrix `C' = e(Coding`ip')
		qui _applycoding `t`ip'' if `touse', coding(`C') `e(missing)'
		if (r(unusedcodes)>0) {
	    		dis as txt "(unused codes for `name' in current data)"
		}			
		if (r(uncodedobs)>0) {
	    		dis as txt "(uncodable values for `name' in current data)"
		}
	}
	
	foreach d of local dim {
		gettoken tp typlist : typlist
		gettoken g  varlist : varlist
		qui gen `tp' `g' = . if `touse'
		mata: RowScores( "`g'", "`touse'", "`tlist'", `d', "`norm'" )
		qui count if missing(`g')
		if (r(N)>0) {
			dis as txt "(" r(N) " missing values generated)"
		}
		label var `g' "rowscore (dim=`d'; `norm' norm.)" 	
	}	
}	
	
end

program ParseNewVars, sclass
	version 9, missing
	syntax [anything(name=vlist)] [if] [in] [, DIMensions(numlist) * ]
	local myif `"`if'"'
	local myin `"`in'"'
	local myopts `"`options'"'
	local dim `dimensions'

	if `"`vlist'"' == "" {
		di as err "{it:varlist} required"
		exit 100
	}
	local varspec `"`vlist'"'
	local stub 0
	if index("`vlist'","*") {
		if "`dim'" == "" {
			local neq = e(f)
			local mydim dim(1/`neq')
		}
		else {
			local neq : word count `dim'
			local mydim dim(`dim')
		}
		_stubstar2names `vlist', nvars(`neq')
		local varlist `s(varlist)'
		local typlist `s(typlist)'
		confirm new var `varlist'
	}
	else {
		syntax newvarlist [if] [in] [, * ]
		if `"`dim'"' != "" {
			local mydim dim(`dim')
		}
	}
	local nvars : word count `varlist'

	sreturn clear
	sreturn local varspec `varspec'
	sreturn local varlist `varlist'
	sreturn local typlist `typlist'
	sreturn local if `"`myif'"'
	sreturn local in `"`myin'"'
	sreturn local options `"`myopts' `mydim'"'
end

// ----------------------------------------------------------------------------

mata:

void RowScores( string scalar _g, string scalar _touse, string scalar _tlist,
	real scalar d, string scalar norm )
{
	real   scalar     i, j, scale
	real   colvector  g
	real   rowvector  cj, coding, indx, lam, z
	real   matrix     rSCW, T, SCW 	
	
	rSCW = st_matrix("e(rSCW)")
	assert(d>=1 & d<=cols(rSCW))
	SCW = rSCW[.,d]
	st_view(g=., ., _g,             _touse)
	st_view(T=., ., tokens(_tlist), _touse)
	coding = indx = J(1,0,.)
	for (j=1; j<=cols(T); j++) {
		cj = st_matrixrowstripe("e(Coding" + strofreal(j) + ")")'
		coding = coding , strtoreal(cj[2,.])
		indx   = indx   , J(1,cols(cj),j)
	}

	if (norm == "principal") {
		lam = st_matrix("e(Ev)")
		scale = sqrt(lam[d])
	}
	else {
		scale = 1
	}

	// generate row coordinates
	for (i=1; i<=rows(T); i++) {
		z = T[i,indx]:==coding
		g[i] = scale*(z:/sum(z))*SCW	
	}
}

end
exit
