{* *! version 1.0.0  18jun2014}{...}
{title:Remarks on using sampling weights}

{pstd}
Sampling weights are treated differently in multilevel models than they
are in standard models such as OLS regression.  In a multilevel model,
observation-level weights are not indicative of overall
inclusion.  Instead, they indicate inclusion conditional on the 
corresponding cluster being included at the next highest-level of sampling.

{pstd}
For example, if you include only observation-level weights in a
two-level model, sampling with equal probabilities at level two is assumed,
and this may or may not be what you intended.
If the sampling at level two is weighted, then including only level-one 
weights can lead to biased results even if weighting at level two has
been incorporated into the level-one weight variable.  For example, it is 
a common practice to multiply conditional weights from multiple levels into
one overall weight.  By contrast, weighted multilevel analysis
requires the component weights from each level of sampling.

{pstd}
Even if you specify sampling weights at all model levels, the scale of
sampling weights at lower levels can affect your estimated parameters 
in a multilevel model.  That is, not only do the relative sizes of the
weights at lower levels matter, the scale of these weights matters also.

{pstd}
In general, exercise caution when using sampling weights;
see {mansection ME meglmRemarksandexamplesSurveydata:{it:Survey data}}
in {it:Remarks and examples} of {bf:[ME] meglm} for more information.
{p_end}
