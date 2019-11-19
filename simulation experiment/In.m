function s=In(A,B)
s.t=max(A.t,B.t);
s.b=min(A.b,B.b);
s.l=max(A.l,B.l);
s.r=min(A.r,B.r);