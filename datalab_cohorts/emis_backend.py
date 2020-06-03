from .presto_utils import presto_connection_from_url


class EMISBackend:
    _db_connection = None

    def __init__(self, database_url, covariate_definitions):
        self.database_url = database_url
        self.covariate_definitions = covariate_definitions

    def to_csv(self, filename):
        raise NotImplementedError()

    def to_dicts(self):
        raise NotImplementedError()

    def to_sql(self):
        raise NotImplementedError()

    def get_db_connection(self):
        if self._db_connection:
            return self._db_connection
        self._db_connection = presto_connection_from_url(self.database_url)
        return self._db_connection
