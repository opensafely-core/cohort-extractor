{smcl}
{* *! version 1.1.11  19oct2017}{...}
{vieweralsosee "[MV] measure_option" "mansection MV measure_option"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] cluster" "help cluster"}{...}
{vieweralsosee "[MV] clustermat" "help clustermat"}{...}
{vieweralsosee "[P] matrix dissimilarity" "help matrix_dissimilarity"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] parse_dissim" "help parse_dissim"}{...}
{viewerjumpto "Syntax" "measure_option##syntax"}{...}
{viewerjumpto "Description" "measure_option##description"}{...}
{viewerjumpto "Options" "measure_option##options"}{...}
{viewerjumpto "References" "measure_option##references"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[MV]} {it:measure_option} {hline 2}}Option for similarity and
dissimilarity measures{p_end}
{p2col:}({mansection MV measure_option:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{it:command} ...{cmd:,} ... {opt mea:sure(measure)} ...

    or

	{it:command} ...{cmd:,} ... {it:measure} ...


INCLUDE help measure_option_optstab


{marker description}{...}
{title:Description}

{pstd}
Several commands have options that allow you to specify a similarity or
dissimilarity measure designated as {it:measure} in the syntax; see
{manhelp cluster MV}, {manhelp mds MV}, {manhelp discrim_knn MV:discrim knn},
and {manhelp matrix_dissimilarity MV: matrix dissimilarity}.  These options
are documented here.  Most analysis commands (for example, {cmd:cluster} and
{cmd:mds}) transform similarity measures to dissimilarity measures as needed.


{marker options}{...}
{title:Options}

{pstd}
Measures are divided into those for continuous data and binary data.
{it:measure} is not case sensitive.  Full definitions are presented
in
{it:{help measure_option##continuous:Similarity and dissimilarity measures for continuous data}},
{it:{help measure_option##binary:Similarity measures for binary data}}, and
{it:{help measure_option##mixed:Dissimilarity measures for mixed data}}.

{pstd}
The similarity or dissimilarity measure is most often used to determine
the similarity or dissimilarity between observations.  However, sometimes
the similarity or dissimilarity between variables is of interest.


{marker continuous}{...}
    {title:Similarity and dissimilarity measures for continuous data}

{pstd}
Here are the similarity and dissimilarity measures for continuous data
available in Stata.  In the following formulas, p represents the number
of variables, N is the number of observations, and x_iv denotes the value of
observation i for variable v.  See 
{mansection MV measure_optionOptionsSimilarityanddissimilaritymeasuresforcontinuousdata:{bf:[MV]} {it:measure_option}}
for the formulas for the similarity and dissimilarity measures between
variables (not presented here).


{phang}
{opt L2} (aliases {opt Euclidean} and {cmd:L(2)}){break}
requests the Minkowski distance metric with argument 2

{center:sqrt(sum((x_ia - x_ja)^2))}

{pmore}
{opt L2} is best known as Euclidean distance and is the default
dissimilarity measure for {cmd:discrim knn}, {cmd:mds},
{cmd:matrix dissimilarity}, and all the {cmd:cluster} subcommands
except for {cmd:centroidlinkage},
{cmd:medianlinkage}, and {cmd:wardslinkage}, which default to using
{cmd:L2squared}; see {manhelp discrim_knn MV:discrim knn}, {manhelp mds MV},
{manhelp matrix_dissimilarity MV:matrix dissimilarity}, and
{manhelp cluster MV}.

{phang}
{opt L2squared} (alias {opt Lpower(2)}){break}
requests the square of the Minkowski distance metric with argument 2

{center:sum((x_ia - x_ja)^2)}

{pmore}
{opt L2squared} is best known as squared Euclidean distance and is the
default dissimilarity measure for the {cmd:centroidlinkage},
{cmd:medianlinkage}, and {cmd:wardslinkage} subcommands of {cmd:cluster};
see {manhelp cluster MV}.

{phang}
{opt L1} (aliases {opt absolute}, {opt cityblock}, {opt manhattan}, and
{cmd:L(1)}){break}
requests the Minkowski distance metric with argument 1

{center:sum(|x_ia - x_ja|)}

{pmore}
which is best known as absolute-value distance.

{phang}
{opt Linfinity} (alias {opt maximum}){break}
requests the Minkowski distance metric with infinite argument

{center:max(|x_ia - x_ja|)}

{pmore}
and is best known as maximum-value distance.

{phang}
{opt L(#)}{break}
requests the Minkowski distance metric with argument {it:#}:

{center:(sum(|x_ia - x_ja|^{it:#})^(1/{it:#})     {it:#} >= 1}

{pmore}
We discourage using extremely large values for {it:#}.  Because the absolute
value of the difference is being raised to the value of {it:#}, depending on
the nature of your data, you could experience numeric overflow or underflow.
With a large value of {it:#}, the {opt L()} option will produce results
similar to those of the {opt Linfinity} option.  Use the numerically
more stable {opt Linfinity} option instead of a large value for {it:#} in the
{opt L()} option.

{pmore}
See {help measure_option##A1973:Anderberg (1973)} for a discussion of the
Minkowski metric and its special cases.

{phang}
{opt Lpower(#)}{break}
requests the Minkowski distance metric with argument {it:#}, raised to the
{it:#} power:

{center:sum(|x_ia - x_ja|^{it:#})     {it:#} >= 1}

{pmore}
As with {opt L(#)}, we discourage using extremely large values for
{it:#}; see the discussion above.

{phang}
{opt Canberra}{break}
requests the following distance metric

{center:sum(|x_ia - x_ja|/(|x_ia|+|x_ja|))}

{pmore}
which ranges from 0 to p, the number of variables.  
{help measure_option##G1999:Gordon (1999)} explains that the Canberra distance
is sensitive to small changes near zero.

{phang}
{opt correlation}{break}
requests the correlation coefficient similarity measure,

{center:sum((x_ia-xbar_i.)(x_ja-xbar_j.))}
{center:{hline 46}}
{center:sqrt(sum(x_ia-xbar_i.)^2 * sum(x_jb-xbar_j.)^2)}

{pmore}
where xbar_i. = sum(x_ia)/p.

{pmore}
The correlation similarity measure takes values between -1 and 1.  With this
measure, the relative direction of the two vectors is important.
The correlation similarity measure is related to the angular separation
similarity measure (described next).  The correlation similarity measure gives
the cosine of the angle between the two vectors measured from the mean;
see {help measure_option##G1999:Gordon (1999)}.

{phang}
{opt angular} (alias {opt angle}){break}
requests the angular separation similarity measure

{center:sum(x_ia * x_ja)/sqrt(sum(x_ia^2) * sum(x_jb^2))}

{pmore}
which is the cosine of the angle between the two vectors measured
from zero and takes values from -1 to 1;
see {help measure_option##G1999:Gordon (1999)}.


{marker binary}{...}
    {title:Similarity measures for binary data}

{pstd}
Similarity measures for binary data are based on the four values from the
cross-tabulation of observation i and j (when comparing observations) or
variables u and v (when comparing variables).

{pstd}
For comparing observations i and j, the cross-tabulation is

{center:       {c |} obs. j}
{center:       {c |}  1  0 }
{center:{hline 7}{c +}{hline 7}}
{center:obs. 1 {c |}  a  b }
{center: i   0 {c |}  c  d }

{pstd}
a is the number of variables where observations i and j both had ones, and d
is the number of variables where observations i and j both had zeros.  The
number of variables where observation i is one and observation j is zero is b,
and the number of variables where observation i is zero and observation j is
one is c.

{pstd}
See {hi:[MV]} {it:measure_option} to see a 
{mansection MV measure_optionOptionscompare_uv:similar table}
for comparison between variables.

{pstd}
Stata treats nonzero values as one when a binary value is expected.
Specifying one of the binary similarity measures imposes this behavior unless
some other option overrides it (for instance, the {opt allbinary} option of
{manhelp matrix_dissimilarity MV:matrix dissimilarity}).  See {hi:[MV]}
{it:measure_option} for a discussion of binary similarity measures applied to
averages.

{pstd}
The following binary similarity coefficients are available.  Unless stated
otherwise, the similarity measures range from 0 to 1.

{phang}
{opt matching}{break}
requests the simple matching
({help measure_option##Z1938:Zubin 1938},
 {help measure_option##SM1958:Sokal and Michener 1958}) binary similarity
coefficient

{center:(a+d)/(a+b+c+d)}

{pmore}
which is the proportion of matches between the 2 observations or variables.

{phang}
{opt Jaccard}{break}
requests the Jaccard
({help measure_option##J1901:1901},
 {help measure_option##J1908:1908}) binary similarity coefficient

{center:a/(a+b+c)}

{pmore}
which is the proportion of matches when at least one of the vectors had
a one.  If both vectors are all zeros, this measure is
undefined.  Stata then declares the answer to be one, meaning perfect
agreement.  This is a reasonable choice for most applications and will cause
an all-zero vector to have similarity of one only with another all-zero
vector.  In all other cases, an all-zero vector will have Jaccard
similarity of zero to the other vector.

{pmore}
The Jaccard coefficient was discovered earlier by 
{help measure_option##G1884:Gilbert (1884)}.

{phang}
{opt Russell}{break}
requests the {help measure_option##RR1940:Russell and Rao (1940)} binary
similarity coefficient

{center:a/(a+b+c+d)}

{phang}
{opt Hamann}{break}
requests the {help measure_option##H1961:Hamann (1961)} binary similarity
coefficient

{center:((a+d)-(b+c))/(a+b+c+d)}

{pmore}
which is the number of agreements minus disagreements divided by the total.
The Hamann coefficient ranges from -1, perfect disagreement, to 1, perfect
agreement.  The Hamann coefficient is equal to twice the simple matching
coefficient minus 1.

{phang}
{opt Dice}{break}
requests the Dice binary similarity coefficient

{center:2a/(2a+b+c)}

{pmore}
suggested by 
{help measure_option##C1932:Czekanowski (1932)},
{help measure_option##D1945:Dice (1945)}, and
{help measure_option##S1948:S{c o/}rensen (1948)}.
The Dice coefficient is similar to the Jaccard similarity coefficient but gives
twice the weight to agreements.  Like the Jaccard coefficient, the Dice
coefficient is declared by Stata to be one if both vectors are all zero, thus
avoiding the case where the formula is undefined.

{phang}
{opt antiDice}{break}
requests the binary similarity coefficient

{center:a/(a+2(b+c))}

{pmore}
which is credited to 
{help measure_option##A1973:Anderberg (1973)} but was shown earlier by
{help measure_option##SS1963:Sokal and Sneath (1963, 129)}.  We did not call
this the Anderberg coefficient because there is another coefficient better
known by that name; see the {helpb measure_option##Anderberg:Anderberg} option.
The name {opt antiDice} is our creation.  This coefficient takes the opposite
view from the Dice coefficient and gives double weight to disagreements.  As
with the Jaccard and Dice coefficients, the anti-Dice coefficient is declared
to be one if both vectors are all zeros.

{phang}
{opt Sneath}{break}
requests the {help measure_option##SS1962:Sneath and Sokal (1962)} binary
similarity coefficient

{center:2(a+d)/{c -(}2(a+d)+(b+c){c )-}}

{pmore}
which is similar to the simple matching coefficient but gives double weight
to matches.  Also compare the Sneath and Sokal coefficient with the Dice
coefficient, which differs only in whether it includes d.

{phang}
{opt Rogers}{break}
requests the {help measure_option##RT1960:Rogers and Tanimoto (1960)} binary
similarity coefficient

{center:(a+d)/{c -(}(a+d)+2(b+c){c )-}}

{pmore}
which takes the opposite approach from the Sneath and Sokal coefficient and
gives double weight to disagreements.  Also compare the Rogers and Tanimoto
coefficient with the anti-Dice coefficient, which differs only in whether it
includes d.

{phang}
{opt Ochiai}{break}
requests the {help measure_option##O1957:Ochiai (1957)} binary similarity
coefficient

{center:a/sqrt((a+b)(a+c))}

{pmore}
The formula for the Ochiai coefficient is undefined when one or both of the
vectors being compared are all zeros.  If both are all zeros, Stata
declares the measure to be one, and if only one of the two vectors is
all zeros, the measure is declared to be zero.

{pmore}
The Ochiai coefficient was presented earlier by
{help measure_option##DK1932:Driver and Kroeber (1932)}.

{phang}
{opt Yule}{break}
requests the Yule (see {help measure_option##Y1900:Yule [1900]} and 
{help measure_option##YK1950:Yule and Kendall [1950]}) binary similarity
coefficient

{center:(ad-bc)/(ad+bc)}

{pmore}
which ranges from -1 to 1.  The formula for the Yule coefficient is undefined
when one or both of the vectors are either all zeros or all ones.  Stata
declares the measure to be 1 when b+c = 0, meaning that there is complete
agreement.  Stata declares the measure to be -1 when a+d = 0, meaning that
there is complete disagreement.  Otherwise, if ad-bc = 0, Stata declares the
measure to be 0.  These rules, applied before using the Yule formula, avoid
the cases where the formula would produce an undefined result.

{marker Anderberg}
{phang}
{opt Anderberg}{break}
requests the Anderberg binary similarity coefficient

{center:(a/(a+b) + a/(a+c) + d/(c+d) + d/(b+d))/4}

{pmore}
The Anderberg coefficient is undefined when one or both vectors are either
all zeros or all ones.  This difficulty is overcome by first applying the rule
that if both vectors are all ones (or both vectors are all zeros),
the similarity measure is declared to be one.  Otherwise, if any of the
marginal totals (a+b, a+c, c+d, b+d) are zero, then the similarity measure is
declared to be zero.

{pmore}
Though this similarity coefficient is best known as the Anderberg coefficient,
it appeared earlier in 
{help measure_option##SS1963:Sokal and Sneath (1963, 130)}.

{phang}
{opt Kulczynski}{break}
requests the {help measure_option##K1927:Kulczyński (1927)} binary similarity
coefficient

{center:(a/(a+b) + a/(a+c))/2}

{pmore}
The formula for this measure is undefined when one or both of the vectors
are all zeros.  If both vectors are all zeros, Stata declares the
similarity measure to be one.  If only one of the vectors is all zeros,
the similarity measure is declared to be zero.

{phang}
{opt Pearson}{break}
requests Pearson's ({help measure_option##P1900:1900}) phi binary similarity
coefficient

{center:(ad-bc)/sqrt((a+b)(a+c)(d+b)(d+c))}

{pmore}
which ranges from -1 to 1.  The formula for this coefficient is undefined when
one or both of the vectors are either all zeros or all ones.  Stata
declares the measure to be 1 when b+c = 0, meaning that there is complete
agreement.  Stata declares the measure to be -1 when a+d = 0, meaning that
there is complete disagreement.  Otherwise, if ad-bc = 0, Stata declares the
measure to be 0.  These rules, applied before using Pearson's phi coefficient
formula, avoid the cases where the formula would produce an undefined result.

{phang}
{opt Gower2}{break}
requests the binary similarity coefficient

{center:ad/sqrt((a+b)(a+c)(d+b)(d+c))}

{pmore}
which is presented by {help measure_option##G1985:Gower (1985)} but appeared
earlier in {help measure_option##SS1963:Sokal and Sneath (1963, 130)}.
Stata uses the name {opt Gower2} to avoid confusion with the better-known Gower
coefficient, which is used with a mix of binary and continuous data.

{pmore}
The formula for this similarity measure is undefined when one or both of the
vectors are all zeros or all ones.  This is overcome by first applying
the rule that if both vectors are all ones (or both vectors are all
zeros) then the similarity measure is declared to be one.  Otherwise, if
ad = 0, the similarity measure is declared to be zero.
 
 
{marker mixed}{...}
    {title:Dissimilarity measure for mixed data}

{pstd}
Here is one measure that works with a mix of binary and continuous
data.  Binary variables are those containing only zeros, ones, and
missing values; all other variables are continuous.  The formulas below are
for the dissimilarity between observations; see 
{mansection MV measure_optionOptionsDissimilaritymeasuresformixeddata:{bf:[MV]} {it:measure_option}}
for the formulas for the dissimilarity between variables (not presented here).

{phang}
{opt Gower}{break}
requests the {help measure_option##G1971:Gower (1971)} dissimilarity
coefficient for a mix of binary and continuous variables

{center:sum(delta_ijv*d_ijv)/sum(delta_ijv)}

{pmore}
where delta_ijv is a binary indicator equal to 1 whenever both observations
i and j are nonmissing for variable v, and zero otherwise.  Observations with
missing values are not included when using {cmd:cluster} or {cmd:mds}, and so
if an observation is included, delta_ijv = 1 and sum(delta_ijv) is the number
of variables.  However, using {cmd:matrix dissimilarity} with the {cmd:Gower}
option does not exclude observations with missing values. See 
{manhelp cluster MV}, {manhelp mds MV}, and
{manhelp matrix_dissimilarity MV:matrix dissimilarity}.

{pmore}
For binary variables v, 

{center:d_ijv = 0 if x_iv=x_jv}
{center:      = 1    otherwise}

{pmore}
This is the same as the {cmd:matching} measure.

{pmore}
For continuous variables v,

{center:d_ijv = |x_iv - x_jv|/(max_k(x_kv)-min_k(x_kv))}

{pmore}
d_ijv is set to 0 if (max_k(x_kv)-min_k(x_kv)) is zero,
that is, if the range of the variable is zero. This is the {cmd:L1} measure
divided by the range of the variable.

{pmore}
The Gower measure interprets binary variables as those with only
0, 1, or missing values.  All other variables are treated as continuous.

{pmore}
In {manhelp matrix_dissimilarity MV:matrix dissimilarity}, missing
observations are included only in the calculation of the {cmd:Gower}
dissimilarity, but the formula for this dissimilarity measure is undefined
when all the values of delta_ijv or delta_iuv are zero.  The dissimilarity
is then set to missing. 


	{title:Technical note}

{pmore}
Normally the commands

{pmore2}
{cmd:. matrix dissimilarity gm = x1 x2 y1, Gower}{break}
{cmd:. clustermat waverage gm, add}{break}

{pmore}
and

{pmore2}
{cmd:. cluster waverage x1 x2 y1, measure(Gower)}

{pmore}
will yield the same results, and likewise with {cmd:mdsmat} and {cmd:mds}.
However, if any of the variables contain missing observations, this will not
be the case.  {cmd:cluster} and {cmd:mds} exclude all observations that have
missing values for any of the variables of interest, whereas {cmd:matrix}
{cmd:dissimilarity} with the {cmd:Gower} option does not. See 
{manhelp cluster MV}, {manhelp mds MV}, and
{manhelp matrix_dissimilarity MV:matrix dissimilarity} for more information.

{pmore}
Note: {helpb matrix dissimilarity} without the {cmd:Gower} option does exclude
all observations that have missing values for any of the variables of interest.


{marker references}{...}
{title:References}

{marker A1973}{...}
{phang}
Anderberg, M. R. 1973. {it:Cluster Analysis for Applications}
    New York: Academic Press.

{marker C1932}{...}
{phang}
Czekanowski, J. 1932. "Coefficient of racial likeness" und
  "durchschnittliche Differenz".
  {it:Anthropologischer Anzeiger} 9: 227-249.

{marker D1945}{...}
{phang}
Dice, L. R. 1945. Measures of the amount of ecologic associate between
   species. {it:Ecology} 26: 297-302.

{marker DK1932}{...}
{phang}
Driver, H. E., and A. L. Kroeber. 1932. Quantitative expression of cultural
  relationships. {it:University of California Publications in American}
  {it:Archaeology and Ethnology} 31: 211-256.

{marker G1884}{...}
{phang}
Gilbert, G. K. 1884. Finley's tornado predictions.
  {it:American Meteorological Journal} 1: 166-172.

{marker G1999}{...}
{phang}
Gordon, A. D. 1999. {it:Classification}. 2nd ed.
    Boca Raton, FL: Chapman & Hall/CRC.

{marker G1971}{...}
{phang}
Gower, J. C. 1971. A general coefficient of similarity and some of its
  properties. {it:Biometrics} 27: 857-871.

{marker G1985}{...}
{phang}
------. 1985. Measures of similarity, dissimilarity, and distance.
  In Vol. 5 of {it:Encyclopedia of Statistical Sciences}, ed.
  S. Kotz, N. L. Johnson, and C. B. Read, 397-405. New York: Wiley.

{marker H1961}{...}
{phang}
Hamann, U. 1961. Merkmalsbestand und Verwandtschaftsbeziehungen der Farinosae.
  Ein Beitrag zum System der Monokotyledonen.
  {it:Willdenowia} 2: 639-768.

{marker J1901}{...}
{phang}
Jaccard, P. 1901. Distribution de la flore alpine dans le Bassin des Dranses et
  dans quelques r{c e'}gions voisines.
  {it:Bulletin de la Soci{c e'}t{c e'} Vaudoise des Sciences Naturelles}
  37: 241-272.

{marker J1908}{...}
{phang}
------. 1908. Nouvelles recherches sur la distribution florale.
  {it:Bulletin de la Soci{c e'}t{c e'} Vaudoise des Sciences Naturelles}
  44: 223-270.

{marker K1927}{...}
{phang}
Kulczyński, S. 1927. Die Pflanzenassoziationen der Pieninen [In Polish,
   German summary]. {it:Bulletin International de l'Academie Polonaise des}
  {it:Sciences et des Lettres, Classe des Sciences Mathematiques et}
  {it: Naturelles, B (Sciences Naturelles)} Suppl. II: 57-203.

{marker O1957}{...}
{phang}
Ochiai, A. 1957. Zoogeographic studies on the soleoid fishes found in Japan
   and its neighbouring regions [in Japanese, English summary].
   {it:Bulletin of the Japanese Society of Scientific Fisheries}
   22: 526-530.

{marker P1900}{...}
{phang}
Pearson, K. 1900. Mathematical contributions to the theory of evolution -- VII.
  On the correlation of characters not quantitatively measurable.
  {it:Philosophical Transactions of the Royal Society of London, Series A}
  195: 1-47.

{marker RT1960}{...}
{phang}
Rogers, D. J., and T. T. Tanimoto. 1960. A computer program for classifying
  plants. {it:Science} 132: 1115-1118.

{marker RR1940}{...}
{phang}
Russell, P. F., and T. R. Rao. 1940. On habitat and association of species of
  anopheline larvae in south-eastern Madras. 
  {it:Journal of the Malaria Institute of India} 3: 153-178.

{marker SS1962}{...}
{phang}
Sneath, P. H. A., and R. R. Sokal. 1962. Numerical taxonomy.
  {it:Nature} 193: 855-860.

{marker SM1958}{...}
{phang}
Sokal, R. R., and C. D. Michener. 1958. 
  A statistical method for evaluating systematic relationships.
  {it:University of Kansas Science Bulletin} 28: 1409-1438.

{marker SS1963}{...}
{phang}
Sokal, R. R., and P. H. A. Sneath. 1963.
  {it:Principles of Numerical Taxonomy}. San Francisco: Freeman.

{marker S1948}{...}
{phang}
S{c o/}rensen, T. 1948. A method of establishing groups of equal amplitude in
  plant sociology based on similarity of species content and its application to
  analyses of the vegetation on Danish commons.
  {it:Royal Danish Academy of Sciences and Letters, Biological Series} 5: 1-34.

{marker Y1900}{...}
{phang}
Yule, G. U. 1900. On the association of attributes in statistics:
  With illustrations from the material of the Childhood Society, etc.
  {it:Philosophical Transactions of the Royal Society, Series A} 194:
  257-319.

{marker YK1950}{...}
{phang}
Yule, G. U., and M. G. Kendall. 1950.
{it:An Introduction to the Theory of Statistics}. 14th ed. New York: Hafner.

{marker Z1938}{...}
{phang}
Zubin, J. 1938. A technique for measuring like-mindedness.
  {it:Journal of Abnormal and Social Psychology} 33: 508-516.
{p_end}
