
program log_create_serset

	syntax , LOG(name) SERSETNAME(string) [ TOUSE(passthru) * ]

	.log_touse , log(`log') `touse'

	tokenize `.varlist'
	args y x

	.`log'.Arrpush tempname yhat
	.`log'.Arrpush ksm `.varlist' , `.method' gen(\`yhat') 		///
		bwidth(`.bwidth') `.ksm_options' nograph

	.`log'.Arrpush label variable \`yhat' 				///
		"ksm of `y', `method' bwidth(`.bwidth') `options'"

	.`log'.Arrpush .`sersetname' = .serset.new \`yhat' `x'		///
		if \`touse1' , `.omitmethod' `options'
	.`log'.Arrpush .`sersetname'.sort `x'

	.`log'.Arrpush .`sersetname'.sers[1].name = "`y'"
end
