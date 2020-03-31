*! version 1.1.3  5dec1997
* _crcnuse -- find number/range of usable observations, count gaps
program define _crcnuse, rclass
	version 6.0
	local touse `"`1'"'
	confirm variable `touse'
        quietly {
/*
	Mark the usable observations with a 1.  Since missing values
        are unusable, they are marked with a 0.

        Exit immediately if there are no usable observations.
*/
                tempvar use esu
                gen byte `use' = (`touse'!=.) & (`touse'!=0)
		count if `use'
		if r(N)==0 {	/* exit if there are no obs */
			ret scalar N = 0
			ret scalar gaps = 0
			ret scalar first = .
			ret scalar last = .
			global S_1 0
			global S_2 0
			global S_3 .
			global S_4 .
			exit
		}
/*
	What is the observation number of the first usable observation?
        This algorithm depends on `use' being filled only with 0's and 1's
        and on `use' not containing all 0's.
*/
        	tempvar j
        	gen long `j' = `use' in f
		replace `j' = cond(sum(`use')==`use',_n,`j'[_n-1])
        	local first = `j'[_N]
/*
	What is the observation number of the last usable observation?
        `esu' is `use' backwards.
*/
        	gen byte `esu' = `use'[_N+1-_n]
		replace `j' = cond(sum(`esu')==`esu',_n,`j'[_n-1])
        	local last = cond(`j'[_N]>0,_N+1-`j'[_N],0)
/*
	How many usable observations are there?  Are there any gaps?
*/
       		count if `use' in `first'/`last'
        	ret scalar N = r(N)
       		ret scalar gaps = return(N) < `last' - `first' + 1
                if return(gaps) { /* There are gaps.  How many are there? */
                        replace `j' = sum(!`use' & `use'[_n-1]) in `first'/`last'
                        ret scalar gaps = `j' in `last'
                }
        	ret scalar first = `first'
        	ret scalar last = `last'
		global S_1 = return(N)
		global S_2 = return(gaps)
		global S_3 = return(first)
		global S_4 = return(last)
        } /* quietly */
end
exit
