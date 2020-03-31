*! version 3.1.7  09feb2015
program define qqplot_7, sort
	version 6, missing
	syntax varlist(min=2 max=2) [if] [in] [, *]
	tempvar touse 
	mark `touse' `if' `in'		/* but do not markout varlist */
	tokenize `varlist'
	tempvar VARY VARX CNT NEWX2
	quietly {
		gen `VARY'=`1' if `touse'
		gen `VARX'=`2' if `touse'
		gen long `CNT'=sum(`VARY'<.)
		local cnty=`CNT'[_N]
		replace `CNT'=sum(`VARX'<.)
		local cntx=`CNT'[_N]
		drop `CNT'
		if `cntx'==0 | `cnty'==0 { error 2000 }
		if `cnty'>`cntx' {
			QQp2 `VARY' `cnty' `cntx'	/* qqalign */
		}
		if `cnty'<`cntx' {
			QQp2 `VARX' `cntx' `cnty' 	/* qqalign */
		}
		QQp1 `VARY' `VARX' `NEWX2'
		_crcslbl `VARY' `1'
		_crcslbl `NEWX2' `2'
	}
	noisily gr7 `VARY' `NEWX2' `NEWX2', `options' /*
		*/ ti("     Quantile-Quantile Plot") sy(oi) c(.l) sort
end

program define QQp1 /* _qqalign */
	version 3.1
	tempvar YORDER
	quietly {
		sort %_1
		local obstype = c(obs_t)
		gen %_obstype %_YORDER=_n
		sort %_2
		gen %_3=%_2[%_YORDER]
	}
end

program define QQp2 /* varname old# new# */	/* was qqcomp */
	version 3.0
	tempvar INT FRAC TEMP
	quietly {
		sort %_1
		local obstype = c(obs_t)
		if "%_obstype" != "double" {
			local obstype = "long"
		}
		gen %_obstype %_INT=(_n-0.5)*%_2/%_3+0.5
		gen %_FRAC=0.5+(_n-0.5)*%_2/%_3-%_INT
		gen %_TEMP=(1-%_FRAC)*%_1[%_INT]+%_FRAC*%_1[%_INT+1]
		replace %_1=%_TEMP
	}
end
