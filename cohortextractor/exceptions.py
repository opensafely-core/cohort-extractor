class ValidationError(Exception):
    human_name = "Validation error"


class DummyDataValidationError(ValidationError):
    human_name = "Dummy data error"


class MissingParameterError(ValidationError):
    human_name = "Missing --param error"
