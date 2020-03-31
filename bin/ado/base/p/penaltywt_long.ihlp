{* *! version 1.0.0  22jun2019}{...}
{phang}
{opt penaltywt(matname)} is a programmer's option for specifying a vector of
weights for the coefficients in the penalty term.  The contribution of each
coefficient to the lasso penalty term is multiplied by its corresponding
weight. Weights must be nonnegative.  By default, each coefficient's penalty
weight is 1.
