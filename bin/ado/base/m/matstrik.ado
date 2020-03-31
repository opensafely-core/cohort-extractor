*  version 1.0.0  23 May 1998
program define matstrik /* matname # */
	version 6
	args M i

	local n = colsof(`M')
	local nm1 = `n'-1
	local im1 = `i'-1
	local ip1 = `i'+1
	if rowsof(`M')==1 {
		if `i'==1 { 
			matrix `M' = `M'[1,2..`n']
		}
		else if `i'==`n' {
			matrix `M' = `M'[1,1..`nm1']
		}
		else {
			matrix `M' = `M'[1, 1..`im1'], `M'[1, `ip1'..`n']
		}
		exit
	}
	if `i'==1 { 
		matrix `M' = `M'[2..`n', 2..`n']
	}
	else if `i'==`n' {
		matrix `M' = `M'[1..`nm1', 1..`nm1']
	}
	else {
		matrix `M' = /*
		*/ (`M'[1..`im1', 1..`im1'], `M'[1..`im1', `ip1'..`n']) \ /*
		*/ (`M'[`ip1'..`n',1..`im1'], `M'[`ip1'..`n',`ip1'..`n'])
	}
end
exit
