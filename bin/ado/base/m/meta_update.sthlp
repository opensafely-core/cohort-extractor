{smcl}
{* *! version 1.0.0  17jun2019}{...}
{viewerdialog "meta" "dialog meta"}{...}
{vieweralsosee "[META] meta update" "mansection META metaupdate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta data" "mansection META metadata"}{...}
{vieweralsosee "[META] meta esize" "help meta esize"}{...}
{vieweralsosee "[META] meta set" "help meta set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta" "help meta"}{...}
{vieweralsosee "[META] Glossary" "help meta glossary"}{...}
{vieweralsosee "[META] Intro" "mansection META Intro"}{...}
{viewerjumpto "Syntax" "meta_update##syntax"}{...}
{viewerjumpto "Menu" "meta_update##menu"}{...}
{viewerjumpto "Description" "meta_update##description"}{...}
{viewerjumpto "Links to PDF documentation" "meta_update##linkspdf"}{...}
{viewerjumpto "Options" "meta_update##options"}{...}
{viewerjumpto "Examples" "meta_update##examples"}{...}
{viewerjumpto "Stored results" "meta_update##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[META] meta update} {hline 2}}Update, describe, and clear meta-analysis settings{p_end}
{p2col:}({mansection META metaupdate:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Update meta-analysis settings declared using {cmd:meta esize} for continuous
outcomes

{p 8 16 2}
{cmd:meta} {cmdab:up:date}
[{cmd:,} {help meta_update##cont_options:{it:options_continuous}}
         {help meta_update##optstbl:{it:options}}]


{pstd}
Update meta-analysis settings declared using {cmd:meta esize} for binary
outcomes

{p 8 16 2}
{cmd:meta} {cmdab:up:date}
[{cmd:,} {help meta_update##bin_options:{it:options_binary}}
         {help meta_update##optstbl:{it:options}}]


{pstd}
Update meta-analysis settings declared using {cmd:meta set}

{p 8 16 2}
{cmd:meta} {cmdab:up:date}
[{cmd:,} {help meta_update##gen_options:{it:options_generic}}
         {help meta_update##optstbl:{it:options}}]


{pstd}
Describe meta data

{p 8 16 2}
{cmd:meta} {cmdab:q:uery} [{cmd:,} {cmd:short}]


{pstd}
Clear meta data

{p 8 16 2}
{cmd:meta} {cmd:clear}


{marker cont_options}{...}
{synoptset 22}{...}
{synopthdr:options_continuous}
{synoptline}
{synopt :{opth es:ize(meta_esize##esspeccnt:esspeccnt)}}specify effect size for
continuous outcome to be used in the meta-analysis{p_end}
{synopt :{opt random}[{cmd:(}{help meta_esize##remethod:{it:remethod}}{cmd:)}]}random-effects meta-analysis{p_end}
{synopt :{opt common}}common-effect meta-analysis; implies inverse-variance method{p_end}
{synopt :{opt fixed}}fixed-effects meta-analysis; implies inverse-variance method{p_end}
{synoptline}

{marker bin_options}{...}
{synopthdr:options_binary}
{synoptline}
{synopt :{opth es:ize(meta_esize##estypebin:estypebin)}}specify effect size for
binary outcome to be used in the meta-analysis{p_end}
{synopt :{opt random}[{cmd:(}{help meta_esize##remethod:{it:remethod}}{cmd:)}]}random-effects meta-analysis{p_end}
{synopt :{opt common}[{cmd:(}{help meta_esize##cefemethod:{it:cefemethod}}{cmd:)}]}common-effect meta-analysis{p_end}
{synopt :{opt fixed}[{cmd:(}{help meta_esize##cefemethod:{it:cefemethod}}{cmd:)}]}fixed-effects meta-analysis{p_end}
{synopt :{opth zerocells:(meta_esize##zcspec:zcspec)}}adjust for zero cells
during computation; default is to add 0.5 to all cells of those 2 x 2 tables
that contain zero cells{p_end}
{synoptline}

{marker gen_options}{...}
{synopthdr:options_generic}
{synoptline}
{synopt :{opt random}[{cmd:(}{help meta_esize##remethod:{it:remethod}}{cmd:)}]}random-effects meta-analysis{p_end}
{synopt :{opt common}}common-effect meta-analysis; implies inverse-variance method{p_end}
{synopt :{opt fixed}}fixed-effects meta-analysis; implies inverse-variance method{p_end}
{synopt :{opth studysize(varname)}}total sample size per study{p_end}
{synoptline}

{marker optstbl}{...}
{synopthdr:options}
{synoptline}
{synopt :{opth studylab:el(varname)}}variable to be used to label studies in all meta-analysis output{p_end}
{synopt :{opth eslab:el(strings:string)}}effect-size label to be used in all meta-analysis output; default is {cmd:eslabel(Effect Size)}{p_end}
{synopt :{opt l:evel(#)}}confidence level for all subsequent meta-analysis commands{p_end}
{synopt :[{cmd:no}]{opt metashow}}display or suppress meta settings in the
output{p_end}
{synoptline}


INCLUDE help menu_meta


{marker description}{...}
{title:Description}

{pstd}
{cmd:meta update} updates certain components of the meta-analysis after it was
declared by {helpb meta set} or {helpb meta esize}.  This command is useful
for updating some of the meta settings without having to fully respecify
your meta-analysis variables.  The updated settings will be used throughout
the rest of your meta-analysis session.

{pstd}
{cmd:meta query} reports whether the data in memory are
{mansection META metadata:{bf:meta} data} and, if they are, displays the
current meta setting information identical to that produced by
{cmd:meta set} or {cmd:meta esize}.

{pstd}
{cmd:meta clear} clears meta settings, including meta data
characteristics and system variables.  The original data remain unchanged.
You do not need to use {cmd:meta clear} before doing another {cmd:meta set} or
{cmd:meta esize}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection META metaupdateQuickstart:Quick start}

        {mansection META metaupdateRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}
For {cmd:meta update} options, see
{help meta_set##options:{it:Options}} of
{helpb meta set:[META] meta set} and
{help meta_esize##options:{it:Options}} of
{helpb meta esize:[META] meta esize}.

{phang}
{cmd:short} is used with {cmd:meta query}.  It displays a short summary of the
meta settings containing the information about the declared type of the effect
size, effect-size and standard-error variables, and meta-analysis model and
estimation method. This option does not appear on the dialog box.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse metaesbin}{p_end}
{phang2}{cmd:. meta esize tdead tsurv cdead csurv}

{pstd}Update effect sizes to be risk differences{p_end}
{phang2}{cmd:. meta update, esize(rdiff)}

{pstd}Update MA method to be an empirical Bayes random-effects method{p_end}
{phang2}{cmd:. meta update, random(ebayes)}

{pstd}Describe the current meta-analysis settings{p_end}
{phang2}{cmd:. meta query}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:meta update} updates characteristics and contents of system variables
described in
{help meta set##results:{it:Stored results}} of 
{helpb meta set:[META] meta set} and
{help meta esize##results:{it:Stored results}} of 
{helpb meta esize:[META] meta esize}.
{p_end}
