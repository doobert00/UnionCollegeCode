"""
Evaluates a polynomial in terms of elements of an algebra w/ multiplication
defined by structure constants. eg: f = x^2 + 1 -> f(u) = u^2 + e.
f: A string polynomial.
u: The algebra element to evaluate in f. It is a Sage vector of rationals.
e: The identity element to substitute into f.
F: Structure constants for the algebra to which u belongs.
Return: The evaluated expression as a Sage rational vector.
"""
def parse(f,u,e,F):
  terms = re.findall('(\-.|\+.)*(\d\*)*(x)*(\^\d+)*(\d+)*',f)
  out = zero_vector(QQ,len(u))

  for t in terms:
    if(t[2] == 'x'):
      u_i = u
      if(t[3] != ''):
        for i in range(1,int(t[3][1:])):
          u_i = AlgebraProduct(u_i,u,F)
      if(t[1] != ''):
        u_i *= int(t[1][0:-1])
      if t[0] == '+ ' or t[0] == '':
        out += u_i
      else:
        out -= u_i
    elif(t[4] != ''):
      if t[0] == '+ ' or t[0] == '':
        out += int(t[4])*e
      else:
        out -= int(t[4])*e
  return out

"""
Parses and evaluates the primitive elmenet of a field extension. Guarenteed
to exist by the primitive element theorem, these are elements such that:
  F(a,b) = F(a+kb)
for some rational k.
f: A string primtive element to evaluate of the form a + kb.
  NOTE: If we are evaluating a compound primitive element then f = b + kc.
a: A Sage rational vector representing the current extension element.
b: A Sage rational vector representing the previous primitive element.
first: The boolean state of the first-ness of our evaluation.
Return: The evaluated expression as a Sage rational vector.
"""
def parse_prim(f,a,b,F,first):
  if(len(a) != len(b)):
    raise Exception('Extension elements must be of equal dimension.')

  terms0 = re.findall('(\-.|\+.)*(\d+\*)*(a)*(\^\d+)*',f)
  terms1 = re.findall('(\-.|\+.)*(\d+\*)*(b)*(\^\d+)*',f)
  if(not first):
    terms0 = terms1
    terms1 = re.findall('(\-.|\+.)*(\d\*)*(c)*(\^\d+)*',f)

  out = zero_vector(QQ,len(a))
  for t in terms0:
    if(t[2] != ''):
      a_i = a
      if(t[3] != ''):
        for i in range(1,int(t[3][1:])):
          a_i = AlgebraProduct(a_i,a,F)
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
          b_i = AlgebraProduct(b_i,b,F)
      if(t[1] != ''):
        b_i *= int(t[1][0:-1])
      if t[0] == '+ ' or t[0] == '':
        out += b_i
      else:
        out -= b_i
  return out

"""
Parses an evaluates expressions from calls to absolute_minpoly(). These are of the form:
  x + a_nc^n + ... + a_1c + a_0.
f: The string expression we wish to evaluate.
v: The element we are substituting for x. It is a Sage rational vector.
c: The element we are substituting for c. It is a Sage rational vector.
e: The (identity) element we are substituting for the a_0 term. It is a Sage rational vector.
F: Structure constants for computing powers of v and c.
Return: The evaluated expression as a Sage rational vector.
"""
def parse_in_ext(f,v,c,e,F):
  if (len(v) != len(c) or len(c) != len(e)):
    raise Exception("Elements must be of the same dimension")

  termsc = re.findall('(\-.|\+.)?(\d+\*)?(c|b)?(\^\d+)?(\d+)?',f)
  termsv = re.findall('(\-.|\+.)?(\d+\*)?(x)?(\^\d+)?(\d+)?',f)

  out = zero_vector(QQ,len(v))

  for t in termsc:
    if (t[2] != ''):
      c_i = c
      if (t[3] != ''):
        for i in range(1,int(t[3][1:])):
          c_i = AlgebraProduct(c_i,c,F)
      if (t[1] != ''):
        c_i *= int(t[1][0:-1])
      if (t[0] == '+ ' or t[0]==''):
        out += a_i
      else:
        out -= a_i
  for t in termsv:
    if (t[2] != ''):
      v_i = v
      if (t[3] != ''):
        for i in range(1,int(t[3][1:])):
          v_i = AlgebraProduct(v_i,v,F)
      if (t[1] != ''):
        v_i *= int(t[1][0:-1])
      if (t[0] == '+ ' or t[0]==''):
        out += v_i
      else:
        out -= v_i
    elif (t[4] != ''):
      if (t[0]=='+ ' or t[0]==''):
        out += int(t[4])*e
      else:
        out -= int(t[4])*e
  return out
