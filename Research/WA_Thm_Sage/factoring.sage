reset()
import re

def ScTable(n):
  SC = list()
  for i in range(0,n):
    SC.append(list())
    for j in range(0,n):
      SC[i].append(list())
      SC[i][j] = vector(QQ,[0 for _ in range(0,n)])
  return SC

def PT2Product(A,B):
  #Matmult algo for the product operation on PT2.
  C = [[0,0],[0,0]]
  for i in range(0,2):
    for j in range(0,2):
      for k in range(0,2):
        C[i][j] +=  (A[i][k] *B[k][j])
  return C

"""
Computing the structure constants for the basis of the algebra.
G: A group with multiplication defined (we use PT2_Product()).
Return: A cube tensor of structure constants
"""
def AStructs(G):
  n = len(G)
  C = ScTable(n)
  for i in range(0,n):
    for j in range(0,n):
      B = G[i]*G[j]
      for k in range(0,n):
        if(B == G[k]):
          C[i][j][k] = 1
  return C


PT2 = [[[0,0],[0,0]],   #1
          [[1,0],[0,0]],  #2
          [[0,1],[0,0]],  #3
          [[0,0],[1,0]],  #4
          [[0,0],[0,1]],  #5
          [[1,1],[0,0]],  #6
          [[1,0],[0,1]],  #7
          [[0,1],[1,0]],  #8
          [[0,0],[1,1]]]  #9


"""""""""""""""""""""
- The following is a condensed outline of the code for readability.

- Note the comments on lines 5 and 9 of the outline with regards to lines
65-68 in the actual code. A primitive element has to be used
because there is not way to continuously extend K.<a> because the "a" parameter
cannot be dynamically created.

- There is also the matter of the polynomial of the primitive element. In looking
at the factorization down the rabbit hold, the coefficients get really big and
the program might get slow for large ideals.

Algorithm Outline:
  In: P is a collection of polynomials in the form returned by MinPoly(u,e,F,Y)
  Out: Lines 14 or 16 would return the factors of the polynomial that split the ideal.
       Line 17 would return the ideal itself since it could not split.
SPLIT(P)
1. K = Q
2. R = K[x]
3. f = P[0]
4. if(f.num_factors() == 1):
5.  K = K[x]/f (= Q(a))
6.  for p in P:
7.    R = K[x]
8.    if(p.num_factors() == 1):
9.      K = K[x]/p (= Q(a,b))
10.     c = K.primelem()
11.     h = c.minpoly()
12.     K = Q(c)
13.   else:
14.     #We can factor p
15. else:
16.   #We can factor f, the first polynomial.
17. #We have proven that the ideal is a field.
"""""""""""""""""""""

def factor_demo():
  #The polynomials we wish to factor in the form of the output of MinPoly(u,e,F,Y)
  polys = [[-1,0],[2,0],[3,0],[7,0],[-4,0],[4,0],[-7,0]]

  #Base field.
  K = Rationals()
  #Set up the ring for factoring.
  R.<x> = PolynomialRing(K,'x')

  f = 0 #This is how polys are made w/ output of MinPoly(u,e,F,Y)
  for i in range(0,len(polys[0])):
    f += polys[0][i]*x^i
  f = x^len(polys[0]) - f

  if(f.is_irreducible()):
    K.<a> = K.extension(f)
    print("z_0:",K.primitive_element())
    for i in range(1,len(polys)):

      #Set up the ring for factoring in 'x'.
      R.<x> = PolynomialRing(K,'x')

      f = 0
      for j in range(0,len(polys[i])):
        f += polys[i][j]*x^j
      f = x^len(polys[i]) - f

      if(f.is_irreducible()):
        K.<b> = K.extension(f) #Extend the field so f factors.

        print("z_"+str(i)+":",K.primitive_element())

        h = K.primitive_element().absolute_minpoly() #Find the minimal polynomial of the primitive element.
        L.<c> = Rationals().extension(h) #Define a new field, L, s.t. all prev. polynomials factor in L.
        K = L #Reset K
        #print("f="+str(f),"is irreducible")
      else:
        None
        #print("f="+str(f),"is reducible.")
        print("f="+str(f),"factors as f="+str(list((f+2*x).factor())))
      #print(K)
  else:
    print("Yay! The first element factors. This is the easy case.")


def poly_testing():
  R.<x> = PolynomialRing(Rationals(),'x')
  f = x^2 + 2*x + 1
  g = x^2 + 1
  h = 4*x^2 - 2*x + 1
  k = 2*x^2 + 2
  l = 3*x^3 + 2*x^2 + x + 1
  t = (x + 2)*(x + 1)*(x + 3)

  #print(t)
  print(h.factor())
  #print(parse(str(h)))
  #print(g.factor())
  #print(h.factor())
  #print(k.factor())
  #print(l.factor())

def parse_prim(f,a,b,first=True):
  if(len(a) != len(b)):
    raise Exception('Extension elements must be of equal dimension.')

  terms0 = re.findall('(\-.|\+.)*(\d\*)*(a)*(\^\d+)*',f)
  terms1 = re.findall('(\-.|\+.)*(\d\*)*(b)*(\^\d+)*',f)
  if(not first):
    terms0 = terms1
    terms1 = re.findall('(\-.|\+.)*(\d\*)*(c)*(\^\d+)*',f)
  print("---------------------------")
  print(terms0)
  print(terms1)
  print("---------------------------")
  out = zero_vector(QQ,len(a))
  for t in terms0:
    if(t[2] != ''):
      a_i = a
      if(t[3] != ''):
        for i in range(1,int(t[3][1:])):
          #u_i = AlgebraProduct(a_i,a,F)
          print(i)
      if(t[1] != ''):
        a_i *= int(t[1][0:-1])
      if t[0] == '+ ' or t[0] == '':
        out += a_i
      else:
        out -= a_i
  for t in terms1:
    if(t[2] != ''):
      b_i = b
      if(t[3] != ''):
        for i in range(1,int(t[3][1:])):
          #b_i = AlgebraProduct(b_i,b,F)
          print(i)
      if(t[1] != ''):
        b_i *= int(t[1][0:-1])
      if t[0] == '+ ' or t[0] == '':
        out += b_i
      else:
        out -= b_i
  return out

def parse(f):
  e = "e"
  z = "z"
  terms = re.findall('(\-.|\+.)*(\d\*)*(x)*(\^\d+)*(\d+)*',f)
  print(terms)
  for t in terms:
    if(t[2] == 'x'):
      #u_i = u
      if(t[3] != ''):
        for i in range(1,int(t[3][1:])):
          #u_i = AlgebraProduct(u_i,u,F)
          print(i)
      if(t[1] != ''):
        #u_i *= int(t[1][0:-1])
        print()
      if t[0] == '+ ' or t[0] == '':
        #out += u_i
        print()
      else:
        print()
        #out -= u_i
    elif(t[4] != ''):
      if t[0] == '+ ' or t[0] == '':
        print()
        #out += int(t[1])*e
      else:
        print()
        #out -= int(t[1])*e
    #return out

def parse_all(f):
  termsc = re.findall('(\-.|\+.)?(\d+\*)?(c|b)?(\^\d+)?(\d+)?',f)
  termsv = re.findall('(\-|\+.)?(\d+\*)?(x)?(\^\d+)?(\d+)?',f)
  for t in termsc:
    print(t)
  print('----------------------------------')
  for t in termsv:
    print(t)

def p(f):
  f = '2/2'
  terms = re.findall('(\-.|\+.)?(\d)*[/]?(\d)?(x)?(\d)?[/]?(\d)?',f)
  f = '2/2'
  #terms = re.findall('(\d)*[/]?(\d)*',f)
  for t in terms:
    print(t)

def main():
  #parse_all('x^1 + 2*x^2 + b^4 + 1')
  #p = parse_prim('a - b^2',vector(QQ,[1,0,0]),vector(QQ,[0,1,0]))
  #print(p)
  factor_demo()


reset()
