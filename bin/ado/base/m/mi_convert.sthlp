{smcl}
{* *! version 1.0.15  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi convert" "mansection MI miconvert"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Styles" "help mi_styles"}{...}
{viewerjumpto "Syntax" "mi convert##syntax"}{...}
{viewerjumpto "Menu" "mi convert##menu"}{...}
{viewerjumpto "Description" "mi convert##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_convert##linkspdf"}{...}
{viewerjumpto "Options" "mi convert##options"}{...}
{viewerjumpto "Remarks" "mi convert##remarks"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[MI] mi convert} {hline 2}}Change style of mi data{p_end}
{p2col:}({mansection MI miconvert:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mi convert} {opt w:ide} [{cmd:,} {it:options}]

{p 8 12 2}
{cmd:mi convert} {opt  ml:ong} [{cmd:,} {it:options}]

{p 8 12 2}
{cmd:mi convert} {opt fl:ong} [{cmd:,} {it:options}]

{p 8 12 2}
{cmd:mi convert} {opt flongs:ep} {it:name} [{cmd:,} {it:options}]


{synoptset 15}{...}
{synopthdr}
{synoptline}
{synopt:{cmd:clear}}okay to convert if data not saved{p_end}

{synopt:{cmdab:noup:date}}see {bf:{help mi_noupdate_option:[MI] noupdate option}}{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:convert} converts {cmd:mi} data from one style to another.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miconvertRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{p 4 8 2}
{cmd:clear}
    specifies that it is okay to convert the data even if the data have 
    not been saved to disk since they were last changed.

{p 4 8 2}
{cmd:noupdate}
    in some cases suppresses the automatic {cmd:mi} {cmd:update} this 
    command might perform; 
    see {bf:{help mi_noupdate_option:[MI] noupdate option}}.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mi_convert##convenience:Using mi convert as a convenience tool}
	{help mi_convert##fromflongsep:Converting from flongsep}
	{help mi_convert##toflongsep:Converting to flongsep}


{marker convenience}{...}
{title:Using mi convert as a convenience tool}

{p 4 4 2}
Some tasks are easier in one style than another.
{cmd:mi} {cmd:convert} allows you to switch to the more convenient style.
It would not be unreasonable for a snippet of a session to read

	. {cmd:mi convert wide}

	. {cmd:drop if sex=="male"}

	. {cmd:mi convert mlong, clear}

	. {cmd:replace age2 = age^2}

{p 4 4 2}
This user is obviously exploiting his or her knowledge of 
{bf:{help mi_styles:[MI] Styles}}.  
The official way to do the above would be

	. {cmd:drop if sex=="male"}

	. {cmd:mi update}

	. {cmd:mi passive: replace age2 = age^2}

{p 4 4 2}
It does not matter which approach you choose.


{marker fromflongsep}{...}
{title:Converting from flongsep}

{p 4 4 2}
If you have flongsep data, it is worth finding out whether you 
can convert it to one of the other styles.  The other styles are 
more convenient than flongsep, and {cmd:mi} commands run faster on them.
With your flongsep data in memory, type 

	. {cmd:mi convert mlong}

{p 4 4 2}
The result will be either success or an insufficient-memory
error.  

{p 4 4 2}
If you wish, 
you can make a crude guess as to how much memory is required
as follows:

{p 8 12 2}
    1.  Use your flongsep data.  Type {cmd:mi} {cmd:describe}.
        Write down {it:M}, the number of imputations, and 
        write down 
        the number of complete observations, which we will 
        call {it:N}, 
        and the number of incomplete observations, which we will 
        call {it:n}.

{p 8 12 2}
    2.  With your flongsep data still in memory, type {cmd:memory}.
        Write down the sum of the numbers reported as "data" and "overhead"
        under the "used" column.  We will call this sum {it:S} for size.

{p 8 12 2}
    3.  Calculate {it:T} = {it:S} + {it:M}*{it:S}*({it:n}/{it:N}).
        {it:T} is an approximation of the memory your {cmd:mi} data
        would consume in the mlong style.  To that, we need to add 
        a bit to account for extra memory used by Stata commands and 
        for variables or observations you might want to add.
        How much to add is always debatable.  For large datasets, add 10%
        or 5 MB, whichever is smaller.

{p 4 4 2}
For instance, you might have

		{it:M} =        30
		{it:N} =    10,000
		{it:n} =     1,500
		{it:S} = 8,040,000 = 8 MB 

{p 4 4 2}
and thus we would calculate {it:T} = 8 + 30*8*(1500/10000) = 44 MB, to
which we would add another 4 or 5 MB, to obtain 48 or 49 MB. 


{marker toflongsep}{...}
{title:Converting to flongsep}

{p 4 4 2}
Note that {cmd:mi} {cmd:convert}'s syntax for converting to flongsep is 

	{cmd:mi convert flongsep} {it:name}

{p 4 4 2}
You must specify a name, and that name will become the basis for the 
names of the datasets that comprise the collection of flongsep data.
Data for {it:m}=0 will be stored in {it:name}{cmd:.dta}; 
data for {it:m}=1, in {cmd:_1_}{it:name}{cmd:.dta}; 
data for {it:m}=2, in {cmd:_2_}{it:name}{cmd:.dta}; 
and so on.  The files will be stored in the current directory;
see the {cmd:pwd} command in {bf:{help cd:[D] cd}}.

{p 4 4 2}
If you are going to use flongsep data, see 
{it:{help mi_styles##advice_flongsep:Advice for using flongsep}}
in {bf:{help mi_styles:[MI] Styles}}.
Also see 
{bf:{help mi_copy:[MI] mi copy}}
and 
{bf:{help mi_erase:[MI] mi erase}}.
{p_end}
