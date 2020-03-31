{smcl}
{* *! version 1.1.15  19oct2017}{...}
{viewerdialog "cluster stop" "dialog cluster_stop"}{...}
{viewerdialog "clustermat stop" "dialog clustermat_stop"}{...}
{vieweralsosee "[MV] cluster stop" "mansection MV clusterstop"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] cluster" "help cluster"}{...}
{vieweralsosee "[MV] clustermat" "help clustermat"}{...}
{viewerjumpto "Syntax" "cluster stop##syntax"}{...}
{viewerjumpto "Menu" "cluster stop##menu"}{...}
{viewerjumpto "Description" "cluster stop##description"}{...}
{viewerjumpto "Links to PDF documentation" "cluster_stop##linkspdf"}{...}
{viewerjumpto "Options" "cluster stop##options"}{...}
{viewerjumpto "Examples" "cluster stop##examples"}{...}
{viewerjumpto "Stored results" "cluster stop##results"}{...}
{viewerjumpto "Reference" "cluster stop##reference"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[MV] cluster stop} {hline 2}}Cluster-analysis stopping rules{p_end}
{p2col:}({mansection MV clusterstop:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

INCLUDE help cluster_stop_syntax


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis > Cluster analysis > Postclustering >}
        {bf:Cluster analysis stopping rules}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cluster} {cmd:stop} and {cmd:clustermat} {cmd:stop} compute the
stopping-rule value for each cluster solution.  The commands currently provide
two stopping rules, the Calinski and Harabasz pseudo-F index and the Duda-Hart
Je(2)/Je(1) index.  For both rules, larger values indicate more distinct
clustering.  Presented with the Duda-Hart Je(2)/Je(1) values are
pseudo-T-squared values.  Smaller pseudo-T-squared values indicate more
distinct clustering.

{pstd}
Users can add more {cmd:stop} rules; see
{manhelp cluster_subroutines MV:cluster programming subroutines}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV clusterstopQuickstart:Quick start}

        {mansection MV clusterstopRemarksandexamples:Remarks and examples}

        {mansection MV clusterstopMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{marker rule()}{...}
{phang}
{cmd:rule(calinski} | {cmd:duda} | {it:rule_name}{cmd:)} indicates the
stopping rule.  {cmd:rule(calinski)}, the default, specifies the
Calinski-Harabasz pseudo-F index.  {cmd:rule(duda)} specifies the Duda-Hart 
Je(2)/Je(1) index.

{pmore}
{cmd:rule(calinski)} is allowed for both hierarchical and nonhierarchical
cluster analyses.  {cmd:rule(duda)} is allowed only for hierarchical cluster
analyses.

{pmore}
You can add stopping rules to the {cmd:cluster} {cmd:stop} command (see
{manhelp cluster_subroutines MV:cluster programming subroutines}) by using the
{opt rule(rule_name)} option.  
{manhelp cluster_subroutines MV:cluster programming subroutines}
illustrates how to add stopping rules by showing a program that adds a
{cmd:rule(stepsize)} option, which implements the simple step-size stopping
rule mentioned in 
{help cluster stop##MC1985:Milligan and Cooper (1985)}.

{phang}
{opth groups(numlist)} specifies the cluster groupings for which the
stopping rule is to be computed.  {cmd:groups(3/20)} specifies that the
measure be computed for the three-group solution, the four-group
solution, ..., and the 20-group solution.

{pmore}
With {cmd:rule(duda)}, the default is {cmd:groups(1/15)}.  With
{cmd:rule(calinski)} for a hierarchical cluster analysis, the default is
{cmd:groups(2/15)}.  {cmd:groups(1)} is not allowed with
{cmd:rule(calinski)} because the measure is not defined for the degenerate
one-group cluster solution.  The {cmd:groups()} option is unnecessary
(and not allowed) for a nonhierarchical cluster analysis.

{pmore}
If there are ties in the hierarchical cluster-analysis structure, some (or
possibly all) of the requested stopping-rule solutions may not be computable.
{bind:{cmd:cluster stop}} passes over, without comment, the {cmd:groups()} for
which ties in the hierarchy cause the stopping rule to be undefined.

{phang}
{opt matrix(matname)} saves the results in a matrix named {it:matname}.

{pmore}
With {cmd:rule(calinski)}, the matrix has two columns, the first
giving the number of clusters and the second giving the corresponding
Calinski-Harabasz pseudo-F stopping-rule index.

{pmore}
With {cmd:rule(duda)}, the matrix has three columns: the first column gives
the number of clusters, the second column gives the corresponding
Duda-Hart Je(2)/Je(1) stopping-rule index, and the third column provides
the corresponding pseudo-T-squared values.

{phang}
{opth variables(varlist)} specifies the variables to be used in the computation
of the stopping rule.  By default, the variables used for the cluster analysis
are used.  {cmd:variables()} is required for cluster solutions produced by
{cmd:clustermat}.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. cluster stop}{p_end}
{phang}{cmd:. cluster stop myclus, rule(duda)}{p_end}
{phang}{cmd:. cluster stop, rule(calinski) groups(2/20) matrix(z)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:cluster stop} and {cmd:clustermat stop} with {cmd:rule(calinski)}
stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(calinski_}{it:#}{cmd:)}}Calinski-Harabasz pseudo-F for # groups{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(rule)}}{cmd:calinski}{p_end}
{synopt:{cmd:r(label)}}{cmd:C-H pseudo-F}{p_end}
{synopt:{cmd:r(longlabel)}}{cmd:Calinski & Harabasz pseudo-F}{p_end}

{pstd}
{cmd:cluster stop} and {cmd:clustermat stop} with {cmd:rule(duda)}
stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(duda_}{it:#}{cmd:)}}Duda-Hart Je(2)/Je(1) value for # groups{p_end}
{synopt:{cmd:r(dudat2_}{it:#}{cmd:)}}Duda-Hart pseudo-T-squared value for # groups{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(rule)}}{cmd:duda}{p_end}
{synopt:{cmd:r(label)}}{cmd:D-H Je(2)/Je(1)}{p_end}
{synopt:{cmd:r(longlabel)}}{cmd:Duda & Hart Je(2)/Je(1)}{p_end}
{synopt:{cmd:r(label2)}}{cmd:D-H pseudo-T-squared}{p_end}
{synopt:{cmd:r(longlabel2)}}{cmd:Duda & Hart pseudo-T-squared}{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker MC1985}{...}
{phang}
Milligan, G. W., and M. C. Cooper. 1985.
An examination of procedures for determining the number of clusters in a
dataset. {it:Psychometrika} 50: 159-179.
{p_end}
