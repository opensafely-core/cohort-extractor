*! version 1.0.0  15jan2018
version 16.0

/*
	Usage:

	S = cvcombsetup(N, n)

	while ((x = cvcomb(S)) != J(0, 1, .)) {

		// do stuff with x
	}

	Example with S = cvcombsetup(5, 3).

	x' steps through the following C(5, 3) = 10 values:

		1   1   1   0   0  <- always in ascending order when viewed
		1   1   0   1   0     as bits of an integer in reverse order
		1   0   1   1   0
		0   1   1   1   0
		1   1   0   0   1
		1   0   1   0   1
		0   1   1   0   1
		1   0   0   1   1
		0   1   0   1   1
		0   0   1   1   1
*/

mata:

struct _cvcombinfo {
	real scalar     N
	real scalar     n
	real scalar     state
	real colvector  x
}

struct _cvcombinfo scalar cvcombsetup(real scalar N, real scalar n)
{
	real               scalar  NN, nn
	struct _cvcombinfo scalar  info

	NN = trunc(N)
	nn = trunc(n)

	if (NN <= 0) {
		_error("vector length must be greater than zero")
	}

	if (nn < 0) {
		_error("group size must be positive")
	}

	if (nn > NN) {
		_error("group size cannot be greater than vector length")
	}

	info.N     = NN
	info.n     = nn
	info.state = -1
	info.x     = J(NN, 1, 0)

	return(info)
}

real colvector cvcomb(struct _cvcombinfo scalar info)
{
	real scalar     i, m
	real colvector  result

	if (info.state == 0) { // done
		return(J(0, 1, .))
	}

	if (info.state == -1) { // first call

		info.x = J(info.n, 1, 1) \ J(info.N - info.n, 1, 0)

		if (info.n == 0) {
			info.state = 0
		}
		else {
			info.state = 1
		}

		return(result = info.x)
	}

	if (info.x[1] == 0) {

		for (i = 2; i < info.N; i++) {
			if (info.x[i + 1] == 0 & info.x[i] == 1) {

				info.x[i + 1] = 1

				m = sum(info.x[|1\(i-1)|])

				info.x = J(m, 1, 1) \
				         J(i - m, 1, 0) \
				         info.x[|(i + 1)\info.N|]

				break
			}
		}

		if (i == info.N) {
			info.state = 0
			return(J(0, 1, .))
		}
	}
	else { // info.x[1] == 1
		for (i = 2; i <= info.N; i++) {
			if (info.x[i] == 0) {
				info.x[i - 1] = 0
				info.x[i]     = 1
				break
			}
		}

		if (i == info.N + 1) {
			info.state = 0
			return(J(0, 1, .))
		}
	}

	result = info.x

	return(result)
}

end

