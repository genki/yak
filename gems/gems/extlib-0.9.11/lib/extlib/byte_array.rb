# This class has exists to represent binary data. This is mainly
# used by DataObjects. Binary data sometimes needs to be quoted differently
# than regular string data (even if the string is just plain ASCII).
class ByteArray < String; end
