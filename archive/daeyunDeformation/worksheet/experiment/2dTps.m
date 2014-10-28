%%
figure(1);
hold on;
drawPoint(pts, 'color', 'black', 'marker', '.', 'markersize', 10);
drawPoint(P1, 'color', 'red', 'marker', 'x', 'markersize', 10);
drawPoint(P2, 'color', 'blue', 'marker', 'o', 'markersize', 10);
axis([-0.1; 1.1; -0.1; 1.1]);
axis square;
% set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');

%% TPS + positional
n = size(P1, 1);
A = pairwiseTpsRadialBasis(P1, P1);

M=...
[A              [ones(n, 1) P1]
[[ones(n, 1) P1]' zeros(3, 3)]];
Y=[P2;zeros(3, 2)];
w=M\Y;

%%


%%
symPair = [
    0.1 0.1 0.9 0.1
    0.1 0.4 0.9 0.4
    0.1 0.6 0.9 0.6
    0.1 0.7 0.9 0.7
    0.1 0.9 0.9 0.9
    ];

drawEdge(symPair, 'color', 'cyan');


pa=[0.2 0.7];
pb=[0.8 0.7];
mid = (pa+pb)/2;
nm = normalize(pb-mid);
a=zeros(3);
a(1:2,1:2) = 2*nm'*nm;
a=eye(3)-a;
t=eye(3);
t(1,3)=-mid(1);
t(2,3)=-mid(2);

t_=eye(3);
t_(1,3)=mid(1);
t_(2,3)=mid(2);

r=t_*a*t;

drawPoint(pa, 'color', 'magenta', 'marker', '.', 'markersize', 10)
drawPoint(mid, 'color', 'yellow', 'marker', '.', 'markersize', 10)
a1 = r*[pb';1];
drawPoint(a1(1:2)', 'color', 'red', 'marker', '.', 'markersize', 10);



%% TPS transform
getM = @(p) [pairwiseTpsRadialBasis(p, P1) [ones(size(p, 1), 1) p]];

fPts = getM(pts)*w;
fP1 = getM(P1)*w;
fP2 = getM(P2)*w;

%%
% w=tpsInterp(P1, P2, ones(1, n+3));
[w,rbCenters, symTargetPts, tfSymSourcePts]=tpsInterp(P1, P2, symPair);
fPts = tpsDeform(pts, rbCenters, w);
fP1 = tpsDeform(P1, rbCenters, w);



figure;
hold on;
drawPoint(fPts, 'color', 'black', 'marker', '.', 'markersize', 10);
drawPoint(fP1, 'color', 'red', 'marker', 'x', 'markersize', 10);
drawPoint(P2, 'color', 'blue', 'marker', 'o', 'markersize', 10);

drawEdge([symTargetPts tfSymSourcePts], 'color', 'cyan')
drawPoint(tfSymSourcePts, 'color', 'blue', 'marker', 'o', 'markersize', 10);

axis([-0.1; 1.1; -0.1; 1.1]);
axis square;%


%% w=tpsInterp(P1, P2, ones(1, n+3));

% [w]=tpsInterp(P1(1:3,:), P2(1:3,:), symPair);
[w,rbCenters, fSymTargetPts, tfSymSourcePts]=tpsInterp(P1(1:4,:), P2(1:4,:), symPair);
fPts = tpsDeform(pts, rbCenters, w);
fP1 = tpsDeform(P1(1:4,:), rbCenters, w);



figure;
hold on;
drawPoint(fPts, 'color', 'black', 'marker', '.', 'markersize', 10);
drawPoint(fP1, 'color', 'red', 'marker', 'x', 'markersize', 10);
drawPoint(P2(1:5,:), 'color', 'red', 'marker', 'o', 'markersize', 10);
drawPoint(rbCenters, 'color', 'magenta', 'marker', 'x', 'markersize', 10);

drawEdge([fSymTargetPts tfSymSourcePts], 'color', 'cyan')
drawPoint(tfSymSourcePts, 'color', 'blue', 'marker', 'o', 'markersize', 10);

axis([-0.1; 1.1; -0.1; 1.1]);
axis square;