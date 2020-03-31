*! version 1.2.0  20feb2018
program _marg_dydx_ccompute
	version 11
	syntax anything(name=o id="name") [fw pw iw aw/] [if/] [in],	///
		xvar(varname) [alternative(string asis) *]
	mata: st__marg_dydx_compute(`.`o'.h', `.`o'.scale')
	.`o'.h = r(h)
	.`o'.scale = r(scale)
end
