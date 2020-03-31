*! version 1.0.1  16jan2003

// ---------------------------------------------------------------------------
//  Drawing program for the normal view

program yxview_normal_draw
	if _N < `.points' {
		local reset 1
		local n0 = _N + 1
		.`log'.Arrpush __NOLOG__ qui set obs `.points'
	}

							// make the data
	local delta = (`max' - `min') / (`.points'-1)
	.`log'.Arrpush __NOLOG__ tempname x p
	.`log'.Arrpush __NOLOG__ qui gen double \`x' = `min' in 1
	.`log'.Arrpush __NOLOG__ qui replace    \`x' = \`x'[_n-1] + `delta' ///
		in 2/`.points'
	.`log'.Arrpush __NOLOG__ qui gen double				///
		\`p' = normden(\`x',`mean',`std') in 1/`.points'

							// labels
	if "`.varlist'" == "" {
		.`log'.Arrpush __NOLOG__ label variable \`x' "X"
	}
	else {
		local lab :variable label `.varlist'
		if `"`lbl'"' == `""' {
		    .`log'.Arrpush __NOLOG__				///
		    		label variable \`p' `"Density of `.varlist'"'
		}
		else {
		    .`log'.Arrpush __NOLOG__ label variable \`x' `"`lbl'"'
		    .`log'.Arrpush __NOLOG__				///
				label variable \`p' `"Density of `lbl'"'
		}
	}

	.`log'.Arrpush .`sersetname' = .serset.new \`p' \`x'		///
		in 1/`.points' , `.omitmethod' `options' nocount

	.`log'.Arrpush __NOLOG__ .`sersetname'.sers[1].name = "density"
	if "`.varlist'" == "" {
		.`log'.Arrpush __NOLOG__ .`sersetname'.sers[2].name = "x"	
		.varlist = "density x"
	}
	else {
	      .`log'.Arrpush __NOLOG__ .`sersetname'.sers[2].name = "`.varlist'"
	      .varlist = "density `.varlist'"
	}

	if 0`reset' {
		.`log'.Arrpush __NOLOG__ qui drop in `n0'/l
	}
end


