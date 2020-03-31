*! version 1.1.0  15jul2014
program _marg_compute
	version 11
	syntax anything(name=o id="name") [fw pw iw aw] [if] [in] [, *]
	.`o'.compute `if' `in' [`weight'`exp'], `options'
end
exit
