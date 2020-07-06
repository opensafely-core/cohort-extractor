"""
The ACME data is accessed via Presto which is a distributed query engine which
runs over multiple backing data stores ("connectors" in Presto's parlance).
The production configuration uses the following connectors:

    hive for views
    delta-lake for underlying data
    mysql for config/metadata

For immediate convenience while testing we use the SQL Server connector (as we
already need an instance running for the TPP tests).

This file defines the structure of the tables we expect to find in the ACME
backend.  Because ACME tables have hyphens in their fieldnames, we cannot use
SQLAlchemy's declarative mappings, and instead have to define tables and models
separately.
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
        os.environ["ACME_DATASOURCE_DATABASE_URL"]
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
        os.environ["ACME_DATABASE_URL"],
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


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Table definitions
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

medication = Table(
    "medication",
    metadata,
    Column("id", Integer, primary_key=True),
    Column("registration-id", Integer, ForeignKey("patient.id")),
    Column("snomed-concept-id", BigInteger),
    Column("effective-date", DateTime),
)

observation = Table(
    "observation",
    metadata,
    Column("id", Integer, primary_key=True),
    Column("registration-id", Integer, ForeignKey("patient.id")),
    Column("snomed-concept-id", BigInteger),
    Column("value-pq-1", Float),
    Column("effective-date", DateTime),
)

patient = Table(
    "patient",
    metadata,
    Column("id", Integer, primary_key=True),
    Column("date-of-birth", DateTime),
    Column("gender", Integer),
    Column("registered-date", DateTime),
    Column("registration-end-date", DateTime),
)

# WARNING: This table does not correspond to a table in the ACME database!
organisation = Table(
    "Organisation",
    metadata,
    Column("Organisation_ID", Integer, primary_key=True),
    Column("GoLiveDate", Date),
    Column("STPCode", String),
    Column("MSOACode", String),
    Column("Region", String),
)

# WARNING: This table does not correspond to a table in the ACME database!
patient_address = Table(
    "PatientAddress",
    metadata,
    Column("PatientAddress_ID", Integer, primary_key=True),
    Column("registration-id", Integer, ForeignKey("patient.id")),
    Column("StartDate", Date),
    Column("EndDate", Date),
    Column("AddressType", Integer),
    Column("RuralUrbanClassificationCode", Integer),
    Column("ImdRankRounded", Integer),
    Column("MSOACode", String),
)

# WARNING: This table does not correspond to a table in the ACME database!
icnarc = Table(
    "ICNARC",
    metadata,
    Column("ICNARC_ID", Integer, primary_key=True),
    Column("registration-id", Integer, ForeignKey("patient.id")),
    Column("IcuAdmissionDateTime", DateTime),
    Column("OriginalIcuAdmissionDate", Date),
    Column("BasicDays_RespiratorySupport", Integer),
    Column("AdvancedDays_RespiratorySupport", Integer),
    Column("Ventilator", Integer),
)

# WARNING: This table does not correspond to a table in the ACME database!
ons_deaths = Table(
    "ONS_Deaths",
    metadata,
    # This column isn't in the actual database but SQLAlchemy gets a bit upset
    # if we don't give it a primary key
    Column("id", Integer, primary_key=True),
    Column("registration-id", Integer, ForeignKey("patient.id")),
    Column("Sex", String),
    Column("ageinyrs", Integer),
    Column("dod", Date),
    Column("icd10u", String),
    Column("ICD10001", String),
    Column("ICD10002", String),
    Column("ICD10003", String),
    Column("ICD10004", String),
    Column("ICD10005", String),
    Column("ICD10006", String),
    Column("ICD10007", String),
    Column("ICD10008", String),
    Column("ICD10009", String),
    Column("ICD10010", String),
    Column("ICD10011", String),
    Column("ICD10012", String),
    Column("ICD10013", String),
    Column("ICD10014", String),
    Column("ICD10015", String),
)

# WARNING: This table does not correspond to a table in the ACME database!
cpns = Table(
    "CPNS",
    metadata,
    Column("registration-id", Integer, ForeignKey("patient.id")),
    Column("Id", Integer, primary_key=True),
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
    Column("DateOfDeath", Date),
    # snapDate                                                 2020-04-09
    # HadLearningDisability                                            NK
    # ReceivedTreatmentForMentalHealth                                 NK
    # Der_Ethnic_Category_Description                                None
    # Der_Latest_SUS_Attendance_Date_For_Ethnicity                   None
    # Der_Source_Dataset_For_Ethnicty                                None
)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Model definitions
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


class Model:
    """Base class for a model."""

    def __init__(self, **kwargs):
        for k, v in kwargs.items():
            if k in [
                "date_of_birth",
                "effective_date",
                "registered_date",
                "registration_end_date",
                "snomed_concept_id",
                "value_pq_1",
            ]:
                k = k.replace("_", "-")
            setattr(self, k, v)


class Medication(Model):
    pass


class Observation(Model):
    pass


class Patient(Model):
    pass


class Organisation(Model):
    pass


class PatientAddress(Model):
    pass


class ICNARC(Model):
    pass


class ONSDeaths(Model):
    pass


class CPNS(Model):
    pass


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Definitions of mappings between models and tables
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

mapper(
    Medication,
    medication,
    properties={"patient": relationship(Patient, back_populates="medications"),},
)

mapper(
    Observation,
    observation,
    properties={"patient": relationship(Patient, back_populates="observations"),},
)

mapper(
    Patient,
    patient,
    properties={
        "medications": relationship(
            Medication, back_populates="patient", cascade="all, delete, delete-orphan",
        ),
        "observations": relationship(
            Observation, back_populates="patient", cascade="all, delete, delete-orphan"
        ),
        #
        # We won't create mappings for these tables until we know what fields
        # they will have in the ACME backend.
        #
        # "Addresses": relationship(
        #     PatientAddress,
        #     back_populates="patient",
        #     cascade="all, delete, delete-orphan",
        # ),
        # "ICNARC": relationship(
        #     ICNARC, back_populates="patient", cascade="all, delete, delete-orphan"
        # ),
        # "ONSDeath": relationship(
        #     ONSDeaths, back_populates="patient", cascade="all, delete, delete-orphan"
        # ),
        # "CPNS": relationship(
        #     CPNS, back_populates="patient", cascade="all, delete, delete-orphan"
        # ),
    },
)

# We won't create mappings for these tables until we know what fields they will
# have in the ACME backend.

# mapper(
#     Organisation,
#     organisation,
# )

# mapper(
#     PatientAddress,
#     patient_address,
#     properties={
#         "patient": relationship(
#             Patient, back_populates="Addresses", cascade="all, delete"
#         )
#     },
# )

# mapper(
#     ICNARC,
#     icnarc,
#     properties={
#         "patient": relationship(Patient, back_populates="ICNARC", cascade="all, delete")
#     },
# )

# mapper(
#     ONSDeaths,
#     ons_deaths,
#     properties={
#         "patient": relationship(
#             Patient, back_populates="ONSDeath", cascade="all, delete"
#         )
#     },
# )

# mapper(
#     CPNS,
#     cpns,
#     properties={
#         "patient": relationship(Patient, back_populates="CPNS", cascade="all, delete")
#     },
# )
