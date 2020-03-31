*! version 1.0.2  19jun2009
* Note: changes to this file may also need to be copied to u_mi_prefix_title.ado
program _prefix_title, rclass
	version 9
	if (`"`e(title)'"' != "") {
		return local title `"`e(title)'"'
		exit
	}
	args cmd default

	if "`cmd'" == "cnreg" {
		return local title "Censored normal regression"
		exit
	}
	if "`cmd'" == "logit" {
		return local title "Logistic regression"
		exit
	}
	if "`cmd'" == "mlogit" {
		return local title "Multinomial logistic regression"
		exit
	}
	if "`cmd'" == "ologit" {
		return local title "Ordered logistic regression"
		exit
	}
	if "`cmd'" == "oprobit" {
		return local title "Ordered probit regression"
		exit
	}
	if "`cmd'" == "probit" {
		return local title "Probit regression"
		exit
	}
	if "`cmd'" == "regress" {
		return local title "Linear regression"
		exit
	}
	if "`cmd'" == "tobit" {
		return local title "Tobit regression"
		exit
	}
	return local title `"`default'"'
end
exit
