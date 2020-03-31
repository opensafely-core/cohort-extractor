*! version 1.0.1  16feb2007
* used as "click to run" examples in screeplot.sthlp
program screeplot_help
	version 9
	args cmd

	quietly { 
		preserve
		sysuse auto
		tempname est
		capture _estimates hold `est', restore 

		pca mpg-gear
	}

	`cmd' 
end	
