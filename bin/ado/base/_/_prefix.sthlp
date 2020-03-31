{smcl}
{* *! version 1.1.6  11jan2017}{...}
{* NOTE: the following are not yet "undocumented"}{...}
{* _prefix_check4esample}{...}
{* _prefix_checkopt}{...}
{* _prefix_display}{...}
{* _prefix_footnote}{...}
{* _prefix_getchars}{...}
{* _prefix_getmat}{...}
{* _prefix_legend}{...}
{* _prefix_mlogit}{...}
{* _prefix_model_test}{...}
{* _prefix_note}{...}
{* _prefix_reject}{...}
{* _prefix_relabel_eqns}{...}
{* _prefix_run_error}{...}
{* _prefix_saving}{...}
{* _prefix_title}{...}
{* _prefix_vcenotallowed}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _on_colon_parse" "help _on_colon_parse"}{...}
{vieweralsosee "[R] bootstrap" "help bootstrap"}{...}
{vieweralsosee "[R] jackknife" "help jackknife"}{...}
{vieweralsosee "[R] permute" "help permute"}{...}
{vieweralsosee "[R] nestreg" "help nestreg"}{...}
{vieweralsosee "[TS] rolling" "help rolling"}{...}
{vieweralsosee "[R] simulate" "help simulate"}{...}
{vieweralsosee "[D] statsby" "help statsby"}{...}
{vieweralsosee "[R] stepwise" "help stepwise"}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{viewerjumpto "Description" "_prefix##description"}{...}
{viewerjumpto "Remarks" "_prefix##remarks"}{...}
{title:Title}

{p2colset 5 20 22 2}{...}
{p2col:{hi:[P] _prefix} {hline 2}}Overview of subroutines for parsing
     {it:prefix} commands{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Stata has a suite of {help prefix} commands.  This entry describes some of the
subroutines that are used by the following prefix commands.

{* do not add -bayes- or -fmm- to the list.*}{...}
{pmore}
{helpb bootstrap},
{helpb jackknife},
{helpb permute},
{helpb nestreg},
{helpb rolling},
{helpb simulate},
{helpb statsby},
{helpb stepwise},
{helpb svy}


{marker remarks}{...}
{title:Remarks}

{phang}
Remarks are presented under the following headings:

	{help _on_colon_parse:Splitting text on the colon character}
	{help _prefix##_prefix_clear:Clearing e() and r()}
	{help _prefix##_prefix_command:Parsing a user supplied command}
	{help _prefix##_prefix_explist:Parsing a list of expressions}
	{help _prefix##_prefix_expand:Expanding and evaluating expression lists}


{title:Splitting text on the colon character}

{pstd}
See {helpb _on_colon_parse}.


{marker _prefix_clear}{...}
{title:Clearing e() and r()}

{pstd}
Use {cmd:_prefix_clear} to clear the contents of {cmd:e()}, {cmd:r()} or both.

{phang2}
{cmd:_prefix_clear} [{cmd:,} {opt e:class} {opt r:class}]

{phang}
{opt eclass} clears the {cmd:e()} stored results.

{phang}
{opt rclass} clears the {cmd:r()} stored results.

{phang}
If neither option is specified, the stored results in {cmd:e()} and {cmd:r()}
remain.


{marker _prefix_command}{...}
{title:Parsing a user supplied command}

{pstd}
Use {cmd:_prefix_command} to parse the contents of {it:command}, which should
follow {help language:standard Stata syntax}.  {it:caller} should be the name
of the routine calling {cmd:_prefix_command} and will be used in error
messages.

{phang2}
{cmd:_prefix_command} {it:caller} {ifin} {weight}
	[{cmd:,}
		{opt svy}
		{opt norest}
		{opt checkcl:uster}
		{opt checkvce}
		{opt cl:uster(varlist)}
		{opt l:evel(#)}
		{opt COEF}
		{it:{help eform_option}}
	] {cmd::} {it:command}

{pstd}
{it:command} can contain calls to {helpb version}, {helpb capture},
{helpb noisily}, and {helpb quietly}; although {cmd:capture}, {cmd:noisily},
and {cmd:quietly} are removed with a note.  {it:command} cannot have calls to
{helpb by} or {helpb xi}.
{it:command} is assumed to have some of or all the following syntax elements:

{phang2}
{it:cmd_name} [{it:anything}]
	[{it:{help if:cmd_if}}]
	[{it:{help in:cmd_in}}]
	[{it:{help weight:cmd_weight}}]
	{bind:[{cmd:,} {it:cmd_options}]}
	{bind:[{cmd::} {it:rest}]}

{pstd}
{cmd:_prefix_parse} checks for conflicts between {cmd:if}, {cmd:in}, and
{it:weight} when they are also specified in {it:command}.

{phang}
{opt svy} specifies that weights are not allowed.

{phang}
{opt norest} specifies that "[{cmd::} {it:rest}]" is not allowed in
{it:command}.

{phang}
{opt checkcluster} specifies that the {it:varlist} from the {opt cluster()}
option must be returned in {cmd:s(cluster)} even if {opt cluster()} is not
specified as an option of {cmd:_prefix_command} but is specified in
{it:cmd_options}.

{phang}
{opt level(#)} is the standard Stata {opt level()} option.
{cmd:_prefix_command} checks for conflicts when the {opt level()} option is
also specified in {it:cmd_options}.

{phang}
{opt coef} is the anti-{it:eform_option} of {helpb logistic}.
{cmd:_prefix_command} checks for conflicts with {it:eform_option}, and also
checks if the corresponding options are specified in {it:cmd_options}.

{phang}
{it:eform_option} is one of the options documented in
{manhelpi eform_option R}.
{cmd:_prefix_command} checks for conflicts when {it:eform_option} is 
also specified in {it:cmd_options}.

{pstd}
{cmd:_prefix_command} stores the following in {cmd:s()}:

{pstd}Macros:{p_end}

{p2colset 9 24 28 2}{...}
{p2col: {bf:s(version)}}{cmd:version}
	prefix for use with {it:command}{p_end}
{p2col: {bf:s(cmdname)}}{it:cmd_name}{p_end}
{p2col: {bf:s(anything)}}{it:anything}{p_end}
{p2col: {bf:s(wtype)}}type of weight, if weights specified{p_end}
{p2col: {bf:s(wexp)}}weight expression, if weights specified{p_end}
{p2col: {bf:s(wgt)}}[{it:weight}], if weights specified{p_end}
{p2col: {bf:s(if)}}[{it:if}] restriction{p_end}
{p2col: {bf:s(in)}}[{it:in}] restriction{p_end}
{p2col: {bf:s(rest)}}{cmd::} {it:rest}, if {it:rest} specified{p_end}
{p2col: {bf:s(efopt)}}{it:eform_option}{p_end}
{p2col: {bf:s(eform)}}{opt eform()} equivalent of {it:eform_option}{p_end}
{p2col: {bf:s(level)}}{it:#} from {opt level(#)} option{p_end}
{p2col: {bf:s(cluster)}}{it:varlist} from {opt cluster()} option{p_end}
{p2col: {bf:s(options)}}{it:cmd_options}{p_end}
{p2col: {bf:s(vce)}}{it:vcetype}
	from {opt vce(vcetype)} option if {opt checkvce} specified{p_end}
{p2col: {bf:s(command)}}{it:command},
	possibly with some options removed{p_end}


{marker _prefix_explist}{...}
{title:Parsing a list of expressions}

{pstd}
Use {cmd:_prefix_explist} as the first step in the two-step process of parsing
an {it:{help exp_list}}.  {it:exp_list} identifies the grammar for lists of
expressions that are specifically used by prefix commands that allow them.

{phang2}
{cmd:_prefix_explist} [{it:{help exp_list}}]
	{cmd:,}
	{opt stub(name)}
	[
		{opt geq:name(name)}
		{opt default}
		{opt edef:aultonly}
	]

{phang}
{opt stub(name)} specifies the {it:stub} used to generate default names used to
identify the individual expressions in {it:exp_list}.  If {cmd:stub(myexp)} is
specified, then {cmd:myexp}{it:#} identifies the {it:#}th unnamed expression in
{it:exp_list}.

{phang}
{opt geqname(name)} specifies the equation name that will be attached to
expressions in {it:exp_list} that are not already part of a named group.  The
default is {cmd:geqname(_eq)}.

{phang}
{opt default} specifies that {cmd:_prefix_explist} generate the default
expression list if {it:exp_list} is not specified.  If {it:exp_list} is not
specified, the default depends the results in {cmd:e()} and {cmd:r()}.  If
{cmd:e(b)} exists, then the default {it:exp_list} is {cmd:_b}.  If {cmd:e(b)}
does not exist, then the default is all the scalars posted to {cmd:r()}.  It
is an error not to specify an expression in {it:exp_list} otherwise.

{phang}
{opt edefault} specifies that {cmd:_prefix_explist} generate the default
expression list if {it:exp_list} is not specified.  If {it:exp_list} is not
specified and {cmd:e(b)} exists, then the default {it:exp_list} is {cmd:_b}.
It is an error not to specify an expression in {it:exp_list} otherwise.

{pstd}
{cmd:_prefix_explist} stores the following in {cmd:s()}:

{pstd}Macros:{p_end}

{p2colset 9 24 28 2}{...}
{p2col: {bf:s(k_exp)}}the
	number of {it:exp} expressions in {it:{help exp_list}}{p_end}
{p2col: {bf:s(idlist)}}list of names for each {it:exp} expression{p_end}
{p2col: {bf:s(eqlist)}}list
	of equation names for each {it:exp} expression{p_end}
{p2col: {bf:s(k_eexp)}}the
	number of {it:eexp} expressions in {it:exp_list}{p_end}
{p2col: {bf:s(eexplist)}}the list of {it:eexp} expressions{p_end}


{marker _prefix_expand}{...}
{title:Expanding and evaluating expression lists}

{pstd}
After using {cmd:_prefix_explist} to perform a preliminary parse of an
{it:exp_list} and running the user supplied command ({it:command} from
{cmd:_prefix_command} above), use {cmd:_prefix_expand} to produce the expanded
list of expressions and collect their observed values in {it:matname}.

{phang2}
{cmd:_prefix_expand} {it:matname}
	[{it:exp1} {it:exp2} ...]
	{cmd:,}
	{opt stub(name)}
	[
		{opt eqstub(name)}
		{opt eexp(eexp)}
		{opt coln:ames(names)}
		{opt cole:q(names)}
	]

{phang}
{opt stub(name)} specifies the {it:stub} used to generate default names used to
identify the individual expressions.  If {cmd:stub(myexp)} is
specified, then {cmd:myexp}{it:#} identifies the {it:#} unnamed expression.

{phang}
{opt eqstub(name)} specifies the {it:stub} used to generate default equation
names used to identify the equations or group of expressions.  If
{cmd:eqstub(gp)} is specified, then {cmd:gp}{it:#} identifies the {it:#}
unnamed group of expressions.  The default is {cmd:eqstub(_eq)}.

{phang}
{opt eexp(eexp)} specifies the {it:eexp} elements as defined in
{help exp_list}.  Individual expressions are derived by expanding each
{it:eexp}.

{pmore}
In the grammar for {it:exp_list}, an {it:eexp} is basically {cmd:_b} or
{cmd:_se} (with the possibility to restrict to a specified equation); see
{help _variables}.  {cmd:_prefix_expand} assigns default names to each
individual expressions derived from {cmd:_b} and {cmd:_se}.  These default
names are based on the equation names and column names.  For example, suppose
{cmd:eexp(_b)} was specified and {cmd:e(b)} contains the following:

{pmore2}
	{cmd:[xb]_b[mpg]}{break}
	{cmd:[xb]_b[turn]}{break}
	{cmd:[xb]_b[trunk]}{break}
	{cmd:[xb]_b[_con]}{break}
	{cmd:[lnsigma]_b[_con]}

{pmore}
{cmd:_prefix_expand} will generate default names for these derived
expressions as follows:

{p2colset 13 35 37 13}{...}
{p2col :{it:expression}}{it:name}{p_end}
{p2line}
{p2col :{cmd:[xb]_b[mpg]}}xb_b_mpg{p_end}
{p2col :{cmd:[xb]_b[turn]}}xb_b_turn{p_end}
{p2col :{cmd:[xb]_b[trunk]}}xb_b_trunk{p_end}
{p2col :{cmd:[xb]_b[_con]}}xb_b_cons{p_end}
{p2col :{cmd:[lnsigma]_b[_con]}}lnsigma_b_cons{p_end}
{p2line}

{phang}
{opt colnames(names)} specifies the list of names corresponding to each
{it:exp#}.

{phang}
{opt coleq(names)} specifies the list of equation names corresponding to each
{it:exp#}.

{pstd}
{cmd:_prefix_expand} stores the following in {cmd:s()}:

{pstd}Macros:{p_end}

{p2colset 9 24 28 2}{...}
{p2col: {bf:s(exp}{it:#}{bf:)}}the {it:#}th expression{p_end}
{p2col: {bf:s(k_eexp)}}number of expressions expanded from {it:eexp}{p_end}
{p2col: {bf:s(ecoleq)}}equation names from {it:eexp}{p_end}
{p2col: {bf:s(ecolna)}}expression names from {it:eexp}{p_end}
{p2col: {bf:s(k_exp)}}number of expression from the {it:exp#}{p_end}
{p2col: {bf:s(coleq)}}equation names for the {it:exp#}{p_end}
{p2col: {bf:s(colna)}}expression names for the {it:exp#}{p_end}
{p2col: {bf:s(k_eq)}}total number of number of equations{p_end}
{p2col: {bf:s(k_extra)}}number of unique names from {opt coleq()}{p_end}
{p2col: {bf:s(enames)}}names for expressions from {it:eexp}{p_end}
{p2col: {bf:s(eexplist)}}paren delimited list
	of the expanded expressions from {it:eexp}{p_end}
{p2col: {bf:s(names)}}names for expressions from the {it:exp#}{p_end}
{p2col: {bf:s(explist)}}paren
	delimited list of the expressions from the {it:exp#}{p_end}
