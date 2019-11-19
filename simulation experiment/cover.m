function x=cover(A,B)
x.t=min(A.t,B.t);
x.b=max(A.b,B.b);
x.l=min(A.l,B.l);
x.r=max(A.r,B.r);