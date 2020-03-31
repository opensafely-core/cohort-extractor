{smcl}
{* *! version 1.0.18  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi export nhanes1" "mansection MI miexportnhanes1"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] mi export" "help mi_export"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi import nhanes1" "help mi_import_nhanes1"}{...}
{viewerjumpto "Syntax" "mi_export_nhanes1##syntax"}{...}
{viewerjumpto "Menu" "mi_export_nhanes1##menu"}{...}
{viewerjumpto "Description" "mi_export_nhanes1##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_export_nhanes1##linkspdf"}{...}
{viewerjumpto "Options" "mi_export_nhanes1##options"}{...}
{viewerjumpto "Remarks" "mi_export_nhanes1##remarks"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[MI] mi export nhanes1} {hline 2}}Export mi data to NHANES format
{p_end}
{p2col:}({mansection MI miexportnhanes1:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mi export nhanes1} {it:filenamestub}
[{cmd:,}
{it:options odd_options}]

{synoptset 28}{...}
{synopthdr}
{synoptline}
{synopt:{cmd:replace}}okay to replace existing files{p_end}
{synopt:{cmdab:upper:case}}uppercase prefix and suffix{p_end}
{synopt:{opt passive:ok}}include passive variables{p_end}
{synoptline}

{synopthdr:odd_options}
{synoptline}
{synopt:{cmd:nacode(}{it:#}{cmd:)}}not applicable code; default is {cmd:0}{p_end}
{synopt:{cmd:obscode(}{it:#}{cmd:)}}observed code; default is {cmd:1}{p_end}
{synopt:{cmd:impcode(}{it:#}{cmd:)}}imputed code; default is {cmd:2}{p_end}

{synopt:{cmdab:imppre:fix("}{it:string}{cmd:" "}{it:string}{cmd:")}}variable
     prefix; default is {cmd:"" ""}{p_end}
{synopt:{cmdab:impsuf:fix("}{it:string}{cmd:" "}{it:string}{cmd:")}}variable
     suffix; default is {cmd:"if" "mi"}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
Note:
{it:odd_options} are not specified unless you want to create 
results that are nhanes1-like but not really nhanes1 format. {p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:export} {cmd:nhanes1} writes the {cmd:mi} data in 
memory to disk files in nhanes1 format.  
The files will be named 
{it:filenamestub}{cmd:.dta}, 
{it:filenamestub}{cmd:1.dta}, 
{it:filenamestub}{cmd:2.dta}, 
and so on.
In addition to the variables in the original {cmd:mi} data, new variable 
{cmd:seqn} will be added to record the sequence number.
After using {cmd:mi} {cmd:export} {cmd:nhanes1}, 
you can use {cmd:outfile} (see {bf:{help outfile:[D] outfile}})
or {cmd:export delimited} (see
{bf:{help import delimited:[D] import delimited}})
to convert the resulting {cmd:.dta} files into a
format suitable for sending to a non-Stata user.  
Also see {findalias frdatain}.

{p 4 4 2}
{cmd:mi} {cmd:export} {cmd:nhanes1} leaves the data in memory unchanged.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miexportnhanes1Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{p 4 8 2}
{cmd:replace}
    indicates that it is okay to overwrite existing files.

{p 4 8 2}
{cmd:uppercase}
    specifies that the new sequence variable {cmd:SEQN} and the 
    variable suffixes {cmd:IF} and {cmd:MI} be 
    in uppercase.  The default is lowercase.  (More correctly, when 
    generalizing beyond nhanes1 format, the {cmd:uppercase} option
    specifies that {cmd:SEQN} be created in uppercase along with 
    all prefixes and suffixes.)

{p 4 8 2}
{cmd:passiveok}
    specifies that passive variables are to be written as if they were 
    imputed variables.  The default is to issue an error if 
    passive variables exist in the original data.

{p 4 8 2}
{cmd:nacode(}{it:#}{cmd:)}, {cmd:obscode(}{it:#}{cmd:)}, and
    {cmd:impcode(}{it:#}{cmd:)} are optional and are never specified
    when reading true nhanes1 data.  
    The default {cmd:nacode(0)} {cmd:obscode(1)} {cmd:impcode(2)}
    corresponds to the nhanes1 definition.
    These options allow changing the codes for not applicable, 
    observed, and imputed.
     
{p 4 8 2}
{cmd:impprefix("}{it:string}{cmd:"} {cmd:"}{it:string}{cmd:")} and 
{cmd:impsuffix("}{it:string}{cmd:"} {cmd:"}{it:string}{cmd:")}
    are optional and are never specified when reading true nhanes1 data.
    The default {cmd:impprefix(""} {cmd:"")} {cmd:impsuffix("if"} {cmd:"mi")}
    corresponds to the nhanes1 definition.
    These options allow setting different prefixes and suffixes.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:mi} {cmd:export} {cmd:nhanes1} is the inverse of 
{cmd:mi import nhanes1};
see {bf:{help mi_import_nhanes1:[MI] mi import nhanes1}} for a description of the nhanes1 format.

{p 4 4 2}
Below we use {cmd:mi} {cmd:export} {cmd:nhanes1} to convert 
{cmd:miproto.dta} to nhanes1 format.  {cmd:miproto.dta} happens 
to be in wide form, but that is irrelevant.

	. {cmd:webuse miproto}
	. {cmd:mi describe}
	. {cmd:list}
	. {cmd:mi export nhanes1 mynh, passiveok}
	. {cmd:use mynh}
	. {cmd:list}
	. {cmd:use mynh1}
	. {cmd:use mynh2}
	. {cmd:list}
