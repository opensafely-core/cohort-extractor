class Measure:
    def __init__(self, id, denominator, numerator, group_by=None):
        self.id = id
        self.denominator = denominator
        self.numerator = numerator
        self.group_by = group_by
