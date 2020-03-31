{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] invtokens()" "mansection M-5 invtokens()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] gettoken" "help gettoken"}{...}
{vieweralsosee "[P] tokenize" "help tokenize"}{...}
{vieweralsosee "[M-5] tokenget()" "help mf_tokenget"}{...}
{vieweralsosee "[M-5] tokens()" "help mf_tokens"}{...}
{vieweralsosee "[M-5] ustrword()" "help mf_ustrword"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Strings" "help m4_string"}{...}
{viewerjumpto "Syntax" "mf_invtokens##syntax"}{...}
{viewerjumpto "Description" "mf_invtokens##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_invtokens##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_invtokens##remarks"}{...}
{viewerjumpto "Conformability" "mf_invtokens##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_invtokens##diagnostics"}{...}
{viewerjumpto "Source code" "mf_invtokens##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] invtokens()} {hline 2}}Concatenate string rowvector into string scalar
{p_end}
{p2col:}({mansection M-5 invtokens():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string scalar}
{cmd:invtokens(}{it:string rowvector s}{cmd:)}

{p 8 12 2}
{it:string scalar}
{cmd:invtokens(}{it:string rowvector s}{cmd:,} {it:string scalar c}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:invtokens(}{it:s}{cmd:)} returns the elements of {it:s}, concatenated
into a string scalar with the elements separated by spaces.
{cmd:invtokens(}{it:s}{cmd:)} is equivalent to 
{cmd:invtokens(}{it:s}, {cmd:" ")}.

{p 4 4 2}
{cmd:invtokens(}{it:s}{cmd:,} {it:c}{cmd:)} returns the elements of {it:s},
concatenated into a string scalar with the elements separated by {it:c}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 invtokens()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:invtokens(}{it:s}{cmd:)} is the inverse of {cmd:tokens()} (see
{bf:{help mf_tokens:[M-5] tokens()}}); 
{cmd:invtokens()}
returns the string obtained by concatenating the elements of 
{it:s} into a space-separated list.

{p 4 4 2}
{cmd:invtokens(}{it:s}{cmd:,} {it:c}{cmd:)}
places {it:c} between the elements of
{it:s} even when the elements of {it:s} are equal to {cmd:""}.
For instance,

        {cmd:: s = ("alpha", "", "gamma", "")}

        {cmd:: invtokens(s, ";")}
          alpha;;gamma;

{p 4 4 2}
{txt}To remove separators between empty elements, use {cmd:select()} (see
{bf:{help mf_select:[M-5] select()}}) to remove the empty
elements from {it:s} beforehand:

        {cmd:: s2 = select(s, strlen(s):>0)}

        {cmd:: s2}
                  1      2
            {c TLC}{hline 17}{c TRC}
          1 {c |}  alpha   gamma  {c |}
            {c BLC}{hline 17}{c BRC}

        {cmd:: invtokens(s2, ";")}
          alpha;gamma


{marker conformability}{...}
{title:Conformability}

    {cmd:invtokens(}{it:s}{cmd:,} {it:c}{cmd:)}:
		 {it:s}:  1 {it:x p} 
	         {it:c}:  1 {it:x} 1    (optional)
	    {it:result}:  1 {it:x} 1 


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
If {it:s} is 1 {it:x} 0, {cmd:invtokens(}{it:s},{it:c}{cmd:)} returns
{cmd:""}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view invtokens.mata, adopath asis:invtokens.mata} 
{p_end}
