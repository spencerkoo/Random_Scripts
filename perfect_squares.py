# This is a function that takes in two ints, puts them into a range (inclusive on both ends), and returns
# the number of perfect squares in the range.
# A perfect square is a number whose square root is a whole number. For example, 4, 9, 16, and 25 are
# perfect squares.

import math

# Function that takes in two numbers and outputs the total number of perfect squares in that inclusive range
def p_squares(A, B):
    nums = list(range(A, B+1))
    total = 0
    
    for i in range(0, len(nums)):
        if math.sqrt(nums[i]) == int(math.sqrt(nums[i])):
            total +=1
    
    return total
