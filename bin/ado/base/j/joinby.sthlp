{smcl}
{* *! version 1.2.3  15oct2018}{...}
{viewerdialog joinby "dialog joinby"}{...}
{vieweralsosee "[D] joinby" "mansection D joinby"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] append" "help append"}{...}
{vieweralsosee "[D] cross" "help cross"}{...}
{vieweralsosee "[D] fillin" "help fillin"}{...}
{vieweralsosee "[D] merge" "help merge"}{...}
{vieweralsosee "[D] save" "help save"}{...}
{viewerjumpto "Syntax" "joinby##syntax"}{...}
{viewerjumpto "Menu" "joinby##menu"}{...}
{viewerjumpto "Description" "joinby##description"}{...}
{viewerjumpto "Links to PDF documentation" "joinby##linkspdf"}{...}
{viewerjumpto "Options" "joinby##options"}{...}
{viewerjumpto "Example" "joinby##example"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] joinby} {hline 2}}Form all pairwise combinations within groups{p_end}
{p2col:}({mansection D joinby:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:joinby} [{varlist}] {cmd:using} {it:{help filename}}
[{cmd:,} {it:options}] 

{synoptset 21 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Options}
{synopt :When observations match:}{p_end}
{synopt :{opt update}}replace missing data in memory with values from
{it:{help filename}}{p_end}
{synopt :{opt replace}}replace all data in memory with values from
{it:{help filename}}{p_end}

{synopt :When observations do not match:}{p_end}
{synopt :{opt unm:atched}{cmd:(}{opt n:one}{cmd:)}}ignore all; the default{p_end}
{synopt :{opt unm:atched}{cmd:(}{opt b:oth}{cmd:)}}include from both datasets{p_end}
{synopt :{opt unm:atched}{cmd:(}{opt m:aster}{cmd:)}}include from data in
memory{p_end}
{synopt :{opt unm:atched}{cmd:(}{opt u:sing}{cmd:)}}include from data in
{it:{help filename}}{p_end}

{synopt :{opth _merge(varname)}}{it:varname} marks source of resulting
observation; default is {opt _merge}{p_end}
{synopt :{opt nol:abel}}do not copy value-label definitions from
{it:{help filename}}{p_end}
{synoptline}
{p 4 6 2}{...}
{it:varlist} may not contain {helpb data types:strL}s.
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Combine datasets > Form all pairwise combinations within groups}


{marker description}{...}
{title:Description}

{pstd}
{cmd:joinby} joins, within groups formed by {varlist}, observations of
the dataset in memory with {it:{help filename}}, a Stata-format dataset.  By
join we mean to form all pairwise combinations.  {it:filename} is required
to be sorted by {it:varlist}.  If {it:filename} is specified without an
extension, {cmd:.dta} is assumed.

{pstd}
If {it:varlist} is not specified, {cmd:joinby} takes as {it:varlist} the set of
variables common to the dataset in memory and in {it:filename}.

{pstd}
Observations unique to one or the other dataset are ignored unless 
{opt unmatched()} specifies differently.  Whether you load one dataset and
join the other or vice versa makes no difference in the number of
resulting observations.

{pstd}
If there are common variables between the two datasets, however, the
combined dataset will contain the values from the master data for those
observations.  This behavior can be modified with the {opt update} and 
{opt replace} options. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D joinbyQuickstart:Quick start}

        {mansection D joinbyRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Options}

{phang}
{opt update} varies the action that {cmd:joinby} takes when an observation is
matched.  By default, values from the master data are retained when the same
variables are found in both datasets.  If {opt update} is specified, however,
the values from the using dataset are retained where the master dataset
contains missing.

{phang}
{opt replace}, allowed with {opt update} only, specifies that nonmissing
values in the master dataset be replaced with corresponding values from the
using dataset.  A nonmissing value, however, will never be replaced with a
missing value.

{phang}
{opt unmatched}{cmd:(}{opt none}|{opt both}|{opt master}|{opt using}{cmd:)}
specifies whether observations unique to one of the datasets are to be kept,
with the variables from the other dataset set to missing.  Valid values are

{p 12 22 2}
{opt none}{space 4}ignore all unmatched observations (default){p_end}
{p 12 22 2}
{opt both}{space 4}include unmatched observations from the master and using data
{p_end}
{p 12 22 2}
{opt master}{space 2}include unmatched observations from the master data{p_end}
{p 12 22 2}
{opt using}{space 3}include unmatched observations from the using data

{phang}
{opth _merge(varname)} specifies the name of the variable that will mark the
source of the resulting observation.  The default name is {cmd:_merge(_merge)}.
To preserve compatibility with earlier versions of {cmd:joinby}, 
{cmd:_merge} is generated only if {cmd:unmatched} is specified.

{phang}
{cmd:nolabel} prevents Stata from copying the value-label definitions from the
dataset on disk into the dataset in memory.  Even if you do not specify this
option, label definitions from the disk dataset do not replace label
definitions already in memory.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse child}{p_end}
{phang2}{cmd:. describe}{p_end}
{phang2}{cmd:. list}{p_end}
{phang2}{cmd:. webuse parent}{p_end}
{phang2}{cmd:. describe}{p_end}
{phang2}{cmd:. list, sep(0)}{p_end}
{phang2}{cmd:. sort family_id}

{pstd}Join information on parents from data in memory with information on
children from data at https://www.stata-press.com{p_end}
{phang2}{cmd:. joinby family_id using}
            {cmd:https://www.stata-press.com/data/r16/child}

{pstd}Describe the resulting dataset{p_end}
{phang2}{cmd:. describe}

{pstd}List the resulting data{p_end}
{phang2}{cmd:. list, sepby(family_id) abbrev(12)}{p_end}
