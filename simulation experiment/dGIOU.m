function s=dGIOU(pred,gt)
Ibox=In(pred,gt);
I=(Ibox.b-Ibox.t)*(Ibox.r-Ibox.l);
U=(pred.b-pred.t)*(pred.r-pred.l)+(gt.b-gt.t)*(gt.r-gt.l)-I;
dU=dUbox(pred,gt);
Cbox=cover(pred,gt);
dC=dCbox(pred,gt);
C=(Cbox.b-Cbox.t)*(Cbox.r-Cbox.l);
if Ibox.t<Ibox.b&&Ibox.l<Ibox.r
    diou=dIOU(pred,gt);
    s.dt=diou.dt;
    s.db=diou.db;
    s.dl=diou.dl;
    s.dr=diou.dr;
    if C>0
        s.dt=s.dt+1*(C*dU.dt-U*dC.dt)/C^2;
        s.db=s.db+1*(C*dU.db-U*dC.db)/C^2;
        s.dl=s.dl+1*(C*dU.dl-U*dC.dl)/C^2;
        s.dr=s.dr+1*(C*dU.dr-U*dC.dr)/C^2;
    end
else
    s.dt=(C*dU.dt-U*dC.dt)/C^2;
    s.db=(C*dU.db-U*dC.db)/C^2;
    s.dl=(C*dU.dl-U*dC.dl)/C^2;
    s.dr=(C*dU.dr-U*dC.dr)/C^2;
end