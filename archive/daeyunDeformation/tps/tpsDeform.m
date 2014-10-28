function fPts = tpsDeform(pts, controlPts, X)

sz=size(pts);
L=pairwiseTpsRadialBasis(pts, controlPts);
P=[ones(sz(1),1) pts];
A=[L P];

fPts=A*X;

end
