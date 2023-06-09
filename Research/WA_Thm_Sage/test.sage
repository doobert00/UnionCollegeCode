reset()
load('new_parsers.sage')
load('Bremner.sage')
import re
import random

#Caller for test functions.
def setup():
	"""
	for i in range(1,6):
		assert(test_AlgebraProduct(SymmetricGroup(i)))
	for i in range(1,6):
		assert(test_AlgebraProduct(DihedralGroup(i)))
	for i in range(1,6):
		assert(test_AlgebraProduct(CyclicPermutationGroup(i)))
	assert(test_AlgebraProduct(KleinFourGroup()))
	"""
	test_ZBasis(SymmetricGroup(3))
	test_IdealIdent(SymmetricGroup(3))


"""
Tests equality of algebra product by struct consts. vs. algebra product by Sage algebra data type.
Seeing inconsistent "index out of range errors" that don't seem to occur when printing "a" and "v"
before their equality is checked.
G: A Sage group of order n.
Return: True iff structure constant product is equal to Sage algebra data type product.
"""
def test_AlgebraProduct(G):
	#Define list basis for the algebra (index matters)
	B = G.algebra(QQ).basis().list()
	#Define structs ordered by algebra basis list index
	C = AStructs(B)

	#Dimension of std basis, group, and vector rep of alg elem over std basis
	n = len(G)

	#Create two random elements of the algebra (over std basis)
	v_0 = vector(QQ,[random.randint(0,n) for _ in range(0,n)])
	v_1 = vector(QQ,[random.randint(0,n) for _ in range(0,n)])

	#Create equivalent sage group alg. elements.
	a_0 = 0
	a_1 = 0
	for i in range(0,n):
		a_0 += v_0[i]*B[i]
		a_1 += v_1[i]*B[i]

	#Compute products
	v = AlgebraProduct(v_0,v_1,C)
	a = a_0*a_1

	"""
	list(a) = [(g_1,a_1),....,(g_n,a_n)]
	but the list is in no particular order!!!
	Then v[i] = a[j][0] iff a[j][1] == B[i]
	for the basis element B[i]. Printing out list(a) may help to understand this.
	"""
	a = list(a)
	#print(len(a))
	#print(len(v))
	counter = 0
	for i in range(0,n):
		for j in range(0,n):
			if(B[j] == a[i][0]):
				assert(v[j] == a[i][1])
				counter += i

	#If correct then counter += i for i\in[0,n) so (n*(n-1))/2 is sum from 0 to n-1
	if(counter == (n*(n-1))/2):
		return True
		#print("SUCCESS")
	else:
		return False
		#print("FAILURE")

def test_ChangeBasis():
	"""
	Not sure how to validate results without replicating the operation.
	We use an m-n basis matrix to change the basis of a dimension m vector alg. elem.
	"""
	assert(True)

"""
Does not function properly yet.
"""
def test_ZBasis(G):
	#Define list basis for the algebra (index matters)
	B = G.algebra(QQ).basis().list()
	#Define structs ordered by algebra basis list index
	C = AStructs(B)

	#Dimension of std basis, group, and vector rep of alg elem over std basis
	n = len(G)

	#Compute our center basis and Sage's center basis (resp.)
	RB,CB = ZBasis(C)
	CB_list = G.algebra(QQ).center_basis()

	#Assert same num basis vectors
	assert(len(CB.rows()) == len(CB_list))

	"""
	Verify that each b\inCB_list matches to some row in CB.
	Have to check every row for each b. Check coef on column associated
	to the group element indexed by the algebra basis B.
	"""
	correct_rows = 0
	for b in CB_list:
		for row in range (0,len(CB.rows())):
			correct_coefs = 0
			for i in range(0,len(b)):
				for j in range(0,len(B)):
					if(B[j] == b[i][0]):
						if(b[i][1] == CB[row][j]):
							correct_coefs+=1
			if(correct_coefs == len(CB.columns())):
				correct_rows+=1
	assert(True)

def test_ZStructs():
	assert(True)

def test_IdealIdent(G):
	"""
	Some work here on constructing ideals in sage.
	Did not find an identity finding functions in sage but one might exist.
	Might be advisable to use gap.
	"""
	A = G.algebra(QQ)
	B = A.basis().list()
	I = A.ideal([B[0]+2*B[1],B[1]])
	print(I.gens())
	assert(True)

def test_MinPoly():
	"""
	Not sure how to replicate this in a test. Could not
	find a similar GAP construction either. Bremner uses
	the term 'minimal polynomial' in a different way than most people.
	"""
	assert(True)

def test_Split():
	"""
	Definitely advisable to run GAP in parallel and
	compare idempotent results against their solutions.
	"""
	assert(True)

def test_QiBasis():
	"""
	Definitely advisable to run GAP in parallel and
	compare basis results against their solutions.
	"""
	assert(True)

"""
factoring.sage contains some use cases for these functions. Here is a summary
of how these functions, generally.
Consider a sage polynomial f(x) = a + \sum_{i=0}^n c_ix^i
where c_i\in\QQ, x^i variables, and a some field extension element.
We will always know a has a vector representation over a basis as a'.
Let b be some algebra element over the same basis as a'.
Then,
f(b) = a + \vec{0}c_0 + \sum_{i=1}^n c_ib^i.
The sum is a normal vector sum, and powers of b can be computed using structure
constants.
This summary covers the main ideas, see each method for their specific application.
"""
def test_parse():
	assert(True)
def test_parse_prim():
	assert(True)
def test_parse_in_ext():
	assert(True)

"""
QStructs and RadBasis are not used because, for G finite,
Q[G] is always a semisimple algebra. Then the radical is
trivial and the quotient A/Rad(A) = A.

In the described case, QStructs returns AStructs.
"""
def test_QStructs():
	assert(True)
def test_RadBasis():
	assert(True)


setup()
reset()
