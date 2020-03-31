{smcl}
{* *! version 1.1.9  19oct2017}{...}
{viewerdialog "cluster kmeans" "dialog cluster_kmeans"}{...}
{viewerdialog "cluster kmedians" "dialog cluster_kmedians"}{...}
{vieweralsosee "[MV] cluster kmeans and kmedians" "mansection MV clusterkmeansandkmedians"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] cluster notes" "help cluster_notes"}{...}
{vieweralsosee "[MV] cluster stop" "help cluster_stop"}{...}
{vieweralsosee "[MV] cluster utility" "help cluster_utility"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] cluster" "help cluster"}{...}
{vieweralsosee "[MV] clustermat" "help clustermat"}{...}
{viewerjumpto "Syntax" "cluster kmeans##syntax"}{...}
{viewerjumpto "Menu" "cluster kmeans##menu"}{...}
{viewerjumpto "Description" "cluster kmeans##description"}{...}
{viewerjumpto "Links to PDF documentation" "cluster_kmeans##linkspdf"}{...}
{viewerjumpto "Options" "cluster kmeans##options"}{...}
{viewerjumpto "Examples" "cluster kmeans##examples"}{...}
{p2colset 1 37 39 2}{...}
{p2col:{bf:[MV] cluster kmeans and kmedians} {hline 2}}Kmeans and kmedians
	cluster analysis{p_end}
{p2col:}({mansection MV clusterkmeansandkmedians:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Kmeans cluster analysis

INCLUDE help cluster_kmeans_syntax

    Kmedians cluster analysis

INCLUDE help cluster_kmedians_syntax

INCLUDE help cluster_kmeans_optstab


{marker menu}{...}
{title:Menu}

    {title:cluster kmeans}

{phang2}
{bf:Statistics > Multivariate analysis > Cluster analysis > Cluster data >}
      {bf:Kmeans}

    {title:cluster kmedians}

{phang2}
{bf:Statistics > Multivariate analysis > Cluster analysis > Cluster data >}
       {bf:Kmedians}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cluster kmeans} and {cmd:cluster kmedians} perform kmeans and kmedians
partition cluster analysis, respectively. 
See {manhelp cluster MV} for a listing of the {cmd:cluster} commands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV clusterkmeansandkmediansQuickstart:Quick start}

        {mansection MV clusterkmeansandkmediansRemarksandexamples:Remarks and examples}

        {mansection MV clusterkmeansandkmediansMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt k(#)}
is required and indicates that {it:#} groups are to be formed by the cluster
analysis.

{phang}
{opt measure(measure)}
specifies the similarity or dissimilarity measure. 
The default is {cmd:measure(L2)}, Euclidean distance.  This option is not
case sensitive.  See {manhelpi measure_option MV} for detailed descriptions of
the supported measures.

{phang}
{opt name(clname)}
specifies the name to attach to the resulting cluster analysis.  If
{cmd:name()} is not specified, Stata finds an available cluster name, displays
it for your reference, and attaches the name to your cluster analysis.

{dlgtab:Options}

{marker start()}{...}
{phang}
{opt start(start_option)}
indicates how the {it:k} initial group centers are to be obtained.  The
available {it:start_option}s are

{phang2}
{opt kr:andom}[{cmd:(}{it:seed#}{cmd:)}],
the default, specifies that {it:k} unique observations be chosen at
random, from among those to be clustered, as starting centers for the {it:k}
groups.  Optionally, a random-number seed may be specified to cause the
command {cmd:set seed} {it:seed#} (see {manhelp set_seed R:set seed}) to be
applied before the {it:k} random observations are chosen.

{phang2}
{opt f:irstk}[{cmd:,} {opt ex:clude}]
specifies that the first {it:k} observations from among those to be
clustered be used as the starting centers for the {it:k} groups.  With
the {cmd:exclude} option, these first {it:k} observations are
not included among the observations to be clustered.

{phang2}
{opt l:astk}[{cmd:,} {opt ex:clude}]
specifies that the last {it:k} observations from among those to be clustered
be used as the starting centers for the {it:k} groups.  With 
the {cmd:exclude} option, these last {it:k} observations are then
not included among the observations to be clustered.

{phang2}
{opt r:andom}[{cmd:(}{it:seed#}{cmd:)}]
specifies that {it:k} random initial group centers be generated.  The
values are randomly chosen from a uniform distribution over the range of the
data.  Optionally, a random-number seed may be specified to cause the command
{cmd:set seed} {it:seed#} (see {manhelp set_seed R:set seed}) to be applied
before the {it:k} group centers are generated.

{phang2}
{opt pr:andom}[{cmd:(}{it:seed#}{cmd:)}]
specifies that {it:k} partitions be formed randomly among the
observations to be clustered.  The group means or medians
from the {it:k} groups defined
by this partitioning are to be used as the starting group centers.
Optionally, a random-number seed may be specified to cause the command
{cmd:set seed} {it:seed#} (see {manhelp set_seed R:set seed}) to be applied
before the {it:k} partitions are chosen.

{phang2}
{opt everyk:th}
specifies that {it:k} partitions be formed by assigning observations 1,
1+{it:k}, 1+2{it:k}, ... to the first group; assigning observations 2,
2+{it:k}, 2+2{it:k}, ... to the second group; and so on, to form {it:k}
groups.  The group means or medians from these {it:k} groups are to be used as
the starting group centers.

{phang2}
{opt seg:ments}
specifies that {it:k} nearly equal partitions be formed from the data.
Approximately the first {hi:N}/{it:k} observations are assigned to the first
group, the second {hi:N}/{it:k} observations are assigned to the second group,
and so on.  The group means or medians from these {it:k} groups are to be used
as the starting group centers.

{phang2}
{opth g:roup(varname)}
provides an initial grouping variable, {it:varname}, that defines {it:k}
groups among the observations to be clustered.  The group means or medians
from these {it:k} groups are to be used as the starting group centers.

{phang}
{opt keepcenters}
specifies that the group means or medians from the {it:k} groups that are
produced are to be appended to the data.

{dlgtab:Advanced}

{phang}
{opth generate:(varlist:groupvar)}
provides the name of the grouping variable to be created by
{cmd:cluster kmeans} or {cmd:cluster kmedians}.  By default, this will be the
name specified in {cmd:name()}.

{phang}
{opt iterate(#)}
specifies the maximum number of iterations to allow in the kmeans or kmedians
clustering algorithm.  The default is {cmd:iterate(10000)}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse labtech}

{pstd}Perform kmeans cluster analysis, creating eight groups{p_end}
{phang2}{cmd:. cluster kmeans x1 x2 x3 x4, k(8)}

{pstd}Same as above, but using absolute-value distance instead of Euclidian
distance, naming cluster analysis {cmd:k8abs}{p_end}
{phang2}{cmd:. cluster kmeans x1 x2 x3 x4, k(8) measure(L1) name(k8abs)}

{pstd}Perform kmedians cluster analysis, creating six groups by using the
Canberra distance metric{p_end}
{phang2}{cmd:. cluster kmedians x1 x2 x3 x4, k(6) measure(Canberra)}

{pstd}Create six groups, using the first 6 observations in the dataset as 
starting centers{p_end}
{phang2}{cmd:. cluster kmedians x1 x2 x3 x4, k(6) start(firstk)}

{pstd}Same as above, but do not include the first 6 observations in the 
cluster analysis{p_end}
{phang2}{cmd:. cluster kmedians x1 x2 x3 x4, k(6) start(firstk, exclude)}
{p_end}
