*! version 1.0.3  23jan2015
program mlogit_footnote
	version 9
	local base = trim(usubstr(`"`e(baselab)'"',1,c(namelenchar)))
	di as txt `"(`e(depvar)'==`base' is the base outcome)"'
end
exit
