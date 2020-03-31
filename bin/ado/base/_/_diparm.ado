*! version 2.0.0  25jun2009
program _diparm
	version 11
	if _caller() < 8.2 {
		_diparm_8 `0'
		exit
	}

	syntax anything(name=eqs)			///
			[,	Level(cilevel)		///
				NOTAB			///
				DOF(passthru)		///
				BMATrix(passthru)	///
				VMATrix(passthru)	///
				DFMATrix(passthru)	///
				COEFLegend		///
				SELEGEND		///
				*			///
			]

	tempname T
	if `:length local notab' {
		.`T' = ._b_diparm.new,	level(`level')	///
					`dof'		///
					`bmatrix'	///
					`vmatrix'	///
					`dfmatrix'	///
					`coeflegend'	///
					`selegend'
		.`T'.compute `eqs', `options'
		exit
	}

	.`T' = ._b_table.new,	level(`level')	///
				`bmatrix'	///
				`vmatrix'	///
				`dfmatrix'	///
				`coeflegend'	///
				`selegend'
	.`T'.display_diparm `eqs', `options' `dof'
end
exit
