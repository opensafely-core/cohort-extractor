{smcl}
{* *! version 1.0.0  17may2019}{...}
{vieweralsosee "[CM]" "mansection CM"}{...}
{viewerjumpto "Description" "cm##description"}{...}
{viewerjumpto "Resources" "cm##resources"}{...}
{p2colset 1 7 9 2}{...}
{p2col:{bf:cm} {hline 2}}Introduction to choice models{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Choice models (CM) are models for data with outcomes that are choices.  The
choices are selected by a decision maker, such as a person or a business, from
a set of possible alternatives.  For instance, we could model choices made by
consumers who select a breakfast cereal from several different brands.  Or we
could model choices made by businesses who chose whether to buy TV, radio,
Internet, or newspaper advertising.

{pstd}
Models for choice data come in two varieties -- models for discrete choices
and models for rank-ordered alternatives.  When each individual selects a
single alternative, say, he or she purchases one box of cereal, the data are
discrete choice data.  When each individual ranks the choices, say, he or she
orders cereals from most favorite to least favorite, the data are rank-ordered
data.  Stata has commands for fitting both discrete choice models and
rank-ordered models.


{marker resources}{...}
{title:Resources}

{pstd}
If you are new to choice models, see the introductions in the following manual 
entries:{p_end}

{synoptset 33}{...}
{synoptline}
{synopt :{manlink CM Intro 1}}Interpretation of choice models{p_end}
{synopt :{manlink CM Intro 2}}Data layout{p_end}
{synopt :{manlink CM Intro 3}}Descriptive statistics{p_end}
{synopt :{manlink CM Intro 4}}Estimation commands{p_end}
{synopt :{manlink CM Intro 5}}Models for discrete choices{p_end}
{synopt :{manlink CM Intro 6}}Models for rank-ordered alternatives{p_end}
{synopt :{manlink CM Intro 7}}Models for panel data{p_end}
{synopt :{manlink CM Intro 8}}Random utility models, assumptions, and estimation{p_end}
{synoptline}

{pstd}
Before you fit a model with one of the {cmd:cm} commands, you will need to
{cmd:cmset} your data.{p_end}

{synoptline}
{synopt :{helpb cmset:[CM] cmset}}Declare data to be choice model data{p_end}
{synoptline}

{pstd}
If you are already familiar with choice models, see the following help files
to explore using specialized commands for computing summary statistics for
choice model data:{p_end}

{synoptline}
{synopt :{helpb cmchoiceset:[CM] cmchoiceset}}Tabulate choice sets{p_end}
{synopt :{helpb cmsample:[CM] cmsample}}Display reasons for sample exclusion{p_end}
{synopt :{helpb cmsummarize:[CM] cmsummarize}}Summarize variables by chosen alternatives{p_end}
{synopt :{helpb cmtab:[CM] cmtab}}Tabulate chosen alternatives{p_end}
{synoptline}

{pstd}
See the following help files for descriptions of the commands for fitting
choice models:{p_end}

{synoptline}
{synopt :{helpb cmclogit:[CM] cmclogit}}Conditional logit (McFadden’s) choice model{p_end}
{synopt :{helpb cmmixlogit:[CM] cmmixlogit}}Mixed logit choice model{p_end}
{synopt :{helpb cmmprobit:[CM] cmmprobit}}Multinomial probit choice model{p_end}
{synopt :{helpb cmrologit:[CM] cmrologit}}Rank-ordered logit choice model{p_end}
{synopt :{helpb cmroprobit:[CM] cmroprobit}}Rank-ordered probit choice model{p_end}
{synopt :{helpb cmxtmixlogit:[CM] cmxtmixlogit}}Panel-data mixed logit choice model{p_end}
{synopt :{helpb nlogit:[CM] nlogit}}Nested logit regression{p_end}
{synoptline}

{pstd}
See the following help files for descriptions of the commands available after
fitting choice models:{p_end}

{synoptline}
{synopt :{helpb cm_margins:[CM] margins}}Adjusted predictions, predictive margins, and marginal effects{p_end}

{synopt :{helpb cmclogit_postestimation:[CM] cmclogit postestimation}}Postestimation tools for cmclogit{p_end}
{synopt :{helpb cmmixlogit_postestimation:[CM] cmmixlogit postestimation}}Postestimation tools for cmmixlogit{p_end}
{synopt :{helpb cmmprobit_postestimation:[CM] cmmprobit postestimation}}Postestimation tools for cmmprobit{p_end}
{synopt :{helpb cmrologit_postestimation:[CM] cmrologit postestimation}}Postestimation tools for cmrologit{p_end}
{synopt :{helpb cmroprobit_postestimation:[CM] cmroprobit postestimation}}Postestimation tools for cmroprobit{p_end}
{synopt :{helpb cmxtmixlogit_postestimation:[CM] cmxtmixlogit postestimation}}Postestimation tools for cmxtmixlogit{p_end}
{synopt :{helpb nlogit_postestimation:[CM] nlogit postestimation}}Postestimation tools for nlogit{p_end}
{synoptline}
