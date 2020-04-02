import os
import sys


if __name__ == "__main__":
    this_dir = os.path.dirname(__file__)
    sys.path.extend([this_dir, os.path.join(this_dir, 'analysis')])
    # Avoid creating __pycache__ files in the analysis directory
    sys.dont_write_bytecode = True
    from study_definition import study
    study.to_csv('analysis/input.csv')
