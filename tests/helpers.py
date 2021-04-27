def assert_results(results, **expected_values):
    for col_name, expected_col_values in expected_values.items():
        col_values = [row[col_name] for row in results]
        assert col_values == expected_col_values, f"Unexpected results for {col_name}"


class RecordingReporter:
    def __init__(self):
        self.msg = ""

    def __call__(self, msg):
        self.msg = msg


def null_reporter(msg):
    pass
