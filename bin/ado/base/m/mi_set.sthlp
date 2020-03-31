{smcl}
{* *! version 1.0.18  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi set" "mansection MI miset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi convert" "help mi_convert"}{...}
{vieweralsosee "[MI] mi describe" "help mi_describe"}{...}
{vieweralsosee "[MI] mi export" "help mi_export"}{...}
{vieweralsosee "[MI] mi extract" "help mi_extract"}{...}
{vieweralsosee "[MI] mi import" "help mi_import"}{...}
{vieweralsosee "[MI] mi XXXset" "help mi_xxxset"}{...}
{vieweralsosee "[MI] Styles" "help mi_styles"}{...}
{viewerjumpto "Syntax" "mi_set##syntax"}{...}
{viewerjumpto "Menu" "mi_set##menu"}{...}
{viewerjumpto "Description" "mi_set##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_set##linkspdf"}{...}
{viewerjumpto "Remarks" "mi_set##remarks"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[MI] mi set} {hline 2}}Declare multiple-imputation data{p_end}
{p2col:}({mansection MI miset:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mi set} {it:style}

	    where {it:style}  is  {opt w:ide}
			     {opt ml:ong}
			     {opt fl:ong}
			     {opt flongs:ep} {it:name}


{p 8 12 2}
{cmd:mi} {cmdab:reg:ister} 
{c -(}{cmdab:imp:uted} |
{cmdab:pas:sive} |
{cmdab:reg:ular}{c )-}
{varlist}

{p 8 12 2}
{cmd:mi} {cmdab:unreg:ister} {varlist}


{p 8 12 2}
{cmd:mi set}
{cmd:M}
{c -(}{cmd:=} | {cmd:+=} | {cmd:-=}{c )-} {it:#}

{p 8 12 2}
{cmd:mi set}
{cmd:m} {cmd:-=} {cmd:(}{it:{help numlist}}{cmd:)}


{p 8 12 2}
{cmd:mi} {cmd:unset} [{cmd:,} {cmd:asis}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:set} is used to set a regular Stata dataset to be an {cmd:mi}
dataset.
{cmd:mi} {cmd:set} is also used to modify the attributes
of an already set dataset.
An {cmd:mi} {cmd:set} dataset has the following attributes:

{p 8 12 2}
o  The data are recorded in a {it:style}: {cmd:wide}, {cmd:mlong}, {cmd:flong},
    or {cmd:flongsep}; see {manhelp mi_styles MI:Styles}.

{p 8 12 2}
o  Variables are registered as {cmd:imputed}, {cmd:passive}, or {cmd:regular},
   or they are left unregistered.

{p 8 12 2}
o  In addition to {it:m}=0, the data with missing values, the data include 
    {it:M}>=0 imputations of the imputed variables.

{p 4 4 2}
{cmd:mi} {cmd:set} {it:style} begins the setting process by setting the
desired style.  {cmd:mi} {cmd:set} {it:style} sets all variables as 
unregistered and sets {it:M}=0.

{p 4 4 2}
{cmd:mi} {cmd:register} 
registers variables as {cmd:imputed}, {cmd:passive}, or {cmd:regular}.
Variables can be registered one at a time or in groups and can be 
registered and reregistered.

{p 4 4 2}
{cmd:mi} {cmd:unregister} unregisters registered variables, 
which is useful if you make a mistake.  Exercise caution.  Unregistering an
imputed or passive variable can cause loss of the filled-in missing values in
{it:m}>0 if your data are recorded in the wide or mlong styles.
In such cases, just {cmd:mi} {cmd:register} the variable correctly without
{cmd:mi} {cmd:unregister}ing it first.

{p 4 4 2}
{cmd:mi} {cmd:set} {cmd:M} modifies {it:M}, the total number of imputations.
{it:M} may be increased or decreased.  {it:M} may be set before or after
imputed variables are registered.

{p 4 4 2}
{cmd:mi} {cmd:set} {cmd:m} drops selected imputations from the data.

{p 4 4 2}
{cmd:mi unset} is a rarely used command to unset the data.  Better
alternatives include {bf:{help mi_extract:mi extract}}
and 
{bf:{help mi_export:mi export}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI misetRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Data must be {cmd:mi} {cmd:set} before they can be used with the 
other {cmd:mi} commands. 
There are two ways data can become {cmd:mi} {cmd:set}:  direct use 
of {cmd:mi} {cmd:set} {it:style} or use of
{bf:{help mi_import:mi import}}.

{p 4 4 2}
The {cmd:mi} {cmd:register}, {cmd:mi} {cmd:set} {cmd:M}, and 
{cmd:mi} {cmd:set} {it:m} commands
are for use with already set data and are useful even with imported data.

{p 4 4 2}
Remarks are presented under the following headings:

	{help mi_set##style:mi set style}
	{help mi_set##register:mi register and mi unregister}
	{help mi_set##Mandm:mi set M and mi set m}
	{help mi_set##unset:mi unset}


{marker style}{...}
{title:mi set style}

{p 4 4 2}
{cmd:mi} {cmd:set} {it:style} begins the setting process.
{cmd:mi} {cmd:set} {it:style} has the following forms:

	{cmd:mi set wide}
	{cmd:mi set mlong}
	{cmd:mi set flong}
	{cmd:mi set flongsep} {it:name}

{p 4 4 2}
It does not matter which style you choose because you can always 
use {bf:{help mi_convert:mi convert}} to change the style later.
We typically choose {cmd:wide} to begin.

{p 4 4 2}
If your data are large, you may have to use {cmd:flongsep}. 
{cmd:mi} {cmd:set} {cmd:flongsep} requires you to specify a name for 
the flongsep dataset collection.
See {it:{help mi_styles##advice_flongsep:Advice for using flongsep}}
in {bf:{help mi_styles:[MI] Styles}}.

{p 4 4 2}
If you intend to have {help mi_glossary##def_varying:super-varying} variables, 
you need to choose either {cmd:flong} or {cmd:flongsep}, or 
you will need to {cmd:mi} {cmd:convert} to flong or flongsep style later.

{p 4 4 2}
The current style of the data is shown by the 
{cmd:mi} {cmd:query} and {cmd:mi} {cmd:describe} commands; see 
{bf:{help mi_describe:[MI] mi describe}}.


{marker register}{...}
{title:mi register and mi unregister}

{p 4 4 2}
{cmd:mi} {cmd:register} has three forms:

	{cmd:mi register imputed} {it:varlist}
	{cmd:mi register passive} {it:varlist}
	{cmd:mi register regular} {it:varlist}

{p 4 4 2}
See {bf:{help mi_glossary:[MI] Glossary}}
for a definition of 
{help mi_glossary##def_imputed:imputed, passive, and regular variables}.

{p 4 4 2}
You are required to register imputed variables.
If you intend to use 
{bf:{help mi_impute:mi impute}} to impute missing values, you must 
still register the variables first.

{p 4 4 2}
Concerning passive variables, we recommend that you register them, and if your
data are style wide, you are required to register them.  If you create passive
variables by using {bf:{help mi_passive:mi passive}}, that command
automatically registers them for you.

{p 4 4 2}
    Whether you register regular variables is up to you.  Registering them is
    safer in all styles except wide, where it does not matter.  
    We say registering is safer because regular variables should not vary
    across {it:m}, and in the long styles, you can unintentionally create
    variables that vary.  If variables are registered, {cmd:mi} will detect
    and fix mistakes for you.

{p 4 4 2}
INCLUDE help mi_longvarnames

{p 4 4 2}
    {help mi_glossary##def_varying:Super-varying variables} -- see
    {bf:{help mi_glossary:[MI] Glossary}} --
    rarely occur, but if you have them, be aware that they can be stored only
    in flong and flongsep data and that they never should be registered.

{p 4 4 2}
    The registration status of variables is listed by 
    {bf:{help mi_describe:mi describe}}.

{p 4 4 2}
Use {cmd:mi} {cmd:unregister} if you accidentally register a variable
incorrectly, with one exception:  if you mistakenly register a variable as
{cmd:imputed} but intended to register it as {cmd:passive}, or vice versa,
use {cmd:mi} {cmd:register} directly to reregister the variable.
The mere act of unregistering a passive or imputed variable can cause values in
{it:m}>0 to be replaced with those from {it:m}=0 if the data are wide or mlong.

{p 4 4 2}
That exception aside, you first {cmd:mi} {cmd:unregister} variables
before reregistering them.


{marker Mandm}{...}
{title:mi set M and mi set m}

{p 4 4 2}
{cmd:mi} {cmd:set} {cmd:M} is seldom used, and 
{cmd:mi} {cmd:set} {cmd:m} is sometimes used.

{p 4 4 2}
{cmd:mi} {cmd:set} {cmd:M} sets {it:M}, the total number of imputations.
The syntax is

	{cmd:mi set M  =} {it:#}
	{cmd:mi set M +=} {it:#}
	{cmd:mi set M -=} {it:#}

{p 4 4 2}
{cmd:mi} {cmd:set} {cmd:M} {cmd:=} {it:#} sets {it:M} = {it:#}.
Imputations are added or deleted as necessary.  If imputations are 
added, the new imputations obtain their values of imputed and passive 
variables from {it:m}=0, which means that the missing values are not yet 
replaced in the new imputations.
It is not necessary to increase {it:M} 
if you intend to use {bf:{help mi_impute:mi impute}} to impute values.

{p 4 4 2}
{cmd:mi} {cmd:set} {cmd:M} {cmd:+=} {it:#} increments {it:M} by {it:#}.

{p 4 4 2}
{cmd:mi} {cmd:set} {cmd:M} {cmd:-=} {it:#} decrements {it:M} by {it:#}.

{p 4 4 2}
{cmd:mi} {cmd:set} {cmd:m} {cmd:-=} {cmd:(}{it:numlist}{cmd:)} 
deletes the specified imputations.
For instance, if you had {it:M}=5 imputations and wanted to delete
imputation 2, leaving you with {it:M}=4, you would type 
{cmd:mi} {cmd:set} {cmd:m} {cmd:-=} {cmd:(2)}.


{marker unset}{...}
{title:mi unset}

{p 4 4 2}
If you wish to unset your data, your best choices are 
{bf:{help mi_extract:mi extract}}
and
{bf:{help mi_export:mi export}}.
The {cmd:mi} {cmd:extract} {cmd:0} command replaces the data in memory with the
data from {it:m}=0, unset.  The {cmd:mi} {cmd:export} command replaces the data
in memory with unset data in a form that can be sent to a non-Stata user.

{p 4 4 2}
{cmd:mi} {cmd:unset} is included for completeness, and if it has 
any use at all, it would be by programmers.
{p_end}
