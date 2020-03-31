{smcl}
{* *! version 2.2.5  19oct2017}{...}
{findalias asgsmviewer}{...}
{findalias asgsuviewer}{...}
{findalias asgswviewer}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{vieweralsosee "[R] net" "help net"}{...}
{vieweralsosee "net_mnu" "net_mnu"}{...}
{vieweralsosee "[R] news" "help news"}{...}
{vieweralsosee "[R] search" "help search"}{...}
{vieweralsosee "searchadvice" "searchadvice"}{...}
{vieweralsosee "[R] update" "help update"}{...}
{vieweralsosee "[R] view" "help view"}{...}
{title:Advice on finding help}

{pstd}
Let's say you are trying to find out how to do something.  With about 3,000
help files and 14,000 pages of PDF documentation, we have probably explained
how to do whatever you want.  The documentation is filled with worked examples
that you can run on supplied datasets.  Whatever your question, try the
following first:

{p 4 7 2}1. Select {bf:Help} from the Stata menu and click on {bf:Search...}.

{p 4 7 2}2. Type some keywords about the topic that interests you, say,
             "logistic regression".

{p 4 7 2}3. Look through the resulting list of available resources, including
            help files, FAQs, Stata Journal articles, and other resources.

{p 4 7 2}4. Select the resource whose description looks most helpful.  Usually,
       this description will be a help file and will include 
       "(help <xyz>)", or, as in our example, perhaps
       "(help {help logistic})".  Click on the blue
       link "logistic".

{p 4 7 2}5. Let's assume you have selected the "(help {help logistic})" entry.
       You are probably not interested in the syntax at the top of the file,
       but you would like to see some examples.  Select {bf:Jump To} from the
       Viewer menu (in the top right corner of the help file now on your
       screen), and click on {bf:Examples}.  You will be taken to example
       commands that you can run on example datasets.  Simply cut and paste
       those commands into Stata to see the results.

{p 4 7 2}6. If you are new to the {cmd:logistic} command and want both an
       overview and worked examples with discussion, from the {bf:Also See}
       menu, click on {mansection R logistic:[R] logistic} with the PDF
       icon. 
       Or at the top of the help file, click on the blue title of the entry
       ({manlink R logistic}).  Your PDF viewer will be opened to the full
       documentation of the {cmd:logistic} command.

{p 4 7 2}7. There is a lot of great material in this documentation for both
       experts and novices.  As with the help file, you will often want to
       begin first with the {it:Remarks and examples} section.  Simply click
       on the {mansection R logisticRemarksandexamples:Remarks and examples}
       link at the top of the {cmd:logistic} entry.  A
       complete discussion of the {cmd:logistic} command can be found in the
       remarks along with worked examples that run on supplied datasets and
       are explained in detail.  That should get you ready to use the
       command on your own data.

{pstd}
If that does not help, try the many other Stata resources;
see {help resources:Resources for learning more about Stata}.
{p_end}
