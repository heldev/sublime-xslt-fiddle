from sublime import Region

XSLT_GROUP = 0
INPUT_GROUP = 1
OUTPUT_GROUP = 2


def max_region(view):
	return Region(0, view.size())
