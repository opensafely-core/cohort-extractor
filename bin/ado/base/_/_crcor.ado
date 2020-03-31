*! version 3.1.3  14feb2000
program define _crcor, rclass /* a b c d level tbflg*/
	version 3.1
	local a `1'
	local b `2'
	local c `3'
	local d `4'
	local level `5'
	local tbflg `6'

	local r=(`a'*`d')/(`b'*`c')
	if "`tbflg'"=="" { 
		_crcrnfd `a' `b' `c' `d' `level'
		ret scalar ub = r(ub)
		ret scalar lb = r(lb)
		ret scalar nf = `r'
		ret local label "(Cornfield)"
		exit
	}
	ret scalar nf = `r'
	tempname iz
	scalar `iz'=invnorm(1-(1-`level'/100)/2)
	if "`tbflg'"=="woolf" { 
		tempname sdlnr
		scalar `sdlnr'=sqrt(1/`a'+1/`b'+1/`c'+1/`d')
		ret scalar lb = exp(ln(`r')-`iz'*`sdlnr')
		ret scalar ub = exp(ln(`r')+`iz'*`sdlnr')
		ret local label "(Woolf)"
		exit
	}
	tempname m1 m0 n1 n0 t x
	scalar `m1'=`a'+`b'
	scalar `m0'=`c'+`d'
	scalar `n1'=`a'+`c'
	scalar `n0'=`b'+`d'
	scalar `t'=`n1'+`n0'
	scalar `x'=(`a'-`n1'*`m1'/`t')/ /* 
			*/ sqrt((`m1'*`m0'*`n1'*`n0')/(`t'^2*(`t'-1)))
	ret scalar lb = return(nf)^(1-`iz'/`x')
	ret scalar ub = return(nf)^(1+`iz'/`x')
	if return(lb)>return(ub) { 
		tempname hold
		scalar `hold' = return(lb)
		ret scalar lb = return(ub)
		ret scalar ub = `hold'
	}
	ret local label "(tb)"
	if `a'==0 | `d'==0 { 
		ret scalar lb = .
		ret scalar ub = .
	}
end

program define _crcrnfd, rclass
	version 3.1
	local a `1'
	local b `3' /* sic */
	local c `2' /* sic */
	local d `4'

	tempname iz m1 n1 n2 al alold i

	scalar `iz'=invnorm(1-(1-`5'/100)/2)
	scalar `m1'=`a'+`b'
	scalar `n1'=`a'+`c'
	scalar `n2'=`b'+`d'
	scalar `i' = 0 
	scalar `al'= `a'
	scalar `alold'= .
	while abs(`al'-`alold')>.001 & `al'!=. { 
		scalar `alold' = `al'
		scalar `al'=`a'-`iz'*1/sqrt(1/`al'+1/(`m1'-`al')+/*
			*/ 1/(`n1'-`al')+ 1/(`n2'-`m1'+`al'))
		if `al'==. {
			scalar `i'=`i'+1
			scalar `al'=`a'-`i'
			if (`al'<0 | (`n2'-`m1'+`al')<0) { scalar `al'= . } 
		}
	}
	if `al'==. { scalar `al'= 0 } 
	ret scalar lb = `al'*(`n2'-`m1'+`al')/((`m1'-`al')*(`n1'-`al'))
	scalar `al'= `a'
	scalar `alold'= . 
	scalar `i'= 0 
	while abs(`al'-`alold')>.001 & `al'!=. {
		scalar `alold'= `al'
		scalar `al'=`a'+`iz'*1/sqrt(1/`al'+1/(`m1'-`al')+/*
			*/ 1/(`n1'-`al')+ 1/(`n2'-`m1'+`al'))
		if `al'==. {
			scalar `i'=`i'+1
			scalar `al'=`a'+`i'
			if (`al'>`n1'|`al'>`m1') { scalar `al' = . } 
		}
	}
	ret scalar ub = `al'*(`n2'-`m1'+`al')/((`m1'-`al')*(`n1'-`al'))
end
exit
cumulative incidence data, odds ratio
R-165	OR
R-173   woolf se 
S-182   (Schlesselman 1982) cornfield calculation description 
R-174   test based
R-163	eq 11-6, definition of test x

