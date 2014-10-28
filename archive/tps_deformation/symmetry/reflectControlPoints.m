function [cps, ds] = reflectControlPoints(controlPoints, displacements, planes)

controlPoints = controlPoints';
displacements = displacements';

nPlanes = size(planes, 3);
nControlPoints = size(controlPoints, 1);

assert(isequal(size(controlPoints), size(displacements)));

cps = zeros(size(controlPoints));
ds = zeros(size(displacements));

for i = 1:nPlanes

    plane = planes(:,:,i);
    center = plane(:, 1);
    v1 = plane(:, 2);
    v2 = plane(:, 3);
    assert (abs(v1'*v2) < 1e-4)

    planePoints = [-1 -1 1; -1 1 1; 1 1 1; 1 -1 1]*[v1';v2'; center'];

    for j = 1:nControlPoints    

        controlPoint = controlPoints(j, :)';
        displacement = displacements(j, :)';

        % normal vector to the plane
        n = normalize(cross(v1, v2));

        % projection of the control point to the plane
        cpProj = controlPoint - dot(controlPoint - center, n) * n;

        if ~isPointInRectangle(cpProj, planePoints')
            continue
        end

        reflectedControlPoint = 2*cpProj - controlPoint;

        % projection of the displacement vector
        dspProj = displacement - dot(displacement - center, n) * n;
        reflectedDisplacement = 2*dspProj - displacement;
        
        cps(j,:) = reflectedControlPoint';
        ds(j,:) = reflectedDisplacement';

    end

end

cps  = cps';
ds = ds';

end

