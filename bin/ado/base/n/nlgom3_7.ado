*! version 1.1.4 28oct2004
program define nlgom3_7
	version 6
        if "`1'"=="?" {
                local depv "`e(depvar)'"
                nlgom4 ? "`2'"
                global S_2 /*
*/ "3-parameter Gompertz function, `depv'=b1*exp(-exp(-b2*(`2'-b3)))"
                global S_1 "b1 b2 b3"
                exit
        }
        replace `1'=$b1*exp(-exp(-$b2*(`2'-$b3)))
end
