*! version 1.4.4  27aug2014
program gr_example2
	version 8.2
	if (_caller() < 8.2)  version 8
	else		      version 8.2

	set more off
	`0'
end

program NotSmall
	if "`c(flavor)'"=="Small" {
		window stopbox stop ///
		"Dataset used in this example" ///
		"too large for Small Stata"
	}
end
	

program Msg
	di as txt
	di as txt "-> " as res `"`0'"'
end

program Xeq
	di as txt
	di as txt `"-> "' as res _asis `"`0'"'
	`0'
end

program markerlabel1
	Msg preserve
	preserve
	Xeq sysuse lifeexp, clear
	Xeq gen pos = 3
	Xeq replace pos = 9 if country=="Honduras"
	#delimit ;
	Xeq
	scatter lexp gnppc if region==2,
		mlabel(country) mlabv(pos)
		xsca(range(35000))
	;
	#delimit cr
	Msg restore
end

program markerlabel2
	Msg preserve
	preserve
	Xeq sysuse lifeexp, clear
	Xeq gen pos = 3
	Xeq replace pos = 9 if country=="Honduras"
	#delimit ;
	Xeq
	scatter lexp gnppc if region==2,
		mlabel(country) mlabv(pos)
		xsca(range(35000))
		plotregion(margin(l+9))
	;
	#delimit cr
	Msg restore
end


program markerlabel3
	Msg preserve
	preserve
	Xeq sysuse lifeexp, clear
	Xeq keep if region==2 | region==3
	Xeq replace gnppc = gnppc / 1000
	Xeq label var gnppc "GNP per capita (thousands of dollars)"
	Xeq gen lgnp = log(gnp)
	Xeq qui reg lexp lgnp
	Xeq predict hat 
	Xeq label var hat "Linear prediction"
	Xeq replace country = "Trinidad" if country=="Trinidad and Tobago"
	Xeq replace country = "Para" if country == "Paraguay"
	Xeq gen pos = 3 
	Xeq replace pos = 9 if lexp > hat 
	Xeq replace pos = 3 if country == "Colombia"
	Xeq replace pos = 3 if country == "Para"
	Xeq replace pos = 3 if country == "Trinidad"
	Xeq replace pos = 9 if country == "United States"

	#delimit ;

	Xeq twoway
	(scatter lexp gnppc, mlabel(country) mlabv(pos))
	(line hat gnppc, sort)
	, xsca(log) xlabel(.5 5 10 15 20 25 30, grid) legend(off) 
	  title("Life expectancy vs. GNP per capita") 
	  subtitle("North, Central, and South America") 
	  note("Data source:  World bank, 1998") 
	  ytitle("Life expectancy at birth (years)")
	;
	#delimit cr
	Msg restore
end

program markerlabel4
	Msg preserve
	preserve
	Xeq sysuse lifeexp, clear
	Xeq keep if region==2 | region==3
	Xeq replace gnppc = gnppc / 1000
	Xeq label var gnppc "GNP per capita (thousands of dollars)"
	Xeq gen lgnp = log(gnp)
	Xeq qui reg lexp lgnp
	Xeq predict hat 
	Xeq label var hat "Linear prediction"
	Xeq replace country = "Trinidad" if country=="Trinidad and Tobago"
	Xeq replace country = "Para" if country == "Paraguay"
	Xeq gen pos = 3 
	Xeq replace pos = 9 if lexp > hat 
	Xeq replace pos = 3 if country == "Colombia"
	Xeq replace pos = 3 if country == "Para"
	Xeq replace pos = 3 if country == "Trinidad"
	Xeq replace pos = 9 if country == "United States"

	#delimit ;

	Xeq twoway
	(scatter lexp gnppc, mlabel(country) mlabv(pos))
	(line hat gnppc, sort)
	, xsca(log) xlabel(.5 5 10 15 20 25 30, grid) legend(off) 
	  title("Life expectancy vs. GNP per capita") 
	  subtitle("North, Central, and South America") 
	  note("Data source:  World bank, 1998") 
	  ytitle("Life expectancy at birth (years)")
	  scale(1.1)
	;
	#delimit cr
	Msg restore
end


/*
program scatter1
	preserve
	quietly {
		use "`c(sysdir_stata)'census", clear
		gen mrate = marriage/pop18p
		gen drate = divorce/pop18p
	}
	scatter mrate drate medage if state!="Nevada"
end
*/

program scatterlog
	Msg preserve
	preserve
	Xeq sysuse lifeexp, clear
	Xeq gen gnp000 = gnppc/1000
	Xeq label var gnp000 "GNP per capita, thousands of dollars"
	Xeq scatter lexp gnp000, xsca(log) ///
		xlabel(.5 2.5 10(10)40, grid)
	Msg restore
end

program scatterwgt
	Msg preserve
	preserve
	Xeq sysuse census, clear
	Xeq gen drate = divorce / pop18p 
	Xeq label var drate "Divorce rate"
	Xeq scatter drate medage [w=pop18p] if state!="Nevada", ///
	m(Oh) ///
	note("State data excluding Nevada" ///
	"Area of symbol proportional to state's population aged 18+")
	Msg restore
end



program line1
	tempname esti
	_est hold `esti', nullok
	Msg preserve
	preserve 
	Xeq sysuse auto, clear
	Xeq quietly regress mpg weight 
	Xeq predict hat
	Xeq predict stf, stdf
	Xeq gen lo = hat - 1.96*stf
	Xeq gen hi = hat + 1.96*stf
	Xeq scatter mpg weight || line hat lo hi weight, ///
		pstyle(p2 p3 p3) sort
	Msg restore
	restore
	_estimates unhold `esti'
end


program line2
	Msg preserve
	preserve 
	Xeq sysuse uslifeexp, clear
	Xeq gen diff = le_wm - le_bm 
	Xeq label var diff "Difference"

	#delimit ;
	Xeq 
	   line le_wm year, yaxis(1 2) xaxis(1 2)
	|| line le_bm year 
	|| line diff  year
	|| lfit diff  year
	||, 
		ylabel(0(5)20, axis(2) gmin angle(horizontal))
		ylabel(0 20(10)80,     gmax angle(horizontal))
		ytitle("", axis(2))
		xlabel(1918, axis(2)) xtitle("", axis(2))
		ylabel(, axis(2) grid)
		ytitle("Life expectancy at birth (years)")
		title("White and black life expectancy")
		subtitle("USA, 1900-1999")
		note("Source: National Vital Statistics, Vol 50, No. 6" 
			"(1918 dip caused by 1918 Influenza Pandemic)")
	;
	#delimit cr
	Msg restore
end

program line3
	Msg preserve
	preserve 
	Xeq sysuse uslifeexp, clear
	Xeq gen diff = le_wm - le_bm 
	Xeq label var diff "Difference"

	#delimit ;
	Xeq 
	   line le_wm year, yaxis(1 2) xaxis(1 2)
	|| line le_bm year 
	|| line diff  year
	|| lfit diff  year
	||, 
		ylabel(0(5)20, axis(2) gmin angle(horizontal))
		ylabel(0 20(10)80,     gmax angle(horizontal))
		ytitle("", axis(2))
		xlabel(1918, axis(2)) xtitle("", axis(2))
		ylabel(, axis(2) grid)
		ytitle("Life expectancy at birth (years)")
		title("White and black life expectancy")
		subtitle("USA, 1900-1999")
		note("Source: National Vital Statistics, Vol 50, No. 6" 
			"(1918 dip caused by 1918 Influenza Pandemic)")
		legend(label(1 "White males") label(2 "Black males"))
	;
	#delimit cr
	Msg restore
end

program line3a
	Msg preserve
	preserve 
	Xeq sysuse uslifeexp, clear
	Xeq gen diff = le_wm - le_bm 
	Xeq label var diff "Difference"

	#delimit ;
	Xeq 
	   line le_wm year, yaxis(1 2) xaxis(1 2)
	|| line le_bm year 
	|| line diff  year
	|| lfit diff  year
	||, 
		ylabel(0(5)20, axis(2) grid gmin angle(horizontal))
		ylabel(0 20(10)80,          gmax angle(horizontal))
		ytitle("", axis(2))
		xlabel(1918, axis(2)) xtitle("", axis(2))
		ylabel(, axis(2) grid)
		ytitle("Life expectancy at birth (years)")
		title("White and black life expectancy")
		subtitle("USA, 1900-1999")
		note("Source: National Vital Statistics, Vol 50, No. 6" 
			"(1918 dip caused by 1918 Influenza Pandemic)")
		legend(label(1 "White males") label(2 "Black males"))
	;
	#delimit cr
	Msg restore
end

program line4
	Msg preserve
	preserve 
	Xeq sysuse uslifeexp, clear
	Xeq gen diff = le_wm - le_bm 
	Xeq label var diff "Difference"

	#delimit ;
	Xeq 
	   line le_wm year, yaxis(1 2) xaxis(1 2)
	|| line le_bm year 
	|| line diff  year
	|| lfit diff  year
	||, 
		ylabel(0(5)20, axis(2) gmin angle(horizontal))
		ylabel(0 20(10)80,     gmax angle(horizontal))
		ytitle("", axis(2))
		xlabel(1918, axis(2)) xtitle("", axis(2))
		ylabel(, axis(2) grid)
		ytitle("Life expectancy at birth (years)")
		title("White and black life expectancy")
		subtitle("USA, 1900-1999")
		note("Source: National Vital Statistics, Vol 50, No. 6" 
			"(1918 dip caused by 1918 Influenza Pandemic)")
		legend(label(1 "White males") label(2 "Black males"))
		legend(col(1) pos(3))
	;
	#delimit cr
	Msg restore
end


program twobar
	Msg preserve
	preserve 
	Xeq sysuse sp500, clear
	#delimit ;
	Xeq twoway 
		line close date, yaxis(1)
	||
		bar change date, yaxis(2)
	||
	in 1/52, 
		ysca(axis(1) r(1000 1400)) ylab(1200(50)1400, axis(1))
		ysca(axis(2) r(-50 300)) ylab(-50 0 50, axis(2)) 
			ytick(-50(25)50, axis(2) grid)
		legend(off)
		xtitle("Date")
		title("S&P 500")
		subtitle("January - March 2001")
		note("Source:  Yahoo!Finance and Commodity Systems, Inc.")
		yline(1150, axis(1) lstyle(foreground))
	;
	#delimit cr
	Msg restore
end

program twobar2
	Msg preserve
	preserve 
	Xeq sysuse pop2000, clear
	Xeq replace maletotal = -maletotal/1e+6
	Xeq replace femtotal = femtotal/1e+6
	#delimit ;
	Xeq twoway
		bar maletotal agegrp, horizontal xvarlab(Males)
	||
		bar  femtotal agegrp, horizontal xvarlab(Females)
	||
	, ylabel(1(1)17, angle(horizontal) valuelabel labsize(*.8))
	xtitle("Population in millions") ytitle("")
	xlabel(-10 "10" -7.5 "7.5" -5 "5" -2.5 "2.5" 2.5 5 7.5 10)
	legend(label(1 Males) label(2 Females))
	title("US Male and Female Population by Age")
	subtitle("Year 2000")
	note("Source:  U.S. Census Bureau, Census 2000, Tables 1, 2 and 3",
	span) ;
	#delimit cr
	Msg restore
end

program twobar3
	Msg preserve
	preserve 
	Xeq sysuse pop2000, clear
	Xeq replace maletotal = -maletotal
	Xeq twoway bar maletotal agegrp, horizontal || bar femtotal agegrp, horizontal 
	Msg restore
end

program twobar4
	Msg preserve
	preserve 
	Xeq sysuse pop2000, clear
	Xeq replace maletotal = -maletotal/1e+6
	Xeq replace femtotal = femtotal/1e+6
	Xeq gen zero = 0
	#delimit ;

	Xeq twoway 
		bar maletotal agegrp, horizontal xvarlab(Males)
	||	
   		bar  femtotal agegrp, horizontal xvarlab(Females)
	||	
   		sc  agegrp zero     , mlabel(agegrp) mlabcolor(black) msymbol(i)
	||	
	, 
	xtitle("Population in millions") ytitle("")
	plotregion(style(none))
	ysca(noline) ylabel(none)
	xsca(noline titlegap(-3.5))
	xlabel(-12 "12" -10 "10" -8 "8" -6 "6" -4 "4" 4(2)12 , tlength(0) 
		grid gmin gmax)
	legend(label(1 Males) label(2 Females)) legend(order(1 2))
	title("US Male and Female Population by Age, 2000")
	note("Source:  U.S. Census Bureau, Census 2000, Tables 1, 2 and 3")
;
	#delimit cr
	Msg restore
end



program twospike
	Msg preserve
	preserve 
	Xeq sysuse sp500, clear
	#delimit ;
	Xeq twoway 
		line close date, yaxis(1)
	||
		spike change date, yaxis(2)
	||,
		ysca(axis(1) r(700  1400)) ylab(1000(100)1400, axis(1))
		ysca(axis(2) r(-50 300)) ylab(-50 0 50, axis(2)) 
			ytick(-50(25)50, axis(2) grid)
		legend(off)
		xtitle(Date)
		title("S&P 500")
		subtitle("January - December 2001")
		note("Source:  Yahoo!Finance and Commodity Systems, Inc.")
		yline(950, axis(1) lstyle(foreground))
	;
	#delimit cr
	Msg restore
end

program twospike2
	Msg preserve
	preserve 
	Xeq sysuse sp500, clear
	#delimit ;
	Xeq twoway 
		line close date, yaxis(1)
	||
		spike change date, yaxis(2)
	||,
		ysca(axis(1) r(700  1400)) ylab(1000(100)1400, axis(1))
		ysca(axis(2) r(-50 300)) ylab(-50 0 50, axis(2)) 
			ytick(-50(25)50, axis(2) grid)
		legend(off)
		xtitle("Date")
		title("S&P 500")
		subtitle("January - December 2001")
		note("Source:  Yahoo!Finance and Commodity Systems, Inc.")
		yline(950, axis(1) lstyle(foreground))
	;
	#delimit cr
	Msg restore
end


program twodropline
	Msg preserve
	preserve 

	Xeq sysuse lifeexp, clear 
	Xeq keep if region==3
	Xeq gen lngnp = ln(gnppc)
	Xeq quietly regress le lngnp 
	Xeq predict r, resid 
	Xeq twoway dropline r gnp, ///
		yline(0, lstyle(foreground)) mlabel(country) mlabpos(9) ///
		ylab(-6(1)6) ///
		subtitle("Regression of life expectancy on ln(gnp)" ///
		"Residuals:" " ", pos(11)) ///
		note("Residuals in years; positive values indicate" ///
		"longer than predicted life expectancy")
	Msg restore
end

program hist1
	Msg preserve
	preserve
	Xeq sysuse sp500, clear 
	#delimit ;
	Xeq
		histogram volume, freq
		xaxis(1 2)
		ylabel(0(10)60, grid) 
		xlabel(12321 "mean" 
		      9735 "-1 s.d." 
		     14907 "+1 s.d." 
		      7149 "-2 s.d."
		     17493 "+2 s.d." 
		     20078 "+3 s.d."
		     22664 "+4 s.d."
					, axis(2) grid gmax)
		xtitle("", axis(2))
		subtitle("S&P 500, January 2001 - December 2001")
		note("Source:  Yahoo!Finance and Commodity Systems, Inc.")
	;
	#delimit cr
	Msg restore
end

program hist2
	Msg preserve
	preserve
	Xeq sysuse sp500, clear 
	#delimit ;
	Xeq
		histogram volume, freq normal
		xaxis(1 2)
		ylabel(0(10)60, grid) 
		xlabel(12321 "mean" 
		      9735 "-1 s.d." 
		     14907 "+1 s.d." 
		      7149 "-2 s.d."
		     17493 "+2 s.d." 
		     20078 "+3 s.d."
		     22664 "+4 s.d."
					, axis(2) grid gmax)
		xtitle("", axis(2))
		subtitle("S&P 500, January 2001 - December 2001")
		note("Source:  Yahoo!Finance and Commodity Systems, Inc.")
	;
	#delimit cr
	Msg restore
end


program tworspike
	Msg preserve
	preserve
	Xeq sysuse sp500, clear 
	Xeq replace volume = volume/1000
	#delimit ;
	Xeq
	twoway
		rspike hi low date ||
		line   close  date ||
		bar    volume date, barw(.25) yaxis(2) ||
	in 1/57
	, ysca(axis(1) r(900 1400))
	  ysca(axis(2) r(  9   45))
	  ylabel(, axis(2) grid)
	ytitle("                          Price -- High, Low, Close")
	ytitle(" Volume (millions)", axis(2) bexpand just(left))
	legend(off)
	subtitle("S&P 500", margin(b+2.5))
	note("Source:  Yahoo!Finance and Commodity Systems, Inc.")
	;
	#delimit cr
	Msg restore
end
	
program tworcap
	Msg preserve
	preserve
	Xeq sysuse sp500, clear 
	Xeq gen month = month(date)
	Xeq sort month
	Xeq by month: egen lo = min(volume)
	Xeq by month: egen hi = max(volume)
	Xeq format lo hi %10.0gc
	Xeq summarize volume
	Xeq by month: keep if _n==_N
	#delimit ;
	Xeq
	twoway rcap lo hi month, 
	  xlabel(1 "J"  2 "F"  3 "M"  4 "A"  5 "M"  6 "J" 
                 7 "J"  8 "A"  9 "S" 10 "O" 11 "N" 12 "D")
	  xtitle("Month of 2001")
	  ytitle("High and Low Volume")
	  yaxis(1 2) ylabel(12321 "12,321 (mean)", axis(2) angle(0))
	  ytitle("", axis(2))
	  yline(12321, lstyle(foreground))
	  msize(*2)
	  title("Volume of the S&P 500", margin(b+2.5))
	  note("Source:  Yahoo!Finance and Commodity Systems Inc.")
	;
	#delimit cr
	Msg restore
end

program twoarea
	Msg preserve
	preserve
	Xeq sysuse gnp96, clear 
	#delimit ;
	Xeq
	twoway area d.gnp96 date, xlabel(36(8)164, angle(90)) 
	ylabel(-100(50)200, angle(0))
	ytitle("Billions of 1996 Dollars")
	xtitle("")
	subtitle("Change in U.S. GNP", position(11))
	note("Source: U.S. Department of Commerce, Bureau of Economic Analysis")
	;
	#delimit cr
	Msg restore
end

program twoarea2
	Msg preserve
	local seed "`c(seed)'"
	preserve
	Xeq sysuse gnp96, clear 
	Xeq gen diff = d.gnp96
	set seed 2938
	Xeq gen u = runiform()
	set seed `seed'
	Xeq sort u
	Xeq twoway area diff date
	Msg restore
end

program tworarea
	Msg preserve
	preserve

	Xeq sysuse auto, clear 
	Xeq quietly regress mpg weight 
	Xeq predict hat
	Xeq predict s, stdf
	Xeq gen low = hat - 1.96*s
	Xeq gen hi  = hat + 1.96*s
	#delimit ;
	Xeq
	twoway
		rarea low hi weight, sort color(gs14) ||
		scatter  mpg weight
	;
	#delimit cr
	Msg restore
end
	
program twofunc
	#delimit ;
	Xeq twoway function y=exp(-x/6)*sin(x), range(0 12.57)
		yline(0, lstyle(foreground))
		xlabel(0 3.14 "{&pi}" 6.28 "2{&pi}" 9.42 "3{&pi}" 12.57 "4{&pi}")
		plotregion(style(none))
		xsca(noline)
	;
	#delimit cr
end

program twofunc2
	#delimit ;
	Xeq
	twoway 
	    function y=normden(x), range(-4 -1.96) color(gs12) recast(area)
	||  function y=normden(x), range(1.96 4) color(gs12) recast(area)
	||  function y=normden(x), range(-4 4) lstyle(foreground)
	||, 
	    plotregion(style(none))
	    ysca(off) xsca(noline)
	    legend(off)
	    xlabel(-4 "-4 sd" -3 "-3 sd" -2 "-2 sd" -1 "-1 sd" 0 "mean" 
		    1 "1 sd"   2 "2 sd"   3 "3 sd"   4 "4 sd", grid gmin gmax)
	    xtitle("")
	;
	#delimit cr
end

program textop1
	NotSmall
	Msg preserve
	preserve


	Xeq sysuse uslifeexp, clear

	#delimit ;
	Xeq
	twoway line  le year ||
	       fpfit le year ||
	, ytitle("Life Expectancy, years")
	  xlabel(1900 1918 1940(20)2000)
	  title("Life Expectancy at Birth")
	  subtitle("U.S., 1900-1999")
	  note("Source:  National Vital Statistics Report, Vol. 50 No. 6")
	  legend(off)
	  text(48.5 1923 
     		"The 1918 Influenza Pandemic was the worst epidemic"
     		"known in the U.S."
     		"More citizens died than in all combat deaths of the"
     		"20th century."
     	  	, box place(se) just(left) margin(l+4 t+1 b+1) width(85))
	;
	#delimit cr
	Msg restore
end


program textop2
	NotSmall
	Msg preserve
	preserve


	Xeq sysuse uslifeexp, clear

	#delimit ;
	Xeq
	twoway line  le year ||
	       fpfit le year ||
	, ylabel(,grid) ytitle("Life Expectancy, years")
	  xlabel(1900 1918 1940(20)2000)
	  title("Life Expectancy at Birth")
	  subtitle("U.S., 1900-1999")
	  note("Source:  National Vital Statistics Report, Vol. 50 No. 6")
	  legend(off)
	  text(48.5 1923 
     		"The 1918 Influenza Pandemic was the worst epidemic"
     		"known in the U.S."
     		"More citizens died than in all combat deaths of the"
     		"20th century."
     	  	, box place(se) just(left) margin(l+4 t+1 b+1) width(40))
	;
	#delimit cr
	Msg restore
end

program textop3
	NotSmall
	Msg preserve
	preserve

	Xeq sysuse uslifeexp, clear

	#delimit ;
	Xeq
	twoway line  le year ||
	       fpfit le year ||
	, ylabel(,grid) ytitle("Life Expectancy, years")
	  xlabel(1900 1918 1940(20)2000)
	  title("Life Expectancy at Birth")
	  subtitle("U.S., 1900-1999")
	  note("Source:  National Vital Statistics Report, Vol. 50 No. 6")
	  legend(off)
	  text(48.5 1923 
     		"The 1918 Influenza Pandemic was the worst epidemic"
     		"known in the U.S."
     		"More citizens died than in all combat deaths of the"
     		"20th century."
     	  	, box place(se) just(left) margin(l+4 t+1 b+1) width(95))
	;
	#delimit cr
	Msg restore
end

program matrix1
	Msg preserve
	preserve
	Xeq sysuse lifeexp, clear
	Xeq gen lgnppc = ln(gnppc)
	Xeq gr matrix popgr lexp lgnp safe
	Msg restore
end

program matrix2
	Msg preserve
	preserve
	Xeq sysuse lifeexp, clear
	Xeq gen lgnppc = ln(gnppc)
	Xeq gr matrix popgr lgnp safe lexp, half
	Msg restore
end

program matrix3a
	Msg preserve
	preserve
	Xeq sysuse lifeexp, clear
	Xeq gen lgnppc = ln(gnppc)
	Xeq gr matrix popgr lgnp safe lexp
	Msg restore
end
	
program matrix3
	Msg preserve
	preserve
	Xeq sysuse lifeexp, clear
	Xeq gen lgnppc = ln(gnppc)
	Xeq gr matrix popgr lgnp safe lexp, ///
		maxes(ylab(#4, grid) xlab(#4, grid))
	Msg restore
end

program matrix4
	Msg preserve
	preserve
	Xeq sysuse lifeexp, clear
	Xeq gen lgnppc = ln(gnppc)
	Xeq label var lgnppc "ln GNP per capita"
	#delimit ;
	Xeq gr matrix popgr lgnp safe lexp, 
		maxes(ylab(#4, grid) xlab(#4, grid))
		subtitle("Summary of 1998 life-expectancy data")
		note("Source:  The World Bank Group")
	;
	#delimit cr
	Msg restore
end

program combine1
	NewFile male.gph
	NewFile female.gph
	Msg preserve
	preserve
	Xeq sysuse uslifeexp, clear 
	Xeq line le_male   year, saving(male)
	Xeq line le_female year, saving(female)
	Xeq gr combine male.gph female.gph
	Xeq erase male.gph
	Xeq erase female.gph
	Msg restore
end

program combine2
	NewFile male.gph
	NewFile female.gph
	Msg preserve
	preserve
	Xeq sysuse uslifeexp, clear 
	Xeq line le_male   year, ylab(,grid) saving(male)
	Xeq line le_female year, ylab(,grid) saving(female)
	Xeq gr combine male.gph female.gph, col(1) scale(1)
	Xeq erase male.gph
	Xeq erase female.gph
	Msg restore
end

program combine3
	NewFile male.gph
	NewFile female.gph
	Msg preserve
	preserve
	Xeq sysuse uslifeexp, clear 
	Xeq line le_male   year, saving(male)
	Xeq line le_female year, saving(female)
	Xeq gr combine male.gph female.gph, ycommon 
	Xeq erase male.gph
	Xeq erase female.gph
	Msg restore
end

program combine4
	NewFile hy.gph 
	NewFile hx.gph
	NewFile yx.gph
	Msg preserve
	preserve
	Xeq sysuse lifeexp, clear 
	Xeq gen loggnp = log10(gnppc)
	Xeq label var loggnp "Log base 10 of GNP per capita"

	#delimit ;
	Xeq
	scatter lexp loggnp, 
		ysca(alt) xsca(alt) 
		xlabel(, grid gmax)
		saving(yx)
	;
	Xeq
	twoway histogram lexp, fraction
		xsca(alt reverse) horiz
		saving(hy)
	;
	Xeq
	twoway histogram loggnp, fraction
		ysca(alt reverse)
		ylabel(,nogrid) xlabel(,grid gmax) 
		saving(hx)
	;
	Xeq
	graph combine hy.gph yx.gph hx.gph, 
		hole(3) 
		imargin(0 0 0 0) graphregion(margin(l=22 r=22))
		title("Life expectancy at birth vs. GNP per capita")
		note("Source:  1998 data from The World Bank Group")
	;
	#delimit cr
	Xeq erase hy.gph
	Xeq erase hx.gph
	Xeq erase yx.gph
	Msg restore
end

program combine5
	NewFile hy.gph 
	NewFile hx.gph
	NewFile yx.gph
	Msg preserve
	preserve
	Xeq sysuse lifeexp, clear 
	Xeq gen loggnp = log10(gnppc)
	Xeq label var loggnp "Log base 10 of GNP per capita"

	#delimit ;
	Xeq
	scatter lexp loggnp, 
		ysca(alt) xsca(alt) 
		xlabel(, grid gmax)
		saving(yx)
	;
	Xeq
	twoway histogram lexp, fraction
		xsca(alt reverse) horiz
		fxsize(25)
		saving(hy)
	;
	Xeq
	twoway histogram loggnp, fraction
		ysca(alt reverse) ylabel(0(.1).2, nogrid)
		xlabel(,grid gmax) fysize(25)
		saving(hx)
	;
	Xeq
	graph combine hy.gph yx.gph hx.gph, 
		hole(3) 
		imargin(0 0 0 0) graphregion(margin(l=22 r=22))
		title("Life expectancy at birth vs. GNP per capita")
		note("Source:  1998 data from The World Bank Group")
	;
	#delimit cr
	Xeq erase hy.gph
	Xeq erase hx.gph
	Xeq erase yx.gph
	Msg restore
end

program define NewFile 
	args fn
	capture confirm new file `fn'
	if _rc {
		di as txt "{p 0 2 2}"
		di "Example cannot be run because you already have a"
		di "file named {res:`fn'}"
		di "{p_end}"
		error 602
	}
end


program plotop1
	Msg preserve
	preserve
	Xeq sysuse cancer, clear
	Xeq stset studytime, fail(died)
	Xeq sts graph
	Msg restore
end

program plotop2
	Msg preserve
	preserve
	qui sysuse cancer, clear
	qui stset studytime, fail(died)
	Xeq quietly streg, distribution(exponential)
	Xeq predict S, surv
	Xeq graph twoway line S _t, sort
	Msg restore
end

program plotop3
	Msg preserve
	preserve
	qui sysuse cancer, clear
	qui stset studytime, fail(died)
	qui streg, distribution(exponential)
	qui predict S, surv
	Xeq sts graph, plot(line S _t, sort)
	Msg restore
end

program grbar0
	preserve
	quietly {
		drop _all
		set obs 1 
		gen ne = 27.9 in 1
		gen nc = 21.7 in 1
		gen south = 46.1 in 1
		gen west = 46.2 in 1
	}
	Xeq graph bar (asis) ne nc south west
end

program grbar0b
	preserve
	quietly {
		drop _all
		set obs 4 
		gen tempjan = 27.9 in 1
		replace tempjan = 21.7 in 2
		replace tempjan = 46.1 in 3
		replace tempjan = 46.2 in 4
		gen str8 region = "N.E." in 1
		replace region = "N. Central" in 2
		replace region = "South" in 3
		replace region = "West" in 4
	}
	Xeq graph bar (asis) tempjan, over(region)
end

program grbar1a
	Msg preserve
	preserve
	Xeq sysuse citytemp4, clear 
	#delimit ;
	Xeq gr bar tempjuly tempjan, over(region)
		legend( label(1 "July") label(2 "January") )
		ytitle("Degrees Fahrenheit")
		title("Average July and January temperatures")
		subtitle("by regions of the United States")
		note("Source:  U.S. Census Bureau, U.S. Dept. of Commerce")
	;
	#delimit cr
	Msg restore
end


program grbar1lab
	Msg preserve
	preserve
	Xeq sysuse citytemp4, clear 
	#delimit ;
	Xeq gr bar tempjuly tempjan, over(region)
		bargap(-30)
		legend( label(1 "July") label(2 "January") )
		ytitle("Degrees Fahrenheit")
		title("Average July and January temperatures")
		subtitle("by regions of the United States")
		note("Source:  U.S. Census Bureau, U.S. Dept. of Commerce")
		blabel(bar, position(inside) format(%9.1f) color(white))
	;
	#delimit cr
	Msg restore
end
		

program grbar1
	Msg preserve
	preserve
	Xeq sysuse citytemp4, clear 
	#delimit ;
	Xeq gr bar tempjuly tempjan, over(region)
		bargap(-30)
		legend( label(1 "July") label(2 "January") )
		ytitle("Degrees Fahrenheit")
		title("Average July and January temperatures")
		subtitle("by regions of the United States")
		note("Source:  U.S. Census Bureau, U.S. Dept. of Commerce")
	;
	#delimit cr
	Msg restore
end

program grbar2
	Msg preserve
	preserve
	Xeq sysuse citytemp4, clear 
	#delimit ;
	Xeq graph bar (mean) tempjuly tempjan,
		over(division, label(labsize(*.75)))
		over(region)
		bargap(-30) nofill
		ytitle("Degrees Fahrenheit")
		legend( label(1 "July") label(2 "January") )
		title("Average July and January temperatures")
		subtitle("by region and division of the United States")
		note("Source:  U.S. Census Bureau, U.S. Dept. of Commerce")
	;
	#delimit cr
	Msg restore
end
	

program grbar3
	Msg preserve
	preserve
	Xeq sysuse citytemp4, clear 
	#delimit ;
	Xeq gr hbar tempjan, over(division) over(region) nofill
		ytitle("Degrees Fahrenheit")
		title("Average January temperature")
		subtitle("by region and division of the United States")
		note("Source:  U.S. Census Bureau, U.S. Dept. of Commerce")
	;
	#delimit cr
	Msg restore
end

program grbar5
	NotSmall
	Msg preserve
	preserve
	Xeq sysuse nlsw88, clear
	#delimit ;
	Xeq graph bar wage, over(smsa) over(married) over(collgrad)

	title("Average Hourly Wage, 1988, Women Aged 34-46")
	subtitle("by College Graduation, Marital Status, and SMSA residence")
	note(
"Source:  1988 data from NLS, U.S. Dept. of Labor, Bureau of Labor Statistics"
	)
	;
	#delimit cr
	Msg restore
end


program grbar5b0
	NotSmall
	Msg preserve
	preserve
	Xeq sysuse nlsw88, clear
	Xeq graph bar wage, over(smsa) over(married) over(collgrad)
	Msg restore
end


program grbar5b
	NotSmall
	Msg preserve
	preserve
	Xeq sysuse nlsw88, clear
	#delimit ;
	Xeq graph bar wage, over(smsa, descend gap(-30)) 
			    over(married) 
	over(collgrad, relabel(1 "Not college graduate" 2 "College graduate"))
	ytitle("")
	title("Average Hourly Wage, 1988, Women Aged 34-46")
	subtitle("by College Graduation, Marital Status, and SMSA residence")
	note(
"Source:  1988 data from NLS, U.S. Dept. of Labor, Bureau of Labor Statistics"
	)
	;
	#delimit cr
	Msg restore
end

program grbar7a
	Msg preserve
	preserve
	Xeq sysuse educ99gdp, clear
	Xeq gen total = private + public
	Xeq graph hbar (asis) public private, over(country)
	Msg restore
end

program grbar7
	Msg preserve
	preserve
	Xeq sysuse educ99gdp, clear
	Xeq gen total = private + public
	#delimit ;
	Xeq graph hbar (asis) public private, 
		over(country, sort(total) descending) stack
		title("Spending on tertiary education as % of GDP, 1999",
			span pos(11))
		subtitle(" ")
		note("Source:  OECD, Education at a Glance 2002", span)
	;
	#delimit cr
	Msg restore
end

program grbar8
	Msg preserve
	preserve
	Xeq sysuse educ99gdp, clear
	gen frac = private / (private + public)
	#delimit ;
	Xeq graph hbar (asis) public private, 
		over(country, sort(frac) descending) stack percentage
		title("Public and private spending on tertiary education, 1999",
			span pos(11))
		subtitle(" ")
		note("Source:  OECD, Education at a Glance 2002", span)
	;
	#delimit cr
	Msg restore
end

program grbar9
	Msg preserve
	preserve
	Xeq sysuse citytemp, clear
	Xeq graph bar , over(division) 
	Msg restore
end

program grbar10
	Msg preserve
	preserve
	Xeq sysuse citytemp, clear
	Xeq graph bar (count), over(division) 
	Msg restore
end


program grbartall
	NotSmall
	Msg preserve
	preserve
	Xeq sysuse nlsw88, clear
	#delimit ;
	Xeq graph hbar wage, over(ind, sort(1)) over(collgrad)
		title("Average hourly wage, 1988, women aged 34-46", span)
                subtitle(" ")
                note("Source:  1988 data from NLS, U.S. Dept. of Labor, Bureau of Labor Statistics", span)
                ysize(7)
	;
	#delimit cr
	Msg restore
end

program grblab1
	NotSmall
	Msg preserve
	preserve
	Xeq sysuse nlsw88, clear
	#delimit ;
	Xeq graph hbar wage, 
	         over( occ, axis(off) sort(1) )
	       blabel( group, pos(base) color(bg) )
	       ytitle( "" )
		   by( union, 
		       title("Average Hourly Wage, 1988, Women Aged 34-46")
		       note("Source:  1988 data from NLS, U.S. Dept. of Labor, Bureau of Labor Statistics")
		     )
	;
	#delimit cr
	Msg restore
end




program grdottall
	NotSmall
	Msg preserve
	preserve
	Xeq sysuse nlsw88, clear
	#delimit ;
	Xeq graph dot wage, over(occ, sort(1)) 
		ytitle("")
		title("Average hourly wage, 1988, women aged 34-46", span)
                subtitle(" ")
                note("Source:  1988 data from NLS, U.S. Dept. of Labor, Bureau of Labor Statistics", span)
	;
	#delimit cr
	Msg restore
end

program grdottall2
	NotSmall
	Msg preserve
	preserve
	Xeq sysuse nlsw88, clear
	#delimit ;
	Xeq graph dot (p10) wage (p90) wage,
		over(occ, sort(2)) 
		legend(label(1 "10th percentile") label(2 "90th percentile"))
		title("10th and 90th percentiles of hourly wage", span)
		subtitle("Women aged 34-46, 1988" " ", span)
                note("Source:  1988 data from NLS, U.S. Dept. of Labor, Bureau of Labor Statistics", span)
	;
	#delimit cr
	Msg restore
end

program grdotby0
	NotSmall
	Msg preserve
	preserve
	Xeq sysuse nlsw88, clear
	Xeq graph dot wage, over(occ) by(collgrad) 
	Msg restore
end

program grdotby
	NotSmall
	Msg preserve
	preserve
	Xeq sysuse nlsw88, clear
	#delimit ;
	Xeq graph dot wage, 
		over(occ, sort(1))
		by(collgrad, 
			title("Average hourly wage, 1988, women aged 34-46", span)
			subtitle(" ")
                	note("Source:  1988 data from NLS, U.S. Dept. of Labor, Bureau of Labor Statistics", span)
		)
	;
	#delimit cr
	Msg restore
end

program grbox1a
	Msg preserve
	preserve
	Xeq sysuse bplong, clear
	Xeq graph box bp, over(when) over(sex)
	#delimit cr
	Msg restore
end

program grbox1
	Msg preserve
	preserve
	Xeq sysuse bplong, clear
	#delimit ;
	Xeq graph box bp, over(when) over(sex)
		ytitle("Systolic blood pressure")
		title("Response to treatment, by Sex")
		subtitle("(120 Preoperative Patients)" " ")
		note("Source:  Fictional Drug Trial, StataCorp, 2003")
	;
	#delimit cr
	Msg restore
end

program grbox2
	NotSmall
	Msg preserve
	preserve
	Xeq sysuse nlsw88, clear
	#delimit ;
	Xeq graph hbox wage, over(ind, sort(1)) nooutside
		ytitle("")
		title("Hourly wage, 1988, woman aged 34-46", span)
		subtitle(" ")
		note(
"Source:  1988 data from NLS, U.S. Dept. of Labor, Bureau of Labor Statistics"
		, span)
	;
	#delimit cr
	Msg restore
end


program grboxby
	NotSmall
	Msg preserve
	preserve
	Xeq sysuse nlsw88, clear
	#delimit ;
	Xeq graph hbox wage, over(ind, sort(1)) nooutside
		ytitle("")
		by(union,
		title("Hourly wage, 1988, woman aged 34-46", span)
		subtitle(" ")
		note(
"Source:  1988 data from NLS, U.S. Dept. of Labor, Bureau of Labor Statistics"
		, span)
		)
	;
	#delimit cr
	Msg restore
end

program grlinee
	Msg preserve
	preserve
	Xeq sysuse uslifeexp2, clear
	#delimit ;
	Xeq line le year, sort 
		title("Line plot")
		subtitle("Life expectancy at birth, U.S.")
		note("1")
		caption(
		"Source:  National Vital Statistics Report, Vol. 50 No. 6")
	;
	#delimit cr
	Msg restore
end

program grscae
	Msg preserve
	preserve
	Xeq sysuse uslifeexp2, clear
	#delimit ;
	Xeq scatter le year,
		title("Scatterplot")
		subtitle("Life expectancy at birth, U.S.")
		note("1")
		caption(
		"Source:  National Vital Statistics Report, Vol. 50 No. 6")
		scheme(economist)
	;
	#delimit cr
	Msg restore
end

program pie1a
	Msg preserve
	preserve

	quietly { 
		drop _all
		set obs 1
		gen sales = 12
		gen marketing = 14
		gen research = 2
		gen development = 8 
		label var sales "Sales"
		label var marketing "Marketing"
		label var research "Research"
		label var development "Development"
	}
	Xeq graph pie sales marketing research development
	Msg restore
end

program pie1
	Msg preserve
	preserve

	quietly { 
		drop _all
		set obs 1
		gen sales = 12
		gen marketing = 14
		gen research = 2
		gen development = 8 
		label var sales "Sales"
		label var marketing "Marketing"
		label var research "Research"
		label var development "Development"
	}
	#delimit ;
	Xeq graph pie sales marketing research development, 
		plabel(_all name, size(*1.5) color(white))
		legend(off)
		plotregion(lstyle(none))
		title("Expenditures, XYZ Corp.")
		subtitle("2002")
		note("Source:  2002 Financial Report (fictional data)")
		;
	#delimit cr
	Msg restore
end


program pie2
	Msg preserve
	preserve

	quietly { 
		drop _all
		set obs 16
		gen qtr = 1 in 1/4
		replace qtr = 2 in 5/8
		replace qtr = 3 in 9/12
		replace qtr = 4 in 13/16
		gen str division = "Development" if mod(_n,4)==1
		replace division = "Marketing" if mod(_n,4)==2
		replace division = "Research" if mod(_n,4)==3
		replace division = "Sales" if mod(_n,4)==0
		gen cost     = 1   in 1
		replace cost = 4.5 in 2
		replace cost =  .3 in 3
		replace cost = 3   in 4

		replace cost = 2   in 5
		replace cost = 3.0 in 6
		replace cost =  .5 in 7
		replace cost = 4   in 8

		replace cost = 2   in 9
		replace cost = 4.0 in 10
		replace cost =  .6 in 11
		replace cost = 3   in 12

		replace cost = 3   in 13
		replace cost = 2.5 in 14
		replace cost =  .6 in 15
		replace cost = 2   in 16

	}
	#delimit ;
	Xeq graph pie cost, over(division)
		plabel(_all name, size(*1.5) color(white))
		legend(off)
		plotregion(lstyle(none))
		title("Expenditures, XYZ Corp.")
		subtitle("2002")
		note("Source:  2002 Financial Report (fictional data)")
		;
	#delimit cr
	Msg restore
end

program pie3
	Msg preserve
	preserve

	quietly { 
		drop _all
		set obs 2
		gen year = 2002 in 1
		gen sales = 12 in 1
		gen marketing = 14 in 1
		gen research = 2 in 1
		gen development = 8 in 1

		replace year = 2003 in 2
		replace sales = 15 in 2
		replace marketing = 17.5 in 2
		replace research = 8.5 in 2
		replace development = 10 in 2

		label var sales "Sales"
		label var marketing "Marketing"
		label var research "Research"
		label var development "Development"
	}
	#delimit ;
	Xeq graph pie sales marketing research development, 
		plabel(_all name, size(*1.5) color(white))
		by(year,
			legend(off)
			title("Expenditures, XYZ Corp.")
			note("Source:  2002 Financial Report (fictional data)")
		)
		;
	#delimit cr
	Msg restore
end


program twopcspike1
	Msg preserve
	preserve
	Xeq sysuse nlswide1, clear
	Xeq twoway pcspike wage68 ttl_exp68 wage88 ttl_exp88	||	///
	scatter wage68 ttl_exp68, msym(O)			||	///
	scatter wage88 ttl_exp88, msym(O) pstyle(p4)		///
		mlabel(occ) xscale(range(17))				///
		title("Change in US Women's Experience and Earnings")	///
		subtitle("By Occupation -- 1968 to 1988")		///
		ytitle(Hourly wages) xtitle(Total experience)		///
		note("Source: National Longitudinal Survey of Young Women") ///
		legend(order(2 "1968" 3 "1988"))
	Msg restore
end

program twopcspike2
	Msg preserve
	preserve
	Xeq sysuse network1a, clear
	Xeq twoway pcspike y_c x_c y_l x_l, pstyle(p3)	    ||		///
       pcspike y_c x_c y_r x_r, pstyle(p4)	    ||			///
       scatter y_l x_l        , pstyle(p3) msize(vlarge) msym(O)	///
       			        mlabel(lab_l) mlabpos(9)	  ||	///
       scatter y_c x_c        , pstyle(p5) msize(vlarge) msym(O)  ||	///
       scatter y_r x_r        , pstyle(p4) msize(vlarge) ms(O)		///
       				mlabel(lab_r) mlabpos(3)		///
	       yscale(off) xscale(off) ylabels(, nogrid) legend(off)	///
	       plotregion(margin(30 15 3 3))


	Msg restore
end

program barbsize
	Msg preserve
	preserve
	Xeq drop _all
	Xeq label drop _all
	Xeq set obs 3
	Xeq gen x1 = 1
	Xeq gen x2 = 2
	Xeq gen y1 = _n
	Xeq gen y2 = _n
	Xeq gen l = _n
	Xeq label define blbl 1 "barbsize(0)" 2 "barbsize(2)" 3 "barbsize(4)"
	Xeq label val l blbl

	Xeq twoway pcarrow y1 x1 y2 x2 in 1, msize(4) mlabel(l) mlabs(4)     ///
					     headlab			  || ///
		   pcarrow y1 x1 y2 x2 in 2, msize(4) mlabel(l) mlabs(4)     ///
			   		     headlab barbsize(2) psty(p1) || ///
		   pcarrow y1 x1 y2 x2 in 3, msize(4) mlabel(l) mlabs(4)     ///
			   		     headlab barbsize(4) psty(p1)    ///
		   plotregion(margin(10 30 5 5))			     ///
		   legend(off) ylabel(, nogrid)				     ///
		   yscale(range(.3 3.5) reverse off) xscale(off)	     ///
		   title("Example barbsize()s with msize(4)")
	Msg restore
end

program pcarrow1
	Msg preserve
	preserve
	_arrow_dta1
	Xeq twoway pcarrow y1 x1 y2 x2
	Msg restore
end

program pcarrow1b
	Msg preserve
	preserve
	_arrow_dta1
	Xeq twoway pcarrow y1 x1 y2 x2 , aspect(1) mlabel(time)		///
		   mlabvposition(pos) headlabel plotregion(margin(vlarge))
	Msg restore
end

program _arrow_dta1
	drop _all
	set obs 2
	qui gen     x1 = 0
	qui gen     y1 = 0
	qui gen     x2 = 1 in 1
	qui gen     y2 = 0 in 1
	qui replace x2 = 0 in 2
	qui replace y2 = 1 in 2
	qui gen str time = "3 o'clock"  in 1
	qui replace time = "12 o'clock" in 2
	qui gen     pos =  3 in 1
	qui replace pos = 12 in 2
end


program pcarrow2
	Msg preserve
	preserve
	Xeq sysuse nlsw88, clear

	Xeq keep if occupation <= 8

	Xeq collapse (p05) p05=wage (p95) p95=wage (p50) p50=wage, by(occupation)
	Xeq gen mid = (p05 + p95) / 2
	Xeq gen dif = (p95 - p05)
	Xeq gsort -dif
	Xeq gen srt = _n

	Xeq twoway pcbarrow srt p05 srt p95 ||			///
            scatter  srt mid, msymbol(i) mlabel(occupation)	///
       			 mlabpos(12) mlabcolor(black)		///
	    plotregion(margin(t=8)) yscale(off)			///
	    ylabel(, nogrid) legend(off)			///
	    title("90 Percentile Range of US Women's Wages by Occupation") ///
	    ytitle(Hourly wages)					   ///
	    note("Source: National Longitudinal Survey of Young Women")
	Msg restore
end

program pcarrowi1
	Msg preserve
	preserve
	Xeq sysuse auto, clear
	Xeq twoway qfitci  mpg weight, stdf  ||				 ///
		   scatter mpg weight, ms(O) ||				 ///
		   pcarrowi 41 2200 41 2060 (3) "VW Diesel"		 ///
		   	    31 3460 28 3280 (3) "Plymouth Arrow"	 ///
			    35 2250 35 2070 (3) "Datsun 210 and Subaru", ///
		   legend(order(1 2 3))
	Msg restore
end

program funcsup1
	Xeq twoway function y = 2*exp(-2*x), range(0 2) title("{&function}(x)=2e{superscript:-2x}")
end

program funcsup2
	Xeq twoway function y = gammaden(1.5,2,0,x), range(0 10) title("{&chi}{sup:2}(3) distribution")
end

program qchi1
	Msg preserve
	preserve
	Xeq sysuse auto, clear
	Xeq egen c1 = std(price)
	Xeq egen c2 = std(mpg)
	Xeq generate ch = c1^2 + c2^2
	Xeq qchi ch, df(2) grid
	Msg restore
end

program minorticks1
	Msg preserve
	preserve
	Xeq sysuse auto, clear
	Xeq scatter mpg weight, ymlabel(##5) xmtick(##10)
	Msg restore
end
