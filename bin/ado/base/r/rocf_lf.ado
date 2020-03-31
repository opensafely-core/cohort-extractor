*! version 7.0.0  17feb2000
program def rocf_lf
	version 6.0
	args lnf  a b $ZV
	tempvar p 
	local max: word count $ZV
	qui gen double `p'= normprob(`z1') if $MC==1 & $MD==0
	qui replace `p'= normprob(`b'*`z1'-`a') if $MC==1 & $MD==1
	local i 2
	while `i'<=`max' {              /* max=4 */
		local j=`i'-1
		qui replace /*
		*/ `p'= normprob(`z`i'')- normprob(`z`j'') if $MC==`i' & $MD==0
		qui replace /*
		*/ `p'= normprob(`b'*`z`i''-`a') /*
		*/ - normprob(`b'*`z`j''-`a') if $MC==`i' & $MD==1
		local i=`i'+1
	}
	qui replace `p'= 1-normprob(`z`max'') if $MC==`max'+1  & $MD==0
	qui replace `p'= 1-normprob(`b'*`z`max''-`a') if $MC==`max'+1  & $MD==1
	qui replace `lnf'=ln(`p')
	qui replace $MP= `p'
	*if `todo'==0 | `lnf==. { exit }
	*tempname da db 
end

