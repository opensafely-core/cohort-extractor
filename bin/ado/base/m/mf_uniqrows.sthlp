{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] uniqrows()" "mansection M-5 uniqrows()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] sort()" "help mf_sort"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Manipulation" "help m4_manipulation"}{...}
{viewerjumpto "Syntax" "mf_uniqrows##syntax"}{...}
{viewerjumpto "Description" "mf_uniqrows##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_uniqrows##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_uniqrows##remarks"}{...}
{viewerjumpto "Conformability" "mf_uniqrows##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_uniqrows##diagnostics"}{...}
{viewerjumpto "Source code" "mf_uniqrows##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] uniqrows()} {hline 2}}Obtain sorted, unique values
{p_end}
{p2col:}({mansection M-5 uniqrows():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:transmorphic matrix}
{cmd:uniqrows(}{it:transmorphic matrix P}{cmd:)}

{p 8 8 2}
{it:transmorphic matrix}
{cmd:uniqrows(}{it:transmorphic matrix P}{cmd:,} {it:freq}{cmd:)}

    where 
        {it:freq} = {cmd:0} (frequencies are not calculated) or
               {cmd:1} (frequencies are calculated)


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:uniqrows(}{it:P}{cmd:)} 
returns a sorted matrix containing the unique rows of {it:P}.

{pstd}
{cmd:uniqrows(}{it:P}{cmd:,} {it:freq}{cmd:)} does the same but lets you
specify whether the frequencies with which each combination occurs should be
calculated.
Using {cmd:uniqrows(}{it:P}{cmd:, 0)} is the same as using
{cmd:uniqrows(}{it:P}{cmd:)}.
{cmd:uniqrows(}{it:P}{cmd:, 1)} specifies that the frequencies with which each
combination occurs should be
calculated.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 uniqrows()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

	: {cmd:x}
	{res}       {txt}1   2   3
	    {c TLC}{hline 13}{c TRC}
	  1 {c |}  {res}4   5   7{txt}  {c |}
	  2 {c |}  {res}4   5   6{txt}  {c |}
	  3 {c |}  {res}1   2   3{txt}  {c |}
	  4 {c |}  {res}4   5   6{txt}  {c |}
	    {c BLC}{hline 13}{c BRC}

	: {cmd:uniqrows(x)}
	{res}       {txt}1   2   3
	    {c TLC}{hline 13}{c TRC}
	  1 {c |}  {res}1   2   3{txt}  {c |}
	  2 {c |}  {res}4   5   6{txt}  {c |}
	  3 {c |}  {res}4   5   7{txt}  {c |}
	    {c BLC}{hline 13}{c BRC}

	: {cmd:uniqrows(x, 1)}
	{res}       {txt}1   2   3
	    {c TLC}{hline 17}{c TRC}
	  1 {c |}  {res}1   2   3   1{txt}  {c |}
	  2 {c |}  {res}4   5   6   2{txt}  {c |}
	  3 {c |}  {res}4   5   7   1{txt}  {c |}
	    {c BLC}{hline 17}{c BRC}


{marker conformability}{...}
{title:Conformability}

    {cmd:uniqrows(}{it:P}{cmd:, 0)}
		{it:P}:  {it:r1 x c1}
	   {it:result}:  {it:r2 x c1}, {it:r2} <= {it:r1}

    {cmd:uniqrows(}{it:P}{cmd:, 1)}
		{it:P}:  {it:r1 x c1}
	   {it:result}:  {it:r2 x c1} + 1, {it:r2} <= {it:r1}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
In {cmd:uniqrows(}{it:P}{cmd:)}, 
if {cmd:rows(}{it:P}{cmd:)==0}, 
{cmd:J(0, cols(}{it:P}{cmd:), missingof(}{it:P}{cmd:))} is returned.

{p 4 4 2}
If {cmd:rows(}{it:P}{cmd:)}>0 and {cmd:cols(}{it:P}{cmd:)==0}, 
{cmd:J(1, 0, missingof(}{it:P}{cmd:))} is returned.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view uniqrows.mata, adopath asis:uniqrows.mata}
{p_end}
