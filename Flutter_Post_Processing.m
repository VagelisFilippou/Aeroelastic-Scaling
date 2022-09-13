% clear all 
close all 
clc

% h5data=h5extract('ucrm_flutter_ref.h5');
h5data=h5extract('ucrm_sol_145.h5');

Points=h5data.NASTRAN.RESULT.AERODYNAMIC.FLUTTER.POINT.NUM(end);
N_V=length(h5data.NASTRAN.RESULT.AERODYNAMIC.FLUTTER.SUMMARY.DAMPING)/Points;

Damping=reshape(h5data.NASTRAN.RESULT.AERODYNAMIC.FLUTTER.SUMMARY.DAMPING,[N_V,Points]);
Velocity=reshape(h5data.NASTRAN.RESULT.AERODYNAMIC.FLUTTER.SUMMARY.VELOCITY,[N_V,Points]);
Frequency=reshape(h5data.NASTRAN.RESULT.AERODYNAMIC.FLUTTER.SUMMARY.FREQUENCY,[N_V,Points]);

figure(1)
plot(Velocity(:,1:6),Frequency(:,1:6),LineWidth=2)
% title(['Normalized Transverse Displacements for Each Mode (1-5)'])
xlabel('Velocity [ft/s]','Interpreter','latex')
ylabel('Frequency [Hz]','Interpreter','latex')
legend({'Mode 1','Mode 2','Mode 3','Mode 4','Mode 5','Mode 6'} ...
    ,Interpreter='latex') 
grid on
xlim([Velocity(1,1) Velocity(end,1)])
legend Location south
legend Orientation horizontal 
set(gca,'TickLabelInterpreter','latex')

figure(2)
plot(Velocity(:,1:6),Damping(:,1:6),LineWidth=2)
% title(['Normalized Transverse Displacements for Each Mode (1-5)'])
xlabel('Velocity [ft/s]','Interpreter','latex')
ylabel('Damping','Interpreter','latex')
legend({'Mode 1','Mode 2','Mode 3','Mode 4','Mode 5','Mode 6'} ...
    ,Interpreter='latex') 
grid on
xlim([Velocity(1,1) Velocity(end,1)])
legend Location south
legend Orientation horizontal 
set(gca,'TickLabelInterpreter','latex')
