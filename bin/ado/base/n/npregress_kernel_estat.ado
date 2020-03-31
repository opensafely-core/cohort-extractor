*! version 1.0.0  17dec2017

program define npregress_kernel_estat
	version 15
	
        if "`e(cmd)'" != "npregress" {
                di as err "{help npregress##_new:npregress} estimation " ///
                 "results not found"
                exit 301
        }

	estatsummarize_kernel `"`0'"'
	
end	

program define estatsummarize_kernel, rclass
        args options
	tempname A B C
	
	local tokens "`options'"
	gettoken opciones tokens: tokens, parse(",")
	gettoken tokens opts: tokens, parse(",")
	local lkey =  length(`"`opciones'"')
	if (`"`opciones'"' != bsubstr("summarize",1,max(2,`lkey')) & ///
	     `"`opciones'"'!="vce" &  ///
		`"`opciones'"'!=bsubstr("bootstrap",1,max(4,`lkey'))){
		display as error ///
		"{bf:estat `opciones'} not allowed after {bf:npregress}"
		exit 321
	}
        local a = e(rhs)
	local b = e(lhs)
	local t "e(sample)"
	local k: list sizeof a

	if (`"`opciones'"' == bsubstr("summarize",1,max(2,`lkey'))) {
		estat_summ `b' `a' 
		matrix `A' = r(stats)
		return matrix stats = `A'
	}
	else if `"`opciones'"'=="vce"  {
		local d = e(vcetype)
		if ("`d'"=="None") {
			display as error ///
			"{bf:estat vce} not available because no" ///
			" variance-covariance matrix was computed"
			exit 198
		}
		else {
			vce
			matrix `B' = r(V)
			return matrix V = `B'
		}
	}
	else if `"`opciones'"'== bsubstr("bootstrap",1,max(4,`lkey')) {
		_my_bs_display `options'
		 local opciones `"`s(opts)'"'
		_bs_display, `opts' 
	}
end

program define _my_bs_display, sclass
		syntax [anything], [ bc 	///
				     bca 	///
				     NORmal	///
				     Percentile ///
				     all	///
				     noHEADer	///
				     noLEGend	///
				     Verbose]
		
		local opciones1 `"`bc' `bca' `normal' `percentile' `all'"' 
		local opciones2 `"`header' `legend' `verbose'"'
		local opciones `"`opciones1' `opciones2'"'
		sreturn local opts "`opciones'"
end

exit
