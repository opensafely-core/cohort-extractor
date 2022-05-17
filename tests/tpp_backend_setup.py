import os
import re
from datetime import datetime

from sqlalchemy import (
    NVARCHAR,
    Boolean,
    Column,
    Date,
    DateTime,
    Float,
    ForeignKey,
    Integer,
    String,
    types,
)
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker

from cohortextractor.process_covariate_definitions import (
    ISARIC_COLUMN_MAPPINGS,
    ONS_CIS_COLUMN_MAPPINGS,
)
from cohortextractor.tpp_backend import AppointmentStatus
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


# a SQLAlchemy enum that uses the int values rather than the strings
class IntEnum(types.TypeDecorator):
    impl = Integer

    def __init__(self, enumtype, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._enumtype = enumtype

    def process_bind_param(self, value, dialect):
        return value.value

    def process_result_value(self, value, dialect):
        return self._enumtype(value)


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

    CodedEventRange = relationship(
        "CodedEventRange",
        back_populates="CodedEvent",
        cascade="all, delete, delete-orphan",
    )

    def __init__(self, **kwargs):
        if "ConsultationDate" in kwargs:
            if re.match(r"\d\d\d\d-\d\d-\d\d$", kwargs["ConsultationDate"]):
                kwargs["ConsultationDate"] += " 12:00:00"
        super().__init__(**kwargs)


class CodedEventSnomed(Base):
    __tablename__ = "CodedEvent_SNOMED"

    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="CodedEventsSnomed", cascade="all, delete"
    )
    CodedEvent_ID = Column(Integer, primary_key=True)
    NumericValue = Column(Float)
    ConsultationDate = Column(DateTime)
    ConceptID = Column(String(collation="Latin1_General_BIN"))
    CodingSystem = Column(Integer)


class CodedEventRange(Base):
    __tablename__ = "CodedEventRange"

    CodedEventRange_ID = Column(Integer, primary_key=True)

    CodedEvent_ID = Column(Integer, ForeignKey(CodedEvent.CodedEvent_ID))
    CodedEvent = relationship(
        "CodedEvent", back_populates="CodedEventRange", cascade="all, delete"
    )
    # These bounds give the "reference range" for the test result in question
    # Uses `-1` as a placeholder for NULL
    LowerBound = Column(Float)
    # Uses `-1` as a placeholder for NULL
    UpperBound = Column(Float)
    # Takes the following values:
    # | Value | Meaning |
    # |-------|---------|
    # | 3     | ~       |
    # | 4     | =       |
    # | 5     | >=      |
    # | 6     | >       |
    # | 7     | <       |
    # | 8     | <=      |
    Comparator = Column(Integer)


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
    Status = Column(IntEnum(AppointmentStatus))


class Patient(Base):
    __tablename__ = "Patient"

    Patient_ID = Column(Integer, primary_key=True)
    DateOfBirth = Column(Date)
    DateOfDeath = Column(Date)

    Appointments = relationship(
        "Appointment",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    MedicationIssues = relationship(
        "MedicationIssue",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    CodedEvents = relationship(
        "CodedEvent", back_populates="Patient", cascade="all, delete, delete-orphan"
    )
    CodedEventsSnomed = relationship(
        "CodedEventSnomed",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
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
    SGSS_AllTests_Positives = relationship(
        "SGSS_AllTests_Positive",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    SGSS_AllTests_Negatives = relationship(
        "SGSS_AllTests_Negative",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    Sex = Column(String)
    HouseholdMemberships = relationship(
        "HouseholdMember",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    ECEpisodes = relationship(
        "EC",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    ECDiagnoses = relationship(
        "EC_Diagnosis",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    APCSEpisodes = relationship(
        "APCS",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    APCS_DerEpisodes = relationship(
        "APCS_Der",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    HighCostDrugs = relationship(
        "HighCostDrugs",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    OPAEpisodes = relationship(
        "OPA",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    OPA_Proc = relationship(
        "OPA_Proc",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    DecisionSupportValue = relationship(
        "DecisionSupportValue",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    HealthCareWorker = relationship(
        "HealthCareWorker",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    Therapeutics = relationship(
        "Therapeutics",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    ISARIC = relationship(
        "ISARICData",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    ONS_CIS = relationship(
        "ONS_CIS",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
    )
    UKRR = relationship(
        "UKRR",
        back_populates="Patient",
        cascade="all, delete, delete-orphan",
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
    ClusterRandomisedTrial = relationship(
        "ClusterRandomisedTrial",
        back_populates="Organisation",
    )
    ClusterRandomisedTrialDetail = relationship(
        "ClusterRandomisedTrialDetail",
        back_populates="Organisation",
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
    Place_of_occurrence = Column(String)


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
    # This column should only ever have this value
    Organism_Species_Name = Column(String, default="NEGATIVE SARS-CoV-2 (COVID-19)")
    Earliest_Specimen_Date = Column(Date)
    Lab_Report_Date = Column(Date)

    # Possible values: "OTHER", "PILLAR 2 TESTING"
    Lab_Type = Column(String)

    # Other columns in the table which we don't use:
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

    # Possible values: "OTHER", "PILLAR 2 TESTING"
    Lab_Type = Column(String)

    # SGTF: S gene target failure
    # Possible values: "", "0", "1", "9"
    # Definitions (from email from PHE)
    #
    #   1: Isolate with confirmed SGTF
    #   Undetectable S gene; CT value (CH3) =0
    #   Detectable ORF1ab gene; CT value (CH2) <=30 and >0
    #   Detectable N gene; CT value (CH1) <=30 and >0
    #
    #   0: S gene detected
    #   Detectable S gene (CH3>0)
    #   Detectable y ORF1ab CT value (CH1) <=30 and >0
    #   Detectable N gene CT value (CH2) <=30 and >0
    #
    #   9: Cannot be classified
    #
    #   Null are where the target is not S Gene. I think LFTs are currently
    #   also coming across as 9 so will need to review those to null as well as
    #   clearly this is a PCR only variable.
    SGTF = Column(String)

    # Possible values: "LFT_Only", "PCR_Only", "LFT_WithPCR"
    CaseCategory = Column(String)

    # Other columns in the table which we don't use:
    #   Age_in_Years
    #   Patient_Sex
    #   County_Description
    #   PostCode_Source


# The SGSS_(Postive|Negative) tables above contain only the first positive test
# for each patient whereas the AllTests tables below contain every positive
# test.
class SGSS_AllTests_Negative(Base):
    __tablename__ = "SGSS_AllTests_Negative"

    # This column isn't in the actual database but SQLAlchemy gets a bit upset
    # if we don't give it a primary key
    id = Column(Integer, primary_key=True)
    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="SGSS_AllTests_Negatives", cascade="all, delete"
    )
    # This column should only ever have this value
    Organism_Species_Name = Column(String, default="NEGATIVE SARS-CoV-2 (COVID-19)")
    Specimen_Date = Column(Date)
    Lab_Report_Date = Column(Date)

    # Possible values: "OTHER", "PILLAR 2 TESTING"
    Lab_Type = Column(String)

    # Possible values: NULL, "false", "true"
    Symptomatic = Column(String)

    # Possible values: "Pillar 1", "Pillar 2"
    Pillar = Column(String)

    # Possible values: NULL, "True"
    LFT_Flag = Column(String)

    # Other columns in the table which we don't use:
    #   Age_in_Years
    #   Patient_Sex
    #   County_Description
    #   PostCode_Source
    #   Ethnic_Category_Desc


class SGSS_AllTests_Positive(Base):
    __tablename__ = "SGSS_AllTests_Positive"

    # This column isn't in the actual database but SQLAlchemy gets a bit upset
    # if we don't give it a primary key
    id = Column(Integer, primary_key=True)
    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="SGSS_AllTests_Positives", cascade="all, delete"
    )
    Organism_Species_Name = Column(String, default="SARS-CoV-2 CORONAVIRUS (Covid-19)")
    Specimen_Date = Column(Date)
    Lab_Report_Date = Column(Date)

    # Possible values: "OTHER"
    Lab_Type = Column(String)

    # Possible values: "N", "U", "Y"
    Symptomatic = Column(String)

    Variant = Column(String)
    VariantDetectionMethod = Column(String)

    # These columns are entirely NULL for some reason
    Pillar = Column(String)
    LFT_Flag = Column(String)

    # See comment on SGTF column on `SGSS_Positive` above for details
    SGTF = Column(String)

    # Other columns in the table which we don't use:
    #   Age_in_Years
    #   Patient_Sex
    #   County_Description
    #   PostCode_Source
    #   Ethnic_Category_Desc


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
    Prison = Column(Boolean)
    MixedSoftwareHousehold = Column(Boolean)
    TppPercentage = Column(Integer)
    HouseholdSize = Column(Integer)
    MSOA = Column(String)
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


class EC(Base):
    __tablename__ = "EC"
    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="ECEpisodes", cascade="all, delete"
    )
    EC_Ident = Column(Integer, primary_key=True)
    Arrival_Date = Column(Date)
    Discharge_Destination_SNOMED_CT = Column(String(collation="Latin1_General_CI_AS"))
    Diagnoses = relationship(
        "EC_Diagnosis", back_populates="EC", cascade="all, delete, delete-orphan"
    )
    Ethnic_Category = Column(String)


class EC_Diagnosis(Base):
    __tablename__ = "EC_Diagnosis"

    # This column isn't in the actual database but SQLAlchemy gets a bit upset
    # if we don't give it a primary key
    id = Column(Integer, primary_key=True)

    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="ECDiagnoses", cascade="all, delete"
    )
    EC_Ident = Column(Integer, ForeignKey("EC.EC_Ident"))
    EC = relationship("EC", back_populates="Diagnoses", cascade="all, delete")
    EC_Diagnosis_01 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_02 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_03 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_04 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_05 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_06 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_07 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_08 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_09 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_10 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_11 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_12 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_13 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_14 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_15 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_16 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_17 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_18 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_19 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_20 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_21 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_22 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_23 = Column(String(collation="Latin1_General_CI_AS"))
    EC_Diagnosis_24 = Column(String(collation="Latin1_General_CI_AS"))


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
    Ethnic_Group = Column(String)
    Admission_Method = Column(String)
    Source_of_Admission = Column(String)
    Discharge_Destination = Column(String)
    Patient_Classification = Column(String)
    Der_Admit_Treatment_Function_Code = Column(String)
    Administrative_Category = Column(String)
    Duration_of_Elective_Wait = Column(String)
    Der_Spell_LoS = Column(Integer)


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
    Spell_PbR_CC_Day = Column(String)


class HighCostDrugs(Base):
    __tablename__ = "HighCostDrugs"
    # COLUMN_NAME	                    TYPE_NAME	PRECISION	LENGTH	IS_NULLABLE
    # Patient_ID	                    bigint	    19	        8	    NO
    # FinancialMonth	                varchar	    2	        2	    YES
    # FinancialYear	                    varchar	    6	        6	    YES
    # PersonAge	                        int	        10	        4	    YES
    # PersonGender	                    int	        10	        4	    YES
    # ActivityTreatmentFunctionCode	    varchar	    100	        100	    YES
    # TherapeuticIndicationCode	        varchar	    1000	    1000	YES
    # HighCostTariffExcludedDrugCode    varchar	    100	        100	    YES
    # DrugName	                        varchar	    1000	    1000	YES
    # RouteOfAdministration	            varchar	    100	        100	    YES
    # DrugStrength	                    varchar	    1000	    1000	YES
    # DrugVolume	                    varchar	    1000	    1000	YES
    # DrugPackSize	                    varchar	    1000	    1000	YES
    # DrugQuanitityOrWeightProportion	varchar	    1000	    1000	YES
    # UnitOfMeasurement	                varchar	    100	        100	    YES
    # DispensingRoute	                varchar	    100	        100	    YES
    # HomeDeliveryCharge	            varchar	    100	        100	    YES
    # TotalCost	                        varchar	    100	        100	    YES
    # DerivedSNOMEDFromName	            varchar	    1000	    1000	YES
    # DerivedVTM	                    varchar	    1000	    1000	YES
    # DerivedVTMName	                varchar	    1000	    1000	YES

    # This column isn't in the actual database but SQLAlchemy gets a bit upset
    # if we don't give it a primary key
    id = Column(Integer, primary_key=True)

    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="HighCostDrugs", cascade="all, delete"
    )
    DrugName = Column(String)
    # String like "202021" for "Year April 2020 to March 2021"
    FinancialYear = Column(String)
    # April = "1", May="2", ... March="12"
    FinancialMonth = Column(String)


class OPA(Base):
    __tablename__ = "OPA"
    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="OPAEpisodes", cascade="all, delete"
    )
    OPA_Ident = Column(Integer, primary_key=True)
    Appointment_Date = Column(Date)
    Attendance_Status = Column(String)
    Ethnic_Category = Column(String)
    First_Attendance = Column(String)
    Treatment_Function_Code = Column(String)
    Consultation_Medium_Used = Column(String)

    OPA_Proc = relationship(
        "OPA_Proc", back_populates="OPA", cascade="all, delete, delete-orphan"
    )


class OPA_Proc(Base):
    __tablename__ = "OPA_Proc"

    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship("Patient", back_populates="OPA_Proc")
    OPA_Ident = Column(Integer, ForeignKey("OPA.OPA_Ident"), primary_key=True)
    OPA = relationship(
        "OPA",
        back_populates="OPA_Proc",
        cascade="all, delete, delete-orphan",
        single_parent=True,
    )
    Primary_Procedure_Code = Column(String)


class DecisionSupportValue(Base):
    __tablename__ = "DecisionSupportValue"

    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="DecisionSupportValue", cascade="all, delete"
    )
    # This column isn't in the actual database but SQLAlchemy gets a bit upset
    # if we don't give it a primary key
    id = Column(Integer, primary_key=True)
    AlgorithmType = Column(Integer)
    CalculationDateTime = Column(DateTime)
    NumericValue = Column(Float)


class HealthCareWorker(Base):
    __tablename__ = "HealthCareWorker"

    # This column isn't in the actual database but SQLAlchemy gets a bit upset
    # if we don't give it a primary key
    id = Column(Integer, primary_key=True)
    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="HealthCareWorker", cascade="all, delete"
    )
    # Only ever contains "Y" so redundant really
    HealthCareWorker = Column(String)


class ClusterRandomisedTrial(Base):
    """Represents relationships between cluster randomised trials and organisations."""

    __tablename__ = "ClusterRandomisedTrial"

    # This table's PK is probably a composite of Organisation_ID and TrialNumber (we
    # assume that one organisation can be in one arm of one trial). However, MSSQL
    # complains when we add `primary_key=True` to two columns. To make life easier, we
    # use a column that isn't in the database.
    id = Column(Integer, primary_key=True)

    Organisation_ID = Column(Integer, ForeignKey("Organisation.Organisation_ID"))
    Organisation = relationship("Organisation", back_populates="ClusterRandomisedTrial")

    TrialNumber = Column(
        Integer, ForeignKey("ClusterRandomisedTrialReference.TrialNumber")
    )
    ClusterRandomisedTrialReference = relationship(
        "ClusterRandomisedTrialReference", back_populates="ClusterRandomisedTrial"
    )

    TrialArm = Column(String)


class ClusterRandomisedTrialDetail(Base):
    """Represents mappings of properties to values."""

    __tablename__ = "ClusterRandomisedTrialDetail"

    # This table's PK is probably a composite of Organisation_ID, TrialNumber, and
    # Property. However, MSSQL complains about Property's type. To make life easier, we
    # use a column that isn't in the database.
    id = Column(Integer, primary_key=True)

    TrialNumber = Column(
        Integer, ForeignKey("ClusterRandomisedTrialReference.TrialNumber")
    )
    ClusterRandomisedTrialReference = relationship(
        "ClusterRandomisedTrialReference", back_populates="ClusterRandomisedTrialDetail"
    )

    Organisation_ID = Column(Integer, ForeignKey("Organisation.Organisation_ID"))
    Organisation = relationship(
        "Organisation", back_populates="ClusterRandomisedTrialDetail"
    )

    Property = Column(String)
    PropertyValue = Column(String)


class ClusterRandomisedTrialReference(Base):
    """Represents cluster randomised trial entities."""

    __tablename__ = "ClusterRandomisedTrialReference"

    TrialNumber = Column(Integer, primary_key=True)
    ClusterRandomisedTrial = relationship(
        "ClusterRandomisedTrial", back_populates="ClusterRandomisedTrialReference"
    )
    ClusterRandomisedTrialDetail = relationship(
        "ClusterRandomisedTrialDetail", back_populates="ClusterRandomisedTrialReference"
    )

    TrialName = Column(String)
    TrialDescription = Column(String)
    CPMSNumber = Column(Integer)


class Therapeutics(Base):
    __tablename__ = "Therapeutics"

    # This column isn't in the actual database but SQLAlchemy gets a bit upset
    # if we don't give it a primary key
    id = Column(Integer, primary_key=True)
    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship(
        "Patient", back_populates="Therapeutics", cascade="all, delete"
    )

    # 'Casirivimab and imdevimab '[note trailing space], 'Molnupiravir', 'Remdesivir', 'sarilumab', 'Sotrovimab' , 'Tocilizumab'
    Intervention = Column(String)

    # 'hospital_onset', 'hospitalised_with', 'non_hospitalised'
    COVID_indication = Column(String)

    # 'Approved','Treatment Complete','Treatment Not Started','Treatment Stopped'
    CurrentStatus = Column(String)
    TreatmentStartDate = Column(String)
    Received = Column(String)

    # e.g. 'solid cancer', 'IMID',
    # look consistent but can be a combination of 2 or more separated with ' and ' e.g. 'renal disease and IMID'
    # sometimes also contains string "Patients with[ a]"
    MOL1_high_risk_cohort = Column(String)
    SOT02_risk_cohorts = Column(String)
    CASIM05_risk_cohort = Column(String)

    Region = Column(String)

    # Other columns in the table which we add into the temp table (for removing duplicates) but
    # don't use in queries:
    AgeAtReceivedDate = Column(String)
    FormName = Column(String)
    MOL1_onset_of_symptoms = Column(String)
    SOT02_onset_of_symptoms = Column(String)
    Count = Column(String)
    Der_LoadDate = Column(String)


class ISARICData(Base):
    __tablename__ = "ISARIC_Patient_Data_TopLine"

    # fake pk to satisfy the ORM
    id = Column(Integer, primary_key=True)

    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship("Patient", back_populates="ISARIC")


# There are lots of string columns for ISARIC, so we create the ORM columns
# dynamically
for name, type_ in ISARIC_COLUMN_MAPPINGS.items():
    setattr(ISARICData, name, Column(String))


class ONS_CIS(Base):
    __tablename__ = "ONS_CIS"

    # fake pk to satisfy the ORM
    id = Column(Integer, primary_key=True)

    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship("Patient", back_populates="ONS_CIS")


# There are lots of columns for ONS_CIS, so we create the ORM columns
# dynamically
sqlalchemy_type_conversion = {
    "int": Integer,
    "bool": Boolean,
    "float": Float,
    "str": String,
    "date": Date,
}
for name, ons_cis_type in ONS_CIS_COLUMN_MAPPINGS.items():
    setattr(ONS_CIS, name, Column(sqlalchemy_type_conversion[ons_cis_type]))


class UKRR(Base):
    __tablename__ = "UKRR"

    # fake pk to satisfy the ORM
    id = Column(Integer, primary_key=True)

    Patient_ID = Column(Integer, ForeignKey("Patient.Patient_ID"))
    Patient = relationship("Patient", back_populates="UKRR")

    dataset = Column(String)
    renal_centre = Column(String)
    rrt_start = Column(Date)
    mod_start = Column(String)
    mod_prev = Column(String)
    creat = Column(Integer)
    eGFR_ckdepi = Column(Float)


class BuildProgress(Base):
    __tablename__ = "BuildProgress"

    # fake pk to satisfy the ORM
    id = Column(Integer, primary_key=True)

    Event = Column(String)
    BuildStart = Column(DateTime, default=datetime.utcnow)
    EventStart = Column(DateTime, default=datetime.utcnow)
    EventEnd = Column(DateTime, default="9999-12-31")
    Duration = Column(Integer)
