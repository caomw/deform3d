controlPoints = rand(3, 4)*4;
displacements = 0.5-rand(3, 4);

cyl = [0 0 0 -7 7 7 5];

figure(1); clf;

displayControlPoints(controlPoints, displacements);
displayCylinders(cyl);


for i = 1:9

    theta = pi/5*i;
    [cps, ds] = rotateControlPoints(controlPoints, displacements, cyl', theta);

    displayControlPoints(cps, ds, 'r');

end

alpha(0.2);