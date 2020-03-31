*! version 1.0.1  31jul2013
version 11.0
/*
Function _pcrow() is called by _growpctile.ado and _growmedian.ado.
Saves results in a variable whose name is passed to string scalar pc.
*/

mata:

mata set matastrict on

void _pcrow(    string scalar varlist,
                string scalar touse,
                string scalar pc,
                string scalar poption)
{
        real matrix             dataM, ind, distribution
        real rowvector          observationV
        real colvector          pctileV
        real scalar             p, i, elemNumber, threshold, cols, rows,
                                smallestIndex, elem1, elem2
        dataM = ind = distribution = .
        observationV = .
        st_view(dataM, ., tokens(varlist), touse)
        p = strtoreal(poption)

        cols = cols(dataM)
        rows = rows(dataM)
        pctileV = J(rows,1,.)
        for (i=1; i<=rows; i++) {
                observationV = dataM[i,.]
                elemNumber = rownonmissing(observationV)
                if (elemNumber > 0) { //there are non missings elements
			threshold = (elemNumber * p/100)
                        // first smallest index larger than threshold
                        smallestIndex = ceil(threshold)
                        if (abs(smallestIndex - threshold) < 1e-8 ) {
                                smallestIndex = smallestIndex + 1
                        }
                        minindex(observationV, cols, ind, distribution)
                        if (abs(threshold - (smallestIndex-1)) < 1e-8) { // 2 values of percentile
                                elem1 = observationV[ind[smallestIndex-1,1]]
                                elem2 = observationV[ind[smallestIndex,1]]
                                pctileV[i] = (elem1 + elem2)/2
                        }
                        else {  // percentile is unique
                                pctileV[i] = observationV[ind[smallestIndex,1]]
                        }
                }
                else {
                //all elements are missings
                        pctileV[i] = .
                }
        }
        st_store(., pc, touse, pctileV)
}
end

