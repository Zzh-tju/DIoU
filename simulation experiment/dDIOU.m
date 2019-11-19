function s=dDIOU(A,B)
pred=to_tblr(A);
gt=to_tblr(B);
Ibox=In(pred,gt);
I=(Ibox.b-Ibox.t)*(Ibox.r-Ibox.l);
Cbox=cover(pred,gt);
C=(Cbox.b-Cbox.t)*(Cbox.b-Cbox.t)+(Cbox.r-Cbox.l)*(Cbox.r-Cbox.l);
CCw=Cbox.r-Cbox.l;
CCh=Cbox.b-Cbox.t;
if pred.t<gt.t
    Ct.dx=0;
    Ct.dy=1;
    Ct.dw=0;
    Ct.dh=-0.5;
else
    Ct.dx=0;
    Ct.dy=0;
    Ct.dw=0;
    Ct.dh=0;
end

if pred.b>gt.b
    Cb.dx=0;
    Cb.dy=1;
    Cb.dw=0;
    Cb.dh=0.5;
else
    Cb.dx=0;
    Cb.dy=0;
    Cb.dw=0;
    Cb.dh=0;
end

if pred.l<gt.l
    Cl.dx=1;
    Cl.dy=0;
    Cl.dw=-0.5;
    Cl.dh=0;
else
    Cl.dx=0;
    Cl.dy=0;
    Cl.dw=0;
    Cl.dh=0;
end

if pred.r>gt.r
    Cr.dx=1;
    Cr.dy=0;
    Cr.dw=0.5;
    Cr.dh=0;
else
    Cr.dx=0;
    Cr.dy=0;
    Cr.dw=0;
    Cr.dh=0;
end
Cw.dx=Cr.dx-Cl.dx;
Cw.dy=Cb.dy-Ct.dy;
Cw.dw=Cr.dw-Cl.dw;
Cw.dh=Cb.dh-Ct.dh;
Ch.dx=Cr.dx-Cl.dx;
Ch.dy=Cb.dy-Ct.dy;
Ch.dw=Cr.dw-Cl.dw;
Ch.dh=Cb.dh-Ct.dh;
if pred.l<gt.l&&pred.r>gt.r
    Cw.dw=-1;
end
if pred.t<gt.t&&pred.b>gt.b
    Ch.dh=-1;
end

d=(A(1)-B(1))*(A(1)-B(1))+(A(2)-B(2))*(A(2)-B(2));
s.dx=1*(2*(B(1)-A(1))*C-(2*CCw*Cw.dx+2*CCh*Ch.dx)*d) / (C * C);
s.dy=1*(2*(B(2)-A(2))*C-(2*CCw*Cw.dy+2*CCh*Ch.dy)*d) / (C * C);
s.dw= 1*(2*CCw*Cw.dw+2*CCh*Ch.dw)*d / (C * C);
s.dh= 1*(2*CCw*Cw.dh+2*CCh*Ch.dh)*d / (C * C);
diou=dIOU(pred,gt);
p.dx=diou.dl+diou.dr;
p.dy=diou.dt+diou.db;
p.dw=(diou.dr-diou.dl);
p.dh=(diou.db-diou.dt);
s.dx=p.dx+s.dx;
s.dy=p.dy+s.dy;
s.dw=p.dw+s.dw;
s.dh=p.dh+s.dh;

