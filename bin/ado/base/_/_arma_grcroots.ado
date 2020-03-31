*! version 1.0.2  27oct2013
program define _arma_grcroots, sclass
	version 13

	syntax  , 				///
		[				///
		amat(string)			///
		armat(string)			///
		arre(name)			///
		arim(name)			///
		armod(name)			///
		mamat(string)			///
		mare(name)			///
		maim(name)			///
		mamod(name)			///
		addplot(string) 		///
		plot(string) 			///
		RLOPts(string)			///
		Dlabel				///
		MODlabel			///
		pgridplots(string)		///
		umod(string)			///
		LEGend(string)			///
		*				///
		]
	
	if "`arre'"!="" & "`mare'"!="" local arma arma
	
	_parse_marker_opts, `arma' `options'
	local aropts `s(aropts)'
	local maopts `s(maopts)'
	
	// parse legend option separately
	local 0 , `legend'
	syntax , [ order(passthru) label(passthru) * ]
	local legopts `options'
	
	if "`arma'"=="arma" {
		local junk : subinstr local pgridplots "function" "", ///
			all count(local n)
		local apos = `n'+3
		local mpos = `n'+4
		if `"`order'"'=="" local order order(`apos' `mpos')
		if `"`label'"'=="" {
			local label label(`apos' "AR roots")
			local label `label' label(`mpos' "MA roots")
		}
		local legend legend(`order' `label' `legopts')
		local aropts `aropts' `legend'
		local s s
	}
	else {
		local aropts `aropts' legend(off)
		local maopts `maopts' legend(off)
	}
	
	if "`arre'"!="" {
		local pre AR
		local ptsplots1 (scatteri 
		local cols = colsof(`arre')
		mata: draworder("`armod'","`arim'","`arre'")
		forvalues i = 1/`cols' {
	
			if "`dlabel'" != "" {
local dist : display %5.3f round(1-`armod'[1,`i'],.001)
local note1 `""Points labeled with their distances from the unit circle""'
			}
			else if "`modlabel'" != "" {
local dist : display %5.3f round(`armod'[1,`i'],.001)
local note1 `""Points labeled with their moduli""'
			}
			local ypt = `arim'[1,`i']
			local xpt = `arre'[1,`i']
	
			local ptsplots1 `"`ptsplots1' `ypt' `xpt' (6) "`dist'""'
		}
		
		local note `"note(`note2' `note1')"'
	
		local ptsplots1 `"`ptsplots1' , `note' `aropts' ) "'
	}
	
	if "`mare'"!="" {
		local pre `pre'MA
		local ptsplots2 (scatteri 
		local cols = colsof(`mare')
		mata: draworder("`mamod'","`maim'","`mare'")
		forvalues i = 1/`cols' {

			if "`dlabel'" != "" {
local dist : display %5.3f round(1-`mamod'[1,`i'],.001)
local note1 `""Points labeled with their distances from the unit circle""'
			}
			else if "`modlabel'" != "" {
local dist : display %5.3f round(`mamod'[1,`i'],.001)
local note1 `""Points labeled with their moduli""'
			}
			local ypt = `maim'[1,`i']
			local xpt = `mare'[1,`i']
			
			local ptsplots2 `"`ptsplots2' `ypt' `xpt' (6) "`dist'" "'
		}
		
		local note `"note(`note2' `note1')"'
		
		local ptsplots2 `"`ptsplots2' , `note' `maopts' ) "'
	}
	
	local b2opts " range(-1 1) lstyle(refline) "
	twoway (function y = sqrt(1-x*x), `b2opts'			///
		subtitle("Inverse roots of `pre' polynomial`s'")	///
		ytitle("Imaginary") xtitle("Real")			///
		xlabel(-1 -.5 0 .5 1, nogrid)				///
		ylabel(-1 -.5 0 .5 1, nogrid)				///
		`rlopts' aspect(1)					/// 
	)								///
	(function y = -1*sqrt(1-x*x), `b2opts' `rlopts' 		///
	) 								///
	`pgridplots'							///
	`ptsplots1'							///
	`ptsplots2'							///
	|| `plot'							///
	|| `addplot'

	sreturn local key_ar `apos'
	sreturn local key_ma `mpos'
	
end

program _parse_marker_opts, sclass
	
	syntax [ , arma Msymbol(string) MColor(string) 			///
		MSIZe(string) MFColor(string) MLColor(string) 		///
		MLWidth(string) MLSTYle(string) MSTYle(string)		///
		PSTYle(string) recast(string) * ]
	
	_get_gropts, graphopts(`options') gettwoway
	local uniqopts `s(twowayopts)'
	local gropts `s(graphopts)'
	
	local opts msymbol mcolor msize mfcolor mlcolor
	local opts `opts' mlwidth mlstyle mstyle pstyle recast
	
	if "`pstyle'"=="" local pstyle p1 p1
	
	foreach o of local opts {
		gettoken ar ma : `o'
		if "`ma'"=="" local ma `ar'
		local aropts `aropts' `o'(`ar')
		local maopts `maopts' `o'(`ma')
	}
	// (revisit mfcolor)
	
	if "`arma'"=="arma" {
		local aropts `aropts' `gropts' `uniqopts'
		local maopts `maopts' `gropts'
		if "`mfcolor'"=="" local maopts `maopts' mfcolor(white)
	}
	else {
		local aropts `aropts' `gropts' `uniqopts'
		local maopts `maopts' `gropts' `uniqopts'
	}
	
	sreturn local aropts `aropts'
	sreturn local maopts `maopts'

end
mata:
void draworder(string scalar mod, string scalar  im, string scalar re) {
	real matrix totmat
 
	totmat = st_matrix(mod)' , st_matrix(im)' , st_matrix(re)' 
	totmat = sort(totmat,(3,2,1))
	st_matrix(mod,totmat[,1]')
	st_matrix(im,totmat[,2]')
	st_matrix(re,totmat[,3]')
}
end
