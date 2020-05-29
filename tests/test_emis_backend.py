import prestodb

# import csv
# import tempfile

# from datalab_cohorts import StudyDefinition, patients
# from tests.emis_backend_setup import Patient, make_database, make_session


def test_can_connect_to_presto():
    connection_params = {
        "host": "localhost",
        "user": "thisdoesnotmatter",
        "catalog": "memory",
    }

    with prestodb.dbapi.connect(**connection_params) as conn:
        cursor = conn.cursor()

        cursor.execute("CREATE SCHEMA test")
        results = cursor.fetchall()


    connection_params["schema"] = "test"

    with prestodb.dbapi.connect(**connection_params) as conn:
        cursor = conn.cursor()
        cursor.execute("CREATE TABLE t (a bigint)")
        results = cursor.fetchall()

        cursor.execute("INSERT INTO t VALUES (1)")
        results = cursor.fetchall()

        cursor.execute("SELECT COUNT(*) FROM test.t")
        results = cursor.fetchall()
        
        assert results == [[1]]


# def setup_module(module):
#     make_database()


# def setup_function(function):
#     session = make_session()
#     session.query(Patient).delete()


# def test_minimal_study_to_csv():
#     session = make_session()
#     patient_1 = Patient(DateOfBirth="1900-01-01", Sex="M")
#     patient_2 = Patient(DateOfBirth="1900-01-01", Sex="F")
#     session.add_all([patient_1, patient_2])
#     session.commit()
#     study = StudyDefinition(population=patients.all(), sex=patients.sex())
#     with tempfile.NamedTemporaryFile(mode="w+") as f:
#         study.to_csv(f.name)
#         results = list(csv.DictReader(f))
#         assert results == [
#             {"patient_id": str(patient_1.Patient_ID), "sex": "M"},
#             {"patient_id": str(patient_2.Patient_ID), "sex": "F"},
#         ]
