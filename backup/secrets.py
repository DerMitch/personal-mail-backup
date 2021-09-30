
def readfile(filename):
    """
    Read a file and return it's contents (without newlines or other whitespace).
    """
    with open(filename) as f:
        return f.read().strip()
