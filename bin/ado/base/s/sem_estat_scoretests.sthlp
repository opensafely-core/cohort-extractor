{smcl}
{* *! version 1.0.9  25sep2018}{...}
{viewerdialog estat "dialog sem_estat, message(-scoretests-) name(sem_estat_scoretests)"}{...}
{vieweralsosee "[SEM] estat scoretests " "mansection SEM estatscoretests"}{...}
{findalias assembequal}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] sem postestimation" "help sem_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] estat ginvariant" "help sem_estat_ginvariant"}{...}
{vieweralsosee "[SEM] estat mindices" "help sem_estat_mindices"}{...}
{viewerjumpto "Syntax" "sem_estat_scoretests##syntax"}{...}
{viewerjumpto "Menu" "sem_estat_scoretests##menu"}{...}
{viewerjumpto "Description" "sem_estat_scoretests##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_estat_scoretests##linkspdf"}{...}
{viewerjumpto "Option" "sem_estat_scoretests##option"}{...}
{viewerjumpto "Remarks" "sem_estat_scoretests##remarks"}{...}
{viewerjumpto "Examples" "sem_estat_scoretests##examples"}{...}
{viewerjumpto "Stored results" "sem_estat_scoretests##results"}{...}
{viewerjumpto "References" "sem_estat_scoretests##references"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[SEM] estat scoretests} {hline 2}}Score tests{p_end}
{p2col:}({mansection SEM estatscoretests:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {cmdab:score:tests} [{cmd:,} {opt min:chi2(#)}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Testing and CIs > Score tests of linear constraints}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat scoretests} is for use after {cmd:sem} but not {cmd:gsem}.

{pstd}
{cmd:estat scoretests} displays score tests  (Lagrange multiplier tests) for
each of the user-specified linear constraints imposed on the model when it was
fit.  See {help sem_estat scoretests##Sorbom1989:S{c o:}rbom (1989)} and
{help sem_estat scoretests##Wooldridge2010:Wooldridge (2010}, 421-428).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM estatscoretestsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}{opt minchi2(#)}
suppresses output of tests with chi2(1) < {it:#}.
By default, {cmd:estat mindices} lists values significant at the 0.05 level,
corresponding to chi-squared value {cmd:minchi2(3.8414588)}.  Specify 
{cmd:minchi2(0)} if you wish to see all tests. 


{marker remarks}{...}
{title:Remarks}

{pstd}
See {findalias sembequal}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_sm1}{p_end}
{phang2}{cmd:. sem (r_occasp <- f_occasp@b1 r_intel@b2 r_ses@b3 f_ses@b4)}{break}
	{cmd: (f_occasp <- r_occasp@b1 f_intel@b2 f_ses@b3 r_ses@b4),}{break}
	{cmd: cov(e.r_occasp*e.f_occasp)}{p_end}

{pstd}Compute score tests{p_end}
{phang2}{cmd:. estat scoretests}{p_end}

{pstd}Display all score tests{p_end}
{phang2}{cmd:. estat scoretests, minchi2(0)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat scoretests} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N_groups)}}number of groups{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(nobs)}}sample size for each group{p_end}
{synopt:{cmd:r(Cns_sctest)}}matrix containing the displayed table values{p_end}
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
