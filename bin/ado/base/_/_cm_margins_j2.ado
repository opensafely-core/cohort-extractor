*! version 1.0.0  09sep2019

program _cm_margins_j2, rclass
	version 16
	syntax anything(name=o id="name") [iw], depvar(varname) [ * ]

	tempvar d
	.`o'._margins_predict `d', depvar(`depvar') `options'

	summarize `d' [`weight'`exp'] if `depvar', meanonly
	return scalar b = r(sum)
	return scalar sumw = r(sumw)
	return scalar N = r(N)
end

exit
