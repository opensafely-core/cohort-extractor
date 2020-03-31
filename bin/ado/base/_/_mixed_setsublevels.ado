*! version 1.0.0  26jan2007
program _mixed_setsublevels
	version 9
	args beg end sublevels

	if (`end' < 1)  exit
	forvalues s = `=max(`beg',1)'/`end' {
		matrix `sublevels'[1,`s'] = `end' - `beg' + 1
	}
end

exit
