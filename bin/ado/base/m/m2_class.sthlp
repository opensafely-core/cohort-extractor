{smcl}
{* *! version 1.3.4  31jul2019}{...}
{vieweralsosee "[M-2] class" "mansection M-2 class"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Declarations" "help m2_declarations"}{...}
{vieweralsosee "[M-2] struct" "help m2_struct"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] class" "help class"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_class##syntax"}{...}
{viewerjumpto "Description" "m2_class##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_class##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_class##remarks"}{...}
{viewerjumpto "Reference" "m2_class##reference"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-2] class} {hline 2}}Object-oriented programming (classes)
{p_end}
{p2col:}({mansection M-2 class:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:class} {it:classname} [{bf:{help m2_class##def_inheritance:extends}} {it:classname}] {cmd:{c -(}}
		{it:declaration(s)}
	{cmd:{c )-}}


{p 4 4 2}
Syntax is presented under the following headings:

	{help m2_class##syn_intro:Introduction}
	{help m2_class##syn_example:Example}
	{help m2_class##syn_variables:Declaration of member variables}
	{help m2_class##syn_functions:Declaration and definition of methods (member functions)}
	{help m2_class##syn_exposure:Default exposure in declarations}

{p 4 4 2}
{it:{help m2_class##description:Description}}
and 
{it:{help m2_class##remarks:Remarks}}
follow that.


{marker syn_intro}{...}
    {title:Syntax: Introduction}

{p 8 8 2}
Stata's two programming languages, ado and Mata, each support
object-oriented programming.  This manual entry explains
object-oriented programming in Mata.  Most users interested in
object-oriented programming will wish to program in Mata.  See
{manhelp class P} to learn about object-oriented programming in ado.


{marker syn_example}{...}
    {title:Syntax: Example}

{p 8 8 2}
The following example is explained in detail in 
{it:{help m2_class##description:Description}}.

		{cmd}class coord {
                	real scalar    x, y
                	real scalar    length(), angle()
		}

		real scalar coord::length()
		{
			return(sqrt(x^2 + y^2))
		}

		real scalar coord::angle()
		{
			return(atan2(y, x)*360/(2*pi()))
		}

		class rotated_coord extends coord {
			real scalar	theta
			real scalar     angle()
			void            new()
		}

		real scalar rotated_coord::angle()
		{
			return(super.angle() - theta)
		}

		void rotated_coord::new() 
		{
			theta = 0 
		}{txt}

{p 8 8 2}
    One could use the class interactively:

		{cmd}: b = rotated_coord()
		: b.x = b.y = 1
		: b.angle()                {txt:// displayed will be 45}
		: b.theta = 30
		: b.angle()                {txt:// displayed will be 15}{txt}

{p 8 8 2}
    Note that executing the class as if it were a function creates an instance
    of the class.  When using the class inside other functions, it is not
    necessary to create the instance explicitly as long as you declare the
    member instance variable to be a {cmd:scalar}:

		{cmd}void myfunc()
		{
			class rotated_coord scalar   b

			b.x = b.y = 1 
			b.angle()          {txt:// displayed will be 45}
			b.theta = 30
			b.angle()          {txt:// displayed will be 15}
		}{txt}



{marker syn_variables}{...}
    {title:Syntax:  Declaration of member variables}

{p 4 4 2}
    Declarations are of the form

        [{it:{help m2_class##def_exposure:exposure}}] {...}
[{bf:{help m2_class##def_static:static}}] {...}
[{bf:{help m2_class##def_final:final}}] {...}
{it:matatype}  {it:name} [{cmd:,} {it:name} [{cmd:,} ...]]

{p 8 8 2}
    where 

                {it:exposure} := { {cmd:public} | {cmd:protected} | {cmd:private} } 

                {it:matatype} := { {it:eltype orgtype} | {it:eltype} | {it:orgtype} } 

                  {it:eltype} :=  {cmd:transmorphic}       {it:orgtype} := {cmd:matrix}
                             {cmd:numeric}                       {cmd:vector}
                             {cmd:real}                          {cmd:rowvector}
                             {cmd:complex}                       {cmd:colvector}
                             {cmd:string}                        {cmd:scalar}
                             {cmd:pointer}
                             {cmd:class} {it:classname}
                             {cmd:struct} {it:structname}

{p 8 8 2}
For example,

		{cmd}class S {
                	real matrix                M
			private real scalar        type 
                	static real scalar         count 
                	class coord scalar         c 
        	}{txt}


{marker syn_functions}{...}
    {title:Syntax:  Declaration and definition of methods (member functions)}

{p 4 4 2}
    Declarations are of the form

        [{it:{help m2_class##def_exposure:exposure}}] {...}
[{bf:{help m2_class##def_static:static}}] {...}
[{bf:{help m2_class##def_final:final}}] {...}
[{bf:{help m2_class##def_virtual:virtual}}] {...}
{it:matatype}  {it:name}{cmd:()} [{cmd:,} {it:name}{cmd:()} [...]]

{p 8 8 2}
For example,

		{cmd}class T { 
                	...
			real matrix                inverse()
			protected real scalar      type()
                	class coord scalar         c()
        	}{txt}

{p 8 8 2}
    Note that function arguments, even if allowed, are not declared.

{p 8 8 2}
    Member functions (methods) and member variables may share the same names
    and no special meaning is attached to the fact.
    {cmd:type} and {cmd:c} below are variables, and 
    {cmd:type()} and {cmd:c()} are functions:

		{cmd}class U {
                	real matrix                M
			private real scalar        type 
                	static real scalar         count 
                	class coord scalar         c 

			real matrix                inverse()
			protected real scalar      type()
                	class coord scalar         c()
        	}{txt}

{p 8 8 2}
     Member functions are defined separately, after the class is 
     defined.  For example, 

		{cmd}class V {
                	real matrix                M
			private real scalar        type 
                	static real scalar         count 
                	class coord scalar         c 

			real matrix                inverse()
			protected real scalar      type()
                	class coord scalar         c()
        	}

                real matrix V::inverse(...)
                {
                        ...
                }

                real scalar V::type(...)
                {
                        ...
                }

                class coord scalar V::c(...)
                {
                        ...
                }{txt}

{p 8 8 2}
When you define member functions, they must be of the same {it:matatype}
as they were previously declared to be, but you omit {it:exposure}
(as well as {cmd:static}, {cmd:final}, and {cmd:virtual}).

     
{marker syn_exposure}{...}
    {title:Syntax:  Default exposure in declarations}

{p 8 8 2}
    Variables and functions are {cmd:public} unless explicitly
    declared otherwise.  (They are also not {cmd:static}, not {cmd:final},
    and not {cmd:virtual}, 
    but that is not part of exposure and so has nothing to do with this 
    subsection.)

{p 8 8 8}
    You may use any of the exposure modifiers
    {helpb m2_class##public:public}, {helpb m2_class##protected:protected}, 
    and {helpb m2_class##private:private}, followed by a colon, to create
    blocks with a different default:

		{cmd}class V {
		    public:
                	real matrix                M
                	static real scalar         count 
                	class coord scalar         c 
			real matrix                inverse()
                	class coord scalar         c()

		    private:
			real scalar                type 

		    protected:
			real scalar                type()
        	}{txt}
    

 
{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:class} 
provides object-oriented programming, also known as class programming,
to Mata.

{p 4 4 2}
A class is a set of variables or related functions (methods) (or both) tied
together under one name.  Classes may be derived from other classes according
to {help m2_class##def_inheritance:inheritance}.

{pstd}
For a more detailed description of classes, see
{help m2_class##gould2018sp:Gould (2018)}.

{p 4 4 2}
Let's look at the details of the example from the first page of this entry
(under the heading {it:{help m2_class##syn_example:Example}}):

{p 8 12 2}
1.  First, we created a class called {cmd:coord}.  
    When we coded 

		{cmd}class coord {
                	real scalar    x, y   
                	real scalar    length(), angle()
		}{txt}

{p 12 12 2}
    we specified that each element of a {cmd:coord} stores two real values,
    which we called {cmd:x} and {cmd:y}.  {cmd:coord} also contains two
    functions, which we called {cmd:length()} and {cmd:angle()}.
    {cmd:length()} and {cmd:angle()} are functions because of the open and
    close parentheses at the end of the names, and {cmd:x} and {cmd:y} are 
    variables because of the absence of parentheses.  In the jargon, 
    {cmd:x} and {cmd:y} are called member variables, and {cmd:length()} 
    and {cmd:angle()} are called member functions.

{p 12 12 2}
    The above, called the class's definition,  defines a blueprint for the 
    type {cmd:coord}.

{p 12 12 2}
    A variable that is of type {cmd:coord} is called an instance
    of a {cmd:coord}.  Say variables {cmd:b} and {cmd:c} are instances of 
    {cmd:coord}, although 
    we have not yet explained how you might arrange that.  Then 
    {cmd:b.x} and {cmd:b.y} would be {cmd:b}'s values of {cmd:x} and {cmd:y}, 
    and {cmd:c.x} and {cmd:c.y} would be {cmd:c}'s values.
    We could run the functions on the values in {cmd:b} by coding 
    {cmd:b.length()} and {cmd:b.angle()},  or on the values in {cmd:c} 
    by coding {cmd:c.length()} and {cmd:c.angle()}.

{p 8 12 2} 
2.  Next we defined {cmd:coord}'s {cmd:length()} and {cmd:angle()}
    functions.  The definitions were

		{cmd}real scalar coord::length()
		{
			return(sqrt(x^2 + y^2))
		}

		real scalar coord::angle()
		{
			return(atan2(y, x)*360/(2*pi()))
		}{txt}

{p 12 12 2}
    These functions are similar to regular Mata functions.  These functions
    do not happen to take any arguments, but that is not a requirement.
    It often happens that member functions do not require
    arguments because the functions are defined in terms of the class
    and its concepts.  That is exactly what is occurring here.
    The first function says that when someone has an instance of a {cmd:coord}
    and they ask for its length, return the square root of the
    sum of the {cmd:x} and {cmd:y} values, individually squared.  The
    second function says that when someone
    asks for the angle, return the arctangent of {cmd:y} and {cmd:x},
    multiplied by {cmd:360/(2*pi())} to convert the result from radians to
    degrees.

{p 8 12 2}
3.  Next we defined another new concept, a {cmd:rotated_coord},
    by extending (inheriting from) class {cmd:coord}:

		{cmd}class rotated_coord extends coord {
			real scalar	theta
			real scalar     angle()
			void            new()
		}{txt}

{p 12 12 2}
    So think of a {cmd:coord} and read the above as the additions.
    In addition to {cmd:x} and {cmd:y} of a regular {cmd:coord}, 
    a {cmd:rotated_coord} has new variable {cmd:theta}.  We also declared that 
    we were adding two functions, {cmd:angle()} and {cmd:new()}.
    But wait, {cmd:angle()} already existed!  What we are actually 
    saying by explicitly mentioning {cmd:angle()} is that we are going 
    to change the definition of {cmd:angle()}.  Function {cmd:new()} 
    is indeed new.

{p 12 12 2}
    Notice that we did not mention previously existing function {cmd:length()}.
    Our silence indicates that the concept of {cmd:length()} remains unchanged.

{p 12 12 2}
    So what is a {cmd:rotated_coord}?  It is a {cmd:coord} with the 
    addition of {cmd:theta}, a redefinition of how {cmd:angle()} 
    is calculated, and the addition of a function called {cmd:new()}.

{p 12 12 2}
      This is an example of inheritance.  {cmd:class rotated_coord} is an
      extension of {cmd:class coord}.  In object-oriented programming, we
      would say this as "{cmd:class rotated_coord} inherits from
      {cmd:class coord}".  A class that inherits from another class is known
      as a "subclass".

{p 8 12 2}
4.  Next we defined our replacement and new functions.  The definitions are

		{cmd}real scalar rotated_coord::angle()
		{
			return(super.angle() - theta)
		}

		void rotated_coord::new() 
		{
			theta = 0 
		}{txt}

{p 12 12 2}
    Concerning {cmd:angle()}, we stated that it is calculated by 
    taking the result of {cmd:super.angle()} and subtracting 
    {cmd:theta} from it.  {cmd:super.angle()} is how one refers
    to the parent's definition of a function.
    If you are unfamiliar with object-oriented programming, parent may seem
    like an odd word in this context.
    We are inheriting concepts from {cmd:coord} to define 
    {cmd:rotated_coord}, and in that sense, {cmd:coord} is the parent concept.
    Anyway, the new definition of an angle is the old definition, 
    minus {cmd:theta}, the angle of rotation.

{p 12 12 2} 
    {cmd:new()} is a special function 
    and is given a special name in the sense that the name 
    {cmd:new()} is reserved.  The {cmd:new()} function, if it exists,
     is a function that is called automatically whenever a new instance of 
     the class is created.  Our {cmd:new()} function says that when 
     a new instance of a {cmd:rotated_coord} is created, initialize
     the instance's {cmd:theta} to 0.

{p 12 12 2}
    Well, that seems like a good idea.  But we did not have a {cmd:new()} 
    function when we defined our previous class, {cmd:coord}.  Did we 
    forget something?  Maybe.  When you do not specify a {cmd:new()} 
    function -- when you do not specify how variables are to be initialized --
    they are initialized in the usual Mata way:  missing values.  
    {cmd:x} and {cmd:y} will be initialized to contain missing.  Given 
    our {cmd:new()} function for {cmd:rotated_coord}, however, {cmd:theta}
    will be initialized to 0.

{p 12 12 2}
    {cmd:new()} is called a "constructor", because it is used to
    construct, or initialize, the class when a new instance of the
    class is created.

{p 4 4 2}
And that completes the definition of our two, related classes.

{p 4 4 2}
There are two ways to create instances of a {cmd:coord} or a
{cmd:rotated_coord}.  One is mostly for interactive use and the other for
programming use.

{p 4 4 2}
If you interactively type {cmd:a=coord()} (note the parentheses), you will
create a {cmd:coord} and store it in {cmd:a}.  
If you interactively type {cmd:b=rotated_coord()}, you will create 
a {cmd:rotated_coord} and store it in {cmd:b}.  
In the first example, typing 
{cmd:b=rotated_coord()} is exactly what we chose to do: 

		{cmd}: b = rotated_coord(){txt}

{p 4 4 2}
Recall that a {cmd:rotated_coord} contains an {cmd:x}, {cmd:y}, and
{cmd:theta}.  At this stage, {cmd:x} and {cmd:y} equal missing, and
{cmd:theta} is 0.  In the example, we set {cmd:b}'s {cmd:x} and {cmd:y}
values to 1, and then asked for the resulting {cmd:angle()}:

		{cmd}: b.x = b.y = 1

		: b.angle()
                  45{txt}

{p 4 4 2}
{cmd:b}-dot-{cmd:x} is how one refers to {cmd:b}'s value of {cmd:x}. 
One can use {cmd:b.x} (and {cmd:b.y}) just as one would use any 
real scalar variable in Mata.

{p 4 4 2}
If we reset {cmd:b}'s {cmd:theta} to be 30 degrees, then {cmd:b}'s angle ought
to change to being 15 degrees.  That is exactly what happens:

		{cmd}: b.theta = 30

		: b.angle()
                  15{txt}

{p 4 4 2}
{cmd:b}-dot-{cmd:angle()} is how one specifies that member function 
{cmd:angle()} is to be run on instance {cmd:b}.  Now you know why 
member functions so seldom have additional arguments:  they are, in 
effect, passed an instance of a class and so have access to all the values 
of member variables of that class.  We repeat, however, that a member function
could take additional arguments.  Had we coded

		{cmd}real scalar rotated_coord::angle(real scalar base)
		{
			return(super.angle() - theta - base)
		}{txt}

{p 4 4 2}
then {cmd:angle()} would have taken an argument and returned the result 
measured from {cmd:base}.

{p 4 4 2}
The difference between using {cmd:rotated_coord} interactively and using
it inside a Mata program is that if we declare a variable (say, {cmd:b}) to be
a {cmd:class} {cmd:rotated_coord} {cmd:scalar}, with the emphasis on
{cmd:scalar}, then we do not need to bother coding {cmd:b=rotated_coord()} to 
fill in {cmd:b} initially.  Coding {cmd:class} {cmd:rotated_coord} {cmd:scalar} 
{cmd:b} implies that {cmd:b} needs to be initialized because it is a scalar,
and so that happens automatically.  It would not hurt if we also coded
{cmd:b=rotated_coord()}, but it would be a waste of our time and of the
computer's once it got around to executing our program.

{p 4 4 2}
Now let's show you something we did not show in the first example.
Remember when we defined {cmd:length()} for a {cmd:coord}?  Remember 
how we did not define {cmd:length()} for a {cmd:rotated_coord}?  
Remember how we did not even mention {cmd:length()}?  Even so, 
{cmd:length()} is a concept of a {cmd:rotated_coord}, because part of the 
definition of {cmd:rotated_coord} 
was inherited from {cmd:coord}, and that happened because when 
we declared {cmd:rotated_coord}, we said 

		{cmd:class rotated_coord extends coord}

{p 4 4 2}
The inheritance happened because we said {cmd:extends}.  Let's test 
that {cmd:length()} works with our {cmd:rotated_coord} class instance, {cmd:b}:

		{cmd}: b.length()
		  1.414213562{txt}

{p 4 4 2}
In the above, inheritance is what saved us from having to write additional,
repeated code.  

{p 4 4 2}
Let's review.  First, we defined a {cmd:coord}.  From that, we defined a
{cmd:rotated_coord}.  You might now define
{cmd:translated_and_rotated_coord} using {cmd:rotated_coord} as a starting
point.  It would not be difficult.

{p 4 4 2}
Classes have lots of properties, features, and details, but it is the property
of inheritance that is at the heart of object-oriented programming.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 classRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_class##notation:Notation and jargon}
	{help m2_class##rem_declaration:Declaring and defining a class}
	{help m2_class##rem_saving:Saving classes in files}
	{help m2_class##rem_workflow:Workflow recommendation}
	{help m2_class##recompile:When you need to recompile}
	{help m2_class##rem_instances:Obtaining instances of a class}
	{help m2_class##rem_new:Constructors and destructors}
	{help m2_class##def_exposure:Setting member variable and member function exposure}
	{help m2_class##def_final:Making a member final}
	{help m2_class##def_static:Making a member static}
	{help m2_class##def_virtual:Virtual functions}
	{help m2_class##def_this:Referring to the current class using this}
	{help m2_class##def_super:Using super to access the parent's concept}
	{help m2_class##def_cast:Casting back to a parent}
	{help m2_class##rem_external:Accessing external functions from member functions}
	{help m2_class##rem_pointers:Pointers to classes}


{marker notation}{...}
{title:Notation and jargon}

{...}
{...}
{...}
{p 4 8 2}
{it::: (double colon)}{break}
    The double-colon notation is used as a shorthand in documentation 
    to indicate that a variable or function is a 
    {help m2_class##def_member:member} 
    of a class and, in two cases, the double-colon notation is also 
    syntax that is understood by Mata.

{p 8 8 2}
    {cmd:S}::{cmd:s} indicates that the variable {cmd:s} is a member 
    of class {cmd:S}.  {cmd:S}::{cmd:s} is documentation shorthand. 

{p 8 8 2}
    {cmd:S}::{cmd:f()} indicates that function {cmd:f()} is a member of
    class {cmd:S}.  {cmd:S}::{cmd:f()} 
    is documentation shorthand. 
    {cmd:S::f()} is something Mata itself understands in two cases:

{p 12 16 2}
        1.  Notation {cmd:S::f()} is used when defining member functions.

{p 12 16 2}
        2.  Notation {cmd:S::f()} can be used as a way of calling 
            {help m2_class##def_static:static} member functions.


{...}
{...}
{...}
{p 4 8 2}
{it:be an instance of}{break}
    When we write 
    "let {cmd:s} be an instance of {cmd:S}" we are saying that {cmd:s} is an 
    {help m2_class##def_instance:instance} of class {cmd:S}, or 
    equivalently, that in some Mata code, {cmd:s} is declared as a
    {cmd:class} {cmd:S} {cmd:scalar}.


{...}
{...}
{...}
{p 4 8 2}
{it:class definition}, {it:class declaration}{break}
    A class definition or declaration is the definition of a class, such as
    the following:

		{cmd}class S {
			private real scalar     a, b
			real scalar             f(), g()
        	}{txt}

{p 8 8 2}
    Note well that the declaration of a Mata variable to be of type
    {cmd:class S}, 
    such as the line {cmd:class S scalar s} in

		{cmd}void myfunction()
		{c -(}
			class S scalar  s
                	...
		{c )-}{txt}

{p 8 8 2}
     is not a class definition.  It is a declaration of an
     {help m2_class##def_instance:instance} of a class.


{...}
{...}
{...}
{marker def_instance}{...}
{p 4 8 2} {it:class instance}, {it:instance}, {it:class {it:A} instance}{break}
A class instance is a variable defined according to a class definition.  
In the code 

		{cmd}void myfunction()
		{c -(}
			class S scalar      s
                	real scalar         b
                	...
		{c )-}{txt}

{p 8 8 2}
    {cmd:s} is a class instance, or, more formally, an instance of class
    {cmd:S}.  The term "instance" can be used with all element types, not just
    with classes.  Thus {cmd:b} is an instance of a {cmd:real}.  The term
    "instance" is more often used with classes and structures, however, because
    one needs to distinguish definitions of variables containing classes or
    structures from the definitions of the classes and structures themselves.


{...}
{...}
{...}
{marker def_inheritance}{...}
{marker def_child}{...}
{p 4 8 2}
{it:inheritance}, {it:extends}, {it:subclass}, {it:parent}, {it:child}{break}
    Inheritance is the property of one class definition using the 
    variables and functions of another just as if they were its own.  When a
    class does this, it is said to extend the other class.
    {cmd:T} extending {cmd:S} means the same thing as {cmd:T} inheriting from
    {cmd:S}.  {cmd:T} is also said to be a subclass of {cmd:S}.

{p 8 8 2}
    Consider the following definitions:

		{cmd}class S {
			real scalar	a, b
			real scalar	f()
		}

		class T extends S { 
			real scalar	c
                        real scalar     g()
		}{txt}

{p 8 8 2}
    Let {cmd:s} be an instance of {cmd:S} and {cmd:t} be an instance of {cmd:T}.
    It is hardly surprising that {cmd:s.a}, {cmd:s.b}, {cmd:s.f()},
    {cmd:t.c}, and {cmd:t.g()} exist, because each is explicitly declared.
    It is because of 
    inheritance that {cmd:t.a}, {cmd:t.b}, and {cmd:t.f()} also exist, and
    they exist with no additional code being written.

{p 8 8 2}
    If {cmd:U} extends {cmd:T} extends {cmd:S}, then {cmd:U} is said to be a
    child of {cmd:T} and to be a child of {cmd:S}, 
    although formally {cmd:U} is the grandchild of {cmd:S}.
    Similarly, both {cmd:S} and {cmd:T} are said to be parents 
    of {cmd:U}, although formally {cmd:S} is the grandparent of {cmd:U}.
    It is usually sufficient to label the relationship parent/child 
    without going into details.


{...}
{...}
{...}
{marker def_external}{...}
{p 4 8 2}
{it:external functions}{break}
    An external function is a regular function, such as 
    {cmd:sqrt()}, {cmd:sin()}, and {cmd:myfcn()}, defined outside of the 
    class and, as a matter of fact, outside of all classes.
    The function could be a function provided by Mata (such as {cmd:sqrt()}
    or {cmd:sin()}) or it could be a function you have written, such as 
    {cmd:myfcn()}.

{p 8 8 2}
    An issue arises when calling external functions from inside the code 
    of a {help m2_class##def_member:member function}.  When coding a member 
    function, references such as {cmd:sqrt()}, {cmd:sin()}, and 
    {cmd:myfcn()} are assumed to be references to the class's member 
    functions if a member function of the name exists.  If one wants 
    to ensure that the external-function interpretation is made, one codes 
    {cmd:::sqrt()}, {cmd:::sin()}, and {cmd:::myfcn()}.
    See 
    {it:{help m2_class##rem_external:Accessing external functions from member functions}}
    below.


{...}
{...}
{...}
{marker def_member}{...}
{p 4 8 2}
{it:member}, {it:member variable}, {it:member function}, {it:method}{break}
    A variable or function declared within a class is said to be a 
    member variable, or member function, of the class.  Member functions are
    also known as methods.  In what follows, 
    let {cmd:ex1} be an instance of {cmd:S}, and assume
    class {cmd:S} contains member function {cmd:f()} and member 
    variable {cmd:v}.

{p 8 8 2}
    When member variables and functions are used inside member functions, 
    they can simply be referred to by their names, {cmd:v} and {cmd:f()}.
    Thus, if we were writing the code for {cmd:S}::{cmd:g()}, we could 
    code

	    {cmd}real scalar S::g() 
	    {
	            return(f()*v)
            }{txt}

{p 8 8 2}
    When member variables and functions are used outside of member functions,
    which is to say, are used in regular functions, 
    the references must be prefixed with a class instance and a period.  Thus
    one codes

	    {cmd}real scalar myg(class S scalar ex1)
	    {
	            return(ex1.f()*ex1.v)
            }{txt}


{...}
{...}
{...}
{marker def_override}{...}
{p 4 8 2}
{it:variable and method overriding}{break}
    Generically, a second variable or function overrides a first variable or 
    function when they share the same name and the second causes the 
    first to be hidden, which causes the second variable to be accessed 
    or the second function to be executed in preference to the first.
    This arises in two ways in Mata's implementation of classes.

{p 8 8 2}
    In the first way, a variable or function in a parent class is said to
    be overridden
    if a child defines a variable or function of the same name.  For instance,
    let {cmd:U} extend {cmd:T} extend {cmd:S}, and assume {cmd:S::f()} and
    {cmd:T::f()} are defined.  By the rules of
    {help m2_class##def_inheritance:inheritance},
    instances of {cmd:U} and {cmd:T}
    that call {cmd:f()} will cause {cmd:T::f()} to execute.  Instances of
    {cmd:S} will cause {cmd:S::f()} to be executed.  Here {cmd:S.f()}
    is said to be overridden by {cmd:T.f()}.  Because {cmd:T::f()} will usually
    be implemented in terms of {cmd:S::f()}, {cmd:T::f()} will find it necessary
    to call {cmd:S::f()}.  This is done by using the {cmd:super} prefix; see
    {it:{help m2_class##def_super:Using super to access the parent's concept}}.

{p 8 8 2}
    The second way has to do with stack variables having precedence over 
    member variables in member functions.  For example, 

		{cmd}class S {
			real scalar     a, b
			void            f()
			...
		}

		void S::f()
		{
			real scalar     a

			a = 0 
			b = 0 
		}{txt}
{p 8 8 2}
     Let {cmd:s} be an instance of {cmd:S}.  Then execution of {cmd:s.f()}
     sets {cmd:s.b} to be 0; it does not change {cmd:s.a}, although 
     it was probably the programmer's intent to set {cmd:s.a} to zero, 
     too.  Because the programmer declared a variable named {cmd:a} within the
     program, however, the program's variable took precedence over the member
     variable {cmd:a}.
     One solution to this problem would be to change the {cmd:a} {cmd:=}
     {cmd:0} line to read {cmd:this.a} {cmd:=} {cmd:0}; see 
     {it:{help m2_class##def_this:Referring to the current class using this}}.


{marker rem_declaration}{...}
{title:Declaring and defining a class}

{p 4 4 2}
Let's say we declared a class by executing the code below:

	{cmd}class coord {
	        real scalar    x, y
                real scalar    length(), angle()
        }{txt}

{p 4 4 2}
At this point, class {cmd:coord} is said to be declared but not yet fully
defined because the code for its member functions {cmd:length()} and
{cmd:angle()} has not yet been entered.  Even so, the class is partially
functional.  In particular,

{p 8 12 2}
1.  The class will work.  Obviously, if an attempt to execute 
    {cmd:length()} or {cmd:angle()} is made, an error message 
    will be issued. 

{p 8 12 2}
2.  The class definition can be saved in an {cmd:.mo} or {cmd:.mlib} file 
    for use later, with the same proviso as in 1).

{p 4 4 2}
Member functions of the class are defined in the same way regular Mata
functions are defined but the name of the function is specified as
{it:classname}{cmd:::}{it:functionname}{cmd:()}.

	{cmd}real scalar coord::length()
	{
	        return(sqrt(x^2 + y^2))
	}

	real scalar coord::angle()
	{
	        return(atan2(y, x)*360/(2*pi()))
	}{txt}

{p 4 4 2}
The other difference is that member functions have direct access to the
class's member variables and functions.  {cmd:x} and {cmd:y} in the above are
the {cmd:x} and {cmd:y} values from an instance of class {cmd:coord}.

{p 4 4 2}
Class {cmd:coord} is now fully defined.


{marker rem_saving}{...}
{title:Saving classes in files}

{p 4 4 2}
The notation {cmd:coord()} -- classname-open parenthesis-close parenthesis --
is used to refer to the entire class definition by Mata's interactive commands
such as {helpb mata describe}, {helpb mata mosave}, and {helpb mata mlib}.

{p 4 4 2}
{cmd:mata} {cmd:describe} {cmd:coord()} would show

	{cmd}: mata describe coord()

            # bytes   type                    name and extent
        ------------------------------------------------------------
                344   classdef scalar         coord()
                176   real scalar              ::angle()
                136   real scalar              ::length()
        ------------------------------------------------------------{txt}

{p 4 4 2}
The entire class definition -- the compiled {cmd:coord()} and all its
compiled member functions -- can be stored in a {cmd:.mo} file by typing

	{cmd}: mata mosave coord(){txt}

{p 4 4 2}
The entire class definition could be stored in an already existing 
{cmd:.mlib} library, {cmd:lpersonal}, by typing 

	{cmd}: mata mlib add lpersonal coord(){txt}

{p 4 4 2}
When saving a class definition, both commands allow the additional option 
{cmd:complete}.  The option specifies that the class is to be saved 
only if the class definition is complete and that, otherwise, an error 
message is to be issued.

	{cmd}: mata mlib add lpersonal coord(), complete{txt}


{marker rem_workflow}{...}
{title:Workflow recommendation}

{p 4 4 2}
Our recommendation is that the source code for classes be kept in separate
files, and that the files include the complete definition.  At StataCorp,
we would save {cmd:coord} in file {cmd:coord.mata}:

	{hline 55} coord.mata {hline}
	*! version 1.0.0 class coord

	version {ccl stata_version}

        mata:

	class coord {
               	real scalar    x, y
               	real scalar    length(), angle()
	}

	real scalar coord::length()
	{
		return(sqrt(x^2 + y^2))
	}

	real scalar coord::angle()
	{
		return(atan2(y, x)*360/(2*pi()))
	}
	end
	{hline 55} coord.mata {hline}

{p 4 4 2}
Note that the file does not clear Mata, nor does it save the class in a
{cmd:.mo} or {cmd:.mlib} file; 
the file merely records the source code.  With this file, to save
{cmd:coord} in a {cmd:.mo} file, we need only to type

	{cmd}. clear mata 
	. do coord.mata 
	. mata mata mosave coord(), replace{txt}

{p 4 4 2}
(Note that although file {cmd:coord.mata} does not have the extension
{cmd:.do}, we can execute it just like we would any other do-file by using the
{cmd:do} command.)
Actually, we would put those three lines in yet another do-file called, 
perhaps, {cmd:cr_coord.do}.

{p 4 4 2}
We similarly use files for creating libraries, such as 

	{hline 52} cr_lourlib.do {hline}
        version {ccl stata_version}
	clear mata
	do coord.mata 
        do anotherfile.mata
        do yetanotherfile.mata
	/* etc. */

	mata:
	mata mlib create lourlib, replace 
	mata mlib add lourlib*()
	end
	{hline 52} cr_lourlib.do {hline}

{p 4 4 2} 
With the above, it is easy to rebuild libraries after updating code.


{marker recompile}{...}
{title:When you need to recompile}

{p 4 4 2}
If you change a class declaration, you need to recompile all programs that use
the class.  That includes other class declarations that inherit from the
class.  For instance, in the opening example, if you change anything 
in the {cmd:coord} declaration, 

	{cmd}class coord {
               	real scalar    x, y
               	real scalar    length(), angle()
	}{txt}

{p 4 4 2}
even if the change is so minor as to reverse the order of {cmd:x} and {cmd:y},
or to add a new variable or function, you must recompile all of {cmd:coord}'s
member functions, recompile all functions that use {cmd:coord}, and recompile
{cmd:rotated_coord} because {cmd:rotated_coord} is inherited from {cmd:coord}. 

{p 4 4 2}
You must do this because Mata seriously compiles your code.  The Mata compiler
deconstructs all uses of classes and substitutes low-level,
execution-time-efficient constructs that record the address of every
member variable and member function.  The advantage is that you do not have to
sacrifice run-time efficiency to have more readable and easily
maintainable code.  The disadvantage is that you must recompile when you
make changes in the definition.

{p 4 4 2}
You do not need to recompile outside functions that use a class if you only
change the code of member functions.  You do need to recompile if you add or
remove member variables or member functions.

{p 4 4 2}
To minimize the need for recompiling, especially if you are distributing 
your code to others physically removed from you, you may want to adopt 
the pass-through approach.

{p 4 4 2}
Assume you have written large, wonderful systems in Mata that all hinge on 
object-oriented programming.  One class inherits from another and that one from
another, but the one class you need to tell your users about is class
{cmd:wonderful}.  Rather than doing that, however, merely tell your users that
they should declare a {cmd:transmorphic} named {cmd:wonderfulhandle} -- and
then just have them pass {cmd:wonderfulhandle} around.  They begin using your
system by making an initialization call:

        {cmd:wonderfulhandle = wonderful_init()}

{p 4 4 2}
After that, they use regular functions you provide that require
{cmd:wonderful} as an argument.  From their perspective,
{cmd:wonderfulhandle} is a mystery.  From your perspective,
{cmd:wonderful_init()} returned an instance of a class {cmd:wonderful}, and the
other functions you provided receive an instance of a {cmd:wonderful}.  Sadly,
this means that you cannot reveal to your users the beauty of your underlying
class system, but it also means that they will not have to recompile their
programs when you distribute an update.  If the Mata compiler can compile their
code knowing only that {cmd:wonderfulhandle} is a {cmd:transmorphic}, then it
is certain their code does not depend on how {cmd:wonderfulhandle} is
constructed.


{marker rem_instances}{...}
{title:Obtaining instances of a class}

{p 4 4 2}
Declaring a class, such as 

	{cmd}class coord {
	         real scalar    x, y
                 real scalar    length(), angle()
        }{txt}

{p 4 4 2}
in fact creates a function, {cmd:coord()}.
Function {cmd:coord()} will create and return instances of the class:

{p 8 11 2}
o{bind:  }{cmd:coord()} -- {cmd:coord()} without arguments -- 
returns a scalar instance of the class.  

{p 8 11 2}
o{bind:  }{cmd:coord(3)} -- 
{cmd:coord()} with one argument, here 3 -- 
returns a 1 {it:x} 3
vector, each element of which is a separate instance of the class.

{p 8 11 2}
o{bind:  }{cmd:coord(2,3)} -- {cmd:coord()} with two arguments, here 
2 and 3 -- returns a 2 {it:x} 3 matrix, each element of which is a 
separate instance of the class.

{p 4 4 2}
Function {cmd:coord()} is useful when using Mata interactively.  It is the only
way to create instances of a class interactively.

{p 4 4 2}
In functions, you can create scalar instances by coding 
{cmd:class} {cmd:coord} {cmd:scalar} {it:name}, 
but in all other cases, you will also need to use function {cmd:coord()}.
In the following example, the programmer wants a vector of {cmd:coord}s:

	{cmd}void myfunction()
	{
		real scalar               i
		class coord vector        v
		...

		v = coord(3)
		for (i=1; i<=3; i++) v[i].x = v[i].y = 1
		...
	}{txt}

{p 4 4 2}
This program would have generated a compile-time error had the programmer
omitted the line {cmd:class} {cmd:coord} {cmd:vector} {cmd:v}.  Variable
declarations are usually optional in Mata, but variable declarations of type
class are not optional.

{p 4 4 2}
This program would have generated a run-time error had the programmer 
omitted the line {cmd:v} {cmd:=} {cmd:coord(3)}.  Because {cmd:v} was 
declared to be {cmd:vector}, {cmd:v} began life as 1 {it:x} 0.  The 
first thing the programmer needed to do was to expand {cmd:v}
to be 1 {it:x} 3.

{p 4 4 2}
In practice, one seldom needs class vectors or matrices.  A more typical program
would read

	{cmd}void myfunction()
	{
		real scalar               i
		class coord scalar        v
		...

		v.x = v.y = 1
		...
	}{txt}

{p 4 4 2}
Note particularly the line {cmd:class} {cmd:coord} {cmd:scalar} {cmd:v}.
The most common error programmers make is to omit the word {cmd:scalar} 
from the declaration.  If you do that, then {cmd:matrix} is assumed, and 
then, rather than {cmd:v} being 1 {it:x} 1, it will be 0 {it:x} 0.
If you did omit the word {cmd:scalar}, you have two alternatives.
Either go back and put the word back in, or add the line 
{cmd:v} {cmd:=} {cmd:coord()} before initializing {cmd:v.x} and 
{cmd:v.y}.  It does not matter which you do.  In fact, when you specify 
{cmd:scalar}, the compiler merely inserts the line {cmd:v} {cmd:=} 
{cmd:coord()} for you.


{marker rem_new}{...}
{title:Constructors and destructors}

{p 4 4 2}
You can specify how variables are initialized, and more, each time a
new instance of a class is created, but before we get to that, let's 
understand the default initialization.  In

	{cmd}class coord {
	        real scalar    x, y
                real scalar    length(), angle()
        }{txt}

{p 4 4 2}
there are two variables.  When an instance of a {cmd:coord} is created, say, by
coding {cmd:b} {cmd:=} {cmd:coord()}, the values are filled in the usual Mata
way.  Here, because {cmd:x} and {cmd:y} are scalars, {cmd:b.x} and
{cmd:b.y} will be filled in with missing.  Had they been vectors, row vectors,
column vectors, or matrices, they would have been dimensioned 1 {it:x} 0
(vectors and row vectors), 0 {it:x} 1 (column vectors), and 0 {it:x} 0
(matrices).

{p 4 4 2}
If you want to control initialization, you may declare a constructor function 
named {cmd:new()} in your class:

	{cmd}class coord {
	        real scalar    x, y
                real scalar    length(), angle()
                void           new()
        }{txt}

{p 4 4 2}
Function {cmd:new()} must be declared to be {cmd:void} and must take no
arguments.  You never bother to call {cmd:new()} yourself -- in fact, you are 
not allowed to do that.  Instead, function {cmd:new()} is called 
automatically each time a new instance of the class is created.

{p 4 4 2}
If you wanted every new instance of a {cmd:coord} to begin life with 
{cmd:x} and {cmd:y} equal to 0, you could code

	{cmd}void coord::new()
	{
	        x = y = 0 
        }{txt}

{p 4 4 2}
Let's assume we do that and we then inherit from {cmd:coord}
when creating the new class {cmd:rotated_coord}, just as shown
in the first example.

	{cmd}class rotated_coord extends coord {
		real scalar	theta
		real scalar     angle()
		void            new()
	}

	void rotated_coord::new() 
	{
		theta = 0 
	}{txt}

{p 4 4 2}
When we create an instance of a {cmd:rotated_coord}, all the variables
were initialized to 0.  That is, function {cmd:rotated_coord()} will
know to call both {cmd:coord}::{cmd:new()} and
{cmd:rotated_coord}::{cmd:new()}, and it will call them
in that order.

{p 4 4 2}
In your {cmd:new()} function, you are not limited to initializing 
values.  {cmd:new()} is a function and you can code whatever you want, 
so if you want to set up a link to a radio telescope and check for 
any incoming messages, you can do that.  
Closer to home, if you were implementing a file system, you might 
use a {help m2_class##def_static:static} variable to count the number 
of open files. (We will explain static member variables later.)

{p 4 4 2}
On the other side of instance creation -- instance destruction -- you can
declare and create {cmd:void} {cmd:destroy()}, which also takes no arguments,
to be called each time an instance is destroyed.  {cmd:destroy()} is known
as a destructor.  {cmd:destroy()}
works like {cmd:new()} in the sense that you are not allowed to call the
function directly.  Mata calls {cmd:destroy()} for you whenever Mata is
releasing the memory associated with an instance.  {cmd:destroy()} does not
serve much use in Mata because, in Mata, memory management is automatic and 
the freeing of memory is not your responsibility.  In some other 
object-oriented programming languages,
such as C++, you are responsible for memory management,
and the destructor is where you free the memory associated with the instance.

{p 4 4 2}
Still, there is an occasional use for {cmd:destroy()} in Mata.  Let's
consider a system that needs to count the number of instances of itself that
exists, perhaps so it can release a resource when the instance count goes to 0.
Such a system might, in part, read

	{cmd}class bigsystem {
		static real scalar	counter
		...
		void	                new(), destroy()
		...
	}

	void bigsystem::new()
	{
		counter = (counter==. ? 1 : counter+1)
	}

	void bigsystem::destroy()
	{
		counter-- 
	}{txt}

{p 4 4 2}
Note that {cmd:bigsystem}::{cmd:new()} must deal with two initializations,
first and subsequent.  The first time it is called, {cmd:counter} is {cmd:.}
and {cmd:new()} must set {cmd:counter} to be 1.  After that, {cmd:new()} must
increment {cmd:counter}.

{p 4 4 2}
If this system needed to obtain a resource, such as access to a radio telescope,
on first initialization and release it on last destruction, and be ready to
repeat the process, the code could read

	{cmd}void bigsystem::new()
	{
                if (counter==.) {
                        get_resource()
                        counter = 1
                }
                else {
                        ++counter
                }
        }

	void bigsystem::destroy()
	{
                if (--counter == 0) {
                        release_resource()
                        counter = .
                }
	}{txt}

{p 4 4 2}
Note that {cmd:destroy()}s are run whenever an instance is destroyed, even 
if that destruction is due to an abort-with-error in the user's program 
or even in the member functions.  The radio telescope will be released when the
last instance of {cmd:bigsystem} is destroyed, except in one case.  The
exception is when there is an error in {cmd:destroy()} or any of the
subroutines {cmd:destroy()} calls.

{p 4 4 2}
For inheritance, child {cmd:destroy()}s are run before parent
{cmd:destroy()}s.


{marker def_exposure}{...}
{title:Setting member variable and member function exposure}

{p 4 4 2}
Exposure specifies who may access the member variables and member functions
of your class.  There are three levels of exposure: from least
restrictive to most restrictive, public, protected, and private.

{marker public}{...}
{p 8 11 2}
    o{bind:  }Public variables and functions may be accessed by
    anyone, including callers from outside a class.

{marker protected}{...}
{p 8 11 2}
    o{bind:  }Protected variables and functions may be accessed only by
    {help m2_class##def_member:member functions} of a class and its 
    {help m2_class##def_child:children}.

{marker private}{...}
{p 8 11 2}
    o{bind:  }Private variables and functions may be accessed only by member
    functions of a class (excluding children).

{p 4 4 2}
When you do not specify otherwise, variables and functions are public.
For code readability, you may declare member variables and functions to be
public with {cmd:public}, but this is not necessary.

{p 4 4 2}
In programming large systems, it is usually considered good style to 
make member variables private and to provide public functions to set and to
access any variables that users might need.  This way, the internal design of
the class can be subsequently modified and other classes that inherit from the
class will not need to be modified, they will just need to be recompiled.

{p 4 4 2}
You make member variables and functions protected or private by preceding
their declaration with {cmd:protected} or {cmd:private}:

	{cmd}class myclass { 
		private real matrix     X
		private real vector     y
		void                    setup()
		real matrix             invert()
		protected real matrix   invert_subroutine()
	}{txt}

{p 4 4 2}
Alternatively, you can create blocks with different defaults:

	{cmd}class myclass { 
	    public:
		void                    setup()
		real matrix             invert()
            protected:
		real matrix             invert_subroutine()
	    private:
		real matrix             X
		real vector             y
	}{txt}

{p 4 4 2}
You may combine 
{cmd:public}, {cmd:private}, and {cmd:protected}, with or without colons,
freely.


{marker def_final}{...}
{title:Making a member final}

{p 4 4 2}
A member variable or function is said to be final if no 
{help m2_class##def_child:children} define a variable or function of the same
name.  Ensuring that a definition is the final definition can be enforced by
including {cmd:final} in the declaration of the member, such as

	{cmd}class myclass { 
	    public:
		void                    setup()
		real matrix             invert()
            protected:
		final real matrix       invert_subroutine()
	    private:
		real matrix             X
		real vector             y
	}{txt}

{p 4 4 2}
In the above, no class that inherits from {cmd:myclass} can redefine
{cmd:invert_subroutine()}.


{marker def_static}{...}
{title:Making a member static}

{p 4 4 2}
Being static is an optional property of a class member variable 
function.  In what follows, let {cmd:ex1} and {cmd:ex2} both
be instances of {cmd:S}, assume {cmd:c} is a static variable of the class, and
assume {cmd:f()} is a static function of the class.

{p 4 4 2}
A static variable is a variable whose value is shared across all instances of
the class.  Thus, {cmd:ex1.c} and {cmd:ex2.c} will always be equal.
If {cmd:ex1.c} is changed, say, by {cmd:ex1.c=5}, then
{cmd:ex2.c} will also be 5.

{p 4 4 2}
A static function is a function that does not use the values of nonstatic
member variables of the class.  Thus {cmd:ex1.f(3)} and {cmd:ex2.f(3)} will
be equal regardless of how {cmd:ex1} and {cmd:ex2} differ.  

{p 4 4 2}
Outside of member functions, static functions may also be invoked by coding
the class name, two colons, and the function name, and thus used even if you
do not have a class instance.  For instance, equivalent to coding
{cmd:ex1.f(3)} or {cmd:ex2.f(3)} is {cmd:S::f(3)}.


{marker def_virtual}{...}
{title:Virtual functions}

{p 4 4 2}
When a function is declared to be virtual, the rules of 
{help m2_class##def_inheritance:inheritance} act as though they were reversed.
Usually, when one class inherits from another, if the child class does not
define a function, then it inherits the parent's function.  For virtual
functions, however, the parent has access to the child's definition of the
function, which is why we say that it is, in some sense, reverse inheritance.

{p 4 4 2}
The canonical motivational example of this deals with animals.  Without loss
of generality, we will use barnyard animals to illustrate.  A class,
{cmd:animal}, is defined.  Classes {cmd:cow} and {cmd:sheep} are defined that
extend (inherit from) {cmd:animal}.  One of the functions defined in
{cmd:animal} needs to make the sound of the specific animal, and it calls
virtual function {cmd:sound()} to do that.  At the {cmd:animal} level,
function {cmd:animal}::{cmd:sound()} is defined to display "Squeak!".
Because function {cmd:sound()} is virtual, however, each of the
specific-animal classes is supposed to define their own sound.  Class
{cmd:cow} defines {cmd:cow}::{cmd:sound()} that displays "Moo!" and class
{cmd:sheep} defines {cmd:sheep}::{cmd:sound()} that displays "Baa!" The
result is that when a routine in {cmd:animal} calls
{cmd:sound()}, it behaves as if the inheritance were reversed, the appropriate
{cmd:sound()} routine is called, and the user sees "Moo!" or "Baa!" 
If a new specific animal is added, and if the programmer forgets to define
{cmd:sound()}, then {cmd:animal}::{cmd:sound()} will run, and the user sees
"Squeak!".  In this case, that is supposed to be the sound of the system in
trouble, but it is really just the default action.

{p 4 4 2}
Let's code this example.  First, we will code the usual case:

	{cmd}class animal { 
		...
		void        sound()
		void        poke()
		...
	}

	void animal::sound() { "Squeak!" }

	void animal::poke()
	{
		...
		sound()
		...
	}

	class cow extends animal { 
		...  
	}

	class sheep extends animal { 
		...  
	}{txt}

{p 4 4 2} 
In the above example, when an animal, cow, or sheep is poked, among other
things, it emits a sound.  Poking is defined at the animal level because
poking is mostly generic across animals, except for the sound they emit.  If
{cmd:c} is an instance of {cmd:cow}, then one can poke that particular cow by
coding {cmd:c.poke()}.  {cmd:poke()}, however, is inherited from {cmd:animal},
and the generic action is taken, along with the cow emitting a generic
squeak.

{marker ex_virtual}{...}
{p 4 4 2}
Now we make {cmd:sound()} virtual:

	{cmd}class animal { 
		...
		virtual void  sound()
		void          poke()
		...
	}

	void animal::sound() { "Squeak!" }

	void animal::poke()
	{
		...
		sound()
		...
	}

	class cow extends animal { 
		...
		virtual void  sound()
	}

	void cow::sound() { "Moo!" }

	class sheep extends animal { 
		...
		virtual void  sound()
	}

	void sheep::sound() { "Baa!" }{txt}

{p 4 4 2}
Now let's trace through what happens when we poke a particular cow by coding
{cmd:c.poke()}.  {cmd:c}, to remind you, is a cow.  There is no
{cmd:cow::poke()} function; however, {cmd:c.poke()} executes
{cmd:animal::poke()}.  {cmd:animal::poke()} calls {cmd:sound()}, which, were
{cmd:sound()} not a virtual function, would be {cmd:animal::sound()}, which
would emit a squeak.  Poke a cow, get a "Squeak!"
Because {cmd:sound()} is virtual, {cmd:animal::poke()} called with a
{cmd:cow} calls {cmd:cow::sound()}, and we hear a "Moo!"

{p 4 4 2}
Focusing on syntax, it is important that both {cmd:cow} and {cmd:sheep} 
repeated {cmd:virtual void sound()} in their declarations.  If you define
function {it:S}::{it:f()}, then {it:f()} must be declared in {it:S}.  Consider
a case, however, where we have two breeds of cows, Angus and Holstein, and
they emit slightly different sounds.  The Holstein, being of Dutch origin,
gets a bit of a U sound into the moo in a way no native English speaker can
duplicate.  Thus we would declare two new classes, {cmd:angus} {cmd:extends}
{cmd:cow} and {cmd:holstein} {cmd:extends} {cmd:cow}, and we would
define {cmd:angus::sound()} and {cmd:holstein::sound()}.  
Perhaps we would not bother to define {cmd:angus::sound()}; then 
an Angus would get the generic cow sound.

{p 4 4 2}
But let's pretend that, instead, we defined {cmd:angus::sound()} and removed
the function for {cmd:cow::sound()}.  Then it does not matter whether
we include the line {cmd:virtual void sound()} in {cmd:cow}'s declaration.
Formally, it should be included, because the line of reverse declaration
should not be broken, but Mata does not care one way or the other.

{p 4 4 2}
A common use of {cmd:virtual} functions is to allow you to process a list of
objects without any knowledge of the specific type of object, as long as all
the objects are subclasses of the same base class:

        {cmd}class animal     animals

        animals = animal(3,1)

        animals[1] = cow()
        animals[2] = sheep()
        animals[3] = holstein()

        for(i=1; i<=length(animals); i++) {
                animals[i].sound()
        }{txt}

{p 4 4 2}
Note the use of {cmd:animals = animal(3,1)} to initialize the vector of
animals.  This is an example of how to create a nonscalar class instance, as
discussed in {it:{help m2_class##rem_instances:Obtaining instances of a class}}.

{p 4 4 2}
When the code above is executed, the appropriate sound for each animal will be
displayed even though {cmd:animals} is a vector declared to be of type
{cmd:class animal}.  Because {cmd:sound()} is {cmd:virtual}, the appropriate
sound from each specific animal child class is called.


{marker def_this}{...}
{title:Referring to the current class using this}

{p 4 4 2}
{cmd:this} is used within member functions to refer to the class as a whole.
For instance, consider the following:

		{cmd}class S { 
			real scalar     n
			real matrix     M
			void            make_M()
		}

		void S::make_M(real scalar n)
		{
			real scalar    i, j

			this.n = n 
			M = J(n, n, 0)
			for (i=1; i<=n; i++) { 
				for (j=1; j<=i; j++) M[i,j] = 1
			}
		}{txt}

{p 4 4 2}
In the above program, references to {cmd:M} are understood to be the class
instance definition of {cmd:M}.  References to {cmd:n}, however, refer to the
function's definition of {cmd:n} because the program's {cmd:n} has precedence
over the class's definition of it.  {cmd:this.n} is how one refers to the
class's variable in such cases.  {cmd:M} also could have been referred to as
{cmd:this.M}, but that was not necessary.

{p 4 4 2}
If, in function {cmd:S::f()}, it was necessary to call a function outside of
the class, and if that function required that we pass the class instance as a
whole as an argument, we could code {cmd:this} for the class instance.  The
line might read {cmd:outside_function(this)}.


{marker def_super}{...}
{title:Using super to access the parent's concept}

{p 4 4 2}
    The {cmd:super} modifier is a way of dealing with variables and functions
    that have been {help m2_class##def_override:overridden} in subclasses
    or, said differently, is a way of accessing the parent's concept of a
    variable or function.

{p 4 4 2}
    Let {cmd:T} extend {cmd:S} and let {cmd:t} be an instance of {cmd:T}.
    Then {cmd:t.f()} refers to {cmd:T::f()} if the function exists,
    and otherwise to {cmd:S::f()}.  {cmd:t.super.f()} always refers to
    {cmd:S::f()}.

{p 4 4 2}
    More generally, in a series of inheritances, {cmd:z.super.f()} refers 
    to the parent's concept of {cmd:f()} -- the {cmd:f()} the parent would 
    call if no {cmd:super} were specified -- {cmd:z.super.super.f()} refers 
    to the grandparent's concept of {cmd:f()}, and so on.  
    For example, let 
    {cmd:W} extend {cmd:V} extend {cmd:U} extend {cmd:T} extend {cmd:S}.
    Furthermore, assume

		{cmd:S::f()}   exists
		{cmd:T::f()}               does not exist
		{cmd:U::f()}   exists
		{cmd:V::f()}               does not exist
		{cmd:W::f()}               does not exist

{p 4 4 2}
    Finally, let {cmd:s} be an instance of {cmd:S}, {cmd:t} be an instance of
    {cmd:T}, and so on.  Then calls of the form {cmd:w.f()}, {cmd:w.super.f()},
     ..., {cmd:w.super.super.super.super.f()}, {cmd:v.f()}, {cmd:v.super.f()},
     and so on, result in execution of 

                                 Number of {cmd:super}s specified
		          0         1         2         3        4
		-------------------------------------------------------
		{cmd}s.      S::f()    
		t.      S::f()    S::f()
		u.      U::f()    S::f()    S::f()
		v.      U::f()    U::f()    S::f()    S::f()
		w.      U::f()    U::f()    U::f()    S::f()    S::f(){txt}
		-------------------------------------------------------


{marker def_cast}{...}
{title:Casting back to a parent}

{p 4 4 2}
     A {help m2_class##def_instance:class instance} may be treated as a class
     instance of a parent by casting.
     Assume {cmd:U} extends {cmd:T} extends {cmd:S}, and let {cmd:u}
     be an instance of {cmd:U}.  Then

		{cmd:(class T) u}

{p 4 4 2}
     is treated as an instance of {cmd:T}, and 

		{cmd:(class S) u}

{p 4 4 2}
     is treated as an instance of {cmd:S}.  {cmd:((class T) u)} could be used
     anywhere
     an instance of {cmd:T} is required and {cmd:((class S) u)} could be used
     anywhere an instance of {cmd:S} is required.

{p 4 4 2}
     For instance, assume {cmd:S::f()} is
     {help m2_class##def_override:overridden}
     by {cmd:T::f()}.  If an instance of {cmd:U} found it necessary to call
     {cmd:S::f()}, one way it could do that would be {cmd:u.super.super.f()}.
     Another would be

		{cmd:((class S) u).f()}


{marker rem_external}{...}
{title:Accessing external functions from member functions}

{p 4 4 2}
In the opening example, class {cmd:coord} contained a member function named
{cmd:length()}.  Had we been coding a regular (nonclass) function, we could not
have created that function with the name {cmd:length()}.  The name
{cmd:length()} is reserved by Mata for its own function that returns the length
(number of elements) of a vector; see {bf:{help mf_rows:[M-5] rows()}}.  We are
allowed to create a function named {cmd:length()} inside classes.  Outside of
member functions, {cmd:c.length()} is an unambiguous reference to {cmd:c}'s
definition of {cmd:length()}, and {cmd:length()} by itself is an unambiguous
reference to {cmd:length()}'s usual definition.

{p 4 4 2}
There is, however, possible confusion when coding member functions.
Let's add another member function to {cmd:coord}: {cmd:ortho()}, the code for
which reads

	{cmd}class coord scalar coord::ortho()
	{
		class coord scalar      newcoord
		real scalar             r, t

		r = length()
		t = angle()
		newcoord.x = r*cos(t)
		newcoord.y = r*sin(t) 
		return(newcoord)
	}{txt}

{p 4 4 2}
Note that in the above code, we call {cmd:length()}.
Because we are writing a member function, and because the class defines 
a member function of that name, {cmd:length()} is interpreted
as being a call to {cmd:coord}'s definition of {cmd:length()}.  If
{cmd:coord} did not define such a member function, then {cmd:length()}
would have been interpreted as a call to Mata's {cmd:length()}.

{p 4 4 2}
So what do we do if the class provides a function, externally 
there is a function of the same name, and we want the external function?
We prefix the function's name with double colons.
If we wanted {cmd:length()} to be interpreted as Mata's function and 
not the class's, we would have coded

		{cmd}r = ::length(){txt}

{p 4 4 2}
There is nothing special about the name {cmd:length()} here.  If the class
provided member function {cmd:myfcn()}, and there was an external definition
as well, and we wanted the externally defined function, we would code
{cmd:::myfcn()}.  In fact, it is not even necessary that the class provide a
definition.  If we cannot remember whether class {cmd:coord} includes
{cmd:myfcn()}, but we know we want the external {cmd:myfcn()} no matter what,
we can code {cmd:::myfcn()}.

{p 4 4 2}
Placing double-colons in front of external function names used inside the 
definitions of member functions is considered good style.  This way, if you
ever go back and add another member function to the class, you do not have to
worry that some already written member function is assuming that the name 
goes straight through to an externally defined function.


{marker rem_pointers}{...}
{title:Pointers to classes}

{p 4 4 2}
Just as you can obtain a pointer to any other Mata variable, you can obtain a
pointer to an instance of a class.  Recall our
{help m2_class##ex_virtual:example}
in {it:{help m2_class##def_virtual:Virtual functions}}
of animals that make various sounds when poked.

{p 4 4 2}
For the sake of example, we will obtain a pointer to an instance of a
{cmd:cow()} and access the {cmd:poke()} function through the pointer:

            {cmd}void pokeacow() {
                    class cow scalar                   c
                    pointer(class cow scalar) scalar   p

                    p = &c
                    p->poke()
            }{txt}

{p 4 4 2}
You access the member variables and functions through a pointer to a class with
the operator {cmd:->} just like you would for structures.  See 
{help m2_struct##tagpointer:Pointers to structures}
in {manhelp m2_struct M-2:struct} for more information.
{p_end}


{marker reference}{...}
{title:Reference}

{marker gould2018sp}{...}
{phang}
Gould, W. W. 2018.
{browse "http://www.stata-press.com/books/mata-book/":{it:The Mata Book: A Book for Serious Programmers and Those Who Want to Be}}.
College Station, TX: Stata Press.
{p_end}
