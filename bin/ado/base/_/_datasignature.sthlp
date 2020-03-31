{smcl}
{* *! version 2.1.7  19oct2017}{...}
{vieweralsosee "[P] _datasignature" "mansection P _datasignature"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] datasignature" "help datasignature"}{...}
{vieweralsosee "[P] signestimationsample" "help signestimationsample"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] cf" "help cf"}{...}
{vieweralsosee "[D] compare" "help compare"}{...}
{viewerjumpto "Syntax" "_datasignature##syntax"}{...}
{viewerjumpto "Description" "_datasignature##description"}{...}
{viewerjumpto "Links to PDF documentation" "_datasignature##linkspdf"}{...}
{viewerjumpto "Options" "_datasignature##options"}{...}
{viewerjumpto "Remarks" "_datasignature##remarks"}{...}
{viewerjumpto "Stored results" "_datasignature##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[P] _datasignature} {hline 2}}Determine whether data have changed
{p_end}
{p2col:}({mansection P _datasignature:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmdab:_datasig:nature}
[{it:{help varlist}}]
[{it:{help if}}]
[{it:{help in}}]
[{cmd:,} {it:options}]


{synoptset 11}{...}
{synopthdr}
{synoptline}
{synopt:{opt f:ast}}perform calculation in machine-dependent way{p_end}
{synopt:{opt e:sample}}restrict to estimation sample{p_end}
{synopt:{opt non:ames}}do not include checksum for variable names{p_end}
{synopt:{opt nod:efault}}treat empty {varlist} as null{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_datasignature} calculates, displays, and stores in
{cmd:r(_datasignature)} checksums of the data, forming a signature.  A
signature might be

	162:11(12321):2725060400:4007406597

{pstd}
The signature can be stored and later used to determine whether the data have
changed.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P _datasignatureRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{p 4 8 2}
{cmd:fast} 
    specifies that the checksum calculation be made in a faster, less
    computationally intensive, and machine-dependent way.  With this option,
    {cmd:_datasignature} runs faster on all computers and can run in less than
    one-third of the time on some computers.  The result can be compared with
    other {cmd:fast} computations made on the same computer, and computers of
    the same make, but not across computers of different makes.  See
    {it:{help _datasignature##remarks:Remarks}} below.

{p 4 8 2}
{cmd:esample} 
    specifies that the checksum be calculated on the data for which
    {cmd:e(sample)} = 1.  Coding

{p 12 12 2}
        {cmd:_datasignature `varlist', esample}

{p 8 8 2}
    or

{p 12 12 2}
        {cmd:_datasignature `varlist' if e(sample)}

{p 8 8 2}
    produces the same result.  The former is a little quicker.
    If the {cmd:esample} option is specified, {cmd:if} {it:exp} may not be
    specified.

{p 4 8 2}
{cmd:nonames}
    specifies that the variable-names checksum in the signature be omitted.
    Rather than the signature being 74:12(71728):2814604011:3381794779, 
    it would be 74:12:2814604011:3381794779.  This option is useful when 
    you do not care about the names or you know that the names have changed,
    such as when using temporary variables.

{p 4 8 2}
{cmd:nodefault} 
    specifies that when {varlist} is not specified, it be taken to 
    mean no variables rather than all variables in the dataset.
    Thus you may code 

{p 12 12 2}
	{cmd:_datasignature `modelvars', nodefault}

{p 8 8 2}
    and obtain desired results even if {cmd:`modelvars'} expands to
    nothing.


{marker remarks}{...}
{title:Remarks}

{pstd}
For an introduction to data signatures, see 
{bf:{help datasignature:[D] datasignature}}.
To briefly summarize:

{p 8 12 2}
o  A signature is a short string that is calculated from a dataset, 
    such as 74:12(71728):3831085005:1395876116.
    If a dataset has the same signature at two different times, 
    then it is highly likely that the data have not changed.
    If a dataset has a different signature, 
    then it is certain that the data have changed.

{p 8 12 2}
o  An example data signature is 74:12(71728):3831085005:1395876116.
    The components are

{p 12 16 2}
a.  {cmd:74}, the number of observations;

{p 12 16 2}
b.  {cmd:12}, the number of variables;

{p 12 16 2}
c.  {cmd:71728}, a checksum function of the variable names and the 
    order in which they occur; and

{p 12 16 2}
d.  {cmd:3831085005} and {cmd:1395876116}, checksum functions of 
    the values of the variables, calculated two different ways.

{p 8 12 2}
o  Signatures are functions of

{p 12 16 2}
a.  the number of observations and number of variables in the data;

{p 12 16 2}
b.  the values of the variables;

{p 12 16 2}
c.  the names of the variables;

{p 12 16 2}
d.  the order in which the variables occur in the dataset if {it:varlist} 
    is not specified, or in {it:varlist} if it is; and

{p 12 16 2}
e.  the storage types of the variables.

{p 12 12 2}
If any of these change, the signature changes.
The signature is not a function of the sort order of the data.
The signature is not a function of variable labels, value labels, 
contents of characteristics, and the like.

{p 4 4 2}
Programs sometimes need to verify that they are running on the same data at
two different times.  This verification is
especially common with estimation commands,
where the estimation is performed by one command and postestimation analyses
by another.  To ensure that
the data have not changed, one obtains the signature at
the time of estimation and then compares that with the signature obtained when
the postestimation command is run.  See 
{bf:{help signestimationsample:[P] signestimationsample}} for an example.

{p 4 4 2}
If you are producing signatures for use within a Stata session -- signatures
that will not be written to disk and thus cannot possibly be transferred to
different computers -- specify
{cmd:_datasignature}'s {cmd:fast} option.  On some
computers, {cmd:_datasignature} can run in less than one-third of the time if
this option is specified.

{p 4 4 2}
{cmd:_datasignature, fast} is faster for two reasons:  the option uses a
less computationally intensive algorithm and the computation is made
in a machine-dependent way.  The first affects the quality of the signature,
and the second does not.

{p 4 4 2}
Remember that signatures have two checksums for the data.  When {cmd:fast} is
specified, a different, inferior algorithm is substituted for the second
checksum.  In the {cmd:fast} case, the second signature is not conditionally
independent of the first and thus does not provide 48 bits of additional
information; it probably provides around 24 bits.  The default
second checksum calculation was selected to catch problems that the first
calculation does not catch.  In the {cmd:fast} case, the second checksum does
not have that property.  These details make the {cmd:fast} signature sound
markedly inferior.  Nevertheless, the first checksum calculation, which is
used both in the default and the {cmd:fast} cases, is good, and when
{cmd:_datasignature} was written, we considered using only the first
calculation in both cases.  We believe that, for within-session testing, where
one does not have to guard against changes produced by an intelligent enemy
who may be trying to fool you, the first checksum alone is adequate.  The
inferior second checksum we include in the {cmd:fast} case provides more
protection than we think necessary.

{p 4 4 2}
The second difference has nothing to do with quality.
Modern computers come in two types:  those that record least-significant
bytes (LSBs) first and those that record most-significant bytes (MSBs) first.
Intel-based computers, for instance, are usually LSB, whereas Sun computers are
MSB.

{p 4 4 2}
By default, {cmd:_datasignature} makes the checksum calculation in an LSB way,
even on MSB computers.  MSB computers must therefore go to extra work to
emulate the LSB calculation, and so {cmd:_datasignature} runs slower on them.

{p 4 4 2}
When you specify {cmd:fast}, {cmd:_datasignature} calculates the checksum the
native way.  The checksum is every bit as good, but the checksum produced will
be different on MSB computers.  If you merely store the signature in
memory for use later in the session, however, that does not matter.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_datasignature} stores the following in {cmd:r()}:

	Macros
	    {cmd:r(datasignature)}         the signature
