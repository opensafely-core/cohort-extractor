{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] st_store()" "mansection M-5 st_store()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_addvar()" "help mf_st_addvar"}{...}
{vieweralsosee "[M-5] st_data()" "help mf_st_data"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] putmata" "help putmata"}{...}
{viewerjumpto "Syntax" "mf_st_store##syntax"}{...}
{viewerjumpto "Description" "mf_st_store##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_store##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_store##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_store##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_store##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_store##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] st_store()} {hline 2}}Modify values stored in current Stata dataset
{p_end}
{p2col:}({mansection M-5 st_store():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    {it:void} {cmd:_st_store(}{it:real scalar i}{cmd:,} {it:real scalar j}{cmd:,} {it:real scalar x}{cmd:)}

    {it:void}  {cmd:st_store(}{it:real matrix i}{cmd:,} {it:rowvector j}{cmd:,} {it:real matrix X}{cmd:)}{right:(1,2)}

    {it:void}  {cmd:st_store(}{it:real matrix i}{cmd:,} {it:rowvector j}{cmd:,} {it:scalar selectvar}{cmd:,}
{col 55}{it:real matrix X}{cmd:)}{right:(1,2,3)}


    {it:void} {cmd:_st_sstore(}{it:real scalar i}{cmd:,} {it:real scalar j}{cmd:,} {it:string scalar s}{cmd:)}

    {it:void}  {cmd:st_sstore(}{it:real matrix i}{cmd:,} {it:rowvector j}{cmd:,} {it:string matrix X}{cmd:)}{right:(1,2)}

    {it:void}  {cmd:st_sstore(}{it:real matrix i}{cmd:,} {it:rowvector j}{cmd:,} {it:scalar selectvar}{cmd:,}
{col 55}{it:string matrix X}{cmd:)}{right:(1,2,3)}


{p 4 4 2}
where

{p 7 11 2}
1.  {it:i} may be specified in the same way as with 
    {bf:{help mf_st_data:st_data()}}.

{p 7 11 2}
2.  {it:j} may be specified in the same way as with 
    {bf:{help mf_st_data:st_data()}}, except that time-series operators 
    may not be specified.

{p 7 11 2}
3.  {it:selectvar} may be specified in the same way as with 
    {bf:{help mf_st_data:st_data()}}.


{marker description}{...}
{title:Description}

{p 4 4 2}
These functions mirror {cmd:_st_data()}, {cmd:st_data()}, and
{cmd:st_sdata()}.  Rather than returning the contents from the Stata dataset,
these commands change those contents to be as given by the last argument.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_store()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
See {bf:{help mf_st_data:[M-5] st_data()}}.


{marker conformability}{...}
{title:Conformability}

{p 4 8 2}
{cmd:_st_store(}{it:i}, {it: j}{cmd:,} {it:x}{cmd:)},
{cmd:_st_sstore(}{it:i}, {it: j}{cmd:,} {it:x}{cmd:)}:
{p_end}
		{it:i}:  1 {it:x} 1
		{it:j}:  1 {it:x} 1
		{it:x}:  1 {it:x} 1
	   {it:result}:  {it:void}

{p 4 8 2}
{cmd:st_store(}{it:i}, {it:j}{cmd:,} {it:X}{cmd:)},
{cmd:st_sstore(}{it:i}, {it:j}{cmd:,} {it:X}{cmd:)}:
{p_end}
		{it:i}:  {it:n x} 1  or  {it:n2 x} 2
		{it:j}:  1 {it:x k}
		{it:X}:  {it:n x k}
	   {it:result}:  {it:void}

{p 4 8 2}
{cmd:st_store(}{it:i}, {it:j}, {it:selectvar}{cmd:,} {it:X}{cmd:)},
{cmd:st_sstore(}{it:i}, {it:j}, {it:selectvar}{cmd:,} {it:X}{cmd:)}:
{p_end}
		{it:i}:  {it:n x} 1  or  {it:n2 x} 2
		{it:j}:  1 {it:x k}
	{it:selectvar}:  1 {it:x} 1
		{it:X}:  ({it:n}-{it:e}) {it:x k}, where {it:e} is number of
                    observations excluded by {it:selectvar}
	   {it:result}:  {it:void}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:_st_store(}{it:i}{cmd:,} {it:j}{cmd:,} {it:x}{cmd:)} 
and 
{cmd:_st_sstore(}{it:i}{cmd:,} {it:j}{cmd:,} {it:s}{cmd:)} 
do nothing if {it:i} or {it:j} is out of range; they do not abort with
error.

{p 4 4 2}
{cmd:st_store(}{it:i}{cmd:,} {it:j}{cmd:,} {it:X}{cmd:)} 
and
{cmd:st_sstore(}{it:i}{cmd:,} {it:j}{cmd:,} {it:s}{cmd:)} 
abort with error if any element of {it:i} or {it:j} is out of range.
{it:j} may be specified as a vector of variable names or as a 
vector of variable indices.  If names are specified, abbreviations are 
allowed.  If you do not want this, use {cmd:st_varindex()} (see
{bf:{help mf_st_varindex:[M-5] st_varindex()}}) to translate 
variable names into variable indices.

{p 4 4 2}
{cmd:st_store()} 
and 
{cmd:st_sstore()} 
abort with error if {it:X} is not
{help m6_glossary##p-conformability:p-conformable} with 
the matrix that {cmd:st_data()} ({cmd:st_sdata()}) would return.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
