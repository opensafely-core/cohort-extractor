{smcl}
{* *! version 1.0.8  19oct2017}{...}
{viewerdialog lrtest "dialog lrtest"}{...}
{vieweralsosee "[SEM] lrtest " "mansection SEM lrtest"}{...}
{findalias assemmimic}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] estat eqtest" "help sem_estat_eqtest"}{...}
{vieweralsosee "[SEM] estat stdize" "help sem_estat_stdize"}{...}
{vieweralsosee "[SEM] test" "help sem_test"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] lrtest" "help lrtest"}{...}
{viewerjumpto "Syntax" "sem_lrtest##syntax"}{...}
{viewerjumpto "Menu" "sem_lrtest##menu"}{...}
{viewerjumpto "Description" "sem_lrtest##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_lrtest##linkspdf"}{...}
{viewerjumpto "Remarks" "sem_lrtest##remarks"}{...}
{viewerjumpto "Examples" "sem_lrtest##examples"}{...}
{viewerjumpto "Stored results" "sem_lrtest##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[SEM] lrtest} {hline 2}}Likelihood-ratio test of linear
hypothesis{p_end}
{p2col:}({mansection SEM lrtest:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

        {c -(}{cmd:sem}|{cmd:gsem}{c )-} ...{cmd:,} ...{right:(fit model 1)       }

{phang2}{cmd:estimates store} {it:modelname1}

        {c -(}{cmd:sem}|{cmd:gsem}{c )-} ...{cmd:,} ...{right:(fit model 2)       }

{phang2}{cmd:estimates store} {it:modelname2}

        {cmd:lrtest} {it:modelname1} {it:modelname2}{right:(compare models)       }

{phang}
where one of the models is constrained and the other is unconstrained.
{cmd:lrtest} counts parameters to determine
which model is constrained and which is unconstrained, so it does not matter
which model is which.


{pstd}
Warning concerning use with {cmd:sem}:
Do not omit variables, observed or latent, from the model.  Constrain their
coefficients to be 0 instead.  The models being compared must contain
the same set of variables.  This is because the standard SEM
likelihood value is a function of the variables appearing in the model.
Despite this fact, use of {cmd:lrtest} is appropriate under the relaxed
conditional normality assumption.

{pstd}
Note concerning {cmd:gsem}:  The above warning does not apply to {cmd:gsem}
just as it does not apply to other Stata estimation commands.  Whether you
omit variables or constrain coefficients to 0, results will be the same.  The
generalized SEM likelihood is conditional on the exogenous variables.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Testing and CIs > Likelihood-ratio tests}


{marker description}{...}
{title:Description}

{pstd}    
{cmd:lrtest} is a postestimation command for use after {cmd:sem},
{cmd:gsem}, and other Stata estimation commands.

{pstd}    
{cmd:lrtest} performs a likelihood-ratio test comparing models. 
See {helpb lrtest:[R] lrtest}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM lrtestRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}
    
{pstd}
See {findalias semmimic} and {findalias gsemtlevel}.

{pstd}
When using {cmd:lrtest} after {cmd:sem}, you must be careful that the models
being compared have the same observed and latent variables.  For instance, the
following is allowed:


{phang2}{cmd:. sem (L1 -> x1 x2 x3) (L1 <- x4 x5) (x1 <- x4) (x2 <- x5)}{p_end}

{phang2}{cmd:. estimates store m1}{p_end}

{phang2}{cmd:. sem (L1 -> x1 x2 x3) (L1 <- x4 x5)}{p_end}

{phang2}{cmd:. estimates store m2}{p_end}

{phang2}{cmd:. lrtest m1 m2}{p_end}

{pstd}
This is allowed because both models contain the same variables, namely,
{cmd:L1}, {cmd:x1}, ..., {cmd:x5}, even though the second model omitted som
paths.  

{pstd}
The following would produce invalid results:
    
{phang2}{cmd:. sem (L1 -> x1 x2 x3) (L1 <- x4 x5) (x1 <- x4) (x2 <- x5)}{p_end}

{phang2}{cmd:. estimates store m1}{p_end}

{phang2}{cmd:. sem (L1 -> x1 x2 x3) (L1 <- x4)}{p_end}

{phang2}{cmd:. estimates store m2}{p_end}

{phang2}{cmd:. lrtest m1 m2}{p_end}

{pstd}
It produces invalid results because the second model does not include variable
{cmd:x5} and the first model does.   To run this test correctly, you type 

   
{phang2}{cmd:. sem (L1 -> x1 x2 x3) (L1 <- x4 x5) (x1 <- x4) (x2 <- x5)}{p_end}

{phang2}{cmd:. estimates store m1}{p_end}

{phang2}{cmd:. sem (L1 -> x1 x2 x3) (L1 <- x4 x5@0)}{p_end}

{phang2}{cmd:. estimates store m2}{p_end}

{phang2}{cmd:. lrtest m1 m2}{p_end}

{pstd}
If we were using {cmd:gsem} rather than {cmd:sem}, all the above would
still be valid.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_mimic1}{p_end}

{pstd}Fit reduced model{p_end}
{phang2}{cmd:. sem (SubjSES -> s_income s_occpres s_socstat)}{break}
	{cmd: (SubjSES <- income occpres)}{p_end}

{pstd}Store results{p_end}
{phang2}{cmd:. estimates store mimic1}{p_end}

{pstd}Fit full model{p_end}
{phang2}{cmd:. sem (SubjSES -> s_income s_occpres s_socstat)}{break}
	{cmd: (SubjSES <- income occpres) (s_income <- income)}{break}
	{cmd: (s_occpres <- occpres)}{p_end}

{pstd}Perform likelihood-ratio test{p_end}
{phang2}{cmd:. lrtest mimic1 .}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_melanoma}{p_end}

{pstd}Fit a three-level negative binomial model{p_end}
{phang2}{cmd:. gsem (deaths <- uv M1[nation] M2[nation>region]),}{break}
 	{cmd:nbreg exposure(expected)}{p_end}

{pstd}Store results{p_end}
{phang2}{cmd:. estimates store nbreg}

{pstd}Fit a three-level Poisson model{p_end}
{phang2}{cmd:. gsem (deaths <- uv M1[nation] M2[nation>region]),}{break} 
        {cmd:poisson exposure(expected)}{p_end}

{pstd}Perform likelihood-ratio test{p_end}
{phang2}{cmd:. lrtest nbreg .}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {it:{help lrtest##results:Stored results}} in
{helpb lrtest:[R] lrtest}.
{p_end}
