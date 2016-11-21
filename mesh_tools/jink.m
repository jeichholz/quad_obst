x=[4 6 1]';
xproj=[0 x(2) x(3)];
costheta=dot(xproj,[0 1 0])/norm(xproj);

theta=acos(costheta);
R=rotate_about_x(theta); 
xprime=R*x; 
%rotate it by theta
%find angle beteween x and xprime
xprime
