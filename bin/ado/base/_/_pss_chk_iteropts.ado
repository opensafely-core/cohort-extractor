*! version 1.1.0  13feb2019
program _pss_chk_iteropts, sclass
	version 13

	syntax [anything(name=validate)], [	///
		  pssobj(string) 		///
		  ITERate(integer 500)		///
		  init(string)			///
		  TOLerance(real 1e-12)		///
		  FTOLerance(real 1e-12)	///
		  LOG				///
		  DOTS				///
		  TECHnique(string)		/// //undoc.
		  onetol			///
		* ]
		  
	sret local options `options'
	if (`"`technique'"'=="") {
		local technique newton
	}
	if "`init'" != "" {
		cap confirm number `init'
		if (c(rc)) {
			di as err "{p}invalid {bf:init(`init')}; a single " ///
			 "value is expected{p_end}"
			exit 198
		}
	}
	if "`validate'"!="" & "`init'"!="" {
		cap confirm number `init'
		local rc = c(rc)
		if !`rc' {
			tempname val
			local sval `validate'
			local validate = lower(bsubstr("`validate'",1, ///
				min(bstrlen("`validate'"),3)))
			if inlist("`validate'","or","eff","var", "m", "orc") {
				scalar `val' = `init'
				local rc = (`val'<=0)
				local extra "positive number "
			}
			else if "`validate'" == "pro" {
				scalar `val' = `init'
				local rc = (`val'<=0 | `val'>=1)
				local extra "positive number less than 1"
			}
			else if "`validate'" == "n" | "`validate'" == "k" {
				scalar `val' = `init'
				local rc = (`val'<=1)
				local extra "positive integer greater than 1"
			}
			else if "`validate'" == "cor" {
				scalar `val' = `init'
				local rc = (`val'<=-1 | `val'>=1)
				local extra "number between -1 and 1"
			}
			else if "`validate'" == "df" {
				scalar `val' = `init'
				local rc = (`val'<=-1 | `val'>=1)
				local extra "number between -1 and 1"
			}
			else if "`validate'" == "r2" {
				scalar `val' = `init'
				local rc = (`val'<=0 | `val'>=1)
				local extra "number between 0 and 1"
			}
		}
		if `rc' {
			di as err "{p}invalid option {bf:init()}: expected a " ///
			 "`extra'{p_end}"
			exit 198
		}
		if "`pssobj'"!="" & "`validate'"=="or" {
			mata: st_local("onesided",strofreal(`pssobj'.onesided))
			mata: st_local("espos",strofreal(`pssobj'.espos))

			if (`espos' & `val'<1.0) local err greater
			if (!`espos' & `val'>1.0) local err less
			if "`err'" != "" {
				di as err "{p}invalid option " 		   ///
				 "{bf:init(`init')}; expected an initial " ///
				 "`sval' value `err' than 1{p_end}"
				exit 198
			}
		}
	}
	if `iterate' < 0 {
		di as err "{p}invalid {bf:iterate(`iterate')}; maximum " ///
		 "number of iterations must be greater than 0{p_end}"
		exit 198
	}
	if `tolerance'<=0 | `tolerance'>1 {
		di as err "{p}invalid {bf:tolerance(`tolerance')}; "    ///
		 "parameter tolerance must be greater than 0 and less " ///
		 "than or equal to 1{p_end}"
		exit 198
	}
	if `ftolerance'<=0 | `ftolerance'>1 {
		di as err "{p}invalid {bf:ftolerance(`ftolerance')}; " ///
		 "function tolerance must be greater than 0 and less " ///
		 "than or equal to 1{p_end}"
		exit 198
	}

	opts_exclusive "`dots' `log'"
	if ("`pssobj'"!="") {
		mata: `pssobj'.inititeropts(`iterate',		///
					    `tolerance', 	///
					    `ftolerance',	///
					    ("`onetol'"==""),	///
					    "`log'",		///
					    "`dots'",		///
					    "`technique'",	///
					    "`init'")
	}
end

exit
