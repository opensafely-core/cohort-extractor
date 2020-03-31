{smcl}
{* *! version 1.0.13  11apr2019}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi export" "mansection MI miexport"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi export ice" "help mi_export_ice"}{...}
{vieweralsosee "[MI] mi export nhanes1" "help mi_export_nhanes1"}{...}
{viewerjumpto "Syntax" "mi_export##syntax"}{...}
{viewerjumpto "Description" "mi_export##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_export##linkspdf"}{...}
{viewerjumpto "Remarks" "mi_export##remarks"}{...}
{viewerjumpto "Examples" "mi_export##examples"}{...}
{viewerjumpto "References" "mi_export##references"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[MI] mi export} {hline 2}}Export mi data{p_end}
{p2col:}({mansection MI miexport:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

        {cmd:mi export nhanes1} ...

        {cmd:mi export ice} ...

{pstd}
See {bf:{help mi_export_nhanes1:[MI] mi export nhanes1}} and
{bf:{help mi_export_ice:[MI] mi export ice}}.


{marker description}{...}
{title:Description}

{p 4 4 2}
Use {cmd:mi}
{cmd:export} {cmd:nhanes1} to export data in the format used by the National
Health and Nutrition Examination Survey.  

{p 4 4 2}
Use {cmd:mi}
{cmd:export} {cmd:ice} to export data in the format used by {cmd:ice}
(Royston {help mi export##R2004:2004},
         {help mi export##R2005a:2005a},
         {help mi export##R2005b:2005b},
         {help mi export##R2007a:2007},
         {help mi export##R2009a:2009}).

{p 4 4 2}
If and when other standards develop for recording multiple-imputation data,
other {cmd:mi} {cmd:export} subcommands will be added.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miexportRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
If you wish to send data to other Stata users, ignore {cmd:mi} {cmd:export}
and just send them your {cmd:mi} dataset(s).

{p 4 4 2}
To send data to users of other packages, however, you will have to negotiate
the format you will use.  The easiest way to send data to non-Stata users
is probably to {bf:{help mi_convert:mi convert}}
your data to flongsep and then use 
{cmd:outfile} (see {bf:{help outfile:[D] outfile}})
or {cmd:export delimited} (see
{bf:{help import delimited:[D] import delimited}}).
Also see {findalias frdatain}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse mheart1s20}

{pstd}Describe the mi data{p_end}
{phang2}{cmd:. mi describe}

{pstd}Export data in the format used by the National Health and Nutrition Examination Survey{p_end}
{phang2}{cmd:. mi export nhanes1 mheartnh}

{pstd}As above, but replacing these files if they exist{p_end}
{phang2}{cmd:. mi export nhanes1 mheartnh, replace}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse mheart1s20, clear}

{pstd}Export data in the format used by ice{p_end}
{phang2}{cmd:. mi export ice}

{pstd}List some of the exported data{p_end}
{phang2}{cmd:. list if _mj < 3 & (_mi == 7 | _mi == 8) , sepby(_mj)}

    {hline}


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
