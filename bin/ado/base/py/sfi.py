'''
*! version 1.0.0  06may2019
'''
__all__ = [
    "Characteristic", "Data", "Datetime", "Frame", "FrameError", 
    "Macro", "Mata", "Matrix", "Missing", "Platform", "Preference", 
    "Scalar", "SFIError", "SFIToolkit", "StrLConnector", "ValueLabel"]
__version__ = '0.1.0'
__author__ = 'StataCorp LLC'

from math import ceil, log, floor
from platform import platform
import sys
import datetime

import stata_plugin as _stp

class Characteristic:
    """
    This class provides access to Stata characteristics.
    """

    def __init__(self):
        pass

    @staticmethod
    def getDtaChar(name):
        """
        Get a characteristic for the current dataset.

        Parameters
        ----------
        name : str
            The name of the characteristic to retrieve.

        Returns
        -------
        str
            Value of the characteristic. Returns an empty string if the 
            characteristic is not found.
        """	
        return _stp._st_getdtachar(name)

    @staticmethod
    def getVariableChar(var, name):
        """
        Get a characteristic for a variable in the current dataset.

        Parameters
        ----------
        var : str or int
            Name or index of the variable.

        name : str
            Name of the characteristic.

        Returns
        -------
        str
            Value of the characteristic. Returns an empty string if the 
            characteristic is not found.

        Raises
        ------
        ValueError
            If `var` is not found or is out of :ref:`range <ref-datarange>`.
        """
        oindex = _get_var_index_single(var)
        var = _stp._st_getvarname(oindex)

        return _stp._st_getvariablechar(var, name)

    @staticmethod
    def setDtaChar(name, value):
        """
        Set a characteristic for the current dataset.

        Parameters
        ----------
        name : str
            Name of the characteristic.

        value : str
            Value to set.
        """
        return _stp._st_setdtachar(name, value)

    @staticmethod
    def setVariableChar(var, name, value):
        """
        Set a characteristic for a variable in the current dataset.

        Parameters
        ----------
        var : str or int
            Name or index of the variable.

        name : str
            Name of the characteristic.

        value : str
            Value to set.

        Raises
        ------
        ValueError
            If `var` is not found or is out of :ref:`range <ref-datarange>`.
        """
        oindex = _get_var_index_single(var)
        var = _stp._st_getvarname(oindex)

        return _stp._st_setvariablechar(var, name, value)


def _check_all(iterable):
    for element in iterable:
        if not element:
            return False
    return True

def _check_any(iterable):
    for element in iterable:
        if element:
            return True
    return False

def _check_var(var, nvars=None):
    if nvars is None:
        nvars = _stp._st_getvarcount()
	
    if var<-nvars or var>=nvars: 
        return True
    else:
        return False

def _check_obs(obs, nobs=None):
    if nobs is None:
        nobs = _stp._st_getobstotal()

    if obs<-nobs or obs>=nobs: 
        return True
    else:
        return False

def _get_var_index_all(ovar):
    if isinstance(ovar, int):
        if _check_var(ovar): 
            raise ValueError("%d: var out of range" % (ovar))

        return [ovar]
    elif isinstance(ovar, str):
        oret = []
        ovar = ovar.split()
        for o in ovar:
            ovari = _stp._st_getvarindex(o)
            if ovari<0:
                raise ValueError("variable %s not found" % (o))
            oret.append(ovari)
        return oret
    elif isinstance(ovar, list):
        if _check_all(isinstance(o, int) for o in ovar):
            oret = []
            nvars = _stp._st_getvarcount()
            for o in ovar:
                if _check_var(o, nvars): 
                    raise ValueError("%d: var out of range" % (o))
                oret.append(o)

            return oret
        elif _check_all(isinstance(o, str) for o in ovar):
            oret = []
            for o in ovar:
                ovari = _stp._st_getvarindex(o)
                if ovari<0:
                    raise ValueError("variable %s not found" % (o))
                oret.append(ovari)

            return oret
        else:
            raise TypeError("all values for variable input must be a string or an integer")
    elif isinstance(ovar, tuple):
        if _check_all(isinstance(o, int) for o in ovar):
            oret = []
            nvars = _stp._st_getvarcount()
            for o in ovar:
                if _check_var(o, nvars): 
                    raise ValueError("%d: var out of range" % (o))
                oret.append(o)

            return oret
        elif _check_all(isinstance(o, str) for o in ovar):
            oret = []
            for o in ovar:
                ovari = _stp._st_getvarindex(o)
                if ovari<0:
                    raise ValueError("variable %s not found" % (o))
                oret.append(ovari)

            return oret
        else:
            raise TypeError("all values for variable input must be a string or an integer")
    elif hasattr(ovar, "__iter__"): 
        ovar = tuple(ovar)
        if _check_all(isinstance(o, int) for o in ovar):
            oret = []
            nvars = _stp._st_getvarcount()
            for o in ovar:
                if _check_var(o, nvars):
                    raise ValueError("%d: var out of range" % (o))
                oret.append(o)

            return oret
        elif _check_all(isinstance(o, str) for o in ovar):
            oret = []
            for o in ovar:
                ovari = _stp._st_getvarindex(o)
                if ovari<0:
                    raise ValueError("variable %s not found" % (o))
                oret.append(ovari)

            return oret
        else:
            raise TypeError("all values for variable input must be a string or an integer")
    else:
        raise TypeError("unsupported operand type(s) for variable input")

def _get_var_index_single(ovar):
    if isinstance(ovar, int):
        if _check_var(ovar):
            raise ValueError("%d: var out of range" % (ovar))
        return ovar
    elif isinstance(ovar, str):
        ovari = _stp._st_getvarindex(ovar)
        if ovari<0:
            raise ValueError("variable %s not found" % (ovar))
        return ovari
    else:
        raise TypeError("unsupported operand type(s) for variable input")

def _get_var_index(ovar):
    if isinstance(ovar, int):
        if _check_var(ovar): 
            raise ValueError("%d: var out of range" % (ovar))

        return ovar
    else:
        raise TypeError("unsupported operand type(s) for variable input")

def _get_var_name(ovar):
    if isinstance(ovar, str):
        ovari = _stp._st_getvarindex(ovar)
        if ovari<0:
            raise ValueError("variable %s not found" % (ovar))
        return ovar
    else:
        raise TypeError("unsupported operand type(s) for variable input")

def _get_obs_index(oobs):
    if isinstance(oobs, int):
        if _check_obs(oobs):
            raise ValueError("%d: obs out of range" % (oobs))

        return [oobs]
    elif isinstance(oobs, list):
        if _check_all(isinstance(o, int) for o in oobs):
            nobs = _stp._st_getobstotal()
            if _check_all(o>-nobs and o<nobs for o in oobs):
                return oobs 
            raise ValueError("obs out of range")
        else:
            raise TypeError("all values for observation index must be an integer")
    elif isinstance(oobs, tuple):
        if _check_all(isinstance(o, int) for o in oobs):
            nobs = _stp._st_getobstotal()
            if _check_all(o>-nobs and o<nobs for o in oobs):
                return list(oobs) 
            raise ValueError("obs out of range")
        else:
            raise TypeError("all values for observation index must be an integer")
    elif hasattr(oobs, "__iter__"):
        oobs = tuple(oobs)
        if _check_all(isinstance(o, int) for o in oobs):
            nobs = _stp._st_getobstotal()
            if _check_all(o>-nobs and o<nobs for o in oobs):
                return list(oobs) 
            raise ValueError("obs out of range")
        else:
            raise TypeError("all values for observation index must be an integer")
    else:
        raise TypeError("unsupported operand type(s) for variable input")

def _get_obs_max(oobs):
    maxo = max(oobs)
    mino = min(oobs)
    nobs = _stp._st_getobstotal()

    if maxo < 0: 
        maxo = maxo + nobs 
    if mino < 0:
        mino = mino + nobs

    if maxo >= mino:
        return maxo 
    else:
        return mino


class _DefaultMissing:
	def __repr__(self):
		return "_DefaultMissing()"

class Data:
    """
    This class provides access to the current Stata dataset. All variable 
    and observation numbering begins at 0. The allowed values for the 
    variable index `var` and the observation index `obs` are

    .. _ref-datarange:

    .. centered:: **-nvar** `<=` `var` `<` **nvar**

    and

    .. centered:: **-nobs** `<=` `obs` `<` **nobs**

    Here **nvar** is the number of variables defined in the dataset 
    currently loaded in Stata, which is returned by :meth:`getVarCount()`. 
    **nobs** is the number of observations defined in the dataset 
    currently loaded in Stata, which is returned by :meth:`getObsTotal()`.

    Negative values for `var` and `obs` are allowed and are interpreted 
    in the usual way for Python indexing. In all functions that 
    take `var` as an argument, `var` can be specified as either the 
    variable index or the variable name. Note that passing the 
    variable index will be more efficient because looking up the index 
    for the specified variable name is avoided for each function call.
    """

    def __init__(self):
        pass

    @staticmethod
    def addObs(n, nofill=False):
        """
        Add `n` observations to the current Stata dataset. By default, 
        the added observations are filled with the appropriate 
        missing-value code. If `nofill` is specified and equal to True, 
        the added observations are not filled, which speeds up the process. 
        Setting `nofill` to True is not recommended. If you choose this setting, 
        it is your responsibility to ensure that the added observations are 
        ultimately filled in or removed before control is returned to Stata.

        There need not be any variables defined to add observations.  
        If you are attempting to create a dataset from nothing, you can 
        add the observations first and then add the variables.

        Parameters
        ----------
        n : int
            Number of observations to add.

        nofill : bool, optional
            Do not fill the added observations. Default is False.

        Raises
        ------
        ValueError
            If the number of observations to add, `n`, exceeds the limit of observations.
        """
        if nofill is True:	
            bnofill = 1
        elif nofill is False:
            bnofill = 0
        else:
            raise TypeError("nofill must be a boolean value")

        return _stp._st_addobs(n, bnofill)

    @staticmethod
    def addVarByte(name):
        """
        Add a variable of type **byte** to the current Stata dataset.

        Parameters
        ----------
        name : str
            Name of the variable to be created.

        Raises
        ------
        ValueError
            If `name` is not a valid Stata variable name.
        """
        return _stp._st_addvarbyte(name)

    @staticmethod
    def addVarDouble(name):
        """
        Add a variable of type **double** to the current Stata dataset.

        Parameters
        ----------
        name : str
            Name of the variable to be created.

        Raises
        ------
        ValueError
            If `name` is not a valid Stata variable name.
        """
        return _stp._st_addvardouble(name)

    @staticmethod
    def addVarFloat(name):
        """
        Add a variable of type **float** to the current Stata dataset.

        Parameters
        ----------
        name : str
            Name of the variable to be created.

        Raises
        ------
        ValueError
            If `name` is not a valid Stata variable name.
        """
        return _stp._st_addvarfloat(name)

    @staticmethod
    def addVarInt(name):
        """
        Add a variable of type **int** to the current Stata dataset.

        Parameters
        ----------
        name : str
            Name of the variable to be created.

        Raises
        ------
        ValueError
            If `name` is not a valid Stata variable name.
        """
        return _stp._st_addvarint(name)

    @staticmethod
    def addVarLong(name):
        """
        Add a variable of type **long** to the current Stata dataset.

        Parameters
        ----------
        name : str
            Name of the variable to be created.

        Raises
        ------
        ValueError
            If `name` is not a valid Stata variable name.
        """
        return _stp._st_addvarlong(name)

    @staticmethod
    def addVarStr(name, length):
        """
        Add a variable of type **str** to the current Stata dataset.

        Parameters
        ----------
        name : str
            Name of the variable to be created.

        length : int
            Initial size of the variable. If the length is greater 
            than :meth:`getMaxStrLength()`, then a variable of type **strL** 
            will be created.

        Raises
        ------
        ValueError
            This error can be raised if

              - `name` is not a valid Stata variable name.
              - `length` is not a positive integer.
        """
        return _stp._st_addvarstr(name, length)

    @staticmethod
    def addVarStrL(name):
        """
        Add a variable of type **strL** to the current Stata dataset.

        Parameters
        ----------
        name : str
            Name of the variable to be created.

        Raises
        ------
        ValueError
            If `name` is not a valid Stata variable name.
        """
        return _stp._st_addvarstrl(name)

    @staticmethod
    def allocateStrL(sc, size, binary=True):
        """
        Allocate a **strL** so that a buffer can be stored using 
        :meth:`writeBytes()`; the contents of the **strL** will not be initialized.

        Parameters
        ----------
        sc : StrLConnector
            The :class:`~StrLConnector` representing a **strL**.

        size : int
            The size in bytes.

        binary : bool, optional
            Mark the data as binary. Note that if the data are not marked as 
            binary, Stata expects that the data be UTF-8 encoded. An alternate 
            approach is to call :meth:`storeAt()`, where the encoding is automatically 
            handled. Default is True.
        """
        if not isinstance(sc, StrLConnector):
            raise TypeError("sc must be an instance of class StrLConnector")

        if binary is True:	
            bbin = 1 
        elif binary is False:
            bbin = 0
        else:
            raise TypeError("binary must be a boolean value")

        return _stp._st_allocatestrl(sc.var, sc.obs, size, bbin)

    @staticmethod
    def dropVar(var):
        """
        Drop the specified variables from the current Stata dataset.

        Parameters
        ----------
        var : int, str, or list-like
            Variables to drop. It can be specified as a single variable index 
            or name, or an iterable of variable indices or names.

        Raises
        ------
        ValueError
            If any of the variable indices or names specified in `var` is out of :ref:`range <ref-datarange>` or not found.
        """
        oindex = _get_var_index_all(var)
        oindex.reverse()
        for o in oindex:
            _stp._st_dropvar(o)

    @staticmethod
    def get(var=None, obs=None, selectvar=None, valuelabel=False, missingval=_DefaultMissing()):
        """
        Read values from the current Stata dataset.

        Parameters
        ----------
        var : int, str, or list-like, optional
            Variables to access. It can be specified as a single variable
            index or name, or an iterable of variable indices or names. 
            If `var` is not specified, all the variables are specified.

        obs : int or list-like, optional
            Observations to access. It can be specified as a single 
            observation index or an iterable of observation indices. 
            If `obs` is not specified, all the observations are specified.

        selectvar : int or str, optional
            Observations for which `selectvar!=0` will be selected. If `selectvar`
            is an integer, it is interpreted as a variable index. If `selectvar` 
            is a string, it should contain the name of a Stata variable. 
            Specifying `selectvar` as "" has the same result as not 
            specifying `selectvar`, which means no observations are excluded. 
            Specifying `selectvar` as -1 means that observations with missing 
            values for the variables specified in `var` are to be excluded.

        valuelabel : bool, optional
            Use the value label when available. Default is False.

        missingval : :ref:`_DefaultMissing <ref-defaultmissing>`, `optional`
            If `missingval` is specified, all the missing values in the returned 
            list are replaced by this value. If it is not specified, the numeric 
            value of the corresponding missing value in Stata is returned.

        Returns
        -------
        List
            A list of lists containing the values from the dataset in memory. 
            Each sublist contains values for one observation.

        Raises
        ------
        ValueError
            This error can be raised if

              - any of the variable indices or names specified in `var` is out of :ref:`range <ref-datarange>` or not found.
              - any of the observation indices specified in `obs` is out of :ref:`range <ref-datarange>`.
              - `selectvar` is out of :ref:`range <ref-datarange>` or not found.


        .. _ref-defaultmissing:

        Notes
        -----
        The definition of the utility class **_DefaultMissing** is as follows::

            class _DefaultMissing:
                def __repr__(self):
                    return "_DefaultMissing()"

        This class is defined only for the purpose of specifying the default 
        value for the parameter `missingval` of the above function. Users are 
        not recommended to use this class for any other purpose.
        """
        if valuelabel is True:	
            bvalabel = 1 
        elif valuelabel is False:
            bvalabel = 0
        else:
            raise TypeError("valuelabel must be a boolean value")

        bmissing = 0
        if not isinstance(missingval, _DefaultMissing):
            bmissing = 1

        svar = -1
        if selectvar is None or selectvar=="":
            svar = -2
        elif selectvar!=-1:
            svar = _get_var_index_single(selectvar)	

        if var is None and obs is None:
            if bmissing == 1:
                return _stp._st_getdata(var, obs, svar, 1, bvalabel, missingval)
            else:
                return _stp._st_getdata(var, obs, svar, 1, bvalabel)
        else:
            if var is None: 
                vars = None
            else:
                vars = _get_var_index_all(var)

            if obs is None:
                obss = None
            else:
                obss = _get_obs_index(obs)

            if bmissing == 1:
                return _stp._st_getdata(vars, obss, svar, 1, bvalabel, missingval)
            else:
                return _stp._st_getdata(vars, obss, svar, 1, bvalabel)

    @staticmethod
    def getAsDict(var=None, obs=None, selectvar=None, valuelabel=False, missingval=_DefaultMissing()):
        """
        Read values from the current Stata dataset and store them in 
        a dictionary. The keys are the variable names. The values are 
        the data values for the corresponding variables.

        Parameters
        ----------
        var : int, str, or list-like, optional
            Variables to access. It can be specified as a single variable
            index or name, or an iterable of variable indices or names. 
            If `var` is not specified, all the variables are specified.

        obs : int or list-like, optional
            Observations to access. It can be specified as a single 
            observation index or an iterable of observation indices. 
            If `obs` is not specified, all the observations are specified.

        selectvar : int or str, optional
            Observations for which `selectvar!=0` will be selected. If 
            `selectvar` is an integer, it is interpreted as a variable 
            index. If `selectvar` is a string, it should contain the name 
            of a Stata variable. Specifying `selectvar` as "" has 
            the same result as not specifying `selectvar`, which means no 
            observations are excluded. Specifying `selectvar` as -1 means 
            that observations with missing values for the variables specified 
            in `var` are to be excluded.

        valuelabel : bool, optional
            Use the value label when available. Default is False.

        missingval : :ref:`_DefaultMissing<ref-defaultmissing>`, `optional`
            If `missingval` is specified, all the missing values in the returned 
            dictionary are replaced by this value. If it is not specified, the numeric 
            value of the corresponding missing value in Stata is returned.

        Returns
        -------
        dictionary
            Return a dictionary containing the data values from the dataset 
            in memory.

        Raises
        ------
        ValueError
            This error can be raised if

              - any of the variable indices or names specified in `var` is out of :ref:`range <ref-datarange>` or not found.
              - any of the observation indices specified in `obs` is out of :ref:`range <ref-datarange>`.
              - `selectvar` is out of :ref:`range <ref-datarange>` or not found.
        """
        if valuelabel is True:	
            bvalabel = 1 
        elif valuelabel is False:
            bvalabel = 0
        else:
            raise TypeError("valuelabel must be a boolean value")

        bmissing = 0
        if not isinstance(missingval, _DefaultMissing):
            bmissing = 1

        svar = -1 
        if selectvar is None or selectvar=="":
            svar = -2
        elif selectvar!=-1:
            svar = _get_var_index_single(selectvar)

        if var is None: 
            nvars = _stp._st_getvarcount()
            vars = list(range(nvars))
        else:
            vars = _get_var_index_all(var)

        vars_len = len(vars)

        if obs is None:
            nobs = _stp._st_getobstotal()
            if nobs==1: 
                obss=[0]
                obss_len = 1
            else:
                obss = None
                obss_len = 0
        else:
            obss = _get_obs_index(obs)
            obss_len = len(obss)

        if vars_len==1:
            lvarnames = _stp._st_getvarname(vars[0])
            if bmissing == 1:
                ldata = _stp._st_getdata(vars, obss, svar, 2, bvalabel, missingval)
            else:
                ldata = _stp._st_getdata(vars, obss, svar, 2, bvalabel)

            zdata = {}
            if len(ldata) > 0:
                zdata[lvarnames] = ldata
            return zdata
        elif obss_len==1: 
            lvarnames = [_stp._st_getvarname(v) for v in vars]
            if bmissing == 1:
                ldata = _stp._st_getdata(vars, obss, svar, 2, bvalabel, missingval)
            else:
                ldata = _stp._st_getdata(vars, obss, svar, 2, bvalabel)

            zdata = {}
            if len(ldata) > 0:
                zdata = zip(lvarnames, ldata)
            return dict(zdata)
        else:
            lvarnames = [_stp._st_getvarname(v) for v in vars]
            if bmissing == 1:
                ldata = _stp._st_getdata(vars, obss, svar, 2, bvalabel, missingval)
            else:
                ldata = _stp._st_getdata(vars, obss, svar, 2, bvalabel)

            zdata = {}
            if len(ldata) > 0:
                zdata = zip(lvarnames, ldata)
            return dict(zdata)

    @staticmethod
    def getAt(var, obs):
        """
        Read a value from the current Stata dataset.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the variable 
            index or name.

        obs : int
            Observation to access.

        Returns
        -------
        float or str
            The value.

        Raises
        ------
        ValueError
            This error can be raised if

              - `var` is out of :ref:`range <ref-datarange>` or not found.
              - `obs` is out of :ref:`range <ref-datarange>`.
        """
        ovar = _get_var_index_single(var)
        if _check_obs(obs):
            raise ValueError("%d: obs out of range" % (obs))

        return _stp._st_getdataat(ovar, obs)
		
    @staticmethod
    def getBestType(value):
        """
        Get the best numeric data type for the specified value.

        Parameters
        ----------
        value : float
            The value to test.

        Returns
        -------
        str
            The best numeric data type for the specified value. It may be 
            **byte**, **int**, **long**, **float**, or **double**.
        """
        return _stp._st_getbesttype(value)

    @staticmethod
    def getFormattedValue(var, obs, bValueLabel):
        """
        Read a value from the current Stata dataset, applying its 
        display format.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the variable 
            index or name.

        obs : int
            Observation to access.

        bValueLabel : bool
            Use the value label when available.

        Returns
        -------
        str
            The formatted value as a string.

        Raises
        ------
        ValueError
            This error can be raised if

              - `var` is out of :ref:`range <ref-datarange>` or not found.
              - `obs` is out of :ref:`range <ref-datarange>`.
        """
        if bValueLabel is True:	
            blbl = 1 
        elif bValueLabel is False:
            blbl = 0
        else:
            raise TypeError("bValueLabel must be a boolean value")

        oindex = _get_var_index_single(var)

        if _check_obs(obs):
            raise ValueError("%d: obs out of range" % (obs))

        return _stp._st_getfmtvalue(oindex, obs, blbl)

    @staticmethod
    def getMaxStrLength():
        """
        Get the maximum length of a Stata string variable of type **str**.

        Returns
        -------
        int
            The maximum length.
        """
        return _stp._st_getmaxstrlength()

    @staticmethod
    def getMaxVars():
        """
        Get the maximum number of variables Stata currently allows.

        Returns
        -------
        int
            The maximum number of variables.
        """
        return _stp._st_getmaxvars()

    @staticmethod
    def getObsTotal():
        """
        Get the number of observations in the current Stata dataset.

        Returns
        -------
        int
            The number of observations.
        """
        return _stp._st_getobstotal()

    @staticmethod
    def getStrVarWidth(var):
        """
        Get the width of the variable of type **str**.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the variable 
            index or name.

        Returns
        -------
        int
            The width of the variable.

        Raises
        ------
        ValueError
            If `var` is out of :ref:`range <ref-datarange>` or not found.
        """
        oindex = _get_var_index_single(var)
        return _stp._st_getstrvarwidth(oindex)

    @staticmethod
    def getVarCount():
        """
        Get the number of variables in the current Stata dataset.

        Returns
        -------
        int
            The number of variables.
        """
        return _stp._st_getvarcount()

    @staticmethod
    def getVarFormat(var):
        """
        Get the format for the Stata variable.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the variable 
            index or name.

        Returns
        -------
        str
            The variable format.

        Raises
        ------
        ValueError
            If `var` is out of :ref:`range <ref-datarange>` or not found.
        """
        oindex = _get_var_index_single(var)
        return _stp._st_getvarformat(oindex)

    @staticmethod
    def getVarIndex(name):
        """
        Look up the variable index for the specified name in the 
        current Stata dataset.

        Parameters
        ----------
        name : str
            Variable to access.

        Returns
        -------
        int
            The variable index.

        Raises
        ------
        ValueError
            If `name` is not found.
        """
        oname = _get_var_name(name)
        return _stp._st_getvarindex(oname)

    @staticmethod
    def getVarLabel(var):
        """
        Get the label for the Stata variable.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the variable 
            index or name.

        Returns
        -------
        str
            The variable label.

        Raises
        ------
        ValueError
            If `var` is out of :ref:`range <ref-datarange>` or not found.
        """
        oindex = _get_var_index_single(var)
        return _stp._st_getvarlabel(oindex)

    @staticmethod
    def getVarName(index):
        """
        Get the name for the Stata variable.

        Parameters
        ----------
        index : int
            Variable to access.

        Returns
        -------
        str
            The variable name at the given index.

        Raises
        ------
        ValueError
            If `index` is out of :ref:`range <ref-datarange>`.
        """
        oindex = _get_var_index(index)
        return _stp._st_getvarname(oindex)

    @staticmethod
    def getVarType(var):
        """
        Get the storage type for the Stata variable, such as 
        **byte**, **int**, **long**, **float**, **double**, **strL**, **str18**, etc.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the variable 
            index or name.

        Returns
        -------
        str
            The variable storage type.

        Raises
        ------
        ValueError
            If `var` is out of :ref:`range <ref-datarange>` or not found.
        """
        ovar = _get_var_index_single(var)
        return _stp._st_gettype(ovar)

    @staticmethod
    def isVarTypeStr(var):
        """
        Test if a variable is of type **str**.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the variable 
            index or name.

        Returns
        -------
        bool
            True if the variable is of type **str**.

        Raises
        ------
        ValueError
            If `var` is out of :ref:`range <ref-datarange>` or not found.
        """
        ovar = _get_var_index_single(var)
        return _stp._st_isvartypestr(ovar)

    @staticmethod
    def isVarTypeString(var):
        """
        Test if a variable is of type string.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the variable 
            index or name.

        Returns
        -------
        bool
            True if the variable is of type **str** or **strL**.

        Raises
        ------
        ValueError
            If `var` is out of :ref:`range <ref-datarange>` or not found.
        """
        ovar = _get_var_index_single(var)
        return _stp._st_isvartypestring(ovar)

    @staticmethod
    def isVarTypeStrL(var):
        """
        Test if a variable is of type **strL**.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the variable 
            index or name.

        Returns
        -------
        bool
            True if the variable is of type **strL**.

        Raises
        ------
        ValueError
            If `var` is out of :ref:`range <ref-datarange>` or not found.
        """
        ovar = _get_var_index_single(var)
        return _stp._st_isvartypestrl(ovar)

    @staticmethod
    def keepVar(var):
        """
        Keep the specified variables.

        Parameters
        ----------
        var : int, str, or list-like
            Variables to keep. It can be specified as a single variable index 
            or name, or an iterable of variable indices or names.

        Raises
        ------
        ValueError
            If any of the variable indices or names specified in `var` is out of :ref:`range <ref-datarange>` or not found.
        """
        kindex = set(_get_var_index_all(var))
        oindex = list(set(range(_stp._st_getvarcount()))-kindex)
        for o in oindex[::-1]:
            _stp._st_dropvar(o)

    @staticmethod
    def list(var=None, obs=None):
        """
        List values from the current Stata dataset. The values are
        displayed using their corresponding variable formats.

        Parameters
        ----------
        var : int, str, or list-like, optional
            Variables to display. It can be specified as a single variable
            index or name, or an iterable of variable indices or names. 
            If `var` is not specified, all the variables are specified.

        obs : int or list-like, optional
            Observations to display. It can be specified as a single 
            observation index or an iterable of observation indices. If `obs` is 
            not specified, all the observations are specified.

        Raises
        ------
        ValueError
            This error can be raised if

              - any of the variable indices or names specified in `var` is out of :ref:`range <ref-datarange>` or not found.
              - any of the observation indices specified in `obs` is out of :ref:`range <ref-datarange>`.
        """
        if _stp._st_getvarcount() <= 0: 
            return 

        if var is None: 
            vars = None
        else:
            vars = _get_var_index_all(var)

        if obs is None:
            nobs = _stp._st_getobstotal()
            obss = None
            maxrow = nobs-1
        else:
            obss = _get_obs_index(obs)
            maxrow = _get_obs_max(obss)

        if maxrow == 0:
            leftwidth = 1 
        else:
            leftwidth = int(floor(log(maxrow, 10)) + 1)
			
        return _stp._st_listdata(vars, obss, leftwidth+1)

    @staticmethod
    def readBytes(sc, length):
        """
        Read a sequence of bytes from a **strL** in the current Stata 
        dataset.

        Parameters
        ----------
        sc : StrLConnector
            The :class:`~StrLConnector` representing a **strL**.

        length : int
            The number of bytes to read.

        Returns
        -------
        bytes
            The array of bytes. An empty array of bytes is returned 
            if there are no more data because the end has been reached.

        Raises
        ------
        ValueError
            If `length` is not a positive integer.

        IOError
            If failure occurred when attempting to read a sequence of bytes.
        """
        if not isinstance(sc, StrLConnector):
            raise TypeError("sc must be an instance of class StrLConnector")

        if length <= 0:
            raise ValueError("length must be positive")

        b = _stp._st_getbytes(sc.var, sc.obs, sc.pos, length)
        blen = len(b)
        if blen > 0:
            sc.setPosition(sc.pos + blen)

        return b

    @staticmethod
    def renameVar(var, name):
        """
        Rename a Stata variable.

        Parameters
        ----------
        var : str or int
            Name or index of the variable to rename.

        name : str
            New variable name.

        Raises
        ------
        ValueError
            This error can be raised if

              - `var` is not found or out of :ref:`range <ref-datarange>`.
              - `name` is not a valid Stata variable name.
        """
        oindex = _get_var_index_single(var)
        return _stp._st_renamevar(oindex, name)

    @staticmethod
    def setObsTotal(nobs):
        """
        Set the number of observations in the current Stata dataset.

        Parameters
        ----------
        nobs : int
            The number of observations to set.

        Raises
        ------
        ValueError
            If the number of observations to set, `nobs`, exceeds the limit of observations.
        """
        return _stp._st_setobstotal(nobs)

    @staticmethod
    def setVarFormat(var, format):
        """
        Set the format for a Stata variable.

        Parameters
        ----------
        var : int or str
            Index or name of the variable to format.

        format : str
            New format.

        Raises
        ------
        ValueError
            This error can be raised if

              - `var` is out of :ref:`range <ref-datarange>` or not found.
              - `format` is not a valid Stata format.
        """
        oindex = _get_var_index_single(var)
        return _stp._st_setvarformat(oindex, format)

    @staticmethod
    def setVarLabel(var, label):
        """
        Set the label for a Stata variable.

        Parameters
        ----------
        var : int or str
            Index or name of the variable to label.

        label : str
            New label.

        Raises
        ------
        ValueError
            If `var` is out of :ref:`range <ref-datarange>` or not found.
        """
        oindex = _get_var_index_single(var)
        return _stp._st_setvarlabel(oindex, label)

    @staticmethod
    def store(var, obs, val, selectvar=None):
        """
        Store values in the current Stata dataset.

        Parameters
        ----------
        var : int, str, list-like, or None
            Variables to access. It can be specified as a single variable
            index or name, an iterable of variable indices or names, or None. 
            If None is specified, all the variables are specified.

        obs : int, list-like, or None
            Observations to access. It can be specified as a single 
            observation index, an iterable of observation indices, or None. 
            It None is specified, all the observations are specified.

        val : array-like
            Values to store. The dimensions of `val` should match the dimensions 
            implied by `var` and `obs`. Each of the values can be numeric or 
            string based on the corresponding variable data types.

        selectvar : int or str, optional
            Only store values for observations with `selectvar!=0`. If 
            `selectvar` is an integer, it is interpreted as a variable index. 
            If `selectvar` is a string, it should contain the name of a Stata 
            variable. Specifying `selectvar` as "" has the same result 
            as not specifying `selectvar`, which means values are stored for all 
            observations specified. Specifying `selectvar` as -1 means that 
            observations with missing values for the variables specified in `var`
            are to be skipped.

        Raises
        ------
        ValueError
            This error can be raised if
              - any of the variable indices or names specified in `var` is out of :ref:`range <ref-datarange>` or not found.
              - any of the observation indices specified in `obs` is out of :ref:`range <ref-datarange>`.
              - dimensions of `val` do not match the dimensions implied by `var` and `obs`.
              - `selectvar` is out of :ref:`range <ref-datarange>` or not found.

        TypeError
            If any of the values specified in `val` does not match the corresponding 
            variable data type.
        """
        svar = -1 
        if selectvar is None or selectvar=="":
            svar = -2
        elif selectvar!=-1:
            svar = _get_var_index_single(selectvar)	

        if var is None:
            nvar = _stp._st_getvarcount()
            vars = None
        else:
            vars = _get_var_index_all(var)
            nvar = len(vars)

        if obs is None:
            nobs = _stp._st_getobstotal()
            obss = None
        else:
            obss = _get_obs_index(obs)
            nobs = len(obss)

        if nvar == 0 or nobs == 0:
            return

        def listimize(x):
            if isinstance(x, str) or not hasattr(x, "__iter__"):
                return [x]
            return list(x)

        if (isinstance(val, str) or
                not hasattr(val, "__iter__")):
            val = [[val]]
        else:
            val = list(listimize(v) for v in val)

        if (nobs == 1 and len(val) == nvar and 
                _check_all(len(v) == 1 for v in val)):
            val = [[v[0] for v in val]]

        if svar==-2:
            if not len(val) == nobs:
                raise ValueError("length of value does not match number of observations")

        if not _check_all(len(v) == nvar for v in val):
            raise ValueError("inner dimensions do not match number of variables")    

        return _stp._st_storedata(vars, obss, val, svar)

    @staticmethod
    def storeAt(var, obs, val):
        """
        Store a value in the current Stata dataset.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the variable 
            index or name.

        obs : int
            Observation to access.

        val : float or str
            Value to store. The value data type depends on the 
            corresponding variable data type.

        Raises
        ------
        ValueError
            This error can be raised if

              - `var` is out of :ref:`range <ref-datarange>` or not found.
              - `obs` is out of :ref:`range <ref-datarange>`.
        """
        oindex = _get_var_index_single(var)
        if _check_obs(obs):
            raise ValueError("%d: obs out of range" % (obs))

        return _stp._st_storedataat(oindex, obs, val)

    @staticmethod
    def storeBytes(sc, b, binary):
        """
        Store a byte buffer to a **strL** in the current Stata dataset. You 
        do not need to call :meth:`allocateStrL()` before using this method.

        Parameters
        ----------
        sc : StrLConnector
            The :class:`~StrLConnector` representing a **strL**.

        b : bytes or bytearray
            Bytes to store.

        binary : bool
            Mark the data as binary.
        """
        if not isinstance(sc, StrLConnector):
            raise TypeError("sc must be an instance of class StrLConnector")

        if not isinstance(b, bytes) and not isinstance(b, bytearray):
            raise TypeError("b must be an instance of bytes or bytearray")

        if binary is True:	
            bbin = 1 
        elif binary is False:
            bbin = 0
        else:
            raise TypeError("binary must be a boolean value")

        return _stp._st_storebytes1(sc.var, sc.obs, b, bbin)

    @staticmethod
    def writeBytes(sc, b, off=None, length=None):
        """
        Write `length` bytes from the specified byte buffer starting at 
        offset `off` to a **strL** in the current Stata dataset; the **strL** 
        must be allocated using :meth:`allocateStrL()` before calling this 
        method.

        Parameters
        ----------
        sc : StrLConnector
            The :class:`~StrLConnector` representing a **strL**.

        b : bytes or bytearray
            The buffer holding the data to store.

        off : int, optional
            The offset into the buffer. If not specified, 0 is used.

        length : int, optional
            The number of bytes to write. If not specified, the size of 
            `b` is used.

        Raises
        ------
        ValueError
            This error can be raised if

              - `off` is negative.
              - `length` is not a positive integer.
        """
        if not isinstance(sc, StrLConnector):
            raise TypeError("sc must be an instance of class StrLConnector")

        if not isinstance(b, bytes) and not isinstance(b, bytearray):
            raise TypeError("b must be an instance of bytes or bytearray")

        if off is None:
            off = 0
        else:
            if off < 0:
                raise ValueError("off must be nonnegative")

        blen = len(b)
        if blen == 0:
            return None

        if length is None: 
            length = blen

        if length <= 0:
            raise ValueError("length must be positive")

        endb = off + length
        b = b[off:endb]

        res = _stp._st_storebytes2(sc.var, sc.obs, b, sc.pos)
        sc.setPosition(sc.pos + len(b))
        return res


class Datetime:
    """
    This class provides a set of core tools for interacting with Stata datetimes.	
    """

    def __init__(self):
        pass

    @staticmethod
    def format(value, format):
        """
        Get the formatted Python datetime or date string based 
        on the specified Stata internal form (**SIF**) value and 
        Stata datetime format.

        Parameters
        ----------
        value : float
            Stata internal form (**SIF**) value.

        format : str
            A valid Stata datetime format.

        Returns
        -------
        str
            The formatted string.

        Raises
        ------
        ValueError
            If `format` is not a valid Stata date format.
        """
        return _stp._st_formatdatetime(value, format).strip()

    @staticmethod
    def getDatetime(value, format):
        """
        Get the Python datetime or date based on the specified Stata 
        internal form (**SIF**) value and Stata datetime format.

        Parameters
        ----------
        value : float
            Stata internal form (**SIF**) value.

        format : str
            A valid Stata datetime format.

        Returns
        -------
        datetime or date
            The Python datetime or date if successful. Otherwise 
            returns None.

        Raises
        ------
        ValueError
            If `format` is not a valid Stata date format.
        """
        dvalue = _stp._st_getdatetime(value, format)
        if dvalue is None:
            return None
        dlen = len(dvalue)
        if dlen==3:
            return datetime.date(dvalue[0],dvalue[1],dvalue[2])
        elif dlen==7:
            return datetime.datetime(dvalue[0],dvalue[1],dvalue[2],dvalue[3],dvalue[4],dvalue[5],dvalue[6])
        else:
            return dvalue[0]

    @staticmethod
    def getSIF(dt, format):
        """
        Get the Stata internal form (**SIF**) value using a Stata datetime format.

        Parameters
        ----------
        dt : datetime or date
            The Python datetime or date to format.

        format : str
            A valid Stata datetime format.

        Returns
        -------
        float
            The **SIF** value.

        Raises
        ------
        ValueError
            If `format` is not a valid Stata date format.
        """
        if isinstance(dt, datetime.datetime):
            if dt.tzinfo:		
                dt = dt - dt.utcoffset()		
            return _stp._st_getsif(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second+dt.microsecond/1000000.0, format)
        elif isinstance(dt, datetime.date):
            return _stp._st_getsif(dt.year, dt.month, dt.day, 0, 0, 0, format)
        else:
            raise ValueError("dt must be one of Python date or datetime")


def _check_df_var(fname, fno, var, nvars=None):
    if nvars is None:
        nvars = _stp._st_df_getvarcount(fname, fno)
	
    if var<-nvars or var>=nvars: 
        return True
    else:
        return False

def _check_df_obs(fname, fno, obs, nobs=None):
    if nobs is None:
        nobs = _stp._st_df_getobstotal(fname, fno)

    if obs<-nobs or obs>=nobs: 
        return True
    else:
        return False

def _get_df_var_index_all(fname, fno, ovar):
    if isinstance(ovar, int):
        if _check_df_var(fname, fno, ovar): 
            raise ValueError("%d: var out of range" % (ovar))

        return [ovar]
    elif isinstance(ovar, str):
        oret = []
        ovar = ovar.split()
        for o in ovar:
            ovari = _stp._st_df_getvarindex(fname, fno, o)
            if ovari<0:
                raise ValueError("variable %s not found" % (o))
            oret.append(ovari)
        return oret
    elif isinstance(ovar, list):
        if _check_all(isinstance(o, int) for o in ovar):
            oret = []
            nvars = _stp._st_df_getvarcount(fname, fno)
            for o in ovar:
                if _check_df_var(fname, fno, o, nvars): 
                    raise ValueError("%d: var out of range" % (o))
                oret.append(o)

            return oret
        elif _check_all(isinstance(o, str) for o in ovar):
            oret = []
            for o in ovar:
                ovari = _stp._st_df_getvarindex(fname, fno, o)
                if ovari<0:
                    raise ValueError("variable %s not found" % (o))
                oret.append(ovari)

            return oret
        else:
            raise TypeError("all values for variable input must be a string or an integer")
    elif isinstance(ovar, tuple):
        if _check_all(isinstance(o, int) for o in ovar):
            oret = []
            nvars = _stp._st_df_getvarcount(fname, fno)
            for o in ovar:
                if _check_df_var(fname, fno, o, nvars): 
                    raise ValueError("%d: var out of range" % (o))
                oret.append(o)

            return oret
        elif _check_all(isinstance(o, str) for o in ovar):
            oret = []
            for o in ovar:
                ovari = _stp._st_df_getvarindex(fname, fno, o)
                if ovari<0:
                    raise ValueError("variable %s not found" % (o))
                oret.append(ovari)

            return oret
        else:
            raise TypeError("all values for variable input must be a string or an integer")
    elif hasattr(ovar, "__iter__"): 
        ovar = tuple(ovar)
        if _check_all(isinstance(o, int) for o in ovar):
            oret = []
            nvars = _stp._st_df_getvarcount(fname, fno)
            for o in ovar:
                if _check_df_var(fname, fno, o, nvars):
                    raise ValueError("%d: var out of range" % (o))
                oret.append(o)

            return oret
        elif _check_all(isinstance(o, str) for o in ovar):
            oret = []
            for o in ovar:
                ovari = _stp._st_df_getvarindex(fname, fno, o)
                if ovari<0:
                    raise ValueError("variable %s not found" % (o))
                oret.append(ovari)

            return oret
        else:
            raise TypeError("all values for variable input must be a string or an integer")
    else:
        raise TypeError("unsupported operand type(s) for variable input")

def _get_df_var_index_single(fname, fno, ovar):
    if isinstance(ovar, int):
        if _check_df_var(fname, fno, ovar):
            raise ValueError("%d: var out of range" % (ovar))
        return ovar
    elif isinstance(ovar, str):
        ovari = _stp._st_df_getvarindex(fname, fno, ovar)
        if ovari<0:
            raise ValueError("variable %s not found" % (ovar))
        return ovari
    else:
        raise TypeError("unsupported operand type(s) for variable input")

def _get_df_var_index(fname, fno, ovar):
    if isinstance(ovar, int):
        if _check_df_var(fname, fno, ovar): 
            raise ValueError("%d: var out of range" % (ovar))

        return ovar
    else:
        raise TypeError("unsupported operand type(s) for variable input")

def _get_df_var_name(fname, fno, ovar):
    if isinstance(ovar, str):
        ovari = _stp._st_df_getvarindex(fname, fno, ovar)
        if ovari<0:
            raise ValueError("variable %s not found" % (ovar))
        return ovar
    else:
        raise TypeError("unsupported operand type(s) for variable input")

def _get_df_obs_index(fname, fno, oobs):
    if isinstance(oobs, int):
        if _check_df_obs(fname, fno, oobs):
            raise ValueError("%d: obs out of range" % (oobs))

        return [oobs]
    elif isinstance(oobs, list):
        if _check_all(isinstance(o, int) for o in oobs):
            nobs = _stp._st_df_getobstotal(fname, fno)
            if _check_all(o>-nobs and o<nobs for o in oobs):
                return oobs 
            raise ValueError("obs out of range")
        else:
            raise TypeError("all values for observation index must be an integer")
    elif isinstance(oobs, tuple):
        if _check_all(isinstance(o, int) for o in oobs):
            nobs = _stp._st_df_getobstotal(fname, fno)
            if _check_all(o>-nobs and o<nobs for o in oobs):
                return list(oobs) 
            raise ValueError("obs out of range")
        else:
            raise TypeError("all values for observation index must be an integer")
    elif hasattr(oobs, "__iter__"):
        oobs = tuple(oobs)
        if _check_all(isinstance(o, int) for o in oobs):
            nobs = _stp._st_df_getobstotal(fname, fno)
            if _check_all(o>-nobs and o<nobs for o in oobs):
                return list(oobs) 
            raise ValueError("obs out of range")
        else:
            raise TypeError("all values for observation index must be an integer")
    else:
        raise TypeError("unsupported operand type(s) for variable input")

def _get_df_obs_max(fname, fno, oobs):
    maxo = max(oobs)
    mino = min(oobs)
    nobs = _stp._st_df_getobstotal(fname, fno)

    if maxo < 0: 
        maxo = maxo + nobs 
    if mino < 0:
        mino = mino + nobs

    if maxo >= mino:
        return maxo 
    else:
        return mino


class Frame:
    """
    This class provides access to Stata frames. Functionality is provided 
    by wrapping a Stata frame in a Python object of type :class:`~Frame`, which 
    provides many methods for accessing the underlying Stata frame. If the 
    underlying frame is renamed from Stata, Mata, etc., then access to the 
    frame from its object will be lost. For more information about Stata 
    frames, see **help frames** in Stata.

    All variable and observation numbering begins at 0. The allowed values 
    for the variable index `var` and the observation index `obs` are

    .. _ref-framerange:

    .. centered:: **-nvar** `<=` `var` `<` **nvar**

    and

    .. centered:: **-nobs** `<=` `obs` `<` **nobs**

    Here **nvar** is the number of variables defined in the underlying Stata 
    frame, which is returned by :meth:`getVarCount()`. **nobs** is the number of 
    observations defined in the underlying Stata frame, which is returned 
    by :meth:`getObsTotal()`.

    Negative values for `var` and `obs` are allowed and are interpreted in the 
    usual way for Python indexing. In all functions that take `var` 
    as an argument, `var` can be specified as either the variable index or 
    the variable name. Note that passing the variable index will be more 
    efficient because looking up the index for the specified variable name is 
    avoided for each function call.
    """

    def __init__(self):
        self.name = ""
        self.id = -1

    @classmethod
    def connect(cls, name):
        """
        Connect to an existing frame in Stata and return a new :class:`Frame` 
        instance that can be used to access it.

        Parameters
        ----------
        name : str
            Name of an existing Stata frame.

        Returns
        -------
        Frame
            A :class:`~Frame` that corresponds to the existing frame in Stata.

        Raises
        ------
        FrameError
            This error can be raised if

              - the frame `name` does not already exist in Stata.
              - Python fails to connect to the frame.
        """
        id = _stp._st_df_lookup(name)
        if id <= 0:
            raise FrameError("frame not found")

        f = cls()
        f.name = name 
        f.id = id

        return f

    @classmethod
    def create(cls, name):
        """
        Create a new frame in Stata and return a new :class:`Frame` instance 
        that can be used to access it.

        Parameters
        ----------
        name : str
            Name of the Stata frame to create.

        Returns
        -------
        Frame
            A new :class:`~Frame` that corresponds to the new frame in Stata.

        Raises
        ------
        FrameError
            If the creation of the new frame in Stata fails.
        """	
        strc = _stp._st_df_create(name)
        if strc!=0:
            raise FrameError("unable to create frame")

        id = _stp._st_df_lookup(name)
		
        f = cls()
        f.name = name 
        f.id = id

        return f

    def addObs(self, n, nofill=False):
        """
        Add `n` observations to the frame. By default, the added 
        observations are filled with the appropriate missing-value 
        code. If `nofill` is specified and equal to True, the added 
        observations are not filled, which speeds up the process. 
        Setting `nofill` to True is not recommended. If you choose this 
        setting, it is your responsibility to ensure that the added 
        observations are ultimately filled in or removed before control 
        is returned to Stata.

        There need not be any variables defined to add observations.  
        If you are attempting to create a frame from nothing, you can 
        add the observations first and then add the variables.

        Parameters
        ----------
        n : int
            Number of observations to add.

        nofill : bool, optional
            Do not fill the added observations. Default is False.

        Raises
        ------
        ValueError
            If the number of observations to add, `n`, exceeds the limit of observations.
        """
        if nofill is True:	
            bnofill = 1
        elif nofill is False:
            bnofill = 0
        else:
            raise TypeError("nofill must be a boolean value")

        return _stp._st_df_addobs(self.name, self.id, n, bnofill)

    def addVarByte(self, name):
        """
        Add a variable of type **byte** to the frame.

        Parameters
        ----------
        name : str
            Name of the variable to be created.

        Raises
        ------
        ValueError
            If `name` is not a valid Stata variable name.
        """
        return _stp._st_df_addvarbyte(self.name, self.id, name)

    def addVarDouble(self, name):
        """
        Add a variable of type **double** to the frame.

        Parameters
        ----------
        name : str
            Name of the variable to be created.

        Raises
        ------
        ValueError
            If `name` is not a valid Stata variable name.
        """
        return _stp._st_df_addvardouble(self.name, self.id, name)

    def addVarFloat(self, name):
        """
        Add a variable of type **float** to the frame.

        Parameters
        ----------
        name : str
            Name of the variable to be created.

        Raises
        ------
        ValueError
            If `name` is not a valid Stata variable name.
        """
        return _stp._st_df_addvarfloat(self.name, self.id, name)

    def addVarInt(self, name):
        """
        Add a variable of type **int** to the frame.

        Parameters
        ----------
        name : str
            Name of the variable to be created.

        Raises
        ------
        ValueError
            If `name` is not a valid Stata variable name.
        """
        return _stp._st_df_addvarint(self.name, self.id, name)

    def addVarLong(self, name):
        """
        Add a variable of type **long** to the frame.

        Parameters
        ----------
        name : str
            Name of the variable to be created.

        Raises
        ------
        ValueError
            If `name` is not a valid Stata variable name.
        """
        return _stp._st_df_addvarlong(self.name, self.id, name)

    def addVarStr(self, name, length):
        """
        Add a variable of type **str** to the frame.

        Parameters
        ----------
        name : str
            Name of the variable to be created.

        length : int
            Initial size of the variable. If the length is greater 
            than :meth:`~Data:getMaxStrLength()`, then a variable of type **strL** 
            will be created.

        Raises
        ------
        ValueError
            This error can be raised if

              - `name` is not a valid Stata variable name.
              - `length` is not a positive integer.
        """
        return _stp._st_df_addvarstr(self.name, self.id, name, length)

    def addVarStrL(self, name):
        """
        Add a variable of type **strL** to the frame.

        Parameters
        ----------
        name : str
            Name of the variable to be created.

        Raises
        ------
        ValueError
            If `name` is not a valid Stata variable name.
        """
        return _stp._st_df_addvarstrl(self.name, self.id, name)

    def allocateStrL(self, sc, size, binary=True):
        """
        Allocate a **strL** so that a buffer can be stored using 
        :meth:`writeBytes()`; the contents of the **strL** will not be initialized.

        Parameters
        ----------
        sc : StrLConnector
            The :class:`~StrLConnector` representing a **strL**.

        size : int
            The size in bytes.

        binary : bool, optional
            Mark the data as binary. Note that if the data are not marked as 
            binary, Stata expects that the data be UTF-8 encoded. An alternate 
            approach is to call :meth:`storeAt()`, where the encoding is 
            automatically handled. Default is True.
        """
        if not isinstance(sc, StrLConnector):
            raise TypeError("sc must be an instance of class StrLConnector")

        if binary is True:	
            bbin = 1 
        elif binary is False:
            bbin = 0
        else:
            raise TypeError("binary must be a boolean value")

        return _stp._st_df_allocatestrl(self.name, self.id, sc.var, sc.obs, size, bbin)
		
    def changeToCWF(self):
        """
        Set the :class:`Frame` as the current working frame in Stata. The current 
        working frame in Stata can be accessed using :class:`Data` if desired.
        """
        return _stp._st_df_changetocwf(self.name)

    def clone(self, newName):
        """
        Create a new :class:`Frame` instance by cloning the current Frame and its 
        contents. This results in a new frame in Stata.

        Parameters
        ----------
        newName : str
            The name of the new frame to be created.

        Returns
        -------
        Frame
            A :class:`~Frame` that corresponds to the newly cloned frame in Stata.

        Raises
        ------
        FrameError
            If the cloning of the frame fails.
        """
        strc = _stp._st_df_clone(self.name, newName)
        if strc!=0:
            raise FrameError("failed to clone frame")

        f = Frame()
        f.name = newName 
        f.id = _stp._st_df_lookup(newName)

        return f

    def drop(self):
        """
        Drop the frame in Stata. You may not drop a frame if it is the current 
        working frame in Stata.
        """
        _stp._st_df_drop(self.name)
        self.name = ""
        self.id = 0

    def dropVar(self, var):
        """
        Drop the specified variables from the frame.

        Parameters
        ----------
        var : int, str, or list-like
            Variables to drop. It can be specified as a single variable index 
            or name, or an iterable of variable indices or names.

        Raises
        ------
        ValueError
            If any of the variable indices or names specified in `var` is out of :ref:`range <ref-framerange>` or not found.
        """
        oindex = _get_df_var_index_all(self.name, self.id, var)
        oindex.reverse()
        for o in oindex:
            _stp._st_df_dropvar(self.name, self.id, o)

    def get(self, var=None, obs=None, selectvar=None, valuelabel=False, missingval=_DefaultMissing()):
        """
        Read values from the frame.

        Parameters
        ----------
        var : int, str, or list-like, optional
            Variables to access. It can be specified as a single variable
            index or name, or an iterable of variable indices or names. 
            If `var` is not specified, all the variables are specified.

        obs : int or list-like, optional
            Observations to access. It can be specified as a single 
            observation index or an iterable of observation indices. 
            If `obs` is not specified, all the observations are specified.

        selectvar : int or str, optional
            Observations for which `selectvar!=0` will be selected. If `selectvar`
            is an integer, it is interpreted as a variable index. If `selectvar`
            is a string, it should contain the name of a Stata variable. 
            Specifying `selectvar` as "" has the same result as not 
            specifying `selectvar`, which means no observations are excluded. 
            Specifying `selectvar` as -1 means that observations with missing 
            values for the variables specified in `var` are to be excluded.

        valuelabel : bool, optional
            Use the value label when available. Default is False.

        missingval : :ref:`_DefaultMissing<ref-defaultmissing>`, `optional`
            If `missingval` is specified, all the missing values in the returned 
            list are replaced by this value. If it is not specified, the numeric 
            value of the corresponding missing value in Stata is returned.

        Returns
        -------
        List
            A list of lists containing the values from the frame. 
            Each sublist contains values for one observation.

        Raises
        ------
        ValueError
            This error can be raised if

              - any of the variable indices or names specified in `var` is out of :ref:`range <ref-framerange>` or not found.
              - any of the observation indices specified in `obs` is out of :ref:`range <ref-framerange>`.
              - `selectvar` is out of :ref:`range <ref-framerange>` or not found.
        """
        if valuelabel is True:	
            bvalabel = 1 
        elif valuelabel is False:
            bvalabel = 0
        else:
            raise TypeError("valuelabel must be a boolean value")

        bmissing = 0
        if not isinstance(missingval, _DefaultMissing):
            bmissing = 1

        svar = -1
        if selectvar is None or selectvar=="":
            svar = -2
        elif selectvar!=-1:
            svar = _get_df_var_index_single(self.name, self.id, selectvar)	

        if var is None and obs is None:
            if bmissing == 1:
                return _stp._st_df_getdata(self.name, self.id, var, obs, svar, 1, bvalabel, missingval)
            else:
                return _stp._st_df_getdata(self.name, self.id, var, obs, svar, 1, bvalabel)
        else:
            if var is None: 
                vars = None
            else:
                vars = _get_df_var_index_all(self.name, self.id, var)

            if obs is None:
                obss = None
            else:
                obss = _get_df_obs_index(self.name, self.id, obs)

            if bmissing == 1:
                return _stp._st_df_getdata(self.name, self.id, vars, obss, svar, 1, bvalabel, missingval)
            else:
                return _stp._st_df_getdata(self.name, self.id, vars, obss, svar, 1, bvalabel)

    def getAsDict(self, var=None, obs=None, selectvar=None, valuelabel=False, missingval=_DefaultMissing()):
        """
        Read values from the frame and store them in a dictionary. The keys 
        are the variable names. The values are the data values for the 
        corresponding variables.

        Parameters
        ----------
        var : int, str, or list-like, optional
            Variables to access. It can be specified as a single variable
            index or name, or an iterable of variable indices or names. 
            If `var` is not specified, all the variables are specified.

        obs : int or list-like, optional
            Observations to access. It can be specified as a single 
            observation index or an iterable of observation indices. 
            If `obs` is not specified, all the observations are specified.

        selectvar : int or str, optional
            Observations for which `selectvar!=0` will be selected. If 
            `selectvar` is an integer, it is interpreted as a variable 
            index. If `selectvar` is a string, it should contain the name 
            of a Stata variable. Specifying `selectvar` as "" has the 
            same result as not specifying `selectvar`, which means no observations 
            are excluded. Specifying `selectvar` as -1 means that observations 
            with missing values for the variables specified in `var` are to be 
            excluded.

        valuelabel : bool, optional
            Use the value label when available. Default is False.

        missingval : :ref:`_DefaultMissing<ref-defaultmissing>`, `optional`
            If `missingval` is specified, all the missing values in the returned 
            dictionary are replaced by this value. If it is not specified, the numeric 
            value of the corresponding missing value in Stata is returned.

        Returns
        -------
        dictionary
            Return a dictionary containing the data values from the frame.

        Raises
        ------
        ValueError
            This error can be raised if

              - any of the variable indices or names specified in `var` is out of :ref:`range <ref-framerange>` or not found.
              - any of the observation indices specified in `obs` is out of :ref:`range <ref-framerange>`.
              - `selectvar` is out of :ref:`range <ref-framerange>` or not found.
        """
        if valuelabel is True:	
            bvalabel = 1 
        elif valuelabel is False:
            bvalabel = 0
        else:
            raise TypeError("valuelabel must be a boolean value")

        bmissing = 0
        if not isinstance(missingval, _DefaultMissing):
            bmissing = 1

        svar = -1 
        if selectvar is None or selectvar=="":
            svar = -2
        elif selectvar!=-1:
            svar = _get_df_var_index_single(self.name, self.id, selectvar)

        if var is None: 
            nvars = _stp._st_df_getvarcount(self.name, self.id)
            vars = list(range(nvars))
        else:
            vars = _get_df_var_index_all(self.name, self.id, var)

        vars_len = len(vars)

        if obs is None:
            nobs = _stp._st_df_getobstotal(self.name, self.id)
            if nobs==1: 
                obss=[0]
                obss_len = 1
            else:
                obss = None
                obss_len = 0
        else:
            obss = _get_df_obs_index(self.name, self.id, obs)
            obss_len = len(obss)

        if vars_len==1:
            lvarnames = _stp._st_df_getvarname(self.name, self.id, vars[0])
            if bmissing == 1:
                ldata = _stp._st_df_getdata(self.name, self.id, vars, obss, svar, 2, bvalabel, missingval)
            else:
                ldata = _stp._st_df_getdata(self.name, self.id, vars, obss, svar, 2, bvalabel)

            zdata = {}
            if len(ldata) > 0:
                zdata[lvarnames] = ldata
            return zdata
        elif obss_len==1: 
            lvarnames = [_stp._st_df_getvarname(self.name, self.id, v) for v in vars]
            if bmissing == 1:
                ldata = _stp._st_df_getdata(self.name, self.id, vars, obss, svar, 2, bvalabel, missingval)
            else:
                ldata = _stp._st_df_getdata(self.name, self.id, vars, obss, svar, 2, bvalabel)

            zdata = {}
            if len(ldata) > 0:
                zdata = zip(lvarnames, ldata)
            return dict(zdata)
        else:
            lvarnames = [_stp._st_df_getvarname(self.name, self.id, v) for v in vars]
            if bmissing == 1:
                ldata = _stp._st_df_getdata(self.name, self.id, vars, obss, svar, 2, bvalabel, missingval)
            else:
                ldata = _stp._st_df_getdata(self.name, self.id, vars, obss, svar, 2, bvalabel)

            zdata = {}
            if len(ldata) > 0:
                zdata = zip(lvarnames, ldata)
            return dict(zdata)

    def getAt(self, var, obs):
        """
        Read a value from the frame.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the variable 
            index or name.

        obs : int
            Observation to access.

        Returns
        -------
        float or str
            The value. 

        Raises
        ------
        ValueError
            This error can be raised if

              - `var` is out of :ref:`range <ref-framerange>` or not found.
              - `obs` is out of :ref:`range <ref-framerange>`.
        """
        ovar = _get_df_var_index_single(self.name, self.id, var)
        if _check_df_obs(self.name, self.id, obs):
            raise ValueError("%d: obs out of range" % (obs))

        return _stp._st_df_getdataat(self.name, self.id, ovar, obs)

    def getFormattedValue(self, var, obs, bValueLabel):
        """
        Read a value from the frame, applying its display format.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the variable
            index or name.

        obs : int
            Observation to access.

        bValueLabel : bool
            Use the value label when available.

        Returns
        -------
        str
            The formatted value as a string.

        Raises
        ------
        ValueError
            This error can be raised if

              - `var` is out of :ref:`range <ref-framerange>` or not found.
              - `obs` is out of :ref:`range <ref-framerange>`.
        """
        if bValueLabel is True:	
            blbl = 1 
        elif bValueLabel is False:
            blbl = 0
        else:
            raise TypeError("bValueLabel must be a boolean value")

        oindex = _get_df_var_index_single(self.name, self.id, var)

        if _check_df_obs(self.name, self.id, obs):
            raise ValueError("%d: obs out of range" % (obs))

        return _stp._st_df_getfmtvalue(self.name, self.id, oindex, obs, blbl)

    @staticmethod
    def getFrameAt(index):
        """
        Utility method for getting the name of a Stata frame 
        at a given index.

        Parameters
        ----------
        index : int
            The index for a frame.

        Returns
        -------
        str
            The name of the frame for the specified index.
        """
        return _stp._st_df_getframeat(index)

    @staticmethod	
    def getFrameCount():
        """
        Utility method for getting the number of frames in Stata.

        Returns
        -------
        int
            The number of frames.
        """
        return _stp._st_df_gettotalframecount()

    def getObsTotal(self):
        """
        Get the number of observations in the frame.

        Returns
        -------
        int
            The number of observations.
        """
        return _stp._st_df_getobstotal(self.name, self.id)

    def getStrVarWidth(self, var):
        """
        Get the width of the variable of type **str**.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the 
            variable index or name.

        Returns
        -------
        int
            The width of the variable.

        Raises
        ------
        ValueError
            If `var` is out of :ref:`range <ref-framerange>` or not found.
        """
        oindex = _get_df_var_index_single(self.name, self.id, var)
        return _stp._st_df_getstrvarwidth(self.name, self.id, oindex)

    def getVarCount(self):
        """
        Get the number of variables in the frame.

        Returns
        -------
        int
            The number of variables.
        """
        return _stp._st_df_getvarcount(self.name, self.id)

    def getVarFormat(self, var):
        """
        Get the format for the variable in the frame.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the 
            variable index or name.

        Returns
        -------
        str
            The variable format.

        Raises
        ------
        ValueError
            If `var` is out of :ref:`range <ref-framerange>` or not found.
        """
        oindex = _get_df_var_index_single(self.name, self.id, var)
        return _stp._st_df_getvarformat(self.name, self.id, oindex)

    def getVarIndex(self, name):
        """
        Look up the variable index for the specified name in the 
        frame.

        Parameters
        ----------
        name : str
            Variable to access.

        Returns
        -------
        int
            The variable index.

        Raises
        ------
        ValueError
            If `name` is not found.
        """
        oname = _get_df_var_name(self.name, self.id, name)
        return _stp._st_df_getvarindex(self.name, self.id, oname)

    def getVarLabel(self, var):
        """
        Get the label for the Stata variable.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the  
            variable index or name.

        Returns
        -------
        str
            The variable label.

        Raises
        ------
        ValueError
            If `var` is out of :ref:`range <ref-framerange>` or not found.
        """
        oindex = _get_df_var_index_single(self.name, self.id, var)
        return _stp._st_df_getvarlabel(self.name, self.id, oindex)

    def getVarName(self, index):
        """
        Get the name for the variable in the frame.

        Parameters
        ----------
        index : int
            Variable to access.

        Returns
        -------
        str
            The variable name at the given index.

        Raises
        ------
        ValueError
            If `index` is out of :ref:`range <ref-framerange>`.
        """
        oindex = _get_df_var_index(self.name, self.id, index)
        return _stp._st_df_getvarname(self.name, self.id, oindex)

    def getVarType(self, var):
        """
        Get the storage type for the variable in the frame, such as 
        **byte**, **int**, **long**, **float**, **double**, **strL**, **str18**, etc.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the  
            variable index or name.

        Returns
        -------
        str
            The variable storage type of the variable.

        Raises
        ------
        ValueError
            If `var` is out of :ref:`range <ref-framerange>` or not found.
        """
        ovar = _get_df_var_index_single(self.name, self.id, var)
        return _stp._st_df_gettype(self.name, self.id, ovar)

    def isVarTypeStr(self, var):
        """
        Test if a variable is of type **str**.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the variable 
            index or name.

        Returns
        -------
        bool
            True if the variable is of type **str**.

        Raises
        ------
        ValueError
            If `var` is out of :ref:`range <ref-framerange>` or not found.
        """
        ovar = _get_df_var_index_single(self.name, self.id, var)
        return _stp._st_df_isvartypestr(self.name, self.id, ovar)

    def isVarTypeString(self, var):
        """
        Test if a variable is of type string.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the variable 
            index or name.

        Returns
        -------
        bool
            True if the variable is of type **str** or **strL**.

        Raises
        ------
        ValueError
            If `var` is out of :ref:`range <ref-framerange>` or not found.
        """
        ovar = _get_df_var_index_single(self.name, self.id, var)
        return _stp._st_df_isvartypestring(self.name, self.id, ovar)

    def isVarTypeStrL(self, var):
        """
        Test if a variable is of type **strL**.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the variable 
            index or name.

        Returns
        -------
        bool
            True if the variable is of type **strL**.

        Raises
        ------
        ValueError
            If `var` is out of :ref:`range <ref-framerange>` or not found.
        """
        ovar = _get_df_var_index_single(self.name, self.id, var)
        return _stp._st_df_isvartypestrl(self.name, self.id, ovar)

    def keepVar(self, var):
        """
        Keep the specified variables in the frame.

        Parameters
        ----------
        var : int, str, or list-like
            Variables to keep. It can be specified as a single variable index 
            or name, or an iterable of variable indices or names.

        Raises
        ------
        ValueError
            If any of the variable indices or names specified in `var` is out of :ref:`range <ref-framerange>` or not found.
        """
        kindex = set(_get_df_var_index_all(self.name, self.id, var))
        oindex = list(set(range(_stp._st_df_getvarcount(self.name, self.id)))-kindex)
        for o in oindex[::-1]:
            _stp._st_df_dropvar(self.name, self.id, o)

    def list(self, var=None, obs=None):
        """
        List values from the frame. The values are displayed using 
        their corresponding variable formats.

        Parameters
        ----------
        var : int, str, or list-like, optional
            Variables to display. It can be specified as a single variable
            index or name, or an iterable of variable indices or names. 
            If `var` is not specified, all the variables are specified.

        obs : int or list-like, optional
            Observations to display. It can be specified as a single 
            observation index or an iterable of observation indices. 
            If `obs` is not specified, all the observations are specified.

        Raises
        ------
        ValueError
            This error can be raised if

              - any of the variable indices or names specified in `var` is out of :ref:`range <ref-framerange>` or not found.
              - any of the observation indices specified in `obs` is out of :ref:`range <ref-framerange>`.
        """
        if _stp._st_df_getvarcount(self.name, self.id) <= 0: 
            return 

        if var is None: 
            vars = None
        else:
            vars = _get_df_var_index_all(self.name, self.id, var)

        if obs is None:
            nobs = _stp._st_df_getobstotal(self.name, self.id)
            obss = None
            maxrow = nobs-1
        else:
            obss = _get_df_obs_index(self.name, self.id, obs)
            maxrow = _get_df_obs_max(self.name, self.id, obss)

        if maxrow == 0:
            leftwidth = 1 
        else:
            leftwidth = int(floor(log(maxrow, 10)) + 1)
			
        return _stp._st_df_listdata(self.name, self.id, vars, obss, leftwidth+1)

    def readBytes(self, sc, length):
        """
        Read a sequence of bytes from a **strL** in the frame.

        Parameters
        ----------
        sc : StrLConnector
            The :class:`~StrLConnector` representing a **strL**.

        length : int
            The number of bytes to read.

        Returns
        -------
        bytes
            The array of bytes. An empty array of bytes is returned 
            if there are no more data because the end has been reached.

        Raises
        ------
        ValueError
            If `length` is not a positive integer.

        IOError
            If failure occurred when attempting to read a sequence of bytes.
        """
        if not isinstance(sc, StrLConnector):
            raise TypeError("sc must be an instance of class StrLConnector")

        if length <= 0:
            raise ValueError("length must be positive")

        b = _stp._st_df_getbytes(self.name, self.id, sc.var, sc.obs, sc.pos, length)
        blen = len(b)
        if blen > 0:
            sc.setPosition(sc.pos + blen)

        return b

    def rename(self, newName):
        """
        Rename the frame in Stata.

        Parameters
        ----------			
        newName : str
            The name of the new frame.
        """
        _stp._st_df_rename(self.name, newName)
        self.name = newName
        self.id = _stp._st_df_lookup(newName)

    def renameVar(self, var, name):
        """
        Rename a variable.

        Parameters
        ----------
        var : str or int
            Name or index of the variable to rename.

        name : str
            New variable name.

        Raises
        ------
        ValueError
            This error can be raised if

              - `var` is not found or out of :ref:`range <ref-framerange>`.
              - `name` is not a valid Stata variable name.
        """
        oindex = _get_df_var_index_single(self.name, self.id, var)
        return _stp._st_df_renamevar(self.name, self.id, oindex, name)

    def setObsTotal(self, nobs):
        """
        Set the number of observations in the frame.

        Parameters
        ----------
        nobs : int
            The number of observations to set.

        Raises
        ------
        ValueError
            If the number of observations to set, `nobs`, exceeds the limit of observations.
        """
        return _stp._st_df_setobstotal(self.name, self.id, nobs)

    def setVarFormat(self, var, format):
        """
        Set the format for a Stata variable.

        Parameters
        ----------
        var : int or str
            Index or name of the variable to format.

        format : str
            New format.

        Raises
        ------
        ValueError
            This error can be raised if

              - `var` is out of :ref:`range <ref-framerange>` or not found.
              - `format` is not a valid Stata format.
        """
        oindex = _get_df_var_index_single(self.name, self.id, var)
        return _stp._st_df_setvarformat(self.name, self.id, oindex, format)

    def setVarLabel(self, var, label):
        """
        Set the label for a Stata variable.

        Parameters
        ----------
        var : int or str
            Index or name of the variable to label.

        label : str
            New label.

        Raises
        ------
        ValueError
            If `var` is out of :ref:`range <ref-framerange>` or not found.
        """
        oindex = _get_df_var_index_single(self.name, self.id, var)
        return _stp._st_df_setvarlabel(self.name, self.id, oindex, label)

    def store(self, var, obs, val, selectvar=None):
        """
        Store values in the frame.

        Parameters
        ----------
        var : int, str, list-like, or None
            Variables to access. It can be specified as a single variable
            index or name, an iterable of variable indices or names, or None. 
            If None is specified, all the variables are specified.

        obs : int, list-like, or None
            Observations to access. It can be specified as a single 
            observation index, an iterable of observation indices, or None. 
            If None is specified, all the observations are specified.

        val : array-like
            Values to store. The dimensions of `val` should match the dimensions 
            implied by `var` and `obs`. Each of the values can be numeric or string 
            based on the corresponding variable data types.

        selectvar : int or str, optional
            Only store values for observations with `selectvar!=0`. If 
            `selectvar` is an integer, it is interpreted as a variable index. 
            If `selectvar` is a string, it should contain the name of a Stata 
            variable. Specifying `selectvar` as "" has the same result 
            as not specifying `selectvar`, which means values are stored for 
            all observations specified. Specifying `selectvar` as -1 means that 
            observations with missing values for the variables specified in `var` 
            are to be skipped.

        Raises
        ------
        ValueError
            This error can be raised if

              - any of the variable indices or names specified in `var` is out of :ref:`range <ref-framerange>` or not found.
              - any of the observation indices specified in `obs` is out of :ref:`range <ref-framerange>`.
              - dimensions of `val` do not match the dimensions implied by `var` and `obs`.
              - `selectvar` is out of :ref:`range <ref-framerange>` or not found.

        TypeError
            If any of the values specified in `val` does not match the corresponding 
            variable data type.
        """
        svar = -1
        if selectvar is None or selectvar=="":
            svar = -2
        elif selectvar!=-1:
            svar = _get_df_var_index_single(self.name, self.id, selectvar)	

        if var is None:
            nvar = _stp._st_df_getvarcount(self.name, self.id)
            vars = None
        else:
            vars = _get_df_var_index_all(self.name, self.id, var)
            nvar = len(vars)

        if obs is None:
            nobs = _stp._st_df_getobstotal(self.name, self.id)
            obss = None
        else:
            obss = _get_df_obs_index(self.name, self.id, obs)
            nobs = len(obss)

        if nvar == 0 or nobs == 0:
            return

        def listimize(x):
            if isinstance(x, str) or not hasattr(x, "__iter__"):
                return [x]
            return list(x)

        if (isinstance(val, str) or
                not hasattr(val, "__iter__")):
            val = [[val]]
        else:
            val = list(listimize(v) for v in val)

        if (nobs == 1 and len(val) == nvar and 
                _check_all(len(v) == 1 for v in val)):
            val = [[v[0] for v in val]]

        if svar==-2:
            if not len(val) == nobs:
                raise ValueError("length of value does not match number of observations")

        if not _check_all(len(v) == nvar for v in val):
            raise ValueError("inner dimensions do not match number of variables")    

        return _stp._st_df_storedata(self.name, self.id, vars, obss, val, svar)

    def storeAt(self, var, obs, val):
        """
        Store a value in the frame.

        Parameters
        ----------
        var : int or str
            Variable to access. It can be specified as the variable 
            index or name.

        obs : int
            Observation to access.

        val : float or str
            Value to store. The value data type depends on the corresponding 
            variable data type. 

        Raises
        ------
        ValueError
            This error can be raised if

              - `var` is out of :ref:`range <ref-framerange>` or not found.
              - `obs` is out of :ref:`range <ref-framerange>`.
        """
        oindex = _get_df_var_index_single(self.name, self.id, var)
        if _check_df_obs(self.name, self.id, obs):
            raise ValueError("%d: obs out of range" % (obs))

        return _stp._st_df_storedataat(self.name, self.id, oindex, obs, val)

    def storeBytes(self, sc, b, binary):
        """
        Store a byte buffer to a **strL** in the frame. You do not need to call 
        :meth:`allocateStrL()` before using this method.

        Parameters
        ----------
        sc : StrLConnector
            The :class:`~StrLConnector` representing a **strL**.

        b : bytes or bytearray
            Bytes to store.

        binary : bool
            Mark the data as binary.
        """
        if not isinstance(sc, StrLConnector):
            raise TypeError("sc must be an instance of class StrLConnector")

        if not isinstance(b, bytes) and not isinstance(b, bytearray):
            raise TypeError("b must be an instance of bytes or bytearray")

        if binary is True:	
            bbin = 1 
        elif binary is False:
            bbin = 0
        else:
            raise TypeError("binary must be a boolean value")

        return _stp._st_df_storebytes1(sc.name, sc.id, sc.var, sc.obs, b, bbin)

    def writeBytes(self, sc, b, off=None, length=None):
        """
        Write `length` bytes from the specified byte buffer starting at 
        offset `off` to a **strL** in the frame; the **strL** 
        must be allocated using :meth:`allocateStrL()` before calling this 
        method.

        Parameters
        ----------
        sc : StrLConnector
            The :class:`~StrLConnector` representing a **strL**.

        b : bytes or bytearray
            The buffer holding the data to store.

        off : int, optional
            The offset into the buffer. If not specified, 0 is used.

        length : int, optional
            The number of bytes to write. If not specified, the size of 
            `b` is used.

        Raises
        ------
        ValueError
            This error can be raised if

              - `off` is negative.
              - `length` is not a positive integer.
        """
        if not isinstance(sc, StrLConnector):
            raise TypeError("sc must be an instance of class StrLConnector")

        if not isinstance(b, bytes) and not isinstance(b, bytearray):
            raise TypeError("b must be an instance of bytes or bytearray")

        if off is None:
            off = 0
        else:
            if off < 0:
                raise ValueError("off must be nonnegative")

        blen = len(b)
        if blen == 0:
            return None

        if length is None: 
            length = blen

        if length <= 0:
            raise ValueError("length must be positive")

        endb = off + length
        b = b[off:endb]

        res = _stp._st_df_storebytes2(self.name, self.id, sc.var, sc.obs, b, sc.pos)
        sc.setPosition(sc.pos + len(b))
        return res


class Macro:
    """
    This class provides access to Stata macros.	
    """

    def __init__(self):
        pass

    @staticmethod
    def getGlobal(name):
        """
        Get the contents of a global macro.

        Parameters
        ----------
        name : str
            Name of the macro. It can be one of the following:

                * global macro such as **"myname"**

                * **return()** macro such as **"return(retval)"**

                * **r()** macro such as **"r(names)"**

                * **e()** macro such as **"e(cmd)"**

                * **c()** macro such as **"c(current_date)"**

                * **s()** macro such as **"s(vars)"**

        Returns
        -------
        str
            Value of the macro. Returns an empty string if the macro 
            is not found.
        """	
        return _stp._st_getglobal(name)

    @staticmethod
    def getLocal(name):
        """
        Get the contents of a local macro.

        Parameters
        ----------
        name : str
            Name of the macro.

        Returns
        -------
        str
            Value of the macro. Returns an empty string if the macro 
            is not found.
        """
        return _stp._st_getlocal(name)

    @staticmethod
    def setGlobal(name, value, vtype="visible"):
        """
        Set the value of a global macro. If necessary, the macro will 
        be created.

        Parameters
        ----------
        name : str
            Name of the macro. It can be one of the following:

                * global macro such as **"myname"**

                * **return()** macro such as **"return(retval)"**

                * **r()** macro such as **"r(names)"**

                * **e()** macro such as **"e(cmd)"**

                * **s()** macro such as **"s(vars)"**

        value : str
            Value to store in the macro.

        vtype : {'visible', 'hidden', 'historical'}, optional
            If the macro is a type of return value, `vtype` sets whether 
            the return value is **visible**, **hidden**, or **historical**. 
            This parameter is ignored when the macro is a global 
            or a **s()** macro. Default is **'visible'**.
        """
        if vtype not in ['visible', 'hidden', 'historical']:
            raise ValueError('vtype must be one of visible, hidden, or historical')

        return _stp._st_setglobal(name, value, vtype)

    @staticmethod
    def setLocal(name, value):
        """
        Set the value of a local macro. If necessary, the macro will 
        be created.

        Parameters
        ----------
        name : str
            Name of the macro.

        value : str
            Value to store in the macro.
        """
        return _stp._st_setlocal(name, value)


def _get_mata_index(index, nrows, ncols, bRow):
    if isinstance(index, int):	
        if bRow:
            if index<-nrows or index>=nrows: 
                raise ValueError("%d: row index out of range" % (index))

        else:
            if index<-ncols or index>=ncols: 
                raise ValueError("%d: column index out of range" % (index))			

        return [index]
    elif isinstance(index, list) or isinstance(index, tuple):
        if _check_all(isinstance(o, int) for o in index):
            oret = []
            for o in index:
                if bRow:
                    if o<-nrows or o>=nrows: 
                        raise ValueError("%d: row index out of range" % (o))

                else:
                    if o<-ncols or o>=ncols: 
                        raise ValueError("%d: column index out of range" % (o))

                oret.append(o)

            return oret
        else:
            raise TypeError("all values for row or column indices must be an integer")
    elif hasattr(index, "__iter__"):
        index = tuple(index)
        if _check_all(isinstance(o, int) for o in index):
            oret = []
            for o in index:
                if bRow:
                    if o<-nrows or o>=nrows: 
                        raise ValueError("%d: row index out of range" % (o))

                else:
                    if o<-ncols or o>=ncols: 
                        raise ValueError("%d: column index out of range" % (o))

                oret.append(o)

            return oret
        else:
            raise TypeError("all values for row or column indices must be an integer")
    else:
        raise TypeError("unsupported operand type(s) for row or column indices")


class Mata:
    """
    This class provides access to global Mata matrices.	All row and column 
    numbering of the matrix begins at 0. The allowed values for the row
    index `row` and the column index `col` are

    .. _ref-matarange:

    .. centered:: **-nrows** `<=` `row` < **nrows**

    and

    .. centered:: **-ncols** `<=` `col` `<` **ncols**

    Here **nrows** is the number of rows of the specified matrix, which is 
    returned by :meth:`getRowTotal()`. **ncols** is the number of columns of the 
    specified matrix, which is returned by :meth:`getColTotal()`. Negative 
    values for `row` and `col` are allowed and are interpreted in the usual way 
    for Python indexing.
    """

    def __init__(self):
        pass

    @staticmethod
    def create(name, nrows, ncols, initialValue):
        """
        Create a Mata matrix.

        Parameters
        ----------
        name : str
            Name of the matrix.

        nrows : int
            Number of rows.

        ncols : int
            Number of columns.

        initialValue : float, str, or complex
            An initialization value for each element. The type of matrix created
            depends on the type of `initialValue`:

               * **float**: a real matrix is created and all the element values equal `initialValue`.

               * **str**: a string matrix is created and all the element values equal `initialValue`.

               * **complex**: a complex matrix is created and all the element values equal `initialValue`.

        Raises
        ------
        ValueError
            This error can be raised if

              - `nrows` is not a positive integer.
              - `ncols` is not a positive integer.
        """

        return _stp._st_createmata(name, nrows, ncols, initialValue)

    @staticmethod
    def get(name, rows=None, cols=None):
        """
        Access elements from a Mata matrix.

        Parameters
        ----------
        name : str
            Name of the Mata matrix.

        rows : int or list-like, optional
            Rows to access. It can be specified as a single row index 
            or an iterable of row indices. If `rows` is not specified, 
            all the rows are specified.

        cols : int or list-like, optional
            Columns to access. It can be specified as a single column 
            index or an iterable of column indices. If `cols` is 
            not specified, all the columns are specified.

        Returns
        -------
        list
            A list of lists containing elements of the matrix. Each sublist 
            contains values from each row of the matrix. Abort with an error 
            if the matrix does not exist.

        Raises
        ------
        ValueError
            This error can be raised if

              - matrix `name` does not exist.
              - any of the row indices specified in `rows` is out of :ref:`range <ref-matarange>`.
              - any of the column indices specified in `cols` is out of :ref:`range <ref-matarange>`.
        """
        if rows is None:
            mrows = None
        else:
            ncols = _stp._st_getmatacoltotal(name)
            nrows = _stp._st_getmatarowtotal(name)
            mrows = _get_mata_index(rows, nrows, ncols, True)

        if cols is None:
            mcols = None
        else:
            ncols = _stp._st_getmatacoltotal(name)
            nrows = _stp._st_getmatarowtotal(name)
            mcols = _get_mata_index(cols, nrows, ncols, False)

        return _stp._st_getmata(name, mrows, mcols)   

    @staticmethod
    def getAt(name, row, col):
        """
        Access an element from a Mata matrix.

        Parameters
        ----------
        name : str
            Name of the Mata matrix.

        row : int
            Row to access.

        col : int
            Column to access.

        Returns
        -------
        float, str, or complex
            The value. The return type depends on the type of the matrix. 

        Raises
        ------
        ValueError
            This error can be raised if

              - matrix `name` does not exist.
              - `row` is out of :ref:`range <ref-matarange>`.
              - `col` is out of :ref:`range <ref-matarange>`.
        """
        return _stp._st_getmataat(name, row, col)

    @staticmethod
    def getColTotal(name):
        """
        Get the number of columns in a Mata matrix.

        Parameters
        ----------
        name : str
            Name of the Mata matrix.

        Returns
        -------
        int
            The number of columns. 

        Raises
        ------
        ValueError
            If matrix `name` does not exist.
        """
        return _stp._st_getmatacoltotal(name)

    @staticmethod
    def getEltype(name):
        """
        Get the type of a Mata object.

        Parameters
        ----------
        name : str
            Name of the Mata object.

        Returns
        -------
        str
            The **eltype** in string form of the Mata object. 

        Raises
        ------
        ValueError
            If object `name` does not exist.
        """
        return _stp._st_getmataeltype(name)

    @staticmethod
    def getRowTotal(name):
        """
        Get the number of rows in a Mata matrix.

        Parameters
        ----------
        name : str
            Name of the Mata matrix.

        Returns
        -------
        int
            The number of rows. 

        Raises
        ------
        ValueError
            If matrix `name` does not exist.
        """
        return _stp._st_getmatarowtotal(name)

    @staticmethod
    def isTypeComplex(name):
        """
        Determine if the Mata object type is **complex**.

        Parameters
        ----------
        name : str
            Name of the Mata object.

        Returns
        -------
        bool
            True if the Mata object type is **complex**. 

        Raises
        ------
        ValueError
            If object `name` does not exist.
        """
        eltype = _stp._st_getmataeltype(name)
        if eltype == "complex":
            return True
        else:
            return False

    @staticmethod
    def isTypeReal(name):
        """
        Determine if the Mata object type is **real**.

        Parameters
        ----------
        name : str
            Name of the Mata object.

        Returns
        -------
        bool
            True if the Mata object type is **real**. 

        Raises
        ------
        ValueError
            If object `name` does not exist.
        """
        eltype = _stp._st_getmataeltype(name)
        if eltype == "real":
            return True
        else:
            return False

    @staticmethod
    def isTypeString(name):
        """
        Determine if the Mata object type is **string**.

        Parameters
        ----------
        name : str
            Name of the Mata object.

        Returns
        -------
        bool
            True if the Mata object type is **string**. 

        Raises
        ------
        ValueError
            If object `name` does not exist.
        """
        eltype = _stp._st_getmataeltype(name)
        if eltype == "string":
            return True
        else:
            return False

    @staticmethod
    def list(name, rows=None, cols=None):
        """
        Display a Mata matrix.

        Parameters
        ----------
        name : str
            Name of the Mata matrix.

        rows : int or list-like, optional
            Rows to display. It can be specified as a single row index 
            or an iterable of row indices. If `rows` is not specified, 
            all the rows are specified.

        cols : int or list-like, optional
            Columns to display. It can be specified as a single column 
            index or an iterable of column indices. If `cols` is not 
            specified, all the columns are specified.

        Raises
        ------
        ValueError
            This error can be raised if

              - matrix `name` does not exist.
              - any of the row indices specified in `rows` is out of :ref:`range <ref-matarange>`.
              - any of the column indices specified in `cols` is out of :ref:`range <ref-matarange>`.
        """
        ncols = _stp._st_getmatacoltotal(name)
        nrows = _stp._st_getmatarowtotal(name)

        if rows is None:	
            mrows = None
            maxrow = nrows-1
        else:
            mrows = _get_mata_index(rows, nrows, ncols, True)
            maxrow = max(mrows)

        if cols is None:
            mcols = None 
            maxcol = ncols-1
        else:
            mcols = _get_mata_index(cols, nrows, ncols, False)
            maxcol = max(mcols)

        return _stp._st_listmata(name, mrows, mcols, maxrow, maxcol)

    @staticmethod
    def store(name, val):
        """
        Store elements in an existing Mata matrix.

        Parameters
        ----------
        name : str
            Name of the matrix.

        val : array-like
            Values to store. The dimensions of `val` should match the 
            dimensions of the matrix. Each value of `val` can be a real 
            number, a string, or a complex number. The matrix type 
            determines the value type of each value.

        Raises
        ------
        ValueError
            This error can be raised if

              - matrix `name` does not exist.
              - dimensions of `val` do not match the dimensions of the matrix.
              - any of the value types specified in `val` do not match the matrix type.
        """
        nrows = _stp._st_getmatarowtotal(name)
        ncols = _stp._st_getmatacoltotal(name)

        def listimize(x):
            if isinstance(x, str) or not hasattr(x, "__iter__"):
                return [x]
            return list(x)

        if (isinstance(val, str) or not hasattr(val, "__iter__")):
            val = [[val]]
        else:
            val = list(listimize(v) for v in val)

        if (nrows == 1 and len(val) == ncols and 
            _check_all(len(v) == 1 for v in val)):
            val = [[v[0] for v in val]]

        if not len(val) == nrows:
            raise ValueError("compatibility error; rows unmatch")
        if not _check_all(len(v) == ncols for v in val):
            raise ValueError("compatibility error; columns unmatch")    

        return _stp._st_storemata(name, val)

    @staticmethod
    def storeAt(name, row, col, val):
        """
        Store an element in an existing Mata matrix.

        Parameters
        ----------
        name : str
            Name of the matrix.

        row : int
            Row in which to store.

        col : int
            Column in which to store.

        val : float, str, or complex
            Value to store. The matrix type determines the type of 
            `val`.

        Raises
        ------
        ValueError
            This error can be raised if

              - matrix `name` does not exist.
              - `row` is out of :ref:`range <ref-matarange>`.
              - `col` is out of :ref:`range <ref-matarange>`.
              - value type of `val` does not match the matrix type.
        """
        return _stp._st_storemataat(name, row, col, val)


def _get_matrix_index(index, name, nrows, ncols, bRow):
    if isinstance(index, int):
        if bRow:
            if index<-nrows or index>=nrows: 
                raise ValueError("%d: row index out of range" % (index))

        else:
            if index<-ncols or index>=ncols: 
                raise ValueError("%d: column index out of range" % (index))			

        return [index]
    elif isinstance(index, str):
        oret = []
        oindex = index.split()
        if bRow:
            rowNames = _stp._st_getmatrixrownames(name)
            for o in oindex:
                try:
                    orowi = rowNames.index(o)
                except:
                    raise ValueError("row %s not found" % (o))

                oret.append(orowi)
        else: 
            colNames = _stp._st_getmatrixcolnames(name)
            for o in oindex:
                try:
                    ocoli = colNames.index(o)
                except:
                    raise ValueError("column %s not found" % (o))

                oret.append(ocoli)

        return oret
    elif isinstance(index, list) or isinstance(index, tuple):
        if _check_all(isinstance(o, int) for o in index):
            oret = []
            for o in index:
                if bRow:
                    if o<-nrows or o>=nrows: 
                        raise ValueError("%d: row index out of range" % (o))

                else:
                    if o<-ncols or o>=ncols: 
                        raise ValueError("%d: column index out of range" % (o))

                oret.append(o)

            return oret
        elif _check_all(isinstance(o, str) for o in index):
            oret = []
            if bRow:
                rowNames = _stp._st_getmatrixrownames(name)
                for o in index:
                    try:
                        orowi = rowNames.index(o)
                    except:
                        raise ValueError("row %s not found" % (o))

                    oret.append(orowi)
            else: 
                colNames = _stp._st_getmatrixcolnames(name)
                for o in index:
                    try:
                        ocoli = colNames.index(o)
                    except:
                        raise ValueError("column %s not found" % (o))

                    oret.append(ocoli)

            return oret
        else:
            raise TypeError("all values for row or column indices must be a string or an integer")
    elif hasattr(index, "__iter__"): 
        index = tuple(index)
        if _check_all(isinstance(o, int) for o in index):
            oret = []
            for o in index:
                if bRow:
                    if o<-nrows or o>=nrows: 
                        raise ValueError("%d: row index out of range" % (o))

                else:
                    if o<-ncols or o>=ncols: 
                        raise ValueError("%d: column index out of range" % (o))

                oret.append(o)

            return oret
        elif _check_all(isinstance(o, str) for o in index):
            oret = []
            if bRow:
                rowNames = _stp._st_getmatrixrownames(name)
                for o in index:
                    try:
                        orowi = rowNames.index(o)
                    except:
                        raise ValueError("row %s not found" % (o))

                    oret.append(orowi)
            else: 
                colNames = _stp._st_getmatrixcolnames(name)
                for o in index:
                    try:
                        ocoli = colNames.index(o)
                    except:
                        raise ValueError("column %s not found" % (o))

                    oret.append(ocoli)

            return oret
        else:
            raise TypeError("all values for row or column indices must be a string or an integer")
    else:
        raise TypeError("unsupported operand type(s) for row or column indices")

class Matrix:
    """
    This class provides access to Stata matrices. All row and column 
    numbering of the matrix begins at 0. The allowed values for the 
    row index `row` and the column index `col` are

    .. _ref-matrixrange:

    .. centered:: **-nrows** `<=` `row` `<` **nrows**

    and

    .. centered:: **-ncols** `<=` `col` `<` **ncols**

    Here **nrows** is the number of rows of the specified matrix, which is 
    returned by :meth:`getRowTotal()`. **ncols** is the number of columns of the 
    specified matrix, which is returned by :meth:`getColTotal()`. Negative 
    values for `row` and `col` are allowed and are interpreted in the usual 
    way for Python indexing.

    Matrix names can be one of the following:

    * global matrix such as **"mymatrix"**

    * **r()** matrix such as **"r(Z)"**

    * **e()** macro such as **"e(Z)"**
    """

    def __init__(self):
        pass

    @staticmethod
    def convertSymmetricToStd(name):
        """
        Convert a symmetric matrix to a standard matrix.

        Parameters
        ----------
        name : str
            Name of the matrix.

        Raises
        ------
        ValueError
            If matrix `name` does not exist.
        """
        return _stp._st_convertsymmetrictostd(name)

    @staticmethod
    def create(name, nrows, ncols, initialValue, isSymmetric=False):
        """
        Create a Stata matrix.

        Parameters
        ----------
        name : str
            Name of the matrix.

        nrows : int
            Number of rows.

        ncols : int
            Number of columns.

        initialValue : float
            An initialization value for each element.

        isSymmetric : bool, optional
            Mark the matrix as symmetric. If the number of rows and columns 
            are not equal, this parameter will be ignored. This parameter 
            affects the behavior of :meth:`storeAt()`. When the matrix is 
            marked as symmetric, :meth:`storeAt()` will always maintain 
            symmetry. Default is False.

        Raises
        ------
        ValueError
            This error can be raised if

              - `nrows` is not a positive integer.
              - `ncols` is not a positive integer.
        """
        if isSymmetric is True:	
            isSymmetric = 1 
        elif isSymmetric is False:
            isSymmetric = 0
        else:
            raise TypeError("isSymmetric must be a boolean value")

        return _stp._st_creatematrix(name, nrows, ncols, initialValue, isSymmetric)

    @staticmethod
    def get(name, rows=None, cols=None):
        """
        Get the data in a Stata matrix.

        Parameters
        ----------
        name : str
            Name of the matrix.

        rows : int or list-like, optional
            Rows to access. It can be specified as a single row index 
            or an iterable of row indices. If `rows` is not specified, 
            all the rows are specified.

        cols : int or list-like, optional
            Columns to access. It can be specified as a single column 
            index or an iterable of column indices. If `cols` is not 
            specified, all the columns are specified.

        Returns
        -------
        list
            A list of lists containing the matrix values. Each sublist 
            contains values from each row of the matrix. Abort with an error 
            if the matrix does not exist.

        Raises
        ------
        ValueError
            This error can be raised if

              - matrix `name` does not exist.
              - any of the row indices specified in `rows` is out of :ref:`range <ref-matrixrange>`.
              - any of the column indices specified in `cols` is out of :ref:`range <ref-matrixrange>`.
        """
        ncols = _stp._st_getmatrixcol(name)
        
        if rows is None:
            mrows = None
        else:
            ncols = _stp._st_getmatrixcol(name)
            nrows = _stp._st_getmatrixrow(name)
            mrows = _get_matrix_index(rows, name, nrows, ncols, True)

        if cols is None:
            mcols = None 
        else:
            ncols = _stp._st_getmatrixcol(name)
            nrows = _stp._st_getmatrixrow(name)
            mcols = _get_matrix_index(cols, name, nrows, ncols, False)

        return _stp._st_getmatrix(name, mrows, mcols)

    @staticmethod
    def getAt(name, row, col):
        """
        Access an element from a Stata matrix.

        Parameters
        ----------
        name : str
            Name of the matrix.

        row : int 
            Row to access.

        col : int
            Column to access.

        Returns
        -------
        float
            The value.

        Raises
        ------
        ValueError
            This error can be raised if

              - matrix `name` does not exist.
              - `row` is out of :ref:`range <ref-matrixrange>`.
              - `col` is out of :ref:`range <ref-matrixrange>`.
        """
        return 	_stp._st_getmatrixat(name, row, col)

    @staticmethod
    def getColNames(name):
        """
        Get the column names of a Stata matrix.

        Parameters
        ----------
        name : str
            Name of the matrix.

        Returns
        -------
        list
            A string list containing the column names of the matrix. 

        Raises
        ------
        ValueError
            If matrix `name` does not exist.
        """
        return _stp._st_getmatrixcolnames(name)

    @staticmethod
    def getColTotal(name):
        """
        Get the number of columns in a Stata matrix.

        Parameters
        ----------
        name : str
            Name of the matrix.

        Returns
        -------
        int
            The number of columns. 

        Raises
        ------
        ValueError
            If matrix `name` does not exist.
        """
        return _stp._st_getmatrixcol(name)

    @staticmethod
    def getRowNames(name):
        """
        Get the row names of a Stata matrix.

        Parameters
        ----------
        name : str
            Name of the matrix.

        Returns
        -------
        list
            A string list containing the row names of the matrix.

        Raises
        ------
        ValueError
            If matrix `name` does not exist.
        """
        return _stp._st_getmatrixrownames(name)

    @staticmethod
    def getRowTotal(name):
        """
        Get the number of rows in a Stata matrix.

        Parameters
        ----------
        name : str
            Name of the matrix.

        Returns
        -------
        int
            The number of rows. 

        Raises
        ------
        ValueError
            If matrix `name` does not exist.
        """
        return _stp._st_getmatrixrow(name)

    @staticmethod
    def list(name, rows=None, cols=None):
        """
        Display a Stata matrix.

        Parameters
        ----------
        name : str
            Name of the matrix.

        rows : int or list-like, optional
            Rows to display. It can be specified as a single row index 
            or an iterable of row indices. If `rows` is not specified, 
            all the rows are specified.

        cols : int or list-like, optional
            Columns to display. It can be specified as a single column 
            index or an iterable of column indices. If `cols` is not 
            specified, all the columns are specified. 

        Raises
        ------
        ValueError
            This error can be raised if

              - matrix `name` does not exist.
              - any of the row indices specified in `rows` is out of :ref:`range <ref-matrixrange>`.
              - any of the column indices specified in `cols` is out of :ref:`range <ref-matrixrange>`.
        """
        ncols = _stp._st_getmatrixcol(name)
        nrows = _stp._st_getmatrixrow(name)

        if rows is None:	
            mrows = None
        else:
            mrows = _get_matrix_index(rows, name, nrows, ncols, True)

        if cols is None:
            mcols = None
        else:
            mcols = _get_matrix_index(cols, name, nrows, ncols, False)

        return _stp._st_listmatrix(name, mrows, mcols)		

    @staticmethod
    def setColNames(name, colNames):
        """
        Set the column names of a Stata matrix.

        Parameters
        ----------
        name : str
            Name of the matrix.

        colNames : list or tuple
            A string list or tuple containing the column names for the 
            matrix. The list or tuple length must match the number of 
            columns in the matrix.

        Raises
        ------
        ValueError
            This error can be raised if

              - matrix `name` does not exist.
              - number of column names specified in `colNames` does not match the number of columns of the matrix.
        """
        return _stp._st_setmatrixcolnames(name, colNames)

    @staticmethod
    def setRowNames(name, rowNames):
        """
        Set the row names of a Stata matrix.

        Parameters
        ----------
        name : str
            Name of the matrix.

        rowNames : list or tuple
            A string list or tuple containing the row names for the 
            matrix. The list or tuple length must match the number of 
            rows in the matrix.

        Raises
        ------
        ValueError
            This error can be raised if

              - matrix `name` does not exist.
              - number of row names specified in `rowNames` does not match the number of rows of the matrix.
        """
        return _stp._st_setmatrixrownames(name, rowNames)

    @staticmethod
    def store(name, val):
        """
        Store elements in an existing Stata matrix or create a new 
        Stata matrix if the matrix does not exist.

        Parameters
        ----------
        name : str
            Name of the matrix.

        val : array-like
            Values to store. The dimensions of `val` should match the 
            dimensions of the matrix. Each value of `val` must be a 
            real number.

        Raises
        ------
        ValueError
            This error can be raised if

              - matrix `name` does not exist.
              - dimensions of `val` do not match the dimensions of the matrix.
        """
        mexist = True
        try:
            ncols = _stp._st_getmatrixcol(name)
            nrows = _stp._st_getmatrixrow(name)
        except:
            mexist = False

        def listimize(x):
            if isinstance(x, str):
                raise TypeError("Value of matrix can not be string")
            if not hasattr(x, "__iter__"):
                return [x]
            return list(x)

        if isinstance(val, str):
            raise TypeError("Value of matrix can not be string")

        if not hasattr(val, "__iter__"):
            val = [[val]]
        else:
            val = list(listimize(v) for v in val)

        if mexist is True:
            if (nrows == 1 and len(val) == ncols and 
                _check_all(len(v) == 1 for v in val)):
                val = [[v[0] for v in val]]

            if not len(val) == nrows:
                raise ValueError("compatibility error; rows unmatch")
            if not _check_all(len(v) == ncols for v in val):
                raise ValueError("compatibility error; columns unmatch") 
        else:
            if len(val) <= 0:
                raise ValueError("compatibility error; val is empty")
            ncols = len(val[0])
            if not _check_all(len(v) == ncols for v in val):
                raise ValueError("compatibility error; columns unmatch")			

        return _stp._st_storematrix(name, val)

    @staticmethod
    def storeAt(name, row, col, val):
        """
        Store an element in an existing Stata matrix.

        Parameters
        ----------
        name : str
            Name of the matrix.

        row : int 
            Row in which to store.

        col : int
            Column in which to store.

        val : float
            Value to store.

        Raises
        ------
        ValueError
            This error can be raised if

              - matrix `name` does not exist.
              - `row` is out of :ref:`range <ref-matrixrange>`.
              - `col` is out of :ref:`range <ref-matrixrange>`.
        """
        return _stp._st_storematrixat(name, row, col, val)


class Missing:
    """
    This class provides access to Stata missing values. 
    """

    a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z = \
        [chr(i+97) for i in range(26)]

    @staticmethod
    def getValue(val=None):
        """
        Get the numeric value that represents the missing value in Stata.

        Parameters
        ----------
        val : {'a', 'b', ..., 'z'}, optional
            The character indicating which missing value to get. If `val` is 
            not specified, the Stata system missing value is returned. If `val` 
            is specified, it must be one of 'a', 'b', ..., or 'z', and the 
            corresponding extended missing value is returned.

        Returns
        -------
        float
            The numeric value of a missing value in Stata.
        """
        missIndex = 0
        if val is not None:
            if val not in [chr(i+97) for i in range(26)]:
                raise ValueError("val must be one of 'a', 'b', ..., or 'z'")

            missIndex = ord(val)-96

        return _stp._st_getmissingvalue(missIndex)

    @staticmethod
    def isMissing(val):
        """
        Test if a value is a Stata missing.

        Parameters
        ----------
        val : float
            The value to test.

        Returns
        -------
        bool
            True if the value is a Stata missing.
        """
        return _stp._st_isvaluemissing(val)

    @staticmethod
    def parseIsMissing(s):
        """
        Test if a string is a Stata missing.

        Parameters
        ----------
        s : str
            The string to test.

        Returns
        -------
        bool
            True if the string matches a Stata system missing value or an 
            extended missing value.
        """
        if s == '.':
            return True
        else:
            if not isinstance(s, str):
                raise TypeError("s must be str")
            if len(s) != 2:
                return False 
            if s[0] != '.' or s[1] > 'z' or s[1] < 'a':
                return False

        return True


class Platform:
    """
    This class provides a set of utilities for getting platform 
    information.
    """

    def __init__(self):
        pass 

    @staticmethod
    def isLinux():
        """
        Determine if the platform is Linux.

        Returns
        -------
        bool
            True if the platform is Linux.
        """
        pf = platform()
        if pf.lower().find("linux") >= 0:
            return True
        else:
            return False

    @staticmethod
    def isMac():
        """
        Determine if the platform is Mac OS.

        Returns
        -------
        bool
            True if the platform is Mac OS.
        """	
        pf = platform()
        if pf.lower().find("darwin") >= 0:
            return True
        else:
            return False

    @staticmethod
    def isSolaris():
        """
        Determine if the platform is Solaris.

        Returns
        -------
        bool
            True if the platform is Solaris.
        """
        pf = platform()
        if pf.lower().find("sunos") >= 0:
            return True
        else:
            return False

    @staticmethod
    def isUnix():
        """
        Determine if the platform is Unix or Linux.

        Returns
        -------
        bool
            True if the platform is Unix or Linux.
        """
        pf = platform()
        if pf.lower().find("sunos") >= 0:
            return True
        elif pf.lower().find("nux") >= 0:
            return True
        elif pf.lower().find("nix") >= 0:
            return True
        else:
            return False

    @staticmethod
    def isWindows(version=None):
        """
        Determine if the platform is Windows and the version number is 
        greater than or equal to the version specified.

        Parameters
        ----------
        version : float, optional
            The Windows version to verify. Version numbers correspond 
            to internal Microsoft versions, such as 5.1, 6.0, 6.1, 6.2, 
            6.3, and 10.0. 

        Returns
        -------
        bool
            True if the platform is Windows and the version is not 
            less than specified.
        """
        pf = platform()
        if pf.lower().find("darwin") >= 0:
            return False
        else: 
            if pf.lower().find("win") < 0:
                return False

        if version is not None:
            version = str(version)
            sv = sys.getwindowsversion()
            try:
                version = float(version)
            except:
                raise TypeError("version must be a number")

            if float(str(sv[0])+"."+str(sv[1])) < version:
                return False

        return True


class Preference:
    """
    This class provides a set of utilities for loading and saving 
    preferences.
    """

    def __init__(self):
        pass 

    @staticmethod
    def deleteSavedPref(section, key):
        """
        Delete a saved preference.

        Parameters
        ----------
        section : str
            The preference section.

        key : str
            The preference key.
        """
        return _stp._st_deletesavedpref(section, key)

    @staticmethod
    def getSavedPref(section, key, defaultValue):
        """
        Get a saved preference.

        Parameters
        ----------
        section : str
            The preference section.

        key : str
            The preference key.

        defaultValue : str
            The default value if the key is not found.

        Returns
        -------
        str
            The saved preference.
        """
        return _stp._st_getsavedpref(section, key, defaultValue)

    @staticmethod
    def setSavedPref(section, key, value):
        """
        Write a saved preference.

        Parameters
        ----------
        section : str
            The preference section.

        key : str
            The preference key.

        value : str
            The value to save.
        """
        return _stp._st_setsavedpref(section, key, value)


class Scalar:
    """
    This class provides access to Stata scalars.
    """

    def __init__(self):
        pass 

    @staticmethod
    def getString(name):
        """
        Get the contents of a Stata string scalar.

        Parameters
        ----------
        name : str
            Name of the scalar. It can be one of the following:

                * global scalar such as **"myname"**

                * **c()** scalar such as **"c(current_date)"**

        Returns
        -------
        str
            Value of the scalar. Returns an empty string if the scalar 
            is not found or if the scalar is marked as binary.
        """
        return _stp._st_getstring(name)

    @staticmethod
    def getValue(name):
        """
        Get the value of a Stata numeric scalar.

        Parameters
        ----------
        name : str
            Name of the scalar. It can be one of the following:

                * global scalar such as **"myname"**

                * **return()** scalar such as **"return(retval)"**

                * **r()** scalar such as **"r(mean)"**

                * **e()** scalar such as **"e(N)"**

                * **c()** scalar such as **"c(level)"**

        Returns
        -------
        float
            Value of the scalar.
        """
        return _stp._st_getvalue(name)

    @staticmethod
    def setString(name, value):
        """
        Set the contents of a Stata string scalar. If necessary, the scalar 
        will be created.

        Parameters
        ----------
        name : str
            Name of the scalar.

        value : str
            Value to store in the scalar.
        """
        return _stp._st_setstring(name, value)

    @staticmethod
    def setValue(name, value, vtype="visible"):
        """
        Set the value of a Stata numeric scalar. If necessary, the scalar 
        will be created.

        Parameters
        ----------
        name : str
            Name of the scalar. It can be one of the following:

                * global scalar such as **"myname"**

                * **return()** scalar such as **"return(retval)"**

                * **r()** scalar such as **"r(mean)"**

                * **e()** scalar such as **"e(N)"**

        value : float
            Value to store in the scalar.

        vtype : {'visible', 'hidden', 'historical'}, optional
            If the scalar is either a **return()**, **r()**, or **e()** scalar, 
            `vtype` sets whether the return value is **visible**, **hidden**, or 
            **historical**. This parameter is ignored when the scalar is a 
            global scalar. Default is **'visible'**.
        """
        if vtype not in ['visible', 'hidden', 'historical']:
            raise ValueError('vtype must be one of visible, hidden, or historical')

        return _stp._st_setvalue(name, value, vtype)


class SFIError(Exception):
    """
    This class is the base class for other exceptions defined in this module.
    """
    pass


class FrameError(SFIError):
    """
    The class is used to indicate that an exceptional condition has occurred with a :class:`Frame`.
    """
    pass


class SFIToolkit:
    """
    This class provides a set of core tools for interacting with Stata.	
    """

    def __init__(self):
        pass

    @staticmethod
    def abbrev(s, n=None):
        """
        Return `s` abbreviated to `n` display columns. Usually, this means it 
        will be abbreviated to `n` characters, but if `s` contains characters
        requiring more than one display column, such as Chinese, Japanese, 
        and Korean (CJK) characters, `s` will be abbreviated such that it does 
        not exceed `n` display columns.

        * `n` is the abbreviation length and is assumed to contain integer values in the range 5, 6, ..., 32.

        * If `s` contains a period, **.**, and `n` < 8, then the value `n` defaults to 8.  Otherwise, if `n` < 5, then `n` defaults to 5.

        * If `n` is not specified, the entire string is returned.

        Parameters
        ----------
        s : str
            The string to abbreviate.

        n: int, optional
            The abbreviation length.

        Returns
        -------
        str 
            An abbreviated string.

        Raises
        ------
        ValueError
            If `n` is out of range.
        """
        if n is not None:
            if not isinstance(n, int):
                raise TypeError("n must be an integer")
            if n<5 or n>32:
                raise ValueError("n must be an integer between 5 and 32")
        else:
            n = -1

        return _stp._st_abbrev(s, n)

    @staticmethod
    def display(s, asis=False):
        """
        Output a string to the Stata Results window. Before the string 
        is printed, it is run through the Stata SMCL interpreter.

        Parameters
        ----------
        s : str
            The string to output.

        asis : bool, optional
            When True, the string is printed without using the Stata SMCL 
            interpreter. Default is False.
        """
        if asis is True:	
            asis = 1 
        elif asis is False:
            asis = 0
        else:
            raise TypeError("asis must be a boolean value")

        return _stp._st_display(s, asis, 1)

    @staticmethod
    def displayln(s, asis=False):
        """
        Output a string to the Stata Results window and automatically 
        add a line terminator at the end. Before the string is printed, 
        it is run through the Stata SMCL interpreter.

        Parameters
        ----------
        s : str
            The string to output.

        asis : bool, optional
            When True, the string is printed without using the Stata SMCL 
            interpreter. Default is False.
        """
        if asis is True:	
            asis = 1 
        elif asis is False:
            asis = 0
        else:
            raise TypeError("asis must be a boolean value")

        return _stp._st_display(s+"\n", asis, 2)

    @staticmethod
    def eclear():
        """
        Clear Stata's **e()** stored results.
        """
        return _stp._st_eclear()

    @staticmethod
    def error(rc):
        """
        Output the standard Stata error message associated with return code `rc` 
        to the Stata Results window.

        Parameters
        ----------
        rc : int
            The return code for the error.

        Raises
        ------
        ValueError
            If `rc` is negative.
        """
        return _stp._st_error(rc)

    @staticmethod
    def errprint(s, asis=False):
        """
        Output a string to the Stata Results window as an error. Before 
        the string is printed, it is run through the Stata SMCL 
        interpreter.

        Parameters
        ----------
        s : str
            The string to output.

        asis : bool, optional
            When True, the string is printed without using the Stata SMCL 
            interpreter. Default is False.
        """
        if asis is True:	
            asis = 1 
        elif asis is False:
            asis = 0
        else:
            raise TypeError("asis must be a boolean value")

        return _stp._st_errprint(s, asis, 1)

    @staticmethod
    def errprintDebug(s, asis=False):
        """
        Output a string to the Stata Results window as an error if **set 
        debug on** is enabled.

        Parameters
        ----------
        s : str
            The string to output.

        asis : bool, optional
            When True, the string is printed without using the Stata SMCL 
            interpreter. Default is False.

        Returns
        -------
        bool 
            True if **set debug on** is enabled.
        """
        if asis is True:	
            asis = 1 
        elif asis is False:
            asis = 0
        else:
            raise TypeError("asis must be a boolean value")

        return _stp._st_errordebug(s, asis, 1)

    @staticmethod
    def errprintln(s, asis=False):
        """
        Output a string to the Stata Results window and automatically 
        add a line terminator at the end. Before the string is printed, 
        it is run through the Stata SMCL interpreter.

        Parameters
        ----------
        s : str
            The string to output.

        asis : bool, optional
            When True, the string is printed without using the Stata SMCL 
            interpreter. Default is False.
        """
        if asis is True:	
            asis = 1 
        elif asis is False:
            asis = 0
        else:
            raise TypeError("asis must be a boolean value")

        return _stp._st_errprint(s+"\n", asis, 2)

    @staticmethod
    def errprintlnDebug(s, asis=False):
        """
        Output a string to the Stata Results window as an error if **set 
        debug on** is enabled, and automatically add a line terminator at
        the end.

        Parameters
        ----------
        s : str
            The string to output.

        asis : bool, optional
            When True, the string is printed without using the Stata SMCL 
            interpreter. Default is False.

        Returns
        -------
        bool 
            True if **set debug on** is enabled.
        """
        if asis is True:	
            asis = 1 
        elif asis is False:
            asis = 0
        else:
            raise TypeError("asis must be a boolean value")

        return _stp._st_errordebug(s+"\n", asis, 2)

    @staticmethod
    def exit(rc=0):
        """
        Terminate execution and set the overall return code to `rc`. **exit()** 
        with no argument is equivalent to **exit(0)**.

        Parameters
        ----------
        rc : int, optional
            The overall return code. Default is 0.

        Raises
        ------
        ValueError
            If `rc` is negative.
        """
        return _stp._st_exit(rc)

    @staticmethod
    def formatValue(value, format):
        """
        Format a value using a Stata format.

        Parameters
        ----------
        value : float
            The value to format.

        format : str
            A valid Stata format.

        Returns
        -------
        str
            The formatted value in string form.

        Raises
        ------
        ValueError
            If `format` is not a valid Stata numeric format.
        """
        return _stp._st_formatvalue(value, format)

    @staticmethod
    def getCallerVersion():
        """
        Get the version number of the calling program. This function can 
        be used to implement Stata version control.

        Returns
        -------
        float
            The caller's version number.
        """
        return _stp._st_getcallerversion()

    @staticmethod
    def getRealOfString(s):
        """
        Get the double representation of a string using Stata's **real()** 
        function.

        Parameters
        ----------
        s : str
            The string to convert.

        Returns
        -------
        float
            The numeric value. If the numeric value is a Stata missing value 
            or the string cannot be converted to a numeric value, the Stata 
            system missing value is returned.
        """
        return _stp._st_getrealofstring(s)

    @staticmethod
    def getTempFile():
        """
        Get a valid Stata temporary filename.

        Returns
        -------
        str
            The filename, including its path.
        """
        return _stp._st_gettempfile()

    @staticmethod
    def getTempName():
        """
        Get a valid Stata temporary name.

        Returns
        -------
        str
            The tempname.
        """
        return _stp._st_gettempname()

    @staticmethod
    def getWorkingDir():
        """
        Get the current Stata working directory.

        Returns
        -------
        str
            The path of the current working directory.
        """
        return _stp._st_getworkingdir()

    @staticmethod
    def isFmt(fmt):
        """
        Test if a format is a valid Stata format.

        Parameters
        ----------
        fmt : str
            The format to test.

        Returns
        -------
        bool
            True if the format is a valid Stata format.
        """
        b = _stp._st_getfmttype(fmt)
        if b=="":
            return False 
        else:
            return True

    @staticmethod
    def isNumFmt(fmt):
        """
        Test if a format is a valid Stata numeric format.

        Parameters
        ----------
        fmt : str
            The format to test.

        Returns
        -------
        bool
            True if the format is a valid Stata numeric format.
        """
        b = _stp._st_getfmttype(fmt)
        if b=="numeric":
            return True 
        else:
            return False

    @staticmethod
    def isStrFmt(fmt):
        """
        Test if a format is a valid Stata string format.

        Parameters
        ----------
        fmt : str
            The format to test.

        Returns
        -------
        bool
            True if the format is a valid Stata string format.
        """
        b = _stp._st_getfmttype(fmt)
        if b=="string":
            return True 
        else:
            return False

    @staticmethod
    def isValidName(name):
        """
        Check if a string is a valid Stata name.

        Parameters
        ----------
        name : str
            Name to test.

        Returns
        -------
        bool
            True if the string represents a valid Stata name.
        """
        return _stp._st_isvalidname(name)

    @staticmethod
    def isValidVariableName(name):
        """
        Check if a string is a valid Stata variable name.

        Parameters
        ----------
        name : str
            Name to test.

        Returns
        -------
        bool
            True if the string represents a valid Stata variable name.
        """
        return _stp._st_isvalidvariablename(name)

    @staticmethod
    def macroExpand(s):
        """
        Return `s` with any quoted or dollar sign--prefixed macros expanded.

        Parameters
        ----------
        s : str
            The string to expand.

        Returns
        -------
        str 
            A string with macros expanded.
        """
        return _stp._st_macroexpand(s)

    @staticmethod
    def makeVarName(s, retainCase=False):
        """
        Attempt to form a valid variable name from a string.

        Parameters
        ----------
        s : str
            Source string.

        retainCase : bool, optional
            Preserve the case or convert variable name to lowercase. If set to 
            True, the case will not be converted to lowercase. Default is 
            False.

        Returns
        -------
        str
            The new variable name. Returns an empty string if a valid 
            name was not created.
        """
        if retainCase is True:	
            rcase = 1 
        elif retainCase is False:
            rcase = 0
        else:
            raise TypeError("retainCase must be a boolean value")

        return _stp._st_makevarname(s, rcase)

    @staticmethod
    def pollnow():
        """
        Request that Stata poll its GUI immediately. Use this method inside 
        a time-consuming task so that the Stata interface is responsive to 
        user inputs. Generally, :meth:`pollstd()` should be used instead.
        """
        return _stp._st_pollnow()

    @staticmethod
    def pollstd():
        """
        Request that Stata poll its GUI at the standard interval. Use this 
        method inside a time-consuming task so that the Stata interface is 
        responsive to user inputs.
        """
        return _stp._st_pollstd()

    @staticmethod
    def rclear():
        """
        Clear Stata's **r()** stored results.
        """
        return _stp._st_rclear()

    @staticmethod
    def sclear():
        """
        Clear Stata's **s()** stored results.
        """
        return _stp._st_sclear()

    @staticmethod
    def stata(s, echo=False):
        """
        Execute a Stata command.

        Parameters
        ----------
        s : str
            The command to execute.

        echo : bool, optional
            Echo the command. Default is False.
        """
        if echo is True:	
            becho = 1
        elif echo is False:
            becho = 0
        else:
            raise TypeError("echo must be a boolean value")

        return _stp._st_executecommand(s, becho)

    @staticmethod
    def strToName(s, prefix=False):
        """
        Convert a string to a Stata name. Each character in `s` that is 
        not allowed in a Stata name is converted to an underscore 
        character, **_**.  If the first character in `s` is a numeric
        character and `prefix` is specified and True, then the result is 
        prefixed with an underscore.  The result is truncated to 32 
        characters.

        Parameters
        ----------
        s : str
            The string to convert.

        prefix : bool, optional
            Prefix with an underscore. Default is False.

        Returns
        -------
        str 
            A valid Stata name.
        """
        if prefix is True:	
            bprefix = 1
        elif prefix is False:
            bprefix = 0
        else:
            raise TypeError("prefix must be a boolean value")

        return _stp._st_strtoname(s, bprefix)


class StrLConnector:
    """
    This class facilitates access to Stata's **strL** datatype.	The allowed 
    values for the variable index `var` and the observation index `obs` 
    are

    .. _ref-strlrange:

    .. centered:: **-nvar** `<=` `var` `<` **nvar**

    and

    .. centered:: **-nobs** `<=` `obs` `<` **nobs**

    Here **nvar** is the number of variables defined in the dataset 
    currently loaded in Stata or in the specified frame, which is 
    returned by :meth:`~Data.getVarCount()`. **nobs** is the number of observations 
    defined in the dataset currently loaded in Stata or in the 
    specified frame, which is returned by :meth:`~Data.getObsTotal()`. 

    Negative values for `var` and `obs` are allowed and are interpreted in the 
    usual way for Python indexing. `var` can be specified either as the 
    variable name or index. Note that passing the variable index will be more 
    efficient because looking up the index for the specified variable name is 
    avoided.

    There are two ways to create a :class:`StrLConnector` instance: 

    * StrLConnector(`var`, `obs`)

        Creates a :class:`StrLConnector` and connects it to a specific **strL** in 
        the Stata dataset; see :class:`Data`.

        **var** : int or str
            Variable to access.

        **obs** : int
            Observation to access.

        A **ValueError** can be raised if

        * `var` is out of :ref:`range <ref-strlrange>` or not found.
        * `obs` is out of :ref:`range <ref-strlrange>`.

    * StrLConnector(`frame`, `var`, `obs`)

        Creates a :class:`StrLConnector` and connects it to a specific **strL** in 
        the specified :class:`~Frame`.

        **frame** : :class:`~Frame`
            The :class:`Frame` to reference.

        **var** : int or str
            Variable to access.

        **obs** : int
            Observation to access.

        A **ValueError** can be raised if

        * `frame` does not already exist in Stata.
        * `var` is out of :ref:`range <ref-strlrange>` or not found.
        * `obs` is out of :ref:`range <ref-strlrange>`.
    """
    def __init__(self, *argv):
        nargs = len(argv)
        if nargs != 2 and nargs != 3:
            raise TypeError("__init__() takes from 2 to 3 positional arguments")

        f = argv[0]
        if isinstance(f, Frame):
            if nargs != 3:
                raise TypeError("__init__() takes 3 required arguments when a frame is specified")

            var = argv[1]
            obs = argv[2]
            nobs = f.getObsTotal()
            nvar = f.getVarCount()

            ovar = _get_df_var_index_single(f.name, f.id, var)
            if ovar<-nvar or ovar>=nvar:
                raise ValueError("%d: var out of range" % (var))

            if obs<-nobs or obs>=nobs:
                raise ValueError("%d: obs out of range" % (obs))

            if not f.isVarTypeStrL(ovar):
                raise TypeError("type mismatch; not a strL")

            self._var = ovar 
            self._obs = obs
            self._pos = 0
            self.frame = f
        else:
            if nargs != 2:
                raise TypeError("__init__() takes 2 required arguments when no frame is specified")

            var = argv[1]
            nobs = Data.getObsTotal()
            nvar = Data.getVarCount()

            ovar = _get_var_index_single(f)
            if ovar<-nvar or ovar>=nvar:
                raise ValueError("%d: var out of range" % (f))

            if var<-nobs or var>=nobs:
                raise ValueError("%d: obs out of range" % (var))

            if not Data.isVarTypeStrL(ovar):
                raise TypeError("type mismatch; not a strL")

            self._var = ovar 
            self._obs = var
            self._pos = 0
            self.frame = None

    def close(self):
        """
        Close the connection and release any resources.
        """
        return self.reset() 

    def getPosition(self):
        """
        Get the current access position.

        Returns
        -------
        int
            The position.
        """
        return self._pos 

    def getSize(self):
        """
        Get the total number of bytes available in the **strL**.

        Returns
        -------
        int
            The total number of bytes available.
        """
        if self.frame is None:
            return _stp._st_getbytessize(self._var, self._obs)
        else:
            return _stp._st_df_getbytessize(self.frame.name, self.frame.id, self._var, self._obs)

    def isBinary(self):
        """
        Determine if the attached **strL** has been marked as binary.

        Returns
        -------
        bool
            True if the **strL** has been marked as binary.
        """
        if self.frame is None:
            return _stp._st_isstrlbinary(self._var, self._obs)
        else:
            return _stp._st_df_isstrlbinary(self.frame.name, self.frame.id, self._var, self._obs)

    @property
    def obs(self):
        """
        Return the observation number of the attached **strL**.
        """
        return self._obs

    @property
    def pos(self):
        """
        Return the current position.
        """
        return self._pos

    def reset(self):
        """
        Reset the access position to its initial value.
        """
        self._pos = 0

    def setPosition(self, pos):
        """
        Set the access position.

        Parameters
        ----------
        pos : int
            The new position.
        """
        if not isinstance(pos, int):
            raise TypeError("pos must be an integer")

        self._pos = pos

    @property
    def var(self):
        """
        Return the variable index of the attached **strL**.
        """
        return self._var

	
class ValueLabel:
    """
    This class provides access to Stata's value labels.	
    """

    def __init__(self):
        pass

    @staticmethod
    def createLabel(name):
        """
        Create a new value-label name.

        Parameters
        ----------
        name : str
            The new name.
        """
        return _stp._st_createlabel(name)

    @staticmethod
    def getLabel(name, value):
        """
        Get the label for a specified value-label value.

        Parameters
        ----------
        name : str
            The name of the value label.

        value : int
            The value to look up.

        Returns
        -------
        str
            The label for the specified value-label value. Returns 
            an empty string if the value-label value is not found.
        """
        return _stp._st_getlabel(name, value)

    @staticmethod
    def getLabels(name):
        """
        Get the labels for a specified value-label name. Use this method 
        in conjunction with :meth:`getValues()` to obtain two lists, where list 
        indexes are used to look up each value-label pairing.

        Parameters
        ----------
        name : str
            The name of the value label.

        Returns
        -------
        list
            A list of the labels for the specified value-label name.
        """
        return _stp._st_getlabels(name)

    @staticmethod
    def getNames():
        """
        Get the names of all value labels in the current dataset.

        Returns
        -------
        list
            A list of value-label names.
        """	
        return _stp._st_getnames()

    @staticmethod
    def getValueLabels(name):
        """
        Get the values and labels for a specified value-label name.

        Parameters
        ----------
        name : str
            The name of the value label.

        Returns
        -------
        directory
            A dictionary containing the values and label pairings 
            for the specified value-label name.
        """
        return _stp._st_getvaluelabels(name)

    @staticmethod
    def getValues(name):
        """
        Get the values associated with a single value-label name. Use this 
        method in conjunction with :meth:`getLabels()` to obtain two lists, where 
        list indexes are used to look up each value-label pairing.

        Parameters
        ----------
        name : str
            The name of the value label.

        Returns
        -------
        list
            A list of the values for the specified value-label name.
        """
        return _stp._st_getvalues(name)

    @staticmethod
    def getVarValueLabel(var):
        """
        Get the value-label name associated with a variable.

        Parameters
        ----------
        var : str or int
            Name or index of the variable.

        Returns
        -------
        str
            The value-label name associated with a variable. Returns 
            an empty string if a value label is not associated with the 
            specified variable.

        Raises
        ------
        ValueError
            If `var` is not found or out of :ref:`range <ref-datarange>`.
        """
        oindex = _get_var_index_single(var)
        return _stp._st_getvarvaluelabel(oindex)

    @staticmethod
    def removeLabel(name):
        """
        Remove a value-label name.

        Parameters
        ----------
        name : str
            The name of the value label to remove.
        """
        return _stp._st_removelabel(name)

    @staticmethod
    def removeLabelValue(name, value):
        """
        Remove a value-label value.

        Parameters
        ----------
        name : str
            The name of the value label.

        value : int
            The value to remove.
        """
        return _stp._st_removelabelvalue(name, value)

    @staticmethod
    def removeVarValueLabel(var):
        """
        Remove a value-label name from a variable.

        Parameters
        ----------
        var : str or int
            Name or index of the variable.

        Raises
        ------
        ValueError
            If `var` is not found or out of :ref:`range <ref-datarange>`.
        """
        oindex = _get_var_index_single(var)
        return _stp._st_removevarvaluelabel(oindex)

    @staticmethod
    def setLabelValue(name, value, label):
        """
        Set a value and label for a value-label name.

        Parameters
        ----------
        name : str
            The name of the value label.

        value : int
            The value.

        label : str
            The label.
        """
        return _stp._st_setlabelvalue(name, value, label)

    @staticmethod
    def setVarValueLabel(var, labelName):
        """
        Set the value label for a variable.

        Parameters
        ----------
        var : str or int
            Name or index of the variable.

        labelName : str
            The value-label name.

        Raises
        ------
        ValueError
            This error can be raised if:

              - `var` is not found or out of :ref:`range <ref-datarange>`.
              - `var` is a string variable.
        """
        oindex = _get_var_index_single(var)
        if _stp._st_isvartypestring(oindex) is True:
            raise ValueError("may not label strings")

        return _stp._st_setvarvaluelabel(oindex, labelName)
