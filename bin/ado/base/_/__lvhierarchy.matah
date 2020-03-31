*! version 1.0.5  27nov2018

local HIERARCHY_LV_NAMES	1
local HIERARCHY_PATH		2
local HIER_FALSE		0
local HIER_TRUE			1

if "$LVHIERARCHY_MATAH_INCLUDED" != "" {
	exit
}

mata:

mata set matastrict on

class __lvpath
{
    protected:
	string scalar m_name
	struct nlparse_node scalar m_top	// tree top
	string scalar m_errmsg

    public:
	static string vector m_hsyms	// special symbols e.g. _n, _all
	static string scalar LATENT_VARIABLE

    protected:
	void new()
	void destroy()

    protected:
	real scalar parse_path()
	void _traverse()
	void _esrevart()
	struct nlparse_node scalar _clone()
	real scalar sort_crossed()

    public:
	real scalar init()
	void clear()

	string scalar name()
	real scalar kvar()
	string scalar path()
	string scalar varlist()
	string vector hierarchy()
	string scalar errmsg()
	real scalar validate()
	void display()

	real scalar isequal()
	real scalar iscompatible()
	real vector order()

	class __lvpath scalar clone()
}

struct _lvhinfo
{
	real scalar kpath			// depth (# paths)
	real vector hrange			// __lvhierarchy.path() range
	pointer (real matrix) vector hinfo	// kh panel matrices
	real colvector iorder
	string vector hvars			// hierarchy path variables
	real colvector panels			// residual panel vector
	real matrix pinfo			// residual panel info matrix
}

class __lvhierarchy
{
    protected:
	pointer (class __lvpath) vector m_paths	// LV paths
	real scalar m_resolved
	string scalar m_touse		// super estimation sample
	string vector m_LVs		// LV names
	string vector m_iREvars		// LV Stata index tempvars
	real vector m_kRE		// RE counts
	real matrix m_indexh		// hierarchy group membership 

	/* sort order only applies to a single hierarchy and/or 
	 *  if a time variable exists					*/
	string scalar m_tvar		// time variable
	string scalar m_gvar		// group variable
	real scalar m_ih		// selected hierarchy
	real scalar m_ipanelvar		// index to m_REindex for current 
					//  Stata panel vector
	struct _lvhinfo vector m_hinfo	// panel infor for each level in 
					//  all hierarchies
	real colvector m_groups		// group indices
	real matrix m_ginfo		// panel info for groups, could
	real colvector m_iorder		//  be (1,N) for single panel

	string scalar m_errmsg

	class __tempnames scalar m_tnames

    protected:
	void new()
	void destroy()
	void clear()

	string scalar LV_index_stvar()	 // Stata LV index var name
	string scalar path_index_stvar() // Stata path index tempvar name

	pointer (struct _lvhinfo) scalar hinfo()	// hinfo for hierarchy k

    public:
	real scalar add_path()
	real scalar resolve_paths()	// order hierarchical paths 
	real scalar gen_sort_order()	// hierarchy sort order indices
	real scalar has_groupvar()
	real scalar set_groupvar()
	string scalar groupvar()	// residual group variable
	string scalar touse()
	void set_touse()

	real scalar set_current_hierarchy_index()
	real scalar current_hierarchy_index()
	real colvector current_sort_order()  // hierarchy index sort order 
	real scalar gen_current_panel_info() // generate hierarchy panel
					     //  matrices; assumes data ordered
	real colvector current_panel_vector()	// overall panel vector
	real matrix current_panel_info()	// panel matrix

	real scalar path_hierarchy_index() // hierarchy index containing path
	real scalar gen_LV_indices()	// generate index for LV path

	real scalar path_count()	// total # paths (rows(paths()))
	string matrix paths()		// all paths for all hierarchies
	string vector hier_paths()	// paths for hierarchical group ih
	string vector hier_LVs()	// LVs for hierarchical group ih
	real scalar hier_count()	// number of hierarchical groups
	real matrix hier_indices()	// hierarchical group membership indices
	pointer (struct _lvhinfo) scalar current_hinfo() // hinfo for current
							 //  hierarchy
	string vector LVnames()		// LVs for all hierarchical paths
	string vector path_LVnames()	// LVs for a specified hierarchical path
	real scalar set_path_LVname_order() 	// reorder LVs for a specified
					     	//  hierarchical path
	real colvector index_vector()		// Mata index vector by 
						//  m_iREvars index
	real colvector LV_index_vector()   	// Mata LV index vector
	real colvector path_index_vector() 	// Mata path index vector
	real scalar LV_index_count()		// # RE for LV
	class __stmatrix scalar hierarchy_stats()	// stats: #RE, mean,
							//  min, max
	void display()
	void return_post()		// post hierarchy info to return
	string scalar errmsg()
}

end

global LVHIERARCHY_MATAH_INCLUDED 1

exit
