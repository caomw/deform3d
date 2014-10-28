% function [W, M, Y] = iterSymTpsInterp(sourcePts, targetPts, symPts)
%%
% sourcePts = controlPoints;
% targetPts = controlPoints+displacements;
% symPts = [point1 point2];
%%
% initialize variables
nSym = size(symPts, 1);
nSc = size(sourcePts, 1);
T0 = cell(nSym, 1); % cell array of known transformations
allPts = [sourcePts; symPts(:,1:3); symPts(:,4:6)];
itmax=50;

% reflective affine transformation matrix for each sym pair.
for iSym = 1:nSym
    T0{iSym} = refAffineMat(symPts(iSym,1:3), symPts(iSym,4:6));
end

% fit without symmerty contraints first
[M, Y] = genTpsEq(sourcePts, sourcePts, targetPts, 9999999999);

symYOffset = nSc;

W=M\Y;
%%
% [M, Y] = genTpsEq(allPts, allPts, [targetPts; zeros(nSym*2, 3)], 0);
[M, Y] = genTpsEq(allPts, sourcePts, [targetPts; zeros(nSym*2, 3)], 9999999999);
fx = M*W;


for iSym = 1:nSym
    T0{iSym} = refAffineMat(fx(symYOffset+iSym,1:3), fx(symYOffset+iSym+nSym,1:3));
end

%%
[M, Y] = genTpsEq(sourcePts, sourcePts, targetPts, 0);
fx = M*W;
W=M\Y;

%%
[M, ~] = genTpsEq([symPts(:,1:3); symPts(:,4:6)], sourcePts, zeros(nSym*2, 3), 0);
fx = M*W;


%%
[M, Y] = genTpsEq(allPts, sourcePts, [targetPts; fx(1:end-4,:)], 0);
fx = M*W;



W=M\Y;

%%

% [M, Y] = genTpsEq(allPts, sourcePts, [targetPts; fx(1:end-4,:)], 0);
% fx = M*W;


%%
prevY = Y;
dY = zeros(itmax, 1);
% Iterate until we find a transformation Tf satisfying Tf*f(x)=f(T0*x).
for i = 1:itmax
    if i > 1
        fx = M*W;
    end
    i
    for iSym = 1:nSym

        if i == 1
            Tf = T0{iSym}; % Start with Tf = T0.
        else
            Tf = refAffineMat(fx(symYOffset+iSym,:), fx(symYOffset+iSym+nSym,:));
        end

        yi = transformAffine(Tf, fx(symYOffset+iSym,:));
        yj = transformAffine(Tf, fx(symYOffset+iSym+nSym,:));
        Y(symYOffset+iSym, :) = yj;
        Y(symYOffset+iSym+nSym, :) = yi;
    end

    if i == 1
        [M, ~] = genTpsEq(allPts, allPts, [targetPts; zeros(nSym*2, 3)], 0);
        A=eye(size(M));
        A(1:13,1:13)=0;
        M(A==1) = 100;
    end

    W=M\Y;

    if sum(dY(max(1, i-3):i)) < 1e-4 && i > 3, break; end
    if i == itmax, warning('Iteration did not converge in itmax=%d.', itmax); end
    dY(i) = sum((Y(:)-prevY(:)).^2); prevY=Y;
end


%%

% A=eye(size(M));
% A;
% M(A==1) = 1000;
% W=M\Y;
%%
deformed_mesh = applyDeformation(chair1, allPts, symPts, W);
figure, displayMesh(deformed_mesh, params);

    
%%
% deformed_mesh = applyDeformation(chair1, sourcePts, symPts, W);
% figure, displayMesh(deformed_mesh, params);




% end