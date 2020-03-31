{smcl}
{* *! version 1.0.0  21jun2019}{...}
{vieweralsosee "[LASSO] estimates store" "mansection lasso estimatesstore"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estimates save" "help estimates save"}{...}
{vieweralsosee "[R] estimates store" "help estimates store"}{...}
{viewerjumpto "Description" "lasso_estimates_store##description"}{...}
{viewerjumpto "Links to PDF documentation" "lasso_estimates_store##linkspdf"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[LASSO] estimates store} {hline 2}}Saving and restoring estimates in
memory and on disk{p_end}
{p2col:}({mansection LASSO estimatesstore:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estimates} {cmd:store} {it:name} stores the current (active) estimation
results under the name {it:name}.

{pstd}
{cmd:estimates} {cmd:restore} {it:name} loads the results stored under
{it:name} into the current (active) estimation results.

{pstd}
{cmd:estimates} {cmd:save} {help filename:{it:filename}} saves the current
(active) estimation results in {it:filename}.

{pstd}
{cmd:estimates} {cmd:use} {it:filename} loads the results saved in
{it:filename} into the current (active) estimation results.

{pstd}
The {cmd:estimates} commands after the lasso commands work the same as they do
after other estimation commands. There is only one difference.  {cmd:estimates}
{cmd:save} {it:filename} saves two files, not just one.
{it:filename}{cmd:.ster} and {it:filename}{cmd:.stxer} are saved.   See
{manhelp estimates R} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO estimatesstoreRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.{p_end}
