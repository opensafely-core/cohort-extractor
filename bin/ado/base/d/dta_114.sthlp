{smcl}
{* *! version 1.0.8  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] save" "help save"}{...}
{vieweralsosee "[D] use" "help use"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] sysuse" "help sysuse"}{...}
{vieweralsosee "[D] webuse" "help webuse"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 1.2.2 Example datasets" "help dta_contents"}{...}
{viewerjumpto "Syntax" "dta_114##syntax"}{...}
{viewerjumpto "Remarks" "dta_114##remarks"}{...}
{title:Title}

{p2colset 5 30 32 2}{...}
{p2col :{hi:[P] File formats .dta} {hline 2}}Description of .dta file format 114{p_end}
{p2colreset}{...}


{pstd}
{bf:Warning:}
The entry below describes the contents of an old Stata {cmd:.dta} file format.
Newer versions of Stata continue to read, and perhaps to write, this old
format.  What follows is the original help file for the {cmd:.dta} file format
when it was the current file format.


{title:Technical note}

{pstd}
Format 114 is identical to format 115 except for the version number.
The new number was introduced because of the new 
{cmd:%tb} {help datetime_business_calendars:business date formats}.
Older Statas would not know what to make of them.  Changing the version
number from 114 to 115 prevented older Statas from reading datasets
that might include {cmd:%tb} formats.


{marker syntax}{...}
{title:Syntax}

{pstd}
The information contained in this highly technical entry probably does not
interest you.  We describe in detail the format of Stata {cmd:.dta} datasets
for those interested in writing programs in C or other languages that read and
write them.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help dta_114##intro:1.  Introduction}
	{help dta_114##versions:2.  Versions and flavors of Stata}
	{help dta_114##strings:3.  Representation of strings}
	{help dta_114##numbers:4   Representation of numbers}
 	{help dta_114##definition:5.  Dataset format definition}
	    {help dta_114##header:5.1  Header}
	    {help dta_114##descriptors:5.2  Descriptors}
	    {help dta_114##variable_labels:5.3  Variable labels}
	    {help dta_114##expansion_fields:5.4  Expansion fields}
	    {help dta_114##data:5.5  Data}
	    {help dta_114##value_labels:5.6  Value labels}


{marker intro}{...}
{title:1.  Introduction}

{pstd}
Stata-format datasets record data in a way generalized to work across computers
that do not agree on how data are recorded.  Thus the same dataset may be
used, without translation, on different computers (Windows, Unix, and
Mac computers).  Given a computer, datasets are
divided into two categories:  native-format and foreign-format datasets. Stata
uses the following two rules:

{p 8 13 2}
    R1.  On any computer, Stata knows how to write only native-format
	 datasets.

{p 8 13 2}
    R2.  On all computers, Stata can read foreign-format as well as
	 native-format datasets.

{pstd}
Rules R1 and R2 ensure that Stata users need not be concerned with
dataset formats.  If you are writing a program to read and write Stata
datasets, you will have to determine whether you want to follow the same rules
or instead restrict your program to operate on only native-format datasets.
Because Stata follows rules R1 and R2, such a restriction would not be too
limiting.  If the user had a foreign-format dataset, he or she could enter
Stata, {helpb use} the data, and then {helpb save} it again.


{marker versions}{...}
{title:2.  Versions and flavors of Stata}

{pstd}
Stata is continually being updated, and these updates sometimes require changes
be made to how Stata records {cmd:.dta} datasets.  This document documents
what are known as {hi:format-114} datasets, the most modern format.  Stata
itself can read older formats, but whenever it writes a dataset, it writes in
{hi:114} format.

{pstd}
There are currently three flavors of Stata available:
{help stataic:Stata/IC}, {help SpecialEdition:Stata/SE}, and
{help statamp:Stata/MP}.  The same {hi:114} format is used by all flavors.
The difference is that datasets can be larger in some flavors.


{marker strings}{...}
{title:3.  Representation of strings}

{phang}
1.  Strings in Stata may be from 1 to 244 bytes long.

{phang}
2.  Stata records a string with a trailing binary 0 ({cmd:\0}) delimiter if
    the length of the string is less than the maximum declared length.  The
    string is recorded without the delimiter if the string is of the maximum
    length.

{phang}
3.  Leading and trailing blanks are significant.

{phang}
4.  Strings use ASCII encoding.


{marker numbers}{...}
{title:4.  Representation of numbers}

{phang}
1.  Numbers are represented as 1-, 2-, and 4-byte integers and 4- and 8-byte
    floats.  In the case of floats, ANSI/IEEE Standard 754-1985 format is used.

{phang}
2.  Byte ordering varies across machines for all numeric types.  Bytes are
    ordered either least-significant to most-significant, dubbed LOHI,
    or most-significant to least-significant, dubbed HILO. Pentiums, for
    instance, use LOHI encoding.  Sun SPARC-based computers use HILO encoding.
    Itanium-based computers are interesting in that they can be either
    LOHI or HILO depending on operating system.  Windows and Linux on
    Itanium use LOHI encoding.  HP-UX on Itanium uses HILO encoding.

{phang}
3.  When reading a HILO number on a LOHI machine or a LOHI
    number on a HILO machine, perform the following before interpreting
    the number:

	    byte          no translation necessary
	    2-byte int    swap bytes 0 and 1
	    4-byte int    swap bytes 0 and 3, 1 and 2
	    4-byte float  swap bytes 0 and 3, 1 and 2
	    8-byte float  swap bytes 0 and 7, 1 and 6, 2 and 5, 3 and 4

{phang}
4.  For purposes of written documentation, numbers are written with the most
    significant byte listed first.  Thus, {cmd:0x0001} refers to a
    2-byte integer taking on the logical value 1 on all machines.

{phang}
5.  Stata has five numeric data types.  They are

	    {cmd:byte}          1-byte signed int
	    {cmd:int}           2-byte signed int
	    {cmd:long}          4-byte signed int
	    {cmd:float}         4-byte IEEE float
	    {cmd:double}        8-byte IEEE float

{phang}
6.  Each type allows for 27 {help missing:missing value codes}, known as
    {cmd:.}, {cmd:.a}, {cmd:.b}, ..., {cmd:.z}.
    For each type, the range allowed for nonmissing values and the missing
    values codes are

	    {cmd:byte}
		minimum nonmissing    -127   (0x80)
		maximum nonmissing    +100   (0x64)
		code for {cmd:.}            +101   (0x65)
		code for {cmd:.a}           +102   (0x66)
		code for {cmd:.b}           +103   (0x67)
		...
		code for {cmd:.z}           +127   (0x7f)

	    {cmd:int}
		minimum nonmissing    -32767 (0x8000)
		maximum nonmissing    +32740 (0x7fe4)
		code for {cmd:.}            +32741 (0x7fe5)
		code for {cmd:.a}           +32742 (0x7fe6)
		code for {cmd:.b}           +32743 (0x7fe7)
		...
		code for {cmd:.z}           +32767 (0x7fff)

	    {cmd:long}
		minimum nonmissing    -2,147,483,647  (0x80000000)
		maximum nonmissing    +2,147,483,620  (0x7fffffe4)
		code for {cmd:.}            +2,147,483,621  (0x7fffffe5)
		code for {cmd:.a}           +2,147,483,622  (0x7fffffe6)
		code for {cmd:.b}           +2,147,483,623  (0x7fffffe7)
		...
		code for {cmd:.z}           +2,147,483,647  (0x7fffffff)

	    {cmd:float}
		minimum nonmissing    -1.701e+38  (-1.fffffeX+7e)  {it:(sic)}
		maximum nonmissing    +1.701e+38  (+1.fffffeX+7e)
		code for {cmd:.}                        (+1.000000X+7f)
		code for {cmd:.a}                       (+1.001000X+7f)
		code for {cmd:.b}                       (+1.002000X+7f)
		...
		code for {cmd:.z}                       (+1.01a000X+7f)

	    {cmd:double}
		minimum nonmissing    -1.798e+308 (-1.fffffffffffffX+3ff)
		maximum nonmissing    +8.988e+307 (+1.fffffffffffffX+3fe)
		code for {cmd:.}                        (+1.0000000000000X+3ff)
		code for {cmd:.a}                       (+1.0010000000000X+3ff)
		code for {cmd:.b}                       (+1.0020000000000X+3ff)
		...
		code for {cmd:.z}                       (+1.01a0000000000X+3ff)

{pmore}
Note that for {cmd:float}, all {it:z}>1.fffffeX+7e, and for {cmd:double}, all
{it:z}>1.fffffffffffffX+3fe are considered to be missing values and it is
merely a subset of the values that are labeled {cmd:.}, {cmd:.a}, {cmd:.b},
..., {cmd:.z}.  For example, a value between {cmd:.a} and {cmd:.b} is still
considered to be missing and, in particular, all the values between {cmd:.a}
and {cmd:.b} are known jointly as {cmd:.a_}.  Nevertheless, the recording of
those values should be avoided.

{pmore}
In the table above, we have used the
{c -(}{cmd:+}|{cmd:-}{c )-}{cmd:1.}{it:<digits>}{cmd:X}{c -(}{cmd:+}|{cmd:-}{c )-}{it:<digits>}
notation.  The number to the left of the {cmd:X} is to be interpreted as a
base-16 number (the period is thus the base-16 point) and the number to the
right (also recorded in base 16) is to be interpreted as the power of 2
{it:(sic)}.  For example,

	    1.01aX+3ff = (1.01a) * 2^(3ff)                        (base 16)
		       = (1 + 0/16 + 1/16^2 + 10/16^3) * 2^1023   (base 10)

{pmore}
The
{c -(}{cmd:+}|{cmd:-}{c )-}{cmd:1.}{it:<digits>}{cmd:X}{c -(}{cmd:+}|{cmd:-}{c )-}{it:<digits>}
notation easily converts to IEEE 8-byte double:
the {cmd:1} is the hidden bit, the digits to the right of the hexadecimal
point are the mantissa bits, and the exponent is the IEEE exponent in signed
(removal of offset) form.
For instance, pi = 3.1415927... is

					    8-byte IEEE, HILO
					 {hline 23}
	    pi = +1.921fb54442d18X+001 = 40 09 21 fb 54 44 2d 18

				       = 18 2d 44 54 fb 21 09 40
					 {hline 23}
					    8-byte IEEE, LOHI

{pmore}
Converting
{c -(}{cmd:+}|{cmd:-}{c )-}{cmd:1.}{it:<digits>}{cmd:X}{c -(}{cmd:+}|{cmd:-}{c )-}{it:<digits>}
to IEEE 4-byte float is more difficult, but the same rule applies:  the
{cmd:1} is the hidden bit, the digits to the right of the hexadecimal point
are the mantissa bits, and the exponent is the IEEE exponent in signed
(removal of offset) form.  What makes it more difficult is that the
sign-and-exponent in the IEEE 4-byte format occupy 9 bits, which is not
divisible by four, and so everything is shifted one bit.  In float:

				      4-byte IEEE, HILO
					 {hline 11}
	    pi = +1.921fb60000000X+001 = 40 49 0f db

				       = db of 49 40
					 {hline 11}
				      4-byte IEEE, LOHI

{pmore}
The easiest way to obtain the above result is to first convert
+1.921fb60000000X+001 to an 8-byte double and then convert the 8-byte double
to a 4-byte float.

{pmore}
In any case, the relevant numbers are

	    V            value                HILO             LOHI
	    {hline 63}
	    m    -1.fffffffffffffX+3ff   ffefffffffffffff  ffffffffffffefff
	    M    +1.fffffffffffffX+3fe   7fdfffffffffffff  ffffffffffffdf7f
	    {cmd:.}    +1.0000000000000X+3ff   7fe0000000000000  000000000000e07f
	    {cmd:.a}   +1.0010000000000X+3ff   7fe0010000000000  000000000001e07f
	    {cmd:.b}   +1.0020000000000X+3ff   7fe0020000000000  000000000002e07f
	    {cmd:.z}   +1.01a0000000000X+3ff   7fe01a0000000000  00000000001ae07f

	    m    -1.fffffeX+7e           feffffff          fffffffe
	    M    +1.fffffeX+7e           7effffff          ffffff7e
	    {cmd:.}    +1.000000X+7f           7f000000          0000007f
	    {cmd:.a}   +1.001000X+7f           7f000800          0008007f
	    {cmd:.b}   +1.002000X+7f           7f001000          0010007f
	    {cmd:.z}   +1.01a000X+7f           7f00d000          00d0007f
	    {hline 63}


{marker definition}{...}
{title:5.  Dataset format definition}

{pstd}
Stata-format datasets contain five components, which are, in
order,

	1.  Header
	2.  Descriptors
	3.  Variable Labels
	4.  Expansion Fields
	5.  Data
	6.  Value Labels


{marker header}{...}
{title:5.1  Header}

{pstd}
The Header is defined as

	Contents            Length    Format    Comments
	{hline}
	{cmd:ds_format}                1    byte      contains 114 = 0x72
	{cmd:byteorder}                1    byte      0x01 -> HILO, 0x02 -> LOHI
	{cmd:filetype}                 1    byte      0x01
	unused                   1    byte      0x00
	{cmd:nvar} (number of vars)    2    int       encoded per {cmd:byteorder}
	{cmd:nobs} (number of obs)     4    int       encoded per {cmd:byteorder}
	{cmd:data_label}              81    char      dataset label, \0 terminated
	{cmd:time_stamp}              18    char      date/time saved, \0 terminated
	{hline}
	Total                  109


{pstd}
{cmd:time_stamp[17]} must be set to binary zero.  When writing a dataset, you
may record the time stamp as blank {cmd:time_stamp[0]}=\0), but you must still
set {cmd:time_stamp[17]} to binary zero as well.  If you choose to write a
time stamp, its format is

	{it:dd Mon yyyy hh}{cmd::}{it:mm}

{pstd}
{it:dd} and {it:hh} may be written with or without leading zeros, but if
leading zeros are suppressed, a blank must be substituted in their place.


{marker descriptors}{...}
{title:5.2  Descriptors}

{pstd}
The Descriptors are defined as

	Contents            Length    Format       Comments
	{hline}
	{cmd:typlist}               {cmd:nvar}    byte array
	{cmd:varlist}            33*{cmd:nvar}    char array
	{cmd:srtlist}          2*({cmd:nvar}+1)   int array    encoded per {cmd:byteorder}
	{cmd:fmtlist}            49*{cmd:nvar}    char array
	{cmd:lbllist}            33*{cmd:nvar}    char array
	{hline}


{pstd}
{cmd:typlist} stores the type of each variable, 1, ..., nvar.
The types are encoded:

		type          code
		{hline 20}
		{cmd:str1}        1 = 0x01
		{cmd:str2}        2 = 0x02
		...
		{cmd:str244}    244 = 0xf4
		{cmd:byte}      251 = 0xfb  {it:(sic)}
		{cmd:int}       252 = 0xfc
		{cmd:long}      253 = 0xfd
		{cmd:float}     254 = 0xfe
		{cmd:double}    255 = 0xff
		{hline 20}

{pstd}
Stata stores five numeric types:  {cmd:double}, {cmd:float}, {cmd:long},
{cmd:int}, and {cmd:byte}.  If {cmd:nvar}==4, a {cmd:typlist} of 0xfcfffdfe
indicates that variable 1 is an {cmd:int}, variable 2 a {cmd:double}, variable
3 a {cmd:long}, and variable 4 a {cmd:float}.  Types above 0x01 through 0xf4
are used to represent strings.  For example, a string with maximum length 8
would have type {cmd:0x08}.  If {cmd:typlist} is read into the C-array
{cmd:char} {cmd:typlist[]}, then {cmd:typlist[i-1]} indicates the type of
variable {cmd:i}.

{pstd}
{cmd:varlist} contains the names of the Stata variables 1, ..., {cmd:nvar},
each up to 32 characters in length, and each terminated by a binary zero (\0).
For instance, if {cmd:nvar}==4,

	0       33        66          99
	|        |         |           |
	{cmd:vbl1\0...myvar\0...thisvar\0...lstvar\0...}


{pstd}
would indicate that variable 1 is named {cmd:vbl1}, variable 2
{cmd:myvar}, variable 3 {cmd:thisvar}, and variable 4 {cmd:lstvar}.  The byte
positions indicated by periods will contain random numbers (and note that we
have omitted some of the periods).  If {cmd:varlist} is read into the C-array
{cmd:char} {cmd:varlist[]}, then {cmd:&varlist[(i-1)*33]} points to the name
of the {cmd:i}th variable.

{pstd}
{cmd:srtlist} specifies the sort-order of the dataset and is terminated by an
(int) 0.  Each 2 bytes is 1 int and contains either a variable number
or zero.  The zero marks the end of the {cmd:srtlist}, and the array positions
after that contain random junk.  For instance, if the data are not sorted, the
first int will contain a zero and the ints thereafter will contain junk.  If
{cmd:nvar}==4, the record will appear as

	{cmd:0000................}

{pstd}
If the dataset is sorted by one variable {cmd:myvar} and if that variable
is the second variable in the {cmd:varlist}, the record will appear as

	{cmd:00020000............}  (if {cmd:byteorder}==HILO)
	{cmd:02000000............}  (if {cmd:byteorder}==LOHI)

{pstd}
If the dataset is sorted by {cmd:myvar} and within {cmd:myvar} by {cmd:vbl1},
and if {cmd:vbl1} is the first variable in the dataset, the record will appear
as

	{cmd:000200010000........}  (if {cmd:byteorder}==HILO)
	{cmd:020001000000........}  (if {cmd:byteorder}==LOHI)


{pstd}
If {cmd:srtlist} were read into the C-array {cmd:short} {cmd:int}
{cmd:srtlist[]}, then {cmd:srtlist[0]} would be the number of the first sort
variable or, if the data were not sorted, 0.  If the number is not zero,
{cmd:srtlist[1]} would be the number of the second sort variable or, if there
is not a second sort variable, 0, and so on.

{pstd}
{cmd:fmtlist} contains the formats of the variables 1, ..., {cmd:nvar}.  Each
format is 49 bytes long and includes a binary zero end-of-string marker.  For
instance,

	{cmd:%9.0f\0..........................................%8.2f\0......}
	{cmd:....................................%20.0g\0..................}
	{cmd:.......................%td\0..................................}
	{cmd:..........%tcDDmonCCYY_HH:MM:SS.sss\0......................}

{pstd}
indicates that variable 1 has a {cmd:%9.0f} format, variable 2 a {cmd:%8.2f}
format, variable 3 a {cmd:%20.0g} format, and so on.  Note that these are
Stata formats, not C formats.

{phang2}
1.  Formats beginning with {cmd:%t} or {cmd:%-t} are Stata's date and time
    formats.

{phang2}
2.  Stata has an old {cmd:%}{cmd:d} format notation and some datasets 
    still have them.  Format {cmd:%}{cmd:d}... is equivalent to 
    modern format {cmd:%td}... and {cmd:%}{cmd:-}{cmd:d}... is 
    equivalent to {cmd:%-td}... 

{phang2}
3.  Nondate formats ending in {cmd:gc} or {cmd:fc} are similar to C's {cmd:g}
    and {cmd:f} formats, but with commas.  Most translation routines would
    ignore the ending {cmd:c} (change it to {cmd:\0}).

{phang2}
4.  Formats may contain commas rather than period, such as {cmd:%9,2f},
    indicating European format.

{pstd}
If {cmd:fmtlist} is read into the C-array {cmd:char} {cmd:fmtlist[]}, then
{cmd:&fmtlist[49*(i-1)]} refers to the starting address of the format for the
{cmd:i}th variable.

{pstd}
{cmd:lbllist} contains the names of the value formats associated with the
variables 1, ..., {cmd:nvar}.  Each value-format name is 33 bytes long and
includes a binary zero end-of-string marker.  For instance,

	0   33        66   99
	|    |         |    |
	{cmd:\0...yesno\0...\0...yesno\0...}

{pstd}
indicates that variables 1 and 3 have no value label associated with them,
whereas variables 2 and 4 are both associated with the value label named
{cmd:yesno}.  If {cmd:lbllist} is read into the C-array {cmd:char}
{cmd:lbllist[]}, then {cmd:&lbllist[33*(i-1)]} points to the start of the
label name associated with the {cmd:i}th variable.


{marker variable_labels}{...}
{title:5.3  Variable labels}

{pstd}
The Variable Labels are recorded as

	Contents            Length    Format     Comments
	{hline 54}
	Variable 1's label      81    char       \0 terminated
	Variable 2's label      81    char       \0 terminated
	...
	Variable {cmd:nvar}'s label   81    char       \0 terminated
	{hline 54}
	Total              81*{cmd:nvar}

{pstd}
If a variable has no label, the first character of its label is \0.


{marker expansion_fields}{...}
{title:5.4  Expansion fields}

{pstd}
The Expansion Fields are recorded as

	Contents            Length    Format     Comments
	{hline 68}
	data type                1    byte       coded, only 0 and 1 defined
	len                      4    int        encoded per {cmd:byteorder}
	contents               len    varies

	data type                1    byte       coded, only 0 and 1 defined
	len                      4    int        encoded per {cmd:byteorder}
	contents               len    varies

	data type                1    byte       code 0 means end
	len                      4    int        0 means end
	{hline 68}

{pstd}
Expansion fields conclude with code 0 and len 0; before the termination
marker, there may be no or many separate data blocks.
Expansion fields are used to record information that is unique to
Stata and has no equivalent in other data management packages.
Expansion fields are always optional when writing data and, generally,
programs reading Stata datasets will want to ignore the expansion fields.
The format makes this easy.  When writing, write 5 bytes of zeros for this
field.  When reading, read five bytes; the last four bytes now tell you the
size of the next read, which you discard.  You then continue like this until
you read 5 bytes of zeros.

{pstd}
The only expansion fields currently defined are type 1 records for variable's
{help char:characteristics}.  The design, however, allows new types of
expansion fields to be included in subsequent releases of Stata without
changes in the data format because unknown expansion types can simply be
skipped.

{pstd}
For those who care, the format of type 1 records is a binary-zero terminated
variable name in bytes 0-32, a binary-zero terminated characteristic name in
bytes 33-65, and a binary-zero terminated string defining the contents in
bytes 66 through the end of the record.


{marker data}{...}
{title:5.5  Data}

{pstd}
The Data are recorded as

	Contents                  Length         Format
	{hline 47}
	obs 1, var 1         per {cmd:typlist}    per {cmd:typlist}
	obs 1, var 2         per {cmd:typlist}    per {cmd:typlist}
	...
	obs 1, var {cmd:nvar}      per {cmd:typlist}    per {cmd:typlist}

	obs 2, var 1         per {cmd:typlist}    per {cmd:typlist}
	obs 2, var 2         per {cmd:typlist}    per {cmd:typlist}
	...
	obs 2, var {cmd:nvar}      per {cmd:typlist}    per {cmd:typlist}
	.
	.
	obs {cmd:nobs}, var 1      per {cmd:typlist}    per {cmd:typlist}
	obs {cmd:nobs}, var 2      per {cmd:typlist}    per {cmd:typlist}
	...
	obs {cmd:nobs}, var {cmd:nvar}   per {cmd:typlist}    per {cmd:typlist}
	{hline 47}

{pstd}
The data are written as all the variables on the first observation, followed
by all the data on the second observation, and so on.  Each variable is
written in its own internal format, as given in {cmd:typlist}.  All values are
written per {cmd:byteorder}.  Strings are null terminated if they are shorter
than the allowed space, but they are not terminated if they occupy the full
width.

{pstd}
End-of-file may occur at this point.  If it does, there are no value labels to
be read.  End-of-file may similarly occur between value labels.  On end-of-file,
all data have been processed.


{marker value_labels}{...}
{title:5.6  Value labels}

{pstd}
If there are no value labels, end-of-file will have occurred while reading the
data.  If there are value labels, each value label is written as

	Contents               len   format     comment
	{hline 67}
	{cmd:len}                      4   int        length of {cmd:value_label_table}
	{cmd:labname}                 33   char       \0 terminated
	padding                  3
	{cmd:value_label_table}      {cmd:len}              see next table
	{hline 67}

{pstd}
and this is repeated for each value label included in the file.
The format of the {cmd:value_label_table} is

	Contents               len   format     comment
	{hline 58}
	{cmd:n}                        4   int        number of entries
	{cmd:txtlen}                   4   int        length of {cmd:txt[]}
	{cmd:off[]}                  4*{cmd:n}   int array  {cmd:txt[]} offset table
	{cmd:val[]}                  4*{cmd:n}   int array  sorted value table
	{cmd:txt[]}               {cmd:txtlen}   char       text table
	{hline 58}

{pstd}
{cmd:len}, {cmd:n}, {cmd:txtlen}, {cmd:off[]}, and {cmd:val[]} are encoded per
{cmd:byteorder}.  The maximum length of {cmd:txt[]} for a label is 32,000
characters.  Stata is robust to datasets which might contain labels longer
than this; labels which exceed the limit, if any, will be dropped
during a {helpb use}.

{pstd}
For example, the {cmd:value_label_table} for 1<->yes and 2<->no, shown in HILO
format, would be

	byte position:  00 01 02 03   04 05 06 07   08 09 10 11   12 13 14 15
	     contents:  00 00 00 02   00 00 00 07   00 00 00 00   00 00 00 04
	      meaning:        n = 2    txtlen = 7    off[0] = 0    off[1] = 4

	byte position:  16 17 18 19   20 21 22 23   24 25 26 27 28 29 30
	     contents:  00 00 00 01   00 00 00 02    y  e  s 00  n  o 00
	      meaning:   val[0] = 1    val[1] = 2    txt --->

{pstd}
The interpretation is that there are {cmd:n}=2 values being mapped.
The values being mapped are {cmd:val[0]}=1 and {cmd:val[1]}=2.
The corresponding text for {cmd:val[0]} would be at {cmd:off[0]}=0
(and so be "{cmd:yes}") and for {cmd:val[1]} would be at
{cmd:off[1]}=4 (and so be "{cmd:no}").

{pstd}
Interpreting this table in C is not as daunting as it appears.  Let
{cmd:(char *) p} refer to the memory area into which {cmd:value_label_table}
is read.  Assume your compiler uses 4-byte {cmd:int}s.  The following
manifests make interpreting the table easier:

	{cmd}#define SZInt               4
	#define Off_n               0
	#define Off_nxtoff          SZInt
	#define Off_off             (SZInt+SZInt)
	#define Off_val(n)          (SZInt+SZInt+n*SZInt)
	#define Off_txt(n)          (Off_val(n) + n*SZInt)
	#define Len_table(n,nxtoff) (Off_txt(n) + nxtoff)

	#define Ptr_n(p)            ( (int *) ( ((char *) p) + Off_n ) )
	#define Ptr_nxtoff(p)       ( (int *) ( ((char *) p) + Off_nxtoff ) )
	#define Ptr_off(p)          ( (int *) ( ((char *) p) + Off_off ) )
	#define Ptr_val(p,n)        ( (int *) ( ((char *) p) + Off_val(n) ) )
	#define Ptr_txt(p,n)        ( (char *) ( ((char *) p) + Off_txt(n) ) ){txt}

{pstd}
It is now the case that {cmd:for(i=0; i < *Ptr_n(p); i++)},
the value {cmd:*Ptr_val(p,i)} is mapped to the character string
{cmd:Ptr_txt(p,i)}.

{pstd}
Remember in allocating memory for {cmd:*p} that the table can be big.  The
limits are {cmd:n}=65,536 mapped values with each value being up to 81
characters long (including the null terminating byte).  Such a table would be
5,823,712 bytes long.  No user is likely to approach that limit and, in any
case, after reading the 8 bytes preceding the table ({cmd:n} and
{cmd:txtlen}), you can calculate the remaining length as
2*4*{cmd:n}+{cmd:txtlen} and {cmd:malloc()} the exact amount.

{pstd}
Constructing the table is more difficult.  The easiest approach is to set
arbitrary limits equal to or smaller than Stata's as to the maximum number of
entries and total text length you will allow and simply declare the three
pieces {cmd:off[]}, {cmd:val[]}, and {cmd:txt[]} according to
those limits:

	{cmd}int off[MaxValueForN] ;
	int val[MaxValueForN] ;
	char txt[MaxValueForTxtlen] ;{txt}

{pstd}
Stata's internal code follows a more complicated strategy of always keeping
the table in compressed form and having a routine that will "add one position"
in the table.  This is slower but keeps memory requirements to be no more than
the actual size of the table.

{pstd}
In any case, when adding new entries to the table, remember that {cmd:val[]}
must be in ascending order:  {cmd:val[0]} < {cmd:val[1]} < ... < {cmd:val[n]}.

{pstd}
It is not required that {cmd:off[]} or
{cmd:txt[]} be kept in ascending order.  We previously offered the example of
the table that mapped 1<->yes and 2<->no:

	byte position:  00 01 02 03   04 05 06 07   08 09 10 11   12 13 14 15
	     contents:  00 00 00 02   00 00 00 07   00 00 00 00   00 00 00 04
	      meaning:        n = 2    txtlen = 7    off[0] = 0    off[1] = 4

	byte position:  16 17 18 19   20 21 22 23   24 25 26 27 28 29 30
	     contents:  00 00 00 01   00 00 00 02    y  e  s 00  n  o 00
	      meaning:   val[0] = 1    val[1] = 2    txt --->

{pstd}
This table could just as well be recorded as

	byte position:  00 01 02 03   04 05 06 07   08 09 10 11   12 13 14 15
	     contents:  00 00 00 02   00 00 00 07   00 00 00 03   00 00 00 00
	      meaning:        n = 2    txtlen = 7    off[0] = 3    off[1] = 0

	byte position:  16 17 18 19   20 21 22 23   24 25 26 27 28 29 30
	     contents:  00 00 00 01   00 00 00 02    n  o 00  y  e  s 00
	      meaning:   val[0] = 1    val[1] = 2    txt --->

{pstd}
but it could not be recorded as

	byte position:  00 01 02 03   04 05 06 07   08 09 10 11   12 13 14 15
	     contents:  00 00 00 02   00 00 00 07   00 00 00 04   00 00 00 00
	      meaning:        n = 2    txtlen = 7    off[0] = 4    off[1] = 0

	byte position:  16 17 18 19   20 21 22 23   24 25 26 27 28 29 30
	     contents:  00 00 00 02   00 00 00 01    y  e  s 00  n  o 00
	      meaning:   val[0] = 2    val[1] = 1    txt --->

{pstd}
It is not the out-of-order values of {cmd:off[]} that cause problems; it is
out-of-order values of {cmd:val[]}.  In terms of table construction, we find
it easier to keep the table sorted as it grows.  This way one can use a binary
search routine to find the appropriate position in {cmd:val[]} quickly.

{pstd}
The following routine will find the appropriate slot.  It uses the manifests
we previously defined and thus it assumes the table is in compressed form, but
that is not important.  Changing the definitions of the manifests to point to
separate areas would be easy enough.

	{cmd}/*
	    slot = vlfindval(char *baseptr, int val)

	    Looks for value val in label at baseptr.
		If found:
			returns slot number:  0, 1, 2, ...
		If not found:
			returns k<0 such that val would go in slot -(k+1)
				k== -1        would go in slot 0.
				k== -2        would go in slot 1.
				k== -3        would go in slot 2.
	*/

	int vlfindval(char *baseptr, int myval)
	{c -(}
		int	n ;
		int	lb, ub, try ;
		int	*val ;
		char    *txt ;
		int	*off ;
		int	curval ;

		n   = *Ptr_n(baseptr) ;
		val =  Ptr_val(baseptr, n) ;

		if (n==0) return(-1) ;  /* not found, insert into 0 */

					/* in what follows,		   */
					/* we know result between [lb,ub   */
					/* or it is not in the table	   */
		lb = 0 ;
		ub = n - 1 ;
		while (1) {c -(}
			try = (lb + ub) / 2 ;
			curval = val[try] ;
			if (myval == curval) return(try) ;
			if (myval<curval) {c -(}
				ub = try - 1 ;
				if (ub<lb) return(-(try+1)) ;
				/* because want to insert before try, ergo,
			   	want to return try, and transform is -(W+1). */
			{c )-}
			else /* myval>curval */ {c -(}
				lb = try + 1 ;
				if (ub<lb) return(-(lb+1)) ;
				/* because want to insert after try, ergo,
			   	want to return try+1 and transform is -(W+1) */
			{c )-}
		{c )-}
		/*NOTREACHED*/
	{c )-}{txt}

{pstd}
For earlier documentation, see {help dta_113}.
{p_end}
