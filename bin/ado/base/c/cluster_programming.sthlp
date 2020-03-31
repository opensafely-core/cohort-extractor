{smcl}
{* *! version 1.2.7  19oct2017}{...}
{vieweralsosee "[MV] cluster programming utilities" "mansection MV clusterprogrammingutilities"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] cluster" "help cluster"}{...}
{vieweralsosee "[MV] clustermat" "help clustermat"}{...}
{vieweralsosee "[MV] cluster programming subroutines" "help cluster_subroutines"}{...}
{viewerjumpto "Syntax" "cluster programming##syntax"}{...}
{viewerjumpto "Description" "cluster programming##description"}{...}
{viewerjumpto "Links to PDF documentation" "cluster_programming##linkspdf"}{...}
{viewerjumpto "Options for cluster set" "cluster programming##options_set"}{...}
{viewerjumpto "Options for cluster delete" "cluster programming##options_delete"}{...}
{viewerjumpto "Options for cluster measures" "cluster programming##options_measures"}{...}
{viewerjumpto "Stored results" "cluster programming##results"}{...}
{p2colset 1 39 41 2}{...}
{p2col:{bf:[MV] cluster programming utilities} {hline 2}}Cluster-analysis
programming utilities{p_end}
{p2col:}({mansection MV clusterprogrammingutilities:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

INCLUDE help cluster_programming_syntax


{marker description}{...}
{title:Description}

{p 4 4 2}
The {bind:{cmd:cluster query}}, {bind:{cmd:cluster set}},
{bind:{cmd:cluster delete}}, {bind:{cmd:cluster parsedistance}}, and
{bind:{cmd:cluster measures}} commands provide tools for programmers to add
their own cluster-analysis subroutines to Stata's {cmd:cluster} command; see
{manhelp cluster MV} and
{manhelp cluster_subroutines MV:cluster programming subroutines}.  These
commands make it possible for the new command to take advantage of Stata's
cluster-management facilities.

{p 4 4 2}
{cmd:cluster query} provides a way to obtain the various attributes of a
cluster analysis in Stata.  If {it:clname} is omitted, {cmd:cluster query}
returns in {hi:r(names)} a list of the names of all currently defined cluster
analyses.  If {it:clname} is provided, the various attributes of the
specified cluster analyses are returned in {hi:r()}.  These attributes include
the type, method, (dis)similarity used, created variable names, notes, and
any other information attached to the cluster analysis.

{p 4 4 2}
{cmd:cluster set} allows you to set the various attributes that define a
cluster analysis in Stata, including naming your cluster
results and adding the name to the master list of currently defined cluster
results.  With {cmd:cluster set}, you can provide information on the type,
method, and (dis)similarity measure of your cluster-analysis results.  You can
associate variables and Stata characteristics (see {manhelp char P}) with your
cluster analysis.  {cmd:cluster set} also allows you to add notes and other
specified fields to your cluster-analysis result.  These items become part
of the dataset and are saved with the data.

{p 4 4 2}
{cmd:cluster delete} allows you to delete attributes from a cluster
analysis in Stata.  This command is the inverse of {bind:{cmd:cluster set}}.

{p 4 4 2}
{cmd:cluster parsedistance} takes the similarity or dissimilarity
{it:measure} name and checks it against the list of those provided by 
Stata, taking account of allowed minimal abbreviations and aliases.  Aliases
are resolved (for instance, {cmd:Euclidean} is changed into the equivalent
{cmd:L2}).

{p 4 4 2}
{cmd:cluster measures} computes the similarity or dissimilarity {it:measure}
between the observations listed in the {cmd:compare()} option and the
observations included based on the {cmd:if} and {cmd:in} conditions and places
the results in the variables specified by the {cmd:generate()} option.  See
{manhelp matrix_dissimilarity MV:matrix dissimilarity} for the
{cmd:matrix dissimilarity} command that places (dis)similarities in a matrix.

{p 4 4 2}
Stata also provides a method for programmers to extend the {cmd:cluster}
command by providing subcommands; see
{manhelp cluster_subroutines MV:cluster programming subroutines}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV clusterprogrammingutilitiesRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_set}{...}
{title:Options for cluster set}

{phang}
{cmd:addname} adds {it:clname} to the master list of currently defined
cluster analyses.  When {it:clname} is not specified, the {cmd:addname} option
is mandatory, and here, {bind:{cmd:cluster set}} automatically finds a
cluster name that is not currently in use and uses this as the cluster name.
{bind:{cmd:cluster set}} returns the name of the cluster in {hi:r(name)}.  If
{cmd:addname} is not specified, the {it:clname} must have been
added to the master list previously (for instance, through a previous call to
{bind:{cmd:cluster set}}).

{phang}
{cmd:type(}{it:type}{cmd:)} sets the cluster type for {it:clname}.
{cmd:type(hierarchical)} indicates that the cluster analysis
is hierarchical-style clustering, and {cmd:type(partition)} indicates that it
is a partition-style clustering.  You are not restricted to these types.
For instance, you might program some kind of fuzzy partition-clustering
analysis, so you then use {cmd:type(fuzzy)}.

{phang}
{cmd:method(}{it:method}{cmd:)} sets the name of the clustering method
for the cluster analysis.  For instance, Stata uses {cmd:method(kmeans)} to
indicate a kmeans cluster analysis and uses {cmd:method(single)} to indicate
single-linkage cluster analysis.  You are not restricted to the names
currently used within Stata.

{phang}
{cmd:similarity(}{it:measure}{cmd:)} and
{cmd:dissimilarity(}{it:measure}{cmd:)}
 set the name of the similarity or
dissimilarity measure used for the cluster analysis.  For example, Stata uses
{cmd:dissimilarity(L2)} to indicate the L2 or Euclidean distance.  You are not
restricted to the names currently used within Stata.  See
{manhelpi measure_option MV} and {manlink MV cluster} for a listing and
discussion of (dis)similarity measures.  See {manhelp parse_dissim MV} for a
programmer's command for parsing (dis)similarity names.

{phang}
{cmd:var(}{it:tag {help varname}}{cmd:)} sets a marker called {it:tag} in the
cluster analysis that points to the variable {it:varname}.  For instance,
Stata uses {bind:{cmd:var(group} {it:varname}{cmd:)}} to set a grouping
variable from a kmeans cluster analysis.  With single-linkage clustering,
Stata uses {bind:{cmd:var(id} {it:idvarname}{cmd:)}},
{bind:{cmd:var(order} {it:ordervarname}{cmd:)}}, and
{bind:{cmd:var(height} {it:hgtvarname}{cmd:)}} to set the {cmd:id},
{cmd:order}, and {cmd:height} variables that define the cluster-analysis result.
You are not restricted to the names currently used within Stata.  Up to 10
{cmd:var()} options may be specified with a {bind:{cmd:cluster set}}
command.

{phang}
{cmd:char(}{it:tag charname}{cmd:)} sets a marker called {it:tag} in
the cluster analysis that points to the Stata characteristic named
{it:charname}; see {manhelp char P}.  This characteristic can be either an
{hi:_dta[]} dataset characteristic or a variable characteristic.  Up to 10
{cmd:char()} options may be specified with a {bind:{cmd:cluster set}}
command.

{phang}
{cmd:other(}{it:tag text}{cmd:)} sets a marker called {it:tag} in
the cluster analysis with {it:text} attached to the {it:tag} marker.  Stata
uses {bind:{cmd:other(k} {it:#}{cmd:)}} to indicate that {hi:k} (the number
of groups) was {it:#} in a kmeans cluster analysis.  You are not restricted
to the names currently used within Stata.  Up to 10 {cmd:other()}
options may be specified with a {bind:{cmd:cluster set}} command.

{phang}
{cmd:note(}{it:text}{cmd:)} adds a note to the {it:clname} cluster
analysis.  The {bind:{cmd:cluster notes}} command (see
{manhelp cluster_notes MV:cluster notes})
is the command to add, delete, or view cluster notes.  The
{bind:{cmd:cluster notes}} command uses the {cmd:note()} option of
{bind:{cmd:cluster set}} to add a note to a cluster analysis.
Up to 10 {cmd:note()} options may be specified with a 
{bind:{cmd:cluster set}} command.


{marker options_delete}{...}
{title:Options for cluster delete}

{phang}
{cmd:zap} deletes all possible settings for cluster analysis {it:clname}.
It is the same as specifying the {cmd:delname}, {cmd:type}, {cmd:method},
{cmd:similarity}, {cmd:dissimilarity}, {cmd:allnotes}, {cmd:allcharzap},
{cmd:allothers}, and {cmd:allvarzap} options.

{phang}
{cmd:delname} removes {it:clname} from the master list of current
cluster analyses.  This option does not affect the various settings
that make up the cluster analysis.  To remove them, use the other options of
{bind:{cmd:cluster delete}}.

{phang}
{cmd:type} deletes the cluster type entry from {it:clname}.

{phang}
{cmd:method} deletes the cluster method entry from {it:clname}.

{phang}
{cmd:similarity} and {cmd:dissimilarity} delete the similarity and
dissimilarity entries, respectively, from {it:clname}.

{phang}
{opth notes(numlist)} deletes the specified numbered notes
from {it:clname}.  The numbering corresponds to the returned results from the
{bind:{cmd:cluster query} {it:clname}} command.  The
{bind:{cmd:cluster notes drop}} command (see
{manhelp cluster_notes MV:cluster notes}) drops a cluster note.  It, in turn,
calls {bind:{cmd:cluster delete}}, using the {cmd:notes()} option to drop the
notes.

{phang}
{cmd:allnotes} removes all notes from the {it:clname} cluster analysis.

{phang}
{cmd:var(}{it:tag}{cmd:)} removes from {it:clname} the entry labeled
{it:tag} that points to a variable.  This option does not delete the variable.

{phang}
{cmd:allvars} removes all the entries pointing to variables for
{it:clname}.  This option does not delete the corresponding variables.

{phang}
{cmd:varzap(}{it:tag}{cmd:)} is the same as {cmd:var()} and actually deletes
the variable in question.

{phang}
{cmd:allvarzap} is the same as {cmd:allvars} and actually deletes
the variables.

{phang}
{cmd:char(}{it:tag}{cmd:)} removes from {it:clname} the entry labeled
{it:tag} that points to a Stata characteristic (see {manhelp char P}).  This
option does not delete the characteristic.

{phang}
{cmd:allchars} removes all the entries pointing to Stata characteristics
for {it:clname}.  This option does not delete the characteristics.

{phang}
{cmd:charzap(}{it:tag}{cmd:)} is the same as {cmd:char()} and actually
deletes the characteristics.

{phang}
{cmd:allcharzap} is the same as {cmd:allchars} and
actually deletes the characteristics.

{phang}
{cmd:other(}{it:tag}{cmd:)} deletes from {it:clname} the {it:tag} entry
and its associated text, which were set by using the {cmd:other()} option of
the {bind:{cmd:cluster set}} command.

{phang}
{cmd:allothers} deletes all entries from {it:clname} that have been
set using the {cmd:other()} option of the {bind:{cmd:cluster set}} command.


{marker options_measures}{...}
{title:Options for cluster measures}

{phang}
{opth compare(numlist)} is required and specifies the
observations to use as the comparison observations.  Each of these
observations will be compared with the observations implied by the {cmd:if} and
{cmd:in} conditions, using the specified (dis)similarity {it:measure}.  The
results are stored in the corresponding new variable from the {cmd:generate()}
option.  There must be the same number of elements in {it:numlist} as there
are variable names in the {cmd:generate()} option.

{phang}
{opth generate(newvarlist)} is required and specifies the
names of the variables to be created.  There must be as many elements in
{it:newvarlist} as there are numbers specified in the {cmd:compare()} option.

{phang}
{it:measure} specifies the similarity or dissimilarity measure. 
The default is {opt L2}  (synonym {opt Euc:lidean}).  This option is not case
sensitive.  See {manhelpi measure_option MV} for detailed descriptions of the
supported measures.

{phang}
{cmd:propvars} is for use with binary measures and specifies that
the observations implied by the {cmd:if} and {cmd:in} conditions be
interpreted as proportions of binary observations.  The default action with
binary measures treats all nonzero values as one (excluding missing values).
With {cmd:propvars}, the values are confirmed to be between zero and one,
inclusive.  See {manhelpi measure_option MV} for a discussion of the use of
proportions with binary measures.

{phang}
{cmd:propcompares} is for use with binary measures.  It indicates that
the comparison observations (those specified in the {cmd:compare()} option)
are to be interpreted as proportions of binary observations. The default
action with binary measures treats all nonzero values as one (excluding
missing values).  With {cmd:propcompares}, the values are confirmed to be
between zero and one, inclusive.  See {manhelpi measure_option MV} for a
discussion of the use of proportions with binary measures.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:cluster query} with no arguments stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(names)}}cluster solution names{p_end}

{pstd}
{cmd:cluster query} with an argument stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(name)}}cluster name{p_end}
{synopt:{cmd:r(type)}}type of cluster analysis{p_end}
{synopt:{cmd:r(method)}}cluster-analysis method{p_end}
{synopt:{cmd:r(similarity)}}similarity measure name{p_end}
{synopt:{cmd:r(dissimilarity)}}dissimilarity measure name{p_end}
{synopt:{cmd:r(note}{it:#}{cmd:)}}cluster note number {it:#}{p_end}
{synopt:{cmd:r(v}{it:#}{cmd:_tag)}}variable tag number {it:#}{p_end}
{synopt:{cmd:r(v}{it:#}{cmd:_name)}}varname associated with
                    {cmd:r(v}{it:#}{cmd:_tag)}{p_end}
{synopt:{cmd:r(}{it:tag}{cmd:var)}}varname associated with {it:tag}{p_end}
{synopt:{cmd:r(c}{it:#}{cmd:_tag)}}characteristic tag number {it:#}{p_end}
{synopt:{cmd:r(c}{it:#}{cmd:_name)}}characteristic name associated with
                    {cmd:r(c}{it:#}{cmd:_tag)}{p_end}
{synopt:{cmd:r(c}{it:#}{cmd:_val)}}characteristic value associated with
                    {cmd:r(c}{it:#}{cmd:_tag)}{p_end}
{synopt:{cmd:r(}{it:tag}{cmd:char)}}characteristic name associated with {it:tag}{p_end}
{synopt:{cmd:r(o}{it:#}{cmd:_tag)}}other tag number {it:#}{p_end}
{synopt:{cmd:r(o}{it:#}{cmd:_val)}}other value associated with {cmd:r(o}{it:#}{cmd:_tag)}{p_end}

{pstd}
{cmd:cluster set} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(name)}}cluster name{p_end}

{pstd}
{cmd:cluster parsedistance} stores the following in {cmd:s()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:s(dist)}}(dis)similarity measure name{p_end}
{synopt:{cmd:s(unab)}}unabbreviated (dis)similarity measure name (before
      resolving alias){p_end}
{synopt:{cmd:s(darg)}}argument of (dis)similarities that take them, such as
{opt L(#)}{p_end}
{synopt:{cmd:s(dtype)}}{cmd:similarity} or {cmd:dissimilarity}{p_end}
{synopt:{cmd:s(drange)}}range of measure (most similar to most dissimilar){p_end}
{synopt:{cmd:s(binary)}}{cmd:binary} if the measure is for binary
observations{p_end}

{pstd}
{cmd:cluster measures} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(generate)}}variable names from the {cmd:generate()} option{p_end}
{synopt:{cmd:r(compare)}}observation numbers from the {cmd:compare()} option{p_end}
{synopt:{cmd:r(dtype)}}{cmd:similarity} or {cmd:dissimilarity}{p_end}
{synopt:{cmd:r(distance)}}the name of the (dis)similarity measure{p_end}
{synopt:{cmd:r(binary)}}{cmd:binary} if the measure is for binary
observations{p_end}
{p2colreset}{...}
