{smcl}
{* *! version 1.1.4  25sep2018}{...}
{viewerdialog estat "dialog sem_estat, message(-ginvariant-) name(sem_estat_ginvariant)"}{...}
{vieweralsosee "[SEM] estat ginvariant " "mansection SEM estatginvariant"}{...}
{findalias assemginv}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] sem postestimation" "help sem_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] estat mindices" "help sem_estat_mindices"}{...}
{vieweralsosee "[SEM] estat scoretests" "help sem_estat_scoretests"}{...}
{viewerjumpto "Syntax" "sem_estat_ginvariant##syntax"}{...}
{viewerjumpto "Menu" "sem_estat_ginvariant##menu"}{...}
{viewerjumpto "Description" "sem_estat_ginvariant##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_estat_ginvariant##linkspdf"}{...}
{viewerjumpto "Options" "sem_estat_ginvariant##options"}{...}
{viewerjumpto "Remarks" "sem_estat_ginvariant##remarks"}{...}
{viewerjumpto "Examples" "sem_estat_ginvariant##examples"}{...}
{viewerjumpto "Stored results" "sem_estat_ginvariant##results"}{...}
{viewerjumpto "References" "sem_estat_ginvariant##references"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[SEM] estat ginvariant} {hline 2}}Test for invariance of
	parameters across groups{p_end}
{p2col:}({mansection SEM estatginvariant:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {cmdab:gin:variant} [{cmd:,} {it:options}]

{synoptset 24}{...}
{synopthdr}
{synoptline}
{synopt:{opt showp:class(pclassname)}}restrict output to parameters in the specified parameter class{p_end}
{synopt:{opt cla:ss}}include joint tests for parameter classes{p_end}
{synopt:{opt leg:end}}include legend describing parameter classes{p_end}
{synoptline}
{p2colreset}{...}

{marker pclassname}{...}
{synoptset 24}{...}
INCLUDE help sem_classnames
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Group statistics > Test invariance of parameters across groups}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat ginvariant} is for use after estimation with {cmd:sem,}
{opt group()};
see {helpb sem_group_options:[SEM] sem group options}.

{pstd}
{cmd:estat ginvariant} performs score tests (Lagrange multiplier tests) and
Wald tests of whether parameters constrained to be equal across groups
should be relaxed and whether parameters allowed to vary across groups
could be constrained.

{pstd}
See {help sem_estat_ginvariant##Sorbom1989:S{c o:}rbom (1989)} and
{help sem_estat_ginvariant##Wooldridge2010:Wooldridge (2010}, 421-428).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM estatginvariantRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth showpclass:(sem_estat_ginvariant##pclassname:pclassname)} displays tests
for the classes specified.  {cmd:showpclass(all)} is the default.

{phang}
{opt class} displays a table with joint tests for group invariance for each
of the nine parameter classes.

{phang}
{opt legend} displays a legend describing the parameter classes.  This option
may only be used with the {opt class} option.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {findalias semginv}.

{pstd}
Score tests are not available after {cmd:gsem}; therefore,
{cmd:estat ginvariant} is not for use after estimation with
{cmd:gsem, group()}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_2fmmby}{p_end}
{phang2}{cmd:. sem (Peer -> peerrel1 peerrel2 peerrel3 peerrel4)}{break}
	{cmd: (Par -> parrel1 parrel2 parrel3 parrel4), group(grade)}{p_end}

{pstd}Test for invariance of parameters across groups{p_end}
{phang2}{cmd:. estat ginvariant}{p_end}

{pstd}Include joint tests for parameter classes{p_end}
{phang2}{cmd:. estat ginvariant, class}{p_end}

{pstd}Only display measurement coefficients{p_end}
{phang2}{cmd:. estat ginvariant, showpclass(mcoef)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat ginvariant} stores the following in {cmd:r()}:

{synoptset 24 tabbed}{...}
{p2col 5 24 28 2: Scalars}{p_end}
{synopt:{cmd:r(N_groups)}}number of groups{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 24 28 2: Matrices}{p_end}
{synopt:{cmd:r(nobs)}}sample size for each group{p_end}
{synopt:{cmd:r(test)}}Wald and score tests{p_end}
{synopt:{cmd:r(test_pclass)}}parameter classes corresponding to {cmd:r(test)}{p_end}
{synopt:{cmd:r(test_class)}}joint Wald and score tests for each class{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker Sorbom1989}{...}
{phang}
S{c o:}rbom, D. 1989.  Model modification.  {it:Psychometrika} 54: 371-384.

{marker Wooldridge2010}{...}
{phang}
Wooldridge, J. M.  2010.  
{browse "http://www.stata.com/bookstore/cspd.html":{it:Econometric Analysis of Cross Section and Panel Data}}. 2nd ed.
Cambridge, MA: MIT Press.
{p_end}
