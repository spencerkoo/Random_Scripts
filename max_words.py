# This script takes in a string, breaks it into sentences, then words, and returns the number of words in the
#sentence with the most number of words.

# Assumptions:
#-period demarcates an end of a sentence
#-the only punctuation are ? . and !
#-when breaking up the string by sentences (splitting by periods) and putting each into a list, there can
#be blank sentences (e.g. for a string with two periods in a row ..)
#-when breaking up each sentence (splitting by spaces) and putting each into a list, a blank word does not
#count as a word (e.g. for two spaces in a row)

# Function that takes in a string and outputs the number of words in the longest sentence
def most_words(S):
    # Replacing all possible delims with periods
    S.replace('?', '.')
    S.replace('!', '.')
    S.replace('.', '. ')
    # Split up the string into list of sentences
    sen = S.split('.')
    
    # Get rid of blank sentences
    print sen
    while '' in sen:
        sen.remove('')
    print sen
    
    words = []
    # Go through every index in sen and split up into words (add to a list of lists)
    for i in range(0, len(sen)):
        words.append(sen[i].split(' '))
    
    # Find the max word count
    max = 0
    for i in range(0, len(words)):
        while '' in words[i]:
            words[i].remove('')
        if len(words[i]) > max:
            max = len(words[i])
    
    return max
