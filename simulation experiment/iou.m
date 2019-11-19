function s=iou(pred,gt)
Ibox=In(pred,gt);
I=(Ibox.b-Ibox.t)*(Ibox.r-Ibox.l);
U=(pred.b-pred.t)*(pred.r-pred.l)+(gt.b-gt.t)*(gt.r-gt.l)-I;
if Ibox.t<Ibox.b&&Ibox.l<Ibox.r
    s=I/U;
else
    s=0;
end