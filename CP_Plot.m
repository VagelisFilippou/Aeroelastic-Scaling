function CP_Plot(figure_counter,x_fill3,y_fill3,z_fill3,Pressure)
figure(figure_counter)
hold on
%[0 0.4470 0.7410]
fill3(x_fill3,y_fill3,z_fill3,transpose(Pressure),EdgeColor='none')
% plot(Xc,Yc,'b.',LineWidth=2)
% colormap turbo;
cmocean('matter')
c=colorbar;
title(c,'CP','fontweight','bold','Interpreter','latex')
c.Location = 'north';
% c.Position(4) = 0.3*c.Position(4);
c.Position(4) = 0.01;
c.Position(3) = 0.15;
c.Position(1) = 0.4;

% c.Position(1) =0.4;
c.Box='off';
axis equal
axis off
% set(gca,'FontName','Palatino Linotype')
ax = gca;
ax.Clipping = 'off';
set(gca,'FontName','Palatino Linotype')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);