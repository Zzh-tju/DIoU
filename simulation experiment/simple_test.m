clear
clc
gt=[10,10,1,1];
pred=[10.5,11.6,2.2,3];		%define it for whatever you want
loss_type='iou';

a=zeros(200,4,'double');
loss=zeros(1,4,'double');
for k=1:160
    gt_tblr=to_tblr(gt);
    pred_tblr=to_tblr(pred);
    IO=iou(pred_tblr,gt_tblr);
    if strcmp(loss_type,'iou')==1
        derivative=dIOU(pred_tblr,gt_tblr);
        derivative=to_xywh(derivative);
    end
    if strcmp(loss_type,'giou')==1
        derivative=dGIOU(pred_tblr,gt_tblr);
        derivative=to_xywh(derivative);
    end
    if strcmp(loss_type,'diou')==1
        derivative=dDIOU(pred,gt);
    end
    if strcmp(loss_type,'ciou')==1
        derivative=dCIOU(pred,gt);
    end
    pred(1)=pred(1)+0.1*(2-IO)*derivative.dx;
    pred(2)=pred(2)+0.1*(2-IO)*derivative.dy;
    pred(3)=pred(3)+0.1*(2-IO)*derivative.dw;
    pred(4)=pred(4)+0.1*(2-IO)*derivative.dh;
    a(k,1:4)=pred;
    loss=abs(a(k,1:4)-gt(1:4))+loss;
end
for k=161:180
    gt_tblr=to_tblr(gt);
    pred_tblr=to_tblr(pred);
    IO=iou(pred_tblr,gt_tblr);
    if strcmp(loss_type,'iou')==1
        derivative=dIOU(pred_tblr,gt_tblr);
        derivative=to_xywh(derivative);
    end
    if strcmp(loss_type,'giou')==1
        derivative=dGIOU(pred_tblr,gt_tblr);
        derivative=to_xywh(derivative);
    end
    if strcmp(loss_type,'diou')==1
        derivative=dDIOU(pred,gt);
    end
    if strcmp(loss_type,'ciou')==1
        derivative=dCIOU(pred,gt);
    end
    pred(1)=pred(1)+0.01*(2-IO)*derivative.dx;
    pred(2)=pred(2)+0.01*(2-IO)*derivative.dy;
    pred(3)=pred(3)+0.01*(2-IO)*derivative.dw;
    pred(4)=pred(4)+0.01*(2-IO)*derivative.dh;
    a(k,1:4)=pred;
    loss=abs(a(k,1:4)-gt(1:4))+loss;
end
for k=181:200
    gt_tblr=to_tblr(gt);
    pred_tblr=to_tblr(pred);
    IO=iou(pred_tblr,gt_tblr);
    if strcmp(loss_type,'iou')==1
        derivative=dIOU(pred_tblr,gt_tblr);
        derivative=to_xywh(derivative);
    end
    if strcmp(loss_type,'giou')==1
        derivative=dGIOU(pred_tblr,gt_tblr);
        derivative=to_xywh(derivative);
    end
    if strcmp(loss_type,'diou')==1
        derivative=dDIOU(pred,gt);
    end
    if strcmp(loss_type,'ciou')==1
        derivative=dCIOU(pred,gt);
    end
    pred(1)=pred(1)+0.001*(2-IO)*derivative.dx;
    pred(2)=pred(2)+0.001*(2-IO)*derivative.dy;
    pred(3)=pred(3)+0.001*(2-IO)*derivative.dw;
    pred(4)=pred(4)+0.001*(2-IO)*derivative.dh;
    a(k,1:4)=pred;
    loss=abs(a(k,1:4)-gt(1:4))+loss;
end
error=loss(1)+loss(2)+loss(3)+loss(4)
figure,plot(a(:,1),'r','LineWidth',1.5),title('x');
figure,plot(a(:,2),'r','LineWidth',1.5),title('y');
figure,plot(a(:,3),'r','LineWidth',1.5),title('w');
figure,plot(a(:,4),'r','LineWidth',1.5),title('h');