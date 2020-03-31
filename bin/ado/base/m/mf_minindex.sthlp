{smcl}
{* *! version 1.2.5  15may2018}{...}
{vieweralsosee "[M-5] minindex()" "mansection M-5 minindex()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] minmax()" "help mf_minmax"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_minindex##syntax"}{...}
{viewerjumpto "Description" "mf_minindex##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_minindex##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_minindex##remarks"}{...}
{viewerjumpto "Conformability" "mf_minindex##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_minindex##diagnostics"}{...}
{viewerjumpto "Source code" "mf_minindex##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] minindex()} {hline 2}}Indices of minimums and maximums
{p_end}
{p2col:}({mansection M-5 minindex():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}
{cmd:minindex(}{it:real vector v}{cmd:,}
{it:real scalar k}{cmd:,}
{it:i}{cmd:,}
{it:w}{cmd:)}

{p 8 12 2}
{it:void}
{cmd:maxindex(}{it:real vector v}{cmd:,}
{it:real scalar k}{cmd:,}
{it:i}{cmd:,}
{it:w}{cmd:)}


{p 4 8 2}
Results are returned in {it:i} and {it:w}.

{p 8 8 2}
{it:i} will be a {it:real colvector}.

{p 8 8 2}
{it:w} will be a {it:K x} 2 {it:real matrix}, {it:K} <= |{it:k}|.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:minindex(}{it:v}{cmd:,} {it:k}{cmd:,} {it:i}{cmd:,} {it:w}{cmd:)}
returns in {it:i} and {it:w} the indices of the {it:k} minimums of {it:v}.

{p 4 4 2}
{cmd:maxindex(}{it:v}{cmd:,} {it:k}{cmd:,} {it:i}{cmd:,} {it:w}{cmd:)}
does the same, except that it returns the indices of the {it:k} maximums.

{p 4 4 2}
{cmd:minindex()} may be called with {it:k}<0; it is then equivalent to 
{cmd:maxindex()}.  

{p 4 4 2}
{cmd:maxindex()} may be called with {it:k}<0; it is then equivalent to 
{cmd:minindex()}.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 minindex()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_minindex##remarks1:Use of functions when v has all unique values}
	{help mf_minindex##remarks2:Use of functions when v has repeated (tied) values}
	{help mf_minindex##remarks3:Summary}

{p 4 4 2}
Remarks are cast in terms of {cmd:minindex()} but apply equally to
{cmd:maxindex()}.


{marker remarks1}{...}
{title:Use of functions when v has all unique values}

{p 4 4 2}
Consider {cmd:v} = (3,1,5,7,6).

{p 8 12 2}
1.  {cmd:minindex(v, 1, i, w)}
    returns {cmd:i} = 2, which means that
    {cmd:v[2]} is the minimum value in {cmd:v}.

{p 8 12 2}
2.  {cmd:minindex(v, 2, i, w)}
    returns {cmd:i} = (2, 1)', which means that
    {cmd:v[2]} is the minimum value of {cmd:v} and 
    that {cmd:v[1]} is the second minimum.

{p 8 12 2}
...

{p 8 12 2}
5.  {cmd:minindex(v, 5, i, w)} returns 
    {cmd:i} = (2, 1, 3, 5, 4)', which means that the ordered
    values in {cmd:v} are 
    {cmd:v[2]}, 
    {cmd:v[1]}, 
    {cmd:v[3]}, 
    {cmd:v[5]}, and 
    {cmd:v[4]}. 

{p 8 12 2}
6.  {cmd:minindex(v, 6, i, w)}, 
    {cmd:minindex(v, 7, i, w)}, and so on, 
    return the same as (5), because there are only five minimums in 
    a five-element vector.

{p 4 4 2}
When {cmd:v} has unique values, the values returned in {cmd:w} are irrelevant.

{p 8 10 2}
o{bind:  }In (1), {cmd:w} will be (1,1).

{p 8 10 2}
o{bind:  }In (2), {cmd:w} will be (1,1 \ 2,1).

{p 8 10 2}
o{bind:  }...

{p 8 10 2}
o{bind:  }In (5), {cmd:w} will be 
(1,1 \ 2,1 \ 3,1 \ 4,1 \ 5,1).  

{p 4 4 2}
The second column of {it:w} records the number of tied values.  
Since the values in {it:v} are unique, the second column of {it:w} will 
be ones.  If you have a problem where you are uncertain whether the values in 
{it:v} are unique, code

		{cmd:if (!allof(w[,2], 1)) {c -(}}
			{cmd:/*} {it:uniqueness assumption false} {cmd:*/}
		{cmd:{c )-}}


{marker remarks2}{...}
{title:Use of functions when v has repeated (tied) values}

{p 4 4 2}
Consider {cmd:v} = (3, 2, 3, 2, 3, 3).

{p 8 12 2}
1.  {cmd:minindex(v, 1, i, w)} returns {cmd:i} = (2, 4)',
    which means that there is one minimum value
    and that it is repeated in two elements of {cmd:v}, namely,
    {cmd:v[2]} and {cmd:v[4]}.

{p 12 12 2}
    Here, {cmd:w} will be (1, 2), but you can ignore that.  
    There are two values in {cmd:i} corresponding 
    to the same minimum.  

{p 12 12 2}
    When {cmd:k==1}, {cmd:rows(i)} equals the number of observations in 
    {cmd:v} corresponding to the minimum, as does {cmd:w[1,2]}.

{p 8 12 2}
2.  {cmd:minindex(v, 2, i, w)} returns {cmd:i} = (2, 4, 1, 3, 5, 6)' 
    and {cmd:w} = (1,2 \ 3,4).

{p 12 12 2}
    Begin with {cmd:w}.  The first row of {cmd:w} is (1, 2),  which states 
    that the indices of the first minimums of {cmd:v} start at {cmd:i[1]}
    and consist of two elements.  Thus the indices of the 
    first minimums are {cmd:i[1]} and {cmd:i[2]} (the minimums are 
    {cmd:v[i[1]]} and 
    {cmd:v[i[2]]}, which of course are equal).

{p 12 12 2}
    The second row of {cmd:w} is (3, 4),  which states that the indices 
    of the second minimums of {cmd:v} start at {cmd:i[3]} and consist of 
    four elements:  {cmd:i[3]}, {cmd:i[4]}, {cmd:i[5]}, and {cmd:i[6]}
    (which are 1, 3, 5, and 6).

{p 12 12 2}
    In summary, {cmd:rows(w)} records the number of minimums returned.
    {cmd:w[m,1]} records where in {cmd:i} the {cmd:m}th minimum begins 
    (it begins at {cmd:i[w[m,1]]}).  {cmd:w[m,2]} records the total number of
    tied values.  Thus one could step across the minimums and the tied
    values by coding

        	{cmd}minindex(v, k, i, w)

		for (m=1; m<=rows(w); m++) {
			for (j=w[m,1]; j<w[m,1]+w[m,2]; j++) {
			      /* i[j] {txt:{it:is the index in}} v {txt:{it:of an}} m{txt:{it:th minimum}} */
			}
		}{txt}
    
{p 8 12 2}
3.  {cmd:minindex(v, 3, i, w)}, 
    {cmd:minindex(v, 4, i, w)}, 
    and so on, return the same as (2) because, with 
    {cmd:v} = (3, 2, 3, 2, 3, 3), there are only two minimums.


{marker remarks3}{...}
{title:Summary}

{p 4 4 2}
Consider {cmd:minindex(}{it:v}{cmd:,} {it:k}{cmd:,} 
{it:i}{cmd:,} {it:w}{cmd:)}.  Returned will be


                {c TLC}        {c TRC}
		{c |} {it:i1}  {it:n1} {c |}      
	    {it:w} = {c |} {it:i2}  {it:n2} {c |}
                {c |} .   .  {c |}
                {c |} .   .  {c |} 
                {c BLC}        {c BRC}  {it:w}:  {it:K x} 2,  {it:K} <= |{it:k}|


                {c TLC}    {c TRC}                                      {c |}
                {c |} {it:j1} {c |} <- {it:i}[{it:i1}] is start of first minimums  {c |} 
                {c |} {it:j2} {c |}                                      {c |} has {it:n1} values
            i = {c |} {it:j3} {c |}                                      {c |}
                {c |}    {c |}
                {c |} {it:j4} {c |} <- {it:i}[{it:i2}] is start of second minimums {c |}
                {c |}  . {c |}                                      {c |} has {it:n2} values
                {c |}    {c |}
                {c |}  . {c |}    etc.
                {c |}  . {c |}  
                {c BLC}    {c BRC}  {it:i}:  1 x {it:m},  {it:m} = {it:n1} + {it:n2} + ...


{p 4 4 2} 
{it:j1}, {it:j2}, ..., are indices into {it:v}.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
    {cmd:minindex(}{it:v}{cmd:,} {it:k}{cmd:,} {it:i}{cmd:,} {it:w}{cmd:)}, 
    {cmd:maxindex(}{it:v}{cmd:,} {it:k}{cmd:,} {it:i}{cmd:,} {it:w}{cmd:)}:
{p_end}
	{it:input:}
		{it:v}:  {it:n x} 1  or  1 {it:x n}
		{it:k}:  1 {it:x} 1
	{it:output:}
		{it:i}:  {it:L x} 1, {it:L} >= {it:K}
		{it:w}:  {it:K x} 2, {it:K} <= |{it:k}|


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:minindex(}{it:v}{cmd:,} {it:k}{cmd:,} {it:i}{cmd:,} {it:w}{cmd:)}
and
{cmd:maxindex(}{it:v}{cmd:,} {it:k}{cmd:,} {it:i}{cmd:,} {it:w}{cmd:)}
abort with error if {it:i} or {it:w} is a view.

{p 4 4 2}
In {cmd:minindex(}{it:v}{cmd:,} {it:k}{cmd:,} {it:i}{cmd:,} {it:w}{cmd:)}
and
{cmd:maxindex(}{it:v}{cmd:,} {it:k}{cmd:,} {it:i}{cmd:,} {it:w}{cmd:)},
missing values in {it:v} are ignored in obtaining minimums and maximums.

{p 4 4 2}
In the examples above, we have shown input vector {it:v} as a row vector.
It can also be a column vector; it makes no difference.

{p 4 4 2}
In {cmd:minindex(}{it:v}{cmd:,} {it:k}{cmd:,} {it:i}{cmd:,} {it:w}{cmd:)},
input argument {it:k} specifies the number of minimums to be obtained.
{it:k} may be zero.  If {it:k} is negative, -{it:k} maximums are obtained.

{p 4 4 2}
Similarly, 
in {cmd:maxindex(}{it:v}{cmd:,} {it:k}{cmd:,} {it:i}{cmd:,} {it:w}{cmd:)},
input argument {it:k} specifies the number of maximums to be obtained.
{it:k} may be zero.  If {it:k} is negative, -{it:k} minimums are obtained.

{p 4 4 2}
{cmd:minindex()} and {cmd:maxindex()} are designed for use when {it:k} 
is small relative to {cmd:length(}{it:v}{cmd:)}; otherwise, see {cmd:order()}
in {bf:{help mf_sort:[M-5] sort()}}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view maxindex.mata, adopath asis:maxindex.mata};
    {cmd:minindex()} is built in.
{p_end}
