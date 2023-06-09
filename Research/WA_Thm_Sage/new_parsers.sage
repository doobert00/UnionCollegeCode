"""
New parsers to support parsing polynomials with fractions.
"""

"""
Evaluates a polynomial in terms of elements of an algebra w/ multiplication
defined by structure constants. eg: f = x^2 + 1 -> f(u) = u^2 + e.
f: A string polynomial.
u: The algebra element to evaluate in f. It is a Sage vector of rationals.
e: The identity element to substitute into f.
F: Structure constants for the algebra to which u belongs.
Return: The evaluated expression as a Sage rational vector.
"""
def parse1(f,u,e,F):
        terms = re.findall('(\-.|\+.)?(\d*)[/]?(\d*)[\*]?(x?)[\^]?(\d*)[/]?(\d*)',f)
        out = zero_vector(QQ,len(u))

        for t in terms:
          if (t[3] == 'x'):
            u_i = u
            if (t[4] != ''):
              for i in range(1,int(t[4])):
                u_i = AlgebraProduct(u_i,u,F)
            if (t[1] != ''):
              u_i *= int(t[1])
            if (t[2] != ''):
              u_i /= int(t[2])
            if(t[0] == '- '):
              u_i *= -1
            out += u_i
          elif (t[1] != ''):
            u_i = int(t[1])*e
            if(t[2] != ''):
              u_i /= int(t[2])
            if(t[0] == '- '):
              u_i *= -1
            out += u_i
        return out

"""
Parses and evaluates the primitive elmenet of a field extension. Guarenteed
to exist by the primitive element theorem, these are elements such that:
  F(a,b) = F(a+kb)
for some rational k.
f: A string primtive element to evaluate, of the form a + kb.
  NOTE: If we are evaluating a compound primitive element then f = b + kc.
a: A Sage rational vector representing the current extension element.
b: A Sage rational vector representing the previous primitive element.
first: The boolean state of the first-ness of our evaluation.
Return: The evaluated expression as a Sage rational vector.
"""
def parse_prim1(f,a,b,F,first):
        if (len(a) != len(b)):
          raise Eception("Elements must be of the same dimension")
        termsa = re.findall('(\-.|\+.)?(\d*)[/]?(\d*)[\*]?(a?)[\^]?(\d*)[/]?(\d*)',f)
        termsb = re.findall('(\-.|\+.)?(\d*)[/]?(\d*)[\*]?(b?)[\^]?(\d*)[/]?(\d*)',f)
        if (not first):
          termsa = termsb
          termsb = termsb = re.findall('(\-.|\+.)?(\d*)[/]?(\d*)[\*]?(c?)[\^]?(\d*)[/]?(\d*)',f)
        out = zero_vector(QQ,len(a))
        out = zero_vector(QQ,len(b))

        for t in termsa:
          if (t[3] != ''):
            a_i = a
            if (t[4] != ''):
              for i in range(1,int(t[4])):
                a_i = AlgebraProduct(a_i,a,F)
            if (t[1] != ''):
              a_i *= int(t[1])
            if (t[2] != ''):
              a_i /= int(t[2])
            if(t[0] == '- '):
              a_i *= -1
            out += a_i
        for t in termsa:
          if (t[3] != ''):
            b_i = b
            if (t[4] != ''):
              for i in range(1,int(t[4])):
                b_i = AlgebraProduct(a_i,a,F)
              if (t[1] != ''):
                b_i *= int(t[1])
              if (t[2] != ''):
                b_i /= int(t[2])
              if(t[0] == '- '):
                b_i *= -1
              out += b_i
        return out



"""
Parses an evaluates expressions from calls to absolute_minpoly(). These are of the form:
  x + a_nc^n + ... + a_1c + a_0.
f: The string expression we wish to evaluate.
x: The element we are substituting for x. It is a Sage rational vector.
c: The element we are substituting for c. It is a Sage rational vector.
e: The (identity) element we are substituting for the a_0 term. It is a Sage rational vector.
F: Structure constants for computing powers of v and c.
Return: The evaluated expression as a Sage rational vector.
"""
def parse_in_ext1(f,x,c,e,F):
        if (len(x) != len(c) or len(c) != len(e)):
          raise Exception("Elemnts must be of the same dimension")
        termsc = re.findall('(\-.|\+.)?(\d*)[/]?(\d*)[\*]?(x?)[\^]?(\d*)[/]?(\d*)[\*]?',f)
        termsx = re.findall('(\-.|\+.)?(\d*)[/]?(\d*)[\*]?(c|b)?[\^]?(\d*)[/]?(\d*)[\*]?',f)
        out = zero_vector(QQ,len(x))

        for t in termsc:
          if (t[3] != ''):
            c_i = c
            if (t[4] != ''):
              for i in range(1,int(t[4])):
                u_i = AlgebraProduct(c_i,c,F)
            if (t[1] != ''):
              c_i *= int(t[1])
            if (t[2] != ''):
              c_i /= int(t[2])
            if(t[0] == '- '):
              c_i *= -1
            out += c_i
        for t in termsx:
          if (t[3] == 'x'):
            x_i = x
            if (t[4] != ''):
              for i in range(1,int(t[4])):
                u_i = AlgebraProduct(x_i,x,F)
            if (t[1] != ''):
              x_i *= int(t[1])
            if (t[2] != ''):
              x_i /= int(t[2])
            if(t[0] == '- '):
              x_i *= -1
            out += u_i
          elif (t[1] != ''):
            x_i = int(t[1])*e
            if(t[2] != ''):
              x_i /= int(t[2])
            if(t[0] == '- '):
              x_i *= -1
            out += x_i
        return out
