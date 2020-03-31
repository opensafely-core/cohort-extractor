{smcl}
{* *! version 1.0.4  19oct2017}{...}
{viewerdialog teffects "dialog teffects"}{...}
{vieweralsosee "[TE] teffects multivalued" "mansection TE teffectsmultivalued"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects" "help teffects"}{...}
{viewerjumpto "Description" "teffects multivalued##description"}{...}
{viewerjumpto "Links to PDF documentation" "teffects_multivalued##linkspdf"}{...}
{viewerjumpto "Remarks" "teffects multivalued##remarks"}{...}
{viewerjumpto "Examples" "teffects multivalued##examples"}{...}
{viewerjumpto "References" "teffects multivalued##references"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[TE] teffects multivalued} {hline 2}}Multivalued treatment
effects{p_end}
{p2col:}({mansection TE teffectsmultivalued:View complete PDF manual entry}){p_end}


{marker description}{...}
{title:Description}

{pstd}
This entry discusses the use of {cmd:teffects} when the treatment is
multivalued.  This entry presumes you are already familiar with the
potential-outcome framework and the use of the {cmd:teffects} commands with
binary treatments.  See 
{bf:{mansection TE teffectsintro:[TE] teffects intro}} or
{bf:{mansection TE teffectsintroadvanced:[TE] teffects intro advanced}}
for more information.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE teffectsmultivaluedRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks: Introduction}

{pstd}
When the treatment is binary, each subject could either receive the treatment
or not receive the treatment.  In contrast, multivalued treatments refer to
cases in which each subject could receive one of several different treatments
or else not receive treatment at all.  For example, in testing the efficacy of
a drug, a patient could receive a 10 milligram (mg) dose, a 20 mg dose, a
30 mg dose, or no dose at all.  We first want to be able to compare a patient
receiving the 10 mg dose with a patient receiving no dose, a patient receiving
the 20 mg dose with a patient receiving no dose, and a patient receiving the
30 mg dose with a patient receiving no dose.  Once we can make those
comparisons, we can then, for example, compare the efficacy of a 30 mg dose
with that of a 20 mg dose or a 10 mg dose.

{pstd}
To highlight an example in economics, we consider an unemployed person who could
participate in a comprehensive skills training program, attend a one-day
workshop that helps job seekers write their resum{'e}s, or choose not to
participate in either.  We want to know how effective each of those programs
is relative to not participating; once we know that, we can then compare
the effectiveness of the comprehensive program with that of the one-day
program. 

{pstd}
Multivalued treatments increase the number of parameters that must be
estimated and complicate the notation.  Fortunately, however, using the
{cmd:teffects} commands is not much more difficult with multivalued treatments
than with binary treatments.  

{pstd}
You can use {cmd:teffects ra}, {cmd:teffects ipw}, {cmd:teffects ipwra}, and
{cmd:teffects aipw} to estimate multivalued treatment effects.  However, the
theory developed in Abadie and Imbens
({help teffects multivalued##AI2006:2006},
 {help teffects multivalued##AI2012:2012}) has
not been extended to handle multivalued treatments, so you cannot use
{cmd:teffects nnmatch} or {cmd:teffects psmatch} in these cases.

{pstd}
{help teffects multivalued##C2010:Cattaneo (2010)},
{help teffects multivalued##I2000:Imbens (2000)}, and
{help teffects multivalued##W2010:Wooldridge (2010, sec. 21.6.3)}
discuss aspects of treatment-effect estimation with multivalued treatments.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse bdsianesi5}

{pstd}Obtain ATEs and base-level potential outcome using RA with a Poisson
model to account for nonnegative wages (variable {cmd:ed} represents four
treatment levels){p_end}
{phang2}{cmd:. teffects ra (wage london eastern paed math7, poisson) (ed)}

{pstd}Same as above, using the AIPW estimator{p_end}
{phang2}{cmd:. teffects aipw (wage london eastern paed math7, poisson)}
    {cmd:(ed math7 read7 maed paed)}

{pstd}Same as above, reporting all four POMs rather than the three ATEs{p_end}
{phang2}{cmd:. teffects aipw (wage london eastern paed math7, poisson)}
       {cmd:(ed math7 read7 maed paed), pomeans}

{pstd}Obtain estimated ATEs{p_end}
{phang2}{cmd:. contrast r.ed, nowald}


{marker references}{...}
{title:References}

{marker AI2006}{...}
{phang}
Abadie, A., and G. W. Imbens.  2006.  Large sample properties of matching
estimators for average treatment effects.
{it:Econometrica} 74: 235-267.

{marker AI2012}{...}
{phang}
------. 2012. Matching on the estimated propensity score. Harvard University
and National Bureau of Economic Research.
{browse "http://www.hks.harvard.edu/fs/aabadie/pscore.pdf"}.

{marker C2010}{...}
{phang}
Cattaneo, M. D. 2010. Efficient semiparametric estimation of multi-valued
treatment effects under ignorability.
{it:Journal of Econometrics} 155: 138-154.

{marker I2000}{...}
{phang}
Imbens, G. W. 2000. The role of the propensity score in estimating
dose-response functions. {it:Biometrika} 87: 706-710.

{marker W2010}{...}
{phang}
Wooldridge, J. M. 2010.
{browse "http://www.stata.com/bookstore/cspd.html":{it:Econometric Analysis of Cross Section and Panel Data}}.
2nd ed. Cambridge, MA: MIT Press.
{p_end}
