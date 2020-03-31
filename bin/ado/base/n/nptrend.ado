*! version 1.2.1  09feb2015
program define nptrend, rclass sortpreserve
	version 6, missing
	syntax varname [if] [in], BY(varlist)	///
		[				///
			noDetail		///
			noLabel			///
			Score(varname)		///
		]
    
	opts_exclusive "`detail' `label'"

	marksample usable
	markout `usable' `score'
	markout `usable' `by', strok

/*
	keep if `usable'
*/

	quietly {
/*
	Is the grouping variable a string variable?
*/
		cap conf string var `by'
		if _rc == 0 { 
			_nostrl error : `by'
			tempvar byvar
			local string 1
			sort `usable' `by'
			qui by `usable' `by': /*
				*/ gen `c(obs_t)' `byvar' = 1 if `usable' & _n==1
			replace `byvar' = sum(`byvar') if `usable'
		}
		else {	
		 	local byvar "`by'"
			local string 0
		}
/*
	Create score.
*/
		local sc "`score'"
		tempvar score
		if "`sc'"=="" {
			gen `score' = `byvar' if `usable'
		}
		else 	gen `score' = `sc' if `usable'
/*
	Generate the rank sums.
*/
		tempvar ranksum obs tie
		egen `ranksum' = rank(`varlist') if `usable'
		gen long `obs' = 1 if `ranksum'<.
		sort `usable' `ranksum'
		by `usable' `ranksum': /*
			*/ gen `tie' = cond(_n==_N,sum(`obs'),.) if `usable'
		replace `tie' = sum(`tie'*(`tie'*`tie'-1))
		local ties = `tie'[_N]
		sort `usable' `byvar'
		by `usable' `byvar': /*
		*/ replace `ranksum'=cond(_n==_N,sum(`ranksum'),.) if `usable'
		by `usable' `byvar': /*
		*/replace `obs'=cond(_n==_N,sum(`obs'),.) if `usable'
/*
	Display the rank sums for each group.
*/
		if "`detail'" == "" {
			char `score'[varname]	score
			char `obs'[varname]	obs
			char `ranksum'[varname]	"sum of ranks"
			format %10.0g `score'
			format %10.0g `obs'
			format %12.0g `ranksum'

nobreak {

			local fmt : format `by'
			if `string' {
				format %10s `by'
			}
			else {
				format %10.0g `by'
			}

capture noisily break {

			list `by' `score' `obs' `ranksum'	///
				if !missing(`obs')		///
				,				///
				`label'				///
				abbreviate(12)			///
				nocompress			///
				noobs				///
				table				///
				textheader			///
				subvarname			///
				clean

} // capture noisily break

			local rc = c(rc)
			format `fmt' `by'
			if `rc' {
				exit `rc'
			}

} // nobreak
		}
		noi di
/*
	Calculate the test statistic and p-value.
*/
		tempvar T L L2
		gen `T'=sum(`ranksum'*`score')
		gen `L'=sum(`score'*`obs')
		gen `L2'=sum(`score'*`score'*`obs')
		replace `obs'=sum(`obs')
		local T = `T' in l
		local L = `L' in l
		local L2 = `L2' in l
		local N = `obs' in l
		local ET = (`N'+1)*`L'/2
		local a=`ties'/(`N'*(`N'*`N'-1))        /* adj for ties */
		local VT = (1-`a')*(`N'*`L2'-`L'*`L')*(`N'+1)/12
		local z = (`T'-`ET')/sqrt(`VT')
		local pval = 2*( 1-normprob(abs(`z')))
	}
	di in gr "          z  = " in ye %5.2f `z'
	di in gr "  Prob > |z| = " in ye %5.3f `pval'
        
        
	return scalar N = `N'
	return scalar T = `T'
	return scalar z = `z'
	return scalar p = `pval'

	/* Double saves */
	global S_1  "`return(N)'"
	global S_2  "`return(T)'"
	global S_3  "`return(z)'"
	global S_4  "`return(p)'"
end
