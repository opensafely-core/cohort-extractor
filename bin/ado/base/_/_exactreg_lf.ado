*! version 1.0.0  13apr2007

program _exactreg_lf
	version 10

	args todo b lnf g negH sc

	tempvar bu 
	tempname bt sbu

	mleval `bu' = `b', eq(1)
	matrix `bt' = `b'*$EXREG_t'

	qui replace `bu' = $ML_y1*exp(`bu')
	mlsum `sbu' = `bu'
	scalar `lnf' = `bt'[1,1]-ln(`sbu') 
	if `todo' > 0 {
		qui replace `bu' = `bu'/`sbu'
		qui replace `sc' = $EXREG_iv-`bu'
		mlvecsum  `lnf' `g' = `sc', eq(1)
		if `todo' > 1 {
			mlmatsum `lnf' `negH' = `bu', eq(1)
			mlvecsum  `lnf' `bt' = `bu', eq(1)
			mat `negH'[1,1] = `negH'[1,1] - `bt'[1,1]^2
		}
	}
end

