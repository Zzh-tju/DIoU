function s=to_xywh(A)
s.dx=A.dl+A.dr;
s.dy=A.dt+A.db;
s.dw=(A.dr-A.dl);
s.dh=(A.db-A.dt);