{smcl}
{* *! version 1.2.0  10oct2017}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{vieweralsosee "[SVY] svyset" "help svyset"}{...}
{viewerjumpto "Syntax" "svygen##syntax"}{...}
{viewerjumpto "Description" "svygen##description"}{...}
{viewerjumpto "Options" "svygen##options"}{...}
{viewerjumpto "Examples" "svygen##examples"}{...}
{title:Title}

{p 4 22 2}
{hi:[SVY] svygen} {hline 2} Generating adjusted sampling weights


{marker syntax}{...}
{title:Syntax}

{pstd}
Poststratification adjusted sampling weights

{p 8 15 2}
{cmd:svygen} {opt post:stratify}
	{it:new_weight_var} {weight} {ifin}
	[{cmd:,}
		{opt posts:trata(varname)} 
		{opt postw:eight(varname)}
		{opt nocheck}]


{pstd}
Balanced repeated replicate (BRR) weights

{p 8 15 2}
{cmd:svygen} {opt br:r}
	{it:stub} {weight} {ifin}{cmd:,}
		{opt H:adamard(matname)} 
		{opt str:ata(varname)} 
	[{opt psu(varname)} 
		{opt fay(#)} 
		{opt posts:trata(varname)} 
		{opt postw:eight(varname)} 
		{opt nocheck}]


{pstd}
Jackknife replicate weights

{p 8 15 2}
{cmd:svygen} {opt jack:knife}
	{it:stub} [{it:multiplier}] {weight} {ifin}
	[{cmd:,}
		{opt str:ata(varname)} 
		{opt psu(varname)} 
		{opt fpc(varname)} 
		{opt posts:trata(varname)} 
		{opt postw:eight(varname)}]


{pstd}
Successive difference replicate (SDR) weights

{p 8 15 2}
{cmd:svygen} {opt sdr}
	{it:stub} {weight} {ifin}{cmd:,}
		{opt H:adamard(matname)} 
	[{opt psu(varname)} 
		{opt posts:trata(varname)} 
		{opt postw:eight(varname)} 
		{opt nocheck}]


{pstd}
{opt pweight}s and {opt iweight}s are allowed; see {help weights}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:svygen} generates adjusted weights for survey data analysis.

{pstd}
{cmd:svygen} {cmd:poststratify} generates sampling weights that are adjusted
according to the poststratification weights.

{pstd}
{cmd:svygen} {cmd:brr} generates BRR weights for designs with two primary
sampling units per stratum.

{pstd}
{cmd:svygen} {cmd:jackknife} generates delete-1 jackknife replicate weights.

{pstd}
{cmd:svygen} {cmd:sdr} generates SDR weights.


{marker options}{...}
{title:Options}

{phang}
{opt poststrata(varname)} specifies the name of a variable (numeric or string)
that identifies the poststratum groups.

{phang}
{opt postweight(varname)} specifies the name of a numeric variable that
contains the poststratum counts in the population.

{phang}
{opt nocheck} prevents {cmd:svygen} {cmd:poststratify} from checking the
validity of the poststratum counts.  This option helps speed things up when
{cmd:svygen} is called within a loop, but it should only be used once the
counts have been validated.

{phang}
{opt hadamard(matname)} ({cmd:brr} and {cmd:sdr} only) specifies the name of a
Hadamard matrix.  The Hadamard matrix {it:matname} is a square matrix {it:H}
with {it:k} columns, such that {it:H}{it:H}' = {it:k}{opt I(k)}, where
{opt I(k)} denotes the identity matrix with {it:k} columns.

{phang2}
For {cmd:svygen} {cmd:brr}, {it:k} must be larger than or equal to the number
of strata identified in the {opt strata()} option.

{phang2}
For {cmd:svygen} {cmd:sdr}, {it:k} must be larger than or equal to the number
of primary sampling units (PSUs).

{phang}
{opt fay(#)} ({cmd:brr} only) specifies Fay's adjustment.  The sampling
weights of the selected PSUs for a given replicate are multiplied by
{hi:2-}{it:#}, while the sampling weights for the unselected PSUs are
multiplied by {it:#}.  {cmd:fay(0)} is the default and is equivalent to the
original BRR method.

{pmore}
{it:#} must be a number between 0 and 2; however, {cmd:fay(1)} is not allowed.

{phang}
{opt strata(varname)} ({cmd:brr} and {cmd:jackknife} only) specifies the name
of a variable (numeric or string) that contains stratum identifiers.
{opt strata()} is required by {cmd:brr}.

{phang}
{opt psu(varname)} ({cmd:brr} and {cmd:jackknife} only) specifies the name of
a variable (numeric or string) that contains identifiers for the PSUs
(clusters).

{phang}
{opt fpc(varname)} ({cmd:brr} and {cmd:jackknife} only) specifies the name of
a numeric variable that contains finite population corrections for the
variance estimates.


{marker examples}{...}
{title:Examples}

{phang}
{cmd:. svygen brr brrw [pw=sampwgt], H(h12) strata(strid) psu(psuid)}
{p_end}
{phang}
{cmd:. svygen jackknife f jkw [pw=sampwgt], strata(strid) psu(psuid)}
{p_end}
{phang}
{cmd:. svygen sdr sdrw [pw=sampwgt], psu(psuid)}
{p_end}
{phang}
{cmd:. svygen post pwgt [pw=sampwgt], posts(strid postid) postw(totals)}
{p_end}
