{smcl}
{* *! version 1.4.7  10feb2020}{...}
{vieweralsosee "[R] Limits" "mansection R Limits"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] about" "help about"}{...}
{vieweralsosee "[D] compress" "help compress"}{...}
{vieweralsosee "[D] Data types" "help data_types"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{vieweralsosee "[D] infile (fixed format)" "help infile2"}{...}
{vieweralsosee "[D] infile (free format)" "help infile1"}{...}
{vieweralsosee "[D] memory" "help memory"}{...}
{vieweralsosee "[D] obs" "help obs"}{...}
{viewerjumpto "Maximum size limits" "limits##size"}{...}
{viewerjumpto "Notes" "limits##notes"}{...}
{viewerjumpto "Determining which flavor of Stata you are running" "limits##about"}{...}
{marker size}{...}
{title:Maximum size limits}

                                                              {help statamp:Stata/MP} and
                                             {help stataic:Stata/IC}         {help SpecialEdition:Stata/SE}
{hline}
   # of observations                  2,147,483,619  1,099,511,627,775 (MP) {help limits##note1:(1)}
                                                         2,147,483,619 (SE) {help limits##note1:(1)}

   # of variables                             2,048            120,000 (MP)
                                                                32,767 (SE)

   # of RHS variables                           798             65,532 (MP)
                                                                10,998 (SE)

   # characters in a command                264,408          4,227,159
   # options for a command                      256                256

   # of elements in a {it:{help numlist}}                 2,500              2,500

   # of interacted continuous variables          64                 64
   # of interacted factor variables               8                  8

   # of unique time-series operators in
       a command                                100                100
   # seasonal suboperators per time-series
       operator                                   8                  8

   # of dyadic operators in an expression       800                800
   # of numeric literals in an expression       300                300
   # of string literals in an expression        512                512
   length of string in string
       expression (bytes)             2,000,000,000      2,000,000,000
   # of sum functions in an expression            5                  5
   # of pairs of nested parentheses             249                249

   # of characters in a macro  {help limits##note2:(2)}          264,392         15,480,200 (MP)
                                                             4,227,143 (SE)

   # of nested do-files                          64                 64

   # of lines in a program                    3,500              3,500
   # of bytes in a program                  135,600            135,600

   length of a variable name (characters)        32                 32
   length of ado-command name (characters)       32                 32
   length of a global macro name
       (characters)                              32                 32
   length of a local macro name (characters)     31                 31

   length of a {helpb data types:str#} variable (bytes)          2,045              2,045
   length of a {helpb data types:strL} variable
        (bytes)                       2,000,000,000      2,000,000,000

   {helpb anova}
       # of variables in one {cmd:anova} term           8                  8
       # of terms in the {cmd:repeated()} option        4                  4

   {helpb char}
       length of one characteristic
       (bytes)                               67,784             67,784

   {helpb constraint}
       # of constraints                       1,999              1,999

   {helpb encode} and {helpb decode}
       # of unique values                    65,536             65,536

   {helpb _estimates} {cmd:hold}
       # of stored estimation results           300                300

   {helpb estimates} {cmd:store}
       # of stored estimation results           300                300

   {helpb exlogistic} and {helpb expoisson}
       maximum memory specification in          2gb                2gb
       {opt memory(#)}

   {helpb frames:frames}
       # of frames                              100                100

   {helpb grmeanby}
       # of unique values in {varlist}           _N/2               _N/2

   {helpb region_options:graph}
       minimum graph size (inches)                1                  1
       maximum graph size (inches)              100                100

   {helpb graph twoway}
       # of variables in a plot                 100                100
       # of styles in an option's stylelist      20                 20

   {helpb import sas}
       # of variables                         2,048             32,766

   {helpb import spss}
       # of variables                         2,048             32,766

   {helpb impute}
       # of variables in {varlist}                 31                 31

   {helpb infile}
       record length without dictionary        none               none
       record length with a dictionary      524,275            524,275

   {helpb infix}
       record length with a dictionary      524,275            524,275

   {helpb label}
       length of dataset label (characters)      80                 80
       length of variable label (characters)     80                 80
       length of value label string
           (bytes)                           32,000             32,000
       length of name of value label
           (characters)                          32                 32
       # of codings within one
	   value label                       65,536             65,536

   {helpb label language}
       # of different languages                 100                100

   {help macros}
       # of nested macros                        20                 20

   {helpb manova}
       # of variables in single {cmd:manova} term       8                  8

   {helpb matrix}  {help limits##note3:(3)}
       dimension of single matrix           800x800      65,534x65,534 (MP)
                                                         11,000x11,000 (SE)

   {help maximize} options
       {cmd:iterate()} maximum                     16,000             16,000

   {helpb mprobit}
       # of categories in a {depvar}               30                 30

   {helpb net} (also see {helpb usersite})
       # of description lines in .pkg file      100                100

   {helpb nlogit} and {helpb nlogittree}
       # of levels in model                       8                  8

   {helpb notes}
       length of one note (bytes)            67,784             67,784
       # of notes attached to _dta            9,999              9,999
       # of notes attached to each
	   variable                           9,999              9,999

   {it:{help numlist}}
       # of elements in the numeric list      2,500              2,500

   {helpb _pctile}
       # of percentiles                       4,096              4,096

   {helpb reg3}, {helpb sureg}, and other system estimators
       # of equations                           800             65,534 (MP)
                                                                11,000 (SE)

   {cmd:set} {helpb adosize}
       memory ado-files may consume           1000K              1000K

   {cmd:set} {helpb scrollbufsize}
       memory for Results window buffer       2000K              2000k

   {helpb slogit}
       # of categories in a {depvar}               30                 30

   {helpb snapshot}
       length of label (characters)              80                 80
       # of saved snapshots                   1,000              1,000

   {helpb stcox}
       # of variables in {cmd:strata()} option          5                  5

   {helpb stcurve}
       # of curves plotted on the same graph     10                 10

   {helpb table} and {helpb tabdisp}
       # of by variables                          4                  4
       # of margins, i.e., sum of rows,
	 columns, supercolumns, and
	 by groups                            3,000              3,000

   {helpb tabulate}  
       # of rows in one-way table             3,000             12,000
       # of rows & cols in two-way table     300x20           1,200x80

   {cmd:tabulate, summarize} (see {helpb tabsum})
       # of cells (rows X cols)                 375                375

   {helpb teffects}
	# of treatments                          20                 20

   {cmd:xt} estimation commands (e.g., {helpb xtgee},
       {helpb xtgls}, {helpb xtpoisson}, {helpb xtprobit}, {helpb xtreg}
       with {cmd:mle} option, and {helpb xtpcse} when
       neither option {cmd:hetonly} nor option
       {cmd:independent} is specified)

       # of time periods within panel           800             65,534 (MP)
                                                                11,000 (SE)
       # of integration points accepted         195                195
         by {opt intpoints(#)}               
{hline}


{marker notes}{...}
{title:Notes}

{marker note1}{...}
{p 4 8 2}(1)  For Stata/MP, the maximum number of observations is
          1,099,511,627,775, and
	  for Stata/SE, the maximum number is 2,147,483,619.
          In practice, both flavors are limited by memory.

{marker note2}{...}
{p 4 8 2}(2)  The maximum length of the contents of a macro are fixed
          in Stata/IC and settable in Stata/SE and Stata/MP.
          The currently set maximum length is recorded in
          {cmd:c(macrolen)}; type {cmd:display c(macrolen)}.
          The maximum length can be changed with {helpb set maxvar}.
          If you set {cmd:maxvar}
          to a larger value, the maximum length increases;
          if you set {cmd:maxvar} to a smaller value, the maximum length
          decreases.  The relationship between them is
          {it:maximum_length} = 129*{cmd:maxvar} + 200.

{marker note3}{...}
{p 4 8 2}(3)  In Mata, matrices are limited only by the amount of memory on your
               computer.


{marker about}{...}
{title:Determining which flavor of Stata you are running}

    Type

	    {cmd:. about}

{p 4 4 2}
The response will be Stata/MP, Stata/SE, or Stata/IC.
Other information is also shown, including your serial number.
See {helpb about}.
{p_end}
