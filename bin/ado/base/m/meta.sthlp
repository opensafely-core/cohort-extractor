{smcl}
{* *! version 1.0.1  23oct2019}{...}
{vieweralsosee "[META] meta" "mansection META meta"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] Intro" "mansection META Intro"}{...}
{viewerjumpto "Description" "meta##description"}{...}
{viewerjumpto "Examples" "meta##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[META] meta} {hline 2}}Introduction to meta{p_end}
{p2col:}({mansection META meta:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

    {c TLC}{hline 61}{c TRC}
    {c |} The {cmd:meta} command performs meta-analysis.  In a nutshell, {col 67}{c |}
    {c |} you can do the following: {col 67}{c |}
    {c |}{col 67}{c |}
    {c |}    1.  Compute or specify effect sizes; see{col 67}{c |}
    {c |}        {helpb meta esize:[META] meta esize} and {...}
{helpb meta set:[META] meta set}.{col 67}{c |}
    {c |}{col 67}{c |}
    {c |}    2.  Summarize meta-analysis data; see{col 67}{c |}
    {c |}        {helpb meta summarize:[META] meta summarize} and {...}
{helpb meta forestplot:[META] meta forestplot}.{col 67}{c |}
    {c |}{col 67}{c |}
    {c |}    3.  Perform meta-regression to address heterogeneity;{col 67}{c |}
    {c |}        see {helpb meta regress:[META] meta regress}.{col 67}{c |}
    {c |}{col 67}{c |}
    {c |}    4.  Explore small-study effects and publication bias;{col 67}{c |}
    {c |}        see {helpb meta funnelplot:[META] meta funnelplot}, {...}
{helpb meta bias:[META] meta bias}, and{col 67}{c |}
    {c |}        {helpb meta trimfill:[META] meta trimfill}.{col 67}{c |}
    {c BLC}{hline 61}{c BRC}


{pstd}
For software-free introduction to meta-analysis, see
{manhelp META Intro}.

{pstd}
Declare, update, and describe {help meta_glossary##meta_data:{bf:meta} data}

{p2colset 9 39 41 2}{...}
{p2col :{helpb meta data}}Declare meta-analysis data{p_end}
{p2col :{helpb meta esize}}Compute effect sizes and declare {cmd:meta} data{p_end}
{p2col :{helpb meta set}}Declare {cmd:meta} data using precalculated effect
sizes{p_end}
{p2col :{helpb meta update}}Update current settings of {cmd:meta} data{p_end}
{p2col :{helpb meta query}}Describe current settings of {cmd:meta} data{p_end}
{p2col :{helpb meta clear}}Clear current settings of {cmd:meta} data{p_end}

{pstd}
Summarize {cmd:meta} data by using a table

{p2col :{helpb meta summarize}}Summarize meta-analysis data{p_end}
{p2col :{mansection META metasummarizeRemarksandexamplesmsumexsubgr:{bf:meta summarize, subgroup()}}}Perform subgroup meta-analysis{p_end}
{p2col : {mansection META metasummarizeRemarksandexamplesmsumexcumul:{bf:meta summarize, cumulative()}}}Perform cumulative meta-analysis{p_end}

{pstd}
Summarize {cmd:meta} data by using a forest plot

{p2col :{helpb meta forestplot}}Produce meta-analysis forest plots{p_end}
{p2col :{mansection META metaforestplotRemarksandexamplesmfpexsubgrs:{bf:meta forestplot, subgroup()}}}Produce subgroup meta-analysis forest plots{p_end}
{p2col :{mansection META metaforestplotRemarksandexamplesmfpexcum:{bf:meta forestplot, cumulative()}}}Produce cumulative meta-analysis forest plots{p_end}

{pstd}
Explore heterogeneity and perform meta-regression 

{p2col :{helpb meta labbeplot}}Produce L'Abb{c e'} plots for binary
data{p_end}
{p2col :{helpb meta regress}}Perform meta-regression{p_end}
{p2col :{helpb estat bubbleplot}}Produce bubble plots after
meta-regression{p_end}

{pstd}
Explore and address small-study effects (funnel-plot asymmetry, publication
bias)

{p2col :{helpb meta funnelplot}}Produce funnel plots{p_end}
{p2col :{mansection META metafunnelplotRemarksandexamplesmfunexcontours:{bf:meta funnelplot, contours()}}}Produce contour-enhanced funnel plots{p_end}
{p2col :{helpb meta bias}}Test for small-study effects or funnel-plot asymmetry{p_end}
{p2col :{helpb meta trimfill}}Perform trim-and-fill analysis of publication bias{p_end}


{marker examples}{...}
{title:Examples}

{p 4 4 2}
Examples are presented under the following headings:
{p_end}

{phang2}
     {help meta##prep:Prepare data for meta-analysis}{p_end}
{phang2}
     {help meta##summary:Meta-analysis summary}{p_end}
{phang2}
     {help meta##subgroup:Subgroup meta-analysis}{p_end}
{phang2}
     {help meta##regress:Meta-regression}{p_end}
{phang2}
     {help meta##hetero:Small-study effects: Heterogeneity}{p_end}
{phang2}
     {help meta##pubbias:Small-study effects: Publication bias}{p_end}


{marker prep}{...}
{title:Prepare data for meta-analysis}

{pstd}Setup{p_end}
{phang2}
{cmd:. webuse pupiliq}
{p_end}

{pstd}Declare meta-analysis data using precomputed effect sizes and their
standard errors{p_end}
{phang2}
{cmd:. meta set stdmdiff se}
{p_end}


{marker summary}{...}
{title:Meta-analysis summary}

{p 4 4 2}
Obtain a standard meta-analysis summary{p_end}
{phang2}
{cmd:. meta summarize}
{p_end}

{pstd}Construct a forest plot{p_end}
{phang2}
{cmd:. meta forestplot}
{p_end}


{marker subgroup}{...}
{title:Subgroup meta-analysis}

{pstd}Obtain a subgroup meta-analysis summary for each category of {cmd:week1}{p_end}
{phang2}
{cmd:. meta summarize, subgroup(week1)}
{p_end}

{pstd}Construct a subgroup meta-analysis forest plot based on variable {cmd:week1}{p_end}
{phang2}
{cmd:. meta forestplot, subgroup(week1)}
{p_end}


{marker regress}{...}
{title:Meta-regression}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse bcg}{p_end}
{phang2}{cmd:. summarize latitude, meanonly}{p_end}
{phang2}{cmd:. generate double latitude_c = latitude - r(mean)}{p_end}

{pstd}Compute log risk-ratios and their standard errors, and declare meta data{p_end}
{phang2}
{cmd:. meta esize npost nnegt nposc nnegc, esize(lnrratio)}
{p_end}

{pstd}Perform meta-regression of the effect size on covariate {cmd:latitude_c}{p_end}
{phang2}
{cmd:. meta regress latitude_c}
{p_end}

{pstd}Construct a bubble plot{p_end}
{phang2}
{cmd:. estat bubbleplot}
{p_end}


{marker hetero}{...}
{title:Small-study effects: Heterogeneity}

{pstd}Setup{p_end}
{phang2}
{cmd:. webuse pupiliqset}
{p_end}
{phang2}
{cmd:. meta query}
{p_end}

{pstd}Construct a funnel plot{p_end}
{phang2}
{cmd:. meta funnelplot}
{p_end}

{pstd}Test for funnel-plot asymmetry using the Egger regression-based
test{p_end}
{phang2}
{cmd:. meta bias, egger}
{p_end}

{pstd}Adjust for heterogeneity due to {cmd:week1}{p_end}
{phang2}
{cmd:. meta funnelplot, by(week1)}
{p_end}
{phang2}
{cmd:. meta bias i.week1, egger}
{p_end}


{marker pubbias}{...}
{title:Small-study effects: Publication bias}

{pstd}Setup{p_end}
{phang2}
{cmd:. webuse nsaids}
{p_end}

{pstd}Compute log odds-ratios and their standard errors, and declare meta data{p_end}
{phang2}
{cmd:. meta esize nstreat nftreat nscontrol nfcontrol}
{p_end}

{pstd}Construct a funnel plot{p_end}
{phang2}
{cmd:. meta funnelplot}
{p_end}

{pstd}Test for funnel-plot asymmetry using the Harbord regression-based test{p_end}
{phang2}
{cmd:. meta bias, harbord}
{p_end}

{pstd}Perform the trim-and-fill analysis of publication bias, and report the
results as odds ratios{p_end}
{phang2}
{cmd:. meta trimfill, eform}
{p_end}
