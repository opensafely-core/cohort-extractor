*! version 1.0.1  14dec2018

program _bayespredict_estname
	version 16.0
	args toparams colon predfile
	local estfile `predfile'
	if regexm(`"`estfile'"', "\.dta$") {
		local estfile = regexr(`"`estfile'"', "\.dta", ".ster") 
	}
	local estfile `estfile'
	c_local `toparams' `estfile'
end
