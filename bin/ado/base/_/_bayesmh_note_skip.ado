*! version 1.0.0  09mar2015
program _bayesmh_note_skip
        args skip mcmcsize storing
	if (`skip'==0) {
                exit
        }
        if ("`storing'"=="") {
                local saving skipping
        }
        else {
                local saving discarding
        }
        if (`skip'==1) {
                local skipping "`saving' every other sample observation"
        }
        else {
                local skipping "`saving' every `skip' sample observations"
        }
        local shift1 = 1+`skip'+1
        local shift2 = `shift1'+`skip'+1
        local shift3 = `shift2'+`skip'+1
        local shift4 = `shift3'+`skip'+1
        if (`shift1'>`mcmcsize') {
                local using "using observation 1"
        }
        else if (`shift2'>`mcmcsize') {
                local using "using observations 1 and `shift1'"
        }
        else if (`shift3'>`mcmcsize') {
                local using "using observations 1,`shift1',`shift2'"
        }
        else if (`shift4'>`mcmcsize') {
                local using "using observations 1,`shift1',`shift2',`shift3'"
        }
        else { //more than 4 observations
                local using "using observations 1,`shift1',`shift2',..."
        }
        di as txt "{p 0 6 2}note: `skipping'; `using'{p_end}"
end

