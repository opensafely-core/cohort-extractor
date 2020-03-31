*! version 1.0.3  10dec2014
version 9.0

mata:

/* (input) todo
   todo == 0 implies eigenvalues only
   todo == 1 implies eigenvalues and right eigenvectors
   todo == 2 implies eigenvalues and left  eigenvectors

   (input) A 
   A is matrix to be decomposed, A is destroyed in process of making
   calculation

   (output) evals
   	evals is complex rowvector containing eigenvalues

   (output) evecs
   	if todo==1 or todo==2, evecs is complex matrix containing
	eigenvectors.

   (input/output) cond
   	on input cond is a real scalar:
		  cond==0 and cond==. imply do not compute condition number
		  of eigenvalues;
		  otherwise condition numbers of eigenvalues are computed and
		  are returned in real rowvector cond
   (input) nobalance
	nobalance==. | nobalance==0 means balance; else do not
*/ 

void  _eigen_work(real scalar todo, numeric matrix A, evecs, evals, 
                  real scalar cond, real scalar nobalance)
{
	real scalar    dima, docond, i
	real colvector p
	numeric matrix tosort
	
	dima   = cols(A)
	docond = (cond!=0 & cond<.)

	/* ------------------------------------------------------------ */
	if (_eigen_la(todo, A, evecs, evals, cond, nobalance)) {
		evals = J(dima,1,C(.))
		if (todo==1 | todo==2) {
			evecs = .		// clear memory
			evecs = J(dima,dima,C(.))
		}
		if (docond)  {
			cond = (todo==2 ? J(   1, dima, C(.)) :
					  J(dima,    1, C(.)) )
		}
		return
	}
	if (dima==0) return
	/* ------------------------------------------------------------ */

	if (todo!=2) _transposeonly(evals)
	p = order(tosort = (evals, quadrant(evals)), (-1, -2 ))

	if (todo) {
		_collate(tosort, p)
		for (i=2; i<=dima; i++) {
			if (tosort[i-1,.]==tosort[i,.]) {
				p = order(
				(evals,quadrant(evals),Re(evecs),Im(evecs)), 
					-(1..(2+2*dima))
				)
				break
			}
		}
	}
	tosort = .

	_collate(evals,p)
	if (todo!=2) _transposeonly(evals)

	if (todo==1) 		evecs = evecs[.,p]
	else if (todo==2) 	evecs = evecs[p,.]
	/* ------------------------------------------------------------ */

	if (docond) {
		if (todo==2) {
			_collate(cond,p)
		}
		else {
			_transpose(cond)
			_collate(cond,p)
			_transpose(cond)
		}
	}	

}

end
