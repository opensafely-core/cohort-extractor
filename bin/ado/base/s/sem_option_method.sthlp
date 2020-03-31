{smcl}
{* *! version 1.0.9  14may2018}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] sem option method()" "mansection SEM semoptionmethod()"}{...}
{findalias assemmlmv}{...}
{vieweralsosee "[SEM] Intro 4" "mansection SEM Intro4"}{...}
{vieweralsosee "[SEM] Intro 8" "mansection SEM Intro8"}{...}
{vieweralsosee "[SEM] Intro 9" "mansection SEM Intro9"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{viewerjumpto "Syntax" "sem_option_method##syntax"}{...}
{viewerjumpto "Description" "sem_option_method##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_option_method##linkspdf"}{...}
{viewerjumpto "Options" "sem_option_method##options"}{...}
{viewerjumpto "Remarks" "sem_option_method##remarks"}{...}
{viewerjumpto "Examples" "sem_option_method##examples"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[SEM] sem option method()} {hline 2}}Specifying method and
calculation of VCE{p_end}
{p2col:}({mansection SEM semoptionmethod():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:sem} ... [{cmd:,} ... {opt method(method)} {opt vce(vcetype)} ...] 

{marker method}{...}
{synoptset 30}{...}
{synopthdr:method}
{p2line}
{p2col :{opt ml}}maximum likelihood; the default{p_end}
{p2col :{opt mlmv}}{opt ml} with missing values{p_end}
{p2col :{opt adf}}asymptotic distribution free{p_end}
{p2line}

{marker vcetype}{...}
{synoptset 30}{...}
{synopthdr:vcetype}
{p2line}
{p2col :{opt oim}}observed information matrix; the default{p_end}
{p2col :{opt eim}}expected information matrix{p_end}
{p2col :{opt opg}}outer product of gradients{p_end}
{p2col :{opt sbentler}}Satorra-Bentler estimator{p_end}
{p2col :{opt r:obust}}Huber/White/sandwich estimator{p_end}
{synopt :{cmdab:cl:uster} {it:clustvar}}generalized Huber/White/sandwich estimator{p_end}
{synopt :{cmdab:boot:strap} [{cmd:,} {it:{help bootstrap:bootstrap_options}}]}bootstrap estimation{p_end}
{synopt :{cmdab:jack:knife} [{cmd:,} {it:{help jackknife:jackknife_options}}]}jackknife estimation{p_end}
{p2line}
{p 4 6 2}
{cmd:pweight}s and {cmd:iweight}s are not allowed with {cmd:sbentler}.
{p_end}

{phang}
The following combinations of {opt method()} and {opt vce()} are allowed:

           {c |} {cmd:oim}   {cmd:eim}   {cmd:opg}  {cmd:sbentler}  {cmd:robust}  {cmd:cluster}  {cmd:bootstrap}  {cmd:jackknife}
      {hline 5}{c +}{hline 65}
      {cmd:ml}   {c |}   x     x     x      x        x       x         x         x
      {cmd:mlmv} {c |}   x     x     x               x       x         x         x
      {cmd:adf}  {c |}   x     x                                       x         x
      {hline 5}{c BT}{hline 65}


{marker description}{...}
{title:Description}

{pstd}
{cmd:sem} option {opt method()} specifies the method used to obtain the
estimated parameters.

{pstd}
{cmd:sem} option {opt vce()} specifies the technique used to obtain the
variance-covariance matrix of the estimates (VCE), which includes the reported
standard errors.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM semoptionmethod()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth method:(sem_option_method##method:method)} specifies the method used to
obtain parameter estimates.  {cmd:method(ml)} is the default.

{phang}
{opth vce:(sem_option_method##vcetype:vcetype)} specifies the technique used to
obtain the VCE.  {cmd:vce(oim)} is the default.

  
{marker remarks}{...}
{title:Remarks}

{pstd}
See {manlink SEM Intro 4} for more information on the maximum-likelihood and
asymptotic distribution-free estimation methods.  

{pstd}
{manlink SEM Intro 8} provides an overview of robust and cluster-robust
standard errors while {manlink SEM Intro 9} discusses all other methods of
estimating standard errors.  

{pstd}
Note that when {cmd:vce(sbentler)} is specified, the Satorra-Bentler scaled
chi-squared test is reported in addition to the corresponding robust standard
errors.  The Satorra-Bentler scaled chi-squared test adjusts the
model-versus-saturated test to be robust to nonnormal data.   See
{manlink SEM Example 1}, Satorra-Bentler scaled chi-squared test.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse cfa_missing}{p_end}

{pstd}Fit a CFA model using maximum likelihood{p_end}
{phang2}{cmd:. sem (test1 test2 test3 test4 <- X), method(ml)}{p_end}

{pstd}Compute robust standard errors{p_end}
{phang2}{cmd:. sem (test1 test2 test3 test4 <- X), method(ml) vce(robust)}{p_end}

{pstd}Report Satorra-Bentler scaled chi-squared test and standard
errors{p_end}
{phang2}{cmd:. sem (test1 test2 test3 test4 <- X), method(ml) vce(sbentler)}

{pstd}Fit model using FIML: treat missing values as missing at random{p_end}
{phang2}{cmd:. sem (test1 test2 test3 test4 <- X), method(mlmv)}{p_end}

{pstd}Fit model using the asymptotic distribution free method{p_end}
{phang2}{cmd:. sem (test1 test2 test3 test4 <- X), method(adf)}{p_end}
