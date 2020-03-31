{smcl}
{* *! version 1.0.5  05feb2020}{...}
{vieweralsosee "[SP]" "mansection SP"}{...}
{viewerjumpto "Description" "sp_intro##description"}{...}
{viewerjumpto "Resources" "sp_intro##resources"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:Sp introduction }{hline 2}}Introduction to Sp{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The Sp commands manage data and fit regressions accounting for spatial
relationships.  Sp fits SAR models that include spatial lags of dependent 
and independent variables with spatial autoregressive errors on lattice 
and areal data, which includes nongeographic data such as social network 
nodes.{p_end}

{pstd}
Different fields use different jargon for spatial concepts.  SAR stands for
(take your pick) spatial autoregressive or simultaneous autoregressive.{p_end}


{marker resources}{...}
{title:Resources}

{pstd}
If you are new to the Sp commands, these eight short introductions will turn 
you into an expert on the Sp software.{p_end}

{synoptset 31}{...}
{synoptline}
{synopt :{manlink SP Intro}}Introduction to spatial data and SAR models{p_end}
{synopt :{manlink SP Intro 1}}A brief introduction to SAR models{p_end}
{synopt :{manlink SP Intro 2}}The W matrix{p_end}
{synopt :{manlink SP Intro 3}}Preparing data for analysis{p_end}
{synopt :{manlink SP Intro 4}}Preparing data: Data with shapefiles{p_end}
{synopt :{manlink SP Intro 5}}Preparing data: Data containing locations (no shapefiles){p_end}
{synopt :{manlink SP Intro 6}}Preparing data: Data without shapefiles or locations{p_end}
{synopt :{manlink SP Intro 7}}Example from start to finish{p_end}
{synopt :{manlink SP Intro 8}}The Sp estimation commands{p_end}
{synoptline}

{pstd} 
If you are already familiar with Sp, see the following help files for 
descriptions of the commands for preparing data, examining data, and fitting
and interpreting SAR models:{p_end}


{pstd}Preparing data{p_end}
{synoptline}
{synopt :{helpb zipfile:[D] zipfile}}Compress and uncompress files in zip archive format{p_end}
{synopt :{helpb spshape2dta:[SP] spshape2dta}}Translate shapefile to Stata format{p_end}
{synopt :{helpb spset:[SP] spset}}Declare data to be Sp spatial data{p_end}
{synopt :{helpb spbalance:[SP] spbalance}}Make panel data strongly balanced{p_end}
{synopt :{helpb spcompress:[SP] spcompress}}Compress Stata-format shapefile{p_end}
{synoptline}


{pstd}Looking at data{p_end}
{synoptline}
{synopt :{helpb grmap:[SP] grmap}}Graph choropleth maps{p_end}
{synopt :{helpb spdistance:[SP] spdistance}}Calculator for distance between places{p_end}
{synoptline}


{pstd}Setting the spatial weighting matrix{p_end}
{synoptline}
{synopt :{helpb spmatrix:[SP] spmatrix}}Create, manipulate, and import/export weighting matrices{p_end}
{synopt :{helpb spgenerate:[SP] spgenerate}}Generate spatial lag variables{p_end}
{synoptline}


{pstd}Fitting models{p_end}
{synoptline}
{synopt :{helpb spregress:[SP] spregress}}Fit cross-sectional SAR models{p_end}
{synopt :{helpb spivregress:[SP] spivregress}}Fit cross-sectional SAR models with endogenous covariates{p_end}
{synopt :{helpb spxtregress:[SP] spxtregress}}Fit panel-data SAR models{p_end}
{synoptline}


{pstd}Postestimation{p_end}
{synoptline}
{synopt :{helpb estat_moran:[SP] estat moran}}Moran's test after regress{p_end}
{synopt :{helpb spregress_postestimation:[SP] spregress postestimation}}Postestimation tools for spregress{p_end}
{synopt :{helpb spivregress_postestimation:[SP] spivregress postestimation}}Postestimation tools for spivregress{p_end}
{synopt :{helpb spxtregress_postestimation:[SP] spxtregress postestimation}}Postestimation tools for spxtregress{p_end}
{synoptline}
{p2colreset}{...}
