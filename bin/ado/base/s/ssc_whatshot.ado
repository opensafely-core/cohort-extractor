*! version 1.1.2  17feb2015
program ssc_whatshot
	version 10
	syntax [, N(real 10) AUTHor(string)]

	if (`n'<=0) {
		di as error "option n() must be greater than 0"
		exit 198
	}
	if (`n' != floor(`n')) {
		di as error "option n() incorrectly specified"
		exit 198
	}

	preserve 
	quietly use http://repec.org/docs/sschotPPPcur, clear
	tempvar recnum neghits_cur
	quietly {
		gen `c(obs_t)' `recnum' = _n
		sort package `recnum'
		capture by package: assert hits_cur == hits_cur[1]
		if _rc { 
			noi listprob `recnum'
			/*NOTREACHED*/
		}
		by package: gen int pkgno = 1
		replace pkgno = sum(pkgno)
		gen `neghits_cur' = -hits_cur
		sort `neghits_cur' package `recnum'
		drop `neghits_cur'
		gen `c(obs_t)' rank = 1 if package!=package[_n-1]
		replace rank = sum(rank)
		sort rank `recnum'
		drop `recnum'
		if ("`author'"=="") {
			keep if rank <= `n'
		}
		else {
			tempvar hasname counter
			local author = lower("`author'")
			gen int `hasname' = strpos(lower(author), "`author'")
			by rank: replace `hasname' = sum(`hasname')
			by rank: replace `hasname' = `hasname'[_N]
			keep if `hasname'
			if (_N==0) { 
				exit
			}
			drop `hasname'
			by rank: gen `c(obs_t)' `counter' = 1 if _n==1
			replace `counter' = sum(`counter')
			keep if `counter' <= `n'
			drop `counter'
		}
	}

	mata: whatshot(`"`_dta[cur]'"', `n', "`author'")
end



program listprob
	args recnum

	capture drop obs_no
	rename `recnum' obs_no

	tempvar prob
	quietly {
		by package: gen int `prob'  = hits_cur != hits_cur[1]
		by package: replace `prob'  = sum(`prob')
		by package: replace `prob'  = `prob'[_N]
		keep if `prob'
		drop `prob'
	}
	di as txt
	di as txt "hits_cur not constant in the following package(s)"
	by package: list obs_no author hits_cur
	di as txt ///
	"(orig_obs is obs. # in http://repec.org/docs/sschotPPPcur.dta)"
	exit 9
end
		
	


local RS	real scalar
local RC	real colvector
local SS	string scalar
local SC	string colvector


mata:

void whatshot(`SS' datestr, `RS' n, `SS' ofauthor)
{
	`SC'	package, author
	`RC' 	hits, rank
	`RS'	i, j, nauthors
	`SC'	authors
	`SS'	ttl

	/* ------------------------------------------------------------ */
	pragma unset package
	pragma unset author
	pragma unset hits
	pragma unset rank

	st_sview(package, ., "package")
	st_sview(author,  ., "author")
	st_view( hits,    ., "hits_cur")
	st_view( rank,    ., "rank")
	/* ------------------------------------------------------------ */

	printf("\n")

	ttl = (n>=. ? "Packages at SSC" : sprintf("Top %f packages at SSC", n))
	if (ofauthor!="") { 
		ttl = ttl + " by author " + strproper(ofauthor)
	}
	printf("{txt}{title:" + ttl + "}\n")
	printf("\n")

	printf("{txt}    %~15s\n", fixdate(datestr))
	printf("  Rank   # hits    Package       Author(s)\n")
	printf("  {hline 70}\n")
	/* ------------------------------------------------------------ */

	pragma unset nauthors 
	for (i=1; i<=rows(package); i = i + nauthors) { 
		nauthors = nauthors(i, rank)
		/* ---------------------------------------------------- */
		authors = author[i]
		for (j=i+1; j<i+nauthors; j++) {
			authors = authors + ", " + author[j]
		}
		authors = justify(40, authors)
		/* ---------------------------------------------------- */
		printf("  %4.0f  %7.1f    {%s:%-12s}  %-40s\n", 
			rank[i], hits[i],
			pkgcmd(package[i]), strlower(package[i]), 
			authors[1])
		for (j=2; j<=rows(authors); j++) { 
			printf("{space 33}  %-40s\n", authors[j])
		}
	}
	printf("  {hline 70}\n")
	printf("  (Click on package name for description)\n")
}


`SS' fixdate(`SS' datestr)
{
	`RS'	date
	`SS'	res

	if ( (date = date("1 " + datestr, "DMY")) >= .) { 
		res = strtrim(datestr)
		return(res=="" ? "Unknown" : res)
	}
	return(sprintf("%tdMon_CCYY", date))
}

`SS' pkgcmd(`SS' package)
{
	`SS'	ltr, name

	name = strlower(strtrim(package))
	ltr  = bsubstr(name, 1, 1)

	return(`"net "describe "' + name + 
	       ", from(http://fmwww.bc.edu/RePEc/bocode/" + ltr + `")""')
}

/*           ________
	`RS' nauthors = nauthors(`RS' i, `RC' rank)
				      -       ----

	Return number of authors for observation i.
*/

`RS' nauthors(`RS' i, `RC' rank)
{
	`RS'	j

	for (j=i; j<=rows(rank); j++) {
		if (rank[j]!=rank[i]) return(j-i)
	}
	return(j-i) 
}





/*           _____
	`SC' lines = justify(`RS' width, `SS' text)
			          -----       ----

	General purpose and useful utility.  Returns contents of text 
	in lines of length width.  For instance, 

		justify(20, "demonstration of how this works")

	returns 
		("demonstration of" \
		 "how this works")
*/
		

`SC' justify(`RS' width, `SS' text)
{
	`RS'	i
	`SS'	piece
	`SC'	res, rhs

	if (strlen(text)<=width) return(text)

	piece = bsubstr(text, 1, width)
	if ((i = width - strpos(strreverse(piece), " ") + 1) < width) {
		res = strrtrim(bsubstr(text, 1, i))
		rhs = strltrim(bsubstr(text, i, .))
	}
	else {
		res = piece 
		rhs = bsubstr(text, width+1, .)
	}
	if (rhs=="") return(res)
	return((res\ justify(width, rhs)))
}

end
