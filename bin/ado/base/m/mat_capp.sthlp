{smcl}
{* *! version 1.0.6  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "[P] matrix operators" "help matrix_operators"}{...}
{viewerjumpto "Syntax" "mat_capp##syntax"}{...}
{viewerjumpto "Description" "mat_capp##description"}{...}
{viewerjumpto "Options" "mat_capp##options"}{...}
{viewerjumpto "Examples" "mat_capp##examples"}{...}
{viewerjumpto "Acknowledgment" "mat_capp##ack"}{...}
{title:Title}

{p 4 22 2}
{hi:[R] mat_capp} {hline 2} Operators on matrices by names rather than positions


{marker syntax}{...}
{title:Syntax}

{p 8 24 2}
{cmd:mat_capp}{space 2}{it:mat1} {cmd::} {it:mat2} {it:mat3} [{cmd:,} {cmd:miss(}{it:#}{cmd:)} {cmd:cons} {cmd:ts} ]

{p 8 24 2}
{cmd:mat_rapp}{space 2}{it:mat1} {cmd::} {it:mat2} {it:mat3} [{cmd:,} {cmd:miss(}{it:#}{cmd:)} {cmd:cons} {cmd:ts} ]

{p 8 24 2}
{cmd:mat_order} {it:mat1} {cmd::} {it:mat2} {it:mat3}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mat_capp} creates matrix {it:mat1} by appending the columns of
the matrices {it:mat1} and {it:mat2} matched on the
row-names of {it:mat2} and {it:mat3}.  Thus the number of columns
of {it:mat1} equals the sum of the numbers of columns of {it:mat2}
and {it:mat3}.

{pstd}
If {cmd:miss} is not specified, the row names of {it:mat2} and of
{it:mat3} should match by equation and name, though they need not be in the
same order.

{pstd}
{cmd:mat_rapp} performs a similar rowwise operation.

{pstd}
{cmd:mat_order} returns a matrix {it:mat1} that contains the values of
{it:mat2} with rows and columns ordered as in {it:mat3}.  The
row and column names of {it:mat2} and {it:mat3} should match exactly.

{pstd}
In all cases, {it:mat1} may be the same matrix as {it:mat2} or {it:mat3}.


{marker options}{...}
{title:Options}

{phang}
{cmd:miss(}{it:#}{cmd:)}
    specifies that the rows of {it:mat2} and {it:mat3} are matched by
    equation and name.  Missing elements corresponding with unmatched
    combinations of rows are set to {it:#}.  Rows of {it:mat3} that
    match an equation, but not a name, of {it:mat2} are inserted at the
    end of the equation in {it:mat1}.  Rows of {it:mat3} that do not
    match any equation are inserted at the end of {it:mat1}.

{phang}
{cmd:cons}
    specifies that rows corresponding with variable {cmd:_cons} should be
    moved to the end of the equation.

{phang}
{cmd:ts}
    specifies that rows with names with a time-series operator are
    inserted at the end of the corresponding variable.


{marker examples}{...}
{title:Examples}

    {hi:Ex 1}

                 b1  b2                  c1
              a1  1   2             a3   13
        z1 =  a2  3   4      z2 =   a1   11
              a3  5   6             a2   12

        {cmd:. mat_capp z12 : z1 z2}

                 b1  b2  c1
              a1  1   2  11
        z12 = a2  3   4  12
              a3  5   6  13


    {hi:Ex 2}

                   z11 z12                z11 z13
             A:a1    1   5          A:a1   11  12
        z1 = A:a2    2   6     z2 = A:a3   21  22
             B:b1    3   7          B:b1   31  32
               e1    4   8          C:c1   41  42

        {cmd:. mat_capp z12 : z1 z2, miss(.)}

                      z11 z12 z11 z13
                 A:a1   1   5  11  12
                 A:a2   2   6   .   .
        z12 =    A:a3   .   .  21  22
                 B:b1   3   7  31  32
                   e1   4   8   .   .
                 C:c1   .   .  41  42


    {hi:Ex 3}

                 b1  b2  b3              b1  b3  b2
             a1   1   5   9         a1   11  13  12
        z1 = a2   2   6  10    z2 = a4   21  23  22
             a3   3   7  11         a3   31  33  32
             a4   4   8  12         a2   41  43  42

        {cmd:. mat_order z12 : z1 z2}

                 b1  b3  b2
              a1  1   9   5
        z12 = a4  4  12   8
              a3  3  11   7
              a2  2  10   6


{marker ack}{...}
{title:Acknowledgment}

{pstd}
These commands were written by Jeroen Weesie, Department of Sociology,
Utrecht University, The Netherlands.
{p_end}
