{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] lowertriangle()" "mansection M-5 lowertriangle()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Manipulation" "help m4_manipulation"}{...}
{viewerjumpto "Syntax" "mf_lowertriangle##syntax"}{...}
{viewerjumpto "Description" "mf_lowertriangle##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_lowertriangle##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_lowertriangle##remarks"}{...}
{viewerjumpto "Conformability" "mf_lowertriangle##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_lowertriangle##diagnostics"}{...}
{viewerjumpto "Source code" "mf_lowertriangle##source"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[M-5] lowertriangle()} {hline 2}}Extract lower or upper triangle
{p_end}
{p2col:}({mansection M-5 lowertriangle():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric matrix}
{cmd:lowertriangle(}{it:numeric matrix A} [{cmd:,}
{it:numeric scalar d}]{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:uppertriangle(}{it:numeric matrix A} [{cmd:,}
{it:numeric scalar d}]{cmd:)}


{p 8 12 2}
{it:void}{bind:         }
{cmd:_lowertriangle(}{it:numeric matrix A} [{cmd:,}
{it:numeric scalar d}]{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:_uppertriangle(}{it:numeric matrix A} [{cmd:,}
{it:numeric scalar d}]{cmd:)}


{p 4 4 2}
where argument {it:d} is optional.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:lowertriangle()} returns the lower triangle of
{it:A}.

{p 4 4 2}
{cmd:uppertriangle()} returns the upper triangle of
{it:A}.

{p 4 4 2}
{cmd:_lowertriangle()} replaces {it:A} with its lower triangle.

{p 4 4 2}
{cmd:_uppertriangle()} replaces {it:A} with its upper triangle.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 lowertriangle()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_lowertriangle##remarks1:Optional argument d}
	{help mf_lowertriangle##remarks2:Nonsquare matrices}


{marker remarks1}{...}
{title:Optional argument d}

{p 4 4 2}
Optional argument {it:d} specifies the treatment of the diagonal.
Specifying {it:d}>={cmd:.}, or not specifying {it:d} at all, means no 
special treatment; if

                                {c TLC}{c -}       {c -}{c TRC}
		                {c |} 1  2  3 {c |}
		        {it:A}    =  {c |} 4  5  6 {c |}
		                {c |} 7  8  9 {c |}
                                {c BLC}{c -}       {c -}{c BRC}

    then

                                {c TLC}{c -}       {c -}{c TRC}
		                {c |} 1  0  0 {c |}
	{cmd:lowertriangle(}{it:A}{cmd:, .)}  =  {c |} 4  5  0 {c |}
		                {c |} 7  8  9 {c |}
                                {c BLC}{c -}       {c -}{c BRC}

{p 4 4 2}
If a nonmissing value is specified for {it:d}, however, that value is 
substituted for each element of the diagonal, for example, 

                                {c TLC}{c -}       {c -}{c TRC}
		                {c |} 1  0  0 {c |}
	{cmd:lowertriangle(}{it:A}{cmd:, 1)}  =  {c |} 4  1  0 {c |}
		                {c |} 7  8  1 {c |}
                                {c BLC}{c -}       {c -}{c BRC}


{marker remarks2}{...}
{title:Nonsquare matrices}

{p 4 4 2}
{cmd:lowertriangle()} and {cmd:uppertriangle()} may be used with nonsquare
matrices.  If

                                {c TLC}{c -}          {c -}{c TRC}
		                {c |} 1  2  3  4 {c |}
		        {it:A}    =  {c |} 5  6  7  8 {c |}
		                {c |} 9 10 11 12 {c |}
                                {c BLC}{c -}          {c -}{c BRC}

    then

                                {c TLC}{c -}       {c -}{c TRC}
		                {c |} 1  0  0 {c |}
	   {cmd:lowertriangle(}{it:A}{cmd:)}  =  {c |} 5  6  0 {c |}
		                {c |} 9 10 11 {c |}
                                {c BLC}{c -}       {c -}{c BRC}

    and

                                {c TLC}{c -}          {c -}{c TRC}
		                {c |} 1  2  3  4 {c |}
	   {cmd:uppertriangle(}{it:A}{cmd:)}  =  {c |} 0  6  7  8 {c |}
		                {c |} 0  0 11 12 {c |}
                                {c BLC}{c -}          {c -}{c BRC}

{p 4 4 2}
{cmd:_lowertriangle()} and 
{cmd:_uppertriangle()}, however, may not be used with nonsquare matrices.


{marker conformability}{...}
{title:Conformability}

    {cmd:lowertriangle(}{it:A}{cmd:,} {it:d}{cmd:)}:
		{it:A}:  {it:r x c}
		{it:d}:  1 {it:x} 1        (optional)
	   {it:result}:  {it:r x} min({it:r},{it:c})

    {cmd:uppertriangle(}{it:A}{cmd:,} {it:d}{cmd:)}:
		{it:A}:  {it:r x c}
		{it:d}:  1 {it:x} 1        (optional)
	   {it:result}:  min({it:r},{it:c}) {it:x c}

{p 4 4 2}
    {cmd:_lowertriangle(}{it:A}{cmd:,} {it:d}{cmd:)},
    {cmd:_uppertriangle(}{it:A}{cmd:,} {it:d}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
		{it:d}:  1 {it:x} 1        (optional)
	{it:output:}
		{it:A}:  {it:n x n}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view lowertriangle.mata, adopath asis:lowertriangle.mata},
{view uppertriangle.mata, adopath asis:uppertriangle.mata},
{view _lowertriangle.mata, adopath asis:_lowertriangle.mata},
{view _uppertriangle.mata, adopath asis:_uppertriangle.mata}
{p_end}
