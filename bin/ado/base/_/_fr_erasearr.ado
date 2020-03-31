*! version 1.0.0  10sep2002
program define _fr_erasearr
	args array

	while 0`.`array'.arrnels' > 0 {
		.`array'.Arrpop
	}
end
