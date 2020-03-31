*! version 1.1.0  16apr2015
program _svy_check_postw, sort
	version 9
	args touse posts postw

	local npost : word count `posts' `postw'
	if (`npost' == 0) exit

	if `npost' == 1 {
		if "`posts'" == "" {
			di as err ///
"poststratum weights are required for poststratification"
		}
		else {
			di as err ///
"a poststratum id variable is required for poststratification"
		}
		exit 198
	}

	// verify post-strata weight assumptions
	local by `touse' `posts'
	sort `by', stable
	capture by `by' : assert `postw' == `postw'[_N] if `touse'
	if c(rc) {
		di as err ///
"poststratification weights must be constant within post strata"
		exit 198
	}
	capture assert `postw' > 0 if `touse'
	if c(rc) {
		di as err ///
"poststratification weights must be positive"
		exit 198
	}
end
exit
