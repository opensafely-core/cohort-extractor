*! version 1.0.5  07nov2018

/* prototype for
 *
 * class __esdvector extends __stmatrix		residual standard deviations
 * class __ecormatrix extends __stmatrix	residual correlation
 * class __ecovmatrix extends __stmatrix	residual covariance
*/

local COV_NONE			0 // no covariance

local VAR_RESID_HOMOSKEDASTIC	1
local VAR_RESID_HETEROSKEDASTIC	2
local VAR_RESID_LINEAR		3
local VAR_RESID_POWER		4
local VAR_RESID_CONSTPOWER	5
local VAR_RESID_EXPONENTIAL	6

local VAR_RESID_TYPES `""no residual variance","homoskedastic""'
local VAR_RESID_TYPES `"`VAR_RESID_TYPES',"heteroskedastic","linear","power""'
local VAR_RESID_TYPES `"`VAR_RESID_TYPES',"constant power","exponential""'

local VAR_RESID_FITTED `""_yhat""'

local COR_RESID_INDEPENDENT	1
local COR_RESID_EXCHANGEABLE	2
local COR_RESID_AUTOREGRESS	3
local COR_RESID_MOVINGAVERAGE	4
local COR_RESID_CONTINUOUSAR1	5
local COR_RESID_TOEPLITZ	6
local COR_RESID_BANDED		7
local COR_RESID_UNSTRUCTURED	8

local COR_RESID_TYPES `""no residual correlation","independent""'
local COR_RESID_TYPES `"`COR_RESID_TYPES',"exchangeable","autoregressive""'
local COR_RESID_TYPES `"`COR_RESID_TYPES',"moving average""'
local COR_RESID_TYPES `"`COR_RESID_TYPES',"continuous AR(1)""'
local COR_RESID_TYPES `"`COR_RESID_TYPES',"banded""'
local COR_RESID_TYPES `"`COR_RESID_TYPES',"unstructured""'

local RESID_STDDEV		1
local RESID_CORR		2

if "$ECOVMATRIX_MATAH_INCLUDED" != "" {
	exit
}

mata:

mata set matastrict on

/* residual standard deviation vector					*/
class __esdvector extends __stmatrix
{
    protected:
	real scalar m_id		// by id
	real colvector m_ilab		// integer labels
	real scalar m_kpar		// # params
	real scalar m_ksd		// # std.dev. params
	real scalar m_trans		// transformation type
	real scalar m_type		// std.dev. structure
	class __stmatrix scalar m_b
	string scalar m_errmsg

	static string vector m_sdtypes

    protected:
	void new()
	void destroy()
	void clear()

    public:
	virtual void erase()
	virtual real scalar set_rowstripe()
	virtual real scalar set_colstripe()
	virtual real scalar set_matrix()

    public:
	real scalar construct()	// construct data structure

	real scalar compute_sd()
	real colvector sd()	// standard deviations
	real scalar kpar()
	real scalar ksd()
	real scalar type()
	real scalar transform()
	string scalar stype()
	string scalar errmsg()

	real scalar set_parameters()	// set parameter vector
	class __stmatrix scalar parameters()

	string scalar identifier()
	void return_post()
}

/* residual correlation matrix						*/
class __ecormatrix extends __stmatrix
{
    protected:
	real vector m_order		// AR(p), MA(q), unstruct dim, banded
	real scalar m_id		// by id
	real colvector m_ilab		// integer labels
	real scalar m_type		// correlation structure
	real scalar m_trans		// transformation
	real scalar m_kpar		// # parameters
	real scalar m_kcor		// # correlation params
	class __stmatrix scalar m_b
	string scalar m_errmsg

	static string scalar m_cortypes

    protected:
	void new()
	void destroy()
	void clear()

    public:
	virtual void erase()
	virtual real scalar set_rowstripe()
	virtual real scalar set_colstripe()
	virtual real scalar set_matrix()

    public:
	real scalar construct()	// construct data structure

	real matrix R()
	real vector order()
	real scalar kpar()
	real scalar kcor()
	real scalar type()
	real scalar transform()
	string scalar stype()
	string scalar errmsg()

	real scalar set_parameters()	// set parameter vector
	real scalar set_athrho()
	class __stmatrix scalar parameters()

	real scalar compute_R()

	void return_post()
	string scalar identifier()
}

/* residual structure covariance matrix					*/
class __ecovmatrix extends __stmatrix
{
    protected:
	class __esdvector vector m_sd		// std.dev. objects
	class __ecormatrix vector m_cor		// correlation objects
	real scalar m_isd, m_icor		// index cor/std.dev types
	real scalar m_lnsigma			// factored variance

	real scalar m_mxsdind, m_mxcorind	// max sd/cor observation index

	string scalar m_bysdvar, m_bycorvar	// name of Stata by-variables
	real colvector m_bysd, m_bycor		// egen'd Mata by-variables
	real matrix m_bysdtable, m_bycortable	// map Mata 2 Stata indices

	string scalar m_tvar, m_pvar		// Stata time & het vars names
	real colvector m_t, m_p			// Mata time & het variables

	string scalar m_isdvar, m_icorvar	// Stata hetero index vars
	real colvector m_indsd, m_indcor	// egen'd Mata index variables
	real matrix m_isdtable, m_icortable	// map Mata 2 Stata indices

	string scalar m_errmsg

    public:
	/* variance types						*/
	static real scalar NONE			// no residual variance
	static real scalar HOMOSKEDASTIC
	static real scalar HETEROSKEDASTIC
	static real scalar LINEAR
	static real scalar POWER
	static real scalar CONSTPOWER
	static real scalar EXPONENTIAL

	/* correlation types						*/
	static real scalar INDEPENDENT
	static real scalar EXCHANGEABLE
	static real scalar AUTOREGRESS
	static real scalar MOVINGAVERAGE
	static real scalar CONTINUOUSAR1
	static real scalar TOEPLITZ
	static real scalar BANDED
	static real scalar UNSTRUCTURED

	/* transforms							*/
	static real scalar LOG
	static real scalar ATANH
	static real scalar LOGIT

	/* object type							*/
	static real scalar STDDEV
	static real scalar CORR

	static string scalar FITTED

    protected:
	void new()
	void destroy()

	real scalar initialize_byvar()
	real scalar initialize_ivar()
	real scalar initialize_tvar()
	real scalar construct_stddevs()
	real scalar construct_correlations()

	real scalar sd_params_metric()
	real scalar cor_params_metric()

	void clear()

    public:
	virtual void erase()
	virtual real scalar set_rowstripe()
	virtual real scalar set_colstripe()
	virtual real scalar set_matrix()

    public:
	real scalar construct()	// construct data structure

	real scalar set_byindex()	// set panel by indices
	real scalar set_bypanel()	// set panel by Stata values
	real rowvector bypanels()
	real matrix bytable()		// by levels and # obs
	string scalar byvarname()	// by-variable name 
	real colvector byvector()	// by index vector (egen group'd)
	real scalar bycount()		// # by levels
	real matrix indtable()		// index levels and # obs
	string scalar indvarname()	// index-variable name
	real colvector indvector()	// stddev/corr index vector

	pointer (class __esdvector) scalar sd_obj()
	pointer (class __ecormatrix) scalar cor_obj()

	real scalar compute_V()
	real matrix V()
	real colvector sd()
	real matrix R()
	real scalar sigma()
	real scalar sigma2()
	real matrix scale_matrix()	// V^(-1/2)
	string scalar errmsg()

	void reestablish_views()	// reestablish byvar and tvar
					//  connections
	class __stmatrix scalar sd_parameters()
	class __stmatrix scalar cor_parameters()
	class __stmatrix scalar lnsigma()
	real scalar lnsigma0()

	real scalar set_parameters()
	real scalar set_sd_parameters()
	real scalar set_cor_parameters()
	void set_lnsigma()

	class __stmatrix scalar params_est_metric()
	class __stmatrix scalar params_metric()

	real scalar ksdpar()
	real scalar ksd()
	real scalar kcorpar()
	real scalar kcor()
	real scalar cor_order()

	real scalar vtype()
	real scalar ctype()
	string scalar svtype()	// variance structure type
	string scalar sctype()	// correlation structure type

	real scalar vtransform()
	real scalar ctransform()

	string scalar tvar_name()
	real colvector tvar()

	string scalar pvar_name()
	real colvector pvar()

	void set_fitted()

	string scalar identifier()	// covariance identifier
	void return_post()
}

end

global ECOVMATRIX_MATAH_INCLUDED 1
exit
