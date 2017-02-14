# This script finds if the an array has an equilibrium index and returns the first one it finds.
# An equilibrium index is the index where the sum of all values in the indices before the
# "equilibrium" index equals the sum of all the values after that index. The "equilibrium" index
# does not count in the sums.
#
# For example:
# array = [0, 1, 2, 5, 3]
# In array, index 3 is an equilibrium index b/c the sum of the values before index 3 is 3,
# and the sum of the index after is 3 as well.
#
# Note, for the first and last indices, the sum to the left/right respectively is considered 0.

# Function that takes in array A and index i and returns the sum to the left of the index
def sum_prior(A, i):
    total = 0
    for x in xrange(0, i):
        total = total + A[x]
    return total

# Function that takes in array A and index i and returns the sum to the right of the index
def sum_post(A, i):
    total = 0
    for x in xrange(i+1, len(A)):
        total = total + A[x]
    return total

# Function that takes in an array and finds the equilibrium index
def equil_index(A):
    # First check if list is empty
    if not A:
        return -1
    # End cases where the sum is 0
    if sum(A)-A[0] == 0:
        return 0
    if sum(A)-A[len(A)-1] == 0:
        return len(A)-1
    
    # Cases inside of the end cases
    for i in xrange(1, len(A)-1):
        if sum_prior(A, i) == sum_post(A, i):
            return i
    # If not equilibrium exists
    return -1
