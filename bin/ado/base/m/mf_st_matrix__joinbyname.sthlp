{smcl}
{* *! version 1.0.0  08may2019}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_matrix()" "help mf_st_matrix"}{...}
{vieweralsosee "[M-5] st_ms_utils" "help mf_st_ms_utils"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rowjoinbyname" "help matrix_rowjoinbyname"}{...}
{viewerjumpto "Syntax" "mf_st_matrix__joinbyname##syntax"}{...}
{viewerjumpto "Description" "mf_st_matrix__joinbyname##description"}{...}
{viewerjumpto "Conformability" "mf_st_matrix__joinbyname##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_matrix__joinbyname##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_matrix__joinbyname##source"}{...}
{title:Title}

{phang}
{cmd:[M-5] st_matrix__joinbyname()} {hline 2} Join rows of Stata matrices
while matching column names


{marker syntax}{...}
{title:Syntax}

{col 5}Setup

{col 9}{cmd:class st_matrix__joinbyname scalar} {it:A}
{col 5}{it:or}
{col 9}{it:A}{col 21}{cmd:= st_matrix__joinbyname()}

{col 23}{it:A}{cmd:.list(}{it:list}{cmd:)}
{col 23}{it:A}{cmd:.type(}{it:rowcol}{cmd:)}
{col 23}{it:A}{cmd:.missing_code(}{it:value}{cmd:)}
{col 23}{it:A}{cmd:.consolidate(}{it:consolidate}{cmd:)}
{col 23}{it:A}{cmd:.encode_omit(}{it:encode_omit}{cmd:)}
{col 23}{it:A}{cmd:.ignore_omit(}{it:ignore_omit}{cmd:)}

{col 5}Query

{col 9}{it:list}{col 21}{cmd:=} {it:A}{cmd:.list()}
{col 9}{it:rowcol}{col 21}{cmd:=} {it:A}{cmd:.type()}
{col 9}{it:value}{col 21}{cmd:=} {it:A}{cmd:.missing_code()}
{col 9}{it:consolidate}{col 21}{cmd:=} {it:A}{cmd:.consolidate()}
{col 9}{it:encode_omit}{col 21}{cmd:=} {it:A}{cmd:.encode_omit()}
{col 9}{it:ignore_omit}{col 21}{cmd:=} {it:A}{cmd:.ignore_omit()}

{col 5}Actions

{col 23}{it:A}{cmd:.join()}
{col 23}{it:A}{cmd:.post(}{it:matname}{cmd:)}
{col 9}{it:result}{col 21}{cmd:=} {it:A}{cmd:.result()}
{col 9}{it:rowstripe}{col 21}{cmd:=} {it:A}{cmd:.rowstripe()}
{col 9}{it:colstripe}{col 21}{cmd:=} {it:A}{cmd:.colstripe()}


{pstd}
where

{p2colset 9 21 25 2}{...}
{p2col:{it:rowcol}}: string scalar, {bf:"row} or {bf:"column"}{p_end}
{p2col:{it:list}}: string vector{p_end}
{p2col:{it:value}}: real scalar{p_end}
{p2col:{it:consolidate}}: real scalar, {bf:0} means off{p_end}
{p2col:{it:encode_omit}}: real scalar, {bf:0} means off{p_end}
{p2col:{it:ignore_omit}}: real scalar, {bf:0} means off{p_end}
{p2col:{it:result}}: real matrix{p_end}
{p2col:{it:rowstripe}}: string matrix{p_end}
{p2col:{it:colstripe}}: string matrix{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Mata class {cmd:st_matrix__joinbyname} joins Stata matrices along
one dimension while matching names in the other dimension.
The default is to join rows while matching on column names, but you can
also join columns while matching on row names.


{marker remarks}{...}
{title:Remarks}

{pstd}
The minimum required setup and actions are

{col 23}{it:A}{cmd:.list(}{it:list}{cmd:)}
{col 23}{it:A}{cmd:.join()}

{pstd}
then

{col 23}{it:A}{cmd:.post(}{it:matname}{cmd:)}

{pstd}
or

{col 9}{it:result}{col 21}= {it:A}{cmd:.result()}
{col 9}{it:rowstripe}{col 21}{cmd:=} {it:A}{cmd:.rowstripe()}
{col 9}{it:colstripe}{col 21}{cmd:=} {it:A}{cmd:.colstripe()}

{pstd}
where {it:list} is a string vector containing the names of Stata
matrices you wish to join into a single matrix, {it:matname} is the name
of a Stata matrix where you want to put the resulting joined matrix,
{it:result} is a Mata matrix where you want to put the resulting joined
matrix, {it:rowstripe} is a string matrix containing the matrix row
names corresponding to {it:result}, and {it:colstripe} is a string
matrix containing the matrix column names corresponding to {it:result}.

{pstd}
By default, matrix rows are joined while matching on matrix column
names.  To join matrix columns while matching on matrix row names, use

{col 23}{it:A}{cmd:.type("column")}

{pstd}
{it:A}{cmd:.type(}{it:rowcol}{cmd:)} will also accept abbreviations of
{cmd:"column"}; the minimum abbreviation is {cmd:"col"}.

{pstd}
By default, elements of a matrix in {it:list} are coded with
{cmd:.} (the "system missing value") where they do not match with the
other matrices in {it:list}.  To change this, use your own code
{it:value} in

{col 23}{it:A}{cmd:.missing_code(}{it:value}{cmd:)}

{pstd}
Equations and names with equations are consolidated by default.
To turn this off, use

{col 23}{it:A}{cmd:.consolidate(0)}

{pstd}
When matching column (or row) names, zero-valued elements of the
matrices with an omit or base-level operator in the column (row) name
are not encoded by default.  To have these elements encoded, use

{col 23}{it:A}{cmd:.encode_omit(1)}

{pstd}
Base levels of factor variables and interactions are encoded with
{cmd:.b}, empty levels are encoded with {cmd:.e}, and all other omitted
elements are encoded with {cmd:.o}.
When this feature is turned on, these missing values are not allowed to
be set in {it:A}{cmd:.missing_code(}{it:value}{cmd:)}.

{pstd}
The base and omit operators are preserved in the matching column (or
row) names but only from the first matrix in which they appear.
To have base and omit operators removed from the matching column (or
row) names, use

{col 23}{it:A}{cmd:.ignore_omit(1)}

{pstd}
This setting is implied by {it:A}{cmd:.ignore_omit(1)}.


{marker conformability}{...}
{title:Conformability}

    {it:A}{cmd:.list(}{it:list}{cmd:)}:
	     {it:list}:  1 {it:x} {it:n} or {it:n} {it:x} 1
	   {it:result}:  {it:void}

    {it:A}{cmd:.list()}:
	   {it:result}:  1 {it:x} {it:n}

    {it:A}{cmd:.type(}{it:rowcol}{cmd:)}:
	   {it:rowcol}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {it:A}{cmd:.type()}:
	   {it:result}:  1 {it:x} 1

    {it:A}{cmd:.missing_code(}{it:value}{cmd:)}:
	    {it:value}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {it:A}{cmd:.missing_code()}:
	   {it:result}:  1 {it:x} 1

    {it:A}{cmd:.consolidate(}{it:consolidate}{cmd:)}:
      {it:consolidate}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {it:A}{cmd:.consolidate()}:
	   {it:result}:  1 {it:x} 1

    {it:A}{cmd:.encode_omit(}{it:encode_omit}{cmd:)}:
      {it:encode_omit}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {it:A}{cmd:.encode_omit()}:
	   {it:result}:  1 {it:x} 1

    {it:A}{cmd:.ignore_omit(}{it:ignore_omit}{cmd:)}:
      {it:ignore_omit}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {it:A}{cmd:.ignore_omit()}:
	   {it:result}:  1 {it:x} 1

    {it:A}{cmd:.join()}:
	   {it:result}:  {it:void}

    {it:A}{cmd:.post(}{it:matname}{cmd:)}:
          {it:matname}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {it:A}{cmd:.result()}:
	   {it:result}:  {it:rows} {it:x} {it:cols}

    {it:A}{cmd:.rowstripe()}:
	   {it:result}:  {it:rows} {it:x} 2

    {it:A}{cmd:.colstripe()}:
	   {it:result}:  {it:cols} {it:x} 2


{marker diagnostics}{...}
{title:Diagnostics}

{pstd}
None.


{marker source}{...}
{title:Source code}

{pstd}
{view st_matrix__joinbyname.mata, adopath asis:associativearray.mata}
{p_end}
