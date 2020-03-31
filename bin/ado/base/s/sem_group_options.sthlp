{smcl}
{* *! version 1.1.3  14may2018}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] sem group options" "mansection SEM semgroupoptions"}{...}
{vieweralsosee "[SEM] Intro 6" "mansection SEM Intro6"}{...}
{findalias assemtfmmg}{...}
{findalias assemcnsg}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{viewerjumpto "Syntax" "sem_group_options##syntax"}{...}
{viewerjumpto "Description" "sem_group_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_group_options##linkspdf"}{...}
{viewerjumpto "Options" "sem_group_options##options"}{...}
{viewerjumpto "Remarks" "sem_group_options##remarks"}{...}
{viewerjumpto "Examples" "sem_group_options##examples"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[SEM] sem group options} {hline 2}}Fitting models on different
groups{p_end}
{p2col:}({mansection SEM semgroupoptions:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:sem} {it:paths} ...{cmd:,} ... {it:group_options}

{synoptset 24}{...}
{synopthdr:group_options}
{synoptline}
{synopt :{opth group(varname)}}fit model for different groups{p_end}
{synopt :{opt gin:variant(pclassname)}}specify parameters that are equal across groups{p_end}
{synoptline}

{marker pclassname}{...}
{synoptset 24}{...}
INCLUDE help sem_classnames
{p2colreset}{...}
{p 4 6 2}
{cmd:ginvariant(mcoef mcons)} is the default if {opt ginvariant()} is not
specified.  {p_end}

{phang}
{opt meanex}, {opt covex}, and {opt all} exclude the observed exogenous
variables (that is, they include only the latent exogenous variables)
unless you specify the {opt noxconditional} option or the {opt noxconditional}
option is otherwise implied; see
{helpb sem_option_noxconditional:[SEM] sem option noxconditional}.  This is what
you would desire in most cases.


{marker description}{...}
{title:Description}

{pstd}
{cmd:sem} can fit combined models across subgroups of the data while allowing
some parameters to vary and constraining others to be equal across subgroups.
These subgroups could be males and females, age category, and the like.

{pstd}
{cmd:sem} performs such estimation when the {opth group(varname)} option is
specified.  The {opt ginvariant(pclassname)} option specifies which parameters
are to be constrained to be equal across the groups.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM semgroupoptionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth group(varname)}
specifies that the model be fit as described above.  {it:varname}
specifies the name of a numeric variable that records the group to which
the observation belongs.

{p 8 8 2}
If you are using summary statistics data in place of raw data, {it:varname} is
the name of the group variable as reported by {cmd:ssd describe}; see
{helpb ssd:[SEM] ssd}. 

{phang}
{opth ginvariant:(sem_group_options##pclassname:pclassname)}
specifies which classes of parameters of the model are to be constrained to be
equal across groups.  The classes are defined above.  The default is 
{cmd:ginvariant(mcoef mcons)} if the option is not specified.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {manlink SEM Intro 6}, and
see {findalias semtfmmg} and {findalias semcnsg}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_2fmmby}{p_end}

{pstd}Two-factor measurement model with groups{p_end}
{phang2}{cmd:. sem (Peer -> peerrel1 peerrel2 peerrel3 peerrel4)}{break}
	{cmd: (Par -> parrel1 parrel2 parrel3 parrel4), group(grade)}{p_end}

{pstd}Specify all parameters to be equal across groups{p_end}
{phang2}{cmd:. sem (Peer -> peerrel1 peerrel2 peerrel3 peerrel4)}{break}
	{cmd: (Par -> parrel1 parrel2 parrel3 parrel4),}{break}
	{cmd: group(grade) ginvariant(all)}{p_end}

{pstd}Specify parameter constraints across groups{p_end}
{phang2}{cmd:. sem (Peer -> peerrel1 peerrel2 peerrel3 peerrel4), }{break}
	{cmd:group(grade) ginvariant(all) var(1: Peer@v3) var(2: Peer@v4)}{p_end}
