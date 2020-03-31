{smcl}
{* *! version 1.1.8  18feb2020}{...}
{vieweralsosee "[M-2] op_transpose" "mansection M-2 op_transpose"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] exp" "help m2_exp"}{...}
{vieweralsosee "[M-5] conj()" "help mf_conj"}{...}
{vieweralsosee "[M-5] _transpose()" "help mf__transpose"}{...}
{vieweralsosee "[M-5] transposeonly()" "help mf_transposeonly"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_op_transpose##syntax"}{...}
{viewerjumpto "Description" "m2_op_transpose##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_op_transpose##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_op_transpose##remarks"}{...}
{viewerjumpto "Conformability" "m2_op_transpose##conformability"}{...}
{viewerjumpto "Diagnostics" "m2_op_transpose##diagnostics"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-2] op_transpose} {hline 2}}Conjugate transpose operator
{p_end}
{p2col:}({mansection M-2 op_transpose:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{it:A}{cmd:'}


{marker description}{...}
{title:Description}

{p 4 4 2}
{it:A}{cmd:'} returns the {help m6_glossary##transpose:transpose} of {it:A} or,
if {it:A} is complex, the conjugate transpose.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 op_transposeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The {cmd:'} postfix operator may be used on any type of matrix 
or vector:  real, complex, string, or pointer:

	: {cmd:a}
	{res}       {txt}1   2   3
	    {c TLC}{hline 13}{c TRC}
	  1 {c |}  {res}1   2   3{txt}  {c |}
	  2 {c |}  {res}4   5   6{txt}  {c |}
	    {c BLC}{hline 13}{c BRC}

	: {cmd:a'}
	{res}       {txt}1   2
	    {c TLC}{hline 9}{c TRC}
	  1 {c |}  {res}1   4{txt}  {c |}
	  2 {c |}  {res}2   5{txt}  {c |}
	  3 {c |}  {res}3   6{txt}  {c |}
	    {c BLC}{hline 9}{c BRC}

	: {cmd:s}
	{res}       {txt}    1       2
	    {c TLC}{hline 17}{c TRC}
	  1 {c |}  {res}alpha    beta{txt}  {c |}
	    {c BLC}{hline 17}{c BRC}

	: {cmd:s'}
	{res}       {txt}    1
	    {c TLC}{hline 9}{c TRC}
	  1 {c |}  {res}alpha{txt}  {c |}
	  2 {c |}  {res} beta{txt}  {c |}
	    {c BLC}{hline 9}{c BRC}


	: {cmd:p}
	{res}       {txt}        1
	    {c TLC}{hline 13}{c TRC}
	  1 {c |}  {res}0xa2fef18{txt}  {c |}
	  2 {c |}  {res}0xb112c28{txt}  {c |}
	    {c BLC}{hline 13}{c BRC}

	: {cmd:p'}
	{res}       {txt}        1           2
	    {c TLC}{hline 25}{c TRC}
	  1 {c |}  {res}0xa2fef18   0xb112c28{txt}  {c |}
	    {c BLC}{hline 25}{c BRC}

	: {cmd:z}
	{res}       {txt}     1        2
	    {c TLC}{hline 19}{c TRC}
	  1 {c |}  {res}1 + 2i   3 + 4i{txt}  {c |}
	  2 {c |}  {res}5 + 6i   7 + 8i{txt}  {c |}
	    {c BLC}{hline 19}{c BRC}

	: {cmd:z'}
	{res}       {txt}     1        2
	    {c TLC}{hline 19}{c TRC}
	  1 {c |}  {res}1 - 2i   5 - 6i{txt}  {c |}
	  2 {c |}  {res}3 - 4i   7 - 8i{txt}  {c |}
	    {c BLC}{hline 19}{c BRC}

{p 4 4 2}
When {cmd:'} is applied to a complex, returned is the 
conjugate transpose.  If you do not want this, code 
{cmd:conj(}{it:z}{cmd:')} or 
{cmd:conj(}{it:z}{cmd:)'} -- it makes no difference; see 
{bf:{help mf_conj:[M-5] conj()}}, 

	: {cmd:conj(z')}
	{res}       {txt}     1        2
	    {c TLC}{hline 19}{c TRC}
	  1 {c |}  {res}1 + 2i   5 + 6i{txt}  {c |}
	  2 {c |}  {res}3 + 4i   7 + 8i{txt}  {c |}
	    {c BLC}{hline 19}{c BRC}

{p 4 4 2}
Or use the {cmd:transposeonly()} function; see
{bf:{help mf_transposeonly:[M-5] transposeonly()}} function:

	: {cmd:transposeonly(z)}
	{res}       {txt}     1        2
	    {c TLC}{hline 19}{c TRC}
	  1 {c |}  {res}1 + 2i   5 + 6i{txt}  {c |}
	  2 {c |}  {res}3 + 4i   7 + 8i{txt}  {c |}
	    {c BLC}{hline 19}{c BRC}

{p 4 4 2}
{cmd:transposeonly()} executes slightly faster than {cmd:conj(}{it:z}{cmd:')}.

{p 4 4 2}
For real and complex {it:A}, also see
{bf:{help mf__transpose:[M-5] _transpose()}}, which provides a way to 
transpose a matrix in place and so saves memory.


{marker conformability}{...}
{title:Conformability}

	{it:A}{cmd:'}:
		{it:A}:  {it:r x c}
	   {it:result}:  {it:c x r}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
The transpose operator cannot fail, but it is easy to use it incorrectly
when working with complex quantities.

{p 4 4 2}
A user wanted to form {it:A}{cmd:*}{it:x} but when he tried, got a
conformability error.  He thought {it:x} was a column vector, but it turned
out to be a row vector, or perhaps it was the other way around.  Anyway, he
then coded {it:A}{cmd:*}{it:x}{cmd:'}, and the program worked and, even
better, produced the correct answers.  In his test, {it:x} was real.

{p 4 4 2}
Later, the user ran the program with complex {it:x}, and the program generated
incorrect results, although it took him a while to notice.  Study and
study his code he did, before he thought about the innocuous
{it:A}{cmd:*}{it:x}{cmd:'}.  The transpose operator not only had changed
{it:x} from being a row into being a column but also had taken the conjugate of
each element of {it:x}!  He changed the code to read
{it:A}{cmd:*}{cmd:transposeonly(}{it:x}{cmd:)}.

{p 4 4 2}
The user no doubt wondered why the {cmd:'} transpose operator was not 
defined at the outset to be equivalent to {cmd:transposeonly()}. 
If it had been, then rather than telling the story of the man
who was bitten by conjugate transpose when he only wanted the transpose, 
we would have told the story of the woman who was bitten by the transpose when
she needed the conjugate transpose.  There are, in fact, more of the latter
stories than there are of the former.
{p_end}
