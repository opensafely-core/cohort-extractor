*! version 1.0.0  08aug2006

program define asclogit_lf
	version 10
	args todo b lnf g negH  

	.$CLOGIT_model.evaluate, lnf(`lnf') b(`b') todo(`todo') g(`g') ///
		h(`negH')
end

exit

