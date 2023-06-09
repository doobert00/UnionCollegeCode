#Must call before execution to reset env. variables.
reset()

#Needed for parsers
import re

#Stops messy warnings
import warnings
warnings.filterwarnings("ignore",category=DeprecationWarning)

#Load subroutines
load('Bremner.sage')
load('new_parsers.sage')
#Deprecated: load('parsers.sage')


"""
Simple UI
"""
def UI():
  while(True):
    i = -1
    n = 0

    print(" 1. Symmetric(n)\n 2. Dihedral(2n)\n 3. Cyclic(n)\n 4. Alternating(n)\n 5. Klein Four Group\n 6. Quit\n")
    while (i < 1 or i > 6):
      tmp = input("Select a group: ")
      if(tmp.isdigit()):
        i = int(tmp)

    #No n needed for Klein Four Group
    while (n < 1 and i != 5 and i != 6):
          tmp = input("Value of n: ")
          if(tmp.isdigit()):
            n = int(tmp)

    if (i == 1):
      g = SymmetricGroup(n)
    elif (i == 2):
      g = DihedralGroup(n)
    elif (i == 3):
      g = CyclicPermutationGroup(n)
    elif (i == 4):
      g = AlternatingGroup(n)
    elif (i == 5):
        g = KleinFourGroup()
    else:
      return True

    A = AStructs(g)
    print('------------------------')
    IrreducibleIdeals(A)
    print('------------------------')

UI()
######################################################
reset()
"""
We call reset after termination to reset all environment
variables and to remove our objects from the sage shell.
"""
######################################################
