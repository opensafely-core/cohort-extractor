*! version 1.1.0  09jan2015
program mds_display_classical
	version 10

	syntax [, CONfig Neigen(str) noPLot ]

	if !inlist(`"`neigen'"', "", "max") {
		confirm integer number `neigen'
		if `neigen' < 0 {
			dis as err "invalid neigen()"
			exit 198
		}
	}
	else if `"`neigen'"' == "max" {
		local neigen = e(np)
	}
	else {
		local neigen = 10
	}

// header

	dis _n as txt "Classical metric multidimensional scaling"

	mds_dataheader

	if `e(addcons)' > 0 {
		dis _col(5) as txt "Const. added to D^2  = " ///
		            as res %9.0g  e(addcons) _c
	}
	dis _col(46) as txt "Number of obs        = " ///
	             as res %10.0fc e(N)

	dis _col( 5) as txt "Eigenvalues > 0      = " ///
	             as res %9.0f e(np)               ///
	    _col(46) as txt "Mardia fit measure 1 = " ///
	             as res %10.4f `e(mardia1)'

	dis _col( 5) as txt "Retained dimensions  = " ///
	             as res %9.0f e(p)                ///
	    _col(46) as txt "Mardia fit measure 2 = " ///
	             as res %10.4f `e(mardia2)'

	if "`e(unique)'" == "0" {
		dis _col(5) as txt ///
		    "(solution not unique in " e(p) " dimensions " ////
		    "because of common eigenvalues)"
	}
	
	if "`e(norm)'" == "target" {
		dis _n _col( 5) as txt "Normalization:"          ///
		       _col(46) as txt "Dilation factor      = " ///
		                as res %10.0g el(e(norm_stats),1,2)

		dis    _col( 5) as txt "Procrustes rotation w/target " ///
		                       "`e(targetmatrix)'"             ///
		       _col(46) as txt "Procrustes P         = "       ///
		                as res %10.4f el(e(norm_stats),1,3)
	}	

// tables and plots

	if (`neigen'   >   0)  EigenTable `neigen'
	if ("`config'" != "")  estat config
	if ("`plot'"   == "")  mdsconfig
end


program EigenTable
	args neigen

	tempname csumabs csumsq evabs evsq sumabs sumsq Ev

	local n = min(`neigen', e(np))

	matrix `Ev'  = e(Ev)
	local m = colsof(`Ev')

	scalar `sumabs' = 0
	scalar `sumsq'  = 0
	forvalues i = 1/`m' {
		scalar `sumabs' = `sumabs' + abs(`Ev'[1,`i'])
		scalar `sumsq'  = `sumsq'  + `Ev'[1,`i']^2
	}

	dis
	Hline TT
	dis as txt _col(18) "{c |} " _skip(18)  ///
	    "abs(eigenvalue)          (eigenvalue)^2"
	dis as txt _col(5) "  Dimension  {c |} " ///
		" Eigenvalue      Percent    Cumul.       Percent    Cumul."
	Hline +

	scalar `csumabs' = 0
	scalar `csumsq'  = 0
	forvalues i = 1/`n' {
		scalar `evabs'   = abs(`Ev'[1,`i'])
		scalar `evsq'    = `Ev'[1,`i']^2

		scalar `csumabs' = `csumabs' + `evabs'
		scalar `csumsq'  = `csumsq'  + `evsq'

		dis as txt _col(10) %6.0f `i' "  {c |} "            ///
		    as res _col(21) %10.0g `Ev'[1,`i']              ///
		    as res _col(38) %6.2f 100*(  `evabs'/`sumabs')  ///
			   _col(48) %6.2f 100*(`csumabs'/`sumabs')  ///
			   _col(62) %6.2f 100*(   `evsq'/`sumsq' )  ///
			   _col(72) %6.2f 100*( `csumsq'/`sumsq' )

		if (`i'==e(p) & e(p)<`n')  Hline +
	}
	Hline BT
end

program Hline
	args c

	dis as txt _col(5) "{hline 13}{c `c'}{hline 60}"
end
exit
