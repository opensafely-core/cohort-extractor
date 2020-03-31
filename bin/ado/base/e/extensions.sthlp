{smcl}
{* *! version 1.1.15  21jun2019}{...}
{findalias asfrfilenames}{...}
{title:Title}

    {findalias frfilenames}


{title:Remarks}

{pstd}
Usually (the exceptions being {cmd:copy}, {cmd:dir}, {cmd:ls}, {cmd:erase},
{cmd:rm}, and {cmd:type}), Stata automatically provides a file extension if
you do not supply one.  For instance, if you type {cmd:use} {cmd:mydata},
Stata assumes that you mean {cmd:use} {cmd:mydata.dta} because {cmd:.dta} is
the file extension Stata normally uses for data files.

{pstd}
Stata provides 23 default file extensions that are used by various
commands:

{p2colset 9 20 22 2}{...}
{p2col :{mansection U 17Ado-files:{bf:.ado}}}automatically loaded do-files{p_end}
{p2col :{helpb infile2:.dct}}text data dictionary{p_end}
{p2col :{mansection U 16Do-files:{bf:.do}}}do-file{p_end}
{p2col :{helpb save:.dta}}Stata-format dataset{p_end}
{p2col :{helpb datasignature:.dtasig}}{cmd:datasignature} file{p_end}
{p2col :{helpb graph save:.gph}}{cmd:graph}{p_end}
{p2col :{helpb graph editor:.grec}}Graph Editor recording (text format){p_end}
{p2col :{helpb irf set:.irf}}impulse-response function datasets{p_end}
{p2col :{helpb log:.log}}log file in text format{p_end}
{p2col :{helpb m1 source:.mata}}Mata source code{p_end}
{p2col :{helpb mata mlib:.mlib}}Mata library{p_end}
{p2col :{helpb mata matsave:.mmat}}Mata matrix{p_end}
{p2col :{helpb mata mosave:.mo}}Mata object file{p_end}
{p2col :{helpb infile1:.raw}}text-format data{p_end}
{p2col :{helpb smcl:.smcl}}log file in SMCL format{p_end}
{p2col :{helpb datetime business calendars:.stbcal}}business calendars{p_end}
{p2col :{helpb estimates save:.ster}}saved estimates{p_end}
{p2col :{helpb smcl:.sthlp}}help file{p_end}
{p2col :{helpb project_manager:.stpr}}project file{p_end}
{p2col :{helpb mi ptrace:.stptrace}}parameter-trace file{p_end}
{p2col :{helpb sem gui:.stsem}}SEM Builder file{p_end}
{p2col :{helpb spmatrix use:.stswm}}spatial weighting matrix{p_end}
{p2col :{helpb lasso estimates store:.stxer}}ancillary file to {cmd:.ster} when using lasso commands{p_end}
{p2col :{helpb checksum:.sum}}checksum files to verify network transfers{p_end}

{pstd}
You do not have to name your data files with the {cmd:.dta} extension -- if
you type an explicit file extension, it will override the default.  For
instance, if your dataset was stored as {cmd:myfile.dat}, you could type
{cmd:use myfile.dat}.  If your dataset was stored as simply {cmd:myfile}
with no file extension, you could type the period at the end of the filename
to indicate that you are explicitly specifying the null extension.  You would
type {cmd:use} {cmd:myfile.} to use this dataset.

{pstd}
Stata also uses 12 other file extensions.  These files are of interest only to
advanced programmers or are for Stata's internal use.  They are

{p2col :{helpb class:.class}}class file for object-oriented programming{p_end}
{p2col :{helpb dialog programming:.dlg}}dialog resource file{p_end}
{p2col :{helpb dialog programming:.idlg}}dialog resource include file{p_end}
{p2col :{helpb smcl:.ihlp}}help include file{p_end}
{p2col :{helpb search:.key}}{cmd:search}'s keyword database file{p_end}
{p2col :{cmd:.maint}}maintenance file (for Stata's internal use only){p_end}
{p2col :{cmd:.mnu}}menu file (for Stata's internal use only){p_end}
{p2col :{helpb net:.pkg}}user-site package file{p_end}
{p2col :{helpb plugin:.plugin}}compiled addition (DLL){p_end}
{p2col :{helpb schemes intro:.scheme}}control file for a graph scheme{p_end}
{p2col :{helpb graph query:.style}}graph style file{p_end}
{p2col :{mansection U 29.5Makingyourowndownloadsite:{bf:.toc}}}user-site description file{p_end}
