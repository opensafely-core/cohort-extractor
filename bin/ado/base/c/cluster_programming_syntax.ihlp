{* *! version 1.0.7  09dec2014}{...}
{pstd}
Obtain various attributes of a cluster analysis

{p 8 23 2}{cmd:cluster} {cmd:query} [{it:clname}]


{pstd}
Set various attributes of a cluster analysis

{p 8 23 2}{cmd:cluster} {cmd:set} [{it:clname}] [{cmd:,} 
{help cluster programming##set_options:{it:set_options}}]


{pstd}
Delete attributes from a cluster analysis

{p 8 23 2}{cmd:cluster} {cmdab:del:ete} {it:clname} [{cmd:,} 
{help cluster programming##delete_options:{it:delete_options}}]


{pstd}
Check similarity and dissimilarity measure name

{p 8 23 2}{cmd:cluster} {cmdab:parsedist:ance} {help measure_option:{it:measure}}


{pstd}
Compute similarity and dissimilarity measure

{p 8 23 2}{cmd:cluster} {cmd:measures} {varlist}
	{ifin} {cmd:,}
	{cmdab:comp:are:(}{it:{help numlist}}{cmd:)}
	{cmdab:gen:erate:(}{it:{help newvarlist:newvarlist}}{cmd:)}
	[{help cluster programming##measures_options:{it:measures_options}}]


{marker set_options}{...}
{synoptset 24}{...}
{synopthdr:set_options}
{synoptline}
{synopt:{opt add:name}}add {it:clname} to the master list of cluster
analyses{p_end}
{synopt:{opt t:ype(type)}}set the cluster type for {it:clname}{p_end}
{synopt:{opt m:ethod(method)}}set the name of the clustering method for the
cluster analysis{p_end}
{synopt:{opth s:imilarity(measure_option:measure)}}set the name of the similarity measure used
for the cluster analysis{p_end}
{synopt:{opth d:issimilarity(measure_option:measure)}}set the name of the dissimilarity measure
used for the cluster analysis{p_end}
{synopt:{cmdab:v:ar(}{it:tag {help varname}}{cmd:)}}set {it:tag} that points to {it:varname}{p_end}
{synopt:{opt c:har(tag charname)}}set {it:tag} that points to
{it:charname}{p_end}
{synopt:{opt o:ther(tag text)}}set {it:tag} with {it:text} attached to the tag
marker{p_end}
{synopt:{opt n:ote(text)}}add a note to the {it:clname}{p_end}
{synoptline}
{p2colreset}{...}

{marker delete_options}{...}
{synoptset 24}{...}
{synopthdr:delete_options}
{synoptline}
{synopt:{opt zap}}delete all possible settings for {it:clname}{p_end}
{synopt:{opt del:name}}remove {it:clname} from the master list of current
cluster analysis{p_end}
{synopt:{opt t:ype}}delete the cluster type entry from {it:clname}{p_end}
{synopt:{opt m:ethod}}delete the cluster method entry from {it:clname}{p_end}
{synopt:{opt s:imilarity}}delete the similarity entries from {it:clname}{p_end}
{synopt:{opt d:issimilarity}}delete the dissimilarity entries from
{it:clname}{p_end}
{synopt:{opth n:otes(numlist)}}delete the specified numbered 
notes from {it:clname}{p_end}
{synopt:{opt alln:otes}}remove all notes from {it:clname}{p_end}
{synopt:{opt v:ar(tag)}}remove {it:tag} from {it:clname}{p_end}
{synopt:{opt allv:ars}}remove all the entries pointing to variables for
{it:clname}{p_end}
{synopt:{opt varz:ap(tag)}}same as {cmd:var()}, but also delete the referenced
variable{p_end}
{synopt:{opt allvarz:ap}}same as {cmd:allvars}, but also delete the
variables{p_end}
{synopt:{opt c:har(tag)}}remove {it:tag} that points to a Stata characteristic
from {it:clname}{p_end}
{synopt:{opt allc:hars}}remove all entries pointing to Stata characteristics
for {it:clname}{p_end}
{synopt:{opt charz:ap(tag)}}same as {cmd:char()}, but also delete the
characteristic{p_end}
{synopt:{opt allcharz:ap}}same as {cmd:allchars}, but also delete the
characteristics{p_end}
{synopt:{opt o:ther(tag)}}delete {it:tag} and its associated text from
{it:clname}{p_end}
{synopt:{opt allo:thers}}delete all entries from {it:clname} that have been set
using {cmd:other()}{p_end}
{synoptline}
{p2colreset}{...}

{marker measures_options}{...}
{synoptset 24 tabbed}{...}
{synopthdr:measures_options}
{synoptline}
{p2coldent :* {opth comp:are(numlist)}}use {it:numlist}
as the comparison observations{p_end}
{p2coldent :* {opth gen:erate(newvarlist)}}create
{it:newvarlist} variables{p_end}
{synopt: {it:{help measure_option:measure}}}(dis)similarity measure; default is 
{cmd:L2}{p_end}
{synopt: {opt propv:ars}}interpret observations implied by {cmd:if} and
{cmd:in} as proportions of binary observations{p_end}
{synopt: {opt propc:ompares}}interpret comparison observations as proportions
of binary observations{p_end}
{synoptline}
{p 4 6 2}* {opt compare(numlist)} and {opt generate(newvarlist)} are
required.{p_end}
{p2colreset}{...}
