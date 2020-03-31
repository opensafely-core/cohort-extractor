{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-4] Solvers" "mansection M-4 Solvers"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Intro" "help m4_intro"}{...}
{viewerjumpto "Contents" "m4_solvers##contents"}{...}
{viewerjumpto "Description" "m4_solvers##description"}{...}
{viewerjumpto "Links to PDF documentation" "m4_solvers##linkspdf"}{...}
{viewerjumpto "Remarks" "m4_solvers##remarks"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-4] Solvers} {hline 2}}Functions to solve AX=B and to obtain A inverse
{p_end}
{p2col:}({mansection M-4 Solvers:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker contents}{...}
{title:Contents}

{col 8} [M-5]
{col 5}Manual entry{col 22}Function{col 35}Purpose
{col 5}{hline}

{col 5}   {c TLC}{hline 9}{c TRC}
{col 5}{hline 3}{c RT}{it: Solvers }{c LT}{hline}
{col 5}   {c BLC}{hline 9}{c BRC}

{col 8}{bf:{help mf_cholsolve:cholsolve()}}{...}
{col 22}{cmd:cholsolve()}{...}
{col 35}{it:A} positive definite; symmetric or Hermitian

{col 8}{bf:{help mf_lusolve:lusolve()}}{...}
{col 22}{cmd:lusolve()}{...}
{col 35}{it:A} full rank, square, real or complex

{col 8}{bf:{help mf_qrsolve:qrsolve()}}{...}
{col 22}{cmd:qrsolve()}{...}
{col 35}{it:A} general; {it:m x n}, {it:m} >= {it:n}, real or complex;
{col 35}least-squares generalized solution

{col 8}{bf:{help mf_svsolve:svsolve()}}{...}
{col 22}{cmd:svsolve()}{...}
{col 35}generalized; {it:m x n}, real or complex;
{col 35}minimum norm, least-squares solution

{col 5}   {c TLC}{hline 11}{c TRC}
{col 5}{hline 3}{c RT}{it: Inverters }{c LT}{hline}
{col 5}   {c BLC}{hline 11}{c BRC}

{col 8}{bf:{help mf_invsym:invsym()}}{...}
{col 22}{cmd:invsym()}{...}
{col 35}generalized; real symmetric

{col 8}{bf:{help mf_cholinv:cholinv()}}{...}
{col 22}{cmd:cholinv()}{...}
{col 35}positive definite; symmetric or Hermitian

{col 8}{bf:{help mf_luinv:luinv()}}{...}
{col 22}{cmd:luinv()}{...}
{col 35}full rank; square; real or complex

{col 8}{bf:{help mf_qrinv:qrinv()}}{...}
{col 22}{cmd:qrinv()}{...}
{col 35}generalized; {it:m x n}, {it:m} >= {it:n}; real or complex

{col 8}{bf:{help mf_pinv:pinv()}}{...}
{col 22}{cmd:pinv()}{...}
{col 35}generalized; {it:m x n}, real or complex
{col 35}Moore-Penrose pseudoinverse

{col 5}{hline}


{marker description}{...}
{title:Description}

{p 4 4 2}
The above functions solve {it:AX}={it:B} for {it:X}
and solve for {it:A}^(-1).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-4 SolversRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Matrix solvers can be used to implement matrix inverters, and so the 
two nearly always come as a pair.

{p 4 4 2}
Solvers solve 
{it:AX}={it:B}
for {it:X}.
One way to obtain {it:A}^(-1) is to solve
{it:AX}={it:I}.  If 
{bind:{it:f}({it:A}, {it:B})} solves {it:AX}={it:B}, 
then 
{bind:{it:f}({it:A}, {cmd:I(rows(}{it:A}{cmd:))}}
solves for the inverse.
Some matrix 
inverters are in fact implemented this way, although usually 
custom code is written because memory savings are possible when it is known 
that {it:B}={it:I}.

{p 4 4 2}
The pairings of inverter and solver are

		inverter         solver
		{hline 37}
		{helpb mf_invsym:invsym()}         (none)
		{helpb mf_cholinv:cholinv()}        {bf:{help mf_cholsolve:cholsolve()}}
		{helpb mf_luinv:luinv()}          {bf:{help mf_lusolve:lusolve()}}
		{helpb mf_qrinv:qrinv()}          {bf:{help mf_qrsolve:qrsolve()}}
		{helpb mf_pinv:pinv()}           {bf:{help mf_svsolve:svsolve()}}
		{hline 37}
