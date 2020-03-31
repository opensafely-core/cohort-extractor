{smcl}
{* *! version 1.0.3  15mar2019}{...}
{viewerdialog predict "dialog predict"}{...}
{vieweralsosee "[ERM] predict treatment" "mansection ERM predicttreatment"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ERM] eintreg postestimation" "help eintreg postestimation"}{...}
{vieweralsosee "[ERM] eintreg predict" "help eintreg predict"}{...}
{vieweralsosee "[ERM] eoprobit postestimation" "help eoprobit postestimation"}{...}
{vieweralsosee "[ERM] eoprobit predict" "help eoprobit predict"}{...}
{vieweralsosee "[ERM] eprobit postestimation" "help eprobit postestimation"}{...}
{vieweralsosee "[ERM] eprobit predict" "help eprobit predict"}{...}
{vieweralsosee "[ERM] eregress postestimation" "help eregress postestimation"}{...}
{vieweralsosee "[ERM] eregress predict" "help eregress predict"}{...}
{viewerjumpto "Syntax" "erm_predict_treatment##syntax"}{...}
{viewerjumpto "Description" "erm_predict_treatment##description"}{...}
{viewerjumpto "Links to PDF documentation" "erm_predict_treatment##linkspdf"}{...}
{viewerjumpto "Options" "erm_predict_treatment##options"}{...}
{viewerjumpto "Examples" "erm_predict_treatment##examples"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[ERM] predict treatment} {hline 2}}predict for treatment
statistics{p_end}
{p2col:}({mansection ERM predicttreatment:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
You previously fit a model by using the {cmd:entreat()} or 
{cmd:extreat()} option, 

        {cmd:eregress     y    x1} ...{cmd:,} ... {cmd:entreat(treated =} ...) ...
        {cmd:eintreg    yl yu  x1} ...{cmd:,} ... {cmd:entreat(treated =} ...) ... 
        {cmd:eprobit      y    x1} ...{cmd:,} ... {cmd:entreat(treated =} ...) ... 
        {cmd:eoprobit     y    x1} ...{cmd:,} ... {cmd:entreat(treated =} ...) ... 
        {cmd:xteregress   y    x1} ...{cmd:,} ... {cmd:entreat(treated =} ...) ...
        {cmd:xteintreg  yl yu  x1} ...{cmd:,} ... {cmd:entreat(treated =} ...) ... 
        {cmd:xteprobit    y    x1} ...{cmd:,} ... {cmd:entreat(treated =} ...) ... 
        {cmd:xteoprobit   y    x1} ...{cmd:,} ... {cmd:entreat(treated =} ...) ... 

        {cmd:eregress     y    x1} ...{cmd:,} ... {cmd:extreat(treated)} ...
        {cmd:eintreg    yl yu  x1} ...{cmd:,} ... {cmd:extreat(treated)} ...
        {cmd:eprobit      y    x1} ...{cmd:,} ... {cmd:extreat(treated)} ...
        {cmd:eoprobit     y    x1} ...{cmd:,} ... {cmd:extreat(treated)} ...
        {cmd:xteregress   y    x1} ...{cmd:,} ... {cmd:extreat(treated)} ...
        {cmd:xteintreg  yl yu  x1} ...{cmd:,} ... {cmd:extreat(treated)} ...
        {cmd:xteprobit    y    x1} ...{cmd:,} ... {cmd:extreat(treated)} ...
        {cmd:xteoprobit   y    x1} ...{cmd:,} ... {cmd:extreat(treated)} ...

{pstd}
In these cases, {cmd:predict} has extra features.  {cmd:predict}'s
extra syntax for these features is 

{p 8 16 2}
{cmd:predict} {dtype} {newvar}
{ifin}{cmd:,}
{helpb erm_predict_treatment##treatstatistic:{it:treatstatistic}}
[{help erm_predict_treatment##treatmodifier:{it:treatmodifier}}
{help erm_predict_treatment##oprobitmodifier:{it:oprobitmodifier}}]

{pstd}
In some cases, more than one new variable needs to be specified:

{p 8 16 2}
{cmd:predict} {dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {help varlist:{it:newvarlist}}{c )-}
{ifin}{cmd:,}
{helpb erm_predict_treatment##treatstatistic:{it:treatstatistic}}
[{help erm_predict_treatment##treatmodifier:{it:treatmodifier}}
{help erm_predict_treatment##oprobitmodifier:{it:oprobitmodifier}}]

{marker treatstatistic}{...}
{synoptset 20}{...}
{synopthdr:treatstatistic}
{synoptline}
{synopt :{opt pom:ean}}potential-outcome mean (POM){p_end}
{synopt :{opt te}}treatment effect (TE){p_end}
{synopt :{opt tet}}treatment effect on the treated (TET){p_end}
{synoptline}

{marker treatmodifier}{...}
{synopthdr:treatmodifier}
{synoptline}
{synopt :{opt tl:evel(#)}}treatment level for which 
{help erm_predict_treatment##treatstatistic:{it:treatstatistic}} is 
		 calculated{p_end}
{synoptline}

{p 4 6 2}
{it:#} may be specified as a value recorded in variable {cmd:treated}, 
such as 1, 2, ... or such as 1, 5, ..., depending on the values 
recorded.

{p 4 6 2}
{it:#} may also be specified as {cmd:#1}, {cmd:#2}, ..., meaning
the first, second, ... values recorded in {cmd:treated}.

{marker oprobitmodifier}{...}
{synopthdr:oprobitmodifier}
{synoptline}
{synopt :{opt outl:evel(#)}}ordered outcome for which 
{help erm_predict_treatment##treatstatistic:{it:treatstatistic}}
		 is calculated{p_end}
{synoptline}

{p 4 6 2}
When used after models fit with {cmd:eoprobit} or {cmd:xteoprobit},
{it:treatstatistic} is calculated for the specified outcome, or for the first
outcome if you do not specify otherwise.

{p 4 6 2}
{opt outlevel(#)} specifies the outcome for which
statistics are to be calculated.  {it:#} is specified in the same
way as with {opt tlevel()}, but the meaning is different.  In the
case of {opt outlevel()}, you are specifying the outcome, not the
treatment level.


{marker description}{...}
{title:Description}

{pstd}
{cmd:predict} has options to predict potential-outcome means,
treatment effects, and treatment effects on the treated after
models fit using the {cmd:entreat()} or {cmd:extreat()}
option.  The {cmd:predict} options are described below.

{pstd}
For standard use of {cmd:predict}, see

            {manhelp eregress_predict ERM:eregress predict}
            {manhelp eintreg_predict ERM:eintreg predict}
            {manhelp eprobit_predict ERM:eprobit predict}
            {manhelp eoprobit_predict ERM:eoprobit predict}

{pstd}
For advanced use of {cmd:predict}, see

            {manhelp erm_predict_advanced ERM:predict advanced}

{pstd}
Also see {manhelp erm_estat_teffects ERM:estat teffects} for reports of
average treatment statistics.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ERM predicttreatmentRemarksandexamples:Remarks and examples}

        {mansection ERM predicttreatmentMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}
The options for the statistic to be calculated -- {cmd:pomean},
{cmd:te}, and {cmd:tet} -- are mutually exclusive.  You calculate one
treatment statistic per {cmd:predict} command.

{phang}
{opt pomean} calculates the POMs for each treatment level.  The POMs are the
expected value of {cmd:y} that would have been observed if everyone was
assigned to each of the treatment levels.

{pmore}
If there were two treatment levels (a control and a treatment), 
you would type

{phang3}
{cmd:. predict pom1 pom2, pomean}

{pmore}
If there were three levels, you would type 

{phang3}
{cmd:. predict pom1 pom2 pom3, pomean}

{pmore}
{cmd:pomean} can alternatively be used with {cmd:tlevel()} to
produce individual POMs:

{phang3}
{cmd:. predict pom1, pomean tlevel(#1)}{p_end}
{phang3}
{cmd:. predict pom2, pomean tlevel(#2)}

{pmore}
If you have fit the model using {cmd:eoprobit} or {cmd:xteoprobit}, the POMs
calculated for the examples above would be for {cmd:y}'s first outcome.  You
can change that.  See
{mansection ERM predicttreatmentRemarksandexamplesPredictingtreatmenteffectsaftereoprobitandxteoprobit:{it:Predicting treatment effects after eoprobit and xteoprobit}}
in {bf:[ERM] predict treatment}.

{phang}
{cmd:te}
calculates the TEs for each treatment level.  The TEs are the differences in
the POMs.  For instance, if there were two treatment levels -- a control and a
treatment -- there would be one treatment effect and it would be
{cmd:pom2-pom1}.  If there were three levels, there would be two treatment
effects, {cmd:pom2-pom1} and {cmd:pom3-pom1}.

{pmore}
If there were two treatment levels -- a control and a treatment -- you would
type

{phang3}
{cmd:. predict te2, te}

{pmore}
If there were three levels, you would type 

{phang3}
{cmd:. predict te2 te3, te}

{pmore}
{opt te} can alternatively be used with {cmd:tlevel()} to
produce individual TEs:

{phang3}
{cmd:. predict te2, te tlevel(#2)}{p_end}
{phang3}
{cmd:. predict te3, te tlevel(#3)}

{pmore}
If you have fit the model using {cmd:eoprobit} or {cmd:xteoprobit}, the TEs
calculated for the examples above would be for {cmd:y}'s first outcome.  You
can change that.  See
{mansection ERM predicttreatmentRemarksandexamplesPredictingtreatmenteffectsaftereoprobitandxteoprobit:{it:Predicting treatment effects after eoprobit and xteoprobit}}
in {bf:[ERM] predict treatment}.

{phang}
{opt tet} calculates the TETs.  The TETs are the differences in the POMs
conditioned on treatment level.

{pmore}
If there were two treatment levels -- a control and a
treatment -- you would type

{phang3}
{cmd:. predict tet2, tet}

{pmore}
If there were three levels, you would type

{phang3}
{cmd:. predict tet2 tet3, tet}

{pmore}
{opt tet} can alternatively be used with {opt tlevel()} to
produce individual TETs:

{phang3}
{cmd:. predict tet2, tet tlevel(#2)}{p_end}
{phang3}
{cmd:. predict tet3, tet tlevel(#3)}

{pmore}
If you have fit the model using {cmd:eoprobit} or {cmd:xteoprobit}, the
TETs calculated for the examples above would be for {cmd:y}'s
first outcome.  You can change that.  See 
{mansection ERM predicttreatmentRemarksandexamplesPredictingtreatmenteffectsaftereoprobitandxteoprobit:{it:Predicting treatment effects after eoprobit and xteoprobit}}
in {bf:[ERM] predict treatment}.

{phang}
{opt tlevel(#)} 
is optionally used with {cmd:pomean}, {cmd:te}, or {cmd:tet}.
Its use is illustrated above.

{phang}
{opt outlevel(#)} 
is optionally used with {cmd:pomean}, {cmd:te}, or {cmd:tet} with models fit
by {cmd:eoprobit} and {cmd:xteoprobit}.  See
{mansection ERM predicttreatmentRemarksandexamplesPredictingtreatmenteffectsaftereoprobitandxteoprobit:{it:Predicting treatment effects after eoprobit and xteoprobit}}
in {bf:[ERM] predict treatment}.
{p_end}


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}
{cmd:. webuse wellness}{p_end}
{phang2}
{cmd:. eprobit lost4 age i.sex, endogenous(weight = i.sex gym) entreat(wellpgm = age i.smoke, nointeract) select(completed = i.wellpgm experience i.salaried) vce(robust)}

{pstd}
Predict the treatment effect for each observation{p_end}
{phang2}
{cmd:. predict te, te}{p_end}

{pstd}
Estimate potential-outcome means for each treatment level{p_end}
{phang2}
{cmd:. predict pom1 pom2, pomean}{p_end}
