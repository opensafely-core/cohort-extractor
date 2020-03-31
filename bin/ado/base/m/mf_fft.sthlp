{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] fft()" "mansection M-5 fft()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Mathematical" "help m4_mathematical"}{...}
{viewerjumpto "Syntax" "mf_fft##syntax"}{...}
{viewerjumpto "Description" "mf_fft##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_fft##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_fft##remarks"}{...}
{viewerjumpto "Conformability" "mf_fft##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_fft##diagnostics"}{...}
{viewerjumpto "Source code" "mf_fft##source"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-5] fft()} {hline 2}}Fourier transform
{p_end}
{p2col:}({mansection M-5 fft():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:complex vector}
{cmd:fft(}{it:numeric vector h}{cmd:)}

{p 8 12 2}
{it:numeric vector}
{cmd:invfft(}{it:numeric vector H}{cmd:)}


{p 8 12 2}
{it:void}{bind:         }
{cmd:_fft(}{it:complex vector h}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:_invfft(}{it:complex vector H}{cmd:)}


{p 8 12 2}
{it:numeric vector}
{cmd:convolve(}{it:numeric vector r}{cmd:,}
{it:numeric vector s}{cmd:)}

{p 8 12 2}
{it:numeric vector}
{cmd:deconvolve(}{it:numeric vector r}{cmd:,}
{it:numeric vector sm}{cmd:)}


{p 8 12 2}
{it:numeric vector}
{cmd:Corr(}{it:numeric vector g}{cmd:,}
{it:numeric vector h}{cmd:,}
{it:real scalar k}{cmd:)}


{p 8 12 2}
{it:real vector}{bind:   }
{cmd:ftperiodogram(}{it:numeric vector H}{cmd:)}


{p 8 12 2}
{it:numeric vector}
{cmd:ftpad(}{it:numeric vector h}{cmd:)}

{p 8 12 2}
{it:numeric vector}
{cmd:ftwrap(}{it:numeric vector r}{cmd:,}
{it:real scalar n}{cmd:)}

{p 8 12 2}
{it:numeric vector}
{cmd:ftunwrap(}{it:numeric vector H}{cmd:)}

{p 8 12 2}
{it:numeric vector}
{cmd:ftretime(}{it:numeric vector r}{cmd:,}
{it:numeric vector s}{cmd:)}

{p 8 12 2}
{it:real vector}{bind:   }
{cmd:ftfreqs(}{it:numeric vector H}{cmd:,}
{it:real scalar delta}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{it:H}={cmd:fft(}{it:h}{cmd:)}
and 
{it:h}={cmd:invfft(}{it:H}{cmd:)} 
calculate the Fourier transform and inverse Fourier transform.
The length of {it:H} and {it:h} must be a power of 2.

{p 4 4 2}
{cmd:_fft(}{it:h}{cmd:)}
and
{cmd:_invfft(}{it:H}{cmd:)} do the same thing, but they perform the 
calculation in place, replacing the contents of {it:h} and {it:H}.

{p 4 4 2}
{cmd:convolve(}{it:r}{cmd:,} {it:s}{cmd:)} 
returns the convolution of the signal {it:s} with the response function
{it:r}.  
{cmd:deconvolve(}{it:r}{cmd:,} {it:sm}{cmd:)}
deconvolves the smeared signal {it:sm} with the response function {it:r} and
is thus the inverse of {cmd:convolve()}.

{p 4 4 2}
{cmd:Corr(}{it:g}{cmd:,} {it:h}{cmd:,} {it:k}{cmd:)}
returns a 2{it:k}+1 element vector containing the correlations of {it:g} and
{it:h} for lags and leads as large as {it:k}.  

{p 4 4 2}
{cmd:ftperiodogram(}{it:H}{cmd:)} returns a real vector 
containing the one-sided periodogram of {it:H}.

{p 4 4 2}
{cmd:ftpad(}{it:h}{cmd:)} returns {it:h} padded with 0s to have a length
that is a power of 2.

{p 4 4 2}
{cmd:ftwrap(}{it:r}{cmd:,} {it:n}{cmd:)} 
converts the symmetrically stored response function
{it:r} into wraparound format of length {it:n},
{it:n}>={cmd:rows(}{it:r}{cmd:)*cols(}{it:r}{cmd:)} and
{cmd:rows(}{it:r}{cmd:)*cols(}{it:r}{cmd:)} odd.

{p 4 4 2}
{cmd:ftunwrap(}{it:H}{cmd:)} unwraps frequency-wraparound order as
returned by {cmd:fft()}.  You may find this useful when graphing or listing
results, but it is otherwise unnecessary.

{p 4 4 2}
{cmd:ftretime(}{it:r}{cmd:,} {it:s}{cmd:)} retimes the signal {it:s} to be on
the same time scale as {cmd:convolve(}{it:r}{cmd:,} {it:s}{cmd:)}.  This is
useful in graphing data and listing results but is otherwise not required.

{p 4 4 2}
{cmd:ftfreqs(}{it:H}{cmd:,} {it:delta}{cmd:)} 
returns a vector containing the frequencies associated with the elements of
{it:H}; {it:delta} is the sampling interval and is often specified as 1.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 fft()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_fft##remarks1:Definitions, notation, and conventions}
	{help mf_fft##remarks2:Fourier transform}
	{help mf_fft##remarks3:Convolution and deconvolution}
	{help mf_fft##remarks4:Correlation}
	{help mf_fft##remarks5:Utility routines}
	{help mf_fft##remarks6:Warnings}


{marker remarks1}{...}
{title:Definitions, notation, and conventions}

{p 4 4 2}
A signal {it:h} is a row or column vector containing real or complex elements.
The length of the signal is defined as the number of elements of the vector.
It is occasionally necessary to pad a signal to a given length.  This is
done by forming a new vector equal to the original and with zeros added to the
end.

{p 4 4 2}
The Fourier transform of a signal {it:h}, typically denoted by capital letter
{it:H} of {it:h}, is stored in frequency-wraparound order.  That is, if there
are {it:n} elements in {it:H}:

			{it:H}[1]            frequency 0
			{it:H}[2]            frequency 1 
			{it:H}[3]            frequency 2
			.
			{it:H}[{it:n}/2]          frequency {it:n}/2-1
			{it:H}[{it:n}/2+1]        frequency {it:n}/2 (-{it:n}/2, aliased)
			{it:H}[{it:n}/2+2]        frequency -({it:n}/2-1)
			.
			{it:H}[{it:n}-1]          frequency -2
			{it:H}[{it:n}]            frequency -1

{p 4 4 2}
All routines expect and use this order, but see
{helpb mf_fft##ftunwrap():ftunwrap()} below.

{p 4 4 2}
A response function {it:r} is a row or column vector containing
{it:m}=2{it:k}+1 real or complex elements.  {it:m} is called the duration of
the response function.  Response functions are generally stored symmetrically,
although the response function itself need not be symmetric.  The response
vector contains

		       {it:r}[1]             response at lag -{it:k}
		       {it:r}[2]             response at lag -{it:k}+1
		       .
		       {it:r}[{it:k}]             response at lag -1
		       {it:r}[{it:k}+1]           contemporaneous response 
		       {it:r}[{it:k}+2]           response at lead 1
		       {it:r}[{it:k}+3]           response at lead 2
		       .
		       {it:r}[2{it:k}+1]          response at lead {it:k}

{p 4 4 2}
Response functions always have odd lengths.  Response vectors are
never padded.

{p 4 4 2}
You may occasionally find it convenient to store a response vector in
"wraparound" order (similar to frequency-wraparound order), although none of
the routines here require this.  In wraparound order:

		    wrap[1]             contemporaneous response
		    wrap[2]             response at lead 1
		    wrap[3]             response at lead 2
		    .
		    wrap[{it:k}+1]           response at lead {it:k}
		    wrap[{it:k}+2]           response at lag -{it:k}
		    wrap[{it:k}+3]           response at lag -{it:k}+1
		    .
		    wrap[2{it:k}+1]          response at lag -1

{p 4 4 2}
Response vectors stored in wraparound order may be internally padded (as
opposed to merely padded) to a given length by the insertion of zeros between
wrap[{it:k}+1] and wrap[{it:k}+2].


{marker remarks2}{...}
{title:Fourier transform}

{p 4 4 2}
{cmd:fft(}{it:h}{cmd:)} returns the discrete Fourier transform of {it:h}.
{it:h} may be either real or complex, but its length must be a power of 2, 
so one typically codes {cmd:fft(ftpad(}{it:h}{cmd:))}; 
see {helpb mf_fft##ftpad():ftpad()}, below.  The returned result is
p-conformable with {it:h}.  The calculation is performed by {cmd:_fft()}.

{p 4 4 2}
{cmd:invfft(}{it:H}{cmd:)} returns the discrete inverse Fourier transform of
{it:H}.  {it:H} may be either real or complex, but its length must be a power
of 2.  The returned result is p-conformable with {it:H}.  The calculation is
performed by {cmd:_invfft()}.

{p 4 4 2}
{cmd:invfft(}{it:H}{cmd:)} may return a real or complex.  This
should be viewed as a feature, but if you wish to ensure the complex
interpretation, code {cmd:C(invfft(}{it:H}{cmd:))}.

{p 4 4 2}
{cmd:_fft(}{it:h}{cmd:)} is the built-in procedure that performs the 
fast Fourier transform in place.  {it:h} must be complex, and its length must
be a power of 2.

{p 4 4 2}
{cmd:_invfft(}{it:H}{cmd:)} is the built-in procedure that performs the
inverse fast Fourier transform in place.  {it:H} must be complex, and its
length must be a power of 2.


{marker remarks3}{...}
{title:Convolution and deconvolution}

{p 4 4 2}
{cmd:convolve(}{it:r}{cmd:,} {it:s}{cmd:)} 
returns the convolution of the signal {it:s} with the response function
{it:r}.  Calculation is performed by taking the {cmd:fft()} of the elements,
multiplying, and using {cmd:invfft()} to transform the results back.
Nevertheless, it is not necessary that the length of {it:s} be a power of 2.
{cmd:convolve()} handles all paddings necessary, including paddings to {it:s}
required to prevent the result from being contaminated by erroneous wrapping
around of {it:s}.  Although one thinks of the convolution operator as
being commutative, {cmd:convolve()} is not commutative since required
zero-padding of the response and signal differ.

{p 4 4 2}
If {it:n} is the length of the signal and 2{it:k}+1 is the length of the
response function, the returned result has length {it:n}+2{it:k}.  The first 
{it:k} elements are the convoluted signal before the true signal begins, and
the last {it:k} elements are the convoluted signal after the true signal ends.
See {helpb mf_fft##ftretime():ftretime()}, below.  In any case, you may be
interested only in the elements
{cmd:convolve()[|}{it:k}+1{cmd:\}{it:n}-{it:k}{cmd:|]}, the part
contemporaneous with {it:s}.

{p 4 4 2}
The returned vector is a row vector if {it:s} is a row vector and a column
vector otherwise.  The result is guaranteed to be real if both {it:r} and
{it:s} are real; the result may be complex or real, otherwise.

{p 4 4 2}
It is not required that the response function be shorter than the signal,
although this will typically be the case.


{p 4 4 2}
{cmd:deconvolve(}{it:r}{cmd:,} {it:sm}{cmd:)}
deconvolves the smeared signal {it:sm} with the response function {it:r} and
is thus the inverse of {cmd:convolve()}.  In particular,

		{cmd:deconvolve(}{it:r}{cmd:, convolve(}{it:r}{cmd:,}{it:s}{cmd:))} = {it:s}        (up to roundoff error)

{p 4 4 2}
Everything said about {cmd:convolve()} applies equally to {cmd:deconvolve()}.


{marker remarks4}{...}
{title:Correlation}

{p 4 4 2}
Here we refer to correlation in the signal-processing sense, not the 
statistical sense.

{p 4 4 2}
{cmd:Corr(}{it:g}{cmd:,} {it:h}{cmd:,} {it:k}{cmd:)}
returns a 2{it:k}+1 element vector containing the correlations of {it:g} and
{it:h} for lags and leads as large as {it:k}.  
For instance,
{cmd:Corr(}{it:g}{cmd:,} {it:h}{cmd:,} {cmd:2)} returns a five-element vector,
the first element of which contains the correlation for lag 2, the second
element lag 1, the third (middle) element the contemporaneous correlation, the
fourth element lead 1, and the fifth element lead 2.  {it:k} must be greater
than or equal to 1.  The returned vector is a row or column vector depending on
whether {it:g} is a row or column vector.  {it:g} and {it:h} must have the same
number of elements but need not be p-conformable.

{p 4 4 2}
The result is obtained by padding with zeros to avoid contamination, taking
the Fourier transform, multiplying {it:G}*conj({it:H}), and rearranging the
inverse transformed result.  Nevertheless, it is not required that the number
of elements of {it:g} and {it:h} be powers of 2 because the program pads
internally.


{marker remarks5}{...}
{title:Utility routines}

{marker ftpad()}{...}
{p 4 4 2}
{cmd:ftpad(}{it:h}{cmd:)} returns {it:h} padded with 0s to have a length
that is a power of 2.  For instance,

	: {cmd:h = (1,2,3,4,5)}

	: {cmd:ftpad(h)}
        {res}       {txt}1   2   3   4   5   6   7   8
            {c TLC}{hline 33}{c TRC}
          1 {c |}  {res}1   2   3   4   5   0   0   0{txt}  {c |}
            {c BLC}{hline 33}{c BRC}

{p 4 4 2}
If {it:h} is a row vector, a row vector is returned.  If {it:h} is a column
vector, a column vector is returned. 

{p 4 4 2}
{cmd:ftwrap(}{it:r}{cmd:,} {it:n}{cmd:)} 
converts the symmetrically stored response function
{it:r} into wraparound format of length {it:n},
{it:n}>={cmd:rows(}{it:r}{cmd:)*cols(}{it:r}{cmd:)} and
{cmd:rows(}{it:r}{cmd:)*cols(}{it:r}{cmd:)} odd.  A
symmetrically stored response function is a vector of odd length, for example:

			(.1, .5, 1, .2, .4)

{p 4 4 2}
The middle element of the vector represents the response function at lag 0.
Elements before the middle represent lags while elements after the
middle represent leads.  Here .1 is the response for lag 2 and .5 for
lag 1, 1 the contemporaneous response, .2 the response for lead 1, and .4 the
response for lead 2.  The wraparound format of a response function records the
response at times 0, 1, and so on in the first positions, has some number of
zeros, and then records the most negative time value of the response function,
and so on.

{p 4 4 2}
For instance,

	: {cmd:r}
        {res}       {txt} 1    2    3    4    5
            {c TLC}{hline 26}{c TRC}
          1 {c |}  {res}.1   .5    1   .2   .4{txt}  {c |}
            {c BLC}{hline 26}{c BRC}

	: {cmd:ftwrap(r, 5)}
        {res}       {txt} 1    2    3    4    5
            {c TLC}{hline 26}{c TRC}
          1 {c |}  {res} 1   .2   .4   .1   .5{txt}  {c |}
            {c BLC}{hline 26}{c BRC}

	: {cmd:ftwrap(r, 6)}
        {res}       {txt} 1    2    3    4    5    6
            {c TLC}{hline 31}{c TRC}
          1 {c |}  {res} 1   .2   .4    0   .1   .5{txt}  {c |}
            {c BLC}{hline 31}{c BRC}

	: {cmd:ftwrap(r, 8)}
        {res}       {txt} 1    2    3    4    5    6    7    8
            {c TLC}{hline 41}{c TRC}
          1 {c |}  {res} 1   .2   .4    0    0    0   .1   .5{txt}  {c |}
            {c BLC}{hline 41}{c BRC}


{marker ftunwrap()}{...}	
{p 4 4 2}
{cmd:ftunwrap(}{it:H}{it:)} unwraps frequency-wraparound order such as
returned by {helpb mf_fft##remarks2:fft()}.  You may find this useful when
graphing or listing results, but it is otherwise unnecessary.
Frequency-unwrapped order is defined as


			unwrap[1]       frequency -({it:n}/2) + 1
			unwrap[2]       frequency -({it:n}/2) + 2
			.
			unwrap[{it:n}/2-1]   frequency -1
			unwrap[{it:n}/2]     frequency 0
			unwrap[{it:n}/2+1]   frequency 1
			.
			unwrap[{it:n}-1]     frequency {it:n}/2 - 1
			unwrap[{it:n}]       frequency {it:n}/2

{p 4 4 2}
Here we assume that {it:n} is even, as will usually be true.  
The aliased (highest) frequency is assigned the positive sign.

{p 4 4 2}
Also see {helpb mf_fft##ftperiodogram():ftperiodogram()}, below.


{marker ftretime()}{...}
{p 4 4 2}
{cmd:ftretime(}{it:r}{cmd:,} {it:s}{cmd:)} 
retimes the signal {it:s} to be on the same time scale as
{cmd:convolve(}{it:r}{cmd:,} {it:s}{cmd:)}.  This is useful in graphing and
listing results but is otherwise not required.  {cmd:ftretime()} uses only the
length of {it:r}, and not its contents, to perform the retiming.  If the
response vector is of length 2{it:k}+1, a vector containing {it:k} zeros,
{it:s}, and {it:k} more zeros is returned.  Thus the result of
{cmd:ftretime(}{it:r}{cmd:,} {it:s}{cmd:)} is p-conformable with
{cmd:convolve(}{it:r}{cmd:,} {it:s}{cmd:)}.



{p 4 4 2}
{cmd:ftfreqs(}{it:H}{cmd:,} {it:delta}{cmd:)} 
returns a p-conformable-with-{it:H} vector containing the frequencies
associated with the elements of {it:H}.  {it:delta} is the sampling interval
and is often specified as 1.


{marker ftperiodogram()}{...}
{p 4 4 2}
{cmd:ftperiodogram(}{it:H}{cmd:)} returns a real vector of length {it:n}/2
containing the one-sided periodogram of {it:H} (length {it:n}),
calculated as

			abs({it:H}({it:f}))^2 + abs({it:H}(-{it:f}))^2

{p 4 4 2}
excluding frequency 0.  Thus {cmd:ftperiodogram(}{it:H}{cmd:)[1]} 
corresponds to frequency 1 (-1), 
{cmd:ftperiodogram(}{it:H}{cmd:)[2]} to frequency 2 (-2), and so
on.  


{marker remarks6}{...}
{title:Warnings}

{p 4 4 2}
{cmd:invfft(}{it:H}{cmd:)} will cast the result down to real if possible.
Code {cmd:C(invfft(}{it:H}{cmd:))} if you want to be assured of the 
result being stored as complex.

{p 4 4 2}
{cmd:convolve(}{it:r}{cmd:,} {it:s}{cmd:)} is not the same as 
{cmd:convolve(}{it:s}{cmd:,} {it:r}{cmd:)}.

{p 4 4 2}
{cmd:convolve(}{it:r}{cmd:,} {it:s}{cmd:)} 
will cast the result down to real if possible.
Code {cmd:C(convolve(}{it:r}{cmd:,} {it:s}{cmd:))} 
if you want to be assured of the result being stored as complex.

{p 4 4 2}
For 
{cmd:convolve(}{it:r}{cmd:,} {it:s}{cmd:)}, 
the response function {it:r} must have odd length.


{marker conformability}{...}
{title:Conformability}

    {cmd:fft(}{it:h}{cmd:)}:
		{it:h}:  1 {it:x n}  or  {it:n x} 1,  {it:n} a power of 2
	   {it:result}:  1 {it:x n}  or  {it:n x} 1

    {cmd:invfft(}{it:H}{cmd:)}:
		{it:H}:  1 {it:x n}  or  {it:n x} 1,  {it:n} a power of 2
	   {it:result}:  1 {it:x n}  or  {it:n x} 1

    {cmd:_fft(}{it:h}{cmd:)}:
		{it:h}:  1 {it:x n}  or  {it:n x} 1,  {it:n} a power of 2
	   {it:result}:  {it:void}

    {cmd:_invfft(}{it:H}{cmd:)}:
		{it:H}:  1 {it:x n}  or  {it:n x} 1,  {it:n} a power of 2
	   {it:result}:  {it:void}

{p 4 4 2}
{cmd:convolve(}{it:r}{cmd:,} {it:s}{cmd:)}:
{p_end}
		{it:r}:  1 {it:x} {it:n}      or      {it:n} {it:x} 1,  {it:n}>0, {it:n} odd
		{it:s}:  1 {it:x} 2{it:k}+1   or   2{it:k}+1 {it:x} 1,  i.e., {it:s} of odd length
	   {it:result}:  1 {it:x} 2{it:k}+{it:n}   or   2{it:k}+{it:n} {it:x} 1

    {cmd:deconvolve(}{it:r}{cmd:,} {it:sm}{cmd:)}
		{it:r}:  1 {it:x} {it:n}      or      {it:n} {it:x} 1,  {it:n}>0, {it:n} odd
	       {it:sm}:  1 {it:x} 2{it:k}+{it:n}   or   2{it:k}+{it:n} {it:x} 1
	   {it:result}:  1 {it:x} 2{it:k}+1   or   2{it:k}+1 {it:x} 1

{p 4 4 2}
{cmd:Corr(}{it:g}{cmd:,} {it:h}{cmd:,} {it:k}{cmd:)}:
{p_end}
		{it:g}:  1 {it:x} {it:n}      or      {it:n} {it:x} 1,  {it:n}>0
		{it:h}:  1 {it:x} {it:n}      or      {it:n} {it:x} 1
		{it:k}:  1 {it:x} 1      or      1 {it:x} 1,  {it:k}>0
	   {it:result}:  1 {it:x} 2{it:k}+1   or   2{it:k}+1 {it:x} 1

    {cmd:ftperiodogram(}{it:H}{cmd:)}:
		{it:H}:  1 {it:x} {it:n}      or     {it:n} {it:x} 1,  {it:n} even
	   {it:result}:	 {it:n}/2 {it:x} 1    or     1 {it:x} {it:n}/2

    {cmd:ftpad(}{it:h}{cmd:)}:
		{it:h}:  1 {it:x n}      or      {it:n x} 1
	   {it:result}:  1 {it:x N}      or      {it:N x} 1, {it:N} = {it:n} rounded up to power of 2

    {cmd:ftwrap(}{it:r}{cmd:,} {it:n}{cmd:)}:
		{it:r}:  1 {it:x} {it:m}      or      {it:m} {it:x} 1,  {it:m}>0, {it:m} odd
		{it:n}:  1 {it:x} 1      or      1 {it:x} 1,  {it:n} >= {it:m}
	   {it:result}:  1 {it:x} {it:n}      or      {it:n} {it:x} 1

    {cmd:ftunwrap(}{it:H}{it:)}:
		{it:H}:  1 {it:x} {it:n}      or     {it:n} {it:x} 1
	   {it:result}:	 1 {it:x} {it:n}      or     {it:n} {it:x} 1

    {cmd:ftretime(}{it:r}{cmd:,} {it:s}{cmd:)}:
		{it:r}:  1 {it:x} {it:n}      or      {it:n} {it:x} 1,  {it:n}>0, {it:n} odd
		{it:s}:  1 {it:x} 2{it:k}+1   or   2{it:k}+1 {it:x} 1,  i.e., {it:s} of odd length
	   {it:result}:  1 {it:x} 2{it:k}+{it:n}   or   2{it:k}+{it:n} {it:x} 1

    {cmd:ftfreqs(}{it:H}{cmd:,} {it:delta}{cmd:)}:
		{it:H}:  1 {it:x} {it:n}      or     {it:n} {it:x} 1,  {it:n} even
  	    {it:delta}:  1 {it:x} 1
	   {it:result}:	 1 {it:x} {it:n}      or     {it:n} {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
All functions abort with error if the conformability requirements are 
not met.  This is always true, of course, but pay particular attention 
to the requirements outlined under
{it:{help mf_fft##conformability:Conformability}} directly above.

{p 4 4 2}
{cmd:fft(}{it:h}{cmd:)}, 
{cmd:_fft(}{it:h}{cmd:)},
{cmd:invfft(}{it:H}{cmd:)},
{cmd:_invfft(}{it:H}{cmd:)},
{cmd:convolve(}{it:r}{cmd:,} {it:s}{cmd:)},
{cmd:deconvolve(}{it:r}{cmd:,} {it:sm}{cmd:)}, 
and
{cmd:Corr(}{it:g}{cmd:,} {it:h}{cmd:,} {it:k}{cmd:)}
return missing results if any argument contains missing values.

{p 4 4 2}
{cmd:ftwrap(}{it:r}{cmd:,} {it:n}{cmd:)}
aborts with error if {it:n} contains missing value.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view fft.mata, adopath asis:fft.mata},
{view invfft.mata, adopath asis:invfft.mata},
{view convolve.mata, adopath asis:convolve.mata},
{view deconvolve.mata, adopath asis:deconvolve.mata},
{view corruppercase.mata, adopath asis:corruppercase.mata},
{view ftperiodogram.mata, adopath asis:ftperiodogram.mata},
{view ftpad.mata, adopath asis:ftpad.mata},
{view ftwrap.mata, adopath asis:ftwrap.mata},
{view ftunwrap.mata, adopath asis:ftunwrap.mata},
{view ftretime.mata, adopath asis:ftretime.mata},
{view ftfreqs.mata, adopath asis:ftfreqs.mata}

{pstd}
{cmd:_fft()} and {cmd:_invfft()} are built in.
{p_end}
