{smcl}
{* *! version 1.1.5  19oct2017}{...}
{vieweralsosee "[R] set rng" "mansection R setrng"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FN] Random-number functions" "help random_number_functions"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{vieweralsosee "[R] set rngstream" "help set_rngstream"}{...}
{vieweralsosee "[R] set seed" "help set_seed"}{...}
{vieweralsosee "[P] version" "help version"}{...}
{viewerjumpto "Syntax" "set_rng##syntax"}{...}
{viewerjumpto "Description" "set_rng##description"}{...}
{viewerjumpto "Links to PDF documentation" "set_rng##linkspdf"}{...}
{viewerjumpto "Remarks" "set_rng##remarks"}{...}
{viewerjumpto "Reference" "set_rng##reference"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] set rng} {hline 2}}Set which random-number generator (RNG) to use{p_end}
{p2col:}({mansection R setrng:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:set}
{cmd:rng}
{c -(}{cmd:default} |
      {cmd:mt64} |
      {cmd:mt64s} |
      {cmd:kiss32}{c )-}


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:rng} determines which random-number generator (RNG) Stata's
{help random:random-number functions} and commands will use.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R setrngRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help set_rng##intro:Introduction}
        {help set_rng##rngs:Random-number generators in Stata}


{marker intro}{...}
{title:Introduction}

{pstd}
By default, Stata uses the 64-bit Mersenne Twister ({cmd:mt64}) RNG.
{cmd:mt64s} is a stream RNG based on the 64-bit Mersenne Twister.  Earlier
versions of Stata used the 32-bit KISS (keep it simple stupid) ({cmd:kiss32})
RNG.

{pstd}
With {cmd:set rng default} (the default), code running under
{help version:version control} will automatically use the appropriate
RNG -- {cmd:mt64} in Stata 14 and later and {cmd:kiss32} for earlier code.

{pstd}
The scope of {cmd:set rng} is the Stata session, do-file, or program in which
{cmd:rng} is set.

{pstd}
Unless you want to simultaneously draw random numbers in separate instances
of Stata, we recommend that you do not change Stata's default behavior for
its RNGs.  See {manhelp set_rngstream R:set rngstream} for an introduction to
simultaneously drawing random numbers in separate instances of Stata.

{pstd}
See {manhelp random_number_functions FN:Random-number functions},
{manhelp set_seed R:set seed}, and {manhelp set_rngstream R:set rngstream} for
more information.


{marker rngs}{...}
{title:Random-number generators in Stata}

{pstd}
The default RNG in Stata is the 64-bit Mersenne Twister.  See
{help set rng##MN1998:Matsumoto and Nishimura (1998)} for more details.  The
default RNG in Stata 13 and earlier versions was George Marsaglia's 32-bit
KISS generator (G. Marsaglia, 1994, pers. comm.).  The KISS generator is still
available under version control or via {cmd:set rng}.  Multiple independent
random-number streams (based on the 64-bit Mersenne Twister) are also
supported for use in multiple simultaneous instances of Stata; see
{manhelp set_rngstream R:set rngstream} for more information on this.  The
abbreviations {cmd:mt64}, {cmd:kiss32}, and {cmd:mt64s} are used,
respectively, to specify these three generators in Stata commands and
functions.

{pstd}
So far, we have discussed two ways you can specify the RNG: with {cmd:set rng}
and through version control.  Another way to specify the RNG is with functions
and system parameters explicitly named after the generators.  In fact, all
random-number functions have variants that are explicitly named after each
generator, using the generator abbreviation as the suffix.  For example,
{cmd:runiform_mt64()}, {cmd:runiform_kiss32()}, and {cmd:runiform_mt64s()} are
variants of {helpb runiform()} for each generator.  Similarly, we have
{cmd:rnormal_mt64()}, {cmd:rnormal_kiss32()}, {cmd:rnormal_mt64s()}, etc.

{pstd}
The system parameters {helpb seed} and {helpb rngstate} also have variants
explicitly named after each generator: {cmd:seed_mt64}, {cmd:seed_kiss32},
{cmd:seed_mt64s}, {cmd:rngstate_mt64}, {cmd:rngstate_kiss32}, and
{cmd:rngstate_mt64s}.

{pstd}
For example, here is how you can use functions and parameters specific to
{cmd:mt64} to set the seed, generate random numbers, preserve a state,
generate more numbers, and restore the previously preserved state:

{p 12 12 2}
       {cmd:. set seed_mt64 482637}

{p 12 12 2}
       {cmd:. generate u = runiform_mt64()}

{p 12 12 2}
       {cmd:. local state = c(rngstate_mt64)}

{p 12 12 2}
       {cmd:. generate l = rlogistic_mt64()}

{p 12 12 2}
       {cmd:. set rngstate_mt64 `state'}

{pstd}
Note that calling functions and setting parameters specific to, say,
{cmd:kiss32}, will not change the current RNG, the seed of the current RNG, or
the state of the current RNG -- unless the current RNG is {cmd:kiss32}.


{marker reference}{...}
{title:Reference}

{marker MN1998}{...}
{phang}
Matsumoto, M., and T. Nishimura. 1998. Mersenne Twister: A 623-dimensionally
equidistributed uniform pseudo-random number generator.
{it:ACM Transactions on Modeling and Computer Simulation} 8: 3-30.
{p_end}
