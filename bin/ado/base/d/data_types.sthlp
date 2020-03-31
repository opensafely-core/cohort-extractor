{smcl}
{* *! version 1.2.3  11may2018}{...}
{vieweralsosee "[D] Data types" "mansection D Datatypes"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] compress" "help compress"}{...}
{vieweralsosee "[D] destring" "help destring"}{...}
{vieweralsosee "[D] encode" "help encode"}{...}
{vieweralsosee "[D] format" "help format"}{...}
{vieweralsosee "[D] recast" "help recast"}{...}
{viewerjumpto "Description" "data types##description"}{...}
{viewerjumpto "Links to PDF documentation" "data_types##linkspdf"}{...}
{viewerjumpto "Remarks" "data types##remarks"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[D] Data types} {hline 2}}Quick reference for data types{p_end}
{p2col:}({mansection D Datatypes:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
This entry provides a quick reference for data types allowed by Stata.
See {findalias frdatatypes} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D DatatypesRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

           {space 46}Closest to
    Storage{space 46}0 without
    type                 Minimum              Maximum    being 0     bytes
    {hline 70}
    {opt byte}                    -127                  100    +/-1          1
    {opt int}                  -32,767               32,740    +/-1          2
    {opt long}          -2,147,483,647        2,147,483,620    +/-1          4
    {opt float}   -1.70141173319*10^38  1.70141173319*10^38    +/-10^-38     4
    {opt double}  -8.9884656743*10^307  8.9884656743*10^307    +/-10^-323    8
    {hline 70}
    Precision for {opt float}  is 3.795x10^-8.
    Precision for {opt double} is 1.414x10^-16.


    String
    storage{space 7}Maximum
    type          length         Bytes
    {hline 41}
    {cmd:str1}             1             1
    {cmd:str2}             2             2
     ...             .             .
     ...             .             .
     ...             .             .
    {cmd:str{ccl maxstrvarlen}}         {ccl maxstrvarlen}           {ccl maxstrvarlen}
    {cmd:strL}            {ccl maxstrlvarlen}     {ccl maxstrlvarlen}
    {hline 41}

{pstd}
Each element of data is said to be either type numeric or type string.  The word
"real" is sometimes used in place of numeric.  Associated with each data type
is a storage type.

{pstd}
Numbers are stored as {opt byte}, {opt int}, {opt long}, {opt float}, or
{opt double}, with the default being {opt float}.  {opt byte}, {opt int}, and
{opt long} are said to be of integer type in that they can hold only integers.

{pstd}
Strings are stored as {opt str}{it:#}, for instance, {opt str1}, {opt str2},
{opt str3}, ..., {cmd:str2045}, or as {opt strL}.  The number after the
{opt str} indicates the maximum length of the string.  A {opt str5} could hold
the word "male", but not the word "female" because "female" has six
characters.  A {opt strL} can hold strings of arbitrary lengths, up to
{ccl maxstrlvarlen} characters, and can even hold binary data containing
embedded {cmd:\0} characters.

{pstd}
Stata keeps data in memory, and you should record your data as parsimoniously
as possible.  If you have a string variable that has maximum length 6, it
would waste memory to store it as a {opt str20}.  Similarly, if you have an
integer variable, it would be a waste to store it as a {opt double}.


{title:Precision of numeric storage types}

{pstd}
{opt floats} have about 7 digits of accuracy; the magnitude of the number
does not matter.  Thus, 1234567 can be stored perfectly as a {opt float}, as
can 1234567e+20.  The number 123456789, however, would be rounded to 123456792.
In general, this rounding does not matter.

{pstd}
If you are storing identification numbers, the rounding could matter.
If the identification numbers are integers and take 9 digits or less, store
them as {opt long}s; otherwise, store them as {opt double}s.  {opt double}s
have 16 digits of accuracy.

{pstd}
Stata stores numbers in binary, and this has a second effect on numbers less
than 1.  1/10 has no perfect binary representation just as 1/11 has no perfect
decimal representation.  In {opt float}, .1 is stored as .10000000149011612.
Note that there are 7 digits of accuracy, just as with numbers larger than 1.
Stata, however, performs all calculations in double precision.  If you were to
store 0.1 in a {opt float} called {cmd:x} and then ask, say,
{cmd:list if x==.1}, there would be nothing in the list.  The .1 that you
just typed was converted to double, with 16 digits of accuracy
(.100000000000000014...), and that number is never equal to 0.1 stored with
{opt float} accuracy.

{pstd}
One solution is to type {cmd:list if x==float(.1)}.  The {helpb float()}
function rounds its argument to float accuracy.
The other alternative would be store your data as {opt double}, but this is
probably a waste of memory.  Few people have data that is accurate to 1 part in
10 to the 7th.  Among the exceptions are banks, who keep records accurate to
the penny on amounts of billions of dollars.  If you are dealing with such
financial data, store your dollar amounts as {opt double}s.
{p_end}
