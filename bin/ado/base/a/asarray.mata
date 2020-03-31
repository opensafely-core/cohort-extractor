*! version 1.0.7  06nov2017
version 10.0

/* -------------------------------------------------------------------- */
							/* Comments	*/
/*
	(transmorphic)	  A = asarray_create([...])
	(void)            A = asarray_notfound(A, notfoundvalue)
	(transmorphic)	  asarray_notfound(A [, notfound])

	(void)            asarray(A, key, contents)
	(transmorphic)    asarray(A, key)

	(`boolean')       asarray_contains(A, key)

	(void)            asarray_remove(A, key)

	(real scalar)     asarray_elements(A)

	(string colvector) asarray_keys(A)

	(transmorphic)    L = asarray_first(A)
	(string scalar)   asarray_key(A, L)
	(transmorphic)	  asarray_contents(A, L)
	(transmorphic)    L = asarray_next(A, L)

	(real scalar)	  asarray_size(A)
	(real rowvector)  asarray_stats(A)
	(void)		  asarray_report(A)

*/


/* -------------------------------------------------------------------- */
						/* Definitions		*/


local DEFAULT_dupsize			5
local MULTIPLIER			1.5
local DEFAULT_NOTFOUND	 		J(0,0,1)

local DEFAULT_maxratio			2
local DEFAULT_minratio			.5
local MIN_minsize			5
local DEFAULT_minsize			100
local MAX_minsize			trunc(2147483647/`MULTIPLIER')

local static

local RS	real scalar
local SS	string scalar
local SC	string colvector
local SM	string matrix
local PS	pointer(transmorphic) scalar
local PR	pointer(transmorphic) rowvector
local SR	string rowvector
local RR	real rowvector
local RV	real vector
local RM	real matrix
local TM	transmorphic matrix
local TS	transmorphic scalar
local TR	transmorphic rowvector
local TC	transmorphic colvector


local Tabcharname AsArray_char
local Tabchar	struct `Tabcharname' scalar

local AAtopname  AsArray_top
local AAdupname  AsArray_dup
local AAtop	 struct `AAtopname' scalar
local AAdup	 struct `AAdupname' scalar

local DAction	`RS'
local 		DA_notfound		0
local		DA_notake		1
local		DA_take1		2
local		DA_take0		3

local Key	`TR'
local Keys	`TM'
local Con	`TM'		// Con means Contents
local Conptr	`PS'		// Content pointer 
local Conptrs	`PR'

local Location	transmorphic

local boolean	`RS'
local		true	1
local		false	0

local Status	`RS'
local StatusR	`RR'
local 		S_empty		0
local		S_single	1
local		S_dup		2

mata:
mata set matastrict on

// Tabchar hold table AAtop table characteristics
struct `Tabcharname' 
{
	`RS'		minsize			// minsize of table, as spec.
	`RS'		maxratio			
	`RS'		minratio
	`RS'		dupsize			// size for AAdup tables
	`RS'		castup			// # cast ups
	`RS'		castdown		// # cast downs
	`RS'		truminsize		// minsize of table, true
	`Con'		notfound		// not found contents value
	`Key'		nullkey			// Key scalar, used like NULL
}

// AAtop holds the associative table:
struct `AAtopname'
{
	`Tabchar'	t			// table characteristics
	`RS'		N			// # in table
	`StatusR'	status			//  cell status
	`Keys'		key			//  cell key
	`Conptrs'	p			//  cell contents
}
// current size of table is obtained via length(p)
// when status[i]==`S_single', p[i] points to the user contents
// when status[i]==`S_dup',    p[i] points to an AAdup table
// when status[i]==`S_empty',  p[i] = NULL

struct `AAdupname'
{
	`RS'		n			// currently filled in
	`Keys'		key			//  cell key
	`Conptrs'	p			//  cell contents
}
// current size of table is via length(key)
// if p[i]!=NULL, then cell i is filled; key[i] is key, p[i] points to 
// contents.  Alternatively, you may also depend on p[i]!=NULL
// iff 1 <= i <= n.

						/* End Definitions	*/
/* -------------------------------------------------------------------- */

	

/* -------------------------------------------------------------------- */
					/* Top-level routines		*/

/*                _
	(`AStop') A = asarray_create([...])
				      ---
		user interface into asarray_create_u()
*/

`AAtop' asarray_create(
		       |`SS' keytype, 		// 1
			`RS' keydim, 		// 2
			`RS' minsize,		// 3
			`RS' minratio, 		// 4
			`RS' maxratio)		// 5
{
	`Tabchar'	t
	`TS'		keyscalar
	`RS'		keywidth

	if (args()>=1) {
		if      (keytype=="string") 	keyscalar = ""
		else if (keytype=="real")	keyscalar = .
		else if (keytype=="complex")	keyscalar = C(.)
		else if (keytype=="pointer")	keyscalar = NULL
		else 				_error(3250)
	}
	else					keyscalar = ""

	if (args()>=2) {
		keywidth = floor(keydim) 
		if (keydim<1 | keydim>50) 	_error(3250)
	}
	else	keywidth = 1
				

	t.minsize  = `DEFAULT_minsize'
	t.minratio = `DEFAULT_minratio'
	t.maxratio = `DEFAULT_maxratio'

	t.dupsize  = `DEFAULT_dupsize'
	t.castup   = 0
	t.castdown = 0
	t.notfound = `DEFAULT_NOTFOUND'
	t.nullkey  = J(1, keywidth, keyscalar)

	if (args()>=3) { 
		if (minsize>=`MIN_minsize' & minsize<=`MAX_minsize') {
			t.minsize = minsize
		}
	}

	if (args()>=4) {
		if (minratio>=0 & minratio<=1) {
			t.minratio = minratio
		}
	}

	if (args()>=5) {
						// . okay
		if (maxratio > 1) t.maxratio = maxratio
	}

	return(asarray_create_u(t, 0)) 
}


/*				        _
	(void)         asarray_notfound(A, notfound)
				        -  --------

	(transmorphic) asarray_notfound(A)
				        -

		Set or return notfound value
*/

transmorphic asarray_notfound(`AAtop' A, |`Con' notfound)
{
	if (args()==1) return(A.t.notfound)
	A.t.notfound = notfound
}




/*
	(`boolean') asarray_contains(A, key)
				     -  ---

		Return 1 if key exists in A, else return 0
*/

`boolean' asarray_contains(`AAtop' A, `Key' key)
{
	`RS'		h
	`Status'	s

	if ( (s = A.status[h = hash1(key, length(A.p))]) ) {
		if (s==`S_dup') return(asarray_contains_dup(*(A.p[h]), key))
		if (key==A.key[h,.]) return(1)
	}
	return(0) 
}




/*				 _
	(void) 		 asarray(A, key, contents)
				 -  ---  --------

	(transmorphic)  asarray(A, key)
			        -  ---

		insert (replace) key = contents into A and consider 
		resizing A,
		or
		return contents associated with key in A.
*/

`Con' asarray(`AAtop' A, `Key' key, |`Con' usert)
{
	`RS'		h
	`RS'		add
	`Conptr'	p
	`Status'	s
	`Con'	t

	s = A.status[h = hash1(key, length(A.p))]

	/* ------------------------------------------------------------ */
	if (args()==2) { 				/* GET		*/
		if (s) {
			p = A.p[h]
			if (s==`S_dup') return(asarray_get_dup(*p, key, A))
			if (key==A.key[h,.]) return(*p)
		}
		return(A.t.notfound)
	}
			
	/* ------------------------------------------------------------ */
							/* PUT		*/
	t = usert
	if (s) {
		if (s==`S_dup') {
			add = asarray_put_dup(*(A.p[h]), key, &t, A)
		}
		else if (key==A.key[h,.]) {
			A.p[h] = &t
			add    = 0
			// replace, so do not increment A.N
		}
		else {
			asarray_makedup_(A, h) 
			add = asarray_put_dup(*(A.p[h]), key, &t, A)
		}
	}
	else {
		A.key[h,.]  = key 
		A.p[h]      = &t
		A.status[h] = `S_single'
		add         = 1
		(void)        ++A.N
	}
	if (add) {
		if (A.N/length(A.p) > A.t.maxratio) asarray_rebuild(A, 1)
	}
}




/*			       _
	(void) asarray_put_ptr(A, key, p)
			       -  ---  -

	insert (replace) key = *p into table. No copy is made, 
	p itself is stored. Used during table rebuild.  A is 
	never resized.
*/

`static' void asarray_put_ptr(`AAtop' A, `Key' key, `Conptr' p)
{
	`RS'		h
	`Status'	s

	s = A.status[h = hash1(key, length(A.p))]
	if (s) {
		if (s==`S_dup') {
			(void) asarray_put_dup(*(A.p[h]), key, p, A)
		}
		else if (key==A.key[h,.]) {
			A.p[h] = p
			// replace, so do not increment A.N
		}
		else {
			asarray_makedup_(A, h) 
			(void) asarray_put_dup(*(A.p[h]), key, p, A)
		}
	}
	else {
		A.key[h,.]  = key 
		A.p[h]      = p
		A.status[h] = `S_single'
		(void)        ++A.N
	}
}




/*			      _
	(void) asarray_remove(A, key)
			      -  ---

		Remove key from A if it exists, or do nothing.
		A might be resized.
*/

void asarray_remove(`AAtop' A, `Key' key)
{
	`RS'				h
	`Status'			s
	`DAction'			act
	pointer(`AAdup') scalar	d
	

	h = hash1(key, length(A.p))
	s = A.status[h]

	act = `DA_notfound'
	if (s) { 
		if (s==`S_dup') { 
			act = array_remove_dup(*(A.p[h]), key, A)
			if (act==`DA_take1') {
				d           = A.p[h]
				A.key[h,.]  = d->key[1,.]
				A.p[h]      = d->p[1]
				d           = NULL
				A.status[h] = `S_single'
			}
			else if (act==`DA_take0') { 
				A.key[h,.]  = A.t.nullkey
				A.p[h]      = NULL
				A.status[h] = `S_empty'
			}
		}
		else {
			if (key==A.key[h,.]) { 
				act         = `DA_notake'
				A.key[h,.]  = A.t.nullkey
				A.p[h]      = NULL
				A.status[h] = `S_empty'
				(void)        --A.N
			}
		}
	}
	
	if (act) {		// then consider resizing
		if (length(A.p)>A.t.truminsize) {
			if (`MULTIPLIER'*A.N/length(A.p)<A.t.minratio) {
				asarray_rebuild(A, 0)
			}
		}
	}
}
					/* End Top-level routines	*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* entry traversal routines	*/

/*	           _
	(Location) L = asarray_first(A)
				     -

		Returns location L of first entry in A.
		A location is real 1x2 (i,j), i index in A, 
		j=0 if `S_single', otherwise j index in D.

		L is set to (pointer scalar) NULL when no more 
		entries.
*/

`Location' asarray_first(`AAtop' A)
{
	`RS'	i

	for (i=1; i<=length(A.p); i++) { 
		if (A.status[i]) return((i, A.status[i]==`S_dup'))
	}
	return(NULL)
}




/*
	(`Key') asarray_key(A, L)
			    -  -
		Return key of location L of A.
*/

`Key' asarray_key(`AAtop' A, `Location' L)
{
	`RS'				i, j
	pointer(`AAdup') scalar		d

	if (L==NULL) return(A.t.nullkey)

	i = L[1]
	if ((j=L[2])==0) return(A.key[i,.])
	d = A.p[i]
	return(d->key[j,.])
}




/*
	(`Con') asarray_contents(A, L)
				 -  -
		Return contents of location L of A
*/

`Con' asarray_contents(`AAtop' A, `Location' L) 
{
	return(*asarray_ptr(A, L))
}




/*
	(`Conptr') asarray_ptr(A, L)
			       -  -
		Return pointer to contents of location L of A
*/

`static' `Conptr' asarray_ptr(`AAtop' A, `Location' L)
{
	`RS'				i, j
	pointer(`AAdup') scalar		d

	if (L==NULL) return(NULL)

	i = L[1]
	if ((j=L[2])==0) return(A.p[i])
	d = A.p[i]
	return(d->p[j])
}




/*
	(Location) asarray_next(A, L)
				-  -
		Return next location of A, or return NULL
*/
	
transmorphic asarray_next(`AAtop' A, `Location' L)
{
	`RS'				i, j 
	pointer(`AAdup') scalar		d
	
	if (L==NULL) return(NULL)

	i = L[1]
	j = L[2]
	if (j) { 
		d    = A.p[i]
		if (j < d->n) return((i, j+1))
	}

	while ((++i) <= length(A.p)) {
		if (A.status[i]) return((i, A.status[i]==`S_dup'))
	}
	return(NULL)
}





/*
	`Keys' asarray_keys(A)
			    -
		return keys stored in A
*/

`Keys' asarray_keys(`AAtop' A)
{
	`RS'	i, j
	`Keys'	res

	res = J(A.N, 1, A.t.nullkey)
	for (i=j=1; i<=length(A.p); i++) { 
		if (A.status[i]) { 
			if (A.status[i]==`S_dup') {
				asarray_keys_dup(res, j, *(A.p[i]))
			}
			else 	res[j++,.] = A.key[i,.]
		}
	}
	return(res)
}

					/* End entry traversal routines	*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
				/* Duplicate handling routines		*/

/*				_
	(void) asarray_makedup_(A, h)
				-  -
		(A.key[h], A.p[h]) contain an `S_single' entry.
		convert it to be a 1-entry dup entry.
*/

`static' void asarray_makedup_(`AAtop' A, `RS' h)
{
	`AAdup'	D

	D           = asarray_create_dup(A.t.dupsize, A.t)
	D.n         = 1
	D.key[1,.]  = A.key[h,.]
	D.p[1]      = A.p[h]

	A.key[h,.]  = A.t.nullkey
	A.p[h]      = &D
	A.status[h] = `S_dup'
}



/*                _
	(`AAdup') D = asarray_create_dup(n, t)
					 -  -
		create duplicate table of size n.
		duplicate table will expand in increments of n as needed
*/

`static' `AAdup' asarray_create_dup(`RS' n, `Tabchar' t)
{
	`AAdup'	D

	D.n       = 0 
	D.key     = J(n, 1, t.nullkey)
	D.p       = J(1, n, NULL)
	return(D)
}



/*
	(`boolean') asarray_contains_dup(D, key)
					 -  ---
	Return 1 if key exists in D, else return 0.
*/
	
`static' `boolean' asarray_contains_dup(`AAdup' D, `Key' key)
{
	`RS'	i

	for (i=1; i<=D.n; i++) { 
		if (D.p[i]) { 
			if (key==D.key[i,.]) return(1)
		}
	}
	return(0)
}



/*
	(`Con') asarray_get_dup(D, key, A)
				-  ---  -
		return contents associated with key from D, or 
		return A.t.notfound
*/

`static' `Con' asarray_get_dup(`AAdup' D, `Key' key, `AAtop' A)
{
	`RS'	i

	for (i=1; i<=D.n; i++) { 
		if (D.p[i]) { 
			if (key==D.key[i,.]) return(*(D.p[i]))
		}
	}
	return(A.t.notfound)
}




/*				     _		_
	`RS' added = asarray_put_dup(D, key, p, A)
				     -  ---  -  -

		insert (replace) key = *p into D. Increment A.N if insert, 
		leave A.N unchanged if replace. Return 1 if insert, 0 if 
		replace. Expand D if necessary.
*/

`static' `RS' asarray_put_dup(`AAdup' D, `Key' key, `Conptr' p, `AAtop' A)
{
	`RS'	i

					/* check if replace	*/
	for (i=1; i<=D.n; i++) { 
		if (D.p[i]) { 
			if (key==D.key[i,.]) { 
				D.p[i] = p
				return(0)
			}
		}
	}

					/* new			*/
	if (D.n == length(D.p)) { 
		asarray_expand_dup(D, A.t)
	}

	(void) ++(D.n)
	(void) ++(A.N)
	D.key[D.n,.]  = key 
	D.p[D.n]      = p
	return(1)
}



/*				  _
	(void) asarray_expand_dup(D, t)
				  -  -
		Expand D by t.dupsize
*/

`static' void asarray_expand_dup(`AAdup' D, `Tabchar' t)
{
	`RV'		r1
	`RM'		r2
	`AAdup'		D2


	D2 = asarray_create_dup(length(D.p) + t.dupsize, t) 

	r1           = (1\length(D.p))
	r2	     = (1,1 \ rows(D.key),cols(D.key))

	D2.n         = D.n
	D2.key[|r2|] = D.key
	D2.p[|r1|]   = D.p 
	swap(D, D2)
}



/*		    ____		    _       _
	(`DAction') code = array_remove_dup(D, key, A)
					    -  ---  -
		Remove key from D if it exists, else do nothing.
		If key exists, A.N decremented.
		Returns code, 
			DA_notake   removed; table has >1 entries left
			DA_take1    removed; table has 1  entry   left 
			DA_toke0    removed; table has 0  entries left
			DA_notfound not found, nothing done
*/

`DAction' array_remove_dup(`AAdup' D, `Key' key, `AAtop' A)
{
	`RS'	i

	for (i=1; i<=D.n; i++) { 
		if (D.p[i]) { 
			if (key==D.key[i,.]) { 
				if (i==D.n) {
					D.key[i,.]   = A.t.nullkey
					D.p[i]     = NULL
				}
				else {
					D.key[i,.]    = D.key[D.n,.]
					D.p[i]      = D.p[D.n] 
					D.key[D.n,.]  = A.t.nullkey
					D.p[D.n]    = NULL
				}
				(void) --(D.n)
				(void) --(A.N)
				return(D.n>1 ? 
					`DA_notake' :
					(D.n ? `DA_take1' : `DA_take0'))
			}
		}
	}
	return(`DA_notfound') 
}



/*			        ___  _
	(void) asarray_keys_dup(res, j, D)
				---  -  -
		add keys stored in D to res[j], res[j+1], ..., and 
		update j.
*/

`static' void asarray_keys_dup(`Keys' res, `RS' j, `AAdup' D)
{
	`RS'	i

	for (i=1; i<=length(D.p); i++) { 
		if (D.p[i]) res[j++,.] = D.key[i,.]
	}
}




/*
	`RS' asarray_count_dup(D)
			       -
		Return # of elements stored in D
*/

`static' `RS' asarray_count_dup(`AAdup' D) return(D.n)


				/* End Duplicate handling routines	*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
					/* Utility routines		*/

/*                _
	(`AAtop') A = asarray_create_u(t, actualsize)
				       -  ----------
		Create associative array given the specifications t.
		actualsize is not taken seriously; 
		if actualsize < minsize, minsize is used.
		actualsize is in actual # of entries units.
		This routine multiplies actualsize to allow extra cells
*/

`static' `AAtop' asarray_create_u(`Tabchar' t, `RS' user_actualsize)
{
	`AAtop'	A
	`RS'	actualsize

	actualsize   = (user_actualsize<t.minsize ? t.minsize : user_actualsize)
	actualsize   = trunc(`MULTIPLIER'*actualsize)

	A.t.dupsize    = t.dupsize
	A.t.notfound   = t.notfound
	A.t.nullkey    = t.nullkey
	A.t.minsize    = t.minsize
	A.t.truminsize = trunc(t.minsize*`MULTIPLIER')
	A.t.minratio   = t.minratio
	A.t.maxratio   = t.maxratio
	A.t.castup     = t.castup
	A.t.castdown   = t.castdown

	A.N            = 0
	A.status       = J(1, actualsize, `S_empty')
	A.key          = J(actualsize, 1, t.nullkey)
	A.p            = J(1, actualsize, NULL)

	return(A)
}



/*			       _
	(void) asarray_rebuild(A, castup)
			       -  ------

		Rebuild table A based on current A.N.  
                Set castup=1 if table being made bigger, castup=0 if table
                being made smaller.  asarray_rebuild() could figure out castup
                for itself, but given how it is used, it is easier to just
                pass castup in.
*/

`static' void asarray_rebuild(`AAtop' A, `boolean' castup)
{
	`AAtop'		B
	`Location'	L

	// printf("REBUILD %g %g\n", (castup ? A.castup : A.castdown), castup)

	B = asarray_create_u(A.t, A.N)

	if (castup) (void) ++(B.t.castup)
	else        (void) ++(B.t.castdown)

	for (L = asarray_first(A); L!=NULL; L = asarray_next(A, L)) {
		asarray_put_ptr(B, asarray_key(A, L), asarray_ptr(A, L))
	}
	swap(A, B)
}


/*
	`RS' asarray_size(A)
			  -
		return current size (dimension) of A
*/

`RS' asarray_size(`AAtop' A) return(length(A.p))


/*
	`RS' asarray_elements(A)
			      -
		return number of elements stored in A
*/

`RS' asarray_elements(`AAtop' A) return(A.N)


					/* End Utility routines		*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
					/* Debugging tools		*/


/*
	`RR'	asarray_stats(A)
			      -
		return statistics about A
*/

real rowvector asarray_stats(`AAtop' A)
{
	`RS'	i, n
	`RS'	single, dup, used, empty
	`RS'	maxdepth, mindepth, sumdepth, avgdepth
	`RR'	toret

	pointer(`AAdup') scalar	d
      
	/* ------------------------------------------------------------ */
	single = used = 0 
	for (i=1; i<=length(A.p); i++) {
		if (A.status[i]) { 
			used++
			if (A.status[i]==`S_single') single++
		}
	}
	dup = used - single
	empty = length(A.p) - used

	mindepth = .
	maxdepth = sumdepth = 0
	for (i=1; i<=length(A.p); i++) { 
		if (A.status[i]==`S_dup') { 
			d = A.p[i]
			n = d->n 
			if (mindepth>n) mindepth = n 
			if (maxdepth<n) maxdepth = n 
			sumdepth = sumdepth + n
		}
	}
	avgdepth = sumdepth/dup
	/* ------------------------------------------------------------ */

	toret = J(1, 14, .)

	toret[ 1] = A.N			// items stored

	toret[ 2] = single		// single slots 
	toret[ 3] = dup			// dup slots
	toret[ 4] = used		// used slots  [2]+3]=[4] 
	toret[ 5] = empty		// empty slots
	toret[ 6] = length(A.p)		// total slots [4]+[5]=[6]

	toret[ 7] = mindepth		// min depth of [3] pools
	toret[ 8] = avgdepth		// avg depth of [3] pools
	toret[ 9] = maxdepth		// max depth of [3] pools

	toret[10] = A.t.truminsize	// minimum size cf. [2]
	toret[11] = A.t.minratio	// minratio
	toret[12] = A.t.maxratio	// maxratio
	toret[13] = A.t.castup 		// castup 
	toret[14] = A.t.castdown	// castdown

	return(toret)
}

/*
	(void) asarray_report(A)
			      -
		Display statistics about A
*/

void asarray_report(`AAtop' A)
{
	`RR'	res
	`RS'	N
	`RS'	single, dup, used, empty, N_slots
	`RS'	maxdepth, mindepth, avgdepth
	`RS'	minsize, minratio, maxratio, castup, castdown

	res = asarray_stats(A)

	N        = res[ 1]
	single   = res[ 2]
	dup      = res[ 3]
	used     = res[ 4]
	empty    = res[ 5] 
	N_slots  = res[ 6]
	mindepth = res[ 7]
	avgdepth = res[ 8]
	maxdepth = res[ 9]
	minsize  = res[10]
	minratio = res[11]
	maxratio = res[12]
	castup   = res[13]
	castdown = res[14]

	printf("{txt}\n")
	printf("{col 9} 1. items stored{col 26}{res:%13.0gc}\n", N)
	printf("\n")

	printf("{col 9} 2. single slots{col 26}{res:%13.0gc}\n", single)
	printf("{col 9} 3. dup slots{col 26}{res:%13.0gc}\n", dup)
	printf("{col 9}{hline 30}\n")
	printf(
	    "{col 9} 4. used slots{col 26}{res:%13.0gc}     (4) = (2)+(3)\n",
				used)
	printf("{col 9} 5. empty slots{col 26}{res:%13.0gc}\n", empty)
	printf("{col 9}{hline 30}\n")
	printf(
	    "{col 9} 6. total slots{col 26}{res:%13.0gc}     (6) = (4)+(5)\n",
				N_slots)

	printf("\n")
	printf("{col 9} 7. min depth{col 26}{res:%13.0gc}\n", mindepth)
	printf("{col 9} 8. avg depth{col 26}{res:%16.2fc}\n", avgdepth)
	printf("{col 9} 9. max depth{col 26}{res:%13.0gc}\n", maxdepth)

	printf("\n")
	printf("{col 9}10. min size{col 26}{res:%13.0gc}     cf. (2)\n",
				minsize)
	printf("{col 9}11. min ratio{col 26}{res:%16.2fc}\n", minratio)
	printf("{col 9}12. max ratio{col 26}{res:%16.2fc}\n", maxratio)
	printf("{col 9}13. # cast up{col 26}{res:%13.0gc}\n", castup)
	printf("{col 9}14. # cast down{col 26}{res:%13.0gc}\n", castdown)
}




/*
	(void) asarray_dump(A)
			    -
		Dump table
*/

void asarray_dump(`AAtop' A)
{
	`RS' 	i

	printf(" n=%f  N=%f  dupsize=%f\n", 0, length(A.p), A.t.dupsize)

	for (i=1; i<=length(A.p); i++) {
		if (A.p[i]) { 
			printf("%4.0f. status=%f |%s|{col 30}", 
				i, A.status[i], A.key[i,1])
			A.p[i]
			if (A.status[i]==`S_dup') asarray_dump_dup(*(A.p[i]))
		}
	}
}

/*
	(void) asarray_dump_dup(D)
				-
		Dump a duplicate table
*/

`static' void asarray_dump_dup(`AAdup' D)
{
	`RS'	i

	printf("     n = %f   N=%f\n", D.n, length(D.p))
	for (i=1; i<=length(D.p); i++) {
		if (D.p[i]) {
			printf("     %4.0f.        |%s|{col 30}", 
				i, D.key[i,1])
			D.p[i]
		}
	}
}


/*
	(void) asarray_elements_test(A)
				     -

		test routine. Verifies that asarray_elements() is 
		correct (that we are adding and subtracting to A.N 
		throughout this code correctly). Aborts if error.
*/

void asarray_elements_test(`AAtop' A)
{
	`RS'	N, i

	N = 0 
	for (i=1; i<=length(A.p); i++) { 
		if (A.status[i]) {
			if (A.status[i]==`S_dup') {
				N = N + asarray_count_dup(*(A.p[i]))
			}
			else 	N++
		}
	}
	if (N != A.N) {
		printf("asarray error: N=%g A.N=%g\n", N, A.N)
		exit(9)
	}
}
						/* End Debugging tools	*/
/* -------------------------------------------------------------------- */

end
