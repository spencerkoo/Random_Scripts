#function that gets the sum of all the values in the indices before it
#takes in array A and index i
def sum_prior(A, i):
    total = 0
    for x in xrange(0, i):
        total = total + A[x]
    return total

#function that gets the sum of all the values in the indices after it
#takes in array A and index i
def sum_post(A, i):
    total = 0
    for x in xrange(i+1, len(A)):
        total = total + A[x]
    return total

#function that takes in an array and finds the indices where the sum of the ints in the array on either side
#of the index are equal
def equil_index(A):
    #first check if list is empty
    if not A:
        return -1
    #end cases where the sum is 0
    if sum(A)-A[0] == 0:
        return 0
    if sum(A)-A[len(A)-1] == 0:
        return len(A)-1
    
    #cases inside of the end cases
    for i in xrange(1, len(A)-1):
        if sum_prior(A, i) == sum_post(A, i):
            return i
    #if not equilibrium exists
    return -1
