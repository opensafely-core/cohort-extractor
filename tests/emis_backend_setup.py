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
from sqlalchemy import (
    Column,
    Integer,
    String,
    DateTime,
    Float,
    NVARCHAR,
    Date,
    BigInteger,
)
from sqlalchemy import ForeignKey
from sqlalchemy import Table, MetaData
from sqlalchemy.orm import sessionmaker
from sqlalchemy.orm import relationship
from sqlalchemy.orm import mapper

from cohortextractor.mssql_utils import mssql_sqlalchemy_engine_from_url
from cohortextractor.presto_utils import wait_for_presto_to_be_ready

Base = declarative_base()
metadata = Base.metadata


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
    wait_for_presto_to_be_ready(
        os.environ["EMIS_DATABASE_URL"],
        # Presto will show active nodes in its `system.runtime.nodes` table but
        # then throw a "no nodes available" error if you try to execute a query
        # which needs to touch the MSSQL instance. So to properly confirm that
        # Presto is ready we need a query which forces it to connect to MSSQL,
        # but ideally one which doesn't depend on any particular configuration
        # having been done first. The below seems to do the trick.
        "SELECT 1 FROM sys.tables",
        timeout,
    )
    return engine


def make_session():
    engine = make_engine()
    Session = sessionmaker()
    Session.configure(bind=engine)
    session = Session()
    return session


def make_database():
    Base.metadata.create_all(make_engine())


class Medication(Base):
    __tablename__ = "medication"

    id = Column(Integer, primary_key=True)
    registration_id = Column(Integer, ForeignKey("patient.id"))
    patient = relationship("Patient", back_populates="medications")
    snomed_concept_id = Column(BigInteger)
    effective_date = Column(DateTime)


class Observation(Base):
    __tablename__ = "observation"

    id = Column(Integer, primary_key=True)
    registration_id = Column(Integer, ForeignKey("patient.id"))
    patient = relationship("Patient", back_populates="observations")
    snomed_concept_id = Column(BigInteger)
    value_pq_1 = Column(Float)
    effective_date = Column(DateTime)


class Patient(Base):
    __tablename__ = "patient"

    id = Column(Integer, primary_key=True)
    date_of_birth = Column(DateTime)
    gender = Column(Integer)
    registered_date = Column(DateTime)
    registration_end_date = Column(DateTime)
    rural_urban = Column(Integer)
    imd_rank = Column(Integer)
    msoa = Column(String)
    stp_code = Column(String)
    stp_name = Column(String)
    english_region_code = Column(String)
    english_region_name = Column(String)

    medications = relationship(
        "Medication", back_populates="patient", cascade="all, delete, delete-orphan"
    )
    observations = relationship(
        "Observation", back_populates="patient", cascade="all, delete, delete-orphan"
    )


# WARNING: This table does not correspond to a table in the EMIS database!
class ICNARC(Base):
    __tablename__ = "ICNARC"

    ICNARC_ID = Column(Integer, primary_key=True)
    registration_id = Column(Integer, ForeignKey("patient.id"))
    IcuAdmissionDateTime = Column(DateTime)
    OriginalIcuAdmissionDate = Column(Date)
    BasicDays_RespiratorySupport = Column(Integer)
    AdvancedDays_RespiratorySupport = Column(Integer)
    Ventilator = Column(Integer)


# WARNING: This table does not correspond to a table in the EMIS database!
class ONSDeaths(Base):
    __tablename__ = "ONS_Deaths"

    # This column isn't in the actual database but SQLAlchemy gets a bit upset
    # if we don't give it a primary key
    id = Column(Integer, primary_key=True)
    registration_id = Column(Integer, ForeignKey("patient.id"))
    Sex = Column(String)
    ageinyrs = Column(Integer)
    dod = Column(Date)
    icd10u = Column(String)
    ICD10001 = Column(String)
    ICD10002 = Column(String)
    ICD10003 = Column(String)
    ICD10004 = Column(String)
    ICD10005 = Column(String)
    ICD10006 = Column(String)
    ICD10007 = Column(String)
    ICD10008 = Column(String)
    ICD10009 = Column(String)
    ICD10010 = Column(String)
    ICD10011 = Column(String)
    ICD10012 = Column(String)
    ICD10013 = Column(String)
    ICD10014 = Column(String)
    ICD10015 = Column(String)


# WARNING: This table does not correspond to a table in the EMIS database!
class CPNS(Base):
    __tablename__ = "CPNS"

    registration_id = Column(Integer, ForeignKey("patient.id"))
    Id = Column(Integer, primary_key=True)
    # LocationOfDeath                                                 ITU
    # Sex                                                               M
    # DateOfAdmission                                          2020-04-02
    # DateOfSwabbed                                            2020-04-02
    # DateOfResult                                             2020-04-03
    # RelativesAware                                                    Y
    # TravelHistory                                                 False
    # RegionCode                                                      Y62
    # RegionName                                               North West
    # OrganisationCode                                                ABC
    # OrganisationName                                Test Hospital Trust
    # OrganisationTypeLot                                        Hospital
    # RegionApproved                                                 True
    # RegionalApprovedDate                                     2020-04-09
    # NationalApproved                                               True
    # NationalApprovedDate                                     2020-04-09
    # PreExistingCondition                                          False
    # Age                                                              57
    DateOfDeath = Column(Date)
    # snapDate                                                 2020-04-09
    # HadLearningDisability                                            NK
    # ReceivedTreatmentForMentalHealth                                 NK
    # Der_Ethnic_Category_Description                                None
    # Der_Latest_SUS_Attendance_Date_For_Ethnicity                   None
    # Der_Source_Dataset_For_Ethnicty                                None
