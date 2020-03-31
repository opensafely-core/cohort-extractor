{smcl}
{* *! version 1.0.0  21jun2019}{...}
{viewerdialog "meta" "dialog meta"}{...}
{vieweralsosee "[META] estat bubbleplot" "mansection META estatbubbleplot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta regress" "help meta regress"}{...}
{vieweralsosee "[META] meta regress postestimation" "help meta regress postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta" "help meta"}{...}
{vieweralsosee "[META] Glossary" "help meta glossary"}{...}
{vieweralsosee "[META] Intro" "mansection META Intro"}{...}
{viewerjumpto "Syntax" "estat_bubbleplot##syntax"}{...}
{viewerjumpto "Menu" "estat_bubbleplot##menu"}{...}
{viewerjumpto "Description" "estat_bubbleplot##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_bubbleplot##linkspdf"}{...}
{viewerjumpto "Options" "estat_bubbleplot##options"}{...}
{viewerjumpto "Examples" "estat_bubbleplot##examples"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[META] estat bubbleplot} {hline 2}}Bubble plots after meta regress{p_end}
{p2col:}({mansection META estatbubbleplot:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:estat} {cmdab:bubble:plot}
{ifin}
[{cmd:,} {it:options}]

{marker optstbl}{...}
{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt reweight:ed}}make bubble size depend on random-effects weights{p_end}
{synopt :[{cmd:no}]{opt reg:line}}display or suppress the regression line{p_end}
{synopt :[{cmd:no}]{cmd:ci}}display or suppress the confidence intervals{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is as declared for meta-analysis{p_end}
{synopt :{opt n(#)}}evaluate CI lines at {it:#} points; default is {cmd:n(100)}{p_end}

{syntab:Fitted line}
{synopt :{opth lineop:ts(line_options)}}affect rendition of the plotted regression line{p_end}

{syntab:CI plot}
{synopt :{opth ciop:ts(estat_bubbleplot##ciopts:ciopts)}}affect rendition of the plotted CI band{p_end}

{syntab:Add plots}
{synopt :{opth addplot:(addplot_option:plot)}}add other plots to the bubble plot{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in {manhelp twoway_options G-3:twoway_options}{p_end}
{synoptline}


INCLUDE help menu_meta


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat bubbleplot} produces bubble plots after simple meta-regression with
one continuous moderator performed by using {helpb meta regress}.  The bubble
plot is a scatterplot of effect sizes against a
{help meta_glossary##moderator:moderator} of interest overlaid with the
predicted regression line and confidence-interval bands.  In a bubble plot,
the marker sizes, "bubbles", are proportional to study weights.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection META estatbubbleplotQuickstart:Quick start}

        {mansection META estatbubbleplotRemarksandexamples:Remarks and examples}

        {mansection META estatbubbleplotMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt reweighted} is used with random-effects meta-regression. It specifies
that the sizes of the bubbles be proportional to the weights from the
random-effects meta-regression, w_j = 1/(σ^_j + τ^2). By default, the sizes
are proportional to the precision of each study, w_j = 1/σ^2_j.

{phang}
{opt regline} and {opt noregline} display or suppress the rendition of the
regression line.  The default, {cmd:regline}, is to display the regression
line.  Option {cmd:noregline} implies option {cmd:noci}.

{phang}
{opt ci} and {opt noci} display or suppress confidence intervals.  The
default, {cmd:ci}, is to display them.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals.  The default is as declared for the meta-analysis session; see
{mansection META metadataRemarksandexamplesDeclaringaconfidencelevelformeta-analysis:{it:Declaring a confidence level for meta-analysis}}
in {bf:[META] meta data}.  Also see option
{helpb meta_set##level:level()} in {helpb meta_set:[META] meta set}.

{phang}
{opt n(#)} specifies the number of points at which to evaluate the CIs.  The
default is {cmd:n(100)}.

{dlgtab:Fitted line}

{phang}
{opt lineopts(line_options)} affects the rendition of the plotted regression
line; see {manhelp line_options G-3}.

{dlgtab:CI plot}

{marker ciopts}{...}
{phang}
{opt ciopts(ciopts)} affects the rendition of the CI band in the bubble plot.
{it:ciopts} are any options as defined in
{helpb twoway_rline:[G-2] graph twoway rline} and option
{cmd:recast(rarea)} as described in {manhelpi advanced_options G-3}.

{dlgtab:Add plots}
 
{phang} 
{opt addplot(plot)} allows adding more {cmd:graph twoway} plots to the graph;
see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}
   
{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {cmd:by()}.  These include options
for titling the graph (see {manhelpi title_options G-3}) and for saving the
graph to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse bcgset}{p_end}
{phang2}{cmd:. meta regress latitude_c}

{pstd}Construct a bubble plot{p_end}
{phang2}{cmd:. estat bubbleplot}

{pstd}Construct a bubble plot with a 90% confidence interval{p_end}
{phang2}{cmd:. estat bubbleplot, level(90)}

{pstd}Specify that study-marker sizes be proportional to the weights from the
random-effects meta-regression{p_end}
{phang2}{cmd:. estat bubbleplot, reweighted}
{p_end}
