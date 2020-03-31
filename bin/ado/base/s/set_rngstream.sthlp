{smcl}
{* *! version 1.0.7  05feb2019}{...}
{vieweralsosee "[R] set rngstream" "mansection R setrngstream"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] clear" "help clear"}{...}
{vieweralsosee "[FN] Random-number functions" "help random_number_functions"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{vieweralsosee "[R] set rng" "help set_rng"}{...}
{vieweralsosee "[R] set seed" "help set_seed"}{...}
{viewerjumpto "Syntax" "set_rngstream##syntax"}{...}
{viewerjumpto "Description" "set_rngstream##description"}{...}
{viewerjumpto "Links to PDF documentation" "set_rngstream##linkspdf"}{...}
{viewerjumpto "Remarks" "set_rngstream##remarks"}{...}
{viewerjumpto "Examples" "set_rngstream##examples"}{...}
{viewerjumpto "Reference" "set_rngstream##reference"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[R] set rngstream} {hline 2}}Specify the stream for the stream
random-number generator{p_end}
{p2col:}({mansection R setrngstream:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{marker rngstream}{...}
{cmd:set rngstream} {it:#}

{phang}
{it:#} is any integer between 1 and 32,767.


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:rngstream} specifies the subsequence, known as a stream, from
which Stata's stream random-number generator should draw random numbers.  
When performing a bootstrap estimation or a Monte Carlo simulation in
parallel on multiple machines, you should set the same seed on all machines
but set a different stream on each machine. This will ensure that random
numbers drawn on different machines are independent. We strongly recommend 
that you set the seed and the stream only once in each Stata session.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R setrngstreamRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Stata's stream random-number generator, the stream 64-bit Mersenne Twister 
({cmd:mt64s}), allows separate instances of Stata to simultaneously draw 
independent random numbers.  This feature enables you to use 
{helpb bootstrap} and to run Monte Carlo simulations in parallel on multiple 
machines.

{pstd}
What we call random numbers are elements in a sequence of deterministic numbers
that appear to be random.  A seed specifies a starting value in this sequence.

{pstd}
A stream random-number generator partitions a sequence of random numbers into
nonoverlapping subsequences known as streams.  The random numbers in each
stream are independent of those in other streams because they come from
distinct nonoverlapping subsets of the original sequence.

{pstd}
In contrast to nonstream random-number generators, setting the seed for a
random-number generator controls not just where the sequence starts but also
how the sequence is partitioned.

{pstd}
The {cmd:mt64s} generator is a stream version of Stata's default generator, 
the 64-bit Mersenne Twister implemented in {cmd:mt64}; see 
{help set rngstream##HM2008:Haramoto et al. (2008)} and
{helpb set rng} for more details.  Our implementation partitions the 
{cmd:mt64} sequence into 32,767 streams, each containing 2^128 
random numbers.  The remaining numbers are unused. The {cmd:mt64s} seed
determines the starting point of every stream in the Mersenne Twister
sequence.

{pstd}
Stream 1 of {cmd:mt64s} has the same starting point as the {cmd:mt64}
generator.  That is, given the same seed, {cmd:mt64s} with {cmd:rngstream} set
to 1 will generate the same random numbers as {cmd:mt64}.

{pstd}
The {cmd:mt64s} generator is designed to simultaneously draw independent
random numbers on different machines.  To draw from different streams that
guarantee independence, use the same seed and change the stream.  For example,
to draw some uniform(0,1) random numbers from stream 10 of the {cmd:mt64s}
generator under seed 123, type

{p 12 12 2}
{cmd:. set rng mt64s}

{p 12 12 2}
{cmd:. set rngstream 10}

{p 12 12 2}
{cmd:. set seed 123}

{p 12 12 2}
{cmd:. generate u = runiform()}

{pstd}
If we wanted to simultaneously draw some uniform(0,1) random numbers
on another machine from stream 11 of the {cmd:mt64s} generator, we would type

{p 12 12 2}
{cmd:. set rng mt64s}

{p 12 12 2}
{cmd:. set rngstream 11}

{p 12 12 2}
{cmd:. set seed 123}

{p 12 12 2}
{cmd:. generate u = runiform()}

{pstd}
Again, each seed creates a different partition of the {cmd:mt64} sequence
into nonoverlapping subsets

{pstd}
We strongly recommend that you set the stream and the seed once in each Stata 
session and draw numbers only from this stream.

{pstd}
{cmd:c(rngstream)} returns the current stream number.  {cmd:c(rngseed_mt64s)}
returns the last seed that was set for {cmd:mt64s}.  See {helpb creturn} for 
more details.  See {helpb set seed} for details about storing and restoring the
current position in the random sequence.

{pstd}
As with the single-stream generators, use {cmd:local state = c(rngstate)} to
store the current position in the current random stream; see {helpb set seed} 
for details.  The {cmd:mt64s} state encodes the seed used in addition to
the stream number, because the seed determines the position of every random
number in every stream.  Unlike the case of single-stream generators, restoring
the state also restores the seed.  For example, suppose you save an {cmd:mt64s}
state with {cmd:local state = c(rngstate)} change the seed and the stream, and
later restore that state with {cmd:set rngstate `state'}.  The current 
{cmd:mt64s} seed is changed to the one encoded in {cmd:state}. In addition to
changing the current stream to the one encoded in {cmd:state}, the current 
{cmd:mt64s} seed is changed to the one encoded in {cmd:state}.  This behavior 
ensures any subsequent stream changes draw from nonoverlapping subsets.

{pstd}
{cmd:set rngstream} also sets the {help set_rng:random-number generator}
to {cmd:mt64s}.


{marker examples}{...}
{title:Examples}

{pstd}Perform 100 bootstrap replications on machine 1{p_end}
{phang2}{cmd:. clear all}{p_end}
{phang2}{cmd:. webuse auto}{p_end}
{phang2}{cmd:. set rng mt64s}{p_end}
{phang2}{cmd:. set rngstream 1}{p_end}
{phang2}{cmd:. set seed 12345}{p_end}
{phang2}{cmd:. bootstrap, reps(100) saving(machine1, replace): regress mpg weight gear foreign}

{pstd}Perform 100 bootstrap replications on machine 2{p_end}
{phang2}{cmd:. clear all}{p_end}
{phang2}{cmd:. webuse auto}{p_end}
{phang2}{cmd:. set rng mt64s}{p_end}
{phang2}{cmd:. set rngstream 2}{p_end}
{phang2}{cmd:. set seed 12345}{p_end}
{phang2}{cmd:. bootstrap, reps(100) saving(machine2, replace): regress mpg weight gear foreign}

{pstd}After copying {cmd:machine2.dta} from machine 2 to the working directory
on machine 1, produce combined results{p_end}
{phang2}{cmd:. clear all}{p_end}
{phang2}{cmd:. use machine1}{p_end}
{phang2}{cmd:. append using machine2}{p_end}
{phang2}{cmd:. bstat}{p_end}


{marker reference}{...}
{title:Reference}

{marker HM2008}{...}
{phang}
Haramoto, H., M. Matsumoto, T. Nishimura, F. Panneton, and P. L'Ecuyer.
2008. Efficient jump ahead for F^2-linear random number generators.
{it:INFORMS Journal on Computing} 20: 385-390.
{p_end}
