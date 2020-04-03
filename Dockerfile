FROM ebmdatalab/datalab-jupyter:python3.8.1-2328e31e7391a127fe7184dcce38d581a17b1fa5

RUN apt-get update
# For stata
RUN apt-get install -y libpng16-16

# For pyodbc
RUN apt-get install -y unixodbc-dev

RUN mkdir -p /usr/local/stata
COPY bin/ /usr/local/stata

# Install pip requirements
COPY requirements.txt /tmp/
# Hack until this is fixed https://github.com/jazzband/pip-tools/issues/823
RUN chmod 644 /tmp/requirements.txt
RUN pip install --requirement /tmp/requirements.txt

WORKDIR /home/app/notebook

CMD ["/bin/bash"]