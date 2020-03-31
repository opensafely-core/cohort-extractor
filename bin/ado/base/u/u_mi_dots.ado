*! version 1.0.1  03feb2015

/*
Example 1: 
	u_mi_dots, title(Iterate) 
	u_mi_dots 1 0
	u_mi_dots 2 0
	u_mi_dots 3 2000
	u_mi_dots, last
Result 1:
	1234567891234567		
	----------------
	Iterate ..x done			<- output

Example 2: 
	u_mi_dots, title(Iterate) indent(4) reps(2)
	u_mi_dots 1 0
	u_mi_dots 2 0
	u_mi_dots, last
Result 2:
	12345678912345678912345
	    Iterate (2) .. done			< output
		
Example 3: 
	u_mi_dots, title(Iterate)
	u_mi_dots 1 0, every(5)
	<repeat iteratively>
	u_mi_dots 10 0, every(5)
	u_mi_dots, last reps(10)
Result 3:
	12345678912345678912345678912
	Iterate ....5....10 done (10)		< output

Result 3alt: long output
	123456789123456789123456789
				  |
				 \ / end of linesize
	Iterate ....5....10...15..		< output
>..20.. done (22)				< output
*/
program u_mi_dots
	version 11
	syntax [anything] [, 	title(string) reps(integer -1) noDOTS 	///
				indent(real 0) every(real 0) last       ///
                                SYMBol(string)]
	if ("`dots'"!="") exit

	tokenize `anything'
	args i rc
	if ("`anything'"!="" & "`rc'"=="") {
		di as err "you must specify both the iteration number " ///
			  "and the error code"
		exit 198
	}
	// begin
	if (`indent'>0) {
		di as txt "{col `++indent'}" _c
	}
	if `"`title'"' != "" {
		di as txt `"`title' "' _c
		if (`reps'>-1) {
			di as res "`reps' " _c
		}
	}
	// always printing 'x' if rc!=0, 
	// printing `symbol' or '.' or `every' if rc==0
	if ("`anything'"!="") {
		if `rc'>0 {
			di as txt "{bf:x}" _c
		}
		else if mod(`i',`every') == 0 {
			di as txt `i' _c
		}
		else if inlist("`rc'", "0", "text") {
			if (`"`symbol'"'!="") {
				di as txt `"`symbol'"' _c
			}
			else {
				di as txt "." _c
			}
		}
	}
	// printing 'done' [(# of reps)]
	if ("`last'"!="") {
		di as txt " done" _c
		if (`reps'>-1) {
			di as txt " (" as res `reps' as txt ")"
		}
		else {
			di
		}
	}
end
