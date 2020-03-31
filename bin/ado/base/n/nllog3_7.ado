*! version 1.1.3  28oct2004
program define nllog3_7
	version 6
        if "`1'"=="?" {
                local depv "`e(depvar)'"
                nllog4_7 ? "`2'"
                global S_2 /*
	*/ "3-parameter logistic function, `depv'=b1/(1+exp(-b2*(`2'-b3)))"
                global S_1 "b1 b2 b3"
                exit
        }
        replace `1'=$b1/(1+exp(-$b2*(`2'-$b3)))
end
