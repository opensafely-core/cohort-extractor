*! version 1.0.4  06dec2016
program define import_fred
	version 15
	
	gettoken serlist rest : 0, parse(",")
		
	capture syntax [anything], SERIESlist(string)			///
		[REALtime(string) 					///
		DATERange(string) 					///
		AGGRegate(string) 					///
		VINTage(string) 					///
		allobs 							///
		nrobs 							///
		long 							///
		initial 						///
		NOSUMMary						///
		clear *]
	if _rc {
		syntax [anything] 					///
			[,REALtime(string) 				///
			DATERange(string) 				///
			AGGRegate(string) 				///
			VINTage(string) 				///
			allobs 						///
			nrobs 						///
			long 						///
			initial 					///
			NOSUMMary					///
			clear *]
			fred_import `serlist' `rest'
	}
	else {
		fred_import_file `serlist' `rest'
	}
end

program fred_import
	syntax [anything] 						///
		[,REALtime(string) 					///
		DATERange(string) 					///
		AGGRegate(string) 					///
		vintage(string) 					///
		allobs 							///
		nrobs 							///
		long 							///
		initial 						///
		NOSUMMary						///
		clear]
	
	if `"`anything'"' == "" {
		di as err "invalid syntax"
		di as err "{p 4 4 2}series id must be specified{p_end}"
		exit 198		
	}
	
	if `"`realtime'"' != "" & `"`vintage'"' != "" {
		di as err "options {bf:realtime()} and {bf:vintage()}"	///
			" may not be specified together"
		exit 198
	}
	
	if `"`realtime'"' != "" & `"`initial'"' != "" {
		di as err "options {bf:realtime()} and {bf:initial}"	///
			" may not be specified together"
		exit 198
	}
	
	if `"`vintage'"' != "" & `"`initial'"' != "" {
		di as err "options {bf:vintage()} and {bf:initial}"	///
			" may not be specified together"
		exit 198
	}
	
	opts_exclusive "`allobs' `nrobs' `long' `initial' `'"
	
	if `"`realtime'"' == "" & `"`vintage'"' == "" {
		if `"`allobs'"' != "" {
			di as err "{p}option {bf:vintage()} or option"	///
				" {bf:realtime()} must be"
			di as err "specified with option {bf:allobs}{p_end}"
			exit 198			
		}
		if `"`nrobs'"' != "" {
			di as err "{p}option {bf:vintage()} or option"	///
				" {bf:realtime()} must be"
			di as err "specified with option {bf:nrobs}{p_end}"
			exit 198			
		}		
	}
	
	if `"`realtime'"' != "" || `"`vintage'"' != "" {
		if `"`aggregate'"' != "" & `"`long'"' != "" {
			di as err "options {bf:aggregate()} and {bf:long}"	///
				" may not be specified together when "		///
				"option {bf:realtime()} or option "		///
				"option {bf:vintage()} is specified"
			exit 198
		}
	}
	
	if `"`aggregate'"' != "" & `"`initial'"' != "" {
		di as err "options {bf:aggregate()} and {bf:initial}"	///
			" may not be specified together"
		exit 198
	}
	
	local _uniqseries : list uniq anything 
	local _uniqvintage : list uniq vintage
	
	local rstart
	local rend
	check_fdate rstart rend : 1 `"`realtime'"'

	local obstart
	local obend
	check_fdate obstart obend : 2 `"`daterange'"'	
	
	local _fredlong 0
	local _fred 0
	if `"`long'"' != "" || `"`initial'"' != "" {
		local _fredlong 1
	}
	
	if `"`realtime'"' == "" & `"`_uniqvintage'"' == "" & 		///
		`"`initial'"' == "" {
		local _fred 1
	}
	
	if `"`initial'"' != "" {
		local _uniqvintage = "_all"
	}
	
	if `"`clear'"' != "" {
		quietly clear
	}
	else {
		quietly count 
		if _N != 0 {
			di as err "no; data in memory would be lost"
			exit 4
		}
	}

	javacall com.stata.plugins.fred.Fred2Stata getSeriesObservations, ///
		args(`"`rstart'"' `"`rend'"'				///
		     `"`obstart'"' `"`obend'"'		 		///
		     `"`aggregate'"') jars(libstata-plugin.jar)
	local _aggrfreq `"`_frequency'"'
	
	javacall com.stata.plugins.fred.Fred2Stata processSeries, 	///
		jars(libstata-plugin.jar)
	
	quietly count
	if _N != 0 {
		quietly levelsof series_id, local(_uniqseries_tmp)
		local _uniqseries_data
		foreach i of local _uniqseries_tmp {
			local _uniqseries_data = "`_uniqseries_data'" + " " + strupper("`i'")
		}
		local _uniqseries_data = strtrim("`_uniqseries_data'")
		local _sortlist
		mata:get_order(`_fred', 1, `"`_uniqseries_var'"', `"`_uniqseries_data'"')
		local nseries : word count `_sortlist'
	}
	
	if `"`long'"' != "" {
		if `_fred' == 0 {
			quietly {
				count 
				if _N != 0 {
					gen _idx = _n
					sort series_id realtime_start realtime_end
					gen daten = date(datestr, "YMD", 9999)
					format %td daten
					order daten, after(datestr)
					label variable datestr "observation date"
					label variable daten "numeric (daily) date"
					sort _idx
					drop _idx
					
					noisily javacall com.stata.plugins.fred.Fred2Stata ///
						getSeriesSummary, jars(libstata-plugin.jar)
					compress
					
					if `"`nosummary'"' == "" {
						noisily mata:get_summary(0, 1, `"`_sortlist'"')
					}
					exit
				}
			}
		}
	}
	
	if `"`initial'"' != "" {
		quietly {
			count
			if _N != 0 {
				gen _idx = _n 
				sort series_id datestr realtime_start realtime_end
				by series_id datestr: gen _idx2 = _n
				drop if _idx2 != 1
				drop _idx2
				sort _idx
				drop _idx
				
				gen daten = date(datestr, "YMD", 9999)
				format %td daten
				order daten, after(datestr)
				label variable datestr "observation date"
				label variable daten "numeric (daily) date"
				noisily javacall com.stata.plugins.fred.Fred2Stata	///
					getSeriesSummary,  jars(libstata-plugin.jar)
				compress
				if `"`nosummary'"' == "" {
					noisily mata:get_summary(0, 1, `"`_sortlist'"')
				}
				exit
			}
		}
	}
	
	quietly {
	count 
	if _N != 0 {
		if `"`realtime'"' == "" & `"`_uniqvintage'"' == "" {
			if `_fredlong' == 0 {
				reshape wide value, i(datestr) j(series_id) string 
				rename value* *	
			}		
		}
		else {
			if `"`realtime'"' != "" {
				if `"`rend'"' != "" {
					local end1 
					local end2

				foreach vint of local _uniqseries_data {
					levelsof realtime_start if series_id==`"`vint'"', local(_rstart)
					levelsof realtime_end if series_id==`"`vint'"', local(_rend)
					local nstart : word count `_rstart'
					local nend : word count `_rend'
					local last_end1 : word `nstart' of `_rstart'
					local last_end2 : word `nend' of `_rend'
					local last_end1 = substr(`"`last_end1'"',1,4) 	+ 	///
						substr(`"`last_end1'"',6,2) 		+	///
						substr(`"`last_end1'"',9,2)
					local last_end2 = substr(`"`last_end2'"',1,4) 	+ 	///
						substr(`"`last_end2'"',6,2) 		+	///
						substr(`"`last_end2'"',9,2)
								
						local end1 = `"`end1'"' + " " + `"`last_end1'"'
						local end2 = `"`end2'"' + " " + `"`last_end2'"'
					}
				}
					
				sort series_id datestr realtime_start realtime_end
				gen rstart = substr(realtime_start,1,4)+ ///
					substr(realtime_start,6,2) +	///
					substr(realtime_start,9,2)
				gen sdate = series_id + "_" + rstart
				drop series_id realtime_start 		///
					realtime_end rstart
				capture reshape wide value, i(datestr) j(sdate) string
				rename value* *
					
				if `"`rend'"' != "" {
					forvalues i=1/`nseries' {
						local sid : word `i' of `_uniqseries_data'
						local sdate1 : word `i' of `end1'
						local sdate2 : word `i' of `end2'
						if `"`sdate1'"' != `"`sdate2'"' {
							gen `sid'_`sdate2' = .
							order `sid'_`sdate2', after(`sid'_`sdate1')
						}
					}
				}
				
				if `"`nrobs'"' == "" {
					foreach tseries in `_uniqseries_data' {
						local vc 1
						local pvar 
						foreach var of varlist `tseries'_* {
							if `vc' != 1 {
								replace `var' = `par' if missing(`var')
							}
							local par `var'
							local vc = `vc' + 1
						}
					}						
				}
				else {
					foreach tseries in `_uniqseries_data' {
						local vc 1
						local pvar 
						foreach var of varlist `tseries'_* {
							if `vc' != 1 {
								if `vc' != 2 {
									replace `var' = .u if (`pvar'==.u | !missing(`pvar')) & missing(`var')
								}
								else {
									replace `var' = .u if !missing(`pvar') & missing(`var')
								}
							}
							local pvar `var'
							local vc = `vc' + 1
						}
					}				
				}
			}
			else {
				local end1 
				local end2
				
				foreach vint of local _uniqseries_data {
					levelsof realtime_start if series_id==`"`vint'"', local(_rstart)
					levelsof realtime_end if series_id==`"`vint'"', local(_rend)
					local nstart : word count `_rstart'
					local nend : word count `_rend'
					local last_end1 : word `nstart' of `_rstart'
					local last_end2 : word `nend' of `_rend'
					local last_end1 = substr(`"`last_end1'"',1,4) 	+ 	///
						substr(`"`last_end1'"',6,2) 		+	///
						substr(`"`last_end1'"',9,2)
					local last_end2 = substr(`"`last_end2'"',1,4) 	+ 	///
						substr(`"`last_end2'"',6,2) 		+	///
						substr(`"`last_end2'"',9,2)
							
					local end1 = `"`end1'"' + " " + `"`last_end1'"'
					local end2 = `"`end2'"' + " " + `"`last_end2'"'
				}
				
				sort series_id datestr realtime_start realtime_end
				gen rstart = substr(realtime_start,1,4) +	///
					substr(realtime_start,6,2) +		///
					substr(realtime_start,9,2)
				gen sdate = series_id + "_" + rstart
				drop series_id realtime_start realtime_end rstart
				capture reshape wide value, i(datestr) j(sdate) string
				rename value* *
					
				forvalues i=1/`nseries' {
					local sid : word `i' of `_uniqseries_data'
					local sdate1 : word `i' of `end1'
					local sdate2 : word `i' of `end2'
					if `"`sdate1'"' != `"`sdate2'"' {
						gen `sid'_`sdate2' = .
						order `sid'_`sdate2', after(`sid'_`sdate1')
					}
				}
				
				if `"`_uniqvintage'"' != "_all" {
					foreach tseries in `_uniqseries_data' {
						local vc 1
						local pvar 
						foreach var of varlist `tseries'_* {
							if `vc' != 1 {
								replace `var' = `pvar' if missing(`var')
							}
							local pvar `var'
							local vc = `vc' + 1
						}
					}
					
					local _format_vints `"`_format_vintages'"'
					foreach tseries in `_uniqseries_data' {
						foreach var of varlist `tseries'_* {
							local var_date = substr("`var'", strrpos("`var'","_")+1, .)
							if strpos("`_format_vints'", "`var_date'") == 0 {
								drop `var'
							}
						}
					}
					
					if `"`nrobs'"' != "" {
						foreach tseries in `_uniqseries_data' {
							local tseries_var 
							foreach var of varlist `tseries'_* {
								local tseries_var = "`var'" + " " + "`tseries_var'"
							}
							
							local vc 1
							local pvar 
							foreach var of local tseries_var {
								if `vc' != 1 {
									replace `pvar' = .u if `var'==`pvar' & !missing(`var')
								}
								local pvar `var'
								local vc = `vc' + 1
							}
						}
					}
				}
				else {
					if `"`nrobs'"' == "" {
						foreach tseries in `_uniqseries_data' {
							local vc 1
							local pvar 
							foreach var of varlist `tseries'_* {
								if `vc' != 1 {
									replace `var' = `pvar' if missing(`var')
								}
								local pvar `var'
								local vc = `vc' + 1
							}
						}
					}
					else {
						foreach tseries in `_uniqseries_data' {
							local vc 1
							local pvar 
							foreach var of varlist `tseries'_* {
								if `vc' != 1 {
									if `vc' != 2 {
										replace `var' = .u if (`pvar'==.u | !missing(`pvar')) & missing(`var')
									}
									else {
										replace `var' = .u if !missing(`pvar') & missing(`var')
									}
								}
								local pvar `var'
								local vc = `vc' + 1
							}
						}
					}
				}
			}
		}
		quietly {
			char _dta[ReS_Xij_n]
			char _dta[ReS_Xij_long1]
			char _dta[ReS_Xij_wide1]
			char _dta[ReS_Xij]
			char _dta[ReS_str]
			char _dta[ReS_j]
			char _dta[ReS_ver]
			char _dta[ReS_i]
			
			gen daten = date(datestr, "YMD", 9999)
			format %td daten
			order daten, after(datestr)
			label variable datestr "observation date"
			label variable daten "numeric (daily) date"
			compress
		}
	}	
	}
	
	if `_fredlong' == 0 {
		local _sortlist
		mata:get_order(`_fred', 0, `"`_uniqseries_var'"', `"`_uniqseries_data'"')	
	}
	
	javacall com.stata.plugins.fred.Fred2Stata 			///
		getSeriesSummary,  jars(libstata-plugin.jar)
	
	if `"`nosummary'"' == "" {
		mata:get_summary(`_fred', `_fredlong', `"`_sortlist'"')
	}
end

program fred_import_file
	syntax [anything], SERIESlist(string)				///
		[*]
	
	if `"`anything'"' != "" {
		di as err "invalid syntax"
		di as err `"{p 4 4 2}`anything' not allowed{p_end}"'
		exit 198
	}
	
	local 0 `anything', `options' 
	local 0 , `options'
	
	syntax , [REALtime(string) 					///
		  DATERange(string) 					///
		  AGGRegate(string) 					///
		  VINTage(string) 					///
		  allobs 						///
		  nrobs 						///
		  long 							///
		  initial 						///
		  NOSUMMmary						///
		  clear]
		  
	local rest `0'
	
	local savefile `serieslist'
	if bsubstr(`"`savefile'"',-4,.)!=".dta" {
		local savefile `"`savefile'.dta"'
	}
	
	capture confirm file `savefile'
	if _rc {
		di as err "in option {bf:serieslist(blah)}, "		///
			"file " `"`savefile'"' " not found"
		exit 601
	}
	
	local _uniqseries 
	quietly {
		count 
		if _N > 0 {
			preserve
			use `"`savefile'"', clear
			mata: load_series_fromfile()
			restore
		}
		else {
			use `"`savefile'"', clear
			mata: load_series_fromfile()		
		}
	}

	fred_import `_uniqseries' `0'
end

program define check_fdate
	args fstart fend colon ftype fdate 
	
	local startdate
	local enddate
	if `"`fdate'"' != "" {
		local 0 `"`fdate'"'
		gettoken startdate 0 : 0
		if `"`0'"' == "" {
			if `ftype'==1 {
				di as err "option {bf:realtime()} "	///
					"incorrectly specified"
				di as err "{p 4 4 2}an end date must"	///
					" be specified; specify either" ///
					" . or an end date {p_end}"
				exit 198
			}
			else {
				di as err "option {bf:daterange()} "	///
					"incorrectly specified"
				di as err "{p 4 4 2}an end date must"	///
					" be specified; specify either" ///
					" . or an end date {p_end}"
				exit 198
			}
		}
		
		local enddate = strtrim(`"`0'"')
		if `"`startdate'"' != "." {
			if `"`enddate'"' == "." {
				local enddate ""
			}
		}
		else {
			if `"`enddate'"' == "." {
				if `ftype'==1 {
					di as err "option {bf:realtime()} "	///
						"incorrectly specified"
					di as err "{p 4 4 2}at least one of "	///
						"the start or end date must"	///
						" be specified{p_end}"
					exit 198
				}
				else {
					di as err "option {bf:daterange()} "	///
						"incorrectly specified"
					di as err "{p 4 4 2}at least one of "	///
						"the start or end date must"	///
						" be specified{p_end}"
					exit 198
				}
			}
			local startdate ""
		}
	}

	c_local `fstart' `"`startdate'"'
	c_local `fend' `"`enddate'"'
end

mata:
void get_order(real scalar isfred, real scalar isfredlong, 
	string scalar orgseries, string scalar avlseries) {
	string rowvector 	orgs
	real scalar		i, loc, smatch
	string scalar		tmp_sid, sortseries, sortlist
	
	orgseries = strtrim(orgseries)
	avlseries = strtrim(avlseries)
	orgs = tokens(orgseries, " ")
	
	sortseries = "" 
	sortlist = ""
	for(i=1; i<=cols(orgs); i++) {
		orgs[i] = strupper(orgs[i])
		tmp_sid = strtrim(orgs[i])
		smatch = 0
		loc = 0
		if (tmp_sid!="") {
			loc = strpos(avlseries, tmp_sid)
			if (loc > 0) {
				if (strlen(avlseries)==(loc+strlen(tmp_sid)-1)) {
					smatch = 1
				}
				else {
					tmp_sid = tmp_sid + " "
					loc = strpos(avlseries, tmp_sid) 
					if (loc > 0) {
						smatch = 1						
					}
				}
			}
		}
		
		if (smatch==1) {
			if (isfred==1) {
				sortseries = sortseries + " " + orgs[i]
			}
			else {
				sortseries = sortseries + " " + orgs[i] + "*"
			}
			sortlist = sortlist + " " + orgs[i]
		}
	}
	
	if (isfredlong != 1) {
		sortseries = "order datestr daten " + sortseries
		loc = _stata(sortseries, 1)
	}
	st_local("_sortlist", strtrim(sortlist))
}

string scalar get_frequency(string scalar sid, string scalar freqlist) {
	string scalar		retfreq, tstr
	real scalar		loc1, loc2 
	
	loc1 = strpos(freqlist, sid+",") 
	if (loc1 <= 0) {
		return("") 
	}
	
	tstr = substr(freqlist, loc1+strlen(sid)+1)
	loc2 = strpos(tstr, ";")
	retfreq = substr(tstr, 1, loc2-1)
	
	return(retfreq)
}

string scalar get_seriesabbrev(real scalar ishist, real scalar maxlen, 
	string scalar sid) {
	real scalar		slen, loc
	string scalar		newsid
	
	slen = strlen(sid)
	if (slen<=maxlen) {
		return(sid)
	}
	else {
		if (ishist==0) {
			return(abbrev(sid,maxlen))
		}
		else {
			loc = strrpos(sid, "_")
			newsid = substr(sid, 1, 20) + "~_" + substr(sid, loc+1, 8)
			return(newsid)
		}
	}
}

void get_summary(real scalar isfred, real scalar isfredlong, string scalar rptseries) {
	string rowvector 	vseries
	real scalar		i, ret, nvar, nseries, nfcolw, dpos
	string scalar		scmd, sid, sidreal, datestr, failseries 
	string scalar		freqlist, freqstr, hfreq, lfreq, aggrfreq
	
	nvar = st_nvar()
	if (nvar==0) {
		exit(0) 
	}
	
	nfcolw = 28
	printf("\nSummary\n")
	printf("{hline}\n")
	printf("Series ID{col 30}Nobs{col 38}Date range{col 64}Frequency\n")
	printf("{hline}\n")
	freqlist = st_local("_freqlist")
	hfreq = st_local("_hfreq")
	lfreq = st_local("_lfreq")
	failseries = st_local("_failseries")
	aggrfreq = st_local("_aggrfreq")
	aggrfreq = strtrim(aggrfreq)
	if (aggrfreq!="") {
		hfreq = aggrfreq
		lfreq = aggrfreq
	}

	if (isfredlong==1) {
		vseries = tokens(rptseries, " ")
		nseries = cols(vseries)
		for(i=1; i<=nseries; i++) {
			sid = vseries[i]
			ret = 0
			scmd = "gen _sidsumm = _n if series_id == " + `"""' + sid + `"""' 
			ret = ret + _stata(scmd, 1)
			scmd = "summ _sidsumm"
			ret = ret + _stata(scmd, 1)
			datestr = _st_sdata(_st_data(st_numscalar("r(min)"), nvar+1), 2)
			datestr = datestr + " to " + _st_sdata(_st_data(st_numscalar("r(max)"), nvar+1), 2)
			if (aggrfreq=="") {
				freqstr = get_frequency(sid, freqlist)
			}
			else {
				freqstr = aggrfreq
			}
			sid = get_seriesabbrev(0, nfcolw, sid)
			printf("%s{col 30}%g{col 38}%s{col 64}%s\n", sid, st_numscalar("r(N)"), datestr, freqstr)
			scmd = "drop _sidsumm"
			ret = ret + _stata(scmd, 1)
		}
		printf("{hline}\n")
		printf("# of series imported: %g\n", nseries)
		printf("{col 4}highest frequency: %s\n", hfreq)
		printf("{col 5}lowest frequency: %s\n", lfreq)
		if (strlen(failseries)!=0) {
			printf("{col 2}series not imported: %s\n", failseries)
		}
	}
	else {
		for(i=3; i<=nvar; i++) {
			sid = st_varname(i)
			ret = 0 
			scmd = "gen _sidsumm = _n if " + sid + " != ."
			ret = ret + _stata(scmd, 1)
			scmd = "summ _sidsumm"
			ret = ret + _stata(scmd, 1)
			datestr = _st_sdata(_st_data(st_numscalar("r(min)"), nvar+1), 1)
			datestr = datestr + " to " + _st_sdata(_st_data(st_numscalar("r(max)"), nvar+1), 1)
			if (isfred!=1) {
				dpos = strrpos(sid, "_")
				if (strlen(sid)-dpos==8) {
					sidreal = substr(sid, 1, strrpos(sid, "_")-1)
				}
				else {
					sidreal = sid
				}
				sid = get_seriesabbrev(0, nfcolw, sid)
			}
			else {
				sidreal = sid
				sid = get_seriesabbrev(1, nfcolw, sidreal)
			}
			if (aggrfreq=="") {
				freqstr = get_frequency(sidreal, freqlist)
			}
			else {
				freqstr = aggrfreq
			}				
			printf("%s{col 30}%g{col 38}%s{col 64}%s\n", sid, st_numscalar("r(N)"), datestr, freqstr)
			scmd = "drop _sidsumm"
			ret = ret + _stata(scmd, 1)
		}
		printf("{hline}\n")
		printf("# of series imported: %g\n", nvar-2)
		printf("{col 4}highest frequency: %s\n", hfreq)
		printf("{col 5}lowest frequency: %s\n", lfreq)	
		if (strlen(failseries)!=0) {
			printf("{col 2}series not imported: %s\n", failseries)
		}		
	}
}

void load_series_fromfile() {
	string scalar 		serieslist 
	real scalar 		i, obscount, var_series
	string colvector	svar_series

	obscount = st_nobs() 
	if (obscount==0) {	
		errprintf("no dataset in use\n")
		exit(3)
	}
	
	var_series = _st_varindex("series_id")
	if (var_series==.) {
		errprintf("variable {bf:series_id} is not found in specified dataset\n")
		exit(198)
	}
	
	serieslist = ""
	svar_series = st_sdata(., var_series)
	for(i=1; i<=rows(svar_series); i++) {
		serieslist = serieslist + " " + svar_series[i]
	}
	
	st_local("_uniqseries", serieslist)
}
end
