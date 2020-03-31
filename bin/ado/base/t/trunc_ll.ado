*! version 1.0.1  14jun2000
program define trunc_ll
	version 7
	args lnf theta1 theta2
	if $TRUNCREG_flag == 1 { 
	     qui replace `lnf' = ln(normd(($ML_y1-`theta1')/`theta2')) /*
		  */ - ln(`theta2') /* 
		  */ - ln(normprob(-($TRUNCREG_a - `theta1')/`theta2'))
        }
	if $TRUNCREG_flag == -1 { 
	     qui replace `lnf' = ln(normd(($ML_y1-`theta1')/`theta2')) /*
		  */ - ln(`theta2') /* 
		  */ - ln(normprob(($TRUNCREG_b - `theta1')/`theta2'))
        }
	if $TRUNCREG_flag == 0 {
	     qui replace `lnf' = ln(normd(($ML_y1-`theta1')/`theta2')) /*
		  */ - ln(`theta2') /*
		  */ - ln(normprob(($TRUNCREG_b - `theta1')/`theta2')  /*
		  */ - normprob(($TRUNCREG_a - `theta1')/`theta2'))
        }
	if $TRUNCREG_flag == 2 {
	     qui replace `lnf' = ln(normd(($ML_y1 -`theta1')/`theta2')) /*
		  */ -ln(`theta2')
	}
end
