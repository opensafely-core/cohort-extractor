{smcl}
{* *! version 1.0.4  11may2018}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spmatrix" "mansection SP spmatrix"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{viewerjumpto "Description" "spmatrix##description"}{...}
{p2colset 1 18 22 2}{...}
{p2col:{bf:[SP] spmatrix} {hline 2}}Categorical guide to the spmatrix
command{p_end}
{p2col:}({mansection SP spmatrix:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:spmatrix} command creates, imports, manipulates, and exports
{bf:W} spatial weighting matrices.  Listed below are the sections
describing the {cmd:spmatrix} command.

{synoptset 28 tabbed}{...}
{syntab:Creating standard weighting matrices}
{synopt:{helpb spmatrix create}}Create standard matrix{p_end}
{synopt:{helpb spdistance}}Calculator for distance between places{p_end}

{syntab:Creating custom weighting matrices}
{synopt:{helpb spmatrix userdefined}}Custom creation
using a user-defined function{p_end}
{synopt:{helpb spmatrix fromdata}}Custom creation based
on variables in the dataset{p_end}
{synopt:{helpb spmatrix spfrommata}}Get weighting matrix from Mata{p_end}
{synopt:{helpb spmatrix matafromsp}}Copy weighting matrix to Mata{p_end}
{synopt:{helpb spmatrix normalize}}Normalize matrix{p_end}

{syntab:Manipulating weighting matrices}
{synopt:{helpb spmatrix dir}}List names of weighting matrices in memory{p_end}
{synopt:{helpb spmatrix summarize}}Details of weighting matrix stored in memory{p_end}
{synopt:{helpb spmatrix drop}}Drop weighting matrix from memory{p_end}
{synopt:{helpb spmatrix copy}}Copy weighting matrix to new name{p_end}
{synopt:{helpb spmatrix save}}Save spatial weighting matrix to file{p_end}
{synopt:{helpb spmatrix use}}Load spatial weighting matrix from file{p_end}
{synopt:{helpb spmatrix note}}Set or list note{p_end}
{synopt:{helpb spmatrix clear}}Drop all weighting matrices from memory{p_end}

{syntab:Importing and exporting weighting matrices}
{synopt:{helpb spmatrix export}}Export weighting matrix in standard format{p_end}
{synopt:{helpb spmatrix import}}Import weighting matrix in standard format{p_end}
{p2colreset}{...}
