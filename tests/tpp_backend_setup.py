import os
import time

import sqlalchemy
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, DateTime, Float, NVARCHAR, Date, Boolean
from sqlalchemy import ForeignKey
from sqlalchemy.orm import sessionmaker
from sqlalchemy.orm import relationship

from cohortextractor.mssql_utils import mssql_sqlalchemy_engine_from_url


Base = declarative_base()


def make_engine():
    engine = mssql_sqlalchemy_engine_from_url(os.environ["TPP_DATABASE_URL"])
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
    return engine


def make_session():
    engine = make_engine()
    Session = sessionmaker()
    Session.configure(bind=engine)
    session = Session()
    return session


def make_database():
    Base.metadata.create_all(make_engine())


class MedicationIssue(Base):
    __tablename__ = "MedicationIssue"

    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship("Patient", back_populates="MedicationIssues")
    Consultation_ID = Column(Integer)
    MedicationIssue_ID = Column(Integer, primary_key=True)
    RepeatMedication_ID = Column(Integer)
    MultilexDrug_ID = Column(
        NVARCHAR(length=20), ForeignKey("MedicationDictionary.MultilexDrug_ID")
    )
    MedicationDictionary = relationship(
        "MedicationDictionary", back_populates="MedicationIssues", cascade="all, delete"
    )
    Dose = Column(String)
    Quantity = Column(String)
    StartDate = Column(DateTime)
    EndDate = Column(DateTime)
    MedicationStatus = Column(String)
    ConsultationDate = Column(DateTime)


class MedicationDictionary(Base):
    __tablename__ = "MedicationDictionary"

    MultilexDrug_ID = Column(NVARCHAR(length=20), primary_key=True)
    MedicationIssues = relationship(
        "MedicationIssue", back_populates="MedicationDictionary"
    )
    ProductId = Column(String)
    FullName = Column(String)
    RootName = Column(String)
    PackDescription = Column(String)
    Form = Column(String)
    Strength = Column(String)
    CompanyName = Column(String)
    DMD_ID = Column(String(collation="Latin1_General_CI_AS"))


class CodedEvent(Base):
    __tablename__ = "CodedEvent"

    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="CodedEvents", cascade="all, delete"
    )
    CodedEvent_ID = Column(Integer, primary_key=True)
    CTV3Code = Column(String(collation="Latin1_General_BIN"))
    NumericValue = Column(Float)
    ConsultationDate = Column(DateTime)
    SnomedConceptId = Column(String)


class Appointment(Base):
    __tablename__ = "Appointment"

    Appointment_ID = Column(Integer, primary_key=True)
    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="Appointments", cascade="all, delete"
    )
    Organisation_ID = Column(Integer, ForeignKey("Organisation.Organisation_ID"))
    Organisation = relationship(
        "Organisation", back_populates="Appointments", cascade="all, delete"
    )
    # The real table has various other datetime columns but we don't currently
    # use them
    SeenDate = Column(DateTime)
    Status = Column(Integer)


class Patient(Base):
    __tablename__ = "Patient"

    Patient_ID = Column(Integer, primary_key=True)
    DateOfBirth = Column(Date)
    DateOfDeath = Column(Date)

    Appointments = relationship(
        "Appointment", back_populates="Patient", cascade="all, delete, delete-orphan",
    )
    MedicationIssues = relationship(
        "MedicationIssue",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    CodedEvents = relationship(
        "CodedEvent", back_populates="Patient", cascade="all, delete, delete-orphan"
    )
    ICNARC = relationship(
        "ICNARC", back_populates="Patient", cascade="all, delete, delete-orphan"
    )
    ONSDeath = relationship(
        "ONSDeaths", back_populates="Patient", cascade="all, delete, delete-orphan"
    )
    CPNS = relationship(
        "CPNS", back_populates="Patient", cascade="all, delete, delete-orphan"
    )
    RegistrationHistory = relationship(
        "RegistrationHistory",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    Addresses = relationship(
        "PatientAddress", back_populates="Patient", cascade="all, delete, delete-orphan"
    )
    Vaccinations = relationship(
        "Vaccination", back_populates="Patient", cascade="all, delete, delete-orphan"
    )
    SGSS_Positives = relationship(
        "SGSS_Positive", back_populates="Patient", cascade="all, delete, delete-orphan"
    )
    SGSS_Negatives = relationship(
        "SGSS_Negative", back_populates="Patient", cascade="all, delete, delete-orphan"
    )
    Sex = Column(String)
    HouseholdMemberships = relationship(
        "HouseholdMember",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    ECEpisodes = relationship(
        "ECDS", back_populates="Patient", cascade="all, delete, delete-orphan",
    )
    ECDiagnoses = relationship(
        "ECDS_EC_Diagnoses",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    APCSEpisodes = relationship(
        "APCS", back_populates="Patient", cascade="all, delete, delete-orphan",
    )
    APCS_DerEpisodes = relationship(
        "APCS_Der", back_populates="Patient", cascade="all, delete, delete-orphan",
    )


class RegistrationHistory(Base):
    __tablename__ = "RegistrationHistory"

    Registration_ID = Column(Integer, primary_key=True)
    Organisation_ID = Column(Integer, ForeignKey("Organisation.Organisation_ID"))
    Organisation = relationship(
        "Organisation", back_populates="RegistrationHistory", cascade="all, delete"
    )
    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="RegistrationHistory", cascade="all, delete"
    )
    StartDate = Column(Date)
    EndDate = Column(Date)


class Organisation(Base):
    __tablename__ = "Organisation"

    Organisation_ID = Column(Integer, primary_key=True)
    GoLiveDate = Column(Date)
    STPCode = Column(String)
    MSOACode = Column(String)
    RegistrationHistory = relationship(
        "RegistrationHistory",
        back_populates="Organisation",
        cascade="all, delete, delete-orphan",
    )
    Region = Column(String)
    Appointments = relationship(
        "Appointment",
        back_populates="Organisation",
        cascade="all, delete, delete-orphan",
    )


class PatientAddress(Base):
    __tablename__ = "PatientAddress"

    PatientAddress_ID = Column(Integer, primary_key=True)
    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship("Patient", back_populates="Addresses", cascade="all, delete")
    StartDate = Column(Date)
    EndDate = Column(Date)
    AddressType = Column(Integer)
    RuralUrbanClassificationCode = Column(Integer)
    ImdRankRounded = Column(Integer)
    MSOACode = Column(String)
    PotentialCareHomeAddress = relationship(
        "PotentialCareHomeAddress",
        back_populates="PatientAddress",
        cascade="all, delete, delete-orphan",
    )


class ICNARC(Base):
    __tablename__ = "ICNARC"

    ICNARC_ID = Column(Integer, primary_key=True)
    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship("Patient", back_populates="ICNARC", cascade="all, delete")
    IcuAdmissionDateTime = Column(DateTime)
    OriginalIcuAdmissionDate = Column(Date)
    BasicDays_RespiratorySupport = Column(Integer)
    AdvancedDays_RespiratorySupport = Column(Integer)
    Ventilator = Column(Integer)


class ONSDeaths(Base):
    __tablename__ = "ONS_Deaths"

    # This column isn't in the actual database but SQLAlchemy gets a bit upset
    # if we don't give it a primary key
    id = Column(Integer, primary_key=True)
    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship("Patient", back_populates="ONSDeath", cascade="all, delete")
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


class CPNS(Base):
    __tablename__ = "CPNS"

    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship("Patient", back_populates="CPNS", cascade="all, delete")
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


class Vaccination(Base):
    __tablename__ = "Vaccination"
    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="Vaccinations", cascade="all, delete"
    )
    Vaccination_ID = Column(Integer, primary_key=True)
    VaccinationDate = Column(DateTime)
    VaccinationName = Column(String)
    # We can't make this a foreign key because the corresponding column isn't
    # unique.  Effectively, there's an implied but not existing VaccinationName
    # table which has a many-one relation with Vaccination and a one-many
    # relation with VaccinationReference.
    VaccinationName_ID = Column(Integer)
    VaccinationSchedulePart = Column(Integer)


class VaccinationReference(Base):
    __tablename__ = "VaccinationReference"

    # This column isn't in the actual database but SQLAlchemy gets a bit upset
    # if we don't give it a primary key
    id = Column(Integer, primary_key=True)
    # Note this is *not* unique because a single named vaccine product can
    # target multiple diseases and therefore have multiple "contents"
    VaccinationName_ID = Column(Integer)
    VaccinationName = Column(String)
    VaccinationContent = Column(String)


class SGSS_Negative(Base):
    __tablename__ = "SGSS_Negative"

    # This column isn't in the actual database but SQLAlchemy gets a bit upset
    # if we don't give it a primary key
    id = Column(Integer, primary_key=True)
    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="SGSS_Negatives", cascade="all, delete"
    )
    Organism_Species_Name = Column(String, default="NEGATIVE SARS-CoV-2 (COVID-19)")
    Earliest_Specimen_Date = Column(Date)
    Lab_Report_Date = Column(Date)
    # Other columns in the table which we don't use:
    #   PHE_ID
    #   Age_in_Years
    #   Patient_Sex
    #   County_Description
    #   PostCode_Source


class SGSS_Positive(Base):
    __tablename__ = "SGSS_Positive"

    # This column isn't in the actual database but SQLAlchemy gets a bit upset
    # if we don't give it a primary key
    id = Column(Integer, primary_key=True)
    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="SGSS_Positives", cascade="all, delete"
    )
    Organism_Species_Name = Column(String, default="SARS-CoV-2 CORONAVIRUS (Covid-19)")
    Earliest_Specimen_Date = Column(Date)
    Lab_Report_Date = Column(Date)
    # Other columns in the table which we don't use:
    #   PHE_ID
    #   Age_in_Years
    #   Patient_Sex
    #   County_Description
    #   PostCode_Source


class PotentialCareHomeAddress(Base):
    __tablename__ = "PotentialCareHomeAddress"

    # This column isn't in the actual database but SQLAlchemy gets a bit upset
    # if we don't give it a primary key
    id = Column(Integer, primary_key=True)

    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    PatientAddress_ID = Column(Integer, ForeignKey("PatientAddress.PatientAddress_ID"))
    PatientAddress = relationship(
        "PatientAddress",
        back_populates="PotentialCareHomeAddress",
        cascade="all, delete",
    )
    # Conceptually these two are a single boolean column but they stored as
    # separate string columns containing either a Y or an N as this directly
    # reflects what's in the underlying data source
    LocationRequiresNursing = Column(String)
    LocationDoesNotRequireNursing = Column(String)


class Household(Base):
    __tablename__ = "Household"
    Household_ID = Column(Integer, primary_key=True)
    # Flag to indicate an entry of No Fixed Abode or Unknown
    NFA_Unknown = Column(Boolean, default=False)
    # CareHome (boolean) - not currently being used
    HouseholdSize = Column(Integer)
    HouseholdMembers = relationship(
        "HouseholdMember", back_populates="Household", cascade="all, delete"
    )


class HouseholdMember(Base):
    __tablename__ = "HouseholdMember"
    HouseholdMember_ID = Column(Integer, primary_key=True)
    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="HouseholdMemberships", cascade="all, delete"
    )
    Household_ID = Column(Integer, ForeignKey("Household.Household_ID"))
    Household = relationship(
        "Household", back_populates="HouseholdMembers", cascade="all, delete"
    )


class ECDS(Base):
    __tablename__ = "ECDS"
    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="ECEpisodes", cascade="all, delete"
    )
    EC_Ident = Column(Integer, primary_key=True)
    Arrival_Date = Column(Date)
    Discharge_Destination_SNOMED_CT = Column(String(collation="Latin1_General_CI_AS"))
    Diagnoses = relationship(
        "ECDS_EC_Diagnoses", back_populates="ECDS", cascade="all, delete, delete-orphan"
    )


class ECDS_EC_Diagnoses(Base):
    __tablename__ = "ECDS_EC_Diagnoses"

    # This column isn't in the actual database but SQLAlchemy gets a bit upset
    # if we don't give it a primary key
    id = Column(Integer, primary_key=True)

    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="ECDiagnoses", cascade="all, delete"
    )
    EC_Ident = Column(Integer, ForeignKey("ECDS.EC_Ident"))
    ECDS = relationship("ECDS", back_populates="Diagnoses", cascade="all, delete")
    Ordinal = Column(Integer)
    DiagnosisCode = Column(String(collation="Latin1_General_CI_AS"))


class APCS(Base):
    __tablename__ = "APCS"
    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="APCSEpisodes", cascade="all, delete"
    )
    APCS_Ident = Column(Integer, primary_key=True)
    APCS_Der = relationship("APCS_Der", uselist=False, back_populates="APCS")
    Admission_Date = Column(Date)
    Discharge_Date = Column(Date)
    Der_Diagnosis_All = Column(String)
    Der_Procedure_All = Column(String)


class APCS_Der(Base):
    __tablename__ = "APCS_Der"
    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="APCS_DerEpisodes", cascade="all, delete"
    )
    APCS_Ident = Column(Integer, ForeignKey("APCS.APCS_Ident"), primary_key=True)
    APCS = relationship("APCS", back_populates="APCS_Der")
    Spell_Primary_Diagnosis = Column(String)
    Spell_Secondary_Diagnosis = Column(String)
