*! version 1.0.2  13sep2000
program define svy_head /* display header */
	version 6
	args nobs nstr npsu npop osub nsub wgt exp strata psu fpc /*
	*/   subpop subexp dash

	if "`wgt'"    == "" { local wgt    "pweight"        }
	if "`exp'"    == "" { local exp    "<none>"         }
	if "`strata'" == "" { local strata "<one>"          }
	if "`psu'"    == "" { local psu    "<observations>" }

	if "`dash'"!="" { di  in smcl _n in gr "{hline 78}" }
	else di /* newline */

	#delimit ;
	di in gr "`wgt':" _col(11) "`exp'"
	   in gr _col(49) "Number of obs" _col(68) "= "
	   in ye %9.0f `nobs' _n
	   in gr "Strata:" _col(11) "`strata'"
	   in gr _col(49) "Number of strata" _col(68) "= "
	   in ye %9.0f `nstr' _n
	   in gr "PSU:" _col(11) "`psu'"
	   in gr _col(49) "Number of PSUs" _col(68) "= "
	   in ye %9.0f `npsu' ;

	if "`fpc'"!="" { ;
		di in gr "FPC:" _col(11) "`fpc'"
		   in gr _col(49) "Population size" _col(68) "="
		   in ye %10.0g `npop' ;
	} ;
	else { ;
		di in gr _col(49) "Population size" _col(68) "="
		   in ye %10.0g `npop' ;
	} ;
	if "`subpop'"!="" { ;
		di in gr "Subpop.:" _col(11) "`subpop'`subexp'"
		   _col(49) "Subpop. no. of obs" _col(68) "= "
		   in ye %9.0f `osub' _n
		   in gr _col(49) "Subpop. size" _col(68) "="
		   in ye %10.0g `nsub'
	} ;

	if "`dash'"!="" { di in smcl in gr "{hline 78}" } ;
end ;
