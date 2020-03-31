{smcl}
{* *! version 1.0.4  15mar2019}{...}
{viewerdialog predict "dialog predict"}{...}
{vieweralsosee "[ERM] predict advanced" "mansection ERM predictadvanced"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ERM] eintreg postestimation" "help eintreg postestimation"}{...}
{vieweralsosee "[ERM] eintreg predict" "help eintreg predict"}{...}
{vieweralsosee "[ERM] eoprobit postestimation" "help eoprobit postestimation"}{...}
{vieweralsosee "[ERM] eoprobit predict" "help eoprobit predict"}{...}
{vieweralsosee "[ERM] eprobit postestimation" "help eprobit postestimation"}{...}
{vieweralsosee "[ERM] eprobit predict" "help eprobit predict"}{...}
{vieweralsosee "[ERM] eregress postestimation" "help eregress postestimation"}{...}
{vieweralsosee "[ERM] eregress predict" "help eregress predict"}{...}
{viewerjumpto "Syntax" "erm_predict_advanced##syntax"}{...}
{viewerjumpto "Description" "erm_predict_advanced##description"}{...}
{viewerjumpto "Links to PDF documentation" "erm_predict_advanced##linkspdf"}{...}
{viewerjumpto "Options" "erm_predict_advanced##options"}{...}
{viewerjumpto "Examples" "erm_predict_advanced##examples"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[ERM] predict advanced} {hline 2}}predict's advanced features{p_end}
{p2col:}({mansection ERM predictadvanced:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:predict} {dtype} {newvar}
{ifin}
[{cmd:,}
{help erm_predict_treatment##treatstatistic:{it:treatstatistic}}
{help eregress_predict##howcalculated_options:{it:howcalculated}}
{help erm_predict_treatment##treatmodifier:{it:treatmodifier}}
{help erm_predict_treatment##oprobitmodifier:{it:oprobitmodifier}}
{help erm_predict_advanced##advanced:{it:advanced}}]

{pstd}
In some cases, more than one new variable needs to be specified:

{p 8 16 2}
{cmd:predict} {dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {help varlist:{it:newvarlist}}{c )-}
{ifin}
[{cmd:,} {help erm_predict_treatment##treatstatistic:{it:treatstatistic}}
{help eregress_predict##howcalculated_options:{it:howcalculated}}
{help erm_predict_treatment##treatmodifier:{it:treatmodifier}}
{help erm_predict_treatment##oprobitmodifier:{it:oprobitmodifier}}
{help erm_predict_advanced##advanced:{it:advanced}}]

{pstd}
With the exception of {it:advanced}, you have seen this syntax
in the other {cmd:predict} manual entries.  We will not cover
old ground.

{marker advanced}{...}
{synoptset 20}{...}
{synopthdr:advanced}
{synoptline}
{synopt :{opt eq:uation(depvar)}}calculate results for specified dependent
variable{p_end}
{synopt :{opt nooff:set}}ignore option {opt offset()} specified when model was
fit in making calculation{p_end}
{synopt :{opt pr(a, b)}}calculate Pr(a < xb + e_i.{it:depvar} < b); 
      {it:a} and {it:b} are numbers or variable names{p_end}
{synopt :{opt e(a, b)}}calculate E(y_i | a < y_i < b), where 
	y_i = xb + e_i.{it:depvar}; {it:a} and {it:b} are numbers or 
	variable names{p_end}
{synopt :{opt expm:ean}}calculate E{c -(}exp(y_i){c )-}{p_end}
{synopt :{opt scores}}calculate equation-level score variables for
cross-sectional models and parameter-level score variables for
panel data models{p_end}
{synoptline}

{pstd}
Also note that even though option {cmd:mean} was not included in
{it:treatstatistic} for {cmd:eprobit}, {cmd:eoprobit}, {cmd:xteprobit}, and
{cmd:xteoprobit} it is allowed with them.  {cmd:mean} returns the probability
of a positive outcome after {cmd:eprobit} and {cmd:xteprobit} and returns the
expected value of the outcome after {cmd:eoprobit} and {cmd:xteoprobit}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:predict}'s features are documented in 

            {manhelp eregress_predict ERM:eregress predict}
            {manhelp eintreg_predict ERM:eintreg predict}
            {manhelp eprobit_predict ERM:eprobit predict}
            {manhelp eoprobit_predict ERM:eoprobit predict}
            {manhelp erm_predict_treatment ERM:predict treatment}

{pstd}
     Here, we document {cmd:predict}'s advanced features.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ERM predictadvancedRemarksandexamples:Remarks and examples}

        {mansection ERM predictadvancedMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt equation(depvar)} specifies the dependent variable for which predictions
are to be calculated.  By default, predictions are made for the dependent
variable of the main equation.

{phang}
{opt nooffset} is relevant only if you specified {opt offset()} when you fit
the model.  It modifies the calculations made by {opt predict} so that they
ignore the offset variable. 

{phang}
{opt pr(a, b)}
calculates 
Pr({it:a} < {bf:x}_i beta + e_i.{it:depvar} < {it:b}), 
the probability that the linear prediction is between
{it:a} and {it:b}.  

{pmore}
{it:a} and {it:b} may be specified as numbers or variable names.  If {it:a} is
missing ({it:a}{ul:>}{cmd:.}), then {it:a} is treated as -infinity.    If
{it:b} is missing ({it:b}{ul:>}{cmd:.}), then {it:b} is treated as +infinity.  

{phang}
{opt e(a, b)} calculates E(y_i | {it:a} < y_i < {it:b}), where
y_i = {bf:x}_i beta+e_i.{it:depvar}.  This is the linear prediction
conditional on the outcome being between {it:a} and {it:b}.  

{pmore}
{it:a} and {it:b} may be specified as numbers or variable names.  If {it:a} is
missing ({it:a}{ul:>}{cmd:.}), then {it:a} is treated as -infinity.    If
{it:b} is missing ({it:b}{ul:>}{cmd:.}), then {it:b} is treated as +infinity.

{phang}
{cmd:expmean}
calculates the mean of the exponentiated outcome.  

{phang}
{opt scores} 
calculates equation-level scores for cross-sectional models ({cmd:eintreg},
{cmd:eoprobit}, {cmd:eprobit}, and {cmd:eregress}) and parameter-level scores
for panel-data models ({cmd:xteintreg}, {cmd:xteoprobit}, {cmd:xteprobit}, and
{cmd:xteregress}).   
{p_end}


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}
{cmd:. webuse womenhlth}{p_end}
{phang2}
{cmd:. eoprobit health i.exercise c.grade, entreat(insured = grade i.workschool) select(select = i.insured i.regcheck) vce(robust)}

{pstd}
Predict the probability of having insurance{p_end}
{phang2}
{cmd:. predict prinsur, pr equation(insured)}{p_end}

{pstd}
Predict the equation-level scores{p_end}
{phang2}
{cmd:. predict sc*, scores}{p_end}
