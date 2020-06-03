"""
The EMIS data is accessed via Presto which is a distributed query engine which
runs over multiple backing data stores ("connectors" in Presto's parlance).
The production configuration uses the following connectors:

    hive for views
    delta-lake for underlying data
    mysql for config/metadata

For immediate convenience while testing we use the SQL Server connector (as we
already need an instance running for the TPP tests).
"""
import os
import time

import sqlalchemy
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, Date
from sqlalchemy.orm import sessionmaker

from datalab_cohorts.mssql_utils import mssql_sqlalchemy_engine_from_url
from datalab_cohorts.presto_utils import wait_for_presto_to_be_ready


Base = declarative_base()


def make_engine():
    engine = mssql_sqlalchemy_engine_from_url(
        os.environ["EMIS_DATASOURCE_DATABASE_URL"]
    )
    timeout = os.environ.get("CONNECTION_RETRY_TIMEOUT")
    timeout = float(timeout) if timeout else 60
    # Wait for the database to be ready if it isn't already
    start = time.time()
    while True:
        try:
            engine.connect()
            break
        except sqlalchemy.exc.DBAPIError:
            if time.time() - start < timeout:
                time.sleep(1)
            else:
                raise
    wait_for_presto_to_be_ready(os.environ["EMIS_DATABASE_URL"], timeout)
    return engine


def make_session():
    engine = make_engine()
    Session = sessionmaker()
    Session.configure(bind=engine)
    session = Session()
    return session


def make_database():
    Base.metadata.create_all(make_engine())


class Patient(Base):
    __tablename__ = "Patient"

    Patient_ID = Column(Integer, primary_key=True)
    DateOfBirth = Column(Date)
    Sex = Column(String)
