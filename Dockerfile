FROM ebmdatalab/datalab-jupyter:python3.8.1-2328e31e7391a127fe7184dcce38d581a17b1fa5

RUN apt-get update

# For pyodbc
RUN apt-get install -y unixodbc-dev

# Install Microsoft stuff needed to install Pyodbc and access a SQL Server
# database
COPY install_mssql.sh /tmp/
RUN bash /tmp/install_mssql.sh

# Install pip requirements
COPY requirements.txt /tmp/
# Hack until this is fixed https://github.com/jazzband/pip-tools/issues/823
RUN chmod 644 /tmp/requirements.txt
RUN pip install --requirement /tmp/requirements.txt

RUN R -e "install.packages('IRkernel')"

EXPOSE 8888

# This is a custom ipython kernel that allows us to manipulate
# `sys.path` in a consistent way between normal and pytest-with-nbval
# invocations
COPY config/kernel.json /tmp/kernel_with_custom_path/kernel.json
RUN jupyter kernelspec install /tmp/kernel_with_custom_path/ --user --name="python3"

# R kernel
COPY config/ir /tmp/ir
RUN jupyter kernelspec install /tmp/ir

WORKDIR /home/app/notebook
CMD PYTHONPATH=. jupyter lab --config=config/jupyter_notebook_config.py
