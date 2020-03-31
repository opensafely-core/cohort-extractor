*! version 1.0.0  20mar2007
program newey_estat
	version 10
	
	if "`e(cmd)'" != "newey" {
		exit 301
	}
	
	gettoken sub rest: 0, parse(" ,")

	local lsub = length("`sub'")
	if "`sub'" == "durbinalt" {
		DoDurbina `rest'
	}
	else estat_default `0'

end

program DoDurbina

	syntax [ , FORCE * ]
	if "`force'" == "" {
		di in smcl as err 		///
"You must specify {cmd:force} for this command to work after {cmd:newey}"
		exit 198
	}
	else {
		durbina, `options' force
	}
		
end
