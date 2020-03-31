{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-2] op_colon" "mansection M-2 op_colon"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] exp" "help m2_exp"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_op_colon##syntax"}{...}
{viewerjumpto "Description" "m2_op_colon##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_op_colon##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_op_colon##remarks"}{...}
{viewerjumpto "Conformability" "m2_op_colon##conformability"}{...}
{viewerjumpto "Diagnostics" "m2_op_colon##diagnostics"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-2] op_colon} {hline 2}}Colon operators
{p_end}
{p2col:}({mansection M-2 op_colon:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{it:a} {cmd::+} {it:b}                  addition
	{it:a} {cmd::-} {it:b}                  subtraction
	{it:a} {cmd::*} {it:b}                  multiplication
	{it:a} {cmd::/} {it:b}                  division
	{it:a} {cmd::^} {it:b}                  power

	{it:a} {cmd::==} {it:b}                 equality
	{it:a} {cmd::!=} {it:b}                 inequality
	{it:a} {cmd::>}  {it:b}                 greater than
	{it:a} {cmd::>=} {it:b}                 greater than or equal to
	{it:a} {cmd::<}  {it:b}                 less than
	{it:a} {cmd::<=} {it:b}                 less than or equal to

	{it:a} {cmd::&}  {it:b}                 and
	{it:a} {cmd::|}  {it:b}                 or


{marker description}{...}
{title:Description}

{p 4 4 2}
Colon operators perform element-by-element operations.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 op_colonRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_op_colon##remarks1:C-conformability:  element by element}
	{help m2_op_colon##remarks2:Usefulness of colon logical operators}
	{help m2_op_colon##remarks3:Use parentheses}


{marker remarks1}{...}
{title:C-conformability:  element by element}

{p 4 4 2}
The colon operators perform the indicated operation on each pair of 
elements of {it:a} and {it:b}.  For instance, 

       {c TLC}{c -}    {c -}{c TRC}        {c TLC}{c -}    {c -}{c TRC}       {c TLC}{c -}        {c -}{c TRC}
       {c |} {it:c}  {it:d} {c |}        {c |} {it:j}  {it:k} {c |}       {c |} {it:c}*{it:j}  {it:d}*{it:k} {c |}
       {c |} {it:f}  {it:g} {c |}   :*   {c |} {it:l}  {it:m} {c |}   =   {c |} {it:f}*{it:l}  {it:g}*{it:m} {c |}
       {c |} {it:h}  {it:i} {c |}        {c |} {it:n}  {it:o} {c |}       {c |} {it:h}*{it:n}  {it:i}*{it:o} {c |}
       {c BLC}{c -}    {c -}{c BRC}        {c BLC}{c -}    {c -}{c BRC}       {c BLC}{c -}        {c -}{c BRC}

{p 4 4 2}
Also colon operators have a relaxed definition of conformability:

       {c TLC}{c -}    {c -}{c TRC}        {c TLC}{c -}    {c -}{c TRC}       {c TLC}{c -}        {c -}{c TRC}
       {c |}   {it:c}  {c |}        {c |} {it:j}  {it:k} {c |}       {c |} {it:c}*{it:j}  {it:c}*{it:k} {c |}
       {c |}   {it:f}  {c |}   :*   {c |} {it:l}  {it:m} {c |}   =   {c |} {it:f}*{it:l}  {it:f}*{it:m} {c |}
       {c |}   {it:g}  {c |}        {c |} {it:n}  {it:o} {c |}       {c |} {it:g}*{it:n}  {it:g}*{it:o} {c |}
       {c BLC}{c -}    {c -}{c BRC}        {c BLC}{c -}    {c -}{c BRC}       {c BLC}{c -}        {c -}{c BRC}


       {c TLC}{c -}    {c -}{c TRC}        {c TLC}{c -}    {c -}{c TRC}       {c TLC}{c -}        {c -}{c TRC}
       {c |} {it:c}  {it:d} {c |}        {c |}  {it:j}   {c |}       {c |} {it:c}*{it:j}  {it:d}*{it:j} {c |}
       {c |} {it:f}  {it:g} {c |}   :*   {c |}  {it:l}   {c |}   =   {c |} {it:f}*{it:l}  {it:g}*{it:l} {c |}
       {c |} {it:h}  {it:i} {c |}        {c |}  {it:n}   {c |}       {c |} {it:h}*{it:n}  {it:i}*{it:n} {c |}
       {c BLC}{c -}    {c -}{c BRC}        {c BLC}{c -}    {c -}{c BRC}       {c BLC}{c -}        {c -}{c BRC}


                       {c TLC}{c -}    {c -}{c TRC}       {c TLC}{c -}        {c -}{c TRC}
                       {c |} {it:j}  {it:k} {c |}       {c |} {it:c}*{it:j}  {it:d}*{it:k} {c |}
       [ {it:c}  {it:d} ]   :*   {c |} {it:l}  {it:m} {c |}   =   {c |} {it:c}*{it:l}  {it:d}*{it:m} {c |}
                       {c |} {it:n}  {it:o} {c |}       {c |} {it:c}*{it:n}  {it:d}*{it:o} {c |}
                       {c BLC}{c -}    {c -}{c BRC}       {c BLC}{c -}        {c -}{c BRC}

       {c TLC}{c -}    {c -}{c TRC}                       {c TLC}{c -}        {c -}{c TRC}
       {c |} {it:c}  {it:d} {c |}                       {c |} {it:c}*{it:l}  {it:d}*{it:m} {c |}
       {c |} {it:f}  {it:g} {c |}   :*   [ {it:l}  {it:m} ]   =   {c |} {it:f}*{it:l}  {it:g}*{it:m} {c |}
       {c |} {it:h}  {it:i} {c |}                       {c |} {it:h}*{it:l}  {it:i}*{it:m} {c |}
       {c BLC}{c -}    {c -}{c BRC}                       {c BLC}{c -}        {c -}{c BRC}


                       {c TLC}{c -}    {c -}{c TRC}       {c TLC}{c -}        {c -}{c TRC}
                       {c |} {it:j}  {it:k} {c |}       {c |} {it:c}*{it:j}  {it:c}*{it:k} {c |}
            {it:c}     :*   {c |} {it:l}  {it:m} {c |}   =   {c |} {it:c}*{it:l}  {it:c}*{it:m} {c |}
                       {c |} {it:n}  {it:o} {c |}       {c |} {it:c}*{it:n}  {it:c}*{it:o} {c |}
                       {c BLC}{c -}    {c -}{c BRC}       {c BLC}{c -}        {c -}{c BRC}


       {c TLC}{c -}    {c -}{c TRC}                       {c TLC}{c -}        {c -}{c TRC}
       {c |} {it:c}  {it:d} {c |}                       {c |} {it:c}*{it:j}  {it:d}*{it:j} {c |}
       {c |} {it:f}  {it:g} {c |}   :*      {it:j}       =   {c |} {it:f}*{it:j}  {it:g}*{it:j} {c |}
       {c |} {it:h}  {it:i} {c |}                       {c |} {it:h}*{it:j}  {it:i}*{it:j} {c |}
       {c BLC}{c -}    {c -}{c BRC}                       {c BLC}{c -}        {c -}{c BRC}

{p 4 4 2}
The matrices above are said to be c-conformable; the {it:c} stands for colon.
The matrices have the same number of rows and columns, or one or the other is
a vector with the same number of rows or columns as the matrix, or one or the
other is a scalar.

{p 4 4 2}
C-conformability is relaxed, but not everything is allowed.  The following is
an error:

                       {c TLC}{c -}   {c -}{c TRC}
                       {c |}  {it:f}  {c |}
        ({it:c  d  e})  :*  {c |}  {it:g}  {c |}
                       {c |}  {it:h}  {c |}
                       {c BLC}{c -}   {c -}{c BRC}


{marker remarks2}{...}
{title:Usefulness of colon logical operators}

{p 4 4 2}
It is worth paying particular attention to the colon logical operators
because they can produce pattern vectors and matrices.  Consider the matrix

	: {cmd:x = (5, 0 \ 0, 2 \ 3, 8)}
	: {cmd:x}
        {res}       {txt}1   2
            {c TLC}{hline 9}{c TRC}
          1 {c |}  {res}5   0{txt}  {c |}
          2 {c |}  {res}0   2{txt}  {c |}
          3 {c |}  {res}3   8{txt}  {c |}
            {c BLC}{hline 9}{c BRC}{txt}

{p 4 4 2}
Which elements of {cmd:x} contain 0?

	: {cmd:x:==0}
        {res}       {txt}1   2
            {c TLC}{hline 9}{c TRC}
          1 {c |}  {res}0   1{txt}  {c |}
          2 {c |}  {res}1   0{txt}  {c |}
          3 {c |}  {res}0   0{txt}  {c |}
            {c BLC}{hline 9}{c BRC}{txt}

{p 4 4 2}
How many zeros are there in {cmd:x}?

	: {cmd:sum(x:==0)}
	  2


{marker remarks3}{...}
{title:Use parentheses}

{p 4 4 2}
Because of their relaxed conformability requirements, colon operators are not
associative even when the underlying operator is.  For instance, you
expect ({it:a}+{it:b})+{it:c} == {it:a}+({it:b}+{it:c}), at least ignoring
numerical roundoff error.  Nevertheless, ({it:a}:+{it:b}):+{it:c} ==
{it:a}:+({it:b}:+{it:c}) does not necessarily hold.  Consider 
what happens when 

		{it:a}:  1 {it:x} 4
		{it:b}:  5 {it:x} 1
		{it:c}:  5 {it:x} 4

{p 4 4 2}
Then 
({it:a}:+{it:b}):+{it:c} is an error because 
{it:a}:+{it:b} is not c-conformable.  

{p 4 4 2}
Nevertheless, 
{it:a}:+({it:b}:+{it:c}) is not an error and in fact produces a 
5 {it:x} 4 matrix because {it:b}:+{it:c} is 5 {it:x} 4, which is 
c-conformable with {it:a}.
	

{marker conformability}{...}
{title:Conformability}

    {it:a} {cmd::}{it:op} {it:b}:
		{it:a}:  {it:r1 x c1}
		{it:b}:  {it:r2 x c2}, {it:a} and {it:b} c-conformable
	   {it:result}:  max({it:r1},{it:r2}) {it:x} max({it:c1},{it:c2})


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
The colon operators return missing and abort with error under the same 
conditions that the underlying operator returns missing and aborts with 
error.
{p_end}
