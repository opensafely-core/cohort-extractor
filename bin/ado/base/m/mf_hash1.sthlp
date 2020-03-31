{smcl}
{* *! version 1.1.11  15may2018}{...}
{vieweralsosee "[M-5] hash1()" "mansection M-5 hash1()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] asarray()" "help mf_asarray"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Programming" "help m4_programming"}{...}
{viewerjumpto "Syntax" "mf_hash1##syntax"}{...}
{viewerjumpto "Description" "mf_hash1##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_hash1##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_hash1##remarks"}{...}
{viewerjumpto "Conformability" "mf_hash1##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_hash1##diagnostics"}{...}
{viewerjumpto "Source code" "mf_hash1##source"}{...}
{viewerjumpto "References" "mf_hash1##references"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-5] hash1()} {hline 2}}Jenkins's one-at-a-time hash function
{p_end}
{p2col:}({mansection M-5 hash1():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar}{bind: }
{cmd:hash1(}{it:x}
[{cmd:,} {it:real scalar n}
[{cmd:,} {it:real scalar byteorder}]]{cmd:)}


{p 4 4 2}
where

{p 16 20 2}
{it:x:}
any type except {cmd:struct} and any dimension

{p 16 20 2}
{it:n:}
1 <= {it:n} <= 2,147,483,647 or {cmd:.}; default is {cmd:.} (missing)

{p 8 20 2}
{it:byteorder:}
1 (HILO), 2 (LOHI), {cmd:.} (natural byte order);
default is {cmd:.} (missing)


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:hash1(}{it:x}{cmd:)} 
returns Jenkins's one-at-a-time hash calculated over the bytes of {it:x};
0 <= 
{cmd:hash1(}{it:x}{cmd:)} 
<= 4,294,967,295.

{p 4 4 2}
{cmd:hash1(}{it:x}{cmd:,} {it:n}{cmd:)}
returns 
Jenkins's one-at-a-time hash 
scaled to 1 <= 
{cmd:hash1(}{it:x}{cmd:,} {it:n}{cmd:)}
<= {it:n},
assuming {it:n}<{cmd:.} (missing).
{cmd:hash1(}{it:x}{cmd:,} {cmd:.)}
is equivalent to {cmd:hash1(}{it:x}{cmd:)}.

{p 4 4 2}
{cmd:hash1(}{it:x}{cmd:,} {it:n}{cmd:,} {it:byteorder}{cmd:)} 
returns 
{cmd:hash1(}{it:x}{cmd:,} {it:n}{cmd:)} 
performed on the bytes of {it:x} ordered as they would be 
on a HILO computer ({it:byteorder}==1), or as they would be 
on a LOHI computer ({it:byteorder}==2), or as they are on 
this computer ({it:byteorder}>={cmd:.}).
See 
{bf:{help mf_byteorder:[M-5] byteorder()}} for a definition of 
byte order.

{p 4 4 2}
In all cases, the values returned by {cmd:hash1()} are integers.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 hash1()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Calculation is significantly faster using the natural byte order of the
computer.  Argument {it:byteorder} is included for those rare cases when it is
important to calculate the same hash value across different computers, 
which in the case of {cmd:hash1()} is mainly for testing.  
{cmd:hash1()}, being a one-at-a-time method, is not sufficient for 
constructing digital signatures.
It is sufficient for constructing hash tables; see 
{bf:{help mf_asarray:[M-5] asarray()}}, in which case, byte order is 
irrelevant.
Also note that
because strings occur in the same order on all computers, the value of 
{it:byteorder} is irrelevant when {it:x} is a string.

{p 4 4 2}
For instance, 

{* hash1ex.do, junk1.smcl}{...}
	{com}: hash1("this"), hash1("this",.,1), hash1("this",.,2)
	{res}       {txt}         1            2            3
	    {c TLC}{hline 40}{c TRC}
	  1 {c |}  {res}2385389520   2385389520   2385389520{txt}  {c |}
	    {c BLC}{hline 40}{c BRC}

	{com}: hash1(15), hash1(15,.,1), hash1(15,.,2)
	{res}       {txt}         1            2            3
	    {c TLC}{hline 40}{c TRC}
	  1 {c |}  {res} 463405819   3338064604    463405819{txt}  {c |}
	    {c BLC}{hline 40}{c BRC}{txt}

{p 4 4 2}
The computer on which this example was run is evidently {it:byteorder}==2, 
meaning LOHI, or least-significant byte first.

{p 4 4 2}
In a Mata context, it is the two-argument form of {cmd:hash1()} that 
is most useful.  In that form, the full result is mapped onto [1, {it:n}]:

{col 16}{...}
{cmd:hash1(}{it:x}{cmd:,} {it:n}{cmd:)} = {...}
{cmd:floor((hash1(}{it:x}{cmd:)/4294967295)*n) + 1}

{p 4 4 2}
For instance, 

{* hash1ex.do, junk2.smcl}{...}
	{com}: hash1("this", 10)
	{res}  6

	{com}: hash1(15, 10)
	{res}  2{txt}

{p 4 4 2}
The result of 
{cmd:hash1(}{it:x}{cmd:,} {cmd:10)}
could be used directly to index a 10 {it:x} 1 array.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:hash1(}{it:x}{cmd:,} {it:n}{cmd:,} {it:byteorder}{cmd:)}:
{p_end}
		{it:x}:  {it:r x c}
		{it:n}:  1 {it:x} 1        (optional)
	{it:byteorder}:  1 {it:x} 1        (optional)
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.  

{p 4 4 2}
Note that {cmd:hash1(}{it:x}[, ...]{cmd:)} never returns a missing
result, even if {it:x} is or contains a missing value.  In the missing 
case, the hash value is calculated of the missing value.  Also note that
{it:x} can be a vector or a matrix, in which case the result is calculated over
the elements aligned rowwise as if they were a single element.  Thus
{cmd:hash1(("a", "b"))} == {cmd:hash1("ab")}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{cmd:hash1()} is built in.


{marker references}{...}
{title:References}

{p 4 8 2}
Jenkins, B. 1997.
{it:Dr. Dobb's Journal}.
Algorithm alley:  Hash functions.
{browse "http://www.ddj.com/184410284":http://www.ddj.com/184410284}.

{p 4 8 2}
------.  unknown.
A hash function for hash table lookup.
{browse "http://www.burtleburtle.net/bob/hash/doobs.html":http://www.burtleburtle.net/bob/hash/doobs.html}.
{p_end}
