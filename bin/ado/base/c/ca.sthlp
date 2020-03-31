{smcl}
{* *! version 1.3.18  19oct2017}{...}
{viewerdialog ca "dialog ca"}{...}
{viewerdialog camat "dialog camat"}{...}
{vieweralsosee "[MV] ca" "mansection MV ca"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] ca postestimation" "help ca postestimation"}{...}
{vieweralsosee "[MV] ca postestimation plots" "help ca postestimation plots"}{...}
{vieweralsosee "[MV] mca" "help mca"}{...}
{vieweralsosee "[R] tabulate twoway" "help tabulate_twoway"}{...}
{viewerjumpto "Syntax" "ca##syntax"}{...}
{viewerjumpto "Menu" "ca##menu"}{...}
{viewerjumpto "Description" "ca##description"}{...}
{viewerjumpto "Links to PDF documentation" "ca##linkspdf"}{...}
{viewerjumpto "Options" "ca##options"}{...}
{viewerjumpto "Remarks" "ca##remarks"}{...}
{viewerjumpto "Examples" "ca##examples"}{...}
{viewerjumpto "Stored results" "ca##results"}{...}
{viewerjumpto "References" "ca##references"}{...}
{p2colset 1 12 14 2}{...}
{p2col:{bf:[MV] ca} {hline 2}}Simple correspondence analysis
{p_end}
{p2col:}({mansection MV ca:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Simple correspondence analysis of two categorical variables

{p 8 16 2}
{cmd:ca} {it:rowvar} {it:colvar} {ifin}
[{it:{help ca##weight:weight}}]
[{cmd:,} {it:options}]


{pstd}
Simple correspondence analysis with crossed (stacked) variables

{p 8 16 2}
{cmd:ca} {it:row_spec} {it:col_spec} {ifin}
[{it:{help ca##weight:weight}}]
[{cmd:,} {it:options}]


{pstd}
Simple correspondence analysis of an {it:n_r} x {it:n_c} matrix

{p 8 16 2}
{cmd:camat} {it:matname} [{cmd:,}
{it:options}]


    where
{p 12 16 2}
{it:spec} = {varname} | {cmd:(}{it:{help newvar}} {cmd::} {varlist}{cmd:)}

{p 8 12 2}
and {it:matname} is an {it:n_r} x {it:n_c} matrix with {it:n_r},
{it:n_c} {ul:>} 2.


{synoptset 22 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab:Model 2}
{synopt:{opt dim:ensions(#)}}number of dimensions (factors, axes);
	default is {cmd:dim(2)}{p_end}
{synopt:{opth norm:alize(ca##nopts:nopts)}}normalization of row and column
	coordinates{p_end}
{synopt:{opt rows:upp(matname_r)}}matrix of supplementary rows{p_end}
{synopt:{opt cols:upp(matname_c)}}matrix of supplementary columns{p_end}
{synopt:{opth rown:ame(strings:string)}}label for rows{p_end}
{synopt:{opth coln:ame(strings:string)}}label for columns{p_end}
{synopt:{opt mis:sing}}treat missing values as ordinary values
	({cmd:ca} only){p_end}

{syntab:Codes ({cmd:ca} only)}
{synopt:{cmdab:rep:ort(}{cmdab:v:ariables)}}report coding of
crossing variables{p_end}
{synopt:{cmdab:rep:ort(}{cmdab:c:rossed)}}report coding of
crossed variables{p_end}
{synopt:{cmdab:rep:ort(}{cmdab:a:ll)}}report coding of crossing and
crossed variables{p_end}
{synopt:{cmdab:len:gth(}{cmdab:m:in)}}use minimal length unique codes of crossing
	variables{p_end}
{synopt:{opt len:gth(#)}}use {it:#} as coding length of crossing variables{p_end}

{syntab:Reporting}
{synopt:{opt ddim:ensions(#)}}number of singular values to be displayed;
	default is {cmd:ddim(.)}{p_end}
{synopt:{opt norowp:oints}}suppress table with row category statistics{p_end}
{synopt:{opt nocolp:oints}}suppress table with column category statistics{p_end}
{synopt:{opt comp:act}}display tables in a compact format{p_end}
{synopt:{opt plot}}plot the row and column coordinates{p_end}
{synopt:{opt max:length(#)}}maximum number of characters for labels;
	default is {cmd:maxlength(12)}{p_end}
{synoptline}

{marker nopts}{...}
{synoptset 22}{...}
{synopthdr:nopts}
{synoptline}
{synopt:{opt sy:mmetric}}symmetric coordinates ({opt ca:nonical}); the
	default{p_end}
{synopt:{opt st:andard}}row and column standard coordinates{p_end}
{synopt:{opt ro:w}}row principal, column standard coordinates{p_end}
{synopt:{opt co:lumn}}column principal, row standard coordinates{p_end}
{synopt:{opt pr:incipal}}row and column principal coordinates{p_end}
{synopt:{it:#}}power {cmd:0} <= {it:#} <= {cmd:1} for row coordinates; seldom
        used{p_end}
{synoptline}

{p 4 6 2}
{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {cmd:rolling}, and {cmd:statsby}
are allowed with {cmd:ca}; see {help prefix}.  However, {cmd:bootstrap} and
{cmd:jackknife} results should be interpreted with caution; identification of
the {cmd:ca} parameters involves data-dependent restrictions, possibly leading
to badly biased and overdispersed estimates
({help ca##MW1995:Milan and Whittaker 1995}).
{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{p 4 6 2}
{cmd:fweight}s, {cmd:aweight}s, and {cmd:iweight}s are allowed with {cmd:ca};
see {help weight}.
{p_end}
{p 4 6 2}
See {manhelp ca_postestimation MV:ca postestimation} for features available
after estimation.  {p_end}


{marker menu}{...}
{title:Menu}

    {title:ca}

{phang2}
{bf:Statistics > Multivariate analysis > Correspondence analysis >}
     {bf:Two-way correspondence analysis (CA)}

    {title:camat}

{phang2}
{bf:Statistics > Multivariate analysis > Correspondence analysis >}
     {bf:Two-way correspondence analysis of a matrix}


{marker description}{...}
{title:Description}

{pstd}
{cmd:ca} performs a simple correspondence analysis (CA) and
optionally creates a biplot of two categorical variables or
multiple crossed variables.  {cmd:camat} is similar to {cmd:ca}
but is for use with a matrix containing cross-tabulations or
other nonnegative values with strictly increasing margins.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV caQuickstart:Quick start}

        {mansection MV caRemarksandexamples:Remarks and examples}

        {mansection MV caMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model 2}

{phang}{opt dimensions(#)}
specifies the number of dimensions (= factors = axes) to be extracted.  The
default is {cmd:dimensions(2)}.  If you specify {cmd:dimensions(1)}, the row
and column categories are placed on one dimension.  {it:#} should be
strictly smaller than the number of rows and the number of columns, counting
only the active rows and columns, excluding supplementary rows and columns
(see options {helpb ca##rowsupp():rowsupp()} and
{helpb ca##colsupp():colsupp()}).

{pmore}
CA is a hierarchical method, so that extracting more dimensions does not
affect the coordinates and decomposition of inertia of dimensions already
included.  The percentages of inertia accounting for the dimensions are in
decreasing order as indicated by singular values.  The first dimension
accounts for the most inertia, followed by the second dimension, and then the
third dimension, etc.

{phang}{opt normalize(nopts)}
specifies the normalization method, that is, how the row and column coordinates
are obtained from the singular vectors and singular values of the matrix of
standardized residuals.  See
{it:{help ca##norm:Normalization and interpretation of correspondence analysis}}
for a discussion of these different normalization methods.

{phang2}{opt symmetric}, the default,
distributes the inertia equally over rows and columns, treating the rows and
columns symmetrically.  The symmetric normalization is also known as the
standard, or canonical, normalization.  This is the most common normalization
when making a biplot.  {cmd:normalize(symmetric)} is equivalent to
{cmd:normalize(0.5)}. {cmdab:ca:nonical} is a synonym for {cmd:symmetric}.

{phang2}{opt standard}
specifies that row and column coordinates should be in standard form (singular
vectors divided by the square root of mass).   This normalization method is
not equivalent to {opt normalize(#)} for any {it:#}.

{phang2}{opt row}
specifies principal row coordinates and standard column coordinates.  This
option should be chosen if you want to compare row categories.  Similarity of
column categories should not be interpreted.  The biplot interpretation of the
relationship between row and column categories is appropriate.
{cmd:normalize(row)} is equivalent to {cmd:normalize(1)}.

{phang2}{opt column}
specifies principal column coordinates and standard row coordinates.  This
option should be chosen if you want to compare column categories.  Similarity
of row categories should not be interpreted.  The biplot interpretation of the
relationship between row and column categories is appropriate.
{cmd:normalize(column)} is equivalent to {cmd:normalize(0)}.

{phang2}{opt principal}
is the normalization to choose if you want to make comparisons among the row
categories and among the column categories.  In this normalization, comparing
row and column points is not appropriate.  Thus a biplot in this
normalization is best avoided.  In the principal normalization, the row and
column coordinates are obtained from the left and right singular vectors,
multiplied by the singular values.  This normalization method is not
equivalent to {opt normalize(#)} for any {it:#}.

{phang2}{it:#}, {cmd:0} {ul:<} {it:#} {ul:<} {cmd:1},
is seldom used; it specifies that the row coordinates are obtained as the left
singular vectors multiplied by the singular values to the power {it:#}, whereas
the column coordinates equal the right singular vectors multiplied by the
singular values to the power 1-{it:#}.

{marker rowsupp()}{...}
{phang}{opt rowsupp(matname_r)}
specifies a matrix of supplementary rows.  {it:matname_r} should have {it:n_c}
columns.  The row names of {it:matname_r} are used for labeling.  Supplementary
rows do not affect the computation of the dimensions and the decomposition of
inertia.  They are, however, included in the plots and in the table with
statistics of the row points.  Because supplementary points do not contribute to
the dimensions, their entries under the column labeled {cmd:contrib} are left
blank.

{marker colsupp()}{...}
{phang}{opt colsupp(matname_c)}
specifies a matrix of supplementary columns.  {it:matname_c} should have
{it:n_r} rows.  The column names of {it:matname_c} are used for labeling.
Supplementary columns do not affect the computation of the dimensions and the
decomposition of inertia.  They are, however, included in the plots and in the
table with statistics of the column points.  Because supplementary points do
not contribute to the dimensions, their entries under the column labeled
{cmd:contrib} are left blank.

{phang}{opth rowname:(strings:string)} specifies a label to refer to the rows
of the matrix.  The default is {cmd:rowname(rowvar)} for {cmd:ca} and
{cmd:rowname(rows)} for {cmd:camat}.

{phang}{opth colname:(strings:string)} specifies a label to refer to the columns
of the matrix.  The default is {cmd:colname(colvar)} for {cmd:ca} and
{cmd:colname(columns)} for {cmd:camat}.

{phang}{opt missing}, allowed only with {cmd:ca},
treats missing values of {it:rowvar} and {it:colvar} as ordinary categories to
be included in the analysis.  Observations with missing values are omitted
from the analysis by default.

{dlgtab:Codes}

{phang}{opt report(opt)}
displays coding information for the crossing variables, crossed variables,
or both.  {cmd:report()} is ignored if you do not specify at least one
crossed variable.

{phang2}
{cmd:report(variables)} displays the coding schemes of the crossing variables,
that is, the variables used to define the crossed variables.

{phang2}
{cmd:report(crossed)} displays a table explaining the value labels of the
crossed variables.

{phang2}
{cmd:report(all)} displays the codings of the crossing and crossed variables.

{phang}{opt length(opt)}
specifies the coding length of crossing variables.

{phang2}{cmd:length(min)}
specifies that the minimal-length unique codes of crossing variables be used.

{phang2}{opt length(#)}
specifies that the coding length {it:#} of crossing variables be used, where
{it:#} must be between 4 and 32.

{dlgtab:Reporting}

{phang}{opt ddimensions(#)}
specifies the number of singular values to be displayed.
The default is {cmd:ddimensions(.)}, meaning all.

{phang}{cmd:norowpoints}
suppresses the table with row point (category) statistics.

{phang}{cmd:nocolpoints}
suppresses the table with column point (category) statistics.

{phang}{opt compact}
specifies that the table with point statistics be displayed multiplied by
1,000 as proposed by {help ca##G2007:Greenacre (2007)}, enabling the display of
more columns without wrapping output.  The compact tables can be displayed
without wrapping for models with two dimensions at line size 79 and with three
dimensions at line size 99.

{phang}{opt plot}
displays a plot of the row and column coordinates in two dimensions.  With
row principal normalization, only the row points are plotted.  With column
principal normalization, only the column points are plotted.  In the other
normalizations, both row and column points are plotted.  You can use
{cmd:cabiplot} directly if you need another selection of points to be
plotted or if you want to otherwise refine the plot; see
{manhelp ca_postestimation_plots MV:ca postestimation plots}.

{phang}{opt maxlength(#)}
specifies the maximum number of characters for row and column labels in plots.
The default is {cmd:maxlength(12)}.

{pstd}
Note: The reporting options may be specified during estimation or replay.


{marker remarks}{...}
{title:Remarks}

{marker norm}{...}
    {title:Normalization and interpretation of CA}

{pstd}
The normalization method used in the CA determines whether and how the
similarity of the row categories, the similarity of the column categories, and
the relationship (association) between the row and column variables can be
interpreted in terms of the row and column coordinates and the origin of the
plot.

{pstd}
How does one compare row points -- provided that the normalization
method allows such a comparison?  Formally, the Euclidean distance between the
row points approximates the chi-squared distances between the corresponding
row profiles.  Thus, in the biplot, row categories mapped close together have
similar row profiles; that is, the distributions on the column variable are
similar.  Row categories mapped widely apart have dissimilar row profiles.
Moreover, the Euclidean distance between a row point and the origin
approximates the chi-squared distance from the row profile and the row
centroid, so it indicates how different a category is from the population.

{pstd}
An analogous interpretation applies to column points.

{pstd}
For the association between the row and column variables:  In the CA
biplot, one should not interpret the distance between a row point r and a
column point c as the relationship of r and c.  Instead, think in terms
of the vectors origin to r (OR) and origin to c (OC).
Remember that CA decomposes scaled deviations d(r,c) from
independence, and d(r,c) is approximated by the inner product of OR
and OC.  The larger the absolute value of d(r,c), the stronger the
association between r and c.  In geometric terms, d(r,c) can be written
as the product of the length of OR, the length of OC, and the
cosine of the angle between OR and OC.

{pstd}
What does this mean?  First, consider the effects of the angle.  The
association in (r,c) is strongly positive if OR and OC point
in roughly the same direction; the frequency of (r,c) is much higher than
expected under independence, and so r tends to flock together with c--if
the points r and c are close together.
Similarly, the association is strongly negative if OR and OC
point in opposite directions.  Here, the frequency of (r,c) is much
lower than expected under independence, and so r and c are unlikely to
occur simultaneously.  Finally, if OR and OC are roughly
orthogonal (angle = +/- 90), the deviation from independence is small.

{pstd}
Second, the association of r and c increases with the lengths of
OR and OC.  Points far from the origin tend to have large
associations.  If a category is mapped close to the origin, all its
associations with categories of the other variable are small:
its distribution resembles the marginal distribution.

{pstd}
Here are the interpretations enabled by the main normalization methods as
specified in the {cmd:normalize()} option.

	{hline 54}
		      similarity   similarity     association
	method         row cat.    column cat.   row vs column
	{hline 54}
	{opt symmetric}          no          no             yes
	{opt principal}         yes         yes              no
	{opt row}               yes          no             yes
	{opt column}             no         yes             yes
	{hline 54}

{pstd}
If we say that a comparison between row categories or between column
categories is not possible, we really mean that the chi-squared
distance between row profiles or column profiles is actually approximated by a
weighted Euclidean distance between the respective plots in which the weights
depend on the inertia of the dimensions rather than on the standard Euclidean
distance.

{pstd}
You may want to do a CA in principal normalization to study the
relationship between the categories of a variable and do a CA in
symmetric normalization to study the association of the row and column
categories.


{marker examples}{...}
{title:Examples with ca}

{pstd}
{cmd:ca} creates the two-way frequency table from individual-level data and
performs a CA of this table.

{phang2}{cmd:. webuse ca_smoking}{p_end}
{phang2}{cmd:. ca rank smoking}{p_end}
{phang2}{cmd:. ca rank smoking, dim(3)}{p_end}

{pstd}
We want to include the distribution of smoking, estimated in a national
sample, in the analysis.  The data for
supplementary points are entered as a row vector with one row and four columns,
one for each smoking category:

{phang2}{cmd:. matrix SR = (42, 29, 20, 9)}{p_end}
{phang2}{cmd:. matrix rownames SR = national}{p_end}
{phang2}{cmd:. ca rank smoking, rowsupp(SR) plot}{p_end}


{title:Example with ca with crossed variables}

{pstd}
You want to analyze how gender and education affect response to the statement
"We believe too often in science, and not enough in feelings or faith,"  
coded in variable {cmd:A}, which has five categories, with 1 indicating strong
agreement and 5 indicating strong disagreement.  Variable {cmd:sex} contains
information on gender (two categories), and variable {cmd:edu} contains
information on education (six categories).  We think of the variables
{cmd:sex} and {cmd:edu} as a demographic classification with 2x6=12
categories.  {cmd:ca} performs a CA of the 5x12 frequency table:

{phang2}
{cmd:. webuse issp93}{p_end}
{phang2}
{cmd:. label language short}{p_end}
{phang2}
{cmd:. ca A (demo : sex edu), dim(2) report(c) length(min)}
{p_end}


{title:Example with camat}

{pstd}
To conduct a CA of data in tabular format it is
convenient to store the data in a Stata matrix and to use {cmd:camat} instead
of {cmd:ca}.  Consider this table:

{center:{txt}{hline 16}{c TT}{hline 31}}
{center:{txt}                {c |}            smoking            }
{center:{txt}      personnel {c |}   none   light  medium   heavy}
{center:{hline 16}{c +}{hline 31}}
{center:{txt} senior manager {c |}      {res}4       2       3       2}
{center:{txt} junior manager {c |}      {res}4       3       7       4}
{center:{txt}senior employee {c |}     {res}25      10      12       4}
{center:{txt}junior employee {c |}     {res}18      24      33      13}
{center:{txt}      secretary {c |}     {res}10       6       7       2}
{center:{txt}{hline 16}{c BT}{hline 31}}

{pstd}
The following code creates a Stata matrix {cmd:F} with the frequencies and
with the appropriate row and column names.  

{phang2}
{cmd:. matrix F = ( 4,2,3,2 \ 4,3,7,4 \ 25,10,12,4 \ 18,24,33,13 \ 10,6,7,2 )}
{p_end}
{phang2}
{cmd:. matrix colnames F = none light medium heavy}
{p_end}
{phang2}
{cmd:. matrix rownames F = sen_mngr jun_mngr sen_empl jun_employ secr}
{p_end}

{pstd}
To conduct the CA with two dimensions (the default) and produce a plot, invoke
{cmd:camat} on {cmd:F}.

{phang2}{cmd:. camat F, rowname(rank) colname(smoking) plot}{p_end}

{pstd}
We add two supplementary columns with the distributions among drinking and
nondrinking subjects.  We create a matrix with five rows (one for each staff
category) and two columns.

{phang2}{cmd:. matrix SC = ( 0,11 \ 1,17 \ 5,46 \ 10,78 \ 7,18)}{p_end}
{phang2}{cmd:. matrix colnames SC = nondrink drink}{p_end}

{phang2}{cmd:. camat F, rowsupp(SR) colsupp(SC) plot}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
Let {it:r} be the number of rows, {it:c} be the number of columns, and {it:f}
be the number of retained dimensions.
{cmd:ca} and {cmd:camat} store the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(f)}}number of dimensions (factors, axes); maximum of min({it:r}
- 1,{it:c} - 1){p_end}
{synopt:{cmd:e(inertia)}}total inertia = {cmd:e(X2)}/{cmd:e(N)}{p_end}
{synopt:{cmd:e(pinertia)}}inertia explained by {cmd:e(f)} dimensions{p_end}
{synopt:{cmd:e(X2)}}chi-squared statistic{p_end}
{synopt:{cmd:e(X2_df)}}degrees of freedom ({it:r} - 1)({it:c} - 1){p_end}
{synopt:{cmd:e(X2_p)}}{it:p}-value for {cmd:e(X2)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:ca} (even for {cmd:camat}){p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(Rcrossvars)}}row crossing variable names ({cmd:ca} only){p_end}
{synopt:{cmd:e(Ccrossvars)}}column crossing variable names ({cmd:ca} only){p_end}
{synopt:{cmd:e(varlist)}}the row and column variable names ({cmd:ca} only){p_end}
{synopt:{cmd:e(wtype)}}weight type ({cmd:ca} only){p_end}
{synopt:{cmd:e(wexp)}}weight expression ({cmd:ca} only){p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(ca_data)}}{cmd:variables} or {cmd:crossed}{p_end}
{synopt:{cmd:e(Cname)}}name for columns{p_end}
{synopt:{cmd:e(Rname)}}name for rows{p_end}
{synopt:{cmd:e(norm)}}normalization method{p_end}
{synopt:{cmd:e(sv_unique)}}{cmd:1} if the singular values are unique, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(properties)}}{cmd:nob noV eigen}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(Ccoding)}}column categories (1 x {it:c}) ({cmd:ca} only){p_end}
{synopt:{cmd:e(Rcoding)}}row categories (1 x {it:r}) ({cmd:ca} only){p_end}
{synopt:{cmd:e(GSC)}}column statistics ({it:c} x 3(1 + {it:f})){p_end}
{synopt:{cmd:e(GSR)}}row statistics ({it:r} x 3(1 + {it:f})){p_end}
{synopt:{cmd:e(TC)}}normalized column coordinates ({it:c} x {it:f}){p_end}
{synopt:{cmd:e(TR)}}normalized row coordinates ({it:r} x {it:f}){p_end}
{synopt:{cmd:e(Sv)}}singular values (1 x {it:f}){p_end}
{synopt:{cmd:e(C)}}column coordinates ({it:c} x {it:f}){p_end}
{synopt:{cmd:e(R)}}row coordinates ({it:r} x {it:f}){p_end}
{synopt:{cmd:e(c)}}column mass (margin) ({it:c} x 1){p_end}
{synopt:{cmd:e(r)}}row mass (margin) ({it:r} x 1){p_end}
{synopt:{cmd:e(P)}}analyzed matrix ({it:r} x {it:c}){p_end}
{synopt:{cmd:e(GSC_supp)}}supplementary column statistics{p_end}
{synopt:{cmd:e(GSR_supp)}}supplementary row statistics{p_end}
{synopt:{cmd:e(PC_supp)}}principal coordinates supplementary column points{p_end}
{synopt:{cmd:e(PR_supp)}}principal coordinates supplementary row points{p_end}
{synopt:{cmd:e(TC_supp)}}normalized coordinates supplementary column points{p_end}
{synopt:{cmd:e(TR_supp)}}normalized coordinates supplementary row points{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample ({cmd:ca} only){p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker G1984}{...}
{phang}
Greenacre, M. J. 1984. {it:Theory and Applications of Correspondence Analysis}.
London:Academic Press.

{marker G2007}{...}
{phang}
------. 2007. {it:Correspondence Analysis in Practice}. 2nd ed.
Boca Raton, FL: Chapman & Hall/CRC.

{marker MW1995}{...}
{phang}
Milan, L., and J. Whittaker. 1995. Application of the parametric bootstrap
to models that incorporate a singular value decomposition.
{it:Applied Statistics} 44: 31-49.
{p_end}
