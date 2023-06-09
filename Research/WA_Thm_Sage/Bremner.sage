"""
Calculates the structure constants for a finite-dimensional algebra Q[G].
G: A list of n group elements from Sage's group library.
Return: A n-n-n tensor of structure constants s.t. C(i,j,k) = 1 iff g_ig_j = g_k. C(i,j,k) = 0 otherwise.
NOTE: We assume the group elem. rep. has product operation, overloading *, s.t. G[i]*G[j] is valid.
"""
def AStructs(G):
  G = list(G)
  n = len(G)
  C = ScTable(n)
  for i in range(0,n):
    for j in range(0,n):
      B = G[i]*G[j]
      for k in range(0,n):
        if(B == G[k]):
          C[i][j][k] = 1
  return C

"""
Removes all zero rows from a matrix.
M: The matrix to remove zero rows from.
"""
def RemoveZeroRows(M):
  toGo = []
  for i in range(0,len(M.rows())):
    if (M.row(i) == zero_vector(QQ,len(M.columns()))):
      toGo.append(i)
  return M.delete_rows(toGo)

"""
Create an empty tensor for structure constants.
n: Integer dimension of the cube tensor.
Return: A n-n-n tensor. It is a list of lists of Sage rational vectors.
"""
def ScTable(n):
  SC = list()
  for i in range(0,n):
    SC.append(list())
    for j in range(0,n):
      SC[i].append(list())
      SC[i][j]= vector(QQ,[0 for _ in range(0,n)])
  return SC

"""
Compute the product of a0*a1 in the algebra A with structure constants for the basis of A.
a0,a1: Length n Sage vectors of coefficients (Rationals).
S: Structure constants for the basis over which A is given as cube tensor list.
Return: Length n Sage vectors of coefficients (Rationals).
"""
def AlgebraProduct(a0,a1,S):
  n = len(a0)
  if(n != len(a1)):
    raise Exception("Elements of the same algebra must have the same length")
  a = vector(QQ,[0 for _ in range(0,n)])
  for l in range(0,n):
    for m in range(0,n):
      c = a0[l]*a1[m]
      for k in range(0,n):
        a[k] += c*S[l][m][k]
  return a

"""
Compute a change of basis for an element of an algebra.
a: An element of an algebra with respect to the basis [u] w/ dimension n as Sage vector (Rationals)
C: The basis [u] with respect to some other basis [v] with dimension m >= n as Sage Matrix.
Return: The element a over the basis [v] as Sage vector (Rationals).
"""
def ChangeBasis(a,C):
  c = len(C.columns())
  r = len(C.rows())
  if(r != len(a)):
    raise Exception("Dimensions not suitable for change of basis.")
  a_C = vector(QQ,[0 for _ in range(0,c)])
  for i in range(0,r):
    for j in range(0,c):
      a_C[j] += a[i]*C[i][j]
  return a_C


"""
Computing a basis for the radical by corollary 12.
C: Structure constants for the algebra as a cube tensor of type list.
Return: The basis for the radical as a Sage Matrix.
"""
def RadBasis(C):
  n = len(C)
  D = [vector(QQ,[0 for _ in range(0,n)]) for _ in range(0,n)]
  for i in range(0,n):
    for j in range(0,n):
      for k in range(0,n):
        for l in range(0,n):
          D[i][j] += C[j][i][k]*C[k][l][l]
  D = Matrix(QQ,D)
  return Matrix(QQ,D.left_kernel().basis())

"""
Calculates the structure constants for Q = A/Rad(A) by Section 1.6.
C: The structure constants for the basis of A as a cube tensor of type list.
R: The basis of the radical given over the basis of A as a Sage Matrix.
Return: Structure constants for Q as a cube tensor of lists.
"""
def QStructs(C,R):
  n = len(C)
  r = n - R.rank()

  #Making L and M
  L = [0 for _ in range(0,n-r)]
  M = [x for x in range(0,n)]
  for i in range(0,n-r):
    j = 0
    while(R[i][j] == 0):
      j += 1
    L[i] = j
    M.remove(j)

  L = vector(QQ,L)
  M = vector(QQ,M)

  #Making sigma
  S = [vector(QQ,[0 for _ in range(0,r)]) for _ in range(0,n-r)]
  for i in range(0,n-r):
    for j in range(0,r):
      if (M[j] < L[i]):
        S[i][j] = 0
      elif M[j] > L[i]:
        S[i][j] = R[i][M[j]]
      else:
        raise Exception("Something went wrong with the quotient.")

  #Calculating structure constants by the equation on the bottom of pg.4
  Q = ScTable(r)
  for i in range(0,r):
    for j in range(0,r):
      for k in range(0,r):
        Q[i][j][k] = C[M[i]][M[j]][M[k]]
        for h in range(0,n-r):
          Q[i][j][k] -= C[M[i]][M[j]][L[h]]*S[h][k]
  return Q

"""
Calculates the basis for Z(Q) by corollary 15.
Q: Structure constants for the quotient algebra Q = A/Rad(A) as a cube tensor.
Return: The reduced and canonical basis (resp.) of Z(Q) as Sage Matrices.
"""
def ZBasis(Q):
  r = len(Q)
  B = [vector(QQ,[0 for _ in range(0,r)]) for _ in range(0,r*r)]
  for i in range(0,r):
    for j in range(0,r):
      for k in range(0,r):
        B[(i*r) + k][j] = Q[i][j][k] - Q[j][i][k]
  B = Matrix(QQ,B)
  if (B == zero_matrix(r*r,r)):
    #B = 0 <=> Q is commutative => return trivial basis.
    return 0,identity_matrix(r)
  R = Matrix(QQ,B.right_kernel().basis()).transpose()
  RB = Matrix(QQ,R.left_kernel().basis())
  CB = Matrix(QQ,RB.right_kernel(basis='pivot').basis())
  return (RB,CB)

"""
Calculate the structure constants for Z(Q) where Q = A/Rad(A).
Z: The canonical basis for Z(Q) w.r.t. the basis of Q as a Sage matrix.
Q: The structure constants for Q as a cube tensor of type list.
Return: The structure constants for Z(Q) as a tensor of type list.
"""
def ZStructs(Z,Q):
  r = len(Z.rows())
  c = len(Z.columns())
  Z_t = Z.transpose()
  if(c != len(Q)):
    raise Exception("Improper structure constants.")
  F = ScTable(r)
  for i in range(0,r):
    for j in range(0,r):
      V = AlgebraProduct(Z[i],Z[j],Q)
      V = Z_t.augment(V).echelon_form()
      for k in range(0,r):
        F[i][j][k] = V[k][-1]
  return F


"""
Returns the basis of the ideal u*Z(Q).
F: The structure constants for the basis of Z(Q) as a cube tensor of type list.
u: An arbitrary element of Z(Q) given w.r.t. the basis of Z(Q) as a list.
Return: The basis of the ideal generated by u as a Sage matrix.
"""
def IdealBasis(F,u):
  c = len(u)
  Y = [vector(QQ,[0 for _ in range(0,c)]) for _ in range(0,c)]
  for i in range(0,c):
    for j in range(0,c):
      for k in range(0,c):
        Y[i][k] += u[j]*F[i][j][k]
  return Matrix(QQ,Y).echelon_form()

"""
Computes the identity of an ideal.
Y: The basis of an ideal as a Sage matrix.
F: The structure constants for Z(Q) as a cube tensor list.
Return: The identity element of the ideal with basis Y, over the basis of Z(Q) as list.
"""
def IdealIdent(F,Y):
  d = len(Y.rows())
  c = len(Y.columns())

  A = [vector(QQ,[0 for _ in range(0,d)]) for _ in range(0,c*d)]
  soln = vector(QQ,[0 for _ in range(0,c*d)])

  #Variables k,p,j,l,m are the same as Bremner's (pg.6)
  for k in range(0,d):
    for p in range(0,c):
      soln[k*d+p] = Y[k][p]
      for j in range(0,d):
        for l in range(0,c):
          for m in range(0,c):
            A[k*d+p][j] += Y[j][l]*Y[k,m]*F[l][m][p]
  A = Matrix(QQ,A)
  X = A.solve_right(soln)
  return ChangeBasis(X,Y)

"""
Computes the defining polynomial of an element in an ideal.
u: The element of the ideal w/ basis Y, given w.r.t. the basis of Z(Q), of type list to find the polynomial of.
e: The identity element of the ideal w/ basis Y, given w.r.t. the basis of Z(Q), of type list.
F: The structure constants for Z(Q) as a cube tensor list.
Y: The basis of the ideal w.r.t. the basis of Z(Q) as a Sage matrix.
Return: Coefficient vector for defining polynomial, f, s.t. f = X[0]x^0 +...+x[n]x^n of type list.
"""
def MinPoly(u,e,F,Y):
  P = Matrix(QQ,[e,u]).transpose()
  u_j = u
  num_cols = 2
  while(P.rank() == num_cols):
    u_j = AlgebraProduct(u_j,u,F)
    P = P.augment(u_j)
    num_cols+=1
  soln = u_j
  A = P.delete_columns([num_cols-1])
  X = list(A.solve_right(soln))
  return X

"""
Splits the ideals of the commutative simple algebra with structure constants in F.
F: A tensor of sage rational vectors.
Return: A list of idempotents (Sage rational vectors) that generate the irreducible ideals.
"""
def Split(F):
  Z = matrix.identity(QQ,len(F))
  E = []
  e = IdealIdent(F,Z)
  return SplitAux(e,Z,e,F,E,0)

"""
Auxilliary split method for the recursive calling strategy.
u: The generating element whose ideal we'd like to split (Sage rational vector).
Y: The basis of the generated ideal (Sage rational matrix).
e: The identity of the ideal w/ basis Y (Sage rational vector).
F: The structure constants for the basis over which all elements are given.
E: A list that collects the generators (identities) of the irreducible ideals.
Return: A list (E) of Sage rational vectors representing the identities of the irreducible ideals.
"""
def SplitAux(u,Y,e,F,E,d):
  d+=1
  is_first = True
  K = Rationals()
  R.<x> = PolynomialRing(K,'x')
  Y = RemoveZeroRows(Y)
  if(dimension(Y.row_space()) == 1):
    E.append(e)
    return E

  for i in range(0,len(Y.rows())):
    w = Y.row(i)
    if(w != u and w != zero_vector(len(w))):
      p = MinPoly(w,e,F,Y)
      f = 0
      for i in range(0,len(p)):
        f += p[i]*x^i
      f = x^len(p) - f

      if(f.is_irreducible()):
        prim_elem = w
        K.<a> = K.extension(f)
        R.<x> = PolynomialRing(K,'x')
        for j in range(i+1,len(Y.rows())):
          w = Y.row(i)
          if(w != u and w != zero_vector(len(w))):

            p = MinPoly(w,e,F,Y)
            f = 0
            for i in range(0,len(p)):
              f += p[i]*x^i
            f = x^len(p) - f
            if(f.is_irreducible()):
              K.<b> = K.extension(f)
              prim_elem = parse_prim1(str(K.primitive_element()),w,prim_elem,F,is_first)
              L.<c> = Rationals().extension(K.primitive_element().absolute_minpoly())
              K = L
              if_first = False
            else:
              for p in list(f.factor()):
                v = parse_in_ext1(str(p[0]),w,prim_elem,e,F)
                Y = IdealBasis(F,v)
                for i in range(0,p[1]):
                  E = SplitAux(v,Y,IdealIdent(F,Y),F,E,d)
              return E
        E.append(e)
        return E
      else:
        for p in list(f.factor()):
          v = parse1(str(p[0]),w,e,F)
          Y = IdealBasis(F,v)
          for i in range(0,p[1]):
            E = SplitAux(v,Y,IdealIdent(F,Y),F,E,d)
        return E
  E.append(e)
  return E

"""
Computes a basis for the irreducible ideal generated by e.
e: A generator for the irreducible ideals of A/Rad(A) given w.r.t the basis of Q as a Sage rational vector.
Q: The structure constants for A/Rad(A) as a tensor of Sage rational vectors.
"""
def QiBasis(e,Q):
  r = len(Q)
  b_j = zero_vector(QQ,r)
  Q_i = Matrix(QQ,b_j).transpose()
  for i in range(0,r):
    b_j[i] = 1
    Q_i = Q_i.augment(AlgebraProduct(b_j,e,Q))
    b_j[i] = 0
  for i in range(0,r):
    b_j[i] = 1
    Q_i = Q_i.augment(AlgebraProduct(e,b_j,Q))
    b_j[i] = 0
  Q_i = Q_i.delete_columns([0])
  return Q_i.transpose().echelon_form()

def IrreducibleIdeals(C):
  R = RadBasis(C)
  #print("My basis for Rad(A)")
  #print(R)
  Q = QStructs(C,R)

  RB,CB = ZBasis(Q)
  #print("My canonical basis for Z(Q):")
  #print(CB)
  #print("My reduced basis for Z(Q):")
  #print(RB)
  #print()


  F = ZStructs(CB,Q)
  E = Split(F)

  print("My decomposition basis for Q:")
  print()
  i = 1
  for e in E:
    e = ChangeBasis(e,CB)
    B = QiBasis(e,Q)
    toGo = []
    for j in range(0,len(B.rows())):
      #Removes zero rows
      if (B.row(j) == zero_vector(QQ,len(B.columns()))):
        toGo.append(j)
    B = B.delete_rows(toGo)
    print("e:",e)
    print("Q_"+str(i)+":",B,"\n")
    i +=1
