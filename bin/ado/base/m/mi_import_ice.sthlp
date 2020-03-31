{smcl}
{* *! version 1.0.16  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi import ice" "mansection MI miimportice"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] mi import" "help mi_import"}{...}
{viewerjumpto "Syntax" "mi_import_ice##syntax"}{...}
{viewerjumpto "Menu" "mi_import_ice##menu"}{...}
{viewerjumpto "Description" "mi_import_ice##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_import_ice##linkspdf"}{...}
{viewerjumpto "Options" "mi_import_ice##options"}{...}
{viewerjumpto "Remarks" "mi_import_ice##remarks"}{...}
{viewerjumpto "References" "mi_import_ice##references"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[MI] mi import ice} {hline 2}}Import ice-format data into mi
{p_end}
{p2col:}({mansection MI miimportice:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mi import ice} [{cmd:,} {it:options}]

{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt:{cmdab:auto:matic}}register variables automatically{p_end}
{synopt:{cmdab:imp:uted(}{varlist}{cmd:)}}imputed variables to be registered
{p_end}
{synopt:{cmdab:pas:sive(}{varlist}{cmd:)}}passive variables to be registered
{p_end}
{synopt:{cmd:clear}}okay to replace unsaved data{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:import} {cmd:ice} converts the data in memory 
to {cmd:mi} data, assuming the data in memory are in 
{cmd:ice} format.  See 
Royston ({help mi import ice##R2004:2004},
         {help mi import ice##R2005a:2005a},
         {help mi import ice##R2005b:2005b},
         {help mi import ice##R2007a:2007},
         {help mi import ice##R2009a:2009}) for a description of {cmd:ice}.

{p 4 4 2}
{cmd:mi} {cmd:import} {cmd:ice} converts the data to {cmd:mi} style flong.
The data are {cmd:mi} {cmd:set}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miimporticeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{p 4 8 2}
{cmd:automatic}
    determines the identity of the imputed variables automatically.
    Use of this option is recommended.

{p 4 8 2}
{cmd:imputed(}{varlist}{cmd:)} specifies the names of the 
    imputed variables.  This option may be used with {cmd:automatic}, 
    in which case {cmd:automatic} is taken to mean automatically 
    determine the identity of imputed variables in addition to the 
    {cmd:imputed()} variables specified.  It is difficult to imagine 
    why one would want to do this.

{p 4 8 2}
{cmd:passive(}{varlist}{cmd:)} specifies the names of the 
    passive variables.  This option may be used with {cmd:automatic} 
    and usefully so.  {cmd:automatic} cannot distinguish imputed 
    variables from passive variables, so it assumes all variables 
    that vary are imputed.  {cmd:passive()} allows you to specify 
    the subset of varying variables that are passive.

{p 4 4 2}
{it:Concerning the above options}:
    If none are specified, all variables are left unregistered in the result.
    You can then use {cmd:mi} {cmd:varying} to determine the varying variables
    and use {cmd:mi} {cmd:register} to register them appropriately; see
    {bf:{help mi_varying:[MI] mi varying}} and {bf:{help mi_set:[MI] mi set}}.
    If you follow this approach, remember to register imputed variables 
    before registering passive variables.

{p 4 8 2}
{cmd:clear}
    specifies that it is okay to replace the data in memory even if they 
    have changed since they were last saved to disk.  Remember, 
    {cmd:mi} {cmd:import} {cmd:ice} starts with {cmd:ice} data in 
    memory and ends with {cmd:mi} data in memory.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The procedure to convert {cmd:ice} data to {cmd:mi} flong is

{p 8 12 2}
1.  {cmd:use} the {cmd:ice} data.

{p 8 12 2}
2.  Issue the {cmd:mi} {cmd:import} {cmd:ice} command, preferably with 
    the {cmd:automatic} option and perhaps with the {cmd:passive()} option, 
    too, although it really does not matter if passive variables are 
    registered as imputed, so long as they are registered.

{p 8 12 2}
3.  Perform the checks outlined in 
    {it:{help mi_import##warning:Using mi import nhanes1, ice, flong, and flongsep}}
    of {bf:{help mi_import:[MI] mi import}}.

{p 8 12 2}
4.  Use {bf:{help mi_convert:mi convert}} to convert the data to a more 
    convenient style such as wide or mlong.

{p 4 4 2}
For instance, you have the following ice data:

	. {cmd:webuse icedata}
	. {cmd:list, separator(2)}

{p 4 4 2}
{cmd:_mj} and {cmd:_mi} are {cmd:ice} system variables.  These data contain
the original data and two imputations.  Variable {cmd:b} is imputed, and 
variable {cmd:c} is passive and in fact equal to {cmd:a}+{cmd:b}.  These are
the same data discussed in {bf:{help mi_styles:[MI] Styles}} but in {cmd:ice}
format.

{p 4 4 2}
The fact that these data are nicely sorted is irrelevant.  To import these
data, you type

	. {cmd:mi import ice, automatic}

{p 4 4 2}
although it would be even better if you typed 

	. {cmd:mi import ice, automatic passive(c)}

{p 4 4 2}
With the first command, both {cmd:b} and {cmd:c} will be registered as 
imputed.  With the second, {cmd:c} will instead be registered as 
passive.  Whether {cmd:c} is registered as imputed or passive makes no 
difference statistically.

{p 4 4 2}
These data are short enough that we can list the result:

        . {cmd:list, separator(2)}

{p 4 4 2}
We will now perform the checks outlined in 
{it:{help mi_import##warning:Using mi import nhanes1, ice, flong, and flongsep}}
of {bf:{help mi_import:[MI] mi import}}, 
which are to run 
{cmd:mi} {cmd:describe}
and 
{cmd:mi} {cmd:varying}
to verify that variables are registered correctly:

	. {cmd:mi describe}
	. {cmd:mi varying}

{p 4 4 2}
We find that there are no remaining problems, so 
we convert our data to our preferred wide style:

	. {cmd:mi convert wide, clear}
	. {cmd:list}


{marker references}{...}
{title:References}

{marker R2004}{...}
{p 4 8 2}
Royston, P. 2004.
    {browse "http://www.stata-journal.com/sjpdf.html?articlenum=st0067":Multiple imputation of missing values.}
    {it:Stata Journal} 4: 227-241.

{marker R2005a}{...}
{p 4 8 2}
------. 2005a.
    {browse "http://www.stata-journal.com/sjpdf.html?articlenum=st0067_1":Multiple imputation of missing values:  Update.}
    {it:Stata Journal} 5: 188-201.

{marker R2005b}{...}
{p 4 8 2}
------. 2005b.
    {browse "http://www.stata-journal.com/sjpdf.html?articlenum=st0067_2":Multiple imputation of missing values:  Update of ice.}
    {it:Stata Journal} 5: 527-536.

{marker R2007a}{...}
{p 4 8 2}
------. 2007.
    {browse "http://www.stata-journal.com/sjpdf.html?articlenum=st0067_3":Multiple imputation of missing values:  Further update of ice, with an emphasis on interval censoring.}
    {it:Stata Journal} 7: 445-464.

{marker R2009a}{...}
{p 4 8 2}
------. 2009.
    {browse "http://www.stata-journal.com/article.html?article=st0067_4":Multiple imputation of missing values:  Further update of ice, with an emphasis on categorical variables.}
    {it:Stata Journal} 9: 466-477.
{p_end}
