{smcl}
{* *! version 1.0.7  11feb2011}{...}
{vieweralsosee "[R] glm" "help glm"}{...}
{vieweralsosee "[R] binreg" "help binreg"}{...}
{title:How are AIC and BIC computed after {cmd:glm} and {cmd:binreg}?}

{pstd}
{cmd:glm} and {cmd:binreg, ml} use the following formulas to compute the
values of AIC and BIC:

{phang2}
        AIC = (-2lnL + 2k)/N
{p_end}	
{phang2}
	BIC = D2 - (N-k)ln(N)
{p_end}

{pstd}
where lnL and D2 are the overall likelihood and the overall deviance, reported
by {cmd:glm}, k is the number of parameters of the model, and N-k is the
degrees of freedom associated with the deviance D2.  These formulas are from 
{help j_glmic##A1973:Akaike (1973)} and
{help j_glmic##R1995:Raftery (1995)}, respectively.

{pstd}
{cmd:estat ic} and {cmd:estimates table, stats(aic bic)} use different
definitions of these criteria on the basis of 
{help j_glmic##A1974:Akaike (1974)} and
{help j_glmic##S1978:Schwarz (1978)}:

{phang2}
        AIC = -2lnL + 2k
{p_end}	
{phang2}
        BIC = -2lnL + kln(N)
{p_end}

{pstd}
They thus report different AIC and BIC values. 


{title:References}

{marker A1973}{...}
{phang}
Akaike, H. 1973.  
Information theory and an extension of the maximum likelihood principle.  In
{it:Second International Symposium on Information Theory}, ed. B. N. Petrov
and F. Csaki, 267-281.  
Budapest:  Akailseoniai-Kiudo.{p_end}

{marker A1974}{...}
{phang}
------. 1974.  
A new look at the statistical model identification.  
{it:IEEE Transactions on Automatic Control} 19: 716-723.{p_end}

{marker R1995}{...}
{phang}
Raftery, A. 1995.  
Bayesian model selection in social research.  
In Vol. 25 of {it:Sociological Methodology}, ed. P. V. Marsden, 111-163.
Oxford: Blackwell.{p_end}

{marker S1978}{...}
{phang}
Schwarz, G. 1978.  
Estimating the dimension of a model.  
{it:Annals of Statistics} 6: 461-464.
{p_end}
