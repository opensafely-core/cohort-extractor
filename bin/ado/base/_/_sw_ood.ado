program define _sw_ood /* realcommand swcmd */
* touched by kth
	if _caller()<5 {
		exit
	}
	version 5.0
	#delimit ;
	di in ye _n "`2'" in gr 
" is an out-of-date command; " in ye "sw `1'" in gr " is its replacement." _n
"We recommend using " in ye "sw `1'" in gr " over " in ye "`2'"
in gr "." _n
"If you must use " in ye "`2'" in gr ", set the version to 4.0:" ;
di _n _col(8) in ye ". version 4.0" _n _col(8) ". `2' " in gr "..." _n(2)
"After running " in ye "`2'" in gr ", remember to set the version back to 5.0"
_n(2) _col(8) in ye ". version 5.0" _n ;
	#delimit cr
	exit 199
end
exit
/*
swcox is an out-of-date command:  sw cox is its replacement.
We recommend use of sw cox over swcox.
If you must use swcox, you should set the version to 4.0:

        . version 4.0
        . swcox ...

After running swcox, remember to set the version back to 5.0:

         . version 5.0
r(199);
*/
