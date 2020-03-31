*! version 1.0.0  15jan2018
version 16.0

/*
	Usage:

	S = cvsubsetsetup(n)

	while ((x = cvsubset(S)) != J(0, 1, .)) {

		// do stuff with x column vector dim n
		// with 0's and 1's indicating set membership
	}

	Example with n = 3. x' steps through the following 8 values:

		0   0   0  <- empty set always first
		1   0   0
		1   1   0
		0   1   0
		0   1   1
		1   1   1  <- all elements always somewhere in middle
		1   0   1
		0   0   1  <- 0 0 ... 0 1 always last

	Or

	S = cvsubsetsetup(n)

	// handle empty set case

	while (_cvsubsetflip(S, element, membership)) {

		// element    = element-th element flipped
		// membership = bit indicating element membership, 0 or 1
	}

	Example with n = 3. Steps through 7 values:

	  element  membership
	  -------  ----------
		1           1
		2           1
		1           0
		3           1
		1           1
		2           0
		1           0

	The first usage steps through all 2^n subsets.
	The second usage steps through all 2^n - 1 changes
	starting with the empty set.
*/

mata:

struct _cvsubsetinfo {
	real scalar     i
	real scalar     state    //
	real colvector  x
}

struct _cvsubsetinfo scalar cvsubsetsetup(real scalar n)
{
	real                 scalar  nn
	struct _cvsubsetinfo scalar  info

	nn = trunc(n)

	if (nn <= 0) {
		_error("vector length must be greater than zero")
	}

	info.x     =  J(n, 1, 0)
	info.i     =  0
	info.state = -1

	return(info)
}

real colvector cvsubset(struct _cvsubsetinfo scalar info)
{
	real colvector result

	_cvsubset_next(info)

	if (info.state == -2) { // done or error
		return(J(0, 1, .))
	}

	result = info.x

	return(result)
}

real scalar _cvsubsetflip(  struct _cvsubsetinfo scalar info,
			    real scalar element,
			  | real scalar membership)
{
	if (info.state == -1) { // first call
		info.state = 0
	}

	_cvsubset_next(info)

	if (info.state == -2) { // done or error
		element    = .
		membership = .
		return(0)
	}

	element    = info.i
	membership = info.x[element]

	return(1)
}

// local function

void _cvsubset_next(struct _cvsubsetinfo scalar info)
{
	real scalar  i, n

	n = rows(info.x)

	if (info.state == -1) { // first call
		info.state = 0
		return
	}

	if ((info.state == 1 & info.x[n] == 1) | info.state == -2) { // done
		info.state = -2
		return
	}

	i = 1

	if (mod(info.state, 2)) {
		for (; i <= n; i++) {
			if (info.x[i]) {
				++i
				break
			}
		}
	}

	info.i     = i
	info.x[i]  = !info.x[i]
	info.state = info.state + 2*info.x[i] - 1
}

end


