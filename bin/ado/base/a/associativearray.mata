*! version 1.0.0  27apr2016
version 14

set matastrict on

/*
	class AssociativeArray
		class interface into asarray*() 
*/


local version    1.00

/*
    PURPOSE

	class AssociativeArray provides a class-based interface to the 
        asarray*() functions described in -help mata asarray()-.

        Most users find the class interface preferable because calls
	are more terse; code using it is cleaner.


    NOTATION AND DEFINITIONS

        Notation:

                A.put(key, val)

           	val = A.get(key)

		where A is a -class AssociativeArray scalar-. 

        The unique feature of associative arrays is that key 
        can be a string or other types.  The vals returned can 
        be anything, and types can even vary element by element. 
       
        The type of the key is set when the class instance is
        created.  Keys are -string scalar-s by default.

        To change the type of key, reset the type using A.reinit()
        before inserting values into the array.  Keys may be -real-,
        -complex-, -numeric-, -string-, or even -pointer-.  Keys can be
        -scalar-s or -rowvector-s of fixed length up to 50.

        The type of the vals, on the other hand, is not set.  You may
        store any type in A, including vectors and matrices, and
        including structure and class instances.  As previously
        mentioned, values can even vary across elements.

    When you create an AssociativeArray instance by declaring 

	class AssociativeArray scalar   A

    or by coding 

	A = AssociativeArray()

    A.new() is run and the key type is set to the default -string
    scalar-.

    An array has the following (metadata) characteristics:

	keytype		-string- by default; may be any eltype. 

	keydim          1 by default; may be 1 <= keydim <= 50. 

	notfound        J(0, 0, .) by default. This is the value returned by 
                        A.get(key) when no value has been stored in A
                        at key.  You may set and reset the notfound
                        value at any time, and even repeatedly.

	minsize         These are the array's tuning parameters.  
	minratio        The array adjusts itself as you insert or delete 
	maxratio	values, of course. These tuning parameters have 
                        nothing to do with that.  They have to do with 
                        other aspects of the system that determine how 
                        quickly A.get(key) can be found.  As the array grows, 
                        the tables that allow A.get(key) to be found quickly 
                        are reorganized.  They are not reorganized every
                        time you insert or delete an element, but
                        eventually, they are reorganized.  When a
                        reorganization occurs, there can be a noticeable 
                        pause.  The tuning parameters determine when
                        reorganization occurs, and how much of an
                        adjustment is made.  If you know what the
                        characteristics of your usage will be, you can
                        set these parameters to optimize performance; 
                        see -help mata asarray()-. 

                        Nonetheless, resetting the default tuning
                        parameters is not recommended.  Considerable
                        thought has gone into determining the default
                        values.

    HOUSEKEEPING FUNCTIONS

        A.reinit(...) clears and reinitializes A to have the 
             characteristics specified.  Use A.reinit() to reset the 
             type or length of key before inserting values into A. 
             It is here that you can reset the tuning parameters, too, 
             but doing that is not recommended. 

	A.clear() deletes all members from A.  The characteristics of 
             A (type and length of key, tuning parameters) are not changed. 

        A.notfound() resets the notfound element value, the value returned 
             when you request A.v[key] and no val has been stored. 
             The default notfound value is J(0,0,.). 


     INSERTING, ACCESSING, AND DELETING VALUES AND KEY 


        A.get(key) returns the value stored at key or, if no value 
             has been stored, returns notfound. 

        A.put(key, val) sets or resets value stored at key.

        A.remove(key) deletes the value and key stored at key, if there
        is value stored there.  Note, removing is different from
        setting a "missing" value such as A.put(key, "") or A.put(key,
        .)  or even A.put(key, J(0,0,.)).  Those calls would store the
        specified value at key.  A.remove(key) removes the stored value
        at key from the array.

        A.exists(key) returns 1 if a value is stored at key, and 0
        otherwise.


     WORKING WITH THE ENTIRE ARRAY

        A.N() returns the number of elements defined in the array. 


        PASSING THROUGH ALL STORED VALUES, METHOD 1

		transmorphic  notfound 

                notfound = A.notfound() 
                for (val=a.firstval(), val!=notfound; val=A.nextval()) {
                          ...
                          ... A.key() ...
                          ... A.val() ...
              }

        A.firstval() returns the "first" value stored in the array, or 
        returns notfound if no values are stored. 

        A.nextval() returns the next value stored in the array, or 
        returns notfound when the last value has already been 
        returned.

        In the body of the loop, you may fetch the key corresponding 
        to the array element using A.key(), and you may fetch the 
        value again using A.val(). 


        PASSING THROUGH ALL STORED VALUES, METHOD 2

		transmorphic  loc

		for (loc=A.firstloc(); loc!=NULL; loc=A.nextloc() {
			key = A.key(loc)
                        val = A.val(loc)
                        .
                        .
                 }

        A.firstloc() returns the "location" loc of the "first" element
           of the array, or returns NULL if there are no elements
           defined.

	A.nextloc(loc) returns the location of the next element after loc, 
	    array, or returns NULL if there are no more elements defined.

	A.key(loc) returns the key at loc. 

	A.val(loc) returns the val at loc. 

*/

		
/* -------------------------------------------------------------------- */
					/* macro'd types		*/
local Asa	        AssociativeArray

local RealS             real scalar
local RealR		real rowvector
local RealM		real matrix
local StringS           string scalar

local BooleanS          real scalar
local TuningS		real scalar
local Key               transmorphic 
local Keys		`Key' matrix
local Loc               transmorphic
local Val               transmorphic

local AArray            transmorphic


mata:
/* -------------------------------------------------------------------- */
					/* class definition		*/
class `Asa'
{
	/* ------------------------------------------------------------ */
					/* Public functions		*/
    public:
	void            new()       // default initialization 
	void            reinit()    // optional reinitialization
	`Val'           notfound()  // set/query notfound value
        void            clear()     // clear and reset

        void            put()       // store val at key
	`Val'           get()       // return val at key 
	void            remove()    // deletion

        `BooleanS'      exists()    // whether key exists
	`RealS'         N()         // # of keys defined

	`Val'		firstval()     // val of first element or notfound
	`Val'		nextval()	// val or next  element or notfound
	`Loc'           firstloc()  // loc of first element or NULL
	`Loc'           nextloc()   // loc of next  element or NULL
	`Key'           key()       // key at loc
	`Val'           val()       // value at Loc

	`Keys'          keys()	    // all keys, internal sys order

	`RealS'         unused1()
	`RealS'         unused2()
	`RealS'         unused3()
	`RealS'         unused4()

	/* ------------------------------------------------------------ */
					/* Debugging functions		*/
    public:
	`RealS' 	current_version()

	`StringS'	keytype()
	`RealS'		keydim()

	`RealS'		array_size()
	void	        elements_test() 
	void		report()
	`RealR'		stats()
	void		dump()

	/* ------------------------------------------------------------ */
					/* Member variables		*/
    private:
	`AArray'        A
	`StringS'       keytype
        `RealS'         keydim 
        `TuningS'       minsize, minratio, maxratio
	`Val'           notfound, default_notfound
	`Loc'           loc

	`RealM'         punused1
	`RealM'         punused2
	`RealM'         punused3
	`RealM'         punused4

	`RealS'		punused1()
	`RealS'		punused2()
	`RealS'		punused3()
	`RealS'		punused4()
}
					/* class definition		*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
					/* Housekeeping functions	*/

void `Asa'::new()	
{
	keytype  = "string"
	keydim   = 1

	minsize = minratio = maxratio = .
	A       = asarray_create(keytype, keydim)

        notfound = default_notfound = asarray_notfound(A)
}


void `Asa'::reinit(| `StringS' keytype,  `RealS' keydim, 
                     `TuningS' minsize, 
                     `TuningS' minratio, `TuningS' maxratio)
{

	if (keytype=="") keytype = "string"
	if (keydim >= .) keydim  = 1

	this.keytype  = keytype
	this.keydim   = keydim 
	this.minsize  = minsize
        this.minratio = minratio
        this.maxratio = maxratio 
        
        A = NULL         

	if (minsize >= .) {
		A = asarray_create(keytype, keydim)
        }
	else if (minratio >= .) {
		A = asarray_create(keytype, keydim, minsize)
        }
	else if (maxratio >= .) {
		A = asarray_create(keytype, keydim, minsize, minratio)
        }
	else {
		A = asarray_create(keytype, keydim, minsize, minratio, 
                                                             maxratio)
        }
	if (notfound != default_notfound) asarray_notfound(A, notfound)
}


void `Asa'::clear()
{
        reinit(keytype, keydim, minsize, minratio, maxratio)
	// notfound handled by reinit()
}


`Val' `Asa'::notfound(|`Val' nf)
{
	if (args()==0) return(asarray_notfound(A))     // returns `Val'
	notfound = nf
		       return(asarray_notfound(A, nf)) // returns void
}

/*
	version = A.current_version()

	Consider two version numbers, 
		v1     A.version() of code program you have 
                       written expects. 

		v2     A.version() current.

	If v2>v1, then there are new features.  You need to recompile 
		if you want to use the new features 

        If floor(v2) > floor(v1), you must recompile your code even if
                you do not intend to use the new features.
*/

`RealS' `Asa'::current_version()    return(`version')


/* -------------------------------------------------------------------- */
					/* Element functions	        */



`Val' `Asa'::get(`Key' key)             return(asarray(A, key))

void  `Asa'::put(`Key' key, `Val' val)  return(asarray(A, key, val))

void       `Asa'::remove(`Key' key)  asarray_remove(A, key)

`BooleanS' `Asa'::exists(`Key' key)  return(asarray_contains(A, key))


/* -------------------------------------------------------------------- */
					/* Entire array functions    	*/


`RealS'    `Asa'::N()                return(asarray_elements(A))

`Loc'      `Asa'::firstloc()         return(asarray_first(A))
`Loc'      `Asa'::nextloc(`Loc' loc) return(asarray_next(A, loc))


`Val' `Asa'::firstval()
{
	if ((loc = firstloc()) != NULL) return(val(loc))
	return(notfound)
}

`Val' `Asa'::nextval()
{
	if (loc == NULL) return(notfound)
	if ((loc = nextloc(loc)) != NULL) return(val(loc))
	return(notfound)
}

`Key' `Asa'::key(| `Loc' userloc)
{
	return(asarray_key(A, (args() ? userloc : loc)))
}

`Val' `Asa'::val(| `Val' userloc) 
{
	return(asarray_contents(A, (args() ? userloc : loc)))
}

`Keys' `Asa'::keys()   return(asarray_keys(A))
	

/* -------------------------------------------------------------------- */
					/* Debugging functions		*/

`StringS'    `Asa'::keytype()       return(keytype)
`RealS'      `Asa'::keydim()        return(keydim)

`RealS'      `Asa'::array_size()    return(asarray_size(A))
void         `Asa'::elements_test() asarray_elements_test(A)

void         `Asa'::report()        asarray_report(A)

`RealR'      `Asa'::stats()         return(asarray_stats(A))

void         `Asa'::dump()          asarray_dump(A)
	
/* -------------------------------------------------------------------- */
end
