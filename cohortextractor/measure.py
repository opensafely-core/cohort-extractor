import numpy

SMALL_NUMBER_THRESHOLD = 5


class Measure:

    POPULATION_COLUMN = "population"

    def __init__(
        self, id, denominator, numerator, group_by=None, small_number_suppression=False
    ):
        """
        Creates a "measure" using data extracted by the StudyDefinition defined
        in the same file.

        Args:
            id: A string used for the output filename (which will be
                `measure_<id>.csv`).  Only alphanumeric and underscore characters
                allowed.
            denominator: A column name from the study definition, or the
                special name "population". Columns must be numeric or boolean.
                For boolean columns the value of the denominator will be the
                number of patients with the value "true". Using the
                "population" denominator will give you the total number of
                patients in the cohort.
            numerator: A column name from the study definition. This must be
                numeric or boolean. For boolean columns the value of the numerator
                will be the number of patients with the value "true".
            group_by: A column name, or a list of column names, from the study
                definition to group results by. Use the special column
                "population" to treat the entire population as a single group.
                Set group_by to None (or omit it entirely) to perform no
                grouping and leave the data at individual patient level.
            small_number_suppression: A boolean to enable or disable
                suppression of small numbers. If enabled, numerator
                and denominator values less than or equal to 5 will be
                suppressed to `numpy.nan` to avoid re-identification. Larger
                numbers also suppressed to bring the total suppressed above
                5. Defaults to `False`.

        Returns:
            Measure instance

        """
        self.id = id
        self.denominator = denominator
        self.numerator = numerator
        if group_by is None:
            self.group_by = []
        elif not isinstance(group_by, (list, tuple)):
            self.group_by = [group_by]
        else:
            self.group_by = group_by
        self.small_number_suppression = small_number_suppression
        # In general we can't handle the case where a numerator or denominator
        # column also appears in the group_by. While you can imagine some weird
        # use cases, this is almost never going to be what you want and it's
        # not worth the extra complexity in trying to support it. The one
        # exception to this is the "population" column (which we already handle
        # as a special case elsewhere). Grouping by the population column just
        # means: sum everthing together as one big group.
        if self.group_by != [self.POPULATION_COLUMN]:
            bad_attr = None
            if self.numerator in self.group_by:
                bad_attr = "numerator"
            if self.denominator in self.group_by:
                bad_attr = "denominator"
            if bad_attr:
                raise ValueError(
                    f"Column '{getattr(self, bad_attr)}' appears in both {bad_attr}"
                    f" and group_by"
                )

    def calculate(self, data, reporter):
        """
        Calculates this measure on the provided patient dataset.

        Args:
            data: a Pandas DataFrame
        """
        result = self._select_columns(data)
        result = self._group_rows(result)
        self._suppress_small_numbers(result, reporter)
        self._calculate_results(result)

        return result

    def _select_columns(self, data):
        columns = _drop_duplicates([self.numerator, self.denominator, *self.group_by])

        # Ensure we're working on a copy rather than a view so that
        # modifications we make (for example low number suppression)
        # can't be reflected in the underlying data.
        return data[columns].copy()

    def _group_rows(self, data):
        if not self.group_by:
            return data
        elif self.group_by == [self.POPULATION_COLUMN]:
            # Group by a function which assigns all rows to the same group
            return data.groupby(lambda _: 0).sum()
        else:
            return data.groupby(self.group_by).sum().reset_index()

    def _suppress_small_numbers(self, data, reporter):
        if self.small_number_suppression:
            self._suppress_column(self.numerator, data, reporter)
            self._suppress_column(self.denominator, data, reporter)

    def _suppress_column(self, column, data, reporter):
        small_value_filter = (data[column] > 0) & (
            data[column] <= SMALL_NUMBER_THRESHOLD
        )
        large_value_filter = data[column] > SMALL_NUMBER_THRESHOLD

        num_small_values = data.loc[small_value_filter, column].count()
        num_large_values = data.loc[large_value_filter, column].count()
        if num_small_values == 0:
            return

        small_value_total = data.loc[small_value_filter, column].sum()
        data.loc[small_value_filter, column] = numpy.nan
        reporter(f"Suppressed small numbers in column {column} in measure {self.id}")

        if small_value_total > SMALL_NUMBER_THRESHOLD:
            return
        if num_large_values == 0:
            return

        # If the total suppressed is small then reidentification may
        # be possible by comparing the total of the unsuppressed
        # values with the population. So we suppress further values to
        # take the total over the threshold. If there are multiple
        # rows with the next smallest value, it may be possible to
        # change the query to reorder the rows and thus reveal their
        # values; so we suppress all of them.
        next_smallest_value = data.loc[large_value_filter, column].min()
        all_next_smallest = data[column] == next_smallest_value
        data.loc[all_next_smallest, column] = numpy.nan
        reporter(f"Additional suppression in column {column} in measure {self.id}")

    def _calculate_results(self, data):
        data["value"] = data[self.numerator] / data[self.denominator]


def _drop_duplicates(lst):
    """
    Preserves the order of the list.
    """
    return list(dict.fromkeys(lst).keys())
