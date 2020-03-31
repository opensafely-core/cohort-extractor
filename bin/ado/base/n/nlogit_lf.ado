*! version 1.0.0  08aug2006

program define nlogit_lf, sort
	version 10
	args todo b lnf g negH  

	tempvar lf
	.$NLOGIT_model.evaluate `lf', b(`b') todo(`todo')

	mlsum `lnf' = `lf'

	if (`todo') {
		.$NLOGIT_model.scores, g(`g')
	}
end

exit

