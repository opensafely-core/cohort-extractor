"""
The EMIS data is accessed via Trino which is a distributed query engine which
runs over multiple backing data stores ("connectors" in Trino's parlance).
The production configuration uses the following connectors:

    hive for views
    delta-lake for underlying data
    mysql for config/metadata

For immediate convenience while testing we use the SQL Server connector (as we
already need an instance running for the TPP tests).
"""
import os
import re
import uuid

from sqlalchemy import (
    BigInteger,
    Column,
    Date,
    DateTime,
    Float,
    ForeignKey,
    Integer,
    String,
)
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker

from cohortextractor.emis_backend import (
    CPNS_TABLE,
    ICNARC_TABLE,
    IMMUNISATIONS_TABLE,
    MEDICATION_TABLE,
    OBSERVATION_TABLE,
    ONS_TABLE,
    PATIENT_TABLE,
)
from cohortextractor.trino_utils import wait_for_trino_to_be_ready
from tests.helpers import mssql_sqlalchemy_engine_from_url, wait_for_mssql_to_be_ready


# Hack: in order to improve the variety of our test data, we intercept object
# initialization, adding a time part to any kwarg that is for a datetime field that has
# been provided as a date.
class BaseTable:
    def __init__(self, **kwargs):
        columns = type(self).__table__.columns
        for k in kwargs:
            if k not in columns:
                continue
            if not isinstance(columns[k].type, DateTime):
                continue
            if re.match(r"\d\d\d\d-\d\d-\d\d$", kwargs[k]):
                kwargs[k] += " 12:00:00"
        super().__init__(**kwargs)


Base = declarative_base(cls=BaseTable)
metadata = Base.metadata


def make_engine():
    engine = mssql_sqlalchemy_engine_from_url(
        os.environ["EMIS_DATASOURCE_DATABASE_URL"]
    )
    timeout = float(os.environ.get("CONNECTION_RETRY_TIMEOUT", "60"))
    wait_for_mssql_to_be_ready(engine, timeout)
    wait_for_trino_to_be_ready(
        os.environ["EMIS_DATABASE_URL"],
        # Trino will show active nodes in its `system.runtime.nodes` table but
        # then throw a "no nodes available" error if you try to execute a query
        # which needs to touch the MSSQL instance. So to properly confirm that
        # Trino is ready we need a query which forces it to connect to MSSQL,
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


def clear_database():
    Base.metadata.drop_all(make_engine())


class Patient(Base):
    __tablename__ = PATIENT_TABLE

    registration_id = Column(Integer, primary_key=True)
    nhs_no = Column(String(128), unique=True)
    hashed_organisation = Column(String)
    date_of_birth = Column(Date)
    date_of_death = Column(Date)
    gender = Column(Integer)
    registered_date = Column(Date)
    registration_end_date = Column(Date)
    rural_urban = Column(Integer)
    imd_rank = Column(Integer)
    msoa = Column(String)
    stp_code = Column(String)
    stp_name = Column(String)
    english_region_code = Column(String)
    english_region_name = Column(String)

    immunisations = relationship(
        "Immunisation", back_populates="patient", cascade="all, delete, delete-orphan"
    )
    medications = relationship(
        "Medication", back_populates="patient", cascade="all, delete, delete-orphan"
    )
    observations = relationship(
        "Observation", back_populates="patient", cascade="all, delete, delete-orphan"
    )
    ICNARC = relationship(
        "ICNARC", back_populates="patient", cascade="all, delete, delete-orphan"
    )
    ONSDeath = relationship(
        "ONSDeaths", back_populates="patient", cascade="all, delete, delete-orphan"
    )
    CPNS = relationship(
        "CPNS", back_populates="patient", cascade="all, delete, delete-orphan"
    )

    def __init__(self, *args, **kwargs):
        if "nhs_no" not in kwargs:
            kwargs["nhs_no"] = uuid.uuid4().hex
        super().__init__(*args, **kwargs)


class Immunisation(Base):
    __tablename__ = IMMUNISATIONS_TABLE

    id = Column(Integer, primary_key=True)
    registration_id = Column(Integer, ForeignKey(f"{PATIENT_TABLE}.registration_id"))
    hashed_organisation = Column(String)
    patient = relationship("Patient", back_populates="immunisations")
    snomed_concept_id = Column(BigInteger)
    effective_date = Column(DateTime)


class Medication(Base):
    __tablename__ = MEDICATION_TABLE

    id = Column(Integer, primary_key=True)
    registration_id = Column(Integer, ForeignKey(f"{PATIENT_TABLE}.registration_id"))
    hashed_organisation = Column(String)
    patient = relationship("Patient", back_populates="medications")
    snomed_concept_id = Column(BigInteger)
    effective_date = Column(DateTime)


class Observation(Base):
    __tablename__ = OBSERVATION_TABLE

    id = Column(Integer, primary_key=True)
    registration_id = Column(Integer, ForeignKey(f"{PATIENT_TABLE}.registration_id"))
    hashed_organisation = Column(String)
    patient = relationship("Patient", back_populates="observations")
    snomed_concept_id = Column(BigInteger)
    value_pq_1 = Column(Float, nullable=True)
    effective_date = Column(DateTime)


class ICNARC(Base):
    __tablename__ = ICNARC_TABLE

    icnarc_id = Column(Integer, primary_key=True)
    registration_id = Column(Integer, ForeignKey(f"{PATIENT_TABLE}.registration_id"))
    hashed_organisation = Column(String)
    patient = relationship("Patient", back_populates="ICNARC")
    icuadmissiondatetime = Column(DateTime)
    originalicuadmissiondate = Column(Date)
    basicdays_respiratorysupport = Column(Integer)
    advanceddays_respiratorysupport = Column(Integer)
    ventilator = Column(Integer)


class ONSDeaths(Base):
    __tablename__ = ONS_TABLE

    # This column isn't in the actual database but SQLAlchemy gets a bit upset
    # if we don't give it a primary key
    id = Column(Integer, primary_key=True)
    pseudonhsnumber = Column(String(128), ForeignKey(f"{PATIENT_TABLE}.nhs_no"))
    hashed_organisation = Column(String)
    patient = relationship("Patient", back_populates="ONSDeath")
    sex = Column(String)
    ageinyrs = Column(Integer)
    reg_stat_dod = Column(Integer)
    icd10u = Column(String)
    icd10001 = Column(String)
    icd10002 = Column(String)
    icd10003 = Column(String)
    icd10004 = Column(String)
    icd10005 = Column(String)
    icd10006 = Column(String)
    icd10007 = Column(String)
    icd10008 = Column(String)
    icd10009 = Column(String)
    icd10010 = Column(String)
    icd10011 = Column(String)
    icd10012 = Column(String)
    icd10013 = Column(String)
    icd10014 = Column(String)
    icd10015 = Column(String)
    upload_date = Column(String)  # dd/mm/yyyy


class CPNS(Base):
    __tablename__ = CPNS_TABLE

    registration_id = Column(Integer, ForeignKey(f"{PATIENT_TABLE}.registration_id"))
    hashed_organisation = Column(String)
    patient = relationship("Patient", back_populates="CPNS")
    id = Column(Integer, primary_key=True)
    # locationofdeath                                                 ITU
    # sex                                                               M
    # dateofadmission                                          2020-04-02
    # dateofswabbed                                            2020-04-02
    # dateofresult                                             2020-04-03
    # relativesaware                                                    Y
    # travelhistory                                                 False
    # regioncode                                                      Y62
    # regionname                                               North West
    # organisationcode                                                ABC
    # organisationname                                Test Hospital Trust
    # organisationtypelot                                        Hospital
    # regionapproved                                                 True
    # regionalapproveddate                                     2020-04-09
    # nationalapproved                                               True
    # nationalapproveddate                                     2020-04-09
    # preexistingcondition                                          False
    # age                                                              57
    dateofdeath = Column(Date)
    # snapdate                                                 2020-04-09
    # hadlearningdisability                                            NK
    # receivedtreatmentformentalhealth                                 NK
    # der_ethnic_category_description                                None
    # der_latest_sus_attendance_date_for_ethnicity                   None
    # der_source_dataset_for_ethnicty                                None
