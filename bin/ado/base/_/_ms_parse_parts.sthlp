{smcl}
{* *! version 1.0.3  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{viewerjumpto "Syntax" "_ms_parse_parts##syntax"}{...}
{viewerjumpto "Description" "_ms_parse_parts##description"}{...}
{viewerjumpto "Stored results" "_ms_parse_parts##results"}{...}
{title:Title}

{p2colset 4 24 27 2}{...}
{p2col:{hi:[P] _ms_parse_parts}}{hline 2}
Parse a single matrix stripe element
{p_end}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_ms_parse_parts} {it:spec}

{pstd}
where {it:spec} is a valid matrix stripe element, excluding the
equation part.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_ms_parse_parts} parses {it:spec} and returns the token parts in
{cmd:r()}.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_ms_parse_parts} stores the following in {cmd:r()}:

{p2colset 9 24 28 2}{...}
{pstd}Scalars{p_end}
{p2col: {cmd:r(omit)}}indicates
	{it:spec} is the base level of a factor variable or {it:spec} is
	tagged as omitted{p_end}
{p2col: {cmd:r(base)}}indicates
	{it:spec} is at base level if {it:spec} is type {cmd:factor}{p_end}
{p2col: {cmd:r(level)}}factor level if {it:spec} is type {cmd:factor}{p_end}
{p2col: {cmd:r(k_names)}}number of names if {it:spec} is type {cmd:interaction}
	or {cmd:product}{p_end}
{p2col: {cmd:r(base}{it:#}{cmd:)}}indicates
	that the {it:#}th factor variable is at the base level if {it:spec} is
	type {cmd:interaction} or {cmd:product}{p_end}
{p2col: {cmd:r(level}{it:#}{cmd:)}}level
	of the {it:#}th factor variable if {it:spec} is type {cmd:interaction}
	or {cmd:product}{p_end}

{pstd}Macros{p_end}
{p2col: {cmd:r(type)}}matrix
	stripe element type: {cmd:variable}, {cmd:error}, {cmd:factor},
	{cmd:interaction}, or {cmd:product}{p_end}
{p2col: {cmd:r(op)}}full operator portion
	if {it:spec} is type {cmd:variable}, {cmd:error}, or
	{cmd:factor}{p_end}
{p2col: {cmd:r(ts_op)}}time-series operator portion
	if {it:spec} is type {cmd:variable}, {cmd:error}, or
	{cmd:factor}{p_end}
{p2col: {cmd:r(name)}}name portion
	if {it:spec} is type {cmd:variable}, {cmd:error}, or
	{cmd:factor}{p_end}
{p2col: {cmd:r(op}{it:#}{cmd:)}}full operator portion of
	the {it:#}th variable if {it:spec} is type {cmd:interaction} or
	{cmd:product}{p_end}
{p2col: {cmd:r(ts_op}{it:#}{cmd:)}}time-series operator portion of
	the {it:#}th variable if {it:spec} is type {cmd:interaction} or
	{cmd:product}{p_end}
{p2col: {cmd:r(name}{it:#}{cmd:)}}name of
	the {it:#}th variable if {it:spec} is type {cmd:interaction} or
	{cmd:product}{p_end}
