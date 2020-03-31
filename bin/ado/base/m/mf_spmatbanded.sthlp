{smcl}
{* *! version 1.0.4  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_spmatbanded##syntax"}{...}
{viewerjumpto "Description" "mf_spmatbanded##description"}{...}
{viewerjumpto "Conformability" "mf_spmatbanded##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_spmatbanded##diagnostics"}{...}
{viewerjumpto "Source code" "mf_spmatbanded##source"}{...}
{title:Title}

{p 4 8 2}
{cmd:SPMATbanded*()} {hline 2} Banded matrix operators


{marker syntax}{...}
{title:Syntax}

{p 4 8 2}
{it:real matrix} {cmd:SPMATbandedmake(}{it:real matrix A}{cmd:,}
{it:real scalar lb}{cmd:,} {it:real scalar ub}{cmd:)}

{p 4 8 2}
{it:real matrix} {cmd:SPMATbandedunmake(}{it:real matrix A}{cmd:,}
{it:real scalar lb}{cmd:,} {it:real scalar ub}{cmd:)}

{p 4 8 2}
{it:void} {cmd:_SPMATbandedtranspose(}{it:real matrix A}{cmd:,}
{it:real scalar lb}{cmd:,} {it:real scalar ub}{cmd:)}

{p 4 8 2}
{it:real matrix} {cmd:SPMATbandedplus(}{it:real matrix A}{cmd:,}
{it:real scalar lb1}{cmd:,} {it:real scalar ub1}{cmd:,}
{it:real matrix B}{cmd:,} {it:real scalar lb2}{cmd:,}
{it:real scalar ub2}{cmd:)}

{p 4 8 2}
{it:real matrix} {cmd:SPMATbandedminus(}{it:real matrix A}{cmd:,}
{it:real scalar lb1}{cmd:,} {it:real scalar ub1}{cmd:,}
{it:real matrix B}{cmd:,} {it:real scalar lb2}{cmd:,}
{it:real scalar ub2}{cmd:)}

{p 4 8 2}
{it:real scalar} {cmd:SPMATbandedtrace(}{it:real matrix A}{cmd:,}
{it:real scalar lb}{cmd:,} {it:real scalar ub}{cmd:)}

{p 4 8 2}
{it:real scalar} {cmd:SPMATbandedtracemult(}{it:real matrix A}{cmd:,}
{it:real scalar lb1}{cmd:,} {it:real scalar ub1}{cmd:,}
{it:real matrix B}{cmd:,} {it:real scalar lb2}{cmd:,}
{it:real scalar ub2}{cmd:)}

{p 4 8 2}
{it:real matrix} {cmd:SPMATbandedcross(}{it:real matrix A}{cmd:,}
{it:real scalar lb}{cmd:,} {it:real scalar ub}{cmd:)}

{p 4 8 2}
{it:real matrix} {cmd:SPMATbandedmult(}{it:real matrix A}{cmd:,}
{it:real scalar lb1}{cmd:,} {it:real scalar ub1}{cmd:,}
{it:real matrix B}{cmd:,} {it:real scalar lb2}{cmd:,}
{it:real scalar ub2}{cmd:)}

{p 4 8 2}
{it:real matrix} {cmd:SPMATbandedmultfull(}{it:real matrix A}{cmd:,}
{it:real scalar lb1}{cmd:,} {it:real scalar ub1}{cmd:,}
{it:real matrix X}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
These functions create and perform operations on banded matrices.

{p 4 4 2}
{cmd:SPMATbandedmake()} takes an {it:n x n} matrix {it:A} and returns a banded
matrix with lower band {it:lb} and upper band {it:ub}.

{p 4 4 2}
{cmd:SPMATbandedunmake()} takes a {it:b x n} banded matrix {it:A} with
lower band {it:lb} and upper band {it:ub} and returns an {it:n x n} matrix.

{p 4 4 2}
{cmd:_SPMATbandedtranspose()} returns the transposed banded matrix {it:A}
with lower band {it:lb} and upper band {it:ub}.

{p 4 4 2}
{cmd:SPMATbandedplus()} performs matrix addition on the banded matrices
{it:A} and {it:B}.

{p 4 4 2}
{cmd:SPMATbandedminus()} performs matrix subtraction on the banded matrices
{it:A} and {it:B}.

{p 4 4 2}
{cmd:SPMATbandedtrace()} returns the trace of the banded matrix {it:A}.

{p 4 4 2}
{cmd:SPMATbandedtracemult()} returns {cmd:trace(}{it:A}{cmd:*}{it:B}{cmd:)}
of the banded matrices {it:A} and {it:B}.

{p 4 4 2}
{cmd:SPMATbandedcross()} returns {cmd:cross(}{it:A,A}{cmd:)}
with the matrix {it:A} stored in a banded form.

{p 4 4 2}
{cmd:SPMATbandedmult()} performs matrix multiplication on the banded
matrices {it:A} and {it:B}.

{p 4 4 2}
{cmd:SPMATbandedmultfull()} performs matrix multiplication on the banded
matrix {it:A} and an {it:n x k} matrix {it:X}.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
    {cmd:SPMATbandedmake()}:
{p_end}
		{it:A}:  {it:n x n}
	   {it:result}:  {it:b x n}        where {it:b} = {it:lb}{cmd: + 1 + }{it:ub}

{p 4 4 2}
    {cmd:SPMATbandedunmake()}:
{p_end}
		{it:A}:  {it:b x n}        where {it:b} = {it:lb}{cmd: + 1 + }{it:ub}
	   {it:result}:  {it:n x n}

{p 4 4 2}
    {cmd:_SPMATbandedtranspose()}:
{p_end}
		{it:A}:  {it:b x n}
	   {it:result}:  {it:b x n}

{p 4 4 2}
    {cmd:SPMATbandedplus()},
    {cmd:SPMATbandedminus()}:
{p_end}
		{it:A}:  {it:b1 x n}        where {it:b1} = {it:lb1}{cmd: + 1 + }{it:ub1}
		{it:B}:  {it:b2 x n}        where {it:b2} = {it:lb2}{cmd: + 1 + }{it:ub2}
	   {it:result}:   {it:b x n}        where  {it:b} = {cmd:max(}{it:lb1}{cmd:,}{it:lb2}{cmd:) + 1 + max(}{it:ub1}{cmd:,}{it:ub2}{cmd:)}

{p 4 4 2}
    {cmd:SPMATbandedtrace()}:
{p_end}
		{it:A}:  {it:b x n}
	   {it:result}:  1 {it:x} 1

{p 4 4 2}
    {cmd:SPMATbandedtracemult()}:
{p_end}
		{it:A}:  {it:b1 x n}
		{it:B}:  {it:b2 x n}
	   {it:result}:   1 {it:x} 1

{p 4 4 2}
    {cmd:SPMATbandedmult()}:
{p_end}
		{it:A}:  {it:b1 x n}        where {it:b1} = {it:lb1}{cmd: + 1 + }{it:ub1}
		{it:B}:  {it:b2 x n}        where {it:b2} = {it:lb2}{cmd: + 1 + }{it:ub2}
	   {it:result}:   {it:b x n}        where  {it:b} = {cmd:(}{it:lb1}{cmd:+}{it:lb2}{cmd:) + 1 + (}{it:ub1}{cmd:+}{it:ub2}{cmd:)}

{p 4 4 2}
    {cmd:SPMATbandedcross()}:
{p_end}
		{it:A}:  {it:b1 x n}        where {it:b1} = {it:lb1}{cmd: + 1 + }{it:ub1}
	   {it:result}:   {it:b x n}        where  {it:b} = {cmd:(}{it:lb1}{cmd:+}{it:ub1}{cmd:) + 1 + (}{it:lb1}{cmd:+}{it:ub1}{cmd:)}

{p 4 4 2}
    {cmd:SPMATbandedmultfull()}:
{p_end}
		{it:A}:  {it:b x n}
		{it:X}:  {it:n x k}
	   {it:result}:  {it:n x k}
	   

{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
    None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
