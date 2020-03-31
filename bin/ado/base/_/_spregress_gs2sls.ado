*! version 1.0.3  28mar2017
program _spregress_gs2sls, eclass
	version 15.0

	cap noi _spivreg `0'
	if (_rc) exit _rc
	
	eret local estat_cmd spregress_estat
	eret local predict spregress_p
	eret local cmdline spregress `0'
	eret local estimator gs2sls
	eret local marginsok RForm xb direct indirect
	eret local marginsnotok LImited FULL NAive
	eret local cmd spregress
end
