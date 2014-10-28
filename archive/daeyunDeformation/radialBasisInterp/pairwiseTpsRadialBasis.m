% PAIRWISE_RADIAL_BASIS - Compute the TPS radial basis function phi(r)
% between every row-pair of A and B where r is the Euclidean distance.
%
% Usage:    P = pairwiseTpsRadialBasis(A, B)
%
% Arguments:
%           A - n by d vector containing n d-dimensional points. 
%           B - m by d vector containing m d-dimensional points. 
%
% Returns:
%           P - P(i, j) = phi(norm(A(i,:)-B(j,:))) where
%                         phi(r) = r^2*log(r) for r >= 1
%                                  r*log(r^r) for r <  1
%
% References:
%           1. https://en.wikipedia.org/wiki/Polyharmonic_spline
%           2. https://en.wikipedia.org/wiki/Radial_basis_function
%
% Author:
% Daeyun Shin
% dshin11@illinois.edu  daeyunshin.com
%
% April 2014
function P = pairwiseTpsRadialBasis(A, B)

% R(i, j) is the Euclidean distance between A(i, :) and B(j, :).
R = pdist2(A, B);

iCond1 = R>=1;
iCond2 = R<1;

Rc1 = R(iCond1);
Rc2 = R(iCond2);

P = zeros(size(R));
P(iCond1) = (Rc1.^2) .* log(Rc1);
P(iCond2) = Rc2 .* (log(Rc2.^Rc2));


%iCond1 = R>=1;
%iCond2 = R<1;

%Rc1 = R(iCond1);
%Rc2 = R(iCond2);

%P = zeros(size(R));
%P(iCond1) = 0 .* log(Rc1);
%P(iCond2) = Rc2 .* (log(Rc2.^Rc2));

end
