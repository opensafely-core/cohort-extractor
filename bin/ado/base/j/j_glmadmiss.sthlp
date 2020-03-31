{smcl}
{* *! version 1.1.1  11feb2011}{...}
{vieweralsosee "[R] glm" "help glm"}{...}
{vieweralsosee "[R] binreg" "help binreg"}{...}
{title:My glm output reports that some mean estimates are inadmissible}

{pstd}
Your estimation results show that your parameter estimates produce
inadmissible mean predictions for one or more observations in your estimation
sample.  As a result, you should exercise caution in interpreting these 
parameter estimates.

{pstd}
If you obtained this warning, then you have attempted to fit a binomial 
model with either log or identity link.

{pstd}
If you fit a binomial model with log link either via {helpb glm} or 
{helpb binreg} with option {cmd:rr} for risk ratios, then the warning arose
because the linear predictor ({it:eta} in glm jargon) is greater than zero for
one or more observations.  For this model, the estimated probability of a
positive event is the exponentiated linear predictor.  When the linear
predictor is greater than zero, the estimated probability is greater than one,
which is inadmissible.

{pstd}
If you fit a binomial model with identity link either via {helpb glm} or 
{helpb binreg} with option {cmd:rd} for risk differences, then the warning 
arose because the linear predictor is outside the range [0,1] for one 
or more observations.  As such, the predicted probability of a positive 
event (which is just the linear predictor in this case) is outside its 
admissible range for these observations.

{pstd}
Most likely your model was fit via ML and the estimation algorithm did not
converge.  Even if the algorithm did converge, the interpretation of the 
resulting parameter estimates is questionable.
{p_end}
