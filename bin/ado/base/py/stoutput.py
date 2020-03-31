'''
*! version 1.0.0  24may2019
'''

import sys as _sys

from stata_plugin import (_st_display, _st_errprint, _st_input)

if _sys.version_info[0] < 3:
	reload(_sys)
	_sys.setdefaultencoding('utf8')

try:
    import os as _os
    syspath = _os.path.join(_sys.exec_prefix, "Library/bin")

    if _os.path.isdir(syspath):
        _os.environ["PATH"] = syspath+";"+_os.environ["PATH"]

    if _sys.argv[1]=="1":
        _os.environ['KMP_DUPLICATE_LIB_OK'] = 'True'
except:
    pass
finally:
    del syspath
    del _os

class _StataDisplay:
    def write(self, text):
        textList = text.split("\n")
        for t in textList[:-1]:
            _st_display(t, 1, 0)
            _st_display("\n", 1, 0)
        _st_display(textList[-1], 1, 0)

    def flush(self):
        pass


class _StataError:
    def write(self, text):
        _st_errprint(text, 1, 0)

    def flush(self):
        pass


class _StataInput:
    def readline(self):
        return _st_input()
		
    def close(self):
        pass 

		
_sys.stdout = _StataDisplay()
_sys.stderr = _StataError()
_sys.stdin = _StataInput()

