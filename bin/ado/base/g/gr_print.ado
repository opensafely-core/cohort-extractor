*! version 1.0.1  14feb2005
program gr_print
	version 9

	local baseopts			///
			NAME(passthru)		///
			LOGO(passthru)		///
			TMargin(passthru)	///
			LMargin(passthru)

	if c(os)=="Unix" {
		local UnixOpts 			///
			FONTface(passthru)	///
			ORientation(passthru) 	///
			PAGESize(passthru)	///
			PAGEHeight(passthru)	///
			PAGEWidth(passthru)	
	}

	syntax [, `baseopts' `unixopts']

	print @Graph, `name' `logo' `tmargin' `lmargin' ///
		      `orientation' `pagesize' `pageheight' `pagewidth'
end
