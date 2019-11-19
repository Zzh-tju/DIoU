function s=dXbox(X)
s.dt=-(X.r-X.l);
s.db=(X.r-X.l);
s.dl=-(X.b-X.t);
s.dr=(X.b-X.t);