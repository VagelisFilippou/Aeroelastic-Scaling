function Lift_Distribution(figure_counter,x_fill3,y_fill3,z_fill3)
figure(figure_counter)
hold on
%[0 0.4470 0.7410]
fill3(x_fill3,y_fill3,z_fill3,[0 0 0],'FaceAlpha',0.5)
% plot(Xc,Yc,'b.',LineWidth=2)
axis equal
axis off
% set(gca,'FontName','Palatino Linotype')
ax = gca;
ax.Clipping = 'off';
set(gca,'FontName','Palatino Linotype')
set(gca,'TickLabelInterpreter','latex')
view(-90,25);
zoom(1.4);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);