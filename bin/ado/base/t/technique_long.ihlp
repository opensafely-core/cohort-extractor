{* *! version 1.0.0  22jun2019}{...}
{phang}
{cmd:technique(dml1}|{cmd:dml2)} specifies which cross-fitting technique is
used, either double machine learning 1 ({cmd:dml1}) or double machine learning
2 ({cmd:dml2}).  For both techniques, the initial estimation steps are the
same.  The sample is split into K={opt xfolds(#)} folds.  Then, coefficients
on the controls are estimated using only the observations not in the kth fold,
for k = 1, 2, ..., K.  Moment conditions for the coefficients on the
{it:varsofinterest} are formed using the observations in fold k.  The default
technique, {cmd:dml2}, solves the moment conditions jointly across all the
observations.  The optional technique, {cmd:dml1}, solves the moment
conditions in each fold k to produce K different estimates, which are then
averaged to form a single vector of estimates.
