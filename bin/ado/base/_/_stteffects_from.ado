*! version 1.0.0  04feb2015

program define _stteffects_from
	version 14.0
	syntax, b(name) from(string)

	gettoken from opt : from, parse(,)
	if "`opt'" != "" {
		gettoken comma opt : opt, parse(,)
	}
	if "`opt'" !=  "copy" {
		local update update
	}
	if "`opt'" != "" {
		local opt ,`opt'
	}
	local stripe : colfullnames `b'
	_mkvec `b', from(`from'`opt') `update' error("from()")

	/* copy option will destroy the stripe				*/
	mat colnames `b' = `stripe'
end

exit
