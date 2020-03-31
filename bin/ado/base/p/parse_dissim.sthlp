{smcl}
{* *! version 1.0.6  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] cluster programming utilities" "help cluster_programming"}{...}
{vieweralsosee "[P] matrix dissimilarity" "help matrix_dissimilarity"}{...}
{vieweralsosee "[MV] measure_option" "help measure_option"}{...}
{viewerjumpto "Syntax" "parse_dissim##syntax"}{...}
{viewerjumpto "Description" "parse_dissim##description"}{...}
{viewerjumpto "Option" "parse_dissim##option"}{...}
{viewerjumpto "Example" "parse_dissim##example"}{...}
{viewerjumpto "Stored results" "parse_dissim##results"}{...}
{title:Title}

{p 4 22 2}
{hi:[MV] parse_dissim} {hline 2} Parse similarity and dissimilarity measures


{marker syntax}{...}
{title:Syntax}

{p 8 21 2}
{cmd:parse_dissim} [{it:{help measure_option:measure}}]
[{cmd:,} {cmd:default(}{it:default_{help measure_option:measure}}{cmd:)} ]


{marker description}{...}
{title:Description}

{pstd}
{cmd:parse_dissim} takes the similarity or dissimilarity name found in
{it:measure} and checks it against the list of those provided by Stata, taking
account of allowed minimal abbreviations and aliases.  Aliases are resolved
(for instance, {cmd:Euclidean} is changed into the equivalent {cmd:L2}).  The
resolved name and other information about the {it:measure} is returned in
{cmd:s()} (see below).  An error message is produced and return code 198 is
returned if {it:measure} is not one of the allowed similarity and
dissimilarity measures.  See {manhelpi measure_option MV} for a listing of
allowed similarity and dissimilarity {it:measure}s and their definitions.


{marker option}{...}
{title:Option}

{phang}
{opt default(default_measure)}
    specifies the default similarity or dissimilarity measure when
    {it:measure} is not specified.  The default for {cmd:default()} is
    {cmd:L2} (alias Euclidean distance).  See {manhelpi measure_option MV} for
    a list of allowed measures.


{marker example}{...}
{title:Example}

    Within a program

	...
	{cmd:parse_dissim `sim'}
	{cmd:local sim "`s(dist)'"}
	{cmd:if "`s(dtype)'" != "similarity" | "`s(binary)'" != "binary" {c -(}}
		{cmd:di as error "only binary similarity measures are allowed"}
		{cmd:exit 198}
	{cmd:{c )-}}
	...


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:parse_dissim} stores the following in {cmd:s()}:

    Macros
{p2colset 9 22 26 2}{...}
{p2col:{cmd:s(dist)}}
	(dis)similarity measure name unabbreviated and with aliases resolved
	{p_end}
{p2col:{cmd:s(unab)}}
	(dis)similarity measure name unabbreviated but without aliases resolved
	{p_end}
{p2col:{cmd:s(darg)}}
	argument (enclosed in parentheses) of (dis)similarities that take them,
	such as {cmd:L(}{it:#}{cmd:)}
	{p_end}
{p2col:{cmd:s(dtype)}}
	the word {cmd:similarity} or {cmd:dissimilarity}
	{p_end}
{p2col:{cmd:s(drange)}}
	range of measure (most similar to most dissimilar); a dot means
	infinity
	{p_end}
{p2col:{cmd:s(binary)}}
	the word {cmd:binary} if the measure is for binary observations
	{p_end}
{p2colreset}{...}
