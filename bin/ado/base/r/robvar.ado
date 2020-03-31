*! version 7.0.7  29jan2015
program define robvar, rclass by(recall) sort
        version 6, missing
	syntax varname [if] [in] , by(varname)
	marksample touse
	markout `touse' `by', strok
	qui {
		count if `touse'
		local N=r(N)
		tempvar xbar 
		egen double `xbar'=mean(`varlist') if `touse',by(`by')
		DoCal `varlist' `by' `xbar' `touse'
		drop `xbar'
		tempname num den ng num w0 w50 w10 p df1 df2
		scalar `num'=`s(num)'
		scalar `den'=`s(den)'
		scalar `ng'=`s(ng)'
		scalar `num'=`num'/(`N'-`ng' )
		scalar `w0'=`den'/`num' 
		scalar `p'=fprob((`ng' -1),(`N'-`ng' ),`w0')
		scalar `df1'=`ng'-1
		scalar `df2'=`N'-`ng'
		noi tab `by' if `touse',sum(`varlist')
		ret scalar df_2=`df2' 
		ret scalar df_1=`df1' 
		ret scalar p_w0=`p' 
		ret scalar w0=`w0' 
		
		egen double `xbar'=median(`varlist') if `touse',by(`by')
		DoCal `varlist' `by' `xbar' `touse'
		drop `xbar'
		scalar `num'=`s(num)'
		scalar `den'=`s(den)'
		scalar `ng'=`s(ng)'
		scalar `num'=`num'/(`N'-`ng' )
		scalar `w50'=`den'/`num' 
		scalar `p'=fprob((`ng' -1),(`N'-`ng' ),`w50')
		ret scalar p_w50=`p' 
		ret scalar w50=`w50' 
 	
		tempvar  p10 p90 m10 
		egen double `p10'=pctile(`varlist') if `touse',p(10) by(`by')
		egen double `p90'=pctile(`varlist') if `touse',p(90) by(`by')
		egen double `m10'=mean(`varlist') if `varlist'>=`p10' /*
		*/ & `varlist'<=`p90' & `touse',by(`by')
		egen double `xbar'=min(`m10') if `touse',by(`by')
		drop `m10' `p10' `p90' 
		DoCal `varlist' `by' `xbar' `touse'
		drop `xbar'
		scalar `num'=`s(num)'
		scalar `den'=`s(den)'
		scalar `ng'=`s(ng)'
		scalar `num'=`num'/(`N'-`ng' )
		scalar `w10'=`den'/`num' 
		scalar `p'=fprob((`ng' -1),(`N'-`ng' ),`w10')
		ret scalar p_w10=`p' 
		ret scalar w10=`w10' 
		ret scalar N=`N'

		local val : display `w0'
		local fmtlen = length("`val'")
		if (bsubstr("`val'",1,1) == ".") {
			local fmtlen = `fmtlen' + 1
		}
		local w0rlen = index(reverse("`val'"), ".") - 1
		local right = `w0rlen'

		local val : display `w50'
		local w50len = length("`val'")
		if (bsubstr("`val'",1,1) == ".") {
			local w50len = `w50len' + 1
		}
		local w50rlen = index(reverse("`val'"), ".") - 1
		if (`fmtlen' < `w50len') {
			local fmtlen = `w50len'
		}
		if (`right' < `w50rlen') {
			local right = `w50rlen'
		}

		local val : display `w10'
		local w10len = length("`val'")
		if (bsubstr("`val'",1,1) == ".") {
			local w10len = `w10len' + 1
		}
		local w10rlen = index(reverse("`val'"), ".") - 1
		if (`fmtlen' < `w10len') {
			local fmtlen = `w10len'
		}
		if (`right' < `w10rlen') {
			local right = `w10rlen'
		}

		local fmtlen = `fmtlen' + 1
		local fmt1 "%`fmtlen'.`right'f"

		capture confirm numeric format `fmt1'
		if _rc {
			local fmt1 ""
		}

		if (return(p_w0) == 0) {
			local fmtpw0 ""
		} 
		else {
			local val : display return(p_w0)
			local pw0len = length("`val'") - 1
			local left = `pw0len' + 2
			local fmtpw0 "%0`left'.`pw0len'f"
		}
		if (return(p_w50) == 0) {
			local fmtpw50 ""
		} 
		else {
			local val : display return(p_w50)
			local pw50len = length("`val'") - 1
			local left = `pw50len' + 2
			local fmtpw50 "%0`left'.`pw50len'f"
		}

		if (return(p_w10) == 0) {
			local fmtpw10 ""
		} 
		else {
			local val : display return(p_w10)
			local pw10len = length("`val'") - 1
			local left = `pw10len' + 2
			local fmtpw10 "%0`left'.`pw10len'f"
		}
		noi di _n in gr "W0  = " in ye `fmt1' `w0' in gr /*
		*/ "   df(" in ye `df1' ", " `df2' in gr ") ""    Pr > F = " /*
		*/ in ye `fmtpw0' return(p_w0)
		noi di _n in gr "W50 = " in ye `fmt1' `w50' in gr /*
		*/ "   df(" in ye `df1' ", " `df2' in gr ")     Pr > F = " /*
		*/ in ye `fmtpw50' return(p_w50)
		noi di _n in gr "W10 = " in ye `fmt1' `w10' in gr /*
		*/ "   df(" in ye `df1' ", " `df2' in gr ")     Pr > F = " /*
		*/ in ye `fmtpw10' return(p_w10)
	}
 end

prog def DoCal, sclass
	args x g xbar touse
		tempvar zij zbari ni den s num
		gen double `zij'=abs(`x'-`xbar') if `touse'
		egen double `zbari'=mean(`zij') if `touse',by(`g')
		sum `zij' if `touse', meanonly
		local zbarp=r(mean) 
		sort `touse' `g'
		by `touse' `g': gen double `ni'=_N
		gen double `den'=`ni'*((`zbari'-`zbarp')^2) if `touse'
		drop `ni'
		sort `touse' `g'
		by `touse' `g':gen double `s' =`den' if _n==1 & `touse'
		drop `den'
		sum `s' if `touse',meanonly
		local ng =r(N)
		local sd =r(sum)
		local den=`sd' /(`ng' -1) 
		gen double `num'=(`zij'-`zbari')^2 if `touse'
		sum `num' if `touse', meanonly
		drop `num' `zij' `zbari'
		local num=r(sum)
		sret local den= `den' 
		sret local num= `num' 
		sret local ng= `ng' 
end
