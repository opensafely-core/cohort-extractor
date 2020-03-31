*! version 1.0.3  07mar2005
program define _vec_grcroots, 
	version 8.2

	syntax  , 				///
		re(name)			///
		im(name)			///
		mod(name)			///
		[				///
		addplot(string) 		///
		plot(string) 			///
		RLOPts(string)			///
		Dlabel				///
		MODlabel			///
		pgridplots(string)		///
		vec				///
		umod(string)			///
		*				///
		]

	if "`vec'" != "" {
		local roots = `umod'
		if `roots' > 1 {
			local mods moduli
		}
		else {
			local mods modulus
		}

local note2 `""The VECM specification imposes `roots' unit `mods'""'

	}

	local ptsplots (scatteri 
	local cols = colsof(`re')
	forvalues i = 1/`cols' {

		if "`dlabel'" != "" {
local dist : display %5.3f round(1-`mod'[1,`i'],.001)
local note1 `""Points labeled with their distances from the unit circle""'
		}
		else if "`modlabel'" != "" {
local dist : display %5.3f round(`mod'[1,`i'],.001)
local note1 `""Points labeled with their moduli""'
		}
		local ypt = `im'[1,`i']
		local xpt = `re'[1,`i']

		local ptsplots `"`ptsplots' `ypt' `xpt' (6) "`dist'" "'
	}

	local note `"note(`note2' `note1')"'

	local ptsplots `"`ptsplots' , pstyle(p1) `note' `options' ) "'	
	local b2opts " range(-1 1) lstyle(refline) "
	twoway (function y = sqrt(1-x*x), `b2opts'			///
		subtitle("Roots of the companion matrix")		///
		legend(off) ytitle("Imaginary") xtitle("Real")		///
		xlabel(-1 -.5 0 .5 1, nogrid)				///
		ylabel(-1 -.5 0 .5 1, nogrid)				///
		`rlopts' aspect(1)					/// 
	)								///
	(function y = -1*sqrt(1-x*x), `b2opts' `rlopts' 		///
	) 								///
	`pgridplots'							///
	`ptsplots'							///
	|| `plot'							///
	|| `addplot'							

end
