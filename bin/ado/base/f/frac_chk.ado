*! version 6.3.2  28jan2015  
program define frac_chk, sclass
	version 8
	args cmd
	sret clear
	if bsubstr("`cmd'", 1, 3)=="reg" local cmd regress

	tokenize clogit cnreg _cnreg cox ereg fit glm intreg logistic logit poisson probit /*
		*/ qreg regress rreg weibull xtgee streg stcox stpm stpm2 stcrreg /*
		*/ ologit oprobit mlogit mprobit nbreg xtreg xtlogit

	sret local bad 0
	local done 0
	while "`1'"!="" & !`done' {
		if "`1'"=="`cmd'" local done 1
		mac shift
	}
	if !`done' {
		sret local bad 1
		exit
	}
	/*
		dist=0 (normal), 1 (binomial/multinomial), 2 (poisson), 3 (cox), 4 (glm),
		5 (xtgee), 6(ereg/weibull).
	*/
	if "`cmd'"=="logit" | "`cmd'"=="probit" | "`cmd'"=="mprobit" /*
 	*/ |"`cmd'"=="clogit"| "`cmd'"=="logistic" /*
 	*/ |"`cmd'"=="mlogit"| "`cmd'"=="ologit" | "`cmd'"=="oprobit" /*
 	*/ |"`cmd'"=="xtlogit" {
						sret local dist 1
	}
	else if "`cmd'"=="poisson" {
						sret local dist 2
	}
	else if "`cmd'"=="cox" {
						sret local dist 3
	}
	else if "`cmd'"=="glm" {
						sret local dist 4
	}
	else if "`cmd'"=="xtgee" {
						sret local dist 5
	}
	else if "`cmd'"=="cnreg" | "`cmd'"=="_cnreg" | "`cmd'"=="ereg" | "`cmd'"=="weibull" | "`cmd'"=="nbreg" {
						sret local dist 6
	}
	else if "`cmd'"=="stcox" | "`cmd'"=="streg" | "`cmd'"=="stpm" | "`cmd'"=="stpmrs" | "`cmd'"=="stpm2" | "`cmd'"=="stcrreg" {
						sret local dist 7
	}
	else if "`cmd'"=="intreg" {
						sret local dist 8
	}
	else				sret local dist 0

	sret local isglm  = (`s(dist)'==4)
	sret local isqreg = ("`cmd'"=="qreg")
	sret local isxtgee= (`s(dist)'==5)
	sret local isnorm = ("`cmd'"=="regress"|"`cmd'"=="fit"|"`cmd'"=="rreg") 
end
