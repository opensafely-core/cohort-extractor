{smcl}
{* *! version 1.0.3  17feb2020}{...}
{viewerdialog "meta" "dialog meta"}{...}
{vieweralsosee "[META] meta forestplot" "mansection META metaforestplot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta data" "mansection META metadata"}{...}
{vieweralsosee "[META] meta summarize" "help meta summarize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta" "help meta"}{...}
{vieweralsosee "[META] Glossary" "help meta glossary"}{...}
{vieweralsosee "[META] Intro" "mansection META Intro"}{...}
{viewerjumpto "Syntax" "meta forestplot##syntax"}{...}
{viewerjumpto "Menu" "meta forestplot##menu"}{...}
{viewerjumpto "Description" "meta forestplot##description"}{...}
{viewerjumpto "Links to PDF documentation" "meta_forestplot##linkspdf"}{...}
{viewerjumpto "Options" "meta_forestplot##options"}{...}
{viewerjumpto "Examples" "meta_forestplot##examples"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[META] meta forestplot} {hline 2}}Forest plot{p_end}
{p2col:}({mansection META metaforestplot:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:meta} {cmdab:forest:plot} [{it:column_list}] {ifin}
[{cmd:,} {help meta_forestplot##optstbl:{it:options}}]

{phang}
{it:column_list} is a list of column names given by
{help meta_forestplot##col:{it:col}}.  In the 
{it:Meta-Analysis Control Panel}, the columns
can be specified on the {bf:Forest plot} tab of the Forest plot pane.

{marker optstbl}{...}
{synoptset 37 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt :{opt random}[{cmd:(}{help meta_summarize##remethod:{it:remethod}}{cmd:)}]}random-effects meta-analysis{p_end}
{synopt :{opt common}[{cmd:(}{help meta_summarize##cefemethod:{it:cefemethod}}{cmd:)}]}common-effect meta-analysis{p_end}
{synopt :{opt fixed}[{cmd:(}{help meta_summarize##cefemethod:{it:cefemethod}}{cmd:)}]}fixed-effects meta-analysis{p_end}
{synopt :{help meta_summarize##reopts:{it:reopts}}}random-effects model options{p_end}
{synopt :{opth subgr:oup(varlist)}}subgroup meta-analysis for each variable in {it:varlist}{p_end}
{synopt :{opth cumul:ative(meta_summarize##cumulspec:cumulspec)}}cumulative meta-analysis{p_end}
{synopt :{cmd:sort(}{help meta_summarize##sortspec:{it:varlist}[{bf:,} ...]}{cmd:)}}sort studies according to
{it:varlist}{p_end}

{syntab:Options}
{synopt :{opt l:evel(#)}}set confidence level; default is as declared for meta-analysis{p_end}
{synopt :{help meta_summarize##eform_option:{it:eform_option}}}report exponentiated results{p_end}
INCLUDE help meta_transfopt
{synopt :{opt tdist:ribution}}report t test instead of z test{p_end}
{synopt :[{cmd:no}]{opt metashow}}display or suppress meta settings in the output{p_end}

{syntab:Maximization}
{synopt :{help meta_forestplot##maxopts:{it:maximize_options}}}control the maximization process; seldom used{p_end}

{syntab:Forest plot}
{synopt :{cmdab:col:umnopts(}{help meta_forestplot##col:{it:col}}{cmd:,} [{help meta_forestplot##colopts:{it:colopts}}]{cmd:)}}column options; can be repeated{p_end}
{synopt :{opth cibind:(meta_forestplot##cibind:bind)}}change binding of CIs for columns {cmd:_esci} and {cmd:_ci}; default is {cmd:cibind(brackets)}{p_end}
{synopt :{opth sebind:(meta_forestplot##sebind:bind)}}change binding of standard errors for column {cmd:_esse}; default is {cmd:sebind(parentheses)}{p_end}
{synopt :{opt nohrule}}suppress horizontal rule{p_end}
{synopt :{opth hrule:opts(meta_forestplot##hruleopts:hrule_options)}}change look of horizontal rule{p_end}
{synopt :{help meta_forestplot##textopts:{it:text_options}}}change looks of text options such as column titles, supertitles, and more{p_end}
{synopt :{help meta_forestplot##plotopts:{it:plot_options}}}change look or suppress markers, restrict range of CIs, and more{p_end}
{synopt :{help meta_forestplot##testopts:{it:test_options}}}suppress information about heterogeneity statistics and tests{p_end}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in {helpb twoway_options:[G-3] twoway options}{p_end}
{synoptline}

{marker col}{...}
{synopthdr:col}
{synoptline}
{syntab:Default columns and order}
{synopt :{cmd:_id}}study label{p_end}
{synopt :{cmd:_data}}summary data; {cmd:_data1} and {cmd:_data2} (only after {cmd:meta esize}){p_end}
{synopt :{cmd:_plot}}forest graph{p_end}
{synopt :{cmd:_esci}}effect size and its confidence interval{p_end}
{synopt :{cmd:_weight}}percentage of total weight given to each study{p_end}

{syntab:Summary-data columns and order}
{syntab:{space 1}Continuous outcomes}
{syntab:{space 2}Treatment group}
{synopt :{cmd:_data1}}summary data for treatment group; {cmd:_n1}, {cmd:_mean1}, and {cmd:_sd1}{p_end}
{synopt :{cmd:_n1}}sample size in the treatment group{p_end}
{synopt :{cmd:_mean1}}mean in the treatment group{p_end}
{synopt :{cmd:_sd1}}standard deviation in the treatment group{p_end}

{syntab:{space 2}Control group}
{synopt :{cmd:_data2}}summary data for control group; {cmd:_n2}, {cmd:_mean2},
and {cmd:_sd2}{p_end}
{synopt :{cmd:_n2}}sample size in the control group{p_end}
{synopt :{cmd:_mean2}}mean in the control group{p_end}
{synopt :{cmd:_sd2}}standard deviation in the control group{p_end}

{syntab:{space 1}Dichotomous outcomes}
{syntab:{space 2}Treatment group}
{synopt :{cmd:_data1}}summary data for treatment group; {cmd:_a} and {cmd:_b}{p_end}
{synopt :{cmd:_a}}number of successes in the treatment group{p_end}
{synopt :{cmd:_b}}number of failures in the treatment group{p_end}

{syntab:{space 2}Control group}
{synopt :{cmd:_data2}}summary data for control group; {cmd:_c} and {cmd:_d}{p_end}
{synopt :{cmd:_c}}number of successes in the control group{p_end}
{synopt :{cmd:_d}}number of failures in the control group{p_end}

{syntab:Other columns}
{synopt :{cmd:_es}}effect size{p_end}
{synopt :{cmd:_ci}}confidence interval for effect size{p_end}
{synopt :{cmd:_lb}}lower confidence limit for effect size{p_end}
{synopt :{cmd:_ub}}upper confidence limit for effect size{p_end}
{synopt :{cmd:_se}}standard error of effect size{p_end}
{synopt :{cmd:_esse}}effect size and its standard error{p_end}
{synopt :{cmd:_pvalue}}p-value for significance test with {cmd:subgroup()} or {cmd:cumulative()}{p_end}
{synopt :{cmd:_K}}number of studies with {cmd:subgroup()}{p_end}
{synopt :{cmd:_order}}order variable for cumulative meta-analysis with {cmd:cumulative()}{p_end}
{synopt :{it:varname}}variable in the dataset (except meta system variables)
{p_end}
{synoptline}
{p 4 6 2}
Columns {cmd:_data}, {cmd:_data1}, {cmd:_data2}, and the other corresponding
data columns are not available after the declaration by using
{helpb meta set}.{p_end}
{p 4 6 2}
Columns {cmd:_n1}, {cmd:_mean1}, {cmd:_sd1}, {cmd:_n2}, {cmd:_mean2}, and
{cmd:_sd2} are available only after the declaration by using
{helpb meta esize} for continuous outcomes.{p_end}
{p 4 6 2}
Columns {cmd:_a}, {cmd:_b}, {cmd:_c}, and {cmd:_d} are available only after
the declaration by using {helpb meta esize} for binary outcomes.{p_end}
{p 4 6 2}
Column {cmd:_pvalue} is available only when option {cmd:cumulative()} or
{cmd:subgroup()} with multiple variables is specified.{p_end}
{p 4 6 2}
Column {cmd:_K} is available only when option {cmd:subgroup()} with multiple
variables is specified.{p_end}
{p 4 6 2}
Column {it:varname} is not available when option {cmd:subgroup()} with
multiple variables is specified.{p_end}

{synoptset 37}{...}
{marker colopts}{...}
{synopthdr:colopts}
{synoptline}
{synopt :{opth superti:tle(strings:string)}}super title specification{p_end}
{synopt :{opth ti:tle(strings:string)}}title specification{p_end}
{synopt :{opth format:(%fmt)}}numerical format for column items{p_end}
{synopt :{opth mask:(meta_forestplot##mask:mask)}}string mask for column items{p_end}
{synopt :{opth plotr:egion(meta_forestplot##regionopts:region_options)}}attributes of plot region{p_end}
{synopt :{help meta_forestplot##textboxopts:{it:textbox_options}}}appearance of textboxes{p_end}
{synoptline}

{marker textopts}{...}
{synopthdr:text_options}
{synoptline}
{synopt :{opth colti:tleopts(textbox_options)}}change look of column titles and supertitles{p_end}
{synopt :{opth item:opts(textbox_options)}}change look of study rows{p_end}
{synopt :{opth overall:opts(textbox_options)}}change look of the overall row{p_end}
{synopt :{opth group:opts(textbox_options)}}change look of subgroup rows{p_end}
{synopt :{opth body:opts(textbox_options)}}change look of study, subgroup, and overall rows{p_end}
{synopt :{opt nonotes}}suppress notes about the meta-analysis model, method, and more{p_end}
{synoptline}

{marker plotopts}{...}
{synopthdr:plot_options}
{synoptline}
{synopt :{opt crop(# #)}}restrict the range of CI lines{p_end}
{synopt :{opth ciop:ts(meta_forestplot##ciopts:ci_options)}}change look of CI lines (size, color, etc.){p_end}
{synopt :{opt nowmark:ers}}suppress weighting of study markers{p_end}
{synopt :{opt nomark:ers}}suppress study markers{p_end}
{synopt :{opth mark:eropts(meta_forestplot##markeropts:marker_options)}}change look of study markers (size, color, etc.){p_end}
{synopt :{opt noomark:er}}suppress the overall marker{p_end}
{synopt :{opth omark:eropts(meta_forestplot##omarkeropts:marker_options)}}change look of the overall marker (size, color, etc.){p_end}
{synopt :{opt nogmark:ers}}suppress subgroup markers{p_end}
{synopt :{opth gmark:eropts(meta_forestplot##gmarkeropts:marker_options)}}change look of subgroup markers (size, color, etc.){p_end}
{synopt :{opt insidemark:er}[{cmd:(}{help meta_forestplot##gmarkeropts:{it:marker_options}}{cmd:)}]}add a marker at the center of the study marker{p_end}
{synopt :{opt esref:line}[{cmd:(}{it:{help line_options}}{cmd:)}]}add a vertical line corresponding to the overall effect size{p_end}
{synopt :{opt nullref:line}[{cmd:(}{it:{help meta_forestplot##nullopts:nullopts}}{cmd:)}]}add a vertical line corresponding to no effect{p_end}
{synopt :{opt customover:all}{cmd:(}{help meta forestplot##customspec:{it:customspec}}{cmd:)}}add a custom diamond representing an overall effect; can be repeated{p_end}
{synoptline}

{marker testopts}{...}
{synopthdr:test_options}
{synoptline}
{synopt :{opt noohet:stats}}suppress overall heterogeneity statistics{p_end}
{synopt :{opt noohom:test}}suppress overall homogeneity test{p_end}
{synopt :{opt noosig:test}}suppress test of significance of overall effect size{p_end}
{synopt :{opt noghet:stats}}suppress subgroup heterogeneity statistics{p_end}
{synopt :{opt nogwhom:tests}}suppress within-subgroup homogeneity tests{p_end}
{synopt :{opt nogbhom:tests}}suppress between-subgroup homogeneity tests{p_end}
{synoptline}

{marker nullopts}{...}
{synopthdr:nullopts}
{synoptline}
{synopt :{opt favorsl:eft}{cmd:(}{it:{help strings:string}}[{cmd:,} {it:{help textbox_options}}]{cmd:)}}add a label to the left of the no-effect reference line{p_end}
{synopt :{opt favorsr:ight}{cmd:(}{it:{help strings:string}}[{cmd:,} {it:{help textbox_options}}]{cmd:)}}add a label to the right of the no-effect reference line{p_end}
{synopt :{it:{help line_options}}}affect the rendition of the no-effect reference line{p_end}
{synoptline}


INCLUDE help menu_meta


{marker description}{...}
{title:Description}

{pstd}
{cmd:meta forestplot} summarizes
{help meta_glossary##meta_data:{bf:meta} data} in a graphical format.  It
reports individual effect sizes and the overall effect size (ES), their
confidence intervals (CIs), heterogeneity statistics, and more.
{cmd:meta forestplot} can perform random-effects (RE), common-effect (CE), and
fixed-effects (FE) meta-analyses.  It can also perform subgroup, cumulative,
and sensitivity meta-analyses.  For tabular display of meta-analysis summaries,
see {helpb meta summarize:[META] meta summarize}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection META metaforestplotQuickstart:Quick start}

        {mansection META metaforestplotRemarksandexamples:Remarks and examples}

        {mansection META metaforestplotMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:random}[{cmd:(}{help meta_summarize##remethod:{it:remethod}}{cmd:)}],
{cmd:common}[{cmd:(}{help meta_summarize##cefemethod:{it:cefemethod}}{cmd:)}],
{cmd:fixed}[{cmd:(}{help meta_summarize##cefemethod:{it:cefemethod}}{cmd:)}],
{opth subgroup(varlist)},
{opth cumulative:(meta_summarize##cumulspec:cumulspec)}, and
{cmd:sort(}{help meta_summarize##sortspec:{it:varlist}[{bf:,} ...]}{cmd:)};
see {help meta_summarize##options:{it:Options}}
in {helpb meta_summarize:[META] meta summarize}.

{phang}
{it:reopts} are {opt tau2(#)}, {opt i2(#)}, {opt predinterval},
{cmd:predinterval(}{it:#}[{cmd:,} {it:{help line_options}}]{cmd:)}, and
{opth se:(meta_summarize##seadj:seadj)}.  These options are used with
random-effects meta-analysis.  See {help meta_summarize##options:{it:Options}}
in {helpb meta_summarize:[META] meta summarize}.

{pmore}
{cmd:predinterval} and
{cmd:predinterval(}{it:#}[{cmd:,} {it:line_options}]{cmd:)} draw
whiskers extending from the overall effect marker and spanning the width of
the prediction interval. {it:line_options} affect how the whiskers are
rendered; see {manhelpi line_options G-3}.

{dlgtab:Options}
 
{marker eform}{...}
{phang}
{opt level(#)}, {help meta_summarize##eform_option:{it:eform_option}},
{opt transform()}, {opt tdistribution}, and [{cmd:no}]{opt metashow}; see
{help meta_summarize##options:{it:Options}}
in {helpb meta_summarize:[META] meta summarize}.

{dlgtab:Maximization}
 
{marker maxopts}{...}
{phang} 
{it:maximize_options}: {opt iterate(#)}, {opt tolerance(#)},
{opt nrtolerance(#)}, {opt nonrtolerance}, {opt from(#)},
and {opt showtrace}; see
{help meta_summarize##options:{it:Options}}
in {helpb meta_summarize:[META] meta summarize}.

{dlgtab:Forest plot}
 
{phang}
{cmd:columnopts(}{help meta_forestplot##col:{it:col}}[{cmd:,} {it:colopts}]{cmd:)}
changes the look of the column identified by {it:col}.  This option can be
repeated.

{pmore}
{it:colopts} are the following options:

{phang3}
{opth supertitle:(strings:string)} specifies that the column's supertitle is
{it:string}.

{phang3}
{opth title:(strings:string)} specifies that the column's title is {it:string}.

{phang3}
{opth format(%fmt)} specifies the format for the column's numerical values.

{marker mask}{...}
{phang3}
{opt mask(mask)} specifies a string composed of formats for the column's
statistics.  For example, {it:mask} for column {cmd:_weight} that identifies
the column of weight percentages may be specified as {cmd:"%6.2f %%"}.

{marker regionopts}{...}
{phang3}
{opt plotregion(region_options)} modifies attributes for the plot region.
You can change the margins, background color, an outline, and so on; see
{manhelpi region_options G-3:region_options}.

{marker textboxopts}{...}
{phang3}
{it:textbox_options} affect how the columns items (study and group) are
rendered.  These options override what is specified in global options
{cmd:bodyopts()}, {cmd:itemopts()}, and {cmd:groupopts()}.  See
{manhelpi textbox_options G-3:textbox_options}.

{pmore3}
Options {cmd:format()}, {cmd:mask()}, and {it:textbox_options} are ignored by
{cmd:_plot}.

{marker cibind}{...}
{phang}
{opt cibind(bind)} changes the binding of the CIs for columns {cmd:_esci} and
{cmd:_ci}.  {it:bind} is one of {cmd:brackets} or {cmdab:parent:heses}.  By
default, the CIs are bound by using brackets, {cmd:cibind(brackets)}.  This
option is relevant only when {cmd:_esci} or {cmd:_ci} appears in the plot.

{marker sebind}{...}
{phang}
{opt sebind(bind)} changes the binding of the standard errors for column
{cmd:_esse}.  {it:bind} is one of {cmdab:parent:heses} or {cmd:brackets}.  By
default, the standard errors are bound by using parentheses,
{cmd:cibind(parentheses)}.  This option is relevant only when {cmd:_esse}
appears in the plot.

{phang}
{cmd:nohrule} suppresses the horizontal rule.

{marker hruleopts}{...}
{phang}
{opt hruleopts(hrule_options)} affects the look of the horizontal rule.

{pmore}
{it:hrule_options} are the following options:

{phang3}
{opt lc:olor(colorstyle)} specifies the color of the rule; see
{manhelpi colorstyle G-4}.

{phang3}
{opt lw:idth(linewidthstyle)} specifies the width of the rule; see
{manhelpi linewidthstyle G-4}.

{phang3}
{opt la:lign(linealignmentstyle)} specifies the alignment of the rule; see
{manhelpi linealignmentstyle G-4}.

{phang3}
{opt lp:attern(linepatternstyle)} specifies the line pattern of the rule; see
{manhelpi linepatternstyle G-4}.

{phang3}
{opt lsty:le(linestyle)} specifies the overall style of the rule; see
{manhelpi linestyle G-4}.

{phang3}
{opt m:argin(marginstyle)} specifies the margin of the rule; see
{manhelpi marginstyle G-4}.

{phang}
{it:text_options} are the following options:

{phang2}
{opt coltitleopts(textbox_options)} affects the look of text for column titles
and supertitles.  See {manhelpi textbox_options G-3}.

{phang2}
{opt itemopts(textbox_options)} affects the look of text for study rows; see
{manhelpi textbox_options G-3}.  This option is ignored when option
{cmd:subgroup()} is specified and contains multiple variables or when option
{cmd:cumulative()} is specified.

{phang2}
{opt overallopts(textbox_options)} affects the look of text for the overall
row.  See {manhelpi textbox_options G-3}.

{phang2}
{opt groupopts(textbox_options)} (synonym {cmd:subgroupopts()}) affects the
look of text for subgroup rows when option {cmd:subgroup()} is specified.  See
{manhelpi textbox_options G-3}.

{phang2}
{opt bodyopts(textbox_options)} affects the look of text for study, subgroup,
and overall rows.  See {manhelp textbox_options G-3}.

{phang2}
{opt nonotes} suppresses the notes displayed on the graph about the specified
meta-analysis model and method and the standard-error adjustment.

{phang}
{it:plot_options} are the following options:

{phang2}
{opt crop(#1 #2)} restricts the range of the CI lines to be between {it:#1} and
{it:#2}.  A missing value may be specified for any of the two values to
indicate that the corresponding limit should not be cropped.  Otherwise, lines
that extend beyond the specified value range are cropped and adorned with
arrows.  This option is useful in the presence of small studies with large
standard errors, which lead to confidence intervals that are too wide to be
displayed nicely on the graph.  Option {cmd:crop()} may be used to handle this
case.

{marker ciopts}{...}
{phang2}
{opt ciopts(ci_options)} affects the look of the CI lines and, in the presence
of cropped CIs (see option {cmd:crop()}), arrowheads.

{phang3}
{it:ci_options} are any options documented in {manhelpi line_options G-3} and
the following options of {helpb twoway_pcarrow:[G-2] graph twoway pcarrow}:
{cmdab:msty:le()}, {cmdab:msiz:e()}, {cmdab:mang:le()}, {cmdab:barb:size()},
{cmdab:mc:olor()}, {cmdab:mfc:olor()}, {cmdab:mlc:olor()}, {cmdab:mlw:idth()},
{cmdab:mlsty:le()}, and {cmdab:col:or()}.

{phang2}
{opt nowmarkers} suppresses weighting of the study markers.

{phang2}
{cmd:nomarkers} suppresses the study markers.

{marker markeropts}{...}
{phang2}
{opt markeropts(marker_options)} affects the look of the study markers.

{phang3}
{it:marker_options}: {cmdab:m:symbol()},
{cmdab:mc:olor()}, {cmdab:mfc:olor()},
{cmdab:mlc:olor()}, {cmdab:mlw:idth()}, {cmdab:mla:lign()},
{cmdab:mlsty:le()}, and {cmdab:msty:le()}; see {manhelpi marker_options G-3}.

{pmore}
{opt nowmarkers}, {opt nomarkers}, and {opt markeropts()} are ignored when
option {cmd:subgroup()} is specified and contains multiple variables or when
option {cmd:cumulative()} is specified.

{phang2}
{opt noomarker} suppresses the overall marker.

{marker omarkeropts}{...}
{phang2}
{opt omarkeropts(marker_options)} affects the look of the overall marker.

{phang3}
{it:marker_options}: {cmdab:mc:olor()}, {cmdab:mfc:olor()},
{cmdab:mlc:olor()}, {cmdab:mlw:idth()}, {cmdab:mla:lign()},
{cmdab:mlsty:le()}, and {cmdab:msty:le()}; see {manhelpi marker_options G-3}.

{phang2}
{opt nogmarkers} suppresses the subgroup markers.

{marker gmarkeropts}{...}
{phang2}
{opt gmarkeropts(marker_options)} affects the look of the subgroup markers.

{phang3}
{it:marker_options}: {cmdab:mc:olor()}, {cmdab:mfc:olor()},
{cmdab:mlc:olor()}, {cmdab:mlw:idth()}, {cmdab:mla:lign()},
{cmdab:mlsty:le()}, and {cmdab:msty:le()}; see {manhelpi marker_options G-3}.

{pmore2}
{opt nogmarkers} and {opt gmarkeropts()} are ignored when option
{cmd:subgroup()} is not specified.

{marker insidemarker}{...}
{phang2}
{cmd:insidemarker} and {opt insidemarker(marker_options)} add markers
at the center of study markers. {it:marker_options} control how the
added markers are rendered.

{phang3}
{it:marker_options}:
{opt m:symbol()},
{opt mc:olor()},
{opt mfc:olor()},
{opt mlc:olor()},
{opt mlw:idth()},
{opt mla:lign()},
{opt mlsty:le()}, and
{opt msty:le()}; see {manhelpi marker_options G-3}.

{pmore2}
{cmd:insidemarker()} is not allowed when option {cmd:subgroup()} is specified
and contains multiple variables or when option {cmd:cumulative()} is
specified.

{phang2}
{opt esrefline} and {opt esrefline(line_options)} specify
that a vertical line be drawn at the value corresponding to the overall effect
size. The optional {it:line_options} control how the line is rendered; see
{manhelpi line_options G-3}.

{phang2}
{opt nullrefline} and {opt nullrefline(nullopts)} specify
that a vertical line be drawn at the value corresponding to no overall effect.
{it:nullopts} are the following options:

{phang3}
{cmd:favorsleft(}{it:{help strings:string}}[{cmd:,} {it:textbox_options}]{cmd:)}
adds a label, {it:string}, to the left side (with respect to the no-effect
line) of the forest graph.  {it:textbox_options} affect how {it:string} is
rendered; see {manhelpi textbox_options G-3}.

{phang3}
{cmd:favorsright(}{it:{help strings:string}}[{cmd:,} {it:textbox_options}]{cmd:)}
adds a label, {it:string}, to the right side (with respect to the no-effect
line) of the forest graph.  {it:textbox_options} affect how {it:string} is
rendered; see {manhelp textbox_options G-3}.

{pmore3}
{cmd:favorsleft()} and {cmd:favorsright()} are typically used to
annotate the sides of the forest graph (column {cmd:_plot}) favoring the
treatment or control.

{phang3}
{it:line_options} affect the rendition of the vertical line;
see {manhelpi line_options G-3}.

{marker customspec}{...}
{phang2}
{opt customoverall(customspec)} draws a custom-defined diamond
representing an overall effect size. This option can be repeated.
{it:customspec} is {it:#}{it:es} {it:#}{it:lb} {it:#}{it:ub}
[{cmd:,} {it:customopts}], where {it:#}{it:es}, {it:#}{it:lb}, and
{it:#}{it:ub} correspond to an overall effect-size estimate and its lower and
upper CI limits, respectively. {it:customopts} are the following options:

{phang3}
{opth lab:el(strings:string)} adds a label, {it:string}, under the {cmd:_id}
column describing the custom diamond.

{phang3}
{it:textbox_options} affect how {opt label(string)} is rendered; see
{manhelpi textbox_options G-3}.

{phang3}
{it:marker_options} affect how the custom diamond is rendered.
{it:marker_options} are
{opt mc:olor()},
{opt mfc:olor()},
{opt mlc:olor()},
{opt mlw:idth()},
{opt mla:lign()},
{opt mlsty:le()}, and
{opt msty:le()}; see {manhelpi marker_options G-3}.

{pmore2}
Option {cmd:customoverall()} may not be combined with option
{cmd:cumulative()}.

{phang}
{it:test_options} are defined below.  These options are not relevant with
cumulative meta-analysis.

{phang2}
{opt noohetstats} suppresses overall heterogeneity statistics reported under
the {cmd:Overall} row heading on the plot.

{phang2}
{opt noohomtest} suppresses the overall homogeneity test labeled as
{cmd:Test of θi=θj} under the {cmd:Overall} row heading on the plot.

{phang2}
{opt noosigtest} suppresses the test of significance of the overall effect
size labeled as {cmd:Test of θ=0} under the {cmd:Overall} row heading on the
plot.  This test is not reported with subgroup analyses, and thus this option
is implied when option {cmd:subgroup()} is specified.

{phang2}
{opt noghetstats} suppresses subgroup heterogeneity statistics reported when a
single subgroup analysis is performed, that is, when option {cmd:subgroup()}
is specified with one variable.  These statistics are reported under the
group-specific row headings.

{phang2}
{opt nogwhomtests} suppresses within-subgroup homogeneity tests.  These tests
investigate the differences between effect sizes of studies within each
subgroup.  These tests are reported when a single subgroup analysis is
performed, that is, when option {opt subgroup()} is specified with one
variable.  The tests are labeled as {cmd:Test of θi=θj} under the
group-specific row headings.

{phang2}
{opt nogbhomtests} suppresses between-subgroup homogeneity tests reported when
any subgroup analysis is performed, that is, when option {cmd:subgroup()} is
specified.  These tests investigate the differences between the subgroup
overall effect sizes and are labeled as {cmd:Test of group differences} on the
plot.

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3:twoway_options},
excluding {cmd:by()}.  These include options for titling the graph
(see {manhelpi title_options G-3}) and for saving the graph to
disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse bcgset}{p_end}

{pstd}{bf:{ul:Basic forest plot}}

{pmore}Construct a forest plot{p_end}
{phang2}{cmd:. meta forestplot}

{pstd}{bf:{ul: Overall effect-size and no-effect lines}}

{pmore}Construct a forest plot with vertical lines drawn at the overall
effect-size value and the null value corresponding to no effect{p_end}
{phang2}{cmd:. meta forestplot, esrefline nullrefline}

{pstd}{bf:{ul:Prediction interval}}

{pmore}Construct a basic forest plot, and draw the prediction interval for the
overall effect size{p_end}
{phang2}{cmd:. meta forestplot, predinterval}

{pstd}{bf:{ul:Subgroup forest plot}}

{pmore}Construct a subgroup MA forest plot based on variable {cmd:alloc}, and
request risk ratios instead of the default log risk-ratios{p_end}
{phang2}{cmd:. meta forestplot, subgroup(alloc) rr}

{pstd}{bf:{ul:Cumulative forest plot}}

{pmore}Construct a CMA forest plot based on the order of variable
{cmd:latitude}, and request risk ratios{p_end}
{phang2}{cmd:. meta forestplot, cumulative(latitude) rr}
{p_end}

{pstd}{bf:{ul: Stratified cumulative forest plot of vaccine efficacies}}

{pmore}As above, but stratify the cumulative analysis by the variable
{cmd:alloc}, and report vaccine efficacies{p_end}
{phang2}{cmd:. meta forestplot, cumulative(latitude, by(alloc)) transform(efficacy)}
{p_end}

{pstd}{bf:{ul:Custom columns and cropped CIs}}

{pmore}Create a forest plot with the specified columns in the specified
order, and restrict the range of the CIs at a lower limit of -2{p_end}
{phang2}{cmd:. meta forestplot _id _esci _weight _plot, crop(-2 .)}

{pstd}{bf:{ul:Add your own columns}}

{pmore}Create a forest plot with the specified columns in the specified
order, and also add variable {cmd:latitude} to the forest plot as another
column titled "Latitude"{p_end}
{phang2}{cmd:. meta forestplot _id _esci _weight _plot latitude, columnopts(latitude, title("Latitude"))}

{pstd}{bf:{ul:Add custom overall effect sizes}}

{pmore}As above, and display overall effect sizes at the specified latitudes on the forest plot{p_end}
{phang2}{cmd:. meta forestplot _id _esci _weight _plot latitude, columnopts(latitude, title("Latitude"))}
	{cmd:nullrefline customoverall(-.184 -.495 .127, label("{bf:latitude = 15}"))}
	{cmd:customoverall(-.562 -.776 -.348, label("{bf:latitude = 28}"))}
	{cmd:customoverall(-1.20 -1.54 -.867, label("{bf:latitude = 50}")) rr}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse streptoset}

{pstd}{bf:{ul:Graph odds ratios}}

{pmore}Construct a forest plot with odds ratios instead of the default log
odds-ratios, and draw a vertical line corresponding to no effect{p_end}
{phang2}{cmd:. meta forestplot, or nullrefline}

{pstd}{bf:{ul:Sides favoring control or treatment}}

{pmore}As above, and annotate the sides (with respect to the no-effect line) of
the plot favoring streptokinase or the placebo{p_end}
{phang2}{cmd:. meta forestplot, or nullrefline(favorsleft("Favors streptokinase") favorsright("Favors placebo")) }

{pstd}{bf:{ul:Changing columns' supertitles}}

{pmore}Override the supertitle for the {cmd:_data1} column to display
"Streptokinase"{p_end}
{phang2}{cmd:. meta forestplot, columnopts(_data1, supertitle(Streptokinase))}

{pstd}{bf:{ul:Changing columns' formatting}}

{pmore}Display the CIs with three decimal digits, and use parentheses to bind
the CIs{p_end}
{phang2}{cmd:. meta forestplot, columnopts(_esci, format(%6.3f)) cibind(parentheses)}

    {hline}
