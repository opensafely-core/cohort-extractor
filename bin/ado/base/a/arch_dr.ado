*! version 7.1.0   19feb2019
program define arch_dr
	version 6
	args 	    todo	/*  whether to calculate gradient
		*/  bc		/*  Name of full beta matrix
		*/  llvar	/*  Name of variable to hold LL_t */

	tempvar XbHet Xb
	tempname T

				/* handle constraints, if any */
	if "$TT" != "" {
		tempname b
		mat `b' = `bc' * $TT' + $Ta
		mat colnames `b' = $Tstripe
	}
	else	local b `bc'
					/* Xb - regression component	*/
	if $Thasxb {
		matrix score double `Xb' = `b', eq($TXbeq), if $ML_samp
	}
	else    scalar `Xb' = 0

					/* errors and ARMA if no arch-in-mean */
	if "$Tarchm" == "" {
		_byobs {
			$Tdoarma score $Te = `b', eq("ARMA") missval($Tarma0v)
			update $Tu = $ML_y1 - `Xb'
			$Tdoarma update $Te = $Tu - $Te
		} if $ML_samp

		local doarma "*"
	}

					/* Multiplicative heteroskedasticity */
	if "$Tmhet" == "1" {
		matrix score double `XbHet' = `b', eq(HET),  if $ML_samp
		if "$Tearch$Tegarch" == "" {
			qui replace `XbHet' = exp(`XbHet')
		}
		local hetterm + `XbHet'
		if "$Tdoarch" == "*" { 
			qui replace $Tsigma2 = `XbHet' if $ML_samp
			local dohet "*"
		}
	}
	else if !$Tarchany {
		matrix `T' = `b'[1, "HET:"]
		qui replace $Tsigma2 = `T'[1,1]  if $ML_samp
		local dohet "*"
	}
	else {
		local dohet "*"
		if "$Tdoarch" == "*" {
			qui replace $Tsigma2 = 0 if $ML_samp
		}		
	}
	
				/* Get shape parameter if optimizing */
	if "$Tdfopt" != "*" {
		local k = colsof(`b')
		if "$Tdistt" == "" {
			glo Ttdf = exp(`b'[1,`k']) + 2
		}
		else if "$TdistGED" == "" {
			glo TGEDdf = exp(`b'[1,`k'])
		}
	}
				/* Recursive computations */

					/* Setup what is to be done */

	if $Tarchany {
				/* Priming values for sigma^2 */

		if "$Tarch0" == "xb" | "$Tarch0" == "xbwt" {
			if "$Tarchm" == "" {
				qui replace $Te2 = $Te^2 if $ML_samp
				if "$Tarch0" == "xb" {
					sum $Te2, meanonly
					scalar $Tsig2_0 = r(mean)
				}
				else if "$Tarch0" == "xbwt" {
					tempname wt_e2 adj
					local t = r(tmax) - r(tmin)
					qui gen double `wt_e2' =  /*
					   */ .7^($Ttimevar-$Ttimemin)*$Te2 /*
					   */ if $ML_samp
					sum `wt_e2', meanonly
					scalar `adj' = r(sum)
					sum $Te2, meanonly
					scalar $Tsig2_0 = 0.7^$Tadjt*r(mean) /*
						*/ + 0.3*`adj'
				}
			}
			else {
				if "$ML_ic" != "$Tic_hold" {
					scalar $Tsig2_0 = $Ts2_mayb
					global Tic_hold = $ML_ic
				}
			}
		}
		local sig2_0 = $Tsig2_0
		local sig_0 = sqrt($Tsig2_0)

		if $Tdopowi {
			mat `T' = `b'[1, "POWER:"]
			scalar $Tpower = `T'[1,1]
			local sigp_0 = $Tsig2_0^($Tpower/2)
		}
		if "$Taarch$Taparch$Tnparch$Tabarch$Tnarch" != "" {
			scalar $Tabse_0 = sqrt(2*$Tsig2_0 / _pi)
			local abse_0 = $Tabse_0
		}
		if "$Tegarch" != "" { local lsig2_0 = ln(`sig2_0') }
	}
	
	if "$TdistGED" != "*" {
		tempname lambda
		scalar `lambda' = sqrt(exp(lngamma(1/$TGEDdf)) /	/*
			*/	(2^(2/$TGEDdf) * exp(lngamma(3/$TGEDdf))))
	}
					/* Observation loop */

	_byobs {
		$Tsd_scr				/* SD ARCH/GARCH */
		
							/* ARCH components */
		$Tdoarch score $Tsigma2 = `b', eq("ARCH") missval(`sig2_0')
		`dohet' update $Tsigma2 = $Tsigma2 `hetterm'

		$Tsd_updt				/* Tsig^2 + Tsigma2 */

		$Taarchex				/* AARCH expression */
		$Tnarchex				/* NARCH expression */


							/* EARCH & EGARCH */
		$Tdoearch score $Ttearch = `b', eq("EARCH") missval(0)
		$Tdoearch score $Ttearcha = `b', eq("EARCHa") missval(0)
		$Tdoegrch score $Ttegarch = `b', eq("EGARCH") missval(`lsig2_0')
$Tdoeaeg update $Tsigma2 = exp($Tsigma2 + $Ttegarch + $Ttearch + $Ttearcha)

							/* Power ARCH */
		$Tdopow score $Ttvar = `b', eq("PARCH") missval(`sigp_0')
		$Taparchx				/* APARCH components */
		$Tnparchx				/* NPARCH components */
		$Tdopowa update $Tsigma2 = $Tsig_pow^(2 / $Tpower)


							/* ARCH-in-mean */
		$Tdarchme update $Ttarchme = $Tarchmex
		$Tdoarchm score $Ttarchm = `b', eq("ARCHM") missval(`sig2_0')

							/* error before ARMA */
		`doarma' update $Tu = $ML_y1 - `Xb' - $Ttarchm

							/* ARMA components */
		$Tdoarma `doarma' score $Te = `b', eq("ARMA") missval(0)
		$Tdoarma `doarma' update $Te = $Tu - $Te

							/* EARCH input terms */
		$Tdoearch update $Tz = $Te / sqrt($Tsigma2)
		$Tdoearch update $Tabsz = abs($Tz) - $Tnormadj
							/* EGARCH input term */
		$Tdoegrch update $Tlnsig2 = ln($Tsigma2)

		`doarch' update $Te2 = $Te^2		/* ARCH term */

							/* TARCH terms */
		$Tdotarch update $Te_tarch = ($Te > 0) * $Te2

		$Tabe_upd				/* |e|		*/
		$Ttae_upd				/* |e|*(e>0)	*/
		$Tsig_upd				/* sqrt(sigma2) */
		$Tabpowex				/* |e|^p	*/
		$Ttpowex				/* (e>0)(|e|^p) */

							/* Likelihood */
		$TdistN update `llvar' =  -0.5 * (ln(2*_pi)  		/*
			*/		  + ln($Tsigma2)  		/*
			*/		  + $Te2 / $Tsigma2)
		$Tdistt update `llvar' = lngamma(($Ttdf+1)/2) 		/*
			*/		- 0.5*ln(_pi) 			/*
			*/		- lngamma($Ttdf/2) 		/*
			*/		- 0.5*ln($Ttdf-2) 		/*
			*/		- 0.5*ln($Tsigma2) 		/*
			*/	 	- ($Ttdf+1)/2*ln1p($Te2 /	/*
			*/		($Tsigma2*($Ttdf-2)))
		$TdistGED update `llvar' = ln($TGEDdf) 			/*
			*/ - 0.5*abs($Te/(`lambda'*sqrt($Tsigma2)))^$TGEDdf /*	
			*/ - 0.5*ln($Tsigma2)				/*
			*/ - lngamma(1/$TGEDdf)				/*
			*/ - ln(`lambda'*2^(($TGEDdf+1)/$TGEDdf))
	}  if $ML_samp

						/* arma priming */
	if "$Tskipobs" != "" { qui replace `llvar' = 0 if !$Ttouse2 }

	if "$Tarchm" != "" { 
		if "$Tarch0" == "xb" {
			sum $Te2 if $Ttouse2, meanonly
			global Ts2_mayb = r(mean)
		}
		else if "$Tarch0" == "xbwt" {
			tempname wt_e2 adj
			local t = r(tmax) - r(tmin)
			qui gen double `wt_e2' =  /*
				*/ .7^($Ttimevar-$Ttimemin)*$Te2 if $ML_samp
			sum `wt_e2' if $Ttouse2, meanonly
			scalar `adj' = r(sum)
			sum $Te2 if $Ttouse2, meanonly
			global Ts2_mayb = 0.7^$Tadjt*r(mean) + 0.3*`adj'
		}
	}

end

exit

Likelihood evaluator for ARCH/GARCH and possibly ARMA disturbances

see globals list in arch.ado:

Note that $Tu and $Te point to same variable if there are no ARMA terms.
