*! version 1.0.1  16feb2007
* used as "click to run" example in scoreplot.sthlp
program scoreplot_help
	version 9
	args cmd

	quietly { 
		preserve
		sysuse auto
		tempname est
		capture _estimates hold `est', restore 

		pca price trunk rep78 head disp gear, comp(3)
	}

	`cmd'
end
