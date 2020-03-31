{smcl}
{* *! version 1.2.5  15may2018}{...}
{vieweralsosee "[M-2] reswords" "mansection M-2 reswords"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] Naming" "help m1_naming"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] version" "help m2_version"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_reswords##syntax"}{...}
{viewerjumpto "Description" "m2_reswords##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_reswords##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_reswords##remarks"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-2] reswords} {hline 2}}Reserved words
{p_end}
{p2col:}({mansection M-2 reswords:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 4 2}
Reserved words are

	{cmd}aggregate       float           pointer         union 
	array           for           	polymorphic     unsigned
  			friend		pragma 		using
	boolean         function        private		    
	break                           protected       vector
	byte            global          public          version     
			goto				virtual
	case            		quad            void
	catch           if                              volatile
	class           inline          real                    
	colvector       int             return          while
	complex                         rowvector      
	const           local                           
	continue        long            scalar         
					short
	default         mata            signed       
	delegate        matrix          static      
	delete                          string     
	do              namespace       strL
	double          new             struct   
			NULL 		super
	else            numeric         switch
	eltypedef
	end             operator        template      
	enum 		orgtypedef	this
	explicit			throw
	export				transmorphic
	external			try
					typedef
					typename{txt}


{marker description}{...}
{title:Description}

{p 4 4 2}
Reserved words are words reserved by the Mata compiler; they may not be 
used to name either variables or functions.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 reswordsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_reswords##remarks1:Future developments}
	{help m2_reswords##remarks2:Version control}


{marker remarks1}{...}
{title:Future developments}

{p 4 4 2}
Many of the words above are reserved for the future implementation of  
new features.  For instance, the words
{cmd:aggregate},
{cmd:array},
{cmd:boolean},
{cmd:byte},
etc., currently play no role in Mata, but they are reserved.

{p 4 4 2}
You cannot infer much about short-run development plans from the presence or
absence of a word from the list.  The list was constructed by
including words that would be needed to add certain
features, but we have erred on the side of reserving too many words because it
is better to give back a word than to take it away later.  Taking away a word
can cause previously written code to break.

{p 4 4 2}
Also, features can be added without reserving words if the word 
will be used only within a specific context.  Our original list was 
much longer, but then we struck from it such context-specific words.


{marker remarks2}{...}
{title:Version control}

{p 4 4 2}
Even if we should need to reserve new words in the future, you can ensure 
that you need not modify your programs by engaging in version control; 
see {bf:{help m2_version:[M-2] version}}.
{p_end}
