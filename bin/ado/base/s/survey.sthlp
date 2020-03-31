{smcl}
{* *! version 1.1.11  24jan2019}{...}
{vieweralsosee "[SVY] Survey" "mansection SVY Survey"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{vieweralsosee "[SVY] svyset" "help svyset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _robust" "help _robust"}{...}
{viewerjumpto "Description" "survey##description"}{...}
{viewerjumpto "Links to PDF documentation" "survey##linkspdf"}{...}
{viewerjumpto "Examples" "survey##examples"}{...}
{viewerjumpto "Video examples" "survey##video"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[SVY] Survey} {hline 2}}Introduction to survey commands
{p_end}
{p2col:}({mansection SVY Survey:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Stata's facilities for survey data are centered around the {cmd:svy} prefix
command.  This overview organizes and presents the commands conceptually, that
is, according to the similarities in the functions that they perform.


{p2colset 5 37 39 2}{...}
{pstd}
{bf:Survey design tools}

{p2col :{manhelp svyset SVY}}Declare survey design for dataset{p_end}
{p2col :{manhelp svydescribe SVY}}Describe survey data{p_end}


{pstd}
{bf:Survey data analysis tools}

{p2col :{manhelp svy SVY}}The survey prefix command{p_end}
{p2col :{manhelp svy_estimation SVY:svy estimation}}Estimation commands for survey data{p_end}
{p2col :{manhelp svy_tabulate_oneway SVY:svy: tabulate oneway}}One-way tables for survey data{p_end}
{p2col :{manhelp svy_tabulate_twoway SVY:svy: tabulate twoway}}Two-way tables for survey data{p_end}
{p2col :{manhelp svy_postestimation SVY:svy postestimation}}Postestimation tools for svy{p_end}
{p2col :{manhelp estat_svy SVY:estat}}Postestimation statistics for survey data, such as
design effects{p_end}
{p2col :{manhelp svy_bootstrap SVY:svy bootstrap}}Bootstrap for survey data{p_end}
{p2col :{manhelpi bootstrap_options SVY}}More options for bootstrap variance
        estimation{p_end}
{p2col :{manhelp svy_brr SVY:svy brr}}Balanced repeated replication for survey data{p_end}
{p2col :{manhelpi brr_options SVY}}More options for BRR variance
        estimation{p_end}
{p2col :{manhelp svy_jackknife SVY:svy jackknife}}Jackknife estimation for survey data{p_end}
{p2col :{manhelpi jackknife_options SVY}}More options for jackknife variance
        estimation{p_end}
{p2col :{manhelp svy_sdr SVY:svy sdr}}Successive difference replication for survey data{p_end}
{p2col :{manhelpi sdr_options SVY}}More options for SDR variance
        estimation{p_end}


{pstd}
{bf:Survey data concepts}

{p2col :{manlink SVY Variance estimation}}Variance estimation for survey data{p_end}
{p2col :{manlink SVY Subpopulation estimation}}Subpopulation estimation for survey data{p_end}
{p2col :{manlink SVY Calibration}}Calibration for survey data{p_end}
{p2col :{manlink SVY Direct standardization}}Direct standardization of means, proportions,
and ratios{p_end}
{p2col :{manlink SVY Poststratification}}Poststratification for survey data{p_end}


{pstd}
{bf:Tools for programmers of new survey commands}{p_end}

{p2col :{manlink SVY ml for svy}}Maximum pseudolikelihood estimation for survey data{p_end}
{p2col :{manhelp svymarkout SVY}}Mark
	observation for exclusion on the basis of survey characteristics{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SVY SurveyRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse multistage}{p_end}

{pstd}Declare the data to be complex survey data{p_end}
{phang2}{cmd:. svyset county [pw=sampwgt], strata(state) fpc(ncounties)}
             {cmd: || school, fpc(nschools)}{p_end}

{pstd}Estimate the average weight of high school seniors in our
population{p_end}
{phang2}{cmd:. svy: mean weight, over(sex)}{p_end}

{pstd}Test the hypothesis that the average male is 30 pounds heavier than the
average female{p_end}
{phang2}{cmd:. test weight#1.sex - weight#2.sex = 30}{p_end}


{marker video}{...}
{title:Video examples}

{phang2}{browse "https://www.youtube.com/watch?v=0DRXnoR-Q1c":Basic introduction to the analysis of complex survey data in Stata}

{phang2}{browse "https://www.youtube.com/watch?v=CUFr3CDM-4g":How to download, import, and merge multiple datasets from the NHANES website}

{phang2}{browse "https://www.youtube.com/watch?v=lRTl8GKsZTE":How to download, import, and prepare data from the NHANES website}
{p_end}
