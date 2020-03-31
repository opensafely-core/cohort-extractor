{smcl}
{* *! version 1.0.12  25sep2018}{...}
{viewerdialog estat "dialog sem_estat, message(-teffects-) name(sem_estat_teffects)"}{...}
{vieweralsosee "[SEM] estat teffects " "mansection SEM estatteffects"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] sem postestimation" "help sem_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] estat stable" "help sem_estat_stable"}{...}
{viewerjumpto "Syntax" "sem_estat_teffects##syntax"}{...}
{viewerjumpto "Menu" "sem_estat_teffects##menu"}{...}
{viewerjumpto "Description" "sem_estat_teffects##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_estat_teffects##linkspdf"}{...}
{viewerjumpto "Options" "sem_estat_teffects##options"}{...}
{viewerjumpto "Remarks" "sem_estat_teffects##remarks"}{...}
{viewerjumpto "Examples" "sem_estat_teffects##examples"}{...}
{viewerjumpto "Stored results" "sem_estat_teffects##results"}{...}
{viewerjumpto "References" "sem_estat_teffects##references"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[SEM] estat teffects} {hline 2}}Decomposition of effects into
total, direct, and indirect{p_end}
{p2col:}({mansection SEM estatteffects:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:estat} {cmdab:tef:fects} [{cmd:,} {it:options}]

{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt:{opt comp:act}}do not display effects with no path{p_end}
{synopt:{opt stand:ardized}}report standardized effects{p_end}
{synopt :{opt nolab:el}}display group values, not labels{p_end}
{synopt :{opt nodir:ect}}do not display direct effects{p_end}
{synopt :{opt noindir:ect}}do not display indirect effects{p_end}
{synopt :{opt notot:al}}do not display total effects{p_end}

{synopt :{it:{help sem_estat_teffects##display_options:display_options}}}control columns and column formats, row spacing, and display of omitted paths{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Testing and CIs > Direct and indirect effects}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat teffects} is for use after {cmd:sem} but not {cmd:gsem}.

{pstd}
{cmd:estat teffects} reports direct, indirect, and total effects for
each path ({help sem_estat teffects##Sobel1987:Sobel 1987}), along with
standard errors obtained by the delta method.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM estatteffectsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}{opt compact}
is a popular option.  Consider the following model:

{phang2}{cmd:. sem (y1<-y2 x1) (y2<-x2)}{p_end}

{p 8 8 2}
{cmd:x2} has no direct effect on {cmd:y1} but does have an indirect effect.
{cmd:estat teffects} formats all its effects tables the same way by default,
so there will be a row for the direct effect of {cmd:x2} on {cmd:y1} just
because there is a row for the indirect effect of {cmd:x2} on {cmd:y1}.  The
value reported for the direct effect, of course, will be 0.  {opt compact}
says to omit these unnecessary rows.

{phang}{opt standardized}
reports effects in standardized form, but standard errors of the
standardized effects are not reported.

{phang}{opt nolabel}
is relevant only if estimation was with {cmd:sem}'s {opt group()}
option and the group variable has a value label.  Groups are identified by
group value rather than label.

{phang}{opt nodirect}, {opt noindirect}, and {opt nototal} suppress the
display of the indicated effect.  The default is to display all effects. 

{marker display_options}{...}
{phang} {it:display_options}: 
{opt noci},
{opt nopv:alues},
{opt noomit:ted},
{opt vsquish},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch}; see 
{helpb estimation options##display_options:[R] Estimation options}.
Although {cmd:estat teffects} is not an estimation command, it
allows these options.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {findalias semnrsm}.

{pstd}
Direct effects are the path coefficients in the model.

{pstd}
Indirect effects are all mediating effects.  For instance, consider

{phang2}{cmd:. sem ... (y1<-y2) (y1<-x2) (y2<-x3) ..., ...}{p_end}

{pstd}
The direct effect of {cmd:y2} on {cmd:y1} is the path coefficient
{cmd:(y1<-y2)}.

{pstd}
In this example, changes in {cmd:x3} affect {cmd:y1}, too.  That is called the
indirect effect and is the product of the path coefficients ({cmd:y2<-x3}) and
({cmd:y1<-y2}).  If there were other paths in the model such that {cmd:y1}
changed when {cmd:x3} changed, those effects would be added to the indirect
effect as well.  {cmd:estat teffects} reports total indirect effects.

{pstd}
The total effect is the sum of the direct and indirect effects.

{pstd}
When feedback loops are present in the model, such as

{phang2}{cmd:. sem ... (y1<-y2) (y1<-x2) (y2<-x3 y1) ..., ...}{p_end}

{pstd}
care must be taken when interpreting indirect effects.  The feedback loop is
when a variable indirectly affects itself, as {cmd:y1} does in the example;
{cmd:y1} affects {cmd:y2} and {cmd:y2} affects {cmd:y1}.  Thus in calculating
the indirect effect, the sum has an infinite number of terms although the term
values get smaller and smaller and thus usually converge to a finite result.
It is important that you check recursive models for stability; see
{help sem_estat_teffects##Bollen1989:Bollen (1989}, 379) and see
{helpb sem_estat_stable:[SEM] estat stable}.  Caution: if the model is
unstable, the calculation of the indirect effect can sometimes still converge
to a finite result.

{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_sm1}{p_end}
{phang2}{cmd:. sem (r_occasp <- f_occasp r_intel r_ses f_ses)}{break}
	{cmd: (f_occasp <- r_occasp f_intel f_ses r_ses),}{break}
	{cmd:  cov(e.r_occasp*e.f_occasp)}{p_end}

{pstd}Display total, direct, and indirect effects{p_end}
{phang2}{cmd:. estat teffects}{p_end}

{pstd}Display standardized effects{p_end}
{phang2}{cmd:. estat teffects, standardized}{p_end}

{pstd}Only show total effects{p_end}
{phang2}{cmd:. estat teffects, nodirect noindirect}{p_end}

{pstd}Omit effects with no paths{p_end}
{phang2}{cmd:. estat teffects, compact}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat teffects} stores the following in {cmd:r()}:

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt:{cmd:r(N_groups)}}number of groups{p_end}

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Matrices}{p_end}
{synopt:{cmd:r(nobs)}}sample size for each group{p_end}
{synopt:{cmd:r(direct)}}direct effects{p_end}
{synopt:{cmd:r(indirect)}}indirect effects{p_end}
{synopt:{cmd:r(total)}}total effects{p_end}
{synopt:{cmd:r(V_direct)}}covariance matrix of the direct effects{p_end}
{synopt:{cmd:r(V_indirect)}}covariance matrix of the indirect effects{p_end}
{synopt:{cmd:r(V_total)}}covariance matrix of the total effects{p_end}

{pstd}
{cmd:estat} {cmd:teffects} with the {opt standardized} option additionally
stores the following in {cmd:r()}:

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Matrices}{p_end}
{synopt:{cmd:r(direct_std)}}standardized direct effects{p_end}
{synopt:{cmd:r(indirect_std)}}standardized indirect effects{p_end}
{synopt:{cmd:r(total_std)}}standardized total effects{p_end}


{marker references}{...}
{title:References}

{marker Bollen1989}{...}
{phang}
Bollen, K. A. 1989.  {it:Structural Equations with Latent Variables}.  New
York: Wiley.

{marker Sobel1987}{...}
{phang}
Sobel, M. E.  1987.  Direct and indirect effect in linear structural equation
models.  {it:Sociological Methods and Research} 16: 155-176.
{p_end}
