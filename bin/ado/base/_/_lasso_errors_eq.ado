*!version 1.0.1  04jun2019
program _lasso_errors_eq
	version 16.0

	syntax [, infer_lasso empty]

	if (`"`infer_lasso'"' != "") {
		if (`"`empty'"' != "") {
			ErrInferEmpty
		}
		else {
			ErrInfer
		}
	}
	else {
		if (`"`empty'"' != "") {
			ErrEmpty
		}
		else {
			ErrDefault
		}
	}
end

					//----------------------------//
					// error infer_lasso and empty
					//----------------------------//
program ErrInferEmpty
	di as err "invalid {bf:controls()} " 
	di "{p 4 4 2}"
	di "{it:othervars} required in {bf:controls([({it:alwaysvars})] " ///
		"{it:othervars})} "
	di "{p_end}"
	exit 198
end

					//----------------------------//
					// error infer_lasso
					//----------------------------//
program ErrInfer
	di as err "invalid {bf:controls()} " 
	di "{p 4 4 2}"
	di "the syntax is {bf:controls([({it:alwaysvars})] {it:othervars})} "
	di "{p_end}"
	exit 198
end

					//----------------------------//
					// error empty
					//----------------------------//
program ErrEmpty
	di as err "invalid syntax" 
	di "{p 4 4 2}"
	di "{it:othervars} required in [({it:alwaysvars})] {it:othervars} "
	di "{p_end}"
	exit 198
end

					//----------------------------//
					// error default
					//----------------------------//
program ErrDefault
	di as err "invalid syntax" 
	di "{p 4 4 2}"
	di "the syntax is {it:depvar} [({it:alwaysvars})] {it:othervars} "
	di "{p_end}"
	exit 198
end

