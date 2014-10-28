function [X, rbNodes, fSymTargetPts, tfSymSourcePts] = tpsInterp(sourcePts, targetPts, symPairs, weights)

if nargin < 3
    sz=size(sourcePts);
    L=pairwiseTpsRadialBasis(sourcePts, sourcePts);
    P=[ones(sz(1),1) sourcePts];
    A=[L P; P' zeros(sz(2)+1)];
    X=A\[targetPts;zeros(sz(2)+1,sz(2))];
    return
end

sz=size(sourcePts);
ssz=size(symPairs);
lambda = 0.08;
L=pairwiseTpsRadialBasis(sourcePts, sourcePts)+lambda*eye(sz(1));
P=[ones(sz(1),1) sourcePts];
A=[L P;P' zeros(sz(2)+1)];
X=A\[targetPts;zeros(sz(2)+1,sz(2))];





deformFunc = @(pts) [pairwiseTpsRadialBasis(pts, sourcePts) ones(size(pts,1),1) pts]*X;

[deformFunc, X] = fixSymmetry2(sourcePts, targetPts, symPairs, deformFunc, X, lambda, true);

[deformFunc, X] = fixSymmetry2(sourcePts, targetPts, symPairs, deformFunc, X, lambda, true);

[deformFunc, X] = fixSymmetry2(sourcePts, targetPts, symPairs, deformFunc, X, lambda, true);

[deformFunc, X] = fixSymmetry2(sourcePts, targetPts, symPairs, deformFunc, X, lambda, true);

[deformFunc, X] = fixSymmetry2(sourcePts, targetPts, symPairs, deformFunc, X, lambda, true);


[deformFunc, X] = fixSymmetry2(sourcePts, targetPts, symPairs, deformFunc, X, lambda, true);

[deformFunc, X] = fixSymmetry2(sourcePts, targetPts, symPairs, deformFunc, X, lambda, true);

[deformFunc, X] = fixSymmetry2(sourcePts, targetPts, symPairs, deformFunc, X, lambda, true);

[deformFunc, X] = fixSymmetry2(sourcePts, targetPts, symPairs, deformFunc, X, lambda, true);

[deformFunc, X] = fixSymmetry2(sourcePts, targetPts, symPairs, deformFunc, X, lambda, true);


[deformFunc, X] = fixSymmetry2(sourcePts, targetPts, symPairs, deformFunc, X, lambda, true);

[deformFunc, X] = fixSymmetry2(sourcePts, targetPts, symPairs, deformFunc, X, lambda, true);

[deformFunc, X] = fixSymmetry2(sourcePts, targetPts, symPairs, deformFunc, X, lambda, true);

[deformFunc, X] = fixSymmetry2(sourcePts, targetPts, symPairs, deformFunc, X, lambda, true);

[deformFunc, X] = fixSymmetry2(sourcePts, targetPts, symPairs, deformFunc, X, lambda, true);







end


function [newDeformFunc, newX] = fixSymmetry(sourcePts, targetPts, symPairs, deformFunc, X, lambda, isDisplayMode)

sz=size(sourcePts);
ssz=size(symPairs);

minDist1 = min(pdist2(symPairs(:,1:end/2),sourcePts),[],2);
minDist2 = min(pdist2(symPairs(:,end/2+1:end),sourcePts),[],2);

symSourcePts = symPairs(:,1:end/2);
symTargetPts = symPairs(:,end/2+1:end);

for i = 1:ssz(1)
    if minDist1(i) > minDist2(i)
        symSourcePts(i,:) = symPairs(i,1:end/2);
        symTargetPts(i,:) = symPairs(i,end/2+1:end);
    end
end

midPts = 0.5*(symSourcePts+symTargetPts);
midPtToTarget = midPts+1.7*(symTargetPts-midPts);


fSymSourcePts = deformFunc(symSourcePts);
fMidPts = deformFunc(midPts);
fMidPtToTarget = deformFunc(midPtToTarget);

fSymTargetPts = deformFunc(symTargetPts);
tfSymSourcePts = reflectPoints(fSymSourcePts, fMidPts, fMidPtToTarget);

pweights = repmat(pairwiseTpsRadialBasis(symSourcePts, sourcePts),[1 1 sz(2)]).*repmat(reshape(X(1:sz(1),:),[1 sz(1) sz(2)]),[ssz(1),1,1]);
pweights = sum(pweights.^2,3);
[pmax pI] = max(pweights,[],2);

pIHist = zeros(numel(pI),1);
for i=1:numel(pI)
    pIHist(pI(i))=pIHist(pI(i))+1;
end

symNodes = [];
[prmax prI] = max(pweights,[],1);
for i=1:numel(pIHist)
%     if pIHist(i) > 0.3*sz(1) || pIHist(i) > 5
    if 1
        symNodes = [symNodes;reflectPoints(sourcePts(pI(i),:), midPts(prI(i),:), midPtToTarget(prI(i),:))];
    end
end

snsz = size(symNodes);
stsz = size(symTargetPts);

L=pairwiseTpsRadialBasis([sourcePts; fSymTargetPts], [sourcePts; symNodes]) + lambda*eye(size([sourcePts; fSymTargetPts],1), size([sourcePts; symNodes],1));
P=[ones(sz(1)+stsz(1),1) [sourcePts; fSymTargetPts]];
P2=[ones(sz(1)+snsz(1),1) [sourcePts; symNodes]];
A=[L P; P2' zeros(sz(2)+1)];

wt=ones(sz(1)+stsz(1), 1);
wt(sz(1)+1:sz(1)+stsz(1)) = 0.001;
zs=eye(size(A,1));
zs(1:numel(wt), 1:numel(wt))=diag(wt);
wt=zs;

X=(A'*wt*A)\(A'*wt*[targetPts; tfSymSourcePts;zeros(sz(2)+1, sz(2))]);
rbNodes=[sourcePts; symNodes];


newDeformFunc = @(pts) [pairwiseTpsRadialBasis(pts, [sourcePts; symNodes]) ones(size(pts,1),1) pts]*X;
newX = X;


if isDisplayMode
    
    pts = [];
    for x = 0:1/12:1
        for y = 0:1/12:1
            pts = [pts; [y, x]];
        end
    end
    %%
    figure;
    hold on;
    axis([-0.1; 1.1; -0.1; 1.1]);
    axis square;
    
    drawPoint(deformFunc(pts), 'color', 'black', 'marker', '.', 'markersize', 10);
    drawPoint(targetPts, 'color', 'blue', 'marker', 'o', 'markersize', 10);
    drawPoint(deformFunc(sourcePts), 'color', 'red', 'marker', 'x', 'markersize', 10);
    %%
    drawEdge([fSymSourcePts fSymTargetPts], 'color', 'cyan');
    drawPoint(fSymTargetPts, 'color', 'magenta', 'marker', 'x', 'markersize', 10);
    %%
    drawEdge([fSymSourcePts tfSymSourcePts], 'color', 'green');
    drawPoint(tfSymSourcePts, 'color', 'magenta', 'marker', 'o', 'markersize', 10);    
    drawPoint(symNodes, 'color', 'green', 'marker', '+', 'markersize', 10);    
end


end






function [newDeformFunc, newX] = fixSymmetry2(sourcePts, targetPts, symPairs, deformFunc, X, lambda, isDisplayMode)

sz=size(sourcePts);
ssz=size(symPairs);

minDist1 = min(pdist2(symPairs(:,1:end/2),sourcePts),[],2);
minDist2 = min(pdist2(symPairs(:,end/2+1:end),sourcePts),[],2);

symSourcePts = symPairs(:,1:end/2);
symTargetPts = symPairs(:,end/2+1:end);

for i = 1:ssz(1)
    if minDist1(i) > minDist2(i)
        symSourcePts(i,:) = symPairs(i,1:end/2);
        symTargetPts(i,:) = symPairs(i,end/2+1:end);
    end
end

midPts = 0.5*(symSourcePts+symTargetPts);
midPtToTarget = midPts+1.7*(symTargetPts-midPts);


fSymSourcePts = deformFunc(symSourcePts);
fMidPts = deformFunc(midPts);
fMidPtToTarget = deformFunc(midPtToTarget);

fSymTargetPts = deformFunc(symTargetPts);
tfSymSourcePts = reflectPoints(fSymSourcePts, fMidPts, fMidPtToTarget);

pweights = repmat(pairwiseTpsRadialBasis(symSourcePts, sourcePts),[1 1 sz(2)]).*repmat(reshape(X(1:sz(1),:),[1 sz(1) sz(2)]),[ssz(1),1,1]);
pweights = sum(pweights.^2,3);
[pmax pI] = max(pweights,[],2);

pIHist = zeros(numel(pI),1);
for i=1:numel(pI)
    pIHist(pI(i))=pIHist(pI(i))+1;
end

symNodes = fSymTargetPts;

snsz = size(symNodes);
stsz = size(symTargetPts);

L=pairwiseTpsRadialBasis([sourcePts; fSymTargetPts], [sourcePts; symNodes]) + lambda*eye(size([sourcePts; fSymTargetPts],1), size([sourcePts; symNodes],1));
P=[ones(sz(1)+stsz(1),1) [sourcePts; fSymTargetPts]];
P2=[ones(sz(1)+snsz(1),1) [sourcePts; symNodes]];
A=[L P; P2' zeros(sz(2)+1)];

wt=ones(sz(1)+stsz(1), 1);
wt(sz(1)+1:sz(1)+stsz(1)) = 0.7;
zs=eye(size(A,1));
zs(1:numel(wt), 1:numel(wt))=diag(wt);
wt=zs;

X=(A'*wt*A)\(A'*wt*[targetPts; tfSymSourcePts;zeros(sz(2)+1, sz(2))]);
rbNodes=[sourcePts; symNodes];


newDeformFunc = @(pts) [pairwiseTpsRadialBasis(pts, [sourcePts; symNodes]) ones(size(pts,1),1) pts]*X;
newX = X;


if isDisplayMode
    
    pts = [];
    for x = 0:1/12:1
        for y = 0:1/12:1
            pts = [pts; [y, x]];
        end
    end
    %%
    figure;
    hold on;
    axis([-0.1; 1.1; -0.1; 1.1]);
    axis square;
    
    drawPoint(deformFunc(pts), 'color', 'black', 'marker', '.', 'markersize', 10);
    drawPoint(targetPts, 'color', 'blue', 'marker', 'o', 'markersize', 10);
    drawPoint(deformFunc(sourcePts), 'color', 'red', 'marker', 'x', 'markersize', 10);
    %%
    drawEdge([fSymSourcePts fSymTargetPts], 'color', 'cyan');
    drawPoint(fSymTargetPts, 'color', 'magenta', 'marker', 'x', 'markersize', 10);
    %%
    drawEdge([fSymSourcePts tfSymSourcePts], 'color', 'green');
    drawPoint(tfSymSourcePts, 'color', 'magenta', 'marker', 'o', 'markersize', 10);    
    drawPoint(symNodes, 'color', 'red', 'marker', '+', 'markersize', 10);    
end


end