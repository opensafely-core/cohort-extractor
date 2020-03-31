{smcl}
{* *! version 2.1.3  19oct2017}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] sem and gsem option covstructure()" "mansection SEM semandgsemoptioncovstructure()"}{...}
{findalias assemcu}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{vieweralsosee "[SEM] sem and gsem path notation" "help sem_and_gsem_path_notation"}{...}
{viewerjumpto "Syntax" "sem_and_gsem_option_covstructure##syntax"}{...}
{viewerjumpto "Description" "sem_and_gsem_option_covstructure##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_and_gsem_option_covstructure##linkspdf"}{...}
{viewerjumpto "Option" "sem_and_gsem_option_covstructure##option"}{...}
{viewerjumpto "Remarks" "sem_and_gsem_option_covstructure##remarks"}{...}
{viewerjumpto "Examples" "sem_and_gsem_option_covstructure##examples"}{...}
{p2colset 1 46 48 2}{...}
{p2col:{bf:[SEM] sem and gsem option covstructure()} {hline 2}}Specifying covariance
restrictions{p_end}
{p2col:}({mansection SEM semandgsemoptioncovstructure():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:sem} ... [{cmd:,} ... {cmdab:covstr:ucture(}{it:{help sem and gsem option covstructure##variables:variables}}{cmd:,}
                    {it:{help sem and gsem option covstructure##structure:structure}}{cmd:)} ...]

{p 8 12 2}
{cmd:gsem} ... [{cmd:,} ... {cmdab:covstr:ucture(}{it:{help sem and gsem option covstructure##variables:variables}}{cmd:,} {it:{help sem and gsem option covstructure##structure:structure}}{cmd:)} ...]

{marker variables}{...}
{phang}
where {it:variables} is one of 

{p 8 12 2}
1.  a list of (a subset of the) exogenous variables ({cmd:sem}) or
    latent exogenous variable ({cmd:gsem}) in your model, for instance,{p_end}

{p 12 14 2}       
{cmd:. sem ..., ... covstruct(x1 x2,} {it:structure}{cmd:)}{p_end}
                            
{p 12 14 2}       
{cmd:. sem ..., ... covstruct(L1 L2,} {it:structure}{cmd:)}{p_end}
                            
{p 12 14 2}       
{cmd:. gsem ..., ... covstruct(L1 L2,} {it:structure}{cmd:)}{p_end}
                            
{p 8 12 2}
2.  {opt _OEx}, meaning all observed exogenous variables in your model
      ({cmd:sem} only){p_end}
        
{p 8 12 2}
3.  {opt _LEx}, meaning all latent exogenous variables in your model
    (including any multilevel latent exogenous variables in the case of
    {cmd:gsem}){p_end}

{p 8 12 2}
4.  {opt _Ex}, meaning all exogenous variables in your model
    ({cmd:sem} only){p_end}

{phang}
or where {it:variables} is one of
                                
{p 8 12 2}
1.  a list of (a subset of the) error variables in your model, for example,
{p_end}
        
{p 12 14 2}       
{cmd:. sem ..., ... covstruct(e.y1 e.y2 e.Aspect,}
{it:structure}{cmd:)}{p_end}

{p 8 12 2}
2.  {opt e._OEn}, meaning all error variables associated with observed
endogenous variables in your model{p_end}

{p 8 12 2}
3.  {opt e._LEn}, meaning all error variables associated with latent
endogenous variables in your model{p_end}

{p 8 12 2}
4.  {opt e._En}, meaning all error variables in your model{p_end}

{marker structure}{...}
{phang}
and where {it:structure} is

{p2colset 8 30 32 2}{...}
{p2col:{it:structure}}Description{p_end}
{p2line}
{p2col :{opt diag:onal}}all variances unrestricted{p_end}
{p2col: }all covariances fixed at {cmd:0}{p_end}

{p2col :{opt un:structured}}all variances unrestricted {p_end}
{p2col: }all covariances unrestricted{p_end}

{p2col :{opt id:entity}}all variances equal{p_end}
{p2col: }all covariances fixed at {cmd:0}{p_end}

{p2col :{opt ex:changeable}}all variances equal{p_end}
{p2col: }all covariances equal{p_end}

{p2col :{opt zero}}all variances fixed at {cmd:0}{p_end}
{p2col: }all covariances fixed at {cmd:0}{p_end}

{p2col :* {opth pat:tern(matname)}}covariances (variances) unrestricted if
matname[i,j] {ul:>} {cmd:.} {p_end}
{p2col: }covariances (variances) equal if matname[i,j] = matname[k,l]{p_end}

{p2col :+ {opth fix:ed(matname)}}covariances (variances) unrestricted if
matname[i,j] {ul:>} {cmd:.} {p_end}
{p2col: }covariances (variances) fixed at matname[i,j] otherwise{p_end}
{p2line}
{p2colreset}{...}
{p 6 10 2}(*) Only elements in the lower triangle of {it:matname} are used.
All values in {it:matname} are interpreted as the {helpb floor()} of the value
if noninteger values appear.  Row and column stripes of {it:matname} are
ignored.

{p 6 10 2}(+) Only elements on the lower triangle of {it:matname} are used.
Row and column stripes of {it:matname} are ignored.


{marker description}{...}
{title:Description}

{pstd}
Option {opt covstructure()} provides a sometimes convenient way to constrain
the covariances of your model. 

{pstd}
Alternatively or in combination, you can place constraints on the
covariances by using the standard path notation, such as

{phang2}{cmd:. sem ..., ... cov(}{it:name1}{cmd:*}{it:name2}{cmd:@}{it:c1} 
{it:name3}{cmd:*}{it:name4}{cmd:@}{it:c1}{cmd:) ...}{p_end}

{phang2}{cmd:. gsem ..., ... cov(}{it:name1}{cmd:*}{it:name2}{cmd:@}{it:c1} 
{it:name3}{cmd:*}{it:name4}{cmd:@}{it:c1}{cmd:) ...}{p_end}

{pstd}
See {helpb sem_and gsem path_notation:[SEM] sem and gsem path notation}.

{pstd}
If you are using {cmd:sem}, also see
{helpb sem_path_notation_extensions:[SEM] sem path notation extensions}
for documentation on how the syntax of {cmd:covstructure()} is modified when
the {cmd:group()} option is specified.

{pstd}
If you are using {cmd:gsem}, also see
{helpb gsem_path_notation_extensions:[SEM] gsem path notation extensions}
for documentation on how the syntax of {cmd:covstructure()} is modified when
the {cmd:group()} option or the {cmd:lclass()} options are specified.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM semandgsemoptioncovstructure()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:covstruct(}{it:variables}{cmd:,} {it:structure}{cmd:)} is
used either to modify the covariance structure among the exogenous
variables of your model or to modify the covariance structure among the
error variables of your model.

{p 8 8 2}
You may specify the {opt covstruct()} option multiple times.

{p 8 8 2}
The default covariance structure for the exogenous variables is 
{cmd:covstruct(_Ex, unstructured)} for {cmd:sem}.  
There is no simple way in this notation to write the default for
{cmd:gsem}.

{p 8 8 2}
The default covariance structure for the error variables is 
{cmd:covstruct(e._En, diagonal)} for {cmd:sem} and {cmd:gsem}. 


{marker remarks}{...}
{title:Remarks}
     
{pstd}
See {findalias semcu}.

{pstd}
Standard linear structural equation modeling allows covariances among
exogenous variables, both latent and observed, and allows covariances among
the error variables.  Covariances between exogenous variables and error
variables are disallowed (assumed to be 0). 

{pstd}
Some authors refer to the covariances among the exogenous variables in
standard SEMs as matrix
{cmd:Phi} and to the covariances among the error variables as matrix
{cmd:Psi}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_mimic1}{p_end}

{pstd}MIMIC model{p_end}
{phang2}{cmd:. sem (SubjSES -> s_income s_occpres s_socstat)}{break}
	{cmd: (SubjSES <- income occpres)}{p_end}

{pstd}Let error variance of {cmd:s_income} and {cmd:s_occpres} be unstructured{p_end}
{phang2}{cmd:. sem (SubjSES -> s_income s_occpres s_socstat)}{break}
	{cmd: (SubjSES <- income occpres),}{break}
	{cmd: covstructure(e.s_income e.s_occpres, unstructured)}{p_end}

{pstd}Set error variances of observed endogenous variables to be equal{p_end}
{phang2}{cmd:. sem (SubjSES -> s_income s_occpres s_socstat)}{break}
	{cmd: (SubjSES <- income occpres),}{break}
	{cmd: covstructure(e.s_income e.s_occpres e.s_socstat, identity)}{p_end}

{pstd}Same as above, but using the keyword _OEn{p_end}
{phang2}{cmd:. sem (SubjSES -> s_income s_occpres s_socstat)}{break}
	{cmd: (SubjSES <- income occpres),}{break}
	{cmd: covstructure(e._OEn, identity)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_cfa}{p_end}

{pstd}Two-factor measurement model{p_end}
{phang2}{cmd:. gsem (MathAb -> q1-q8, logit) (MathAtt -> att1-att5, ologit)}{p_end}

{pstd}Constrain covariance between {cmd:MathAb} and {cmd:MathAtt} to {cmd:0} but 
estimate variances freely{p_end}
{phang2}{cmd:. gsem (MathAb -> q1-q8, logit) (MathAtt -> att1-att5, ologit),}{break}
	{cmd: covstructure(MathAb MathAtt, diagonal)}{p_end}

{pstd}Same as above, but using the keyword {p_end}
{phang2}{cmd:. gsem (MathAb -> q1-q8, logit) (MathAtt -> att1-att5, ologit),}{break}
        {cmd: covstructure(_LEx, diagonal)}{p_end}

    {hline}
