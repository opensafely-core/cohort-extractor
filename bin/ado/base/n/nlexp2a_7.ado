*! version 1.1.3  28oct2004
program define nlexp2a_7
	version 6
        if "`1'"=="?" {
                local depv "`e(depvar)'"
                nlexp3_7 ? "`2'"
                global b1 $b0
                global S_2 /*
		*/ "2-parameter asymptotic regression, `depv'=b1*(1-b2^`2')"
                global S_1 "b1 b2"
                exit
        }
        replace `1'=$b1*(1-(($b2)^`2'))
end
