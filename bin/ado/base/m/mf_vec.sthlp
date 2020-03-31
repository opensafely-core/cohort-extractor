{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] vec()" "mansection M-5 vec()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Manipulation" "help m4_manipulation"}{...}
{viewerjumpto "Syntax" "mf_vec##syntax"}{...}
{viewerjumpto "Description" "mf_vec##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_vec##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_vec##remarks"}{...}
{viewerjumpto "Conformability" "mf_vec##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_vec##diagnostics"}{...}
{viewerjumpto "Source code" "mf_vec##source"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-5] vec()} {hline 2}}Stack matrix columns
{p_end}
{p2col:}({mansection M-5 vec():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:transmorphic colvector}{bind: }
{cmd:vec(}{it:transmorphic matrix T}{cmd:)}

{p 8 8 2}
{it:transmorphic colvector}
{cmd:vech(}{it:transmorphic matrix T}{cmd:)}

{p 8 8 2}
{it:transmorphic matrix}
{cmd:invvech(}{it:transmorphic colvector v}{cmd:)}



{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:vec(}{it:T}{cmd:)} returns {it:T} transformed into a
column vector with one column stacked onto the next.

{p 4 4 2}
{cmd:vech(}{it:T}{cmd:)} returns square and typically symmetric
matrix {it:T} transformed into a column vector; only the lower half of 
the matrix is recorded.

{p 4 4 2}
{cmd:invvech(}{it:v}{cmd:)} returns {cmd:vech()}-style column vector {it:v}
transformed into a symmetric (Hermitian) matrix.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 vec()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_vec##remarks1:Example of vec()}
	{help mf_vec##remarks2:Example of vech() and invvech()}


{marker remarks1}{...}
{title:Example of vec()}

        {cmd:: x}
               1   2   3
            {c TLC}{hline 13}{c TRC}
          1 {c |}  1   2   3  {c |}
          2 {c |}  4   5   6  {c |}
            {c BLC}{hline 13}{c BRC}

        {cmd:: vec(x)}
               1
            {c TLC}{hline 5}{c TRC}
          1 {c |}  1  {c |}
          2 {c |}  4  {c |}
          3 {c |}  2  {c |}
          4 {c |}  5  {c |}
          5 {c |}  3  {c |}
          6 {c |}  6  {c |}
            {c BLC}{hline 5}{c BRC}


{marker remarks2}{...}
{title:Example of vech() and invvech()}

        {cmd:: x}
        [symmetric]
               1   2   3
            {c TLC}{hline 13}{c TRC}
          1 {c |}  1          {c |}
          2 {c |}  2   4      {c |}
          3 {c |}  3   6   9  {c |}
            {c BLC}{hline 13}{c BRC}

        {cmd:: v = vech(x)}
        {cmd:: v}
               1
            {c TLC}{hline 5}{c TRC}
          1 {c |}  1  {c |}
          2 {c |}  2  {c |}
          3 {c |}  3  {c |}
          4 {c |}  4  {c |}
          5 {c |}  6  {c |}
          6 {c |}  9  {c |}
            {c BLC}{hline 5}{c BRC}

        {cmd:: invvech(v)}
        [symmetric]
               1   2   3
            {c TLC}{hline 13}{c TRC}
          1 {c |}  1          {c |}
          2 {c |}  2   4      {c |}
          3 {c |}  3   6   9  {c |}
            {c BLC}{hline 13}{c BRC}


{marker conformability}{...}
{title:Conformability}

    {cmd:vec(}{it:T}{cmd:)}:
                  {it:T}:   {it:r x c}
             {it:result}:   ({it:r}*{it:c}) {it:x} 1

    {cmd:vech(}{it:T}{cmd:)}:
                  {it:T}:   {it:n x n}
             {it:result}:   ({it:n}*({it:n}+1)/2) {it:x} 1

    {cmd:invvech(}{it:v}{cmd:)}:
                  {it:v}:   ({it:n}*({it:n}+1)/2) {it:x} 1
             {it:result}:   {it:n x n}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:vec(}{it:T}{cmd:)} cannot fail.

{p 4 4 2}
{cmd:vech(}{it:T}{cmd:)} aborts with error if {it:T} is not square.
{cmd:vech()} records only the lower triangle of {it:T}; it does not 
require {it:T} be symmetric.

{p 4 4 2}
{cmd:invvech(}{it:v}{cmd:)} aborts with error if {it:v} 
does not have 0, 1, 3, 6, 10, ... rows.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view vec.mata, adopath asis:vec.mata},
{view vech.mata, adopath asis:vech.mata},
{view invvech.mata, adopath asis:invvech.mata}
{p_end}
