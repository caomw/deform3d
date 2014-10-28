function [deformedMesh] = applyDeformation(Mesh, rbCenters, symPts, W)

points = Mesh.v;

assert(max(size(points)) > 3);

if size(points, 2) ~= 3
    points = points';
    warning('applyDeformation: input size should be n by 3');
end

assert(size(points, 2) == 3);


nP = size(points, 1);

% A = pairwiseTpsRadialBasis(points, [rbCenters; symPts(:,1:3); symPts(:,4:6)]);
A = pairwiseTpsRadialBasis(points, rbCenters);
V = [ones(nP, 1) points];

M = [A V];
Y = M*W;

deformedMesh = struct('v', Y, 'f', Mesh.f);

end