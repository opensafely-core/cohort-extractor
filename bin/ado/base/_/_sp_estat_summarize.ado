*! version 1.0.0  13apr2017
program _sp_estat_summarize
	version 15.0

	syntax [anything] [, *]

	gettoken subcmd varlist : anything

	if (`"`subcmd'"'!="summarize") {
		di as error "{bf:estat `subcmd'} not allowed"
		exit 321
	}

	if (`"`varlist'"' == "") {
		GetCovars
		local covars `s(covars)'
		estat_summ `covars', `options'
	}
	else {
		estat_summ `varlist', `options'
	}
end

program GetCovars, sclass
	tempname b
						//  get covars
	matrix `b' = e(b)
	local covars : colvarlist `b'
	local covars : list uniq covars
						//  remove _cons and e.depvar
	local ex_list e.`e(depvar)' _cons
	local covars : list covars - ex_list
						//  add depvar
	local covars `e(depvar)' `covars'
	local covars : list uniq covars

	sret local covars `covars'
end
