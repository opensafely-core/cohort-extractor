{smcl}
{* *! version 1.0.9  25sep2018}{...}
{viewerdialog estat "dialog sem_estat, message(-residuals-) name(sem_estat_residuals)"}{...}
{vieweralsosee "[SEM] estat residuals " "mansection SEM estatresiduals"}{...}
{findalias assemmimic}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] sem postestimation" "help sem_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] estat eqgof" "help sem_estat_eqgof"}{...}
{vieweralsosee "[SEM] estat ggof" "help sem_estat_ggof"}{...}
{vieweralsosee "[SEM] estat gof" "help sem_estat_gof"}{...}
{viewerjumpto "Syntax" "sem_estat_residuals##syntax"}{...}
{viewerjumpto "Menu" "sem_estat_residuals##menu"}{...}
{viewerjumpto "Description" "sem_estat_residuals##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_estat_residuals##linkspdf"}{...}
{viewerjumpto "Options" "sem_estat_residuals##options"}{...}
{viewerjumpto "Remarks" "sem_estat_residuals##remarks"}{...}
{viewerjumpto "Examples" "sem_estat_residuals##examples"}{...}
{viewerjumpto "Stored results" "sem_estat_residuals##results"}{...}
{viewerjumpto "References" "sem_estat_residuals##references"}{...}
{p2colset 1 26 24 2}{...}
{p2col:{bf:[SEM] estat residuals} {hline 2}}Display mean and covariance residuals{p_end}
{p2col:}({mansection SEM estatresiduals:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {cmdab:res:iduals} [{cmd:,} {it:options}]

{synoptset 22}{...}
{synopthdr}
{synoptline}
{synopt:{opt norm:alized}}report normalized residuals{p_end}
{synopt:{opt stand:ardized}}report standardized residuals{p_end}
{synopt:{opt sam:ple}}use sample covariances in residual variance calculations{p_end}
{synopt :{opt nm1}}use adjustment {it:N}-1 in residual variance calculations{p_end}
{synopt:{opt zero:tolerance(tol)}}apply tolerance to treat residuals
as 0{p_end}
{synopt:{opth for:mat(%fmt)}}display format{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Goodness of fit > Matrices of residuals}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat residuals} is for use after {cmd:sem} but not {cmd:gsem}.

{pstd}
{cmd:estat residuals} displays the mean and covariance residuals.
Normalized and standardized residuals are available.

{pstd}
Both mean and covariance residuals are reported unless {cmd:sem}'s option 
{opt nomeans} was specified or implied at the time the model was fit, in
which case mean residuals are not reported. 

{pstd}
{cmd:estat residuals} usually does not work following {cmd:sem} models fit
with {cmd:method(mlmv)}.  It also does not work if there are any missing
values, which after all is the whole point of using {cmd:method(mlmv)}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM estatresidualsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt normalized} and {opt standardized} are alternatives.  If neither is
specified, raw residuals are reported.

{p 8 8 2}
Normalized residuals and standardized residuals attempt to adjust the
residuals in the same way, but they go about it differently.  The normalized
residuals are always valid, but they do not follow a standard normal
distribution.  The standardized residuals do follow a standard normal
distribution but only if they can be calculated; otherwise, they will equal
missing values.  When both can be calculated (equivalent to both being
appropriate), the normalized residuals will be a little smaller than the
standardized residuals.  See
{help sem_estat_residuals##Joreskog1986:J{c o:}reskog and S{c o:}rbom (1986)}.

{phang}
{opt sample} specifies that the sample variance and covariances be used in
variance formulas to compute normalized and standardized residuals.  The
default uses fitted variance and covariance values as described by
{help sem_estat_residuals##Bollen1989:Bollen (1989)}.

{phang}
{opt nm1} specifies that the variances be computed using N-1 in the
denominator rather than using sample size N.

{phang}
{opt zerotolerance(tol)} treats residuals within {it:tol} of
0 as if they were 0.  {it:tol} must be a numeric value less than 1.
The default is {cmd:zerotolerance(0)}, meaning that no tolerance is applied.
When standardized residuals cannot be calculated, it is because a
variance calculated by the
{help sem estat_residuals##Hausman1978:Hausman (1978)} theorem turns negative.
Applying a tolerance to the residuals turns some residuals into 0 and then
division by the negative variance becomes irrelevant, and that may be enough to
solve the calculation problem.

{phang}
{opth format(%fmt)} specifies the display format.  The default is
{cmd:format(%9.3f)}.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {findalias semmimic}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_mimic1}{p_end}
{phang2}{cmd:. sem (SubjSES -> s_income s_occpres s_socstat)}{break}
	{cmd: (SubjSES <- income occpres)}{p_end}

{pstd}Display raw mean and covariance residuals{p_end}
{phang2}{cmd:. estat residuals}{p_end}

{pstd}Include normalized and standardized residuals{p_end}
{phang2}{cmd:. estat residuals, normalized standardized}{p_end}

{pstd}Use sample covariances and adjustment N-1 in calculations{p_end}
{phang2}{cmd:. estat residuals, normalized standardized sample nm1}{p_end}

{pstd}Treat residuals less than 1e-6 as zero{p_end}
{phang2}{cmd:. estat residuals, normalized standardized zerotolerance(1e-6)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat residuals} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N_groups)}}number of groups{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(sample)}}empty or {opt sample}, if {opt sample} was specified{p_end}
{synopt:{cmd:r(nm1)}}empty or {opt nm1}, if {opt nm1} was specified{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(nobs)}}sample size for each group{p_end}
{synopt:{cmd:r(res_mean}[{cmd:_}{it:#}]{cmd:)}}raw mean residuals (for group
{it:#}) (*){p_end}
{synopt:{cmd:r(res_cov}[{cmd:_}{it:#}]{cmd:)}}raw covariance residuals (for group {it:#}){p_end}
{synopt:{cmd:r(nres_mean}[{cmd:_}{it:#}]{cmd:)}}normalized mean residuals (for
group {it:#}) (*){p_end}
{synopt:{cmd:r(nres_cov}[{cmd:_}{it:#}]{cmd:)}}normalized covariance residuals (for group {it:#}){p_end}
{synopt:{cmd:r(sres_mean}[{cmd:_}{it:#}]{cmd:)}}standardized mean residuals
(for group {it:#}) (*){p_end}
{synopt:{cmd:r(sres_cov}[{cmd:_}{it:#}]{cmd:)}}standardized covariance residuals (for group {it:#}){p_end}
{p2colreset}{...}

{p 4 8 2}
(*) If there are no estimated means or intercepts in the {cmd:sem} model,
these matrices are not returned.  
{p_end}


{marker references}{...}
{title:References}

{marker Bollen1989}{...}
{phang}
Bollen, K. A. 1989.  {it:Structural Equations with Latent Variables}.  New
York: Wiley.

{marker Hausman1978}{...}
{phang}
Hausman, J. A.  1978.  Specification tests in econometrics. {it:Econometrica}
46: 1251-1271.

{marker Joreskog1986}{...}
{phang}
J{c o:}eskog, K. G., and D. S{c o:}rbom.  1986.
{it:LISREL VI: Analysis of linear structural relationships by the method}
{it:of maximum likelihood}.
Mooresville, IN: Scientific Software.
{p_end}
