{smcl}
{* *! version 1.0.2  23may2011}{...}
{title:Posterior parameters obtained using sampling with replacement} 

{pstd}
You specified the {cmd:bootstrap} option, which estimates the parameters of
the imputation model from a bootstrap sample of the observed data.  The
default method instead simulates the parameters from their joint posterior
distribution or from a normal approximation to the posterior distribution.
The bootstrap method may be an improvement over the default method when the
normal approximation is not as accurate
({help mi_boot_note##R2004:Royston 2004, sec. 5.1}), which may
be the case in small samples.  The {cmd:bootstrap} option may also be useful 
for handling perfect prediction during imputation of categorical data 
({help mi_boot_note##WDR2010:White, Daniel, and Royston 2010}).

{pstd}
For more information on bootstrap sampling, see {manhelp bsample R}.


{title:References}

{marker R2004}{...}
{phang}
Royston, P. 2004. 
    {browse "http://www.stata-journal.com/sjpdf.html?articlenum=st0067":Multiple imputation of missing values.}
    {it:Stata Journal} 4: 227-241.
{p_end}

{marker WDR2010}{...}
{phang}
White, I. R., R. Daniel, and P. Royston. 2010.  Avoiding bias due to perfect
prediction in multiple imputation of incomplete categorical data.  
{it:Computational Statistics & Data Analysis} 54: 2267-2275.
{p_end}
