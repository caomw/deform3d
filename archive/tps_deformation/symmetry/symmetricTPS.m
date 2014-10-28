function [mapping_coeffs, poly_coeffs] = ...
    symmetricTPS(control_points, displacements, lambda, planes)

p = size(control_points, 1);
d = size(control_points, 2);

assert(isequal(size(control_points), size(displacements)), ...
    'ERROR: size(control_points) must equal size(displacements).');

% This correcponds to the matrix A from [1].
A = pairwise_radial_basis(control_points, control_points);

% Relax the exact interpolation requirement by means of regularization. [3]
A = A + lambda * eye(size(A));

% This correcponds to V from [1].
V = [ones(p, 1), control_points]';

% Target points.
y = control_points + displacements;

M = [[A, V']; [V, zeros(d+1, d+1)]];
Y = [y;zeros(d+1, d)];

% solve for M*X = Y.
% At least d+1 control points should not be in a subspace; e.g. for d=2, at
% least 3 points are not on a straight line. Otherwise M will be singular.
X = M\Y;

mapping_coeffs = X(1:end-(d+1),:);
poly_coeffs = X((end-d):end,:);

end