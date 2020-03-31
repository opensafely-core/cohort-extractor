{smcl}
{* *! version 1.0.14  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi export ice" "mansection MI miexportice"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] mi export" "help mi_export"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi import ice" "help mi_import_ice"}{...}
{viewerjumpto "Syntax" "mi_export_ice##syntax"}{...}
{viewerjumpto "Menu" "mi_export_ice##menu"}{...}
{viewerjumpto "Description" "mi_export_ice##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_export_ice##linkspdf"}{...}
{viewerjumpto "Option" "mi_export_ice##option"}{...}
{viewerjumpto "Remarks" "mi_export_ice##remarks"}{...}
{viewerjumpto "References" "mi_export_ice##references"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[MI] mi export ice} {hline 2}}Export mi data to ice format{p_end}
{p2col:}({mansection MI miexportice:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mi export ice} 
[{cmd:,}
{cmd:clear}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:export} {cmd:ice} 
converts the {cmd:mi} data in memory to {cmd:ice} format.
See Royston
({help mi export ice##R2004:2004},
 {help mi export ice##R2005a:2005a},
 {help mi export ice##R2005b:2005b},
 {help mi import ice##R2007a:2007},
 {help mi import ice##R2009a:2009}) for a description of {cmd:ice}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miexporticeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{p 4 8 2}
{cmd:clear}
    specifies that it is okay to replace the data in memory even if they
    have changed since they were last saved to disk.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:mi} {cmd:export} {cmd:ice} is the inverse of 
{bf:{help mi_import_ice:mi import ice}}.
Below we use {cmd:mi} {cmd:export} {cmd:ice} to convert 
{cmd:miproto.dta} to {cmd:ice} format.  {cmd:miproto.dta} happens 
to be in wide form, but that is irrelevant.

	. {cmd:webuse miproto}
	. {cmd:mi describe}
	. {cmd:list}
	. {cmd:mi export ice}
	. {cmd:list, separator(2)}


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
