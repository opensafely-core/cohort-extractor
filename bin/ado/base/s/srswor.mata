*! version 1.0.0  22aug2017
version 15.0

local N_CUTPOINT_1    1000
local N_CUTPOINT_2   10000
local N_CUTPOINT_3  100000
local n_CUTPOINT_2      50
local n_CUTPOINT_3    1000

local USE_PICK         0.9
local EXTRA              2
local MAX_EXTRA         10

mata:

/*
    srswor(real vector x, real scalar n)

	returns a simple random sample without replacement of size n
	from x where n <= N = length(x)

   Calls	            N <= 1000       1,000 < N <= 10,000
		     |--------------------|---------------------|
		     | n < N/2 | n >= N/2 | n <= 50 |  n > 50   |
		     |---------|----------|---------|-----------|
                     |         |          |         |           |
   srswor_jumble()   |         |    X     |         |           |
                     |         |          |         |           |
   srswor_pick()     |    X    |          |         |     X     |
                     |         |          |         |           |
   srswor_collate()  |         |          |    X    |           |
                     |------------------------------------------|

		         10,000 < N <= 100,000    N > 100,000
		     |------------------------|-----------------|
		     | n <= 1,000 | n > 1,000 | small n | big n |
		     |------------|-----------|---------|-------|
                     |            |           |         |       |
   srswor_jumble()   |            |           |         |       |
                     |            |           |         |       |
   srswor_pick()     |            |     X     |         |   X   |
                     |            |           |         |       |
   srswor_collate()  |      X     |           |    X    |       |
                     |------------------------------------------|
*/

real vector srswor(real vector x, real scalar n)
{
	real scalar  N, time_collate, time_pick

	N = length(x)

	if (N <= `N_CUTPOINT_1') {

		if (n < N/2) {
			return(srswor_pick(x, n))
		}

		return(srswor_jumble(x, n))
	}

	if (N <= `N_CUTPOINT_2') {

		if (n <= `n_CUTPOINT_2')  {
			return(srswor_collate(x, n))
		}

		return(srswor_pick(x, n))
	}

	if (n <= `n_CUTPOINT_3') {
		return(srswor_collate(x, n))
	}

	if (N <= `N_CUTPOINT_3') {
		return(srswor_pick(x, n))
	}

	time_collate = (-5.38e-07)*n + (1.36e-07)*n*log(n)
	time_pick    = ( 3.98e-07)*n + (2.00e-10)*N*log(N)

	if (time_collate < time_pick) {
		return(srswor_collate(x, n))
	}

	return(srswor_pick(x, n))
}

real vector srswor_collate(real vector x, real scalar n)
{
	real scalar     extra, N, size
	real colvector  index, sel
	real matrix     X

	N = length(x)

	if (n > N | n <= 0) {
		return(orgtype(x) == "colvector" ? J(0, 1, .) : J(1, 0, .))
	}

	// When n is close to or equal to N, this method becomes inefficient.

	if (n > `USE_PICK'*N) { // only possible if function called directly
		return(srswor_pick(x, n))
	}

	for (extra = `EXTRA'; extra <= `MAX_EXTRA'; ++extra) {

		// Pick extra elements to make up for duplicates.

		size = extra*n

		X = (runiformint(size, 1, 1, N), (1::size))

		// Use a sort to remove duplicates, keeping first occurrence.

		index = order(X, (1, 2))

		X = X[., 1]

		_collate(X, index)

		index = invorder(index)

		// Flag duplicates.

		sel = selectindex((X[|2 \ .|] :== X[|1 \ (size - 1)|])) :+ 1

		// Set duplicates to missing.

		X[sel] = J(rows(sel), 1, .)

		// Restore to original ordering.

		_collate(X, index)

		// Remove duplicates.

		sel = select(X, X :!= .)

		if (length(sel) >= n) {
			break
		}
	}

	if (length(sel) < n) { // next to impossible
		_error("method failed to select sample")
	}

	return(x[sel[|1\n|]])
}

real vector srswor_pick(real vector x, real scalar n)
{
	real scalar  i, k, N
	real vector  el, pick

	N = length(x)

	if (n > N | n <= 0) {
		return(orgtype(x) == "colvector" ? J(0, 1, .) : J(1, 0, .))
	}

	el = (1::N)

	pick = runiformint(1, 1, 1, N::(N - n + 1))

	for (i = 1; i <= n; ++i) {

		k = pick[i]

		pick[i] = x[el[k]]

		el[k] = el[N - i + 1]
	}

	if (orgtype(x) == "colvector") {
		return(pick)
	}

	return(pick')
}

real vector srswor_jumble(real vector x, real scalar n)
{
	if (n > length(x) | n <= 0) {
		return(orgtype(x) == "colvector" ? J(0, 1, .) : J(1, 0, .))
	}

	if (orgtype(x) == "colvector") {
		return(jumble(x)[|1\n|])
	}

	return(jumble(x')[|1\n|]')
}

end

