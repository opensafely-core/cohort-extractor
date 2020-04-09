# This is a pytest config file
# https://docs.pytest.org/en/2.7.3/plugins.html

# It allows us to tell nbval (the py.text plugin we use to run
# notebooks and check their output is unchanged) to skip comparing
# notebook outputs for particular mimetypes.


def pytest_collectstart(collector):
    if (
        collector.fspath
        and collector.fspath.ext == ".ipynb"
        and hasattr(collector, "skip_compare")
    ):
        # Skip plotly comparison, because something to do with
        # responsive plot sizing makes output different in test
        # environment
        collector.skip_compare += ("application/vnd.plotly.v1+json", "stderr")
