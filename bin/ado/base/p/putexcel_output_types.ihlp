{* *! version 1.0.3  08may2019}{...}
{* *! This ihlp is for putexcel. If you make changes here, check}{...}
{* *! if similar changes need be made to putexcela_output_types.ihlp.}{...}
{marker expr}{...}
{phang}
{it:exp} writes a valid Stata expression to a cell; see
{helpb exp:[U] 13 Functions and expressions}.  Stata dates and datetimes
differ from Excel dates and datetimes.  To properly export date and datetime
values, use {opt asdate} and {opt asdatetime}.

{marker matrix}{...}
{phang}
{opth matrix:(matrix:matname)} writes the values from a Stata matrix to Excel.
Stata determines where to place the data in Excel by default from the size of
the matrix (the number of rows and columns) and the location you specified in
{it:ul_cell}.  By default, {it:ul_cell} contains the first element of
{it:matname}, and matrix row names and column names are not written.

{marker picture}{...}
{phang}
{opth image(filename)} writes a portable network graphics ({cmd:.png}), JPEG
({cmd:.jpg}), Windows metafile ({cmd:.wmf}), device-independent bitmap
({cmd:.dib}), enhanced metafile ({cmd:.emf}), or bitmap ({cmd:.bmp}) file to
an Excel worksheet.  The upper-left corner of the image is aligned with the
upper-left corner of the specified {it:ul_cell}.  The image is not resized.
If {it:filename} contains spaces, it must be enclosed in double quotes.

{marker returnset}{...}
{phang}
{it:returnset} is a shortcut name that is used to identify a group of
{help return} values.  It is intended primarily for use by programmers and by
those who intend to do further processing of their exported results in Excel.
{it:returnset} may be any one of the following:

         {it:returnset}
	{hline 25}
         {opt escal:ars}   {opt escalarn:ames}
         {opt rscal:ars}   {opt rscalarn:ames}
         {opt emac:ros}    {opt emacron:ames}
         {opt rmac:ros}    {opt rmacron:ames}
         {opt emat:rices}  {opt ematrixn:ames}
         {opt rmat:rices}  {opt rmatrixn:ames}
         {opt e*}          {opt ena:mes}
         {opt r*}          {opt rna:mes}
	{hline 25}

{marker formula}{...}
{phang}
{opt formula(formula)} writes an Excel formula to the cell specified in
{it:ul_cell}.  {it:formula} may be any valid Excel formula.  Stata does not
validate formulas; the text is passed literally to Excel.

{marker etable}{...}
{phang}
{cmd:etable}[{cmd:(}{it:#}1 {it:#}2 ... {it:#n}{cmd:)}] adds an
automatically generated table to an Excel file starting in {it:ul_cell}.
The table may be derived from the
coefficient table of the last estimation command, from the table of
margins after the last {helpb margins} command,
or from the table of results from one or more models displayed by
{helpb estimates table}.

{pmore} 
If the estimation command outputs {it:n} > 1 coefficient tables, the
default is to add all tables and assign the corresponding table names
{it:tablename}{cmd:1}, {it:tablename}{cmd:2}, ..., {it:tablename}_{it:n}.
To specify which tables to add, supply the optional numlist to {cmd:etable}.
For example, to add only the first and third tables from the estimation output,
specify {cmd:etable(1 3)}.  A few estimation commands do not support the
{cmd:etable} output type. See
{mansection RPT AppendixforputdocxDescriptionUnsupportedestimationcommands:{it:Unsupported estimation commands}}
in {bf:[RPT] Appendix for putdocx} for a list of estimation commands that are
not supported by {cmd:putexcel}.
{p_end}
