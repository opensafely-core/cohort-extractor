{smcl}
{* *! version 2.2.0  22apr2019}{...}
{vieweralsosee "[R] estimates" "mansection R estimates"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _estimates" "help _estimates"}{...}
{viewerjumpto "Syntax" "estimates##syntax"}{...}
{viewerjumpto "Description" "estimates##description"}{...}
{viewerjumpto "Links to PDF documentation" "estimates##linkspdf"}{...}
{viewerjumpto "Remarks" "estimates##remarks"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] estimates} {hline 2}}Save and manipulate estimation results{p_end}
{p2col:}({mansection R estimates:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{col 9}Command{col 50}Reference
{col 9}{hline 65}
{col 9}{it:Save and use results from disk}

{col 9}  {opt est:imates} {cmd:save} {it:{help filename}}{...}
{col 50}{bf:{help estimates_save:[R] estimates save}}
{col 9}  {opt est:imates} {cmd:use}  {it:{help filename}}{...}
{col 50}{bf:{help estimates_save:[R] estimates save}}

{col 9}  {opt est:imates} {opt des:cribe} {cmd:using} {it:{help filename}}{...}
{col 50}{bf:{help estimates_describe:[R] estimates describe}}

{col 9}  {opt est:imates} {opt esample}{cmd::} ...{...}
{col 50}{bf:{help estimates_save:[R] estimates save}}

{col 9}{hline 65}
{col 9}{it:Store and restore estimates in memory}

{col 9}  {opt est:imates} {opt sto:re}   {it:name}{...}
{col 50}{bf:{help estimates_store:[R] estimates store}}
{col 9}  {opt est:imates} {opt res:tore} {it:name}{...}
{col 50}{bf:{help estimates_store:[R] estimates store}}

{col 9}  {opt est:imates} {opt q:uery}{...}
{col 50}{bf:{help estimates_store:[R] estimates store}}
{col 9}  {opt est:imates} {opt dir}{...}
{col 50}{bf:{help estimates_store:[R] estimates store}}

{col 9}  {opt est:imates} {opt drop}    {it:namelist}{...}
{col 50}{bf:{help estimates_store:[R] estimates store}}
{col 9}  {opt est:imates} {opt clear}{...}
{col 50}{bf:{help estimates_store:[R] estimates store}}

{col 9}{hline 65}
{col 9}{it:Set titles and notes}

{col 9}  {opt est:imates} {opt title}{cmd::} {it:text}{...}
{col 50}{bf:{help estimates_title:[R] estimates title}}
{col 9}  {opt est:imates} {opt title}{...}
{col 50}{bf:{help estimates_title:[R] estimates title}}

{col 9}  {opt est:imates} {opt note:s}{cmd::} {it:text}{...}
{col 50}{bf:{help estimates_notes:[R] estimates notes}}
{col 9}  {opt est:imates} {opt note:s}{...}
{col 50}{bf:{help estimates_notes:[R] estimates notes}}
{col 9}  {opt est:imates} {opt note:s} {opt l:ist} ...{...}
{col 50}{bf:{help estimates_notes:[R] estimates notes}}
{col 9}  {opt est:imates} {opt note:s} {cmd:drop} ...{...}
{col 50}{bf:{help estimates_notes:[R] estimates notes}}

{col 9}{hline 65}
{col 9}{it:Report}

{col 9}  {opt est:imates} {opt des:cribe} [{it:name}]{...}
{col 50}{bf:{help estimates_describe:[R] estimates describe}}
{col 9}  {opt est:imates} {opt r:eplay}   [{it:namelist}]{...}
{col 50}{bf:{help estimates_replay:[R] estimates replay}}

{col 9}{hline 65}
{col 9}{it:Tables and statistics}

{col 9}  {opt est:imates} {opt tab:le} [{it:namelist}]{...}
{col 50}{bf:{help estimates_table:[R] estimates table}}
{col 9}  {opt est:imates} {opt sel:ected} [{it:namelist}]{...}
{col 50}{bf:{help estimates_selected:[R] estimates selected}}
{col 9}  {opt est:imates} {opt stat:s} [{it:namelist}]{...}
{col 50}{bf:{help estimates_stats:[R] estimates stats}}
{col 9}  {opt est:imates} {opt for} {it:namelist}{cmd::} ...{...}
{col 50}{bf:{help estimates_for:[R] estimates for}}

{col 9}{hline 65}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estimates} allows you to store and manipulate estimation results:

{p 8 12 2}
o  You can save estimation results in a file for use in later sessions.

{p 8 12 2}
o  You can store estimation results in memory so that you can

{p 12 16 2}
a.  switch among separate estimation results and

{p 12 16 2}
b.  form tables combining separate estimation results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R estimatesRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:estimates} is for use after you have fit a model, be it with 
{cmd:regress}, {cmd:logistic}, etc.  You can use {cmd:estimates} after 
any estimation command, whether it be an official estimation command 
of Stata or a community-contributed one.

{pstd}
{cmd:estimates} has three separate but related capabilities:

{p 8 12 2}
1.  You can save estimation results in a file on disk so that you can 
    use them later, even in a different Stata session.

{p 8 12 2}
2.  You can store up to 300 estimation results in memory so that 
    they are at your fingertips.

{p 8 12 2}
3.  You can make tables comparing any results you have stored in memory.

{pstd}
Remarks are presented under the following headings:

	{help estimates##saving:Saving and using estimation results}
	{help estimates##storing:Storing and restoring estimation results}
	{help estimates##comparing:Comparing estimation results}


{marker saving}{...}
{title:Saving and using estimation results}

{pstd}
After you have fit a model, say, with {cmd:regress}, type

	. {cmd:sysuse auto}
	. {cmd:regress mpg weight displ foreign}

{pstd}
You can save the results in a file:

	. {cmd:estimates save basemodel}

{pstd}
Later, say, in a different session, you can reload those results:

	. {cmd:estimates use basemodel}

{pstd}
The situation is now nearly identical to what it was immediately after you
fit the model.  You can replay estimation results:

	. {cmd:regress}

{pstd} 
You can perform tests: 

	. {cmd:test foreign==0}

{pstd}
And you can use any postestimation command or postestimation capability of
Stata.  The only difference is that Stata no longer knows what the
estimation sample, {cmd:e(sample)} in Stata jargon was.  When you reload the
estimation results, you might not even have the original data in memory.  That
is okay.  Stata will know to refuse to calculate anything that can be
calculated only on the original estimation sample.

{pstd}
If it is important that you use a postestimation command that can be 
used only on the original estimation sample, there is a way you can do that.
You {cmd:use} the original data and then use {cmd:estimates} {cmd:esample:}
to tell Stata what the original sample was.

{pstd} 
See {bf:{help estimates_save:[R] estimates save}} for details.


{marker storing}{...}
{title:Storing and restoring estimation results}

{pstd}
Storing and restoring estimation results in memory is much like saving 
them to disk.  You type 

	. {cmd:estimates store base}

{pstd} 
to save the current estimation results under the name {cmd:base}, and 
you type 

	. {cmd:estimates restore base}

{pstd} 
to get them back later.  You can find out what you have stored by typing 

	. {cmd:estimates dir}

{pstd}
Saving estimation results to disk is more permanent than storing 
them in memory, so why would you want merely to store them?  The 
answer is that, once they are stored, you can use other {cmd:estimates}
commands to produce tables and reports from them.

{pstd}
See {bf:{help estimates_store:[R] estimates store}} for details 
about the {cmd:estimates} {cmd:store} and {cmd:restore} commands.


{marker comparing}{...}
{title:Comparing estimation results}

{pstd}
Let's say that you have done the following:

	. {cmd:sysuse auto}
	. {cmd:regress mpg weight displ}
	. {cmd:estimates store base}
	. {cmd:regress mpg weight displ foreign}
	. {cmd:estimates store alt}

{pstd} 
You can now get a table comparing the coefficients:

	. {cmd:estimates table base alt}

{pstd}
{cmd:estimates} {cmd:table} can do much more; see 
{bf:{help estimates_table:[R] estimates table}}.
Also see 
{bf:{help estimates_stats:[R] estimates stats}}.  
{cmd:estimates} {cmd:stats} works similarly to {cmd:estimates} {cmd:table} but
produces model comparisons in terms of BIC and AIC.
{p_end}
