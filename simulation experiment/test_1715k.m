clear
clc
mm1=0;
F1=fopen('C:\Users\dell\Desktop\yourpath\iou-1715k.txt','a');
F2=fopen('C:\Users\dell\Desktop\yourpath\giou-1715k.txt','a');
F3=fopen('C:\Users\dell\Desktop\yourpath\diou-1715k.txt','a');
F4=fopen('C:\Users\dell\Desktop\yourpath\ciou-1715k.txt','a');
rr=3*sqrt(rand(1,5000));
seta=2*pi*rand(1,5000);
xx=10+rr.*cos(seta);
yy=10+rr.*sin(seta);
c1=sqrt(3);
c2=sqrt(2);
i_x=zeros(200,1,'double');i_y=zeros(200,1,'double');i_w=zeros(200,1,'double');i_h=zeros(200,1,'double');
g_x=zeros(200,1,'double');g_y=zeros(200,1,'double');g_w=zeros(200,1,'double');g_h=zeros(200,1,'double');
d_x=zeros(200,1,'double');d_y=zeros(200,1,'double');d_w=zeros(200,1,'double');d_h=zeros(200,1,'double');
c_x=zeros(200,1,'double');c_y=zeros(200,1,'double');c_w=zeros(200,1,'double');c_h=zeros(200,1,'double');
position_x=zeros(1715000,1,'double');
position_y=zeros(1715000,1,'double');
position_w=zeros(1715000,1,'double');
position_h=zeros(1715000,1,'double');
IoU_Loss=zeros(1715000,1,'double');
GIoU_Loss=zeros(1715000,1,'double');
DIoU_Loss=zeros(1715000,1,'double');
CIoU_Loss=zeros(1715000,1,'double');
final_error_iou=zeros(1715000,1,'double');
final_error_giou=zeros(1715000,1,'double');
final_error_diou=zeros(1715000,1,'double');
final_error_ciou=zeros(1715000,1,'double');			%Initialization

for i=1:5000           %5000 points
    pred_x=xx(i);
    pred_y=yy(i);
    for c=1:7
        if c==1
            gt_w=0.5;
            gt_h=2.0;
        end
        if c==2
            gt_w=c1/3;
            gt_h=c1;
        end
        if c==3
            gt_w=c2/2;
            gt_h=c2;
        end
        if c==4
            gt_w=1;
            gt_h=1;
        end
        if c==5
            gt_w=c2;
            gt_h=c2/2;
        end
        if c==6
            gt_w=c1;
            gt_h=c1/3;
        end
        if c==7
            gt_w=2.0;
            gt_h=0.5;
        end
        gt=[10,10,gt_w,gt_h];       %7 aspect ratios of target boxes

        for o=1:7
            if o==1
                S=0.5*gt_w*gt_h;
            end
            if o==2
                S=0.67*gt_w*gt_h;
            end
            if o==3
                S=0.75*gt_w*gt_h;
            end
            if o==4
                S=1*gt_w*gt_h;
            end
            if o==5
                S=1.33*gt_w*gt_h;
            end
            if o==6
                S=1.5*gt_w*gt_h;
            end
            if o==7
                S=2.0*gt_w*gt_h;                %7 scales of anchor boxes
            end
            iou0=zeros(7,1,'double');
            giou0=zeros(7,1,'double');
            diou0=zeros(7,1,'double');
            ciou0=zeros(7,1,'double');
            for l=1:7
                if l==1
                    pred_w=0.5*sqrt(S);
                    pred_h=2.0*sqrt(S);
                end
                if l==2
                    pred_w=c1/3*sqrt(S);
                    pred_h=c1*sqrt(S);
                end
                if l==3
                    pred_w=c2/2*sqrt(S);
                    pred_h=c2*sqrt(S);
                end
                if l==4
                    pred_w=1.0*sqrt(S);
                    pred_h=1.0*sqrt(S);
                end
                if l==5
                    pred_w=c2*sqrt(S);
                    pred_h=c2/2*sqrt(S);
                end
                if l==6
                    pred_w=c1*sqrt(S);
                    pred_h=c1/3*sqrt(S);
                end
                if l==7
                    pred_w=2.0*sqrt(S);
                    pred_h=0.5*sqrt(S);
                end
                pred=[pred_x,pred_y,pred_w,pred_h];       %7 aspect ratios of anchor boxes
                
                mm1=mm1+1;
                position_x(mm1)=pred_x;
                position_y(mm1)=pred_y;
                position_w(mm1)=pred_w;
                position_h(mm1)=pred_h;
                pred1=pred;
                a=zeros(200,4,'double');
                loss1=zeros(1,4,'double');
                for k=1:160					%do bounding box regression by gradient descent algorithm
                    gt_tblr=to_tblr(gt);
                    pred_tblr=to_tblr(pred1);
                    IO=iou(pred_tblr,gt_tblr);
                    diou=dIOU(pred_tblr,gt_tblr);
                    diou_xywh=to_xywh(diou);
                    pred1(1)=pred1(1)+0.1*(2-IO)*diou_xywh.dx;
                    pred1(2)=pred1(2)+0.1*(2-IO)*diou_xywh.dy;
                    pred1(3)=pred1(3)+0.1*(2-IO)*diou_xywh.dw;
                    pred1(4)=pred1(4)+0.1*(2-IO)*diou_xywh.dh;
                    a(k,2:5)=pred1;
                    loss1=abs(a(k,2:5)-gt(1:4))+loss1;
                    i_x(k)=abs(pred1(1)-gt(1))+i_x(k);
                    i_y(k)=abs(pred1(2)-gt(2))+i_y(k);
                    i_w(k)=abs(pred1(3)-gt(3))+i_w(k);
                    i_h(k)=abs(pred1(4)-gt(4))+i_h(k);
                end
                for k=161:180
                    gt_tblr=to_tblr(gt);
                    pred_tblr=to_tblr(pred1);
                    IO=iou(pred_tblr,gt_tblr);
                    diou=dIOU(pred_tblr,gt_tblr);
                    diou_xywh=to_xywh(diou);
                    pred1(1)=pred1(1)+0.01*(2-IO)*diou_xywh.dx;
                    pred1(2)=pred1(2)+0.01*(2-IO)*diou_xywh.dy;
                    pred1(3)=pred1(3)+0.01*(2-IO)*diou_xywh.dw;
                    pred1(4)=pred1(4)+0.01*(2-IO)*diou_xywh.dh;
                    a(k,2:5)=pred1;
                    loss1=abs(a(k,2:5)-gt(1:4))+loss1;
                    i_x(k)=abs(pred1(1)-gt(1))+i_x(k);
                    i_y(k)=abs(pred1(2)-gt(2))+i_y(k);
                    i_w(k)=abs(pred1(3)-gt(3))+i_w(k);
                    i_h(k)=abs(pred1(4)-gt(4))+i_h(k);
                end
                for k=181:200
                    gt_tblr=to_tblr(gt);
                    pred_tblr=to_tblr(pred1);
                    IO=iou(pred_tblr,gt_tblr);
                    diou=dIOU(pred_tblr,gt_tblr);
                    diou_xywh=to_xywh(diou);
                    pred1(1)=pred1(1)+0.001*(2-IO)*diou_xywh.dx;
                    pred1(2)=pred1(2)+0.001*(2-IO)*diou_xywh.dy;
                    pred1(3)=pred1(3)+0.001*(2-IO)*diou_xywh.dw;
                    pred1(4)=pred1(4)+0.001*(2-IO)*diou_xywh.dh;
                    a(k,2:5)=pred1;
                    loss1=abs(a(k,2:5)-gt(1:4))+loss1;
                    i_x(k)=abs(pred1(1)-gt(1))+i_x(k);
                    i_y(k)=abs(pred1(2)-gt(2))+i_y(k);
                    i_w(k)=abs(pred1(3)-gt(3))+i_w(k);
                    i_h(k)=abs(pred1(4)-gt(4))+i_h(k);
                end
                final_error_iou(mm1)=abs(pred1(1)-gt(1))+abs(pred1(2)-gt(2))+abs(pred1(3)-gt(3))+abs(pred1(4)-gt(4));
                iou0(l)=loss1(1)+loss1(2)+loss1(3)+loss1(4);
                IoU_Loss(mm1)=iou0(l);
                fprintf(F1, '%d\t',mm1);
                fprintf(F1, '%f\t',position_x(mm1));
                fprintf(F1, '%f\t',position_y(mm1));
                fprintf(F1, '%f\t',position_w(mm1));
                fprintf(F1, '%f\t',position_h(mm1));
                fprintf(F1, '%f\t',IoU_Loss(mm1));
                fprintf(F1, '%f\n',final_error_iou(mm1));				%save results for every regression cases
                
                pred2=pred;
                a=zeros(200,4,'double');
                loss2=zeros(1,4,'double');
                for k=1:160
                    gt_tblr=to_tblr(gt);
                    pred_tblr=to_tblr(pred2);
                    IO=iou(pred_tblr,gt_tblr);
                    dgiou=dGIOU(pred_tblr,gt_tblr);
                    dgiou_xywh=to_xywh(dgiou);
                    pred2(1)=pred2(1)+0.1*(2-IO)*dgiou_xywh.dx;
                    pred2(2)=pred2(2)+0.1*(2-IO)*dgiou_xywh.dy;
                    pred2(3)=pred2(3)+0.1*(2-IO)*dgiou_xywh.dw;
                    pred2(4)=pred2(4)+0.1*(2-IO)*dgiou_xywh.dh;
                    a(k,2:5)=pred2;
                    loss2=abs(a(k,2:5)-gt(1:4))+loss2;
                    g_x(k)=abs(pred2(1)-gt(1))+g_x(k);
                    g_y(k)=abs(pred2(2)-gt(2))+g_y(k);
                    g_w(k)=abs(pred2(3)-gt(3))+g_w(k);
                    g_h(k)=abs(pred2(4)-gt(4))+g_h(k);
                end
                for k=161:180
                    gt_tblr=to_tblr(gt);
                    pred_tblr=to_tblr(pred2);
                    IO=iou(pred_tblr,gt_tblr);
                    dgiou=dGIOU(pred_tblr,gt_tblr);
                    dgiou_xywh=to_xywh(dgiou);
                    pred2(1)=pred2(1)+0.01*(2-IO)*dgiou_xywh.dx;
                    pred2(2)=pred2(2)+0.01*(2-IO)*dgiou_xywh.dy;
                    pred2(3)=pred2(3)+0.01*(2-IO)*dgiou_xywh.dw;
                    pred2(4)=pred2(4)+0.01*(2-IO)*dgiou_xywh.dh;
                    a(k,2:5)=pred2;
                    loss2=abs(a(k,2:5)-gt(1:4))+loss2;
                    g_x(k)=abs(pred2(1)-gt(1))+g_x(k);
                    g_y(k)=abs(pred2(2)-gt(2))+g_y(k);
                    g_w(k)=abs(pred2(3)-gt(3))+g_w(k);
                    g_h(k)=abs(pred2(4)-gt(4))+g_h(k);
                end
                for k=181:200
                    gt_tblr=to_tblr(gt);
                    pred_tblr=to_tblr(pred2);
                    IO=iou(pred_tblr,gt_tblr);
                    dgiou=dGIOU(pred_tblr,gt_tblr);
                    dgiou_xywh=to_xywh(dgiou);
                    pred2(1)=pred2(1)+0.001*(2-IO)*dgiou_xywh.dx;
                    pred2(2)=pred2(2)+0.001*(2-IO)*dgiou_xywh.dy;
                    pred2(3)=pred2(3)+0.001*(2-IO)*dgiou_xywh.dw;
                    pred2(4)=pred2(4)+0.001*(2-IO)*dgiou_xywh.dh;
                    a(k,2:5)=pred2;
                    loss2=abs(a(k,2:5)-gt(1:4))+loss2;
                    g_x(k)=abs(pred2(1)-gt(1))+g_x(k);
                    g_y(k)=abs(pred2(2)-gt(2))+g_y(k);
                    g_w(k)=abs(pred2(3)-gt(3))+g_w(k);
                    g_h(k)=abs(pred2(4)-gt(4))+g_h(k);
                end
                final_error_giou(mm1)=abs(pred2(1)-gt(1))+abs(pred2(2)-gt(2))+abs(pred2(3)-gt(3))+abs(pred2(4)-gt(4));
                giou0(l)=loss2(1)+loss2(2)+loss2(3)+loss2(4);
                GIoU_Loss(mm1)=giou0(l);
                fprintf(F2, '%d\t',mm1);
                fprintf(F2, '%f\t',position_x(mm1));
                fprintf(F2, '%f\t',position_y(mm1));
                fprintf(F2, '%f\t',position_w(mm1));
                fprintf(F2, '%f\t',position_h(mm1));
                fprintf(F2, '%f\t',GIoU_Loss(mm1));
                fprintf(F2, '%f\n',final_error_giou(mm1));				%save results for every regression cases
                
                pred3=pred;
                a=zeros(200,4,'double');
                loss3=zeros(1,4,'double');
                for k=1:160
                    gt_tblr=to_tblr(gt);
                    pred_tblr=to_tblr(pred3);
                    IO=iou(pred_tblr,gt_tblr);
                    ddiou=dDIOU(pred3,gt);
                    pred3(1)=pred3(1)+0.1*(2-IO)*ddiou.dx;
                    pred3(2)=pred3(2)+0.1*(2-IO)*ddiou.dy;
                    pred3(3)=pred3(3)+0.1*(2-IO)*ddiou.dw;
                    pred3(4)=pred3(4)+0.1*(2-IO)*ddiou.dh;
                    a(k,2:5)=pred3;
                    loss3=abs(a(k,2:5)-gt(1:4))+loss3;
                    d_x(k)=abs(pred3(1)-gt(1))+d_x(k);
                    d_y(k)=abs(pred3(2)-gt(2))+d_y(k);
                    d_w(k)=abs(pred3(3)-gt(3))+d_w(k);
                    d_h(k)=abs(pred3(4)-gt(4))+d_h(k);
                end
                for k=161:180
                    gt_tblr=to_tblr(gt);
                    pred_tblr=to_tblr(pred3);
                    IO=iou(pred_tblr,gt_tblr);
                    ddiou=dDIOU(pred3,gt);
                    pred3(1)=pred3(1)+0.01*(2-IO)*ddiou.dx;
                    pred3(2)=pred3(2)+0.01*(2-IO)*ddiou.dy;
                    pred3(3)=pred3(3)+0.01*(2-IO)*ddiou.dw;
                    pred3(4)=pred3(4)+0.01*(2-IO)*ddiou.dh;
                    a(k,2:5)=pred3;
                    loss3=abs(a(k,2:5)-gt(1:4))+loss3;
                    d_x(k)=abs(pred3(1)-gt(1))+d_x(k);
                    d_y(k)=abs(pred3(2)-gt(2))+d_y(k);
                    d_w(k)=abs(pred3(3)-gt(3))+d_w(k);
                    d_h(k)=abs(pred3(4)-gt(4))+d_h(k);
                end
                for k=181:200
                    gt_tblr=to_tblr(gt);
                    pred_tblr=to_tblr(pred3);
                    IO=iou(pred_tblr,gt_tblr);
                    ddiou=dDIOU(pred3,gt);
                    pred3(1)=pred3(1)+0.001*(2-IO)*ddiou.dx;
                    pred3(2)=pred3(2)+0.001*(2-IO)*ddiou.dy;
                    pred3(3)=pred3(3)+0.001*(2-IO)*ddiou.dw;
                    pred3(4)=pred3(4)+0.001*(2-IO)*ddiou.dh;
                    a(k,2:5)=pred3;
                    loss3=abs(a(k,2:5)-gt(1:4))+loss3;
                    d_x(k)=abs(pred3(1)-gt(1))+d_x(k);
                    d_y(k)=abs(pred3(2)-gt(2))+d_y(k);
                    d_w(k)=abs(pred3(3)-gt(3))+d_w(k);
                    d_h(k)=abs(pred3(4)-gt(4))+d_h(k);
                end
                final_error_diou(mm1)=abs(pred3(1)-gt(1))+abs(pred3(2)-gt(2))+abs(pred3(3)-gt(3))+abs(pred3(4)-gt(4));
                diou0(l)=loss3(1)+loss3(2)+loss3(3)+loss3(4);
                DIoU_Loss(mm1)=diou0(l);
                fprintf(F3, '%d\t',mm1);
                fprintf(F3, '%f\t',position_x(mm1));
                fprintf(F3, '%f\t',position_y(mm1));
                fprintf(F3, '%f\t',position_w(mm1));
                fprintf(F3, '%f\t',position_h(mm1));
                fprintf(F3, '%f\t',DIoU_Loss(mm1));
                fprintf(F3, '%f\n',final_error_diou(mm1));				%save results for every regression cases

                pred4=pred;
                a=zeros(200,4,'double');
                loss4=zeros(1,4,'double');
                for k=1:160
                    gt_tblr=to_tblr(gt);
                    pred_tblr=to_tblr(pred4);
                    IO=iou(pred_tblr,gt_tblr);
                    dciou=dCIOU(pred4,gt);
                    pred4(1)=pred4(1)+0.1*(2-IO)*dciou.dx;
                    pred4(2)=pred4(2)+0.1*(2-IO)*dciou.dy;
                    pred4(3)=pred4(3)+0.1*(2-IO)*dciou.dw;
                    pred4(4)=pred4(4)+0.1*(2-IO)*dciou.dh;
                    a(k,2:5)=pred4;
                    loss4=abs(a(k,2:5)-gt(1:4))+loss4;
                    c_x(k)=abs(pred4(1)-gt(1))+c_x(k);
                    c_y(k)=abs(pred4(2)-gt(2))+c_y(k);
                    c_w(k)=abs(pred4(3)-gt(3))+c_w(k);
                    c_h(k)=abs(pred4(4)-gt(4))+c_h(k);
                end
                for k=161:180
                    gt_tblr=to_tblr(gt);
                    pred_tblr=to_tblr(pred4);
                    IO=iou(pred_tblr,gt_tblr);
                    dciou=dCIOU(pred4,gt);
                    pred4(1)=pred4(1)+0.01*(2-IO)*dciou.dx;
                    pred4(2)=pred4(2)+0.01*(2-IO)*dciou.dy;
                    pred4(3)=pred4(3)+0.01*(2-IO)*dciou.dw;
                    pred4(4)=pred4(4)+0.01*(2-IO)*dciou.dh;
                    a(k,2:5)=pred4;
                    loss4=abs(a(k,2:5)-gt(1:4))+loss4;
                    c_x(k)=abs(pred4(1)-gt(1))+c_x(k);
                    c_y(k)=abs(pred4(2)-gt(2))+c_y(k);
                    c_w(k)=abs(pred4(3)-gt(3))+c_w(k);
                    c_h(k)=abs(pred4(4)-gt(4))+c_h(k);
                end
                for k=181:200
                    gt_tblr=to_tblr(gt);
                    pred_tblr=to_tblr(pred4);
                    IO=iou(pred_tblr,gt_tblr);
                    dciou=dCIOU(pred4,gt);
                    pred4(1)=pred4(1)+0.001*(2-IO)*dciou.dx;
                    pred4(2)=pred4(2)+0.001*(2-IO)*dciou.dy;
                    pred4(3)=pred4(3)+0.001*(2-IO)*dciou.dw;
                    pred4(4)=pred4(4)+0.001*(2-IO)*dciou.dh;
                    a(k,2:5)=pred4;
                    loss4=abs(a(k,2:5)-gt(1:4))+loss4;
                    c_x(k)=abs(pred4(1)-gt(1))+c_x(k);
                    c_y(k)=abs(pred4(2)-gt(2))+c_y(k);
                    c_w(k)=abs(pred4(3)-gt(3))+c_w(k);
                    c_h(k)=abs(pred4(4)-gt(4))+c_h(k);
                end
                final_error_ciou(mm1)=abs(pred4(1)-gt(1))+abs(pred4(2)-gt(2))+abs(pred4(3)-gt(3))+abs(pred4(4)-gt(4));
                ciou0(l)=loss4(1)+loss4(2)+loss4(3)+loss4(4);
                CIoU_Loss(mm1)=ciou0(l);
                fprintf(F4, '%d\t',mm1);
                fprintf(F4, '%f\t',position_x(mm1));
                fprintf(F4, '%f\t',position_y(mm1));
                fprintf(F4, '%f\t',position_w(mm1));
                fprintf(F4, '%f\t',position_h(mm1));
                fprintf(F4, '%f\t',CIoU_Loss(mm1));
                fprintf(F4, '%f\n',final_error_ciou(mm1));				%save results for every regression cases
            end
        end
    end
end
fclose(F1);fclose(F2);fclose(F3);fclose(F4);
total_iou_loss=sum(IoU_Loss)	%This is the total error of 1715k regression cases.
total_giou_loss=sum(GIoU_Loss)
total_diou_loss=sum(DIoU_Loss)
total_ciou_loss=sum(CIoU_Loss)
iii=i_x+i_y+i_w+i_h;
ggg=g_x+g_y+g_w+g_h;
ddd=d_x+d_y+d_w+d_h;
ccc=c_x+c_y+c_w+c_h;
figure,plot(iii,'k','LineWidth',1.5);hold on
plot(ggg,'b','LineWidth',1.5);hold on
plot(ddd,'r','LineWidth',1.5);hold on
plot(ccc,'c','LineWidth',1.5),legend('IoU','GIoU','DIoU','CIoU'),xlabel('Iteration'),ylabel('error');      %plot regression error sum curve

fxy_iou=zeros(5000,1,'double');
fxy_giou=zeros(5000,1,'double');
fxy_diou=zeros(5000,1,'double');
fxy_ciou=zeros(5000,1,'double');
for u=1:5000
    for v=1:343
        n=(u-1)*343+v;
        fxy_iou(u)=fxy_iou(u)+final_error_iou(n);
		fxy_giou(u)=fxy_giou(u)+final_error_giou(n);
		fxy_diou(u)=fxy_diou(u)+final_error_diou(n);
		fxy_ciou(u)=fxy_ciou(u)+final_error_ciou(n);
    end
end
tri = delaunay(xx,yy);
figure,trimesh(tri,xx,yy,fxy_iou),zlabel('total final error'); 
figure,trimesh(tri,xx,yy,fxy_giou),zlabel('total final error'); 
figure,trimesh(tri,xx,yy,fxy_diou),zlabel('total final error');  
figure,trimesh(tri,xx,yy,fxy_ciou),zlabel('total final error'); 	%plot regression error at final iteration 200th

F11=fopen('C:\Users\dell\Desktop\yourpath\iou_reg.txt','a');		%save results for every iterations
F22=fopen('C:\Users\dell\Desktop\yourpath\giou_reg.txt','a');
F33=fopen('C:\Users\dell\Desktop\yourpath\diou_reg.txt','a');
F44=fopen('C:\Users\dell\Desktop\yourpath\ciou_reg.txt','a');
for v=1:200
    fprintf(F11, '%d\t',v);
    fprintf(F11, '%f\t',i_x(v));
    fprintf(F11, '%f\t',i_y(v));
    fprintf(F11, '%f\t',i_w(v));
    fprintf(F11, '%f\t',i_h(v));
    fprintf(F11, '%f\n',iii(v));
    fprintf(F22, '%d\t',v);
    fprintf(F22, '%f\t',g_x(v));
    fprintf(F22, '%f\t',g_y(v));
    fprintf(F22, '%f\t',g_w(v));
    fprintf(F22, '%f\t',g_h(v));
    fprintf(F22, '%f\n',ggg(v));
    fprintf(F33, '%d\t',v);
    fprintf(F33, '%f\t',d_x(v));
    fprintf(F33, '%f\t',d_y(v));
    fprintf(F33, '%f\t',d_w(v));
    fprintf(F33, '%f\t',d_h(v));
    fprintf(F33, '%f\n',ddd(v));
    fprintf(F44, '%d\t',v);
    fprintf(F44, '%f\t',c_x(v));
    fprintf(F44, '%f\t',c_y(v));
    fprintf(F44, '%f\t',c_w(v));
    fprintf(F44, '%f\t',c_h(v));
    fprintf(F44, '%f\n',ccc(v));
end
fclose(F11);
fclose(F22);
fclose(F33);
fclose(F44);

%--------------------------the following is to redraw from previous results----------------------------%

% [i1,i2,i3,i4,i5,i6,i7]=textread('C:\Users\dell\Desktop\yourpath\iou-1715k.txt','%d%f%f%f%f%f%f');
% [g1,g2,g3,g4,g5,g6,g7]=textread('C:\Users\dell\Desktop\yourpath\giou-1715k.txt','%d%f%f%f%f%f%f');
% [d1,d2,d3,d4,d5,d6,d7]=textread('C:\Users\dell\Desktop\yourpath\diou-1715k.txt','%d%f%f%f%f%f%f');
% [c1,c2,c3,c4,c5,c6,c7]=textread('C:\Users\dell\Desktop\yourpath\ciou-1715k.txt','%d%f%f%f%f%f%f');
% fxy_iou=zeros(5000,1,'double');
% fxy_giou=zeros(5000,1,'double');
% fxy_diou=zeros(5000,1,'double');
% fxy_ciou=zeros(5000,1,'double');
% for u=1:5000
    % xx(u)=i2(u*343);
    % yy(u)=i3(u*343);
    % for v=1:343
        % n=(u-1)*343+v;
        % fxy_iou(u)=fxy_iou(u)+i7(n);
        % fxy_giou(u)=fxy_giou(u)+g7(n);
        % fxy_diou(u)=fxy_diou(u)+d7(n);
        % fxy_ciou(u)=fxy_ciou(u)+c7(n);
    % end
% end
% tri = delaunay(xx,yy);
% figure,trimesh(tri,xx,yy,fxy_iou); 				%redraw regression error at final iteration 200th from previous results
% figure,trimesh(tri,xx,yy,fxy_giou); 
% figure,trimesh(tri,xx,yy,fxy_diou); 
% figure,trimesh(tri,xx,yy,fxy_ciou); 

% [ii1,ii2,ii3,ii4,ii5,ii6]=textread('C:\Users\dell\Desktop\yourpath\iou_reg.txt','%d%f%f%f%f%f');
% [gg1,gg2,gg3,gg4,gg5,gg6]=textread('C:\Users\dell\Desktop\yourpath\giou_reg.txt','%d%f%f%f%f%f');
% [dd1,dd2,dd3,dd4,dd5,dd6]=textread('C:\Users\dell\Desktop\yourpath\diou_reg.txt','%d%f%f%f%f%f');
% [cc1,cc2,cc3,cc4,cc5,cc6]=textread('C:\Users\dell\Desktop\yourpath\ciou_reg.txt','%d%f%f%f%f%f');
% figure,plot(ii6,'k','LineWidth',1.5);hold on
% plot(gg6,'b','LineWidth',1.5);hold on
% plot(dd6,'r','LineWidth',1.5);hold on
% plot(cc6,'c','LineWidth',1.5),legend('IoU','GIoU','DIoU','CIoU'); 	%redraw regression error sum curve from previous results