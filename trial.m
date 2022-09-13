clc;
clear all;
clf;
format short g

syms x;
f = @(x) x-cos(x);
g = @(x) cos(x);
dg = matlabFunction(diff(g(x),x));

figure(1)
z = -3:.001:3;
plot(z,z,'-k',z,g(z),'-k',z,0*z,'-r',0*z,g(z),'-r')
hold on;

x = 1.0;
tol =1.0e-15;
px = x;
x = g(x);
line([px,px],[px,x],'color','blue');
line([px,x,],[x,x],'color','blue');
i = 1;
while(abs(px-x)>tol)
   px = x;
   x = g(x);
   line([px,px],[px,x],'color','blue');
    line([px,x,],[x,x],'color','blue');
   i = i+1;
   data = [i  x g(x) f(x)]
   drawnow
end