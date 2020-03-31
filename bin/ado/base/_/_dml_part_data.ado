*! version 1.0.1  15apr2019
/*
	double machine learning partition data

	It must be called by a program with sortpreserve, and preserve the data
	set.
*/
program _dml_part_data
	version 16.0

	syntax , gr(string)	/// tempvar for groups
		xfolds(string)	//  number of groups in cross-fitting

					//-- sort data in arbitrary order --//	
	tempvar tmp
	qui gen double `tmp' = runiform()
	sort `tmp'
					//-- create group variable --//
	qui gen int `gr' = 1 + mod(_n, `xfolds')
end
