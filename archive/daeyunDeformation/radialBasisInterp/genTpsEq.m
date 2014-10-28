function [M, Y] = genTpsEq(interpPts, rbCenters, targetPts, lambda)
% [M, Y] = genTpsEq(rbCenters, targetPts, lambda) - Prepare a
% system of linear equations used for thin-plate-spline interpolation.
%
% rbCenters: [x y z]: n by 3 matrix of radial basis centers.
% targetPts: [x y z]: n by 3 matrix of target points.
% lambda: regularization parameter. See page 4 of [3].
%
% M: n by n. X=M\Y
% Y: n by 1
%
% References:
%   1. http://en.wikipedia.org/wiki/Polyharmonic_spline
%   2. http://en.wikipedia.org/wiki/Thin_plate_spline
%   3. http://cseweb.ucsd.edu/~sjb/pami_tps.pdf
%
% Author:
% Daeyun Shin
% dshin11@illinois.edu  daeyunshin.com
%
% April 2014

assert(isequal(size(interpPts), size(targetPts)), ...
    'ERROR: size(interpPts) must equal size(targetPts).');

nC = size(rbCenters, 1);
nP = size(interpPts, 1);

A = pairwiseTpsRadialBasis(interpPts, rbCenters);

% Regularization.
A = A + lambda * eye(size(A));

V = [ones(nP, 1) interpPts];
VT = [ones(nC, 1) rbCenters]';

% At least d+1 control points should not be in a subspace; e.g. for d=2, at
% least 3 points are not on a straight line. Otherwise M will be singular.
M = [A V; VT zeros(4, 4)];
Y = [targetPts; zeros(4, 3)];



% M = [M; VT zeros(4, 4)];
% Y = [Y; zeros(4, 3)];




end