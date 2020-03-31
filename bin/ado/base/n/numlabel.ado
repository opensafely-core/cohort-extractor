*! version 1.2.0  16feb2015
program numlabel
	version 9

	syntax [anything(id=labellist name=names)] ///
		[, Add Remove Mask(str) Detail force ]

	if "`add'" != "" & "`remove'" != "" {
		dis as err "options add and remove must not be both specified"
		exit 198
	}
	if "`add'" == "" & "`remove'" == "" {
		dis as err "option add or remove should be specified"
		exit 198
	}
	if `"`mask'"' != "" {
		loc tmp: subinstr local mask "#" "", all count(local nch)
		if `nch' != 1 {
			dis as err `"mask `mask' should contain "' ///
			           `"1 substitution char #"'
			exit 198
		}
	}
	else 	local mask "#. "

// parsing is ready

	preserve
	tempname lname label value
	matalabel `names', gen(`lname' `value' `label')
	capture rcof "mata rows(`lname') >= 1" == 0
	if _rc {
		capture mata: mata drop `lname' `value' `label'
		exit
	}

	tempname prefix
	tempfile f
	capture noisily mata: __numlabel_wrk(`lname',`value',`label',`"`mask'"',"`add'","`remove'","`force'","`detail'",`"`f'"')
	local rc = _rc
	capture mata: mata drop `lname' `value' `label'
	if (`rc') {
		exit `rc'
	}

	// bring back original data, and run definition file
	restore

	capture confirm file `"`f'"'
	if (_rc == 0) {
		run `"`f'"'
	}
end

version 9
mata:
void __numlabel_wrk(string colvector lname, real colvector lvalue, string colvector llab, string scalar mask, string scalar add, string scalar remove, string scalar force, string scalar detail, string scalar tempf)
{
	string colvector	prefix
	real colvector		numlab
	real matrix		lpanel
	real scalar		i, j
	string colvector	badl
	real scalar		cnt
	string colvector	modlabel
	transmorphic colvector	towrite
	real scalar		fh
	transmorphic matrix	subnam, subnum, subunq, sublab, subval
	real scalar		newlen

	prefix = subinstr(mask, "#", strofreal(lvalue, "%20.0g"), 1)

	numlab = (prefix :== bsubstr(llab,1,bstrlen(prefix)))

	lpanel = panelsetup(lname, 1)

	if (force == "") {
		badl=J(0,1,"")
		for(i=1; i<=rows(lpanel); i++) {
			subnam = panelsubmatrix(lname, i, lpanel)
			subnum = panelsubmatrix(numlab, i, lpanel)
			subunq = uniqrows(subnum)
			if (subunq[1,1] != subunq[rows(subunq),1]) {
				badl = badl \ subnam[1,1]
				if (detail != "") {
					if (rows(badl)==1) {
						displayas("txt")
						printf("\nThe following value labels are only partially numlabel-ed\n")
					}
					subval = panelsubmatrix(lvalue, i, lpanel)
					sublab = panelsubmatrix(llab, i, lpanel)
					displayas("txt")
					display("{hline}")
					printf("-> lname = %s\n\n", subnam[1,1])
					for(j=1;j<=rows(subnum);j++) {
						if (j==1) {
							displayas("txt")
							printf("  %-9uds\t%s\n",
								"value",
								"label")
						}
						displayas("res")
						printf("  %9.0f\t%s\n",
							subval[j,1],
							sublab[j,1])
						if (j==rows(subnum)) {
							displayas("txt")
							display("")
						}
					}
				}
				else {
					if (rows(badl)==1) {
						displayas("txt")
						printf("there are value labels that are only partially numlabel-ed\nspecify option detail for a list of these value labels\n")
					}
				}
			}
		}
		if (rows(badl)>0) {
			displayas("txt")
			display("specify option force to modify value labels anyway")
			exit(180)
		}
	}

	if (add != "") {
		newlen = strlen(llab) :+ (1:-numlab):*strlen(prefix)
		cnt = sum(newlen :> 32000)

		if (cnt > 0) {
			displayas("err")
			display("impossible to prefix a value to value labels > 32000 chars")
			exit(180)
		}
		modlabel = (1:-numlab):*prefix :+ llab
	}

	if (remove != "") {
		modlabel = bsubstr(llab, 1:+(numlab:*bstrlen(prefix)), .)
	}

	towrite = llab :!= modlabel
	cnt = sum(towrite)
	if (cnt == 0) {
		displayas("txt")
		display("(no value label to be modified)")
		exit(0)
	}

	fh = fopen(tempf, "w")
	
	for(i=1; i<= rows(lname); i++) {
		towrite = "label define "			///
			+ lname[i,1] + " "			///
			+ strofreal(lvalue[i,1],"%20.0g") + " "	///
			+ char((96,34))				///
			+ subinstr(modlabel[i,1],char((96)),char((92,96))) ///
			+ char((34,39)) + ", modify"
		fput(fh, towrite)
	}
	fclose(fh)
}
end
exit

HISTORY

1.1.2  added support for Stata/SE

1.1.1  improved syntax parsing via syntax:anything
       modified wording in some err msg
