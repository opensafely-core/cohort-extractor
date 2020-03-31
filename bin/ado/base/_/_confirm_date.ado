*! version 2.0.3  13feb2015
program _confirm_date
	version 9
	args tfmt date

	if bsubstr(`"`tfmt'"',1,3) == "%-t" {
		local ff = bsubstr(`"`tfmt'"',4,1)
	}
	else if bsubstr(`"`tfmt'"',1,2) == "%t" {
		local ff = bsubstr(`"`tfmt'"',3,1)
	}
	else if bsubstr(`"`tfmt'"',1,3) == "%-d" {
		local ff d
	}
	else if bsubstr(`"`tfmt'"',1,2) == "%d" {
		local ff d
	}
	else	exit 9

	c_local ff `ff'
	if ("`ff'"=="y") {
		if (`date'<0100 | `date'>9999) {
			exit 9
		}
	}
	else {
		capture {
			local x = t`ff'(`date')
			confirm integer number `x'
		}
		if c(rc) exit 9
	}
end

