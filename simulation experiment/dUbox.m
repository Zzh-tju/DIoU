function s=dUbox(pred,gt)
dX=dXbox(pred);
dI=dIbox(pred,gt);
s.dt=dX.dt-dI.dt;
s.db=dX.db-dI.db;
s.dl=dX.dl-dI.dl;
s.dr=dX.dr-dI.dr;