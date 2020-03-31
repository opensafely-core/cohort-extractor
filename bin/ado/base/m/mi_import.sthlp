{smcl}
{* *! version 1.1.16  15oct2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi import" "mansection MI miimport"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi import flong" "help mi_import_flong"}{...}
{vieweralsosee "[MI] mi import flongsep" "help mi_import_flongsep"}{...}
{vieweralsosee "[MI] mi import ice" "help mi_import_ice"}{...}
{vieweralsosee "[MI] mi import nhanes1" "help mi_import_nhanes1"}{...}
{vieweralsosee "[MI] mi import wide" "help mi_import_wide"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Styles" "help mi_styles"}{...}
{viewerjumpto "Syntax" "mi_import##syntax"}{...}
{viewerjumpto "Description" "mi_import##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_import##linkspdf"}{...}
{viewerjumpto "Remarks" "mi_import##remarks"}{...}
{viewerjumpto "References" "mi_import##references"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[MI] mi import} {hline 2}}Import data into mi{p_end}
{p2col:}({mansection MI miimport:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{bf:mi import nhanes1} ...

{p 8 12 2}
{bf:mi import ice} ...

{p 8 12 2}
{bf:mi import flong} ...

{p 8 12 2}
{bf:mi import flongsep} ...

{p 8 12 2}
{bf:mi import wide} ...


{p 4 4 2}
See 
{bf:{help mi_import_nhanes1:[MI] mi import nhanes1}},
{bf:{help mi_import_ice:[MI] mi import ice}},
{bf:{help mi_import_flong:[MI] mi import flong}},
{bf:{help mi_import_flongsep:[MI] mi import flongsep}},
and
{bf:{help mi_import_wide:[MI] mi import wide}}.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:import} imports into {cmd:mi} data that contain 
original data and imputed values.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miimportRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mi_import##overview:When to use which mi import command}
	{help mi_import##importstata:Import data into Stata before importing into mi}
	{help mi_import##warning:Using mi import nhanes1, ice, flong, and flongsep}


{marker overview}{...}
{title:When to use which mi import command}

{p 4 4 2}
{cmd:mi} {cmd:import} {cmd:nhanes1} imports data recorded in the format used
by the National Health and Nutrition Examination Survey (NHANES) produced by
the National Center for Health Statistics of the U.S. Centers for Disease
Control and Prevention (CDC); 
see {browse "https://www.cdc.gov/nchs/nhanes.htm"}.

{p 4 4 2}
{cmd:mi} {cmd:import} {cmd:ice} imports data recorded in the format used by 
{cmd:ice} (Royston {help mi import##R2004:2004},
                   {help mi import##R2005a:2005a},
                   {help mi import##R2005b:2005b},
                   {help mi import##R2007a:2007},
                   {help mi import##R2009a:2009}).

{p 4 4 2}
{cmd:mi} {cmd:import} {cmd:flong} and {cmd:mi} {cmd:import} {cmd:flongsep}
import data that are in flong- and flongsep-like format, which is to say, the
data are repeated for {it:m}=0, {it:m}=1, ..., and {it:m}={it:M}.  {cmd:mi}
{cmd:import} {cmd:flong} imports data in which the information is contained in
one file.  {cmd:mi} {cmd:import} {cmd:flongsep} imports data in which the
information is recorded in a collection of files.  

{p 4 4 2}
{cmd:mi} {cmd:import} {cmd:wide} imports data that are in wide-like format,
where additional variables are used to record the imputed values.


{marker importstata}{...}
{title:Import data into Stata before importing into mi}

{p 4 4 2}
With the exception of {cmd:mi} {cmd:import} {cmd:ice}, 
you must import the data into Stata before you can use {cmd:mi} {cmd:import}
to import the data into {cmd:mi}.  
{cmd:mi} {cmd:import} {cmd:ice} is the exception only because the data 
are already in Stata format.
That is, 
{cmd:mi} {cmd:import}
requires that the data be stored in Stata-format {cmd:.dta} datasets.  You
perform the initial import into Stata by using any method described in
{manhelp import D}.


{marker warning}{...}
{title:Using mi import nhanes1, ice, flong, and flongsep}

{p 4 4 2}
Import commands 
{cmd:mi} {cmd:import} {cmd:nhanes1}
and
{cmd:mi} {cmd:import} {cmd:flongsep}
produce an flongsep result; 
{cmd:mi} {cmd:import} {cmd:ice} and 
{cmd:mi} {cmd:import} {cmd:flong}
produce an flong result.
You can use {bf:{help mi_convert:mi convert}} afterward to convert the
result to another style, and we usually recommend that.  Before doing that,
however, you need to examine the freshly imported data and verify that all
imputed and passive variables are registered correctly.
If they are not registered correctly, 
you risk losing imputed values.

{p 4 4 2}
To perform this verification, use the 
{bf:{help mi_describe:mi describe}}
and {bf:{help mi_varying:mi varying}} commands
immediately after {cmd:mi} {cmd:import}:

	. {cmd:mi import} ...

	. {cmd:mi describe}

	. {cmd:mi varying}

{p 4 4 2}
{cmd:mi} {cmd:describe} will list the registration status of the variables.
{cmd:mi} {cmd:varying} will report the 
{help mi_glossary##def_varying:varying and super-varying} variables.
Verify that all varying variables are registered as imputed or passive.
If one or more is not, register them now:

	. {cmd:mi register imputed} {it:forgottenvar}

	. {cmd:mi register passive} {it:another_forgottenvar}

{p 4 4 2}
There is no statistical distinction between imputed and passive variables,
so you may register variables about which you are unsure either way.
If an unregistered variable is found to be varying and you are convinced that
is an error, register the variable as regular:

	. {cmd:mi register regular} {it:variable_in_error}

{p 4 4 2}
Next, if {cmd:mi} {cmd:varying} reports that your data contain 
any super-varying variables, determine whether the variables are due to errors
in the source data or really are intended to be super varying.
If they are errors, register the variables as imputed, passive, or regular, as
appropriate.  Leave any intended
super-varying variables unregistered, however, 
and make a note to yourself:  never convert these data to the wide or mlong
styles.  Data with super-varying variables can be stored only in the 
flong and flongsep styles.

{p 4 4 2}
Now run {cmd:mi} {cmd:describe} and {cmd:mi} {cmd:varying} again:

	. {cmd:mi describe} 

	. {cmd:mi varying} 

{p 4 4 2}
Ensure that you have registered variables correctly, and, if necessary, repeat
the steps above to fix any remaining problems.

{p 4 4 2}
After that, 
you may use {cmd:mi} {cmd:convert} to switch the data to a more convenient
style.  We generally start with the wide style:

	. {cmd:mi convert wide}

{p 4 4 2}
Do not switch to wide, however, if you have any super-varying variables.
Try flong instead:

	. {cmd:mi convert flong}

{p 4 4 2}
Whichever style you choose, 
if you get an insufficient-memory error, you will have to either increase
the amount of memory dedicated to Stata or use these data in the 
more inconvenient, but perfectly workable, flongsep style.
Concerning increasing memory, see  
{it:{help mi_convert##fromflongsep:Converting from flongsep}}
in {bf:{help mi_convert:[MI] mi convert}}.
Concerning the workability of flongsep, 
see {it:{help mi_styles##advice_flongsep:Advice for using flongsep}}
in {bf:{help mi_styles:[MI] Styles}}.

{p 4 4 2}
We said to perform the checks above before using {cmd:mi} {cmd:convert}.  It
is, however, safe to convert the just-imported flongsep data to flong, perform
the checks, and then convert to the desired form.  The checks will run more
quickly if you convert to flong first.

{p 4 4 2}
You can vary how you perform the checks.
The logic underlying our recommendations is as follows:

{p 8 12 2}
    o  It is possible that you did not specify all the imputed and passive
        variables when you imported the data, perhaps due to errors in 
        the data's documentation.  It is also possible that there are errors
        in the data that you imported.  It is worth checking.

{p 8 12 2}
    o  As long as the imported data are recorded in the 
        flongsep or flong style, unregistered variables will appear 
        exactly as they appeared in the original source.  It is only 
        when the data are converted to the wide or mlong style that 
        assumptions about the structure of the data are exploited 
        to save memory.
        Thus you need to perform checks before converting the data 
        to the more convenient wide or mlong style.

{p 8 12 2}
    o  If you find errors, you could go back and reimport the data
        correctly, but it is easier to use {cmd:mi} {cmd:register} 
        after the fact.  When you type {cmd:mi} {cmd:register}, 
        you are not only informing {cmd:mi} about how to deal with the 
        variable but also asking {cmd:mi} {cmd:register} to examine the
        variable and fix any problems given its new registration status.


{marker references}{...}
{title:References}

{marker R2004}{...}
{p 4 8 2}
Royston, P. 2004.
    {browse "https://www.stata-journal.com/sjpdf.html?articlenum=st0067":Multiple imputation of missing values.}
    {it:Stata Journal} 4: 227-241.

{marker R2005a}{...}
{p 4 8 2}
------. 2005a.
    {browse "https://www.stata-journal.com/sjpdf.html?articlenum=st0067_1":Multiple imputation of missing values:  Update.}
    {it:Stata Journal} 5: 188-201.

{marker R2005b}{...}
{p 4 8 2}
------. 2005b.
    {browse "https://www.stata-journal.com/sjpdf.html?articlenum=st0067_2":Multiple imputation of missing values:  Update of ice.}
    {it:Stata Journal} 5: 527-536.

{marker R2007a}{...}
{p 4 8 2}
------. 2007.
    {browse "https://www.stata-journal.com/sjpdf.html?articlenum=st0067_3":Multiple imputation of missing values:  Further update of ice, with an emphasis on interval censoring.}
    {it:Stata Journal} 7: 445-464.

{marker R2009a}{...}
{p 4 8 2}
------. 2009.
    {browse "https://www.stata-journal.com/article.html?article=st0067_4":Multiple imputation of missing values:  Further update of ice, with an emphasis on categorical variables.}
    {it:Stata Journal} 9: 466-477.
{p_end}
