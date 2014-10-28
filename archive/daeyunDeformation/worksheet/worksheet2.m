
additionalPoints = [point1(1:6,1:3); point2(1:6,1:3)];
[M Y] = genTpsEq(controlPoints, [controlPoints; additionalPoints], controlPoints+displacements, 0);
X = M\Y;

%%
[M Y] = genPosConst(additionalPoints, [controlPoints; additionalPoints], additionalPoints, 0);

fY = M*X;

%%
Ts = {};
nA = size(additionalPoints, 1)/2;
for i = 1:nA
    p1 = additionalPoints(i,:);
    p2 = additionalPoints(i+nA,:);

    n=normalize(p2-p1);
    center = (p1+p2)/2;
    cpProj = p1 - dot(p1 - center, n) * n;
    T = -eye(4);
    T(1:4, 4) = [2*cpProj 1];

    Ts = [Ts T];
    
    yi = T*[fY(i+nA,:) 1]';
    yj = T*[fY(i,:) 1]';
    
    Y(i, :) = yi(1:3)/yi(4);
    Y(i+nA, :) = yj(1:3)/yj(4);
end


%%
M_=M; Y_=Y;
[M Y] = genTpsEq(controlPoints, [controlPoints; additionalPoints], controlPoints+displacements, 0);
%%
M=[M;M_]; Y=[Y;Y_];

%%
X = M\Y;
fY = M*X;