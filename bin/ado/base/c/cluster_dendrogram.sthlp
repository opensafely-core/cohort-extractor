{smcl}
{* *! version 1.2.14  19oct2017}{...}
{viewerdialog "cluster dendrogram" "dialog cluster_dendrogram"}{...}
{vieweralsosee "[MV] cluster dendrogram" "mansection MV clusterdendrogram"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] cluster" "help cluster"}{...}
{vieweralsosee "[MV] clustermat" "help clustermat"}{...}
{viewerjumpto "Syntax" "cluster dendrogram##syntax"}{...}
{viewerjumpto "Menu" "cluster dendrogram##menu"}{...}
{viewerjumpto "Description" "cluster dendrogram##description"}{...}
{viewerjumpto "Links to PDF documentation" "cluster_dendrogram##linkspdf"}{...}
{viewerjumpto "Options" "cluster dendrogram##options"}{...}
{viewerjumpto "Examples" "cluster dendrogram##examples"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[MV] cluster dendrogram} {hline 2}}Dendrograms for hierarchical
cluster analysis{p_end}
{p2col:}({mansection MV clusterdendrogram:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

INCLUDE help cluster_dendro_optstab


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis > Cluster analysis > Postclustering >}
        {bf:Dendrograms}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cluster dendrogram} produces dendrograms (also called cluster trees)
for a hierarchical clustering.  See {manhelp cluster MV} for a list of the
available {cmd:cluster} commands.

{pstd}
Dendrograms graphically present the information concerning which observations
are grouped together at various levels of (dis)similarity.  At the bottom of
the dendrogram, each observation is considered its own cluster.  Vertical
lines extend up for each observation, and at various (dis)similarity values,
these lines are connected to the lines from other observations with a
horizontal line.  The observations continue to combine until, at the top of
the dendrogram, all observations are grouped together.

{pstd}
The height of the vertical lines and the range of the (dis)similarity axis
give visual clues about the strength of the clustering.  Long vertical lines
indicate more distinct separation between the groups.  Long vertical lines
at the top of the dendrogram indicate that the groups represented by those
lines are well separated from one another.  Shorter lines indicate groups that
are not as distinct.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV clusterdendrogramQuickstart:Quick start}

        {mansection MV clusterdendrogramRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt quick} switches to a different style of dendrogram in which the vertical
lines go straight up from the observations instead of the default action
of being recentered after each merge of observations in the dendrogram
hierarchy.  Some people prefer this representation, and it is quicker to
render.

{phang}
{opth labels(varname)} specifies that {it:varname} is to
be used in place of observation numbers for labeling the observations at the
bottom of the dendrogram.

{phang}
{opt cutnumber(#)} displays only the top {it:#} branches of
the dendrogram.  With large dendrograms, the lower levels of the tree can become
too crowded.  With {opt cutnumber()}, you can limit your view to the upper
portion of the dendrogram.  Also see the {opt cutvalue()} option.

{phang}
{opt cutvalue(#)} displays only those branches of the dendrogram that are
above the {it:#} (dis)similarity measure.  With large dendrograms, the lower
levels of the tree can become too crowded.  With {opt cutvalue()}, you can
limit your view to the upper portion of the dendrogram.  Also see the
{opt cutnumber()} option.

{phang}
{opt showcount} requests that the number of observations associated with
each branch be displayed below the branches.  {cmd:showcount} is most
useful with {cmd:cutnumber()} and {cmd:cutvalue()} because, otherwise, the
number of observations for each branch is one.  When this option is
specified, a label for each branch is constructed by using a prefix
string, the branch count, and a suffix string.

{phang}
{opth countprefix:(strings:string)} specifies the prefix string for the branch
count label.  The default is {cmd:countprefix(n=)}.  This option implies the
use of the {cmd:showcount} option.

{phang}
{opth countsuffix:(strings:string)} specifies the suffix string for the branch
count label.  The default is an empty string.  This option implies the
use of the {cmd:showcount} option.

{phang}
{opt countinline} requests that the branch count be put in line with the
corresponding branch label.  The branch count is placed below the branch label
by default.  This option implies the use of the {cmd:showcount} option.

{phang}
{opt vertical} and {opt horizontal} specify whether the {it:x} and
{it:y} coordinates are to be swapped before plotting -- {opt vertical}
(the default) does not swap the coordinates, whereas
{opt horizontal} does.

{dlgtab:Plot}

{phang}
{it:line_options} affect the rendition of the lines; see 
{manhelpi line_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} allows adding more {cmd:graph} {cmd:twoway}
plots to the graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for 
saving the graph to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse labtech}{p_end}
{phang2}{cmd:. cluster completelinkage x1 x2 x3 x4, name(L2clnk)}{p_end}
{phang2}{cmd:. cluster generate g3 = group(3)}{p_end}

{pstd}Draw dendrograms{p_end}
{phang2}{cmd:. cluster dendrogram L2clnk, horizontal labels(labt)}{p_end}
{phang2}{cmd:. cluster dendrogram L2clnk, labels(labt) quick}{p_end}

{pstd}Tree is a synonym for dendrogram; show only top 5 branches{p_end}
{phang2}{cmd:. cluster tree if g3==3, showcount}{p_end}

{pstd}Show only branches with dissimilarity greater than 75.3{p_end}
{phang2}{cmd:. cluster dendrogram, cutvalue(75.3)}{p_end}
{phang2}{cmd:. cluster tree, cutvalue(75.3) showcount countinline}{p_end}
