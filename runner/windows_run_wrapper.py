import sys

from run import check_for_updates
from run import possibly_start_with_gui

if check_for_updates():
    input(
        "New version of wrapper.exe is required. Please run upgrade_wrapper.exe (press any key to continue)"
    )
    sys.exit(1)
else:
    possibly_start_with_gui()
