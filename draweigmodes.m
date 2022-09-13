function draweigmodes(V,eighz,xxplot,yyplot,unodes,mseed,prescribeddof,nml)
myorange=[0.8500 0.3250 0.0980]	;
numplot=10;
Vmodx=V(1:5:end,1:numplot);
Vmody=V(2:5:end,1:numplot);
Vmodz=V(3:5:end,1:numplot);

for i = 1:numplot
    Vmod2x=[zeros(length(prescribeddof(1:5:end)),1);Vmodx(:,i)];
    Vmod2y=[zeros(length(prescribeddof(2:5:end)),1);Vmody(:,i)];
    Vmod2z=[zeros(length(prescribeddof(3:5:end)),1);Vmodz(:,i)];
       
    Vmod1x(:,i)=Vmod2x(unodes);
    Vmod1y(:,i)=Vmod2y(unodes);
    Vmod1z(:,i)=Vmod2z(unodes);
end

filepch='fe_2_nm_out2.pch';
fid3=fopen(filepch);
data2=textscan(fid3,'%s', 'delimiter','\n','whitespace', '');
count2=1;
nodesus=gridus;
nodesls=gridls;

sf=10;
delimiters=[8 42887;42894 85774;85782 128661;128669 171548;171556 214435;214443 257322;257330 300209;300217 343096;343104 385983;385991 428870];

for kk=1:10
    del1=delimiters(kk,1);
    del2=delimiters(kk,2);
for k=del1:2:del2
    gg=strsplit(data2{1}{k});
    dispx=str2double(gg(4));
    dispy=str2double(gg(5));
    dispz=str2double(gg(6));

    grdid=str2double(gg(2));
    [a1,b1]=find(grdid==nodesus);
    [a2,b2]=find(grdid==nodesls);

    count2=count2+1;
    if ~isempty(a1) && ~isempty(b1) 
       if isempty(a2)==1
      modeusx{kk}(a1,b1)=dispx;
      modeusy{kk}(a1,b1)=dispy;
      modeusz{kk}(a1,b1)=dispz;

       else
      modeusx{kk}(a1,b1)=dispx;
      modeusy{kk}(a1,b1)=dispy;
      modeusz{kk}(a1,b1)=dispz;      
      modelsx{kk}(a2,b2)=dispx;
      modelsy{kk}(a2,b2)=dispy;
      modelsz{kk}(a2,b2)=dispz;       
       end
    elseif ~isempty(a2) && ~isempty(b2) 
      
      modelsx{kk}(a2,b2)=dispx;
      modelsy{kk}(a2,b2)=dispy;
      modelsz{kk}(a2,b2)=dispz;
    end
end
bux=find(modeusx{kk}==1);
blx=find(modelsx{kk}==1); 
buy=find(modeusy{kk}==1);
bly=find(modelsy{kk}==1);

if isempty(bux) && isempty(blx)
   if isempty(buy)   && isempty(bly)
    mode='z';
    vecx =0*Vmod1x(:,kk) ;
    vecy =0*Vmod1y(:,kk);
    vecz =Vmod1z(:,kk)./(max(abs(Vmod1z(:,kk)))) ;
    
     modevecux=0*modeusx{kk};
    modevecuy=0*modeusy{kk};
    modevecuz1=modeusz{kk};
maxmodeu=max(max(modevecuz1));
    modevecuz=modevecuz1./(abs(maxmodeu));

    modeveclx=0*modeusx{kk};
    modevecly=0*modelsy{kk};
modeveclz1=modelsz{kk};
maxmodel=max(max(modevecuz1));
    modeveclz=modeveclz1./(abs(maxmodel));   
   else
   mode='y';
     vecx =0*Vmod1x(:,kk) ;
    vecy =Vmod1y(:,kk)./(max(abs(Vmod1y(:,kk))));
    vecz =0*Vmod1z(:,kk);
    
     modevecux=0*modeusx{kk};
    modevecuy=modeusy{kk};
    modevecuz=0*modeusz{kk};

    modeveclx=0*modeusx{kk};
    modevecly=modelsy{kk};
    modeveclz=0*modelsz{kk};
   end
else
    mode='x';
    vecx=Vmod1x(:,kk)./(max(abs(Vmod1x(:,kk)))) ;
    vecy =0*Vmod1y(:,kk);
    vecz =0*Vmod1z(:,kk);
    
     modevecuy=0*modeusy{kk};
    modevecuz=0*modeusz{kk};
    modevecux1=modeusx{kk};
   maxmodeu=max(max(modevecux1));
    modevecux=modevecux1./(abs(maxmodeu));
    
     modevecly=0*modelsy{kk};
    modeveclz=0*modelsz{kk};
    modeveclx1=modeusx{kk};
     maxmodel=max(max(modeveclx1));
    modeveclx=modeveclx1./(abs(maxmodel));
    
end
vecpx=reshape(vecx,[mseed(1,1)+1  mseed(1,2)+mseed(2,2)+1]);
vecpy=reshape(vecy,[mseed(1,1)+1  mseed(1,2)+mseed(2,2)+1]);
vecpz=reshape(vecz,[mseed(1,1)+1  mseed(1,2)+mseed(2,2)+1]);
%% Plots
subplot(1,4,kk-6)
myblue=1/255*[0, 51, 102];
mypurple=1/255*[46, 26, 71];
if kk~=5 && kk~=7 && kk~=10
sf=0.3;
sfz=0.3;
else
 sf=0.3;
 sfz=-0.3;
end
h1=surf(Xus,Yus,Zus,'FaceColor','[0.5 0.5 0.5]	','FaceAlpha',1,'EdgeAlpha',0,'LineStyle','-');
hold on
h2=surf(Xls,Yls,Zls,'FaceColor','[0.5 0.5 0.5]	','FaceAlpha',1,'EdgeAlpha',0,'LineStyle','-');
hold on
h3=surf(Xus+0.2*modevecux,Yus+sf*modevecuy,Zus+0.1*modevecuz,'FaceAlpha',1,'EdgeAlpha',1);
hold on
h5=surf(Xls+0.2*modeveclx,Yls+sf*modevecly,Zls+0.1*modeveclz,'FaceAlpha',1,'EdgeAlpha',1);
hold on
h4=surf(xxplot+sf*vecpx,yyplot+sf*vecpy,0.2*vecpz,'FaceAlpha',1);
title({['Mode Number ',num2str(kk)];['NASTRAN = ',num2str(nm_nas(kk)),'Hz'];['EPM = ',num2str( eighz(kk)),'Hz']},'interpreter', 'latex','FontSize',15);
set(get(gca,'title'),'Position',[1 2 0.5])
%   set(get(gca,'title'),'Position',[13 15 4])
xlim([0 5])
ylim([0 5])
zlim([-0.5 0.5])
set(gca,'visible','off')
set(findall(gca, 'type', 'text'), 'visible', 'on');
set(gcf,'color','w')
view( -60,30)
ax = gca;               % get the current axis
ax.Clipping = 'off';    % turn clipping off
hold on
if kk==1 || kk==4 || kk==7 
mArrow3([-1.3 0 0],[-1 0 0 ],'stemWidth',.005,'FaceAlpha',1,'color','r')
hold on
mArrow3([-1.3 0 0],[-1.3 0.3 0],'stemWidth',.005,'FaceAlpha',1,'color','b')
hold on
mArrow3([-1.3 0 0],[-1.3 0 0.16],'stemWidth',.006,'FaceAlpha',1,'color','g')
text(-1 ,0 ,0,'x','interpreter','latex','FontSize',20)
text(-1.55 ,0.2 ,0,'y','interpreter','latex','FontSize',20)
text(-1.28 ,0 ,.15,'z','interpreter','latex','FontSize',20)
end
end
print(gcf,'tc2_nm_3.png','-dpng','-r300');    
% mArrow3([-5 0 0],[-4 0 0 ],'stemWidth',.02,'FaceAlpha',1,'color','r')
% hold on
% mArrow3([-5 0 0],[-5 1 0],'stemWidth',.02,'FaceAlpha',1,'color','b')
% hold on
% mArrow3([-5 0 0],[-5 0 1],'stemWidth',.02,'FaceAlpha',1,'color','g')
% text(-4 ,0 ,0,'x','interpreter','latex','FontSize',20)
% text(-5.5 ,1 ,0,'y','interpreter','latex','FontSize',20)
% text(-5.5 ,0 ,1,'z','interpreter','latex','FontSize',20)
h= legend([h1,h2,h3], {'CRM - Outer Mold Line','CRM - Mode Shape','CRM - Equivalent Plate'},'interpreter','latex');
set(h,'FontSize',15)

