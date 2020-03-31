{smcl}
{* *! version 2.1.11  22jun2019}{...}
{viewerdialog "estimates store" "dialog estimates_store"}{...}
{viewerdialog "estimates restore" "dialog estimates_restore"}{...}
{viewerdialog "estimates dir" "dialog estimates_dir"}{...}
{viewerdialog "estimates drop" "dialog estimates_drop"}{...}
{vieweralsosee "[R] estimates store" "mansection R estimatesstore"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estimates" "help estimates"}{...}
{vieweralsosee "[LASSO] estimates store" "help lasso estimates store"}{...}
{viewerjumpto "Syntax" "estimates_store##syntax"}{...}
{viewerjumpto "Menu" "estimates_store##menu"}{...}
{viewerjumpto "Description" "estimates_store##description"}{...}
{viewerjumpto "Links to PDF documentation" "estimates_store##linkspdf"}{...}
{viewerjumpto "Option" "estimates_store##option"}{...}
{viewerjumpto "Example" "estimates_store##example"}{...}
{viewerjumpto "Stored results" "estimates_store##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[R] estimates store} {hline 2}}Store and restore estimation results{p_end}
{p2col:}({mansection R estimatesstore:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{opt est:imates} {opt sto:re}{bind:  }
{it:name}
[{cmd:,} 
{cmd:nocopy}]

{p 8 12 2}
{opt est:imates} {opt res:tore}
{it:name}


{p 8 12 2}
{opt est:imates} {opt q:uery}

{p 8 12 2}
{opt est:imates} {cmd:dir}{bind:    }
[{it:namelist}]


{p 8 12 2}
{opt est:imates} {cmd:drop}{bind:   }
{it:namelist}

{p 8 12 2}
{opt est:imates} {cmd:clear}


{phang}
where {it:namelist} is a name, a list of names, {cmd:_all}, or 
{cmd:*}.{break}
{cmd:_all} and {cmd:*} mean the same thing.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estimates} {cmd:store} {it:name} saves the current (active)
estimation results under the name {it:name}.

{pstd}
{cmd:estimates} {cmd:restore} {it:name} loads the results stored under
{it:name} into the current (active) estimation results.

{pstd}
{cmd:estimates} {cmd:query} tells you whether the current (active) estimates
have been stored and, if so, the name.  

{pstd}
{cmd:estimates} {cmd:dir} displays a list of the stored estimates.

{pstd}
{cmd:estimates} {cmd:drop} {it:namelist} 
drops the specified stored estimation results.

{pstd}
{cmd:estimates} {cmd:clear}
drops all stored estimation results.  

{pstd}
{cmd:estimates} {cmd:clear}, 
{cmd:estimates} {cmd:drop} {cmd:_all}, and 
{cmd:estimates} {cmd:drop} {cmd:*} do the same thing.
{cmd:estimates} {cmd:drop} and {cmd:estimates} {cmd:clear} 
do not eliminate the current (active) estimation results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R estimatesstoreQuickstart:Quick start}

        {mansection R estimatesstoreRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:nocopy}, used with {cmd:estimates} {cmd:store}, specifies that 
    the current (active) estimation results are to be moved 
    into {it:name} rather than copied.  Typing 

		. {cmd:estimates store hold, nocopy}

{pmore}
    is the same as typing 

		. {cmd:estimates store hold}
		. {cmd:ereturn clear}

{pmore}
    except that the former is faster.  The {cmd:nocopy} option is sometimes
    used by programmers.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress mpg weight displ}

{pstd}Store results{p_end}
{phang2}{cmd:. estimates store myreg}

{phang2}{cmd:.} ... {it:you do other things, including fitting other models} ...

{pstd}Restore regression results{p_end}
{phang2}{cmd:. estimates restore myreg}

{pstd}For comparison, the same output is shown again{p_end}
{phang2}{cmd:. regress}

{pstd}List stored estimates{p_end}
{phang2}{cmd:. estimates dir}

{pstd}Drop estimates stored as {cmd:myreg}{p_end}
{phang2}{cmd:. estimates drop myreg}

{pstd}
After {cmd:estimates} {cmd:restore} {cmd:myreg}, things are once again just as
they were, estimationwise, just after you typed {cmd:regress} {cmd:mpg}
{cmd:weight} {cmd:displ}.

{pstd}
{cmd:estimates} {cmd:store} stores results in memory.
When you exit Stata, those stored results vanish.  If you wish 
to make a permanent copy of your estimation results, see 
{bf:{help estimates_save:[R] estimates save}}.

{pstd}
The purpose of making copies in memory is (1) so that you can quickly 
switch between them and (2) so that you make tables comparing estimation 
results.  Concerning the latter, see 
{bf:{help estimates_table:[R] estimates table}}
and 
{bf:{help estimates_stats:[R] estimates stats}}.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estimates} {cmd:dir} stores the following in {cmd:r()}:

		Macros
		    {cmd:r(names)}   names of stored results
