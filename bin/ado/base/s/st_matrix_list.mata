*! version 1.0.4  12feb2015
version 11

mata:

void st_matrix_list(	string	scalar	mname,
			|string	scalar	fmt,
			string	scalar	title,
			real	scalar	blank,
			real	scalar	half,
			real	scalar	header,
			real	scalar	names,
			real	scalar	dotz)
{
	real	matrix	M
	string	matrix	R
	string	matrix	C

	if (fmt == "") {
		fmt = "%10.0g"
	}

	M = st_matrix(mname)
	if (names) {
		R = st_matrixrowstripe_abbrev(mname, 12)
		C = st_matrixcolstripe_split(mname, 12)
	}
	else {
		R = J(rows(M),2,"")
		C = J(cols(M),2,"")
	}

	if (blank) {
		printf("\n")
	}

	if (header) {
		displayas("txt")
		if (rows(M) == cols(M)) {
			if (mreldifsym(M) < 1e-8) {
				printf("symmetric ")
			}
		}
		printf("%s[%1.0f,%1.0f]", mname, rows(M), cols(M))
		if (strlen(title)) {
			printf(":  %s", title)
		}
		printf("\n")
	}

	_matrix_list(M, R, C, fmt, half, dotz)
}

void _matrix_list(
	real	matrix	M,
	|string	matrix	rstripe,
	string	matrix	cstripe,
	string	scalar	fmt,
	real	scalar	half,
	real	scalar	dotz
)
{
	real	scalar	r, c, b, c0, c1
	real	scalar	i, j
	real	scalar	rwidth, cwidth
	real	scalar	lsize, cblocks, nblocks
	real	scalar	issym
	string	scalar	rfmt, cfmt
	string	matrix	S, myrstripe, mycstripe
	real	scalar	hasop
	string	scalar	lastch

	// validate the matrix stripe arguments
	r = rows(M)
	if (args() > 1 & rows(rstripe)) {
		if (cols(rstripe) < 2) {
			errprintf(
"invalid stripe matrix in second argument\n")
			exit(9)
		}
		if (rows(rstripe) > r) {
			errprintf(
"stripe matrix in second argument has too many rows\n")
			exit(3200)
		}
		if (rows(rstripe) < r) {
			errprintf(
"stripe matrix in second argument has too few rows\n")
			exit(3200)
		}
		myrstripe = rstripe
	}
	else {
		myrstripe = J(r,2,"")
		for (b=1; b<=r; b++) {
			myrstripe[b,2] = sprintf("r%f",b)
		}
	}
	c = cols(M)
	if  (args() > 2 & rows(cstripe)) {
		if (cols(cstripe) < 2) {
			errprintf("invalid stripe matrix in third argument\n")
			exit(9)
		}
		if (rows(cstripe) > c) {
			errprintf(
			"stripe matrix in third argument has too many rows\n")
			exit(3200)
		}
		if (rows(cstripe) < c) {
			errprintf(
			"stripe matrix in third argument has too few rows\n")
			exit(3200)
		}
		mycstripe = cstripe
	}
	else {
		mycstripe = J(c,2,"")
		for (b=1; b<=c; b++) {
			mycstripe[b,2] = sprintf("c%f",b)
		}
	}

	if (length(M) == 0) {
		return
	}

	// validate format argument
	if (args() < 4) {
		fmt = "%10.0g"
	}
	S = strofreal(M, fmt)

	issym = 0
	if (half & r == c) {
		issym = mreldifsym(M) < 1e-8
	}

	if (dotz == 0) {
		if (any(S :== ".z")) {
			for (i=1; i<=r; i++) {
				for (j=1; j<=c; j++) {
					if (S[i,j] == ".z") {
						S[i,j] = ""
					}
				}
			}
		}
	}

	if (cols(myrstripe) > 2) {
		rwidth	= max(strlen(myrstripe[,1]))-1
		c0	= cols(myrstripe) 
		for (i=1; i<=r; i++) {
			for (j=2; j<=c0; j++) {
				if (strlen(myrstripe[i,j])) {
					lastch	= bsubstr(myrstripe[i,j],-1,1)
					hasop	= strpos(".@#|*", lastch)
					rwidth	= max((	rwidth,
						strlen(myrstripe[i,j])-hasop))
				}
			}
		}
	}
	else {
		rwidth	= max(strlen(myrstripe[,1]+myrstripe[,2]))
	}
	cwidth	= max((max(strlen(S)), max(strlen(mycstripe)))) + 2
	lsize	= c("linesize") - rwidth - 1
	cblocks	= floor(lsize/cwidth)
	nblocks	= ceil(c/cblocks)
	rfmt	= "%" + strofreal(rwidth) + "uds"
	cfmt	= "%" + strofreal(cwidth-1) + "uds"
	cwidth	= max(strlen(mycstripe))

	for (b=1; b<=nblocks; b++) {
		c0 = (b-1)*cblocks+1
		c1 = min((c,b*cblocks))
		_matrix_list_wrk(
			S,
			myrstripe,
			mycstripe,
			c0, c1,
			issym,
			rfmt,
			cfmt
		)
		if (b<nblocks & cwidth) {
			printf("\n")
		}
	}
	printf("{reset}")
}

/*STATIC*/ void _matrix_list_wrk(
	string	matrix	S,
	string	matrix	rstripe,
	string	matrix	cstripe,
	real	scalar	c0,
	real	scalar	c1,
	real	scalar	issym,
	string	scalar	rfmt,
	string	scalar	cfmt
)
{
	real	scalar	r0, r
	real	scalar	cscols
	real	scalar	rscols
	real	scalar	i, j, k
	real	scalar	hasop
	string	scalar	lastch
	string	scalar	oldeq
	real	scalar	rsplit

	if (issym) {
		r0 = c0
	}
	else	r0 = 1
	r = rows(S)

	displayas("txt")
	if (max(strlen(cstripe[,1]))) {
		printf(rfmt+" ", "")
		for (j=c0; j<=c1; j++) {
			printf(" "+cfmt, cstripe[j,1])
		}
		printf("\n")
	}
	if (max(strlen(cstripe[,2..cols(cstripe)]))) {
		cscols = cols(cstripe) ;
		for (k=2; k<=cscols; k++) {
			printf(rfmt+" ", "")
			for (j=c0; j<=c1; j++) {
				lastch = bsubstr(cstripe[j,k],-1,1)
				hasop = k<cscols ? strpos(".@#|*", lastch) : 0
				if (hasop) {
					printf(" "+cfmt, cstripe[j,k])
				}
				else {
					printf(	cfmt+(j==c1? "" : " "),
						cstripe[j,k])
				}
			}
			printf("\n")
		}
	}

	oldeq	= ""
	rscols	= cols(rstripe) ;
	rsplit	= rscols > 2
	for (i=r0; i<=r; i++) {
		displayas("txt")
		if (rsplit) {
			if (rstripe[i,1] != oldeq) {
				lastch = bsubstr(rstripe[i,1],-1,1)
				hasop = strpos(":", lastch)
				if (hasop) {
					oldeq = bsubstr(	rstripe[i,1],
							1,
							strlen(rstripe[i,1])-1)
				}
				else {
					oldeq = rstripe[i,1]
				}
				printf("{result:"+rfmt+"}:\n", oldeq)
				oldeq = rstripe[i,1]
			}
			if (max(strlen(rstripe[,2..cols(rstripe)]))) {
				for (k=2; k<rscols; k++) {
					if (strlen(rstripe[i,k])) {
					    lastch = sprintf(rfmt, rstripe[i,k])
					    if (lastch == rstripe[i,k]) {
						printf(rfmt, rstripe[i,k])
						printf("\n")
					    }
					    else {
						printf(" "+rfmt, rstripe[i,k])
						printf("\n")
					    }
					}
				}
			}
			printf(rfmt+" ", rstripe[i,rscols])
		}
		else {
			printf(rfmt+" ", rstripe[i,1]+rstripe[i,2])
		}
		displayas("result")
		for (j=c0; j<=c1; j++) {
			if (issym) {
				printf(	cfmt+(j==min((c1,i)) ? "" : " "),
					S[i,j])
				if (j == i) {
					break
				}
			}
			else {
				printf(cfmt+(j==c1 ? "" : " "), S[i,j])
			}
		}
		printf("\n")
	}
}

end
