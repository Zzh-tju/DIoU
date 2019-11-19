function s=dCbox(pred,gt)
Cbox=cover(pred,gt);
if pred.t<gt.t
    s.dt=-(Cbox.r-Cbox.l);
else
    s.dt=0;
end
if pred.b>gt.b
    s.db=Cbox.r-Cbox.l;
else
    s.db=0;
end
if pred.l<gt.l
    s.dl=-(Cbox.b-Cbox.t);
else
    s.dl=0;
end
if pred.r>gt.r
    s.dr=Cbox.b-Cbox.t;
else
    s.dr=0;
end