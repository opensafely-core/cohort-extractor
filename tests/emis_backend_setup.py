from sqlalchemy import Column, Date, Integer
from sqlalchemy.engine import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker


Base = declarative_base()


def make_engine():
    engine = create_engine(
        "presto://localhost:8080/memory/test", connect_args={"poll_interval": 0.01}
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


class Patient(Base):
    __tablename__ = "patient"

    id = Column(Integer, primary_key=True)
    # TODO: this should be called date-of-birth
    date_of_birth = Column(Date)
