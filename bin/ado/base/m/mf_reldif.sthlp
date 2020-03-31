{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] reldif()" "mansection M-5 reldif()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_reldif##syntax"}{...}
{viewerjumpto "Description" "mf_reldif##description"}{...}
{viewerjumpto "Conformability" "mf_reldif##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_reldif##diagnostics"}{...}
{viewerjumpto "Source code" "mf_reldif##source"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-5] reldif()} {hline 2}}Relative/absolute difference
{p_end}
{p2col:}({mansection M-5 reldif():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:real matrix}{bind:    }
{cmd:reldif(}{it:numeric matrix X}{cmd:,}
{it:numeric matrix Y}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind:   }
{cmd:mreldif(}{it:numeric matrix X}{cmd:,}
{it:numeric matrix Y}{cmd:)}

{p 8 8 2}
{it:real scalar}
{cmd:mreldifsym(}{it:numeric matrix X}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind: }
{cmd:mreldifre(}{it:numeric matrix X}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:reldif(}{it:X}, {it:Y}{cmd:)} returns the relative difference 
defined by 

		      |X - Y|
		r =  ---------
		      |Y| + 1

{p 4 4 2}
calculated element by element.

{p 4 4 2}
{cmd:mreldif(}{it:X}, {it:Y}{cmd:)} returns the maximum relative difference
and is equivalent to {cmd:max(reldif(}{it:X}, {it:Y}{cmd:))}.

{p 4 4 2}
{cmd:mreldifsym(}{it:X}{cmd:)} is equivalent to 
{cmd:mreldif(}{it:X}{cmd:',} {it:X}{cmd:)} and so is a measure of 
how far the matrix is from being symmetric (Hermitian).

{p 4 4 2}
{cmd:mreldifre(}{it:X}{cmd:)} is equivalent to 
{cmd:mreldif(Re(}{it:X}{cmd:),} {it:X}{cmd:)} and so is a measure of 
how far the matrix is from being real.


{marker conformability}{...}
{title:Conformability}

    {cmd:reldif(}{it:X}, {it:Y}{cmd:)}:
		{it:X}:  {it:r x c}
		{it:Y}:  {it:r x c}
	   {it:result}:  {it:r x c}

    {cmd:mreldif(}{it:X}, {it:Y}{cmd:)}:
		{it:X}:  {it:r x c}
		{it:Y}:  {it:r x c}
	   {it:result}:  1 {it:x} 1

    {cmd:mreldifsym(}{it:X}{cmd:)}:
		{it:X}:  {it:n x n}
	   {it:result}:  1 {it:x} 1

    {cmd:mreldifre(}{it:X}{cmd:)}:
		{it:X}:  {it:r x c}
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
The relative difference function treats equal missing values as having a 
difference of 0 and different missing values as having a difference of 
missing ({cmd:.}):

{p 8 8 2}
{cmd:reldif(., .) == reldif(.a, .a) ==} ... {cmd:== reldif(.z, .z) == 0}

{p 8 8 2}
{cmd:reldif(., .a) == reldif(., .z) ==} ... {cmd:== reldif(.y, .z) == .}


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
