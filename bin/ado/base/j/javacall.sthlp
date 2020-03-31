{smcl}
{* *! version 1.2.6  23may2019}{...}
{vieweralsosee "[P] javacall" "mansection P javacall"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] Java intro" "help java intro"}{...}
{vieweralsosee "[P] python" "help python"}{...}
{vieweralsosee "Stata-Java API Specification" "browse http://www.stata.com/java/api16"}{...}
{vieweralsosee "Java Platform, Standard Edition 8 API Specification" "browse http://docs.oracle.com/javase/8/docs/api/"}{...}
{viewerjumpto "Syntax" "javacall##syntax"}{...}
{viewerjumpto "Description" "javacall##description"}{...}
{viewerjumpto "Links to PDF documentation" "javacall##linkspdf"}{...}
{viewerjumpto "Options" "javacall##options"}{...}
{viewerjumpto "Example" "javacall##example"}{...}
{p2colset 1 17 16 2}{...}
{p2col:{bf:[P] javacall} {hline 2}}Call a Java plugin{p_end}
{p2col:}({mansection P javacall:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt javacall} {it:class} {it:method} [{varlist}] {ifin}{cmd:,}
{c -(}{opt jars(jar_files)}|{opt classpath(classpath)}{c )-}
[{opt args(arg_list)}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:javacall} calls a Java plugin by invoking a static method.  The
{it:method} to be called must be implemented with a specific Java signature in
the following form:

	{cmd:static int} {it:java_method_name}{cmd:(String[] args)}

{pstd}
{cmd:javacall} requires the {it:class} to be a fully 
qualified name that includes the class's package specification.  
For example, to call a method named {cmd:method1} from
class {bf:Class1}, which was part of package {bf:com.mydomain} and packaged
in {bf:myjarfile.jar}, the following command would be used:

	{com}. javacall com.mydomain.Class1 method1, jars(myjarfile.jar){txt}

{pstd}
Optionally, a varlist, an {helpb if} condition, or an {helpb in} condition may
be specified.  Stata provides a Java package containing various classes and
methods allowing access to the varlist, {cmd:if} condition, and {cmd:in}
condition; see {helpb Java_intro:[P] Java intro} for more details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P javacallRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt jars(jar_files)} specifies the JAR files to be added to the class path.
{it:jar_files} may be one JAR file or a list of JAR files separated either
by spaces or by semicolons.  Stata will search along the
{help sysdir:ado-path} for the specified JAR files and add them to the Java
class path for the plugin.  Either {opt jars()} or {opt classpath()} must be
specified.

{phang}
{opt classpath(classpath)} specifies the class path to use.  {it:classpath}
may be a single class path or multiple paths specified using a
platform-specific Java class path.  On Windows, multiple paths are
separated by semicolons.  On Mac and Unix, multiple paths are separated
by colons.  Either {cmd:jars()} or {cmd:classpath()} must be specified.

{pmore}
This option is provided as a convenience for use during the development
process.  For example, a developer might use this option to set the class path
to the directory where their compiler is generating {cmd:.class} files,
allowing newly compiled code to be tested quickly without the need to build a
JAR file.  After the development process is complete, a JAR file should be
created, and the {cmd:jars()} option should be used instead.

{phang}
{opt args(args_list)} specifies the {it:args_list} that will be passed to the
Java method as a string array.  If {opt args()} is not specified, the array
will be empty.


{marker example}{...}
{title:Example}

{pstd}
Consider two variables needing to store integers too large to be held 
accurately in a {help datatype:double} or a {help datatype:long},
so instead they are stored as {help datatype:strings}.  If we 
needed to subtract the values in one variable from another, 
we could write a plugin using Java's BigInteger class.  
The following code shows how we could perform the task:
  
    /* Java class begins here */
    import java.math.BigInteger;
    import com.stata.sfi.*;
    public class MyClass {
       /* Define the static method with the correct signature */
       public static int sub_string_vals(String[] args) {
	  long nobs1 = Data.getObsParsedIn1() ;
	  long nobs2 = Data.getObsParsedIn2() ;
	  BigInteger b1, b2 ;

	  if (Data.getParsedVarCount() != 2) {
	      SFIToolkit.error("Exactly two variables must be specified\n") ;
	      return(198) ;
	  }
	  if (args.length != 1) {
	      SFIToolkit.error("New variable name not specified\n") ;
	      return(198) ;
	  }

	  if (Data.addVarStr(args[0], 10)!=0) {
	      SFIToolkit.errorln("Unable to create new variable " + args[0]) ;
	      return(198) ;
	  }

	  // get the real indexes of the varlist
	  int mapv1 = Data.mapParsedVarIndex(1) ;
	  int mapv2 = Data.mapParsedVarIndex(2) ;
	  int resv  = Data.getVarIndex(args[0]) ;

	  if (!Data.isVarTypeStr(mapv1) || !Data.isVarTypeStr(mapv2)) {
	      SFIToolkit.error("Both variables must be strings\n") ;
	      return(198) ;
	  }

	  for(long obs=nobs1; obs<=nobs2; obs++) {
	      // Loop over the observations

	      if (!Data.isParsedIfTrue(obs)) continue ;
	      // skip any observations omitted from an [if] condition
	      try {
	          b1 = new BigInteger(Data.getStr(mapv1, obs)) ;
	          b2 = new BigInteger(Data.getStr(mapv2, obs)) ;
	          Data.storeStr(resv, obs, b1.subtract(b2).toString()) ;
	      }
	      catch (NumberFormatException e) { }
	  }
	  return(0) ;		
       }
    }
    /* Java class ends here */
