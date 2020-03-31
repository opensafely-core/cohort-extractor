*! version 1.1.0  01oct2018
program define spxtregress, sortpreserve eclass
	version 15.0

	if replay() {
		Playback `0'
	}
	else {
		Estimate `0'
	}
end
					//-- Playback --//
program Playback
	syntax [, *]

	if (`"`e(cmd)'"'!="spxtregress") {
		di as err "results for {bf:spxtregress} not found"
		exit 301
	}
	else {
		spxtreg_`e(model)' `0'
	}
end
					//-- Estimate --//
program Estimate
	ParseModel `0'
	local model `s(model)'
	spxtreg_`model' `0'
end
					//-- ParseModel --//
program ParseModel, sclass
	syntax varlist(fv) [if] [in] [, fe re *]

	local model `fe' `re'
	local cases : word count `model'
	if (`cases'==0) {
		di as err "must specify fe or re"
		exit 198
	}
	else if (`cases'==2) {
		di as err "choose only one of fe or re"
		exit 198
	}
	sret local model `model'
end
