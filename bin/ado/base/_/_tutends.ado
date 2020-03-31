*! version 7.0.1  12sep2000
program define _tutends /* next */
	version 6
	set more off
	#delimit ;
	di _n(4) in smcl in gr "{title:Demonstration ends}" _n; 

	global F6 "tutorial `1';" ;

	di in gr
"That concludes our short demonstration, but there's much more.  We now return"
	_n
"control to you.  Some suggestions:" _n ;

	di in smcl in gr   
	_col(5) "If you" _col(49) "Then we will show you" _n
	_col(5) "{hline 72}" _n
	_col(5) "Press F5 or type '" "{stata tutorial contents:tutorial contents}" in gr "'"
	_col(49) "a table of tutorial contents" _n(2)
	_col(5) "Press F6 or type '" "{stata tutorial `1':tutorial `1'}" in gr "'"
	_col(49) "the next tutorial" _n 
	_col(5) "{hline 72}" _n ;

	di in gr _n
	"And remember:" _n(2)
	"    Macintosh, Unix(GUI), and Windows users can pull down "
	in wh "Help" in gr " from Stata's" _n 
	"    menu bar." _n;
	di in smcl in gr 
	"    All users can type '" "{cmd:help}" in gr "' (or press "
	"F1" in gr " followed by " "Return" in gr ")." _n ;
end ; 
exit ;
