*! version 2.0.5  15apr2019
program mds_parse_method, sclass
	version 10

	capture syntax [anything] [, LOSS(str) TRANSformation(str) ]
	if _rc {
		di as err "mds_parse_method invalid syntax "
		exit 198
	}
	local 0 , `anything'
	capture syntax [, Classical Modern Nonmetric *]
	if _rc {
		di as err "method() invalid"
		exit 198
	}
	if "`options'" != "" {
		di as err "method() may be one of classical, modern, or nonmetric"
		exit 198
	}

	local meths `classical' `modern' `nonmetric' 
	local wc : word count `meths'
	if `wc' > 1 {
		di as err "only one of classical, modern and nonmetric " ///
			"methods may be specified"
		exit 198
	}
	if "`classical'" != "" & ("`loss'" != "" | "`transformation'" != "") {
		di as error "neither loss() nor transform() allowed with " ///
			"method(classical)"
		exit 198
	}
	if "`modern'" != "" & "`loss'" == "" & "`transformation'" == "" {
		local loss stress
		local transformation identity
		di "{txt}({bf:loss(stress)} assumed)"
		di "{txt}({bf:transform(identity)} assumed)"
	}
	if "`nonmetric'" != "" & "`loss'" == "" & "`transformation'" == "" {
		local loss stress
		local transformation monotonic
		di "{txt}({bf:loss(stress)} assumed)"
		di "{txt}({bf:transform(monotonic)} assumed)"
	}
	if "`nonmetric'" != "" & "`transformation'" == "" {
		if "`loss'" != bsubstr("stress", 1, min(4,length("`loss'"))){
			di as err "method(nonmetric) valid only with {bf:loss(stress)}"
			exit 198
		}
		local transformation monotonic
		di "{txt}({bf:transform(monotonic)} assumed)"

	}

	if `"`loss'`transformation'"' == "" {
	sreturn clear
	sreturn local classical classical
	exit
	}	

	Parse_Loss `"`loss'"'
	local loss `s(loss)'

	Parse_Transf `"`transformation'"'
	local transf `s(transf)'

// defaults ---------------------------------------------------------

	if "`transf'" == "" {
		if "`loss'" != "" {
			dis "{txt}({bf:transform(identity)} assumed)"
			local transf identity
		}
	}

	if "`transf'" == "monotonic" {
		if "`loss'" == "" {
			dis "{txt}({bf:loss(stress)} assumed)"
			local loss stress
		}
		else if "`loss'" != "stress" {
			dis as err "transform(monotonic) not allowed with " ///
				"loss(`loss')"
			exit 198
		}
	}
	else if "`transf'" != "" & "`loss'" == "" {
		dis "{txt}({bf:loss(stress)} assumed)"
		local loss stress
	}

	assert ("`transf'"!="")==("`loss'"!="")

	// if transform/loss unspecified: classical MDS

// descriptive titles -----------------------------------------------

	if "`loss'" == "stress" {
		local losst "raw_stress/norm(distances)"
	}
	else if "`loss'" == "sstress" {
		local losst "raw_sstress/norm(distances^2)"
	}
	else if "`loss'" == "nstress" {
		local losst "raw_stress/norm(disparities)"
	}
	else if "`loss'" == "nsstress" {
		local losst   "raw_sstress/norm(disparities^2)"
	}
	else if "`loss'" == "strain" {
		local losst "loss for classical MDS"
	}
	else if "`loss'" == "sammon" {
		local losst "Sammon mapping"
	}

	if "`transf'" == "identity" {
		local transft "identity (no transformation)"
	}
	else if "`transf'" == "power" {
		local transft "power"
	}
	else if "`transf'" == "monotonic" {
		local transft "monotonic (nonmetric)"
	}

	if "`nonmetric'" != "" & ("`loss'" != "stress" |		///
		"`transf'" != "monotonic") {
		di as err "method(nonmetric) only valid with {bf:loss(stress)} " ///
			"and transform(monotonic)"
		exit 198
	}
	if "`classical'" != "" & "`loss'`transf'" != "" { 
		dis as err "loss() and transform() not allowed with " ///				"method(classical)"  
		exit 198
	}	
	else if "`loss'`transf'" == "" { 
		local classical classical
	}	

//return ------------------------------------------------------------

	sreturn clear
	sreturn local loss        `loss'
	sreturn local losstitle   `losst'
	sreturn local transf      `transf'
	sreturn local transftitle `transft'
	sreturn local classical `classical'
end


program Parse_Loss, sclass
	args lossarg

	local 0 ,`lossarg'
	capture syntax [, STREss SSTRess NSTRess NSSTress STRAin SAMmon ]
	if _rc {
		dis as err "loss() may be one of stress, sstress, " ///
		"nsstress, strain, or sammon"
		exit 198
	}

	local loss `stress' `sstress' `nstress' `nsstress' `strain' `sammon'
	opts_exclusive "`loss'" loss

	sreturn clear
	sreturn local loss `loss'
end


program Parse_Transf, sclass
	args transarg

	local 0, `transarg'
	capture syntax [, Identity Power Monotonic ]
	if _rc {
		dis as err "transform() may be one of identity, power, " ///
			"or monotonic"
		exit 198
	}

	local transf `identity' `power' `monotonic'
	opts_exclusive "`transf'" transform

	sreturn clear
	sreturn local transf `transf'
end

exit
