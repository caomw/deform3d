function fPts = reflectPoints(pts, midPts, midPtToTarget)
    n=normr(midPtToTarget-midPts);
    proj = pts - repmat(sum((pts - midPts).*n,2),[1 size(n, 2)]) .* n;
    fPts=-pts+2*proj;
end
