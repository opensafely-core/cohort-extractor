*! version 2.0.9  13feb2015
program cluster
	local vv : display "version " string(_caller()) ", missing:"

	version 7.0, missing

	gettoken subcmd 0 : 0 , parse(" ,")
	local subcmd = lower(`"`subcmd'"')

	if `"`subcmd'"' == "" | `"`subcmd'"' == "," {
		di as error "must specify a cluster subcommand"
		exit 198
	}

	if trim(`"`subcmd'"') == "resolve_version" {
		ResolveVersion
		c_local reset_these_globals `"`reset_these_globals'"'
		exit
	}

	// Take care of old version -cluster- objects (if any) and set
	// globals (if needed)
	ResolveVersion

	capture noisily `vv' ClustWork , subcmd(`"`subcmd'"') rest(`"`0'"')

	local therc = _rc

	if `therc' {
		ClustClean // clean up chars from any partial cluster runs
	}

	// reset globals if we set them
	foreach g of local reset_these_globals {
		global `g'
	}

	exit `therc'
end


program define ClustWork
	local vv : display "version " string(_caller()) ", missing:"
	version 7.0, missing
	syntax [, subcmd(str) rest(str) ]
	local len = length(`"`subcmd'"')
	if `"`subcmd'"' == bsubstr("kmeans",1,max(1,`len')) {
		ClustKmeans "`vv'" "means" `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("kmedians",1,max(4,`len')) {
		ClustKmeans "`vv'" "medians" `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("singlelinkage",1,max(1,`len')) {
		ClustLink "single" `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("averagelinkage",1,max(1,`len')) {
		ClustLink "average" `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("completelinkage",1,max(1,`len')) {
		ClustLink "complete" `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("centroidlinkage",1,max(4,`len')) {
		ClustLink "centroid" `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("medianlinkage",1,max(3,`len')) {
		ClustLink "median" `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("waveragelinkage",1,max(3,`len')) {
		ClustLink "waverage" `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("wardslinkage",1,max(4,`len')) {
		ClustLink "wards" `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("dendrogram",1,max(4,`len')) | /*
			*/ `"`subcmd'"' == bsubstr("tree",1,max(2,`len')) {
		`vv' cluster_tree `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("generate",1,max(3,`len')) {
		ClustGen `rest'
		exit
	}
	if `"`subcmd'"' == "dir" {
		ClustDir `rest'
		exit
	}
	if `"`subcmd'"' == "list" {
		ClustList `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("notes",1,max(4,`len')) {
		ClustNote `rest'
		exit
	}
	if `"`subcmd'"' == "drop" {
		ClustDrop `rest'
		exit
	}
	if `"`subcmd'"' == "use" {
		ClustUse `rest'
		exit
	}
	if `"`subcmd'"' == "rename" {
		ClustRename `rest'
		exit
	}
	if `"`subcmd'"' == "renamevar" {
		ClustRenameVar `rest'
		exit
	}
	if `"`subcmd'"' == "query" {
		ClustQuery `rest'
		exit
	}
	if `"`subcmd'"' == "set" {
		ClustSet `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("delete",1,max(3,`len')) {
		ClustDel `rest'
		exit
	}
	if `"`subcmd'"' == bsubstr("parsedistance",1,max(9,`len')) {
		if trim(`"`rest'"') == "" {
			error 198
		}
		ParseDist , distance(`rest')
		exit
	}
	/* else call user defined command */
	cluster_`subcmd' `rest'
end


* ClustKmeans -- Kmeans and Kmedians cluster analysis (means and medians)
*
* name() -- cluster name.
* generate() -- name of variable to generate with cluster solution (group var).
* start() -- determines the k starting center values, see ParseStart for info.
* iterate() -- maximum iterations allowed.
* keepcenters -- appends the final center points (means or medians) for the
*                groups to the end of the dataset (adding k obs. to the data).
*
program define ClustKmeans
	gettoken vv 0 : 0
	gettoken typeflag 0 : 0
	if "`typeflag'" == "means" {
		local cmd `"cluster kmeans `0'"'
	}
	else if "`typeflag'" == "medians" {
		local cmd `"cluster kmedians `0'"'
	}
	syntax [varlist(numeric)] [if] [in], k(numlist int max=1 >0) /*
	*/ [ Name(str) GENerate(str) Start(str) ITERate(integer 10000) /*
	*/ KEEPcenters MEAsure(str) * ]

	marksample touse

	if `"`measure'"' != "" {
		if `"`options'"' != "" {
			opts_exclusive `"`options' measure(`measure')"'
		}
		local dop `"distance(`measure')"'
	}
	if `"`options'"' != "" {
		local dop `"distance(`options')"'
	}
	ParseDist , `dop'
	local dist `s(dist)'
	local dstargs `s(darg)'
	local dtype `s(dtype)'
	local isbin `s(binary)'
	local drange `s(drange)'

	local realN = _N           /* remember the true number of obs */
	local sortedby : sortedby  /* and how we were sorted */
	tempvar realid
	gen `c(obs_t)' `realid' = _n

	/* check for errors in start() option */
	ParseStart "`vv'" `k' `touse' `start'
	local stway `s(startway)'
	local stopt `s(startopt)'
	local stfull `s(start)'

	preserve /* in case of break--temporarily will be adding obs to end */

	/* for storing means (and medians if ties occur) at the end of the
	   data we need to recast byte, int, long, and float to
	   double.  When we drop the extra obs we will recast back. */
	local vtcnt 0
	foreach var of local varlist {
		local vtype : type `var'
		if "`vtype'" != "double" {
			recast double `var'
			local vtcnt = `vtcnt' + 1
			local vtdo`vtcnt' recast `vtype' `var'
		}
	}

	/* set up k seed obs at bottom of data taking care of touse var etc. */
	DoStart `k' `touse' `realid' `typeflag' `varlist' , /*
						*/ `stway' `stopt' `isbin'

	ClustSet `name', add type(partition) method(k`typeflag') other(k `k')/*
		*/ `dtype'(`dist'`dstargs') other(start `stfull') /*
		*/ other(range `drange')
	local cname `r(name)'

	capture noi {
		if `"`generate'"' == "" { /* default varname is cluster name */
			capture confirm new var `cname'
			if _rc {
				di as error /*
				   */ "unable to create new variable `cname';"
				di as error /*
			    */ "use the generate() option to specify a varname"
				exit _rc
			}
			local generate `cname'
		}
		else {
			confirm new var `generate'
		}
	}
	if _rc {
		ClustDrop `cname'
		exit _rc
	}

	capture noi {
		_cluster `varlist' if `touse', kmeans(`k') `dist'`dstargs' /*
			*/ generate(`generate') `typeflag' iterate(`iterate')
		ReformatDisp `generate'

		ClustSet `cname', var(group `generate') other(cmd `cmd') /*
			*/ other(varlist `varlist')

	}
	if _rc {
		local therc = _rc
		capture ClustDrop `cname'
		exit `therc'
	}

	if "`keepcenters'" != "" { /* keep the extra last k obs. */
		local Np1 = `realN' + 1
		qui replace `realid' = _n in `Np1'/l /* keep last k in order */
		forvalues i = 1/`vtcnt' {
			/* if possible put vars back to original type */
			capture `vtdo`i''
		}
		sort `sortedby' `realid' /* get back into sort order */
	}
	else { /* Drop the k seed obs. we added, change storage types back,
					and get back in original order */
		qui drop if `realid' >= .
		forvalues i = 1/`vtcnt' {
			`vtdo`i''
		}
		sort `sortedby' `realid' /* get back into sort order */
	}

	restore, not /* we need to keep our generated vars if all went well */
end


* ClustLink -- various Linkage Hierarchical Cluster Analyses
*
*	linkages: single, complete, average, centroid, median, waverage, wards
*
program define ClustLink
	gettoken method 0 : 0 , parse(" ,")
	local cmd `"cluster `method'linkage `0'"'
	syntax [varlist(numeric)] [if] [in] [, Name(str) GENerate(str) ///
						MEAsure(str) * ]

	marksample touse
	qui count if `touse'
	if r(N) <= 1 {
		di as err "insufficient observations"
		exit 2001
	}

	if `"`measure'"' != "" {
		if `"`options'"' != "" {
			opts_exclusive `"`options' measure(`measure')"'
		}
		local dop `"distance(`measure')"'
	}
	if `"`options'"' != "" {
		local dop `"distance(`options')"'
	}
	ParseDist , `dop' method(`method')
	local dist `s(dist)'
	local dstargs `s(darg)'
	local dtype `s(dtype)'
	local drange `s(drange)'

	ClustSet `name' , add type(hierarchical) method(`method') /*
			*/ `dtype'(`dist'`dstargs') other(range `drange')
	local cname `r(name)'

	capture noi ParseGen `cname' `generate'
	if _rc {
		ClustDrop `cname'
		exit _rc
	}
	local idvar `s(id)'
	local ordvar `s(ord)'
	local hgtvar `s(hgt)'
	local phtvar `s(pht)'
	local varops `"idvar(`idvar') ordvar(`ordvar') hgtvar(`hgtvar')"'
	local all `s(all)'
	if "`method'" == "single" {
		if "`all'" == "all" {
			local pivar `s(pi)'
			local lamvar `s(lam)'
			local varops /*
				*/ `"`varops' pivar(`pivar') lamvar(`lamvar')"'
		}
		else {
			tempvar tmp1 tmp2
			local varops `"`varops' pivar(`tmp1') lamvar(`tmp2')"'
		}
	}
	else {
		if "`all'" != "" {
			di as error "invalid generate() option"
			exit 198
		}
		local varops `"`varops' phtvar(`phtvar')"'
	}

	capture noi {
		_cluster `varlist' if `touse', `method' `dist'`dstargs' `varops'

		ReformatDisp `idvar' `ordvar' `hgtvar'

		if "`method'" == "single" {
			ClustSet `cname', var(id `idvar') var(order `ordvar') /*
							*/ var(height `hgtvar')

			if "`all'" == "all" {
				ReformatDisp `pivar' `lamvar'
				ClustSet `cname', var(pi `pivar') var(lambda `lamvar')
			}
		}
		else {
			CheckPHTvar `phtvar'
			if `r(nopht)' {
				qui drop `phtvar'
				ClustSet `cname', var(id `idvar') /*
					*/ var(order `ordvar') /*
					*/ var(height `hgtvar')
			}
			else {
				ClustSet `cname', var(id `idvar') /*
					*/ var(order `ordvar') /*
					*/ var(real_height `hgtvar') /*
					*/ var(pseudo_height `phtvar')
			}
		}

		ClustSet `cname', other(cmd `cmd') other(varlist `varlist')
	}
	if _rc {
		local therc = _rc
		capture ClustDrop `cname'
		exit `therc'
	}
end


* ClustGen -- generate variable(s) that summarize in one way or another the
*             information from a previous cluster analysis.
*
* To generate a group var (or vars) after a hier. cluster analysis by telling
* how many groups to split into.
*
*        cluster gen[erate] {name|stub} = gr[oups](numlist) [, name(clname)
*                                     ties({ error | skip | fewer | more }) ]
*
* Also have alias -ties(less)- for -ties(fewer)- for backwards compatibility
*
* To create a group var after a hier. cluster analysis by telling the value
* (dendrogram height) at which to cut.
*
*        cluster gen[erate] name = cut(numlist) [, name(clname) ]
*
program define ClustGen
	local orig0 `0'
	gettoken stub 0 : 0, parse(" =(")
	gettoken eqsign 0 : 0, parse(" =(")
	if `"`eqsign'"' != "=" {
		error 198
	}
	gettoken fcn 0 : 0, parse(" =(")
	gettoken fcnargs 0 : 0, parse(" ,") match(paren)
	if `"`paren'"' != "(" {
		error 198
	}
	local len = length(`"`fcn'"')

	ClustQuery
	local clnames `r(names)'
	if "`clnames'" == "" {
		di as error "no cluster solutions currently defined"
		exit 198
	}

  * ============================ groups() =================================

	/* -cluster generate <stub> = groups(<fcnargs>) ...- */
	if `"`fcn'"' == bsubstr("groups",1,max(2,`len')) {
		syntax [, Name(str) Ties(str) ]

		if `"`ties'"' == "" {/* default -- error if ties encountered */
			local ties error
		}
		else {
			local ties = lower(`"`ties'"')
			local tielen = length(`"`ties'"')
			if `"`ties'"' == bsubstr("error",1,max(1,`tielen')) {
				local ties error
			}
			if `"`ties'"' == bsubstr("skip",1,max(1,`tielen')) {
				local ties skip
			}
			if `"`ties'"' == bsubstr("fewer",1,max(1,`tielen')) {
				local ties less		// sic
			}
			if `"`ties'"' == bsubstr("less",1,max(1,`tielen')) {
				local ties less
			}
			if `"`ties'"' == bsubstr("more",1,max(1,`tielen')) {
				local ties more
			}
		}

		if `"`name'"' == "" {
			local name : word 1 of `clnames'
		}
		else {
			local wcnt : word count `name'
			if `wcnt' != 1 {
				error 198
			}
			ExpandNames, a(`"`name'"') b(`"`clnames'"') onlyone
			local name `s(names)'
		}

		ClGenGrps, clname(`name') groups(`fcnargs') stub(`stub') /*
				*/ ties(`ties')

		exit
	}

  * ============================== cut() ==================================

	/* -cluster generate <stub> = cut(<fcnargs>) ...- */
	if `"`fcn'"' == "cut" {
		syntax [, Name(str) ]

		if `"`name'"' == "" {
			local name : word 1 of `clnames'
		}
		else {
			local wcnt : word count `name'
			if `wcnt' != 1 {
				error 198
			}
			ExpandNames, a(`"`name'"') b(`"`clnames'"') onlyone
			local name `s(names)'
		}

		ClGenCut `stub' , clname(`name') cut(`fcnargs')

		exit
	}

  * ========================= user defined function ===================

	/* call through to user defined cluster gen function */
	clusgen_`fcn' `orig0'

end


* ClustDir -- give a directory listing of currently defined cluster names
*
* returns: r(names)   the currently defined cluster names
*
program define ClustDir, rclass
	if `"`0'"' != "" {
		error 198
	}

	ClustQuery
	ret local names `r(names)'
	foreach name in `r(names)' {
		di as res `"`name'"'
	}
end


* ClustList -- give a listing of currently named cluster runs
*
*       cluster list [name [name ...]] [, notes type method dissimilarity
*                                         similarity chars vars other all ]
*
* default is -all-
*
* returns: r(names)   the cluster names requested or all currently defined
*                     cluster names if no user specified names provided.
*
program define ClustList, rclass
	gettoken aname 0 : 0 , parse(" ,")
	while `"`aname'"' != "" & `"`aname'"' != "," {
		local names `names' `aname'
		gettoken aname 0 : 0 , parse(" ,")
	}
	local 0 `", `0'"'
	ClustQuery
	local clnames `r(names)'
	if `"`names'"' == "" {
		local names `clnames'
	}
	else {
		ExpandNames, a(`"`names'"') b(`"`clnames'"')
		local names `s(names)'
	}
	syntax [, Notes Type Method Dissimilarity Similarity Chars Vars /*
		*/ Other All ]
	if "`notes'`type'`method'`dissimilarity'`similarity'`chars'`vars'`other'" /*
				*/ == "" | `"`all'"' != "" {
		local notes notes
		local type type
		local method method
		local dissimilarity dissimilarity
		local similarity similarity
		local chars chars
		local vars vars
		local other other
	}
	return local names `names'
	local indenta 5
	local indentb = `indenta' + 7
	local indentc = `indentb' + 5
	foreach name of local names {
		ClustQuery `name'
		di as res "{p 0 `indentc'}`name'" _c
		if "`type'`method'`dissimilarity'`similarity'" != "" {
			di as txt "{space 2}(" _c
			if "`type'" != "" & `"`r(type)'"' != "" {
				di `"{txt}type: {res}`r(type)'"' _c
				if "`method'" != "" & `"`r(method)'"' != "" {
					di as txt ",{space 2}" _c
				}
				else if "`dissimilarity'" != "" & `"`r(dissimilarity)'"' != "" {
					di as txt ",{space 2}" _c
				}
				else if "`similarity'" != "" & `"`r(similarity)'"' != "" {
					di as txt ",{space 2}" _c
				}
			}
			if "`method'" != "" & `"`r(method)'"' != "" {
				di `"{txt}method: {res}`r(method)'"' _c
				if "`dissimilarity'" != "" & `"`r(dissimilarity)'"' != "" {
					di as txt ",{space 2}" _c
				}
				else if "`similarity'" != "" & `"`r(similarity)'"' != "" {
					di as txt ",{space 2}" _c
				}
			}
			if "`dissimilarity'"!="" & `"`r(dissimilarity)'"'!= "" {
				di `"{txt}dissimilarity: {res}`r(dissimilarity)'"' _c
			}
			if "`similarity'" != "" & `"`r(similarity)'"' != "" {
				di `"{txt}similarity: {res}`r(similarity)'"' _c
			}
			di as txt ")" _c
		}
		di as txt "{p_end}"

		if "`notes'" != "" {
			local i 1
			local nnn `r(note`i')'
			while `"`nnn'"' != "" {
				if `i' < 10 {
					local nispace "{space 2}"
				}
				else if `i' < 100 {
					local nispace "{space 1}"
				}
				else {
					local nispace
				}
				if `i' == 1 {
					di as txt `"{p `indenta' `indentc'}notes: "' _c
				}
				else {
					di as txt `"{p `indentb' `indentc'}"' _c
				}
				di `"{txt}`nispace'`i'. {res}`nnn'{p_end}"'
				local i = `i' + 1
				local nnn `r(note`i')'
			}
		}

		if "`chars'" != "" {
			local i 1
			local ccc `r(c`i'_tag)'
			while `"`ccc'"' != "" {
				if `i' == 1 {
					di as txt "{p `indenta' `indentc'}chars: " _c
				}
				else {
					di as txt "{p `indentb' `indentc'}"
				}
				di `"{txt}`ccc': {res}`r(c`i'_name)'{txt}: {res}`r(c`i'_val)'{p_end}"'
				local i = `i' + 1
				local ccc `r(c`i'_tag)'
			}
		}

		if "`vars'" != "" {
			local i 1
			local vvv `r(v`i'_tag)'
			while `"`vvv'"' != "" {
				if `i' == 1 {
					di as txt "{p `indenta' `indentc'}{bind: }vars: " _c
				}
				else {
					di as txt "{p `indentb' `indentc'}"
				}
				di `"{res}`r(v`i'_name)' {txt}(`vvv' variable){p_end}"'
				local i = `i' + 1
				local vvv `r(v`i'_tag)'
			}
		}

		if "`other'" != "" {
			local i 1
			local ooo `r(o`i'_tag)'
			while `"`ooo'"' != "" {
				if `i' == 1 {
					di as txt "{p `indenta' `indentc'}other: " _c
				}
				else {
					di as txt "{p `indentb' `indentc'}"
				}
				di `"{txt}`ooo': {res}`r(o`i'_val)'{p_end}"'
				local i = `i' + 1
				local ooo `r(o`i'_tag)'
			}
		}

		di /* blank line between each cluster listing */
	}
end


* ClustNote -- Add/View/Delete notes for a particular cluster analysis
*
*    To add a note to the cluster named name
*            cluster note name : text
*
*    To list the notes associated with the named clusters (all if no names)
*            cluster note [name [name ...]]
*
*    To delete specific cluster notes
*            cluster note drop name [^in^ numlist]
*
program define ClustNote
	ClustQuery
	local clnames `r(names)'
	if `"`0'"' == "" { /* if no names then use all names */
		local 0 `clnames'
	}
	gettoken name tmp0 : 0 , parse(" :")
	if `"`name'"' == "drop" {
		gettoken name tmp0 : tmp0
		if `"`name'"' == "" {
			error 198
		}
		ExpandNames, a(`"`name'"') b(`"`clnames'"') onlyone
		local name `s(names)'
		gettoken intok tmp0 : tmp0
		if `"`intok'"' == "" {
			ClustDel `name' , allnotes
		}
		else if `"`intok'"' != "in" | /*
				*/ (`"`intok'"' == "in" & `"`tmp0'"' == "") {
			error 198
		}
		else {
			ClustDel `name' , notes(`tmp0')
		}
		exit
	}

	gettoken colon tmp0 : tmp0 , parse(" :")
	if `"`colon'"' == ":" { /* we are to add a note */
		ExpandNames, a(`"`name'"') b(`"`clnames'"') onlyone
		local name `s(names)'
		if `"`tmp0'"' == "" { error 198 }
		ClustSet `name' , note(`tmp0')
	}
	else { /* we are to list note[s] */
		ExpandNames, a(`"`0'"') b(`"`clnames'"')
		ClustList `s(names)' , notes
	}
end


* ClustDrop -- drop all structures created for the named cluster solution.
*              The result variables, notes, characteristics, etc are all
*              discarded.
*
*    cluster drop { name [name [...]] | _all }
*
program define ClustDrop
	ClustQuery
	local full `r(names)'
	if `"`0'"' == "" {
		error 198
	}
	else if `"`0'"' == "_all" {
		local names `full'
	}
	else {
		ExpandNames, a(`"`0'"') b(`"`full'"')
		local names `s(names)'
	}
	foreach name of local names {
		ClustDel `name', zap
	}
end


* ClustUse -- place cluster at front of list
*
*    cluster use clname
*
program define ClustUse
	args clname stuff
	if `"`stuff'"' != "" | `"`clname'"' == "" {
		error 198
	}

	ClustQuery
	local clnames `r(names)'
	ExpandNames, a(`"`clname'"') b(`"`clnames'"') onlyone
	local clname `s(names)'

	char _dta[$S_V2_Cluster] `"`: list clname | clnames'"'
end


* ClustRename -- rename cluster from 1st name to 2nd name
*
*    cluster rename fromname toname
*
program define ClustRename
	args from to stuff
	if `"`stuff'"' != "" | `"`to'"' == "" {
		error 198
	}
	ClustQuery
	local clnames `r(names)'
	ExpandNames, a(`"`from'"') b(`"`clnames'"') onlyone
	local from `s(names)'
	if `"`from'"' == `"`to'"' { /* do nothing */
		exit
	}
	capture ExpandNames, a(`"`to'"') b(`"`clnames'"')
	if !_rc {
		di as error `"`to' cluster name already in use"'
		exit 198
	}
	if `"`_dta[`to']'"' != "" {
		di as error `"_dta[`to'] char already in use"'
		exit 198
	}

	ClustSet `to', addname
	ClustDel `from', delname

	capture noi char _dta[`to'] `"`_dta[`from']'"'
	if _rc {
		ClustDel `to', delname
		ClustSet `from', addname
		exit _rc
	}
	char _dta[`from']
end


* ClustRenameVar -- rename a variable attached to a cluster analysis
*
*    cluster renamevar oldvarname newvarname [, name(clname) prefix ]
*
program define ClustRenameVar
	gettoken from 0 : 0, parse(" ,")
	gettoken to 0 : 0, parse(" ,")
	if `"`to'"' == "" | `"`to'"' == "," | `"`from'"' == "," {
		error 198
	}
	syntax [, Name(str) Prefix ]

	ClustQuery
	local clnames `r(names)'

	if `"`name'"' == "" {
		local name : word 1 of `clnames'
	}
	else {
		ExpandNames, a(`"`name'"') b(`"`clnames'"') onlyone
		local name `s(names)'
	}

	local fromlen = length(`"`from'"')
	local fromlenp1 = `fromlen'+1

	ClustQuery `name'

	local i 1
	while "`r(v`i'_name)'" != "" {
		if "`prefix'" != "" {
			if bsubstr("`r(v`i'_name)'",1,`fromlen') == "`from'" {
				local tov = `"`to'"' + /*
				     */ bsubstr("`r(v`i'_name)'",`fromlenp1',.)
				confirm new variable `tov'
				local ftags `ftags' `r(v`i'_tag)'
				local fvars `fvars' `r(v`i'_name)'
				local tvars `tvars' `tov'
			}
		}
		else {
			if "`r(v`i'_name)'" == "`from'" {
				confirm new variable `to'
				local ftags `r(v`i'_tag)'
				local fvars `from'
				local tvars `to'
				continue, break
			}
		}
		local i = `i' + 1
	}
	if "`ftags'" == "" {
		if "`prefix'" != "" {
			local space " "
		}
		di as error "variable `prefix'`space'`from' not found in `name'"
		exit 198
	}

	local i 1
	local ftag : word 1 of `ftags'
	local fvar : word 1 of `fvars'
	local tvar : word 1 of `tvars'
	while "`ftag'" != "" {
		rename `fvar' `tvar'
		ClustDel `name', v(`ftag')
		ClustSet `name', v(`ftag' `tvar')
		local i = `i' + 1
		local ftag : word `i' of `ftags'
		local fvar : word `i' of `fvars'
		local tvar : word `i' of `tvars'
	}
end


* ClustQuery -- Programmer utility that provides an easy way for a programmer
*               of a cluster analysis routine to obtain the various character-
*               istics of a previously defined cluster analysis.
*
*    cluster query [name]
*
* If name is not given then r(names) is returned providing a list of names of
* all currently defined clusters.  If name is given then returned are:
*
*    r(name)                      the cluster name (same as name argument)
*    r(type)                      the cluster analysis type
*    r(method)                    the cluster analysis method
*    r(dissimilarity)             the dissimilarity measure used
*    r(similarity)                the similarity measure used
*    r(note1), r(note2), ...      the cluster notes
*
* Also
*
*    r(v1_tag), r(v2_tag), ...    the tags assoc. with the cluster anal. vars.
*    r(v1_name), r(v2_name), ...  the var names assoc. with the cluster anal.
*    r(c1_tag), r(c2_tag), ...    the tags assoc. with the cluster anal. chars.
*    r(c1_name), r(c2_name), ...  the char names assoc. with the cluster anal.
*    r(c1_val), r(c2_val), ...    the actual char values
*    r(o1_tag), r(o2_tag), ...    the tags assoc. with the "other" fields
*    r(o1_val), r(o2_val), ...    the values of the "other" fields
*
* Additionally, is returned things like
*
*    r(<tag>var)    the var name with tag == <tag>
*    r(<tag>char)   the char name with tag == <tag>
*
* which is another, often more convenient, way of returning these names.
*
program define ClustQuery, rclass
	args name rest

	if `"`rest'"' != "" {
		error 198
	}

	if `"`name'"' == "" {
		ret local names `_dta[$S_V2_Cluster]'
		exit
	}

	ExpandNames, a(`"`name'"') b(`"`_dta[$S_V2_Cluster]'"') onlyone
	local name `s(names)'
	local ncnt 0
	local vcnt 0
	local ccnt 0
	local ocnt 0

	local ptrlist : char _dta[`name']
	foreach pitem of local ptrlist {
		gettoken ptyp ptrs : pitem
		if `"`ptyp'"' == "cmd" {
			local ++ocnt
			local valu
			foreach cptr of local ptrs {
				local valu `valu' `: char _dta[`cptr']'
			}
			return local o`ocnt'_tag cmd
			return local o`ocnt'_val `valu'
		}
		else if `"`ptyp'"' == "vars" {
			local ++ocnt
			local valu
			foreach vptr of local ptrs {
				local valu `valu' `: char _dta[`vptr']'
			}
			return local o`ocnt'_tag varlist
			return local o`ocnt'_val `valu'
		}
		else if `"`ptyp'"' == "info" {
			foreach iptr of local ptrs {
				local nmlist : char _dta[`iptr']
				foreach nm of local nmlist {
					gettoken first rest : nm
					if `"`first'"' == "t" {
						return local type `rest'
					}
					else if `"`first'"' == "m" {
						return local method `rest'
					}
					else if `"`first'"' == "d" {
					      return local dissimilarity `rest'
					}
					else if `"`first'"' == "s" {
						return local similarity `rest'
					}
					else if `"`first'"' == "v" {
						gettoken tag rest : rest
						local ++vcnt
						return local v`vcnt'_tag `tag'
						return local v`vcnt'_name `rest'
						return local `tag'var `rest'
					}
					else if `"`first'"' == "o" {
						gettoken tag rest : rest
						local ++ocnt
						return local o`ocnt'_tag `tag'
						return local o`ocnt'_val `rest'
					}
					else if `"`first'"' == "c" {
						gettoken tag rest : rest
						gettoken cnm rest : rest
						local ++ccnt
						return local c`ccnt'_tag `tag'
						return local c`ccnt'_name `cnm'
						return local c`ccnt'_val ``cnm''
						return local `tag'char `cnm'
					}
				}
			}
		}
		else if `"`ptyp'"' == "notes" {
			foreach nptr of local ptrs {
				local ++ncnt
				return local note`ncnt' `: char _dta[`nptr']'
			}
		}

	}
	return local name `name'
end


* ClustSet -- Programmer utility that provides an easy way for a programmer of
*             a cluster analysis routine to set the various characteristics
*             that define a cluster analysis.
*
*    cluster set [clname] [, addname type(str) method(str)
*                            { dissimilarity(str) | similarity(str) }
*                            note(str) var(name varname) char(name charname)
*                            other(name str) ]
*
* -addname- adds clname to the master list of currently defined cluster
*           analysis solutions.
* -type()- specifies (and stores with clname) the cluster type ("hier", ...).
* -method()- specifies (and stores with clname) the method ("single", ...).
* -dissimilarity() - specifies (and stores with clname) the dissimilarity.
* -similarity() - specifies (and stores with clname) the similarity.
* -note()- adds a note to the clname cluster analysis.
* -var()- adds a "name"d marker ("id", "order", "height", ...) pointing to the
*         variable varname.
* -char()- adds a "name"d link to another Stata char.
* -other()- adds a "name"d item (a string) to clname.
*
* If clname is not specified then option -addname- must be specified.  In this
* case we find a currently unused name and use that for the clname.
*
* If -addname- is not specified the clname must already have previously been
* added to the master list.
*
* returns:  r(name)
*
program define ClustSet, rclass
	gettoken clname 0 : 0 , parse(" ,")
	if `"`clname'"' == "" {
		error 198
	}
	if trim(`"`0'"') == "" {
		/* at least one option is needed */
		error 198
	}
	if trim(`"`0'"') == "," {
		/* at least one option is needed */
		error 198
	}
	if `"`clname'"' == "," { /* clear clname and put the comma back */
		local clname
		local 0 `", `0'"'
	}
	syntax [, ADDname Type(str) Method(str) Dissimilarity(str) /*
	*/ Similarity(str) Note1(str) Note2(str) Note3(str) Note4(str) /*
	*/ Note5(str) Note6(str) Note7(str) Note8(str) Note9(str) Note10(str) /*
	*/ Var1(str) Var2(str) Var3(str) Var4(str) Var5(str) Var6(str) /*
	*/ Var7(str) Var8(str) Var9(str) Var10(str) Char1(str) Char2(str) /*
	*/ Char3(str) Char4(str) Char5(str) Char6(str) Char7(str) Char8(str) /*
	*/ Char9(str) Char10(str) Other1(str) Other2(str) Other3(str) /*
	*/ Other4(str) Other5(str) Other6(str) Other7(str) Other8(str) /*
	*/ Other9(str) Other10(str) ]

	local stub $S_V2_Cl_stub
	local main $S_V2_Cluster
	local current : char _dta[`main']
	if `"`clname'"' == "" {
		if "`addname'" == "" {/*empty clname allowed only with addname*/
			error 198
		}
		/* addname specified with empty clname --- find a valid one */
		local i 1
		local done 0
		while `i' < 10000 & !`done' {
			local nametry `stub'_`i'
			if `"`: list nametry & current'"' == "" {
				if `"`_dta[`nametry']'"' == "" {
					local clname `nametry'
					di `"{txt}cluster name: {res}`clname'"'
					local done 1
				}
			}
			local ++i
		}
		if !`done' {
			di as error "could not find an available name"
			exit 198
		}
	}
	else {
		if "`addname'" != "" {
			confirm name `clname'
			if `"`: list clname & current'"' != "" {
				di as err `"`clname' already defined"'
				exit 198
			}
			if `"`_dta[`clname']'"' != "" {
				di as err "char _dta[`clname'] already defined"
				exit 198
			}
		}
		else { // not -addname- so check clname already defined
			ExpandNames, a(`"`clname'"') b(`"`current'"') onlyone
			local clname `s(names)'
		}
	}
	if "`addname'" != "" {
		char _dta[`main'] `clname' `current'
	}

	local clptrs : char _dta[`clname']
	if `"`clptrs'"' != "" { // Get stuff previously placed in clname
		foreach clitem of local clptrs {
			gettoken ptyp ptrs : clitem
			if `"`ptyp'"' == "cmd" {
				local cptrs `ptrs'
			}
			else if `"`ptyp'"' == "vars" {
				local vptrs `ptrs'
			}
			else if `"`ptyp'"' == "info" {
				local iptrs `ptrs'
			}
			else if `"`ptyp'"' == "notes" {
				local nptrs `ptrs'
			}
		}
	}

	if `"`type'"' != "" {
		local toaddi `"`toaddi' `"t `type'"'"'
	}
	if `"`method'"' != "" {
		local toaddi `"`toaddi' `"m `method'"'"'
	}
	if `"`dissimilarity'"' != "" & `"`similarity'"' != "" {
		di as err "only one of dissimilarity() and similarity() allowed"
		exit 198
	}
	if `"`dissimilarity'"' != "" {
		local toaddi `"`toaddi' `"d `dissimilarity'"'"'
	}
	if `"`similarity'"' != "" {
		local toaddi `"`toaddi' `"s `similarity'"'"'
	}
	forvalues x = 1/10 {
		if `"`var`x''"' != "" {
			local toaddi `"`toaddi' `"v `var`x''"'"'
		}
		else {
			continue, break
		}
	}
	forvalues x = 1/10 {
		if `"`other`x''"' != "" {
			gettoken osub orest : other`x'
			if `"`osub'"' == "cmd" {
				local orest : list retokenize orest
				AddCmd `clname' `"`cptrs'"' `"`orest'"'
				local cptrs `r(cmdptrs)'
			}
			else if `"`osub'"' == "varlist" {
				local orest : list retokenize orest
				AddVarlist `clname' `"`vptrs'"' `"`orest'"'
				local vptrs `r(varsptrs)'
			}
			else {
				local toaddi `"`toaddi' `"o `other`x''"'"'
			}
		}
		else {
			continue, break
		}
	}
	forvalues x = 1/10 {
		if `"`char`x''"' != "" {
			local toaddi `"`toaddi' `"c `char`x''"'"'
		}
		else {
			continue, break
		}
	}
	local toaddi : list retokenize toaddi

	AddInfo `clname' `"`iptrs'"' `"`toaddi'"'
	local iptrs `r(infoptrs)'

	forvalues x = 1/10 {
		if `"`note`x''"' != "" {
			AddNote `clname' `"`nptrs'"' `"`note`x''"'
			local nptrs `r(noteptrs)'
		}
		else {
			continue, break
		}
	}

	if `"`cptrs'"' != "" {
		local theptrs `""cmd `cptrs'""'
	}
	if `"`vptrs'"' != "" {
		local theptrs `"`theptrs' "vars `vptrs'""'
	}
	if `"`iptrs'"' != "" {
		local theptrs `"`theptrs' "info `iptrs'""'
	}
	if `"`nptrs'"' != "" {
		local theptrs `"`theptrs' "notes `nptrs'""'
	}
	local theptrs : list retokenize theptrs

	char _dta[`clname'] `"`theptrs'"'
	return local name `clname'
end


* ClustDel -- deletes various items from the named cluster structure.
*
*        cluster delete <clname> [, <options> ]
*
* Where <clname> is the name of the cluster solution and valid <options> are
*
* zap -- deletes everything possible for cluster <clname>.  It is the same as
*      specifying the delname, type, method, dissimilarity, similarity,
*      allnotes, allcharzap, allothers, and allvarzap options.
* delname -- removes clname from the master list (and thats all it does -- the
*      various pieces making up the cluster analysis are not touched).
* type -- the type field of clname is deleted.
* method -- the method field of clname is deleted.
* dissimilarity -- the dissimilarity field of clname is deleted.
* similarity -- the similarity field of clname is deleted.
* notes(numlist) -- removes the numbered notes from clname.  (The numbers
*      correspond to the returned results from -cluster query clname-.)
* allnotes -- removes all the notes from clname.
* char(str) -- removes the named char fields of clname (but does not delete
*      those chars).
* allchars -- removes all the char fields of clname (but does not delete those
*      chars).
* charzap(str) -- same as char() with the addition of actually deleting the
*      referenced chars.
* allcharzap -- same as allchars with the addition of actually deleting the
*      referenced chars.
* other(str) -- removes the named "other" fields of clname.
* allothers -- removes all the "other" fields of clname.
* var(str) -- removes the named var fields of clname (but does not delete the
*      the variables).
* allvars -- removes all var fields of clname (but does not delete the
*      variables).
* varzap(str) -- same as var() with the addition of actually deleting the
*      variables).
* allvarzap -- same as allvars with the addition of actually deleting the
*      variables).
*
program define ClustDel
	gettoken clname 0 : 0 , parse(" ,")
	if `"`clname'"' == "" | `"`clname'"' == "," {
		error 198
	}
	syntax [, ZAP DELname Type Method Dissimilarity Similarity /*
		*/ Notes(numlist integer >0) ALLNotes Char(str) ALLChars /*
		*/ CHARZap(str) ALLCHARZap Other(str) ALLOthers Var(str) /*
		*/ ALLVars VARZap(str) ALLVARZap ]

	if "`zap'" != "" {  // obliterate everything for this cluster
		local delname delname
		local allcharzap allcharzap
		local allvarzap allvarzap
	// type, method, dissimilarity, notes, & others zapped later in code
	}

	local clptrs : char _dta[`clname']
	if `"`clptrs'"' != "" { // Get stuff previously placed in clname
		foreach clitem of local clptrs {
			gettoken ptyp ptrs : clitem
			if `"`ptyp'"' == "cmd" {
				local cptrs `ptrs'
			}
			else if `"`ptyp'"' == "vars" {
				local vptrs `ptrs'
			}
			else if `"`ptyp'"' == "info" {
				local iptrs `ptrs'
			}
			else if `"`ptyp'"' == "notes" {
				local nptrs `ptrs'
			}
		}
	}

	ClustQuery `clname'

	local zz 0
	if "`type'" != "" & `"`r(type)'"' != "" {
		local x `"`"t `r(type)'"'"'
		local idel : list idel | x
	}
	if "`method'" != "" & `"`r(method)'"' != "" {
		local x `"`"m `r(method)'"'"'
		local idel : list idel | x
	}
	if "`dissimilarity'" != "" & `"`r(dissimilarity)'"' != "" {
		local x `"`"d `r(dissimilarity)'"'"'
		local idel : list idel | x
	}
	if "`similarity'" != "" & `"`r(similarity)'"' != "" {
		local x `"`"s `r(similarity)'"'"'
		local idel : list idel | x
	}
	if "`notes'" != "" {
		foreach nnum of local notes {
			local notechar : word `nnum' of `nptrs'
			local deln `deln' `notechar'
			if `"`notechar'"' == "" {
				di as err `"cluster note `nnum' not found"'
				exit 198
			}
			// arrange to erase the char holding the note
			local ++zz
			local todo`zz' "char _dta[`notechar']"
		}
		// remove them from the nptrs list
		local nptrs : list nptrs - deln
	}
	if "`allnotes'" != "" {
		foreach nt of local nptrs {
			// arrange to erase the char holding the note
			local ++zz
			local todo`zz' "char _dta[`nt']"
		}
		// set nptrs to empty
		local nptrs
	}
	if "`char'" != "" {
		foreach citem of local char {
			local found 0
			local i 1
			while `"`r(c`i'_tag)'"' != "" {
				if `"`citem'"' == `"`r(c`i'_tag)'"' {
					local x /*
				      */ `"`"c `r(c`i'_tag)' `r(c`i'_name)'"'"'
					local idel : list idel | x
					local found 1
					continue, break
				}
				local ++i
			}
			if !`found' {
				di as err "`citem' cluster char not found"
				exit 198
			}
		}
	}
	if "`charzap'" != "" {
		foreach citem of local charzap {
			local found 0
			local i 1
			while `"`r(c`i'_tag)'"' != "" {
				if `"`citem'"' == `"`r(c`i'_tag)'"' {
					local x /*
				      */ `"`"c `r(c`i'_tag)' `r(c`i'_name)'"'"'
					local idel : list idel | x
					local ++zz
					local todo`zz' ///
						capture char `r(c`i'_name)'
					local found 1
					continue, break
				}
				local ++i
			}
			if !`found' {
				di as err "`citem' cluster char not found"
				exit 198
			}
		}
	}
	if "`allchars'" != "" | "`allcharzap'" != "" {
		local i 1
		while `"`r(c`i'_tag)'"' != "" {
			local x `"`"c `r(c`i'_tag)' `r(c`i'_name)'"'"'
			local idel : list idel | x
			if "`allcharzap'" != "" {
				// erase the pointed to data characteristic
				local ++zz
				local todo`zz' capture char `r(c`i'_name)'
			}
			local ++i
		}
	}
	if "`other'" != "" {
		foreach oitem of local other {
			if `"`oitem'"' == "cmd" {
				foreach cpt of local cptrs {
					// arrange erasing chars holding cmd
					local ++zz
					local todo`zz' "char _dta[`cpt']"
				}
				// erase cptrs
				local cptrs
			}
			else if `"`oitem'"' == "varlist" {
				foreach vpt of local vptrs {
					// arrange erasing chars holding varlist
					local ++zz
					local todo`zz' "char _dta[`vpt']"
				}
				// erase vptrs
				local vptrs
			}
			else {
				local found 0
				local i 1
				while `"`r(o`i'_tag)'"' != "" {
					if `"`oitem'"' == `"`r(o`i'_tag)'"' {
						local x /*
					*/ `"`"o `r(o`i'_tag)' `r(o`i'_val)'"'"'
						local idel : list idel | x
						local found 1
						continue, break
					}
					local ++i
				}
				if !`found' {
					di as err ///
					     `"`oitem' other field not found"'
					exit 198
				}

			}
		}
	}
	if "`allothers'" != "" {
		local i 1
		while `"`r(o`i'_tag)'"' != "" {
			if `"`r(o`i'_tag)'"' == "cmd" {
				foreach cpt of local cptrs {
					// arrange erasing chars holding cmd
					local ++zz
					local todo`zz' "char _dta[`cpt']"
				}
				// erase cptrs
				local cptrs
			}
			else if `"`r(o`i'_tag)'"' == "varlist" {
				foreach vpt of local vptrs {
					// arrange erasing chars holding varlist
					local ++zz
					local todo`zz' "char _dta[`vpt']"
				}
				// erase vptrs
				local vptrs
			}
			else {
				local x `"`"o `r(o`i'_tag)' `r(o`i'_val)'"'"'
				local idel : list idel | x
			}
			local ++i
		}
	}
	if "`var'" != "" {
		foreach vitem of local var {
			local found 0
			local i 1
			while `"`r(v`i'_tag)'"' != "" {
				if `"`vitem'"' == `"`r(v`i'_tag)'"' {
					local x /*
				      */ `"`"v `r(v`i'_tag)' `r(v`i'_name)'"'"'
					local idel : list idel | x
					local found 1
					continue, break
				}
				local ++i
			}
			if !`found' {
				di as err `"`vitem' var entry not found"'
				exit 198
			}
		}
	}
	if "`varzap'" != "" {
		foreach vitem of local varzap {
			local found 0
			local i 1
			while `"`r(v`i'_tag)'"' != "" {
				if `"`vitem'"' == `"`r(v`i'_tag)'"' {
					local x /*
				      */ `"`"v `r(v`i'_tag)' `r(v`i'_name)'"'"'
					local idel : list idel | x
					local ++zz
					local todo`zz' ///
						capture drop `r(v`i'_name)'
					local found 1
					continue, break
				}
				local ++i
			}
			if !`found' {
				di as err `"`vitem' var entry not found"'
				exit 198
			}
		}
	}
	if "`allvars'" != "" | "`allvarzap'" != "" {
		local i 1
		while `"`r(v`i'_tag)'"' != "" {
			local x `"`"v `r(v`i'_tag)' `r(v`i'_name)'"'"'
			local idel : list idel | x
			if "`allvarzap'" != "" {
				// drop the pointed to variable
				local ++zz
				local todo`zz' capture drop `r(v`i'_name)'
			}
			local ++i
		}
	}

	if "`zap'" != "" { // completely erase clname
		local x `"`_dta[`clname']'"'
		// remove the chars holding the information for this clname
		foreach ptrset of local x {
			gettoken pnam ptrs : ptrset
			foreach ptr of local ptrs {
				char _dta[`ptr']
			}
		}
		// now we can remove the main char for this clname
		char _dta[`clname']
	}
	else { // remove the identified items from clname
		foreach ipt of local iptrs {
			local ii : char _dta[`ipt']
			local ii : list ii - idel
			char _dta[`ipt'] `"`ii'"'
			if `"`ii'"' == "" {
				local iptdel `iptdel' `ipt'
			}
		}
		local iptrs : list iptrs - iptdel

		if `"`cptrs'"' != "" {
			local theptrs `""cmd `cptrs'""'
		}
		if `"`vptrs'"' != "" {
			local theptrs `"`theptrs' "vars `vptrs'""'
		}
		if `"`iptrs'"' != "" {
			local theptrs `"`theptrs' "info `iptrs'""'
		}
		if `"`nptrs'"' != "" {
			local theptrs `"`theptrs' "notes `nptrs'""'
		}
		local theptrs : list retokenize theptrs

		char _dta[`clname'] `"`theptrs'"'
	}

	if "`delname'" != "" { // remove clname from master list
		ClustQuery
		local clist `"`r(names)'"'
		char _dta[$S_V2_Cluster] `"`: list clist - clname'"'
	}

	// Actually remove variables and chars marked for deletion.
	forvalues i = 1/`zz' {
		`todo`i''
	}
end


* ClustClean -- cleans up the data cluster characteristics getting rid of any
*               of them where the associated variables or chars are missing.
*
program define ClustClean
	ClustQuery
	local names `r(names)'
	foreach name of local names {
		local bad 0
		ClustQuery `name'

		local allofem `"`r(type)'`r(method)'`r(dissimilarity)'"'
		local allofem `"`allofem'`r(similarity)'`r(note1)'"'
		local allofem `"`allofem'`r(v1_tag)'`r(c1_tag)'`r(o1_tag)'"'
		if `"`allofem'"' == "" {
			ClustDel `name' , zap
			continue
		}

		local i 1
		while `"`r(v`i'_tag)'"' != "" {
			capture confirm var `r(v`i'_name)'
			if _rc {
				local bad 1
				continue, break
			}
			local i = `i' + 1
		}
		if `bad' {
			ClustDel `name' , zap
			continue
		}

		local i 1
		while `"`r(c`i'_tag)'"' != "" {
			if `"`r(c`i'_val)'"' == "" {
				local bad 1
				continue, break
			}
			local i = `i' + 1
		}
		if `bad' {
			ClustDel `name' , zap
		}
	}
end


* ParseDist -- similarity/dissimilarity option parsing
*
* Returns: s(dist)   = selected (dis)similarity (with synonyms resolved)
*          s(darg)   = numeric argument for L() option
*          s(dtype)  = the word "dissimilarity" or "similarity" to indicate if
*                      larger or smaller numbers indicate larger distance.
*          s(drange) = range of measure (from match to mismatch).  A dot means
*                      infinity.
*          s(binary) = the word "binary" if the measure is designed only for
*                      binary variables.
*
program define ParseDist, sclass
	sreturn clear
	syntax [, distance(string) method(string) ]
	if inlist("`method'","centroid","median","wards") {
		// some methods have L2squared as the default
		local deflt "default(L2squared)"
	}
	parse_dissim `distance', `deflt'
end


* ParseGen -- Parse the generate() option.
*
*       , [ ... generate(stub [, all]) ... ]
*
* The calling routine has placed the clustername in front of what was passed
* in as the body of the -generate()- option.  We use the clustername if stub
* is empty.
*
* The id, ord, and hgt variables are always to be generated.  The pht (pseudo
* heights) variable is also created (and will later be discarded if there were
* no reversals).  If -all- is specified the pi and lam variables are to be
* generated.  The variables are confirmed to be new but are not created.
*
* Returned:  s(id), s(ord), s(hgt), s(pht), s(pi), s(lam)   <-- variable names
*            s(all)   <-- all option
*
program define ParseGen, sclass
	gettoken cname 0 : 0 , parse(" ,")
	gettoken stub : 0 , parse(" ,")
	if `"`stub'"' == "" | `"`stub'"' == "," {
		local stub `cname'
	}
	else { /* remove stub from `0' */
		gettoken tmp 0 : 0 , parse(" ,")
	}

	/* the 1234 is used to check that stub is not too long */
	capture confirm name `stub'1234
	if _rc {
		di as err `"`stub' invalid stub name"'
		exit 7
	}

	gettoken comma 0 : 0 , parse(" ,")
	if `"`comma'"' == "," {
		gettoken allopt 0 : 0
		if `"`0'"' != "" | `"`allopt'"' != "all" {
			di as err "invalid generate() option"
			exit 198
		}
	}
	else if `"`comma'"' != "" {
			di as err "invalid generate() option"
			exit 198
	}

	confirm new var `stub'_id `stub'_ord `stub'_hgt `stub'_pht
	if "`allopt'" == "all" {
		confirm new var `stub'_pi `stub'_lam
	}

	sreturn local id `stub'_id
	sreturn local ord `stub'_ord
	sreturn local hgt `stub'_hgt
	sreturn local pht `stub'_pht
	if "`allopt'" == "all" {
		sreturn local all all
		sreturn local pi `stub'_pi
		sreturn local lam `stub'_lam
	}
end


* ExpandNames
*
program define ExpandNames, sclass
	syntax [, a(str) b(str) onlyone ]
	if `"`a'"' == "" {
		exit
	}
	local totalfound 0
	foreach aitem of local a {
		local found 0
		foreach bitem of local b {
			if match(`"`bitem'"',`"`aitem'"') {
				local found = `found' + 1
				local matchlist `matchlist' `bitem'
			}
		}
		if !`found' {
			di as err `"`aitem' not found"'
			exit 198
		}
		local totalfound = `totalfound' + `found'
	}
	if "`onlyone'" != "" & `totalfound' != 1 {
		di as err "multiple names not allowed"
		exit 198
	}

	sreturn local names `matchlist'
end


* ClGenGrps  ---  Utility program that does the work of generating group vars
*                 from a hier. cluster analysis based on # of groups requested
*
program define ClGenGrps, sortpreserve
	* clname() argument verified by caller to be a current cluster name
	* ties() will be one of { error | skip | less | more }
	syntax , clname(str) groups(numlist int min=1 >0 sort) stub(str) /*
		*/ ties(str)

	ClustQuery `clname'

	if "`r(type)'" != "hierarchical" {
		di as err `"`clname' is not a hierarchical cluster analysis"'
		exit 198
	}

	local idvar `r(idvar)'
	local ordvar `r(ordervar)'
	local hgtvar `r(heightvar)'

	if `"`r(similarity)'"' != "" & `"`r(dissimilarity)'"' != "" {
		di as err "dissimilarity and similarity simultaneously set"
		exit 198
	}

	tempvar tmpv rankvar

	if "`hgtvar'" != "" {
		* This is for a standard hier. cluster (no reversals)

		if `"`r(similarity)'"' != "" {
			local thehvar `hgtvar'
		}
		else if `"`r(dissimilarity)'"' != "" {
			qui gen double `tmpv' = -`hgtvar'
			local thehvar `tmpv'
		}
		else {
			di as err "dissimilarity or similarity not set"
			exit 198
		}
	}
	else {
		* Reversal case: must deal with pseudo heights & real heights
		local phtvar `r(pseudo_heightvar)'
		local rhtvar `r(real_heightvar)'
		qui gen double `tmpv' = -`phtvar'
		sort `tmpv' `idvar'
		qui replace `tmpv' = `tmpv'[_n-1] /*
					*/ if (`rhtvar'-`rhtvar'[_n-1])==0
		local thehvar `tmpv'
	}

	sort `thehvar' `idvar'

	qui by `thehvar' : gen `c(obs_t)' `rankvar' = 1 if _n == _N & `thehvar' < .
	qui replace `rankvar' = `rankvar' + _n if `rankvar' < .
	qui by `thehvar' : replace `rankvar' = `rankvar'[_N] if `thehvar' < .

	qui count if `idvar' < .
	local maxnn `r(N)'

	local ncnt : word count `groups'

	if `ncnt' > 1 {
		local znn nn
	}

	/* check for ties and adjust list depending on ties() option */
	/* following code assumes `groups' is sorted and >0 (imposed earlier)*/
	foreach nn of local groups {
		if "`nn'" == "`lastnn'" {
			/* skip repeats */
			continue
		}

		if `nn' == 1 {
			confirm new var `stub'``znn''
			local vnames `stub'``znn''
			local newlist 1
			local lastnn 1
			local lastadd 1
			continue
		}

		if `nn' > `maxnn' {
			if "`ties'" != "less" {
				di as err /*
			   */ "insufficient observations to create `nn' groups"
				exit 2000
			}
			else { /* ties(less) --> use maxnn */
				confirm new var `stub'``znn''
				local vnames `vnames' `stub'``znn''
				local newlist `newlist' `maxnn'
				continue, break
			}
		}

		qui count if `rankvar' <= `nn'
		if `r(N)' == `nn' - 1 { /* no ties for this case */
			confirm new var `stub'``znn''
			local vnames `vnames' `stub'``znn''
			local newlist `newlist' `nn'
			local lastadd `nn'
			local lastnn `nn'
			continue
		}

		/* need to deal with ties for this case */
		if "`ties'" == "error" {
			di as err "cannot create `nn' groups because of ties"
			exit 198
		}
		if "`ties'" == "skip" {
			local lastnn `nn'
			continue
		}
		if "`ties'" == "less" {
			confirm new var `stub'``znn''
			local vnames `vnames' `stub'``znn''
			qui summ `rankvar' if `rankvar' <= `nn'
			if `r(N)' == 0 {
				local newlist `newlist' 1
				local lastnn `nn'
				local lastadd 1
				continue
			}
			else {
				local newlist `newlist' `r(max)'
				local lastnn `nn'
				local lastadd `r(max)'
				continue
			}
		}
		if "`ties'" == "more" {
			confirm new var `stub'``znn''
			local vnames `vnames' `stub'``znn''
			qui summ `rankvar' if `rankvar'>=`nn' & `rankvar'< .
			local newlist `newlist' `r(min)'
			local lastnn `nn'
			local lastadd `r(min)'
			continue
		}
	}

	/* put into idvar order */
	sort `idvar'

	/* Since in `idvar' order the last `rankvar' change from . to 1 */
	qui replace `rankvar' = 1 in `maxnn'

	tempvar marker
	qui gen long `marker' = .

	/* Now we create the vars */
	local ncnt : word count `newlist'
	forvalues i = 1/`ncnt' {

		sort `idvar'

		qui replace `marker' = .   /* reset the marker */
		local nn : word `i' of `newlist'
		local vv : word `i' of `vnames'
		qui replace `marker' = 1 if `rankvar'[_n-1] <= `nn' in 2/`maxnn'
		qui replace `marker' = 1 in 1
		qui replace `marker' = sum(`marker') in 1/`maxnn'

		sort `ordvar'

		qui gen long `vv' = `marker'[`idvar'] in 1/`maxnn'
		ReformatDisp `vv'
	}
end


* ClGenCut --- Utility program that does the work of generating a group var
*              from a hier. cluster analysis by cutting the tree at a value
*
program define ClGenCut, sortpreserve
	syntax newvarname , clname(str) cut(real)

	ClustQuery `clname'

	if "`r(type)'" != "hierarchical" {
		di as err `"`clname' is not a hierarchical cluster analysis"'
		exit 198
	}

	local idvar `r(idvar)'
	local ordvar `r(ordervar)'
	local hgtvar `r(heightvar)'

	if `"`r(similarity)'"' != "" & `"`r(dissimilarity)'"' != "" {
		di as err "dissimilarity and similarity simultaneously set"
		exit 198
	}
	else if `"`r(similarity)'"' != "" {
		local cmp "<="
	}
	else if `"`r(dissimilarity)'"' != "" {
		local cmp ">="
	}
	else {
		di as err "dissimilarity or similarity not set"
		exit 198
	}

	if "`hgtvar'" == "" {
		local rhtvar `r(real_heightvar)'
		local phtvar `r(pseudo_heightvar)'
		summ `phtvar' if `rhtvar' `cmp' `cut', meanonly
		local seln `r(N)'
		local selmin `r(min)'
		summ `phtvar' if ~(`rhtvar' `cmp' `cut'), meanonly
		local notseln `r(N)'
		local notselmax `r(max)'
		if `notseln'==0 | `seln'==0 {
			local hgtvar `rhtvar'
		} 
		else if `notselmax' > `selmin' {
			di as err "unable to perform cut due to dendrogram reversal"
			exit 198
		}
		else {
			local hgtvar `rhtvar'
		}
	}

	quietly {
		count if `idvar' < .
		local nn `r(N)'

		tempvar marker
		gen long `marker' = -`idvar'

		sort `marker'

		replace `marker' = .
		replace `marker' = 1 if `hgtvar' `cmp' `cut' in 2/`nn'
		replace `marker' = 1 in 1
		count if `marker' == 1 in 1/`nn'
		local mmax = `r(N)' + 1
		replace `marker' = sum(`marker') in 1/`nn'

		sort `ordvar'

		gen long `varlist' = `mmax' - `marker'[`idvar'] in 1/`nn'
		ReformatDisp `varlist'
	}
end


* ParseStart --- Parse the -start()- option of -cluster kmeans- and
*                -cluster kmedians- and check for errors
*
* Possible start options include the following.  The first set of options
* identify k observations to use directly.  The second set of options set up a
* partition of the data and the k starting means (or medians) are computed from
* that partition.  The last option randomly creates k observations.
*
*     krandom[(seed#)] -- k unique observations chosen at random
*     firstk [, exclude ] -- first k observations.  exclude indicates they are
*         only to be used as seeds and are to be excluded from the actual
*         clustering.
*     lastk [, exclude ] -- last k observations. (exclude same as with firstk).
*
*     prandom[(seed#)] -- initial partition set up at random with restriction
*         that k groups are formed.
*     everykth -- observations 1, k+1, 2k+1, ... assigned to grp1 etc.
*     segments -- initial partition obtained by assigning (aprox) the first n/k
*         observations to grp1 etc.
*     group(varname) -- user provides an initial grouping variable.
*
*     random[(seed#)] -- randomly create k obs. with restriction that they fall
*         within the range of the data.  These obs are excluded from the actual
*         clustering -- only used as seeds.
*
* Returned : s(startway)   start method name
*            s(startopt)   option if provided
*            s(start)      fully spelled out start option
*
program define ParseStart, sclass
	gettoken vv 0 : 0	/* passes in top level caller version */
	gettoken k 0 : 0        /* caller passes in k */
	gettoken tousevar 0 : 0 /* caller passes in touse var name */
	gettoken start 0 : 0 , parse(" ,(")
	if `"`start'"' == "" { /* set default if not specified */
		local start krandom
	}
	local start = lower(`"`start'"')
	local stlen = length(`"`start'"')
	if `"`0'"' != "" {
		gettoken commapar : 0 , parse(" ,(")
		if `"`commapar'"' != "," & `"`commapar'"' != "(" {
			di as err "invalid start() option"
			exit 198
		}
	}

	qui count if `tousevar'
	local Nuse = `r(N)'
	if `Nuse' < `k' {
		di as err "insufficient observations"
		exit 2001
	}

  * ======================== krandom[(seed#)] =============================
	if `"`start'"' == bsubstr("krandom",1,max(2,`stlen')) {
		sreturn local startway krandom
		sreturn local start krandom
		if `"`0'"' != "" {
			local 0 `", krandom`0'"'
			syntax , KRandom(numlist max=1 min=1 >0)
			`vv' set seed `krandom'
			sreturn local start krandom(`krandom')
		}
		exit
	}

  * ======================== firstk [, exclude ] ==========================
	if `"`start'"' == bsubstr("firstk",1,max(1,`stlen')) {
		sreturn local startway firstk
		sreturn local start firstk
		if `"`0'"' != "" {
			syntax , EXclude
			sreturn local startopt exclude
			sreturn local start "firstk , exclude"
		}
		exit
	}

  * ======================== lastk [, exclude ] ===========================
	if `"`start'"' == bsubstr("lastk",1,max(1,`stlen')) {
		sreturn local startway lastk
		sreturn local start lastk
		if `"`0'"' != "" {
			syntax , EXclude
			sreturn local startopt exclude
			sreturn local start "lastk , exclude"
		}
		exit
	}

  * ======================== prandom[(seed#)] =============================
	if `"`start'"' == bsubstr("prandom",1,max(2,`stlen')) {
		sreturn local startway prandom
		sreturn local start prandom
		if `"`0'"' != "" {
			local 0 `", prandom`0'"'
			syntax , PRandom(numlist max=1 min=1 >0)
			`vv' set seed `prandom'
			sreturn local start prandom(`prandom')
		}
		exit
	}

  * ======================== everykth =====================================
	if `"`start'"' == bsubstr("everykth",1,max(6,`stlen')) {
		if `"`0'"' != "" {
			error 198
		}
		sreturn local startway everykth
		sreturn local start everykth
		exit
	}

  * ======================== segments =====================================
	if `"`start'"' == bsubstr("segments",1,max(3,`stlen')) {
		if `"`0'"' != "" {
			error 198
		}
		sreturn local startway segments
		sreturn local start segments
		exit
	}

  * ======================== group(varname) ===============================
	if `"`start'"' == bsubstr("group",1,max(1,`stlen')) {
		local 0 `",`start'`0'"'
		syntax , Group(varname)
		sreturn local startway group(`group')
		sreturn local start group(`group')
		exit
	}

  * ======================== random[(seed#)] ==============================
	if `"`start'"' == bsubstr("random",1,max(1,`stlen')) {
		sreturn local startway random
		sreturn local start random
		if `"`0'"' != "" {
			local 0 `", random`0'"'
			syntax , Random(numlist max=1 min=1 >0)
			`vv' set seed `random'
			sreturn local start random(`random')
		}
		exit
	}

	/* If we reach here it is an error */
	di as err "invalid start() option"
	exit 198
end


* DoStart --- Act on the -start()- option of -cluster kmeans- and
*             -cluster kmedians- and setup the k seed observations and append
*             them to the dataset.
*
* (see ParseStart for description of valid -start()- options)
*
program define DoStart
	gettoken k 0 : 0         /* caller passes in k */
	gettoken tousevar 0 : 0  /* caller passes in touse var name */
	gettoken realidvar 0 : 0 /* caller passes in 1/n var for dataset */
	gettoken mtype 0 : 0     /* caller passes in "medians" or "means" */

	syntax varlist(numeric) [, krandom firstk lastk prandom everykth /*
		*/ segments group(varname) random exclude binary ]

	/* binary is a flag indicating that the variables are to be treated
	   as binary variables when computing means or medians (non zeros are
	   treated as 1 except missing which is missing). */

	local oldN = _N
	local Np1 = `oldN' + 1
	local newN = _N + `k'

	/* For check of unique, must be careful if binary and not 0/1 vals */
	if "`binary'" != "" {
		local i 0
		foreach v of local varlist {
			capture assert `v'==1 | `v'==0 if `tousevar'
			if _rc != 0 {
				local i = `i'+1
				tempvar tmv`i'
				qui gen byte `tmv`i'' = !(`v'==0) if `tousevar'
				local newvlist `newvlist' `tmv`i''
			}
			else {
				local newvlist `newvlist' `v'
			}
		}
	}
	else { /* no change needed */
		local newvlist `varlist'
	}

	/* these methods pull k existing obs. as start seeds */
	if "`krandom'`firstk'`lastk'" != "" {
		tempvar uniques

		if "`krandom'" != "" {
			tempvar rndm
			qui gen float `rndm' = uniform()
			local tmpid `realidvar'
		}
		else if "`lastk'" != "" {
			tempvar tmpid
			local nmkp1 = _N - `k' + 1
			qui gen long `tmpid' = `realidvar'
			sort `tousevar' `realidvar'
			qui replace `tmpid' = `realidvar'-_N in `nmkp1'/l
		}
		else if "`firstk'" != "" {
			local tmpid `realidvar'
		}

		/* need to get unique ones */
		sort `tousevar' `newvlist' `rndm' `tmpid'
		qui by `tousevar' `newvlist' : gen byte `uniques' = 1 /*
						*/ if _n==1 & `tousevar'
		qui count if `uniques'==1
		if `r(N)' < `k' {
			di as err /*
			   */ "insufficient observations due to ties"
			exit 2001
		}
		/* now find first (or last or random) k unique obs */
		sort `uniques' `rndm' `tmpid'

		if "`exclude'" != "" {
			qui replace `tousevar' = 0 in 1/`k'
			qui count if `tousevar'
			if `r(N)' < `k' {
				di as err "insufficient observations"
				exit 2001
			}
		}

		/* put selected obs into extra k obs at end of dataset */
		qui set obs `newN'
		qui replace `tousevar' = 0 in `Np1'/`newN' /* make 0 not . */
		local numv : word count `varlist'
		forvalues i = 1/`numv' {
			local var : word `i' of `varlist'
			if "`binary'" != "" {
				local nvlvar : word `i' of `newvlist'
				qui replace `var' = `nvlvar'[_n-`oldN'] /*
							*/ in `Np1'/`newN'
				qui replace `nvlvar' = `nvlvar'[_n-`oldN'] /*
							*/ in `Np1'/`newN'
			}
			else {
				qui replace `var' = `var'[_n-`oldN'] /*
							*/ in `Np1'/`newN'
			}
		}

		/* get realidvar ready for putting back into order */
		qui replace `realidvar' = _n in `Np1'/`newN'

		/* make sure enough unique obs for clustering */
		drop `uniques'
		sort `tousevar' `newvlist' `realidvar'
		qui by `tousevar' `newvlist' : gen byte `uniques' = 1 /*
						*/ if _n==1 & `tousevar'
		qui count if `uniques' == 1
		if `r(N)' < `k' {
			di as err "insufficient observations due to ties"
			exit 2001
		}

		/* put back into order */
		sort `realidvar'
		qui replace `realidvar' = . in `Np1'/`newN'
		exit
	}


	/* these methods compute start seeds from a partition of the data */
	else if "`prandom'`everykth'`segments'`group'" != "" {
		tempvar grpvar

		if "`prandom'" != "" {
			tempvar rndm
			qui gen float `rndm' = uniform()
			local kp1 = `k' + 1
			sort `tousevar' `rndm' `realidvar'
			qui by `tousevar' : gen long `grpvar' = /*
				*/ _n if _n <= `k' & `tousevar'
			qui by `tousevar' : replace `grpvar' = /*
				*/ `grpvar'[_n-`k'] if _n > `k' & `tousevar'
		}

		if "`everykth'" != "" {
			local kp1 = `k' + 1
			sort `tousevar' `realidvar'
			qui by `tousevar' : gen long `grpvar' = /*
				*/ _n if _n <= `k' & `tousevar'
			qui by `tousevar' : replace `grpvar' = /*
				*/ `grpvar'[_n-`k'] if _n > `k' & `tousevar'
		}

		if "`segments'" != "" {
			sort `tousevar' `realidvar'
			qui by `tousevar' : gen long `grpvar' = /*
				*/ int(((_n-1)/_N)*`k') + 1 if `tousevar'
		}

		if "`group'" != "" {
			sort `tousevar' `group' `realidvar'
			qui by `tousevar' `group' : gen long `grpvar' = /*
				*/ 1 if _n==1 & `tousevar' & !missing(`group')
			qui count if `grpvar'==1
			if `r(N)' != `k' {
				di as err "`group' does not define `k' groups"
				exit 198
			}
			qui by `tousevar' : replace `grpvar' = sum(`grpvar') /*
				*/ if `tousevar' & !missing(`group')
		}

		sort `realidvar'

		/* add k new observations to bottom of data */
		qui set obs `newN'
		qui replace `tousevar' = 0 in `Np1'/`newN' /* make 0 not . */
		qui replace `realidvar' = _n in `Np1'/`newN'

		if "`binary'" != "" { /* setup to deal with binary vars */
			tempvar binvar
			qui gen byte `binvar' = .
		}

		if "`mtype'" == "means" {
			local summopt ", meanonly"
			local summr "r(mean)"
		}
		else { /* medians */
			local summopt ", detail"
			local summr "r(p50)"
		}
		/* fill in the mean or median values in last k obs */
		local numv : word count `varlist'
		forvalues i = 1/`numv' {
			local var : word `i' of `varlist'
			local thevar : word `i' of `newvlist'
			forvalues grp = 1/`k' {
				local Npk = `oldN' + `grp'
				qui summ `thevar' if `grpvar' == `grp' `summopt'
				qui replace `var' = `summr' in `Npk'
				if "`var'" != "`thevar'" {
					qui replace `thevar' = `summr' in `Npk'
				}
			}
		}

		/* make sure enough unique obs for clustering */
		tempvar uniques
		sort `tousevar' `newvlist' `realidvar'
		qui by `tousevar' `newvlist' : gen byte `uniques' = 1 /*
						*/ if _n==1 & `tousevar'
		qui count if `uniques'==1
		if `r(N)' < `k' {
			di as err "insufficient observations due to ties"
			exit 2001
		}

		/* put back into proper order */
		sort `realidvar'
		qui replace `realidvar' = . in `Np1'/`newN'

		exit
	}


	/* this method creates random start seeds */
	else if "`random'" != "" {
		/* make sure enough unique obs for clustering */
		tempvar uniques
		sort `tousevar' `newvlist' `realidvar'
		qui by `tousevar' `newvlist' : gen byte `uniques' = 1 /*
						*/ if _n==1 & `tousevar'
		qui count if `uniques'==1
		if `r(N)' < `k' {
			di as err "insufficient observations due to ties"
			exit 2001
		}
		/* put back into proper order */
		sort `realidvar'

		/* add k new observations to bottom of data */
		qui set obs `newN'
		qui replace `tousevar' = 0 in `Np1'/`newN' /* make 0 not . */

		/* fill the k new obs with random limited to range of data */
		foreach var of local varlist {
			if "`binary'" != "" { /* random 0's and 1's as seeds */
				qui replace `var'=round(uniform(),1) /*
					*/ in `Np1'/`newN'
			}
			else { /* random seeds within range of data */
				summ `var' if `tousevar', meanonly
				local vmin = r(min)
				local vrange = r(max) - r(min)
				qui replace `var'=uniform()*`vrange'+`vmin' /*
					*/ in `Np1'/`newN'
			}
		}

		exit
	}
end


program define CheckPHTvar, rclass
	capture assert `1' >= .
	if _rc {
		ReformatDisp `1'
		return local nopht 0
	}
	else {
		return local nopht 1
	}
end


program define ReformatDisp
	qui compress `0'
	foreach x of local 0 {
		local xtype : type `x'
		if "`xtype'" == "byte" | "`xtype'" == "int" {
			format `x' %8.0g
		}
		else if "`xtype'" == "long" {
			format `x' %12.0g
		}
		else if "`xtype'" == "float" {
			format `x' %9.0g
		}
		else if "`xtype'" == "double" {
			format `x' %10.0g
		}
	}
end



// ResolveVersion
//
//   1) sets (if not set) globals: S_Cl_stub, S_V2_Cluster, S_V2_Cl_stub,
//      and S_Cl_MaxCharLen
//   2) sets caller's local: reset_these_globals containing a list
//      of globals for the calling routine to clear just before exiting
//   3) Pulls old version cluster objects over to new version (erasing the old)
//
// ----------------------------------------------------------------------------
//
// Version 1 of -cluster- used $S_Cl_stub == "_cl" for
//       1) Indicating where to store the list of cluster analyses
//          (_dta[_cl])
//       2) As the default stub for naming each cluster analysis (_cl_#)
//
// Version 2 of -cluster- uses $S_V2_Cluster == "_cluster_objects" for
//       1) Indicating where to store the list of cluster analyses
//          (_dta[_cluster_objects])
//       2) The first 3 characters are used as the default stub for naming
//          each cluster analysis (_cl_#)
//
program ResolveVersion

	capture			// just to reset c(rc)

	if `"$S_Cl_MaxCharLen"' == "" {
		// up to 67784 allowed (i.e., max length of a char in Stata/IC)
		global S_Cl_MaxCharLen 67000
		local greset S_Cl_MaxCharLen
	}
	else {
		capture confirm integer number $S_Cl_MaxCharLen
		if !c(rc) {
			capture assert inrange($S_Cl_MaxCharLen, 40, 67784)
		}
		if c(rc) {
			di as error "global $S_Cl_MaxCharLen is invalid"
			exit c(rc)
		}
	}

	if `"$S_Cl_stub"' == "" {
		/* if stub not already preset by user set it to default */
		global S_Cl_stub "_cl"
		local greset `greset' S_Cl_stub
	}
	else {
		capture confirm name $S_Cl_stub
		if c(rc) {
			di as error "global S_Cl_stub contains invalid name"
			foreach g of local greset {
				global `g'
			}
			exit c(rc)
		}
	}

	if `"$S_V2_Cluster"' == "" {
		/* if not already preset by user set it to default */
		global S_V2_Cluster "_cluster_objects"
		local greset `greset' S_V2_Cluster
	}
	else {
		capture confirm name $S_V2_Cluster
		if c(rc) {
			di as error "global S_V2_Cluster contains invalid name"
			foreach g of local greset {
				global `g'
			}
			exit c(rc)
		}
	}
	if `"$S_V2_Cl_stub"'=="" {
		global S_V2_Cl_stub = usubstr(`"$S_V2_Cluster"',1,5)
		local greset `greset' S_V2_Cl_stub
	}
	else {
		capture confirm name $S_V2_Cl_stub
		if c(rc) {
			di as error "global S_V2_Cl_stub contains invalid name"
			foreach g of local greset {
				global `g'
			}
			exit c(rc)
		}
	}

	if `"`_dta[$S_Cl_stub]'"' != "" & `"`_dta[$S_V2_Cluster]'"' != "" {
		// Somehow there are both old and new -cluster- analyses
		// (maybe because of a -merge- with an older .dta file).
		// Pull the old ones over to the new style.
		capture noisily MergeOldToNew
	}
	else if `"`_dta[$S_Cl_stub]'"' != "" {
		// Old style -cluster- analyses -- pull over to new style
		capture noisily PullOldToNew
	}

	if c(rc) {
		foreach g of local greset {
			global `g'
		}
		exit c(rc)
	}

	// set the caller's reset_these_globals (local macro)
	c_local reset_these_globals `greset'
end


program MergeOldToNew

	local newlist : char _dta[$S_V2_Cluster]
	local oldlist : char _dta[$S_Cl_stub]

	// Check if any old have same name as new
	local chk : list newlist & oldlist
	if "`chk'" != "" {
		di as err "{p}" ///
		"older-version cluster analysis named `chk' and " ///
		"newer-version cluster analysis of the same name found;{p_end}"
		di as err
		di as err "{p}" ///
		"This problem likely happened after merging or appending " ///
		"an older-version Stata dataset containing cluster " ///
		"analyses with a modern Stata dataset also containing " ///
		"cluster analyses.  Both the old and the new datasets " ///
		"contained a cluster analysis with the same name (one " ///
		"stored the old way and the other the new way).  To " ///
		"resolve the problem, use -cluster rename- and -cluster " ///
		"renamevar- on the original datasets to obtain unique " ///
		"cluster names and then recombine the datasets.{p_end}"

if 0 {
// The following will only work if the conflicting cluster analyses used
// different underlying created variable names (e.g., due to using the
// -gen()- option instead of allowing for the default names, or one was
// a hierarchical and the other a partition cluster analysis and so create
// different default variable names).  Otherwise, the variables from the
// conflicting cluster analyses are no longer valid for use because of the
// merging or appending that must have happened to create such a dataset.
		di as err
		di as err "{p}" ///
		"Alternatively, backup your current dataset (just in " ///
		"case), temporarily hide the information for the old " ///
		"cluster analyses, and then rename the newer cluster " ///
		"analyses that are in conflict with the older cluster " ///
		"analyses.  Then place the information for the old " ///
		"cluster analyses back.{p_end}"
		di as err
		di as err  "        save ..."
		di as err  "        local hold_old_cl : char _dta[_cl]"
		di as err  "        char _dta[_cl]"
		di as err  "        cluster rename ..."
		di as err `"        char _dta[_cl] "\`hold_old_cl'""'
		di as err
		di as err "{p}" ///
		"Then reissue your -cluster- command and the old-style " ///
		"cluster analyses should be pulled in with the new-style " ///
		"cluster analyses.{p_end}."
} // end of -if 0-

		exit 459
	}

	PullOldToNew

end


program PullOldToNew

	// loop over the old cluster analyses
	foreach clobj in `: char _dta[$S_Cl_stub]' {
		// copy old to new
		OldToNew `clobj' `clobj'
	}

	// append the old items to the new list
	char _dta[$S_V2_Cluster] ///
		`: char _dta[$S_V2_Cluster]' `: char _dta[$S_Cl_stub]'

	// erase the old list
	char _dta[$S_Cl_stub]
end

program OldToNew

	args oldname newname

	local old : char _dta[`oldname']

	if `"`oldname'"' != `"`newname'"' {
		if `"`_dta[`newname']'"' != "" {
			di as err "char _dta[`newname'] already defined"
			exit 459
		}
	}

	local ncnt 0
	foreach item of local old {
		gettoken first rest : item
		local rest : list retokenize rest
		if `"`first'"' == "t" {
			local inf `"`inf' `"t `rest'"'"'
		}
		else if `"`first'"' == "m" {
			local inf `"`inf' `"m `rest'"'"'
		}
		else if `"`first'"' == "d" {
			local inf `"`inf' `"d `rest'"'"'
		}
		else if `"`first'"' == "s" {
			local inf `"`inf' `"s `rest'"'"'
		}
		else if `"`first'"' == "v" {
			local inf `"`inf' `"v `rest'"'"'
		}
		else if `"`first'"' == "o" {
			gettoken tag rest : rest
			local rest : list retokenize rest
			if `"`tag'"' == "cmd" {
				GetAName `"`newname'"' "_cmd"
				local ptr_cmd `ptr_cmd' `r(name)'
				char _dta[`r(name)'] `"`rest'"'
			}
			else if `"`tag'"' == "varlist" {
				GetAName `"`newname'"' "_vars"
				local ptr_vars `ptr_vars' `r(name)'
				char _dta[`r(name)'] `"`rest'"'
			}
			else {
				local inf `"`inf' `"o `tag' `rest'"'"'
			}
		}
		else if `"`first'"' == "n" {
			local ncnt = `ncnt' + 1
			GetAName `"`newname'"' "_n`ncnt'"
			local ptr_notes `ptr_notes' `r(name)'
			char _dta[`r(name)'] `"`rest'"'
		}
		else if `"`first'"' == "c" {
			local inf `"`inf' `"c `rest'"'"'
		}
	}

	local inf : list retokenize inf
	GetAName `"`newname'"' "_info"
	local ptri `r(name)'
	char _dta[`r(name)'] `"`inf'"'

	if `"`ptr_cmd'"' != "" {
		local theptrs `""cmd `ptr_cmd'""'
	}
	if `"`ptr_vars'"' != "" {
		local theptrs `"`theptrs' "vars `ptr_vars'""'
	}
	if `"`ptri'"' != "" {
		local theptrs `"`theptrs' "info `ptri'""'
	}
	if `"`ptr_notes'"' != "" {
		local theptrs `"`theptrs' "notes `ptr_notes'""'
	}
	local theptrs : list retokenize theptrs

	char _dta[`oldname']
	char _dta[`newname'] `"`theptrs'"'
end


// AddCmd finds an available char (or chars if more than one will be needed)
// and places cmd in the char (or chars) and then sends back the new list of
// cptrs in r(cmdptrs)
program AddCmd, rclass
	args clname cptrs cmd

	local maxlen $S_Cl_MaxCharLen

	if `"`cmd'"' == "" { // There is nothing to do
		return local cmdptrs `"`cptrs'"'
		exit
	}
	if `"`cptrs'"' != "" {
		// We expect at most 1 "other(cmd ...) item, but there is
		// already an existing one
		di as err "{p}" ///
		"other(cmd ...) already set; " ///
		"use -cluster delete other(cmd)- to delete it before " ///
		"using -cluster set-{p_end}"
		exit 198
	}

	if `: length local cmd' > `maxlen' {
		local i 1
		while "`done'" == "" {
			local x : piece `i' `maxlen' of `"`cmd'"', nobreak
			if `"`x'"' == "" {
				local done 1
			}
			else {
				GetAName `"`clname'"' "_cmd"
				char _dta[`r(name)'] `"`x'"'
				local ptrs `ptrs' `r(name)'
			}
			local ++i
		}
		return local cmdptrs `"`ptrs'"'
	}
	else {
		GetAName `"`clname'"' "_cmd"
		char _dta[`r(name)'] `"`cmd'"'

		return local cmdptrs `"`r(name)'"'
	}
end


// AddVarlist finds an available char (or chars if more than one will be
// needed) and places the varlist (vlist) in the char (or chars) and then
// sends back the new list of vptrs in r(varsptrs)
program AddVarlist, rclass
	args clname vptrs vlist

	local maxlen $S_Cl_MaxCharLen

	if `"`vlist'"' == "" { // There is nothing to do
		return local varsptrs `"`vptrs'"'
		exit
	}
	if `"`vptrs'"' != "" {
		// We expect at most 1 "other(varlist ...) item, but there is
		// already an existing one
		di as err "{p}" ///
		"other(varlist ...) already set; " ///
		"use -cluster delete other(varlist)- to delete it before " ///
		"using -cluster set-{p_end}"
		exit 198
	}

	if `: length local vlist' > `maxlen' {
		local i 1
		while "`done'" == "" {
			local x : piece `i' `maxlen' of `"`vlist'"', nobreak
			if `"`x'"' == "" {
				local done 1
			}
			else {
				GetAName `"`clname'"' "_vars"
				char _dta[`r(name)'] `"`x'"'
				local ptrs `ptrs' `r(name)'
			}
			local ++i
		}
		return local varsptrs `"`ptrs'"'
	}
	else {
		GetAName `"`clname'"' "_vars"
		char _dta[`r(name)'] `"`vlist'"'

		return local varsptrs `"`r(name)'"'
	}
end


// AddInfo finds an available char (or chars if more than one will be needed)
// and places the info in the char (or chars) and then sends back the new
// list of iptrs in r(infoptrs)
program AddInfo, rclass
	args clname iptrs info

	local maxlen $S_Cl_MaxCharLen

	if `"`info'"' == "" { // There is nothing to do
		return local infoptrs `"`iptrs'"'
		exit
	}
	local ilen : length local info
	if `ilen' > `maxlen' {
		// Split into 2 parts with part1 small enough
		local iwc : word count `info'
		forvalues i = 1/`iwc' {
			local nxt : word `i' of `info'
			if !`done1'0 & `: length local part1' + ///
			   `: length local nxt'   + 6 < `maxlen' {
				local part1 `"`part1' `"`nxt'"'"'
			}
			else {
				local done1 1
				local part2 `"`part2' `"`nxt'"'"'
			}
		}
		local part1 : list retokenize part1
		local part2 : list retokenize part2

		// Call back in to this routine with the 2 parts
		AddInfo `clname' `"`iptrs'"' `"`part1'"'
		AddInfo `clname' `"`r(infoptrs)'"' `"`part2'"'
		return local infoptrs `r(infoptrs)'
		exit
	}

	local n : word count `iptrs'
	if `n' {
		local liptr : word `n' of `iptrs'
		local lasti : char _dta[`liptr']
		local llen : length local lasti
		if `llen' + `ilen' + 1 < `maxlen' {
			char _dta[`liptr'] `"`lasti' `info'"'
			local ptrs `iptrs'
		}
		else {
			GetAName `"`clname'"' "_info"
			char _dta[`r(name)'] `"`info'"'
			local ptrs `iptrs' `r(name)'
		}
	}
	else {
		GetAName `"`clname'"' "_info"
		char _dta[`r(name)'] `"`info'"'
		local ptrs `r(name)'
	}

	return local infoptrs `"`ptrs'"'
end


// AddNote finds an available char and places the note in it and sends
// back the new list of nptrs in r(noteptrs)
program AddNote, rclass
	args clname nptrs note

	if `"`note'"' == "" { // There is nothing to do
		return local noteptrs `"`nptrs'"'
		exit
	}

	GetAName `"`clname'"' "_note"
	char _dta[`r(name)'] `"`note'"'

	return local noteptrs `"`nptrs' `r(name)'"'
end


program GetAName, rclass

	args first last

	local try = usubstr("`first'`last'",1,32)
	capture confirm name `try'
	if _rc {
		local try "_clus_"
	}
	if `"`_dta[`try']'"' == "" & `"`try'"' != `"`first'"' {
		return local name "`try'"
		exit
	}
	local try = usubstr("`try'",1,31)
	forvalues i = 1/9 {
		if `"`_dta[`try'`i']'"' == "" & `"`try'`i'"' != `"`first'"' {
			return local name "`try'`i'"
			continue, break
		}
	}
	if `"`return(name)'"' != "" {
		exit
	}
	local try = usubstr("`try'",1,30)
	forvalues i = 10/99 {
		if `"`_dta[`try'`i']'"' == "" & `"`try'`i'"' != `"`first'"' {
			return local name "`try'`i'"
			continue, break
		}
	}
	if `"`return(name)'"' != "" {
		exit
	}
	local try = usubstr("`try'",1,29)
	forvalues i = 100/999 {
		if `"`_dta[`try'`i']'"' == "" & `"`try'`i'"' != `"`first'"' {
			return local name "`try'`i'"
			continue, break
		}
	}
	if `"`return(name)'"' != "" {
		exit
	}
	local try = usubstr("`try'",1,28)
	forvalues i = 1000/9999 {
		if `"`_dta[`try'`i']'"' == "" & `"`try'`i'"' != `"`first'"' {
			return local name "`try'`i'"
			continue, break
		}
	}
	if `"`return(name)'"' != "" {
		exit
	}
	local try = usubstr("`try'",1,27)
	forvalues i = 10000/99999 {
		if `"`_dta[`try'`i']'"' == "" & `"`try'`i'"' != `"`first'"' {
			return local name "`try'`i'"
			continue, break
		}
	}
	if `"`return(name)'"' != "" {
		exit
	}
	local try = usubstr("`try'",1,26)
	forvalues i = 100000/999999 {
		if `"`_dta[`try'`i']'"' == "" & `"`try'`i'"' != `"`first'"' {
			return local name "`try'`i'"
			continue, break
		}
	}
	if `"`return(name)'"' != "" {
		exit
	}

	// This should be exceedingly rare
	di as err "char _dta[" usubstr("`first'`last'",1,32) "] is not available"
	exit 198
end

