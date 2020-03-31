*! version 1.1.0  19feb2019
program define gamhet_glf
	version 7.0
	args lnf beta lnsigmavar kvar lnthetavar

	local t = "$EREGt"
	local t0 = "$EREGt0"
	local d = "$EREGd"

	tempname k th sg lnsigma lntheta ga
	tempvar a b b0 c c0 f 
	
	quietly { 
		summarize `kvar' if $ML_samp, meanonly
		scalar `k' = r(mean)
		scalar `k'=cond(abs(`k')<0.01,cond(`k'>0,0.01,-0.01),`k')
		summarize `lnsigmavar' if $ML_samp, meanonly
		scalar `lnsigma' = r(mean)
		summarize `lnthetavar' if $ML_samp, meanonly
		scalar `lntheta' = r(mean)
		scalar `sg' = exp(`lnsigma') 
		scalar `th' = cond(`lntheta'<-20,exp(-20),exp(`lntheta'))

		scalar `ga' = 1/(`k'*`k') 
		
		gen double `a' = 1/`th'+`d' if $ML_samp

		if (`k'>0) {
			gen double `b' = `ga'*exp((ln(`t')-`beta')/ /*
				*/ (`sg'*sqrt(`ga'))) if $ML_samp
			gen double `b0' = cond(`t0'>0, /*
				*/ `ga'*exp((ln(`t0')-`beta')/ /*
				*/ (`sg'*sqrt(`ga'))),0) if $ML_samp
			gen double `c' = ln1m(gammap(`ga',`b')) if $ML_samp
			gen double `c0' = cond(`t0'>0, /* 
				*/ ln1m(gammap(`ga',`b0')),0) if $ML_samp
		}
		else {
 			gen double `b' = `ga'*exp((`beta'-ln(`t'))/ /*
				*/ (`sg'*sqrt(`ga'))) if $ML_samp
			gen double `b0' = cond(`t0'>0, /*
				*/ `ga'*exp((`beta'-ln(`t0'))/ /*
				*/ (`sg'*sqrt(`ga'))),0) if $ML_samp
			gen double `c' = ln(gammap(`ga',`b')) if $ML_samp
			gen double `c0' = cond(`t0'>0, /* 
				*/ ln(gammap(`ga',`b0')),0) if $ML_samp
		}
	
		gen double `f' = -`b' + (`ga'-1)*ln(`b') - /*
			*/ lngamma(`ga') if $ML_samp
	
		replace `lnf' = -`a'*ln1m(`th'*`c') + /* 
			*/ cond(`t0'>0,ln1m(`th'*`c0')/`th',0) + /* 
			*/ `d'*(`f'+0.5*ln(`ga')+ln(`b'/`ga')-ln(`sg')-`c') /*
			*/ if $ML_samp
	}
end
exit

