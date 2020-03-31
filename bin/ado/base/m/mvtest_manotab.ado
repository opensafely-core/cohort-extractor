*! version 1.0.0  23jun2008
/* Program to display manova output in a table for mvtest. */
program mvtest_manotab
	version 11

	args S /* stat_m matrix after manova */

	local title1 "Wilks' lambda"
	local title2 "Pillai's trace"
	local title3 "Lawley-Hotelling trace"
/*                    1234567890123456789012 == 22 */
	local title4 "Roy's largest root"

	tempname Mtab
	.`Mtab' = ._tab.new

	local tabres .`Mtab'.reset, lmargin(5) columns(6)
	local tabwid .`Mtab'.width 23| 10 6 10 10 11
	`tabres'
	`tabwid'
	.`Mtab'.titlefmt %22s %10s %6s %10s %10s %8s
	.`Mtab'.titles "" "Statistic" "   F(df1" ",     df2)" "   =  F   " "   Prob>F"
	.`Mtab'.sep
	.`Mtab'.reset, lmargin(5) columns(7)
	`tabwid' 2
	.`Mtab'.strfmt %22s %9s %6s %10s %10s %8s %2s
	.`Mtab'.numfmt . %9.4f %6.1f %8.1f %8.2f %7.4f .
	.`Mtab'.pad . 1 2 2 2 2 .
	.`Mtab'.strcolor . . . . . . yellow
	forvalues i = 1/4 {
		if `S'[`i',6] == 1 {
			local e e
		}
		else if (`i' < 4) {
			local e a
		}
		else {
			local e u
		}
		.`Mtab'.row "`title`i''" `S'[`i',1] `S'[`i',3] `S'[`i',4] `S'[`i',2] `S'[`i',5] "`e'"
	}
	`tabres'
	`tabwid'
	.`Mtab'.sep, bottom
	.`Mtab'.reset, lmargin(10) columns(1)
	.`Mtab'.width 66
	.`Mtab'.strfmt %66s
	.`Mtab'.row "e = exact, a = approximate, u = upper bound on F"
end
exit

