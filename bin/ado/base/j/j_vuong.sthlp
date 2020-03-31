{smcl}
{* *! version 1.0.1  25sep2017}{...}
{vieweralsosee "[R] zip" "help zip"}{...}
{vieweralsosee "[R] zinb" "help zinb"}{...}
{vieweralsosee "[R] zioprobit" "help zioprobit"}{...}
{title:Vuong test is not appropriate for testing zero inflation}

{pstd}
{help j_vuong##G1994:Greene (1994)} proposed using the Vuong test for
nonnested models ({help j_vuong##V1989:Vuong 1989}) to test for
zero inflation.  Despite many earlier citations,
recent work by {help j_vuong##W2015:Wilson (2015)} has shown that the Vuong
test is inappropriate for testing zero inflation.  Nesting occurs when the
probability of zero inflation is 0, which is on the boundary, and this
violates the regularity conditions of the Vuong test for nonnested models.  So
the distribution of the test statistic is not standard normal.  The actual
distribution is unknown and thus cannot be used for inference.

{pstd}
You may consider using information criteria to choose between the standard and
the zero-inflated models; see
{mansection R zipRemarksandexamplesex2:example 2} in {bf:[R] zip}.


{title:References}

{marker G1994}{...}
{phang}
Greene, W. H.  1994.
Accounting for excess zeros and sample selection in Poisson and negative
binomial regression models.  Working paper EC-94-10, Department of Economics,
Stern School of Business, New York University.
{browse "https://ideas.repec.org/p/ste/nystbu/94-10.html"}.

{marker V1989}{...}
{phang}
Vuong, Q. H.  1989.
Likelihood ratio tests for model selection and non-nested hypotheses.
{it:Econometrica} 57: 307-333.

{marker W2015}{...}
{phang}
Wilson, P.  2015.
The misuse of the Vuong test for non-nested models to test for zero-inflation.
{it:Economics Letters} 127: 51-53.
{p_end}
