*! version 1.0.1  20jan2015
program nlogit_estat
	version 10

	if "`e(cmd)'"!="nlogit" {
		di as err "{help nlogit##|_new:nlogit} estimation " ///
		 "results not found"
		exit 301
	}

	gettoken sub rest: 0, parse(" ,")

	local lsub = length("`sub'")
	if "`sub'" == bsubstr("alternatives",1,max(3,`lsub')) {
		if "`rest'" != "" {
			di as error "invalid syntax"
			exit 198
		}
		Alternatives
	}
	else estat_default `0'
end

program Alternatives

	local nlv1 = e(levels)-1
	forvalues i=1/`nlv1' {
		AlternTable `i'
	}
	AlternTable
end

program AlternTable
	args idx

	di _n as text `"{col 4}Alternatives summary for `e(altvar`idx')'"'
	tempname table
	.`table'  = ._tab.new, col(6)
	.`table'.width |10 11 18|11 11 11|
	.`table'.sep, top
	.`table'.strcolor . . yellow . . .
	.`table'.numcolor yellow yellow . yellow yellow yellow
	.`table'.numfmt %7.0g %9.0g . %10.0g %10.0g %10.2f
	.`table'.strfmt . %39s . %6s . .
	.`table'.titles "" "Alternative" "" "Cases " "Frequency" "Percent"
	.`table'.titles "index  " "value" "label" "present" "selected" ///
		"selected"
	.`table'.sep, mid
	
	if ("`idx'"!="") local u _
	local nalt = rowsof(e(stats`idx'))
	forvalues i=1/`nalt' {
		local label = abbrev("`e(alt`idx'`u'`i')'",17)
		.`table'.row `i' el(e(stats`idx'),`i',1) "`label'"       ///
		 	el(e(stats`idx'),`i',2) el(e(stats`idx'),`i',3)  ///
			100*el(e(stats`idx'),`i',4)
	}
	.`table'.sep,bot
end
	
exit
