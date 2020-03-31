*! version 1.0.1  07jun2019
program lassocoef
	version 16.0

	syntax [anything(name=est_list)] [, *]

	estimates selected `est_list' , `options' lassocoef
end
