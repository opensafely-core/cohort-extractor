{smcl}
{* *! version 1.1.5  23jun2019}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spmatrix create" "mansection SP spmatrixcreate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "[SP] spmatrix" "help spmatrix"}{...}
{vieweralsosee "[M] mata" "mansection M-0 Mata"}{...}
{viewerjumpto "Syntax" "spmatrix_create##syntax"}{...}
{viewerjumpto "Menu" "spmatrix_create##menu"}{...}
{viewerjumpto "Description" "spmatrix_create##description"}{...}
{viewerjumpto "Links to PDF documentation" "spmatrix_create##linkspdf"}{...}
{viewerjumpto "Options for spmatrix create contiguity" "spmatrix_create##options_contiguity"}{...}
{viewerjumpto "Option for spmatrix create idistance" "spmatrix_create##option_idistance"}{...}
{viewerjumpto "Options for both contiguity and idistance" "spmatrix_create##options_contiguity_idistance"}{...}
{viewerjumpto "Examples" "spmatrix_create##examples"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[SP] spmatrix create} {hline 2}}Create standard weighting
matrices{p_end}
{p2col:}({mansection SP spmatrixcreate:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:spmatrix} {cmd:create}
{opt cont:iguity} {it:spmatname}
{ifin}
[{cmd:,} {help spmatrix_create##contoptions:{it:contoptions}}
{help spmatrix_create##stdoptions:{it:stdoptions}}]

{p 8 14 2}
{cmd:spmatrix} {cmd:create}
{opt idist:ance} {it:spmatname}
{ifin}
[{cmd:,} {help spmatrix_create##idistoption:{it:idistoption}}
{help spmatrix_create##stdoptions:{it:stdoptions}}]

{phang}
{it:spmatname} is a weighting matrix name.

{marker contoptions}{...}
{synoptset 20}{...}
{synopthdr:contoptions}
{synoptline}
{synopt :{opt rook}}share a border and not just a vertex{p_end}
{synopt :{opt first}}first-order neighbors{p_end}
{synopt :{opt sec:ond}[{cmd:(}{it:#}{cmd:)}]}second-order neighbors{p_end}
{synoptline}

{marker idistoption}{...}
{synopthdr:idistoption}
{synoptline}
{synopt :{opt vtrunc:ate(#)}}set (i,j) element to 0 if 1/distance {ul:<} {it:#}{p_end}
{synoptline}

{marker stdoptions}{...}
{synopthdr:stdoptions}
{synoptline}
{synopt :{opth norm:alize(spmatrix_create##normalize:normalize)}}type of
normalization; default is {cmd:normalize(spectral)}{p_end}
{synopt :{cmd:replace}}replace existing weighting matrix{p_end}
{synoptline}


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spmatrix} {cmd:create} creates standard-format spatial
weighting matrices.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spmatrixcreateQuickstart:Quick start}

        {mansection SP spmatrixcreateRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_contiguity}{...}
{title:Options for spmatrix create contiguity}

{phang}
{opt rook} specifies that areas that share just a vertex not be treated
as neighbors.  For instance, consider the following map:

                                  +-------+
                                  |       |
                       +----------+   C   |
                       |    B     |       |
                 +----------------+-------+
                 |          A     |
                 +----------------+

{pmore}
If {opt rook} is not specified, A and C are neighbors because they have a
vertex (corner) in common.  If {opt rook} is specified, A and C are not
neighbors.  Regardless of whether {opt rook} is specified, A and B are
neighbors and B and C are neighbors because they share a border (line
segment).

{phang}
{opt first} specifies that first-order neighbors be assigned 1.  If
areas i and j are neighbors, then {it:spmatname}_{i,j} =
{it:spmatname}_{j,i} = 1.  {cmd:first} is the default unless {cmd:second} or
{opt second(#)} is specified.

{phang}
{opt second}[{cmd:(}{it:#}{cmd:)}] specifies that the second-order
neighbors -- neighbors of neighbors -- be assigned a nonzero value.
{cmd:second} specifies that they be assigned 1.  {opt second(#)}
specifies that they be assigned {it:#}.

{pmore}
If you also specify option {cmd:first}, then the matrix created will set
first-order neighbors to contain 1.  For instance, if you specify {cmd:first}
{cmd:second}, both kinds of neighbors will be set to 1.  If you specify
{cmd:first} {cmd:second(.5)}, first-order neighbors are set to 1 and
second-order neighbors are set to 0.5.


{marker option_idistance}{...}
{title:Option for spmatrix create idistance}

{marker vtruncate}{...}
{phang}
{opt vtruncate(#)} specifies that areas farther apart than {it:#} be set to 0.
Type {cmd:spset} without arguments to determine the units in which {it:#} is
specified.  The {opt coordinates} line of {opt spset}'s output will be one of
the following:

            {cmd}coordinates:  _CX, _CY (planar)
            coordinates:  _CY, _CX (latitude and longitude, kilometers)
            coordinates:  _CY, _CX (latitude and longitude, miles){txt}

{pmore}
Units of {it:#} will be planar, kilometers, or miles.  If
planar, see {manhelp spdistance SP} for advice on determining the units.

{pmore}
If {opt spset} reports

            {cmd:coordinates:  none}

{pmore}
then you cannot use {cmd:spmatrix} {cmd:create}.


{marker options_contiguity_idistance}{...}
{title:Options for both contiguity and idistance}

{marker normalize}{...}
{phang}
{opt normalize(normalize)} specifies how the resulting matrix is to be
scaled.

{phang2}
{cmd:normalize(}{cmdab:spec:tral)} is the default.  The matrix will be
normalized so that its largest eigenvalue is 1.

{phang2}
{cmd:normalize(minmax)} specifies that the matrix elements be
divided by the smaller of the largest row or column sum of absolute
values.  The min-max calculation is much quicker than the
spectral calculation and in most cases gives similar results as the
spectral normalization.

{phang2}
{cmd:normalize(row)} specifies that each row of the matrix be
divided by the row's sum (not absolute values).  This
adjustment can be performed even more quickly than the min-max adjustment.

{phang2}
{cmd:normalize(none)} specifies that the matrix not be rescaled.  This option
has one use:  To store the matrix in unadjusted form so that you can fetch it
later, make changes to it while the matrix is still in its original units, and
then repost the matrix, at which point it will be rescaled.  See 
{mansection SP spregressRemarksandexamplesChoosingweightingmatricesandtheirnormalization:{it:Choosing weighting matrices and their normalization}}
in {bf:[SP] spregress} for details about normalization.

{phang}
{opt replace} specifies that matrix {it:spmatname} may be replaced if 
it already exists.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/texas_merge.dta .}
{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/texas_merge_shp.dta .}
{p_end}
{phang2}{cmd:. use texas_merge}

{pstd}Create spectral-normalized contiguity weighting matrix with the default spectral normalization{p_end}
{phang2}{cmd:. spmatrix create contiguity W}

{pstd}Create row-standardized contiguity weighting matrix with second-order
neighbors set to 0.5 and row normalization{p_end}
{phang2}{cmd:. spmatrix create contiguity M, normalize(row) second(0.5)}

{pstd}Create spectral-normalized inverse-distance weighting matrix with min-max normalization{p_end}
{phang2}{cmd:. spmatrix create idistance W, normalize(minmax) replace}
{p_end}
