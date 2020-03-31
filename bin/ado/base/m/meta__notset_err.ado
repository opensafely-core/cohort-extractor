*! version 1.0.0  01apr2019
program meta__notset_err	
	di as err "data not {bf:meta} set"
	di as err "{p 4 4 2}You must declare your meta-analysis " ///
		"data using either {helpb meta set} or " 	  ///	
		"{helpb meta esize}.{p_end}"
	exit 119
end	