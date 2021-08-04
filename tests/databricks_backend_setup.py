import os

from sqlalchemy import Column, Date, DateTime, Float, ForeignKey, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker

from cohortextractor.mssql_utils import (
    mssql_sqlalchemy_engine_from_url,
    wait_for_mssql_to_be_ready,
)

Base = declarative_base()


def make_engine():
    engine = mssql_sqlalchemy_engine_from_url(os.environ["TPP_DATABASE_URL"])
    timeout = float(os.environ.get("CONNECTION_RETRY_TIMEOUT", "60"))
    wait_for_mssql_to_be_ready(engine, timeout)
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


def build_coded_event_table(year):
    columns = {
        "__tablename__": f"CodedEvent_{year}",
        "Patient_ID": Column(Integer, ForeignKey("Patient.Patient_ID")),
        "Patient": relationship(
            "Patient", back_populates=f"CodedEvents{year}", cascade="all, delete"
        ),
        "CodedEvent_ID": Column(Integer, primary_key=True),
        "CTV3Code": Column(String(collation="Latin1_General_BIN")),
        "NumericValue": Column(Float),
        "ConsultationDate": Column(DateTime),
        "SnomedConceptId": Column(String),
    }
    return type(f"CodedEvent{year}", (Base,), columns)


CodedEvent2018 = build_coded_event_table(2018)
CodedEvent2019 = build_coded_event_table(2019)
CodedEvent2020 = build_coded_event_table(2020)


class Patient(Base):
    __tablename__ = "Patient"

    Patient_ID = Column(Integer, primary_key=True)
    DateOfBirth = Column(Date)
    DateOfDeath = Column(Date)
    Sex = Column(String)

    CodedEvents2018 = relationship(
        "CodedEvent2018", back_populates="Patient", cascade="all, delete, delete-orphan"
    )
    CodedEvents2019 = relationship(
        "CodedEvent2019", back_populates="Patient", cascade="all, delete, delete-orphan"
    )
    CodedEvents2020 = relationship(
        "CodedEvent2020", back_populates="Patient", cascade="all, delete, delete-orphan"
    )
