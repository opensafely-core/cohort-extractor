*! version 1.0.0  18aug2014

program _parse_igmm_options, sclass
	version 14
	syntax, [ igmm igmmiterate(string) igmmeps(string) igmmweps(string) ]

	if "`igmm'" == "" {
		if "`igmmiterate'" != "" {
			di as err "{p}may only specify {bf:igmmiterate()} " ///
			 "with iterative GMM estimator{p_end}"
			exit 198
		}
		if "`igmmeps'" != "" {
			di as err "{p}may only specify {bf:igmmeps()} with " ///
			 "iterative GMM estimator{p_end}"
			exit 198
		}
		if "`igmmweps'" != "" {
			di as err "{p}may only specify {bf:igmmweps()} " ///
			 "with iterative GMM estimator{p_end}"
			exit 198
		}
		exit
	}
	if "`igmmiterate'" != "" {
		cap confirm integer number `igmmiterate'
		local rc = c(rc)
		if !`rc' {
			local rc = (`igmmiterate'<=0)
		}
		if `rc' {
			di as err "{p}{bf:igmmiterate()} must be " ///
			 "an integer greater than zero{p_end}"
			exit 198
		}
	}
	else local igmmiterate = c(maxiter)

	if "`igmmeps'" != "" {
		cap confirm number `igmmeps'
		local rc = c(rc)
		if !`rc' {
			local rc = !(`igmmeps'>0.0)
		}
		if `rc' {
			di as err "{bf:igmmeps()} must be greater " ///
			 "than zero"
			exit 198
		}
	}
	else local igmmeps = 1e-6

	if "`igmmweps'" != "" {
		cap confirm number `igmmweps'
		local rc = c(rc)
		if !`rc' {
			local rc = !(`igmmweps'>0.0)
		}
		if `rc' {
			di as err "{bf:igmmweps()} must be greater " ///
			 "than zero"
			exit 198
		}
	}
	else local igmmweps = 1e-6

	sreturn local igmmiterate = `igmmiterate'
	sreturn local igmmeps = `igmmeps'
	sreturn local igmmweps = `igmmweps'
end

exit
