*! version 1.0.1  16sep2009

program postrtoe, eclass
	version 11

	syntax [name] [, MACro(namelist)    	///
		MATrix(namelist)   		///
		SCAlar(namelist)		///
		noCLEar				///
		RESize				///
		REName				///
		debug ]            		// not documented

	if "`debug'" == "" local c "*"

	if ("`e(cmd)'"=="regress" & "`resize'"!="") {
		di as err "option resize is not allowed with results " _c
		di as err "from regress"
		error 198
	}
	
	if ("`e(cmd)'"=="anova" & "`resize'"!="") {
		di as err "option resize is not allowed with results " _c
		di as err "from anova"
		error 198
	}
	
	// limit prefix to 10 characters
	if length("`namelist'") > 10 {
		di as err "maximum length of prefix is 10 characters"
		error 198
	}
	
	`c' di as err "prefix is: `namelist'"
	
	// check #number of () options specified
	local mac = "`macro'"==""
	local mat = "`matrix'"==""
	local sca = "`scalar'"==""
	local opts = `mac' + `mat' + `sca'
	`c' di as err "number of missing () options: `opts'"
	
	// check for nonexisting matrices
	if ("`matrix'"!="" & "`matrix'"!="_all") {
		foreach i of local matrix {
			capture confirm matrix r(`i')
			if _rc {
				di as err "matrix r(`i') not found"
				error 111
			}
		}
	}
	
	// check for nonexisting scalars
	if ("`scalar'"!="" & "`scalar'"!="_all") {
		foreach i of local scalar {
			capture confirm scalar r(`i')
			if _rc {
				di as err "scalar r(`i') not found"
				error 111
			}
		}
	}
	
	// clear ereturn list
	if "`clear'"=="" {
		ereturn clear
		`c' di as err "ereturn clear"
	}
	
	// get the names of scalars
	if (`opts'==3 | "`scalar'"=="_all") {
		local scalarlist : r(scalars)
	}
	else {
		local scalarlist `scalar'
	}
	`c' di as err "scalar list: `scalarlist'"
	
	// get the names of macros
	if (`opts'==3 | "`macro'"=="_all") {
		local macrolist : r(macros)
	}
	else {
		local macrolist `macro'
	}
	`c' di as err "macro list: `macrolist'"
	
	// get the names of matrices
	if (`opts'==3 | "`matrix'"=="_all") {
		local matrixlist : r(matrices)
	}
	else {
		local matrixlist `matrix'
	}
	`c' di as err "matrix list: `matrixlist'"
	
	// ereturn matrices with optional prefix
	if "`matrixlist'" != "" {
		tempname mymat
		if ("`clear'"!="" & "`namelist'"=="") {
			`c' di as err "do not clear, no prefix -- use " _c
			`c' di as err "ereturn repost"
			local bvc = "ereturn repost"
			foreach i of local matrixlist {
				if "`i'"=="b" {
					tempname bmat
					mat `bmat' = r(`i')
					local b `i'=`bmat'
					local bvc = ""
				}
				else if "`i'"=="V" {
					tempname vmat
					mat `vmat' = r(`i')
					local v `i'=`vmat'
					local bvc = ""
				}
				else if "`i'"=="Cns" {
					tempname cmat
					mat `cmat' = r(`i')
					local cns `i'=`cmat'
					local bvc = ""
				}
				else {		
					mat `mymat' = r(`i')
					ereturn matrix `i' `mymat'
				}
			}
			if ("`bvc'" == "") {
				ereturn repost `b' `v' `cns', `rename' `resize'
			}
		}
		else {
			if "`namelist'"!="" { // no need to post, just ereturn
				foreach i of local matrixlist {
					mat `mymat' = r(`i')
					ereturn matrix `namelist'`i' `mymat'
				}
			}
			else { // must use ereturn post for b, V, and Cns
				local bvc = "ereturn post"
				foreach i of local matrixlist {
					if "`i'"=="b" {
						tempname b
						mat `b' = r(`i')
						local b `b'
						local bvc = ""
					}
					else if "`i'"=="V" {
						tempname V
						mat `V' = r(`i')
						local V `V'
						local bvc = ""
					}
					else if "`i'"=="Cns" {
						tempname Cns
						mat `Cns' = r(`i')
						local Cns `Cns'
						local bvc = ""
					}
				}
	/* ereturn post will clear e() so post b, V, and Cns
		       before processing other matrices, macros, and scalars */
				if ("`bvc'" == "") {
					ereturn post `b' `V' `Cns'
				}
				foreach i of local matrixlist {
					if ("`i'"!="b" /*
                                         */ & "`i'"!="V" & "`i'"!="Cns" ) {
						mat `mymat' = r(`i')
						ereturn matrix `i' `mymat'
					}
				}			
				
			}
		}
	}
	
	// ereturn scalars with optional prefix
	if "`scalarlist'" != "" {
		foreach i of local scalarlist {
			ereturn scalar `namelist'`i' = `r(`i')'
		}
	}
	
	// ereturn macros with optional prefix
	if "`macrolist'" != "" {
		foreach i of local macrolist {
			ereturn local `namelist'`i' `r(`i')'
		}
	}

end
exit


in logical terms:

clear  prefix | result
--------------+--------
  0      0    | repost
  0      1    |   post
  1      0    |   post
  1      1    |   post

(note: clear=0 means "do not clear e() list")


