*! version 1.3.2  13mar2019
program _xtme_estat
	version 9
	gettoken sub rest: 0, parse(" ,")
	local lsub = length(`"`sub'"')
	if `"`sub'"' == "icc" {
		_estat_icc `rest'
		exit
	}
	if `"`sub'"' == "sd" {
		SD `rest'
		exit
	}
	if `"`sub'"' == bsubstr("group",1,max(2,`lsub')) {
		local type group
	}
	else if `"`sub'"' != bsubstr("recovariance",1,max(5,`lsub')) {
		estat_default `0'
		exit
	}

	if "`type'" == "group" {
		gettoken comma rest : rest, parse(",")
		if `"`comma'"' != "" {
			if `"`rest'"' != "" | `"`comma'"' != "," {
di as err "{p 0 4 2}options not allowed with subcommand group{p_end}"
			  exit 198
		 	}
		}
		`e(cmd)', grouponly
		exit
	}
	Covariance `rest'
end

program SD
	syntax [, verbose post COEFLegend SELegend VARiance *]

	if "`variance'" != "" {
		di as err "option {bf:variance} not allowed"
		exit 198
	}
	if "`verbose'" == "" local fix nofetable
	if "`post'" != "" local fix
	
	if "`post'" == "" {
		local legend `coeflegend' `selegend'
		if "`legend'" != "" {
			local 0 `", `legend'"'
			syntax [, NULLOP]
			exit 198	// [sic]
		}
		`e(cmd)', stddev noheader nogroup nolrtest `fix' `options'
		_gsem_ret_sd
	}
	else {
		_gsem_eret_sd
		_coef_table, `coeflegend' `selegend'
	}
end

program Covariance, rclass
	
	local is_qr = inlist("`e(cmd)'","mixed","meqrlogit","meqrpoisson")
	if `is_qr' local lev_opt RELEVel
	else local lev_opt Level

	syntax [, CORRelation `lev_opt'(string) TITle(string) noREDIM *]

	local eredim = "`e(redim)'" != ""
	if `eredim' {
		local dim1 : word 1 of `e(redim)'
		local eredim = !`dim1'
	}
	if "`redim'" == "" local recheck `"| `eredim'"'

	if "`correlation'" != "" {
		local ctype correlation
	}
	else {
		local ctype covariance
	}
	tempname v

	if `"`title'"' == "" {
		local mytitle mytitle
		local t1 Random-effects `ctype' matrix for level 
	}

	local ivars `e(ivars)'
	local ivars : list uniq ivars
	if "`ivars'" == "" `recheck' {
		if "`e(cmd)'" == "xtmixed" | "`e(cmd)'" == "mixed" {
			local rrtype linear
		}
		else {
			local rrtype `e(model)'
		}
		di as err `"{p 0 4 2}model is `rrtype' regression;"'
		di as err " no random effects{p_end}"
		exit 459
	}
	
	local c Cov
	if "`ctype'" == "correlation" {
		local c Corr
	}
	local c_hid = lower("`c'")
	
	local level `level' `relevel'
	tempname m0
	
	if `"`level'"' != "" {
                if `"`level'"' != "_all" {
                        if `:word count `level'' != 1 {
                          di as err "{p 0 4 2}invalid `lev_opt'() specification"
                          di as err "{p_end}"
                          exit 198
                        }
                        unab level : `level'
                }
                if `:list posof `"`level'"' in local ivars' == 0 {
                        di as err `"{p 0 4 2}`level' is not a level variable "'
                        di as err "in this model{p_end}"
                        exit 198
                }
		GetLevelMat `level' `v' `ctype'
		local rflag = r(rflag)
		if `rflag' local Rname = r(Rname)
		if `"`mytitle'"' != "" {
			local title `t1' {res:`level'}
		}
		if(colsof(`v') > 1 | rowsof(`v') > 1 | !missing(`v'[1,1])) {
			matlist `v', `options' title(`"`title'"')
			if `rflag' RflagNote `Rname'
			return matrix `c' = `v'
			mat `m0' = return(`c')
			return hidden matrix `c_hid' = `m0'
		}
	}
	else {
		local i 1
		foreach lev of local ivars {
			GetLevelMat `lev' `v' `ctype'
			local rflag = r(rflag)
			if `rflag' local Rname = r(Rname)
			if `"`mytitle'"' != "" {
				local title `t1' {res:`lev'}
			}
			if(colsof(`v') > 1 | rowsof(`v') > 1 | ///
			    !missing(`v'[1,1])) {
				matlist `v', `options' title(`"`title'"')
				if `rflag' RflagNote `Rname'
				local ++i
				local m `c'`i'
				return matrix `m' = `v'
			}
		}
		mat `m0' = return(`m')
		return hidden matrix `c_hid' = `m0'
		return scalar relevels = `i'
	}
		
end

program GetLevelMat, rclass
	args level v ctype

	local ivars `e(ivars)'
	local uivars : list uniq ivars
	local eqnum : list posof "`level'" in uivars
	local revars `e(revars)'
	local w : word count `ivars'
	local subeq 0
	local sdim 0
	forval i = 1/`w' {
		local lev : word `i' of `ivars'
		local dim : word `i' of `e(redim)'
		local type : word `i' of `e(vartypes)'
		if "`lev'" == "`level'" {
			local ++subeq	
			local types `types' `type'
			local nlev `dim'
			local rflag 0
			forval j = 1/`dim' {
				gettoken var revars : revars

				// Deal with factor variable
				if (strpos("`var'", "R.") & ///
				    "`type'"=="Exchangeable") {
					local nlev 2
					local Rname :subinstr local var "R." ""
					local var Ri.`Rname' Rj.`Rname'
					local rflag 1
				} 

				local cnames `cnames' `var'
			}
			local dims `dims' `nlev'
			local sdim = `sdim' + `nlev'
		}
		else {
			forval j = 1/`dim' {
				gettoken var revars : revars    //consume	
			}
		}	
	}
	if `sdim' {
		mat `v' = I(`sdim')
		local start 1
		forval i = 1/`subeq' {
			tempname v1 
			gettoken type types : types
			gettoken dim dims : dims
			GetSubLevelMat `eqnum' `i' `dim' `type' `v' `start'
			local start = `start' + `dim'
		}
		local cnames : subinstr local cnames "." "_", all
		mat colnames `v' = `cnames'
		mat rownames `v' = `cnames'
		if "`ctype'" == "correlation" {
			mat `v' = corr(`v')
		}
	}
	else {
		mat `v' = J(1,1,.)
	}
	return scalar rflag = `rflag'
	if `rflag' return local Rname `Rname'
end

program GetSubLevelMat
	args lev sub dim type v start

	local lns lns`lev'_`sub'
	local atr atr`lev'_`sub'
	if "`type'" == "Identity" {
		forval i = `start'/`=`start'+`dim'-1' {
			mat `v'[`i',`i'] = exp(2*[`lns'_1]_cons)
		}	
		exit
	}
	else if "`type'" == "Exchangeable" {
		forval i = `start'/`=`start'+`dim'-1' {
			mat `v'[`i',`i'] = exp(2*[`lns'_1]_cons)
			forval j = `=`i'+1'/`=`start'+`dim'-1' {
				mat `v'[`i',`j'] = ///
				  tanh([`atr'_1_1]_cons)*exp(2*[`lns'_1]_cons)
				mat `v'[`j',`i'] = `v'[`i',`j']
			}
		}
		exit
	}
	else if "`type'" == "Independent" {
		local k 1
		forval i = `start'/`=`start'+`dim'-1' {
			mat `v'[`i',`i'] = exp(2*[`lns'_`k']_cons)
			local ++k
		}
		exit
	}
	else {			// Unstructured
		local k 1
		forval i = `start'/`=`start'+`dim'-1' {
			mat `v'[`i',`i'] = exp(2*[`lns'_`k']_cons)
			local m = `k' + 1
			forval j = `=`i'+1'/`=`start'+`dim'-1' {
				mat `v'[`i',`j'] = ///
				       tanh([`atr'_`k'_`m']_cons)* ///
				       exp([`lns'_`k']_cons + ///
					   [`lns'_`m']_cons)
				mat `v'[`j',`i'] = `v'[`i',`j']
				local ++m
			}
			local ++k
		}
		exit
	}
end

program RflagNote
	args Rname
	di 
	di as txt "{p 0 6 2}Note: Ri and Rj denote any two levels of the " ///
		"factor {cmd:`Rname'}.{p_end}"
end

exit
