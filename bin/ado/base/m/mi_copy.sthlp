{smcl}
{* *! version 1.0.9  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi copy" "mansection MI micopy"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi erase" "help mi_erase"}{...}
{vieweralsosee "[MI] Styles" "help mi_styles"}{...}
{viewerjumpto "Syntax" "mi copy##syntax"}{...}
{viewerjumpto "Menu" "mi copy##menu"}{...}
{viewerjumpto "Description" "mi copy##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_copy##linkspdf"}{...}
{viewerjumpto "Option" "mi copy##option"}{...}
{viewerjumpto "Remarks" "mi copy##remarks"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[MI] mi copy} {hline 2}}Copy mi flongsep data{p_end}
{p2col:}({mansection MI micopy:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mi copy} {it:newname}
[{cmd:,}
{cmd:replace}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:copy} {it:newname} copies flongsep data in memory 
to {it:newname} and sets it 
so that you are working with that copy.  {it:newname} may not be specified
with the {cmd:.dta} suffix.

{p 4 4 2}
In detail, 
{cmd:mi} {cmd:copy} {it:newname} 
1) completes saving the flongsep data to its current name if that is
necessary; 2) copies the data to {it:newname}{cmd:.dta},
{cmd:_1_}{it:newname}.{cmd:dta}, {cmd:_2_}{it:newname}{cmd:.dta}, ...,
{cmd:_}{it:M}{cmd:_}{it:newname}{cmd:.dta}; and 3) 
tells {cmd:mi} that you are now working with {it:newname}{cmd:.dta}
in memory.

{p 4 4 2}
{cmd:mi} {cmd:copy} can also be used with wide, mlong, or flong data, 
although there is no reason you would want to do so.  The data are not saved
to the original filename as flongsep data would be, but otherwise actions are
the same:  the data in memory are copied to {it:newname}{cmd:.dta}, and
{it:newname}{cmd:.dta} is loaded into memory.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI micopyRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{p 4 8 2}
{cmd:replace} specifies that it is okay to overwrite {it:newname}{cmd:.dta}, 
{cmd:_1_}{it:newname}{cmd:.dta}, 
{cmd:_2_}{it:newname}{cmd:.dta}, ..., if they already exist.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
In Stata, one usually works with a copy of the data in memory.  Changes you
make to the data are not saved in the underlying disk file until and unless
you explicitly save your data.  That is not true when working with flongsep
data.

{p 4 4 2}
Flongsep data are a matched set of datasets, one containing {it:m}=0,
another containing {it:m}=1, and so on.  You work with one of them in memory,
namely, {it:m}=0, but as you work, the other datasets are automatically updated;
as you make changes, the datasets on disk change.

{p 4 4 2}
Therefore, it is best to work with a copy of your flongsep data and then 
periodically save the data to the real files, thus mimicking how you
work with ordinary Stata datasets.  {cmd:mi} {cmd:copy} is for just that
purpose.  After loading your flongsep data, type, for example,

	. {cmd:use myflongsep}

{p 4 4 2}
and immediately make a copy, 

	. {cmd:mi copy} {it:newname}

{p 4 4 2}
You are now working with the same data but under a new name.
Your original data are safe.

{p 4 4 2}
When you reach a point where you would ordinarily save your data, 
whether under the original name or a different one, type

	. {cmd:mi copy} {it:original_name_or_different_name}{cmd:, replace}

	. {cmd:use} {it:newname}

{p 4 4 2}
Later, when you are done with {it:newname}, you can erase it by typing

	. {cmd:mi} {cmd:erase} {it:newname}

{p 4 4 2}
Concerning erasure, you will discover that {cmd:mi} {cmd:erase} will 
not let you erase the files when you have one of the files to be erased
in memory.  Then
you will have to type

	. {cmd:mi erase} {it:newname}{cmd:, clear}

{p 4 4 2}
See {bf:{help mi_erase:[MI] mi erase}} for more information.

{p 4 4 2}
For more information on flongsep data, see 
{it:{help mi_styles##advice_flongsep:Advice for using flongsep}} in
{bf:{help mi_styles:[MI] Styles}}.
{p_end}
