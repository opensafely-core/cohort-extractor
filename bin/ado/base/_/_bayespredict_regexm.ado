*! version 1.0.0  18feb2019

program _bayespredict_regexm
	version 16.0
	gettoken cmd    0 : 0
	gettoken output 0 : 0
	gettoken colon  0 : 0
	if `"`colon'"' != ":" {
		di as err "_bayespredict_regexm expecting a colon"
		exit(198)
	}
	_bayespredict_regexm_`cmd' res : `0'
	c_local `output' = `"`res'"'
end

program _bayespredict_regexm_nobraces
	args regstr colon
	c_local `regstr' = ///
	".*:_ysim.*|_ysim.*|.*:_resid.*|_resid.*|.*:_mu.*|_mu.*"
end

program _bayespredict_regexm_braces
	args regstr colon
	c_local `regstr' = ///
	"{.*:_ysim.*}|{_ysim.*}|{.*:_resid.*}|{_resid.*}|{.*:_mu.*}|{_mu.*}"
end