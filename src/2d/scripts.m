%%
M = importMeshDir('/Users/daeyun/Documents/MATLAB/thesisMisc/mesh/')
%%
for i = 1:numel(M)

    f=figure('visible', 'off');

    hold on;
    axis equal;
    grid off;
    box off;

    v = [1 1 1];
    view(v);

    cameratoolbar('Show');
    cameratoolbar('SetMode', 'orbit');
    cameratoolbar('SetCoordSys', 'y');

    xlabel('');
    ylabel('');
    zlabel('');

    axis off;

    display3d(M{i});

    set(gca, 'XTick',[]);
    set(gca, 'YTick',[]);
    set(gca, 'ZTick',[]);

    % set(f, 'Color', 'none');
    % export_fig(f, 'thesisMisc/2d/1.png', '-q600', '-transparent');
    saveTightFigure(f, ['thesisMisc/2d/' num2str(i) '.png']);
    close(f);
end


%%

num = 7;

figure
im=imread(['thesisMisc/2d/' num2str(num) '.png']);
imshow(im);

figure
displayMesh(M{num});

v = [6 1 1];
view(v);
cameratoolbar('Show');
cameratoolbar('SetMode', 'orbit');
cameratoolbar('SetCoordSys', 'y');

%%
num=20;
figure
displayMesh(M{num});
clickA3DPoint(M{num}.v');




%%
files = rdir(fullfile('thesisMisc/2dMatch/*.txt'));
corMesh = {};
Matches = {};
MeshName = {};
Obj2d = {};

for i = 1:numel(files)
    filename = regexp(files(i).name, '/([^/]+).txt$', 'once', 'ignorecase', 'tokens');
    Matches{i}=importdata(files(i).name);
    corMesh{i} = M{str2num(filename{:})};
    MeshName{i} = filename{:};
    Obj2d{i} = imread(sprintf('thesisMisc/2d/%s.png', filename{:}));
end

%%



i=4;
corMesh{i};
Matches{i};
MeshName{i}

figure;
displayMesh(corMesh{i});

v = [6 1 1];
view(v);
cameratoolbar('Show');
cameratoolbar('SetMode', 'orbit');
cameratoolbar('SetCoordSys', 'y');

for j = 1:numel(Matches{i})
    m=Matches{i}(j);
    drawPoint3d(corMesh{i}.v(m,:), 'marker', '.', 'markersize', 50, 'color', 'r')
    
    text(corMesh{i}.v(m,1), corMesh{i}.v(m,2), corMesh{i}.v(m,3),sprintf('%d, %d', j, m),'HorizontalAlignment','left','FontSize',20,'color','blue');
end

figure
hold on;
imshow(Obj2d{i})
cameratoolbar('Show');
cameratoolbar('SetMode', 'orbit');
cameratoolbar('SetCoordSys', 'y');

for j = 1:numel(Matches{i})
    fprintf('select %d, %d:\n', j, Matches{i}(j));
    [x, y] = ginput(1);
    fprintf('%d, %d\n', x, y);
    drawPoint(x, y, 'marker', '.', 'markersize', 50, 'color', 'r');
    points2d{i}(j,:)=[x y];
end



% w = waitforbuttonpress;
% if w == 0
%     disp('Button click')
% else
%     disp('Key press')
% end
% [x,y] = ginput(1)


%%
clear all; close all; clc
%Generate a surface to plot in 3d
z=peaks;
%Generate an image to plot on the xy plane (z=0)
imOnXY=rand([size(peaks,1),size(peaks,2),3]);
figure(1);
%Show the image
x=zeros(100,100);
hold on
surface(x,imOnXY,'FaceColor','texturemap','EdgeColor','none','CDataMapping','direct')
axis on
view(-35,45)






%%
i=3;
figure;
im=Obj2d{i};
x=[0 0; 0 0];
hold on

xImage = [0 1; 0 1];   %# The x data for the image corners
yImage = [0 0; 1 1];             %# The y data for the image corners
zImage = [0 0; 0 0];   %# The z data for the image corners
surf(xImage,yImage,zImage,...    %# Plot the surface
     'CData',im,...
     'FaceColor','texturemap','CDataMapping','direct');

axis on;
view([0 0 -1]);

[h,w,~]=size(Obj2d{i});

pts = bsxfun(@rdivide, points2d{i}, [w, h]);

pts = [pts, zeros(size(pts,1),1)];

m=Matches{i};
pts3d = corMesh{i}.v(m,:);

lines = repmat([0 0 1], [size(pts,1), 1]);
interp = Interpolation(pts3d, pts, 0).interpolate2D();

fv = interp.apply(corMesh{i}.v);

fMesh.v = fv;
fMesh.f = corMesh{i}.f;

original = corMesh{i};
original.v = bsxfun(@minus, [1 0 1.5], bsxfun(@plus, original.v, [0 -1 0.4]));
fMesh.v = bsxfun(@plus, fMesh.v, [0 0 -0.4]);
pts3d = bsxfun(@minus, [1 0 1.5], bsxfun(@plus, pts3d, [0 -1 0.4]));

drawPoint3d(pts,'marker','.','markersize', 10, 'color', 'r');
drawPoint3d(pts3d,'marker','.','markersize', 10, 'color', 'b');
drawEdge3d([pts pts3d]);

displayMesh(original);
displayMesh(fMesh)

view([0 0 -1]);

%%
setfig();
m=corMesh{i};

a = normalize(rand(1, 3));

drawEdge3d([0 0 0 a]);

n=repmat(a, [size(m.v,1) 1]);
proj = m.v - bsxfun(@times,sum(m.v.*n,2),n);

m.v=proj;

displayMesh(m);




%%

cameraParams = estimateCameraParameters(repmat(pts(:,1:2),[1 1 2]), pts3d);

% Evaluate calibration accuracy.
figure; showReprojectionErrors(cameraParams);
title('Reprojection Errors');


%%

a=corMesh{i};

% a.v = similarityTransform3d(a.v, [1 1 1], [1 1 1], 1);

n = normr(repmat([1 0 0] , [size(a.v, 1) 1]));
m = repmat([0.5 0.5 0] , [size(a.v, 1) 1]);
a.v = a.v - repmat(sum((a.v - m).*n,2),[1 size(n, 2)]) .* n;

displayMesh(a);

drawPoint3d(m);
drawEdge3d([m m+n]);

%%



a=corMesh{4};

% pts3d=a.v;
pts2d=pts;


a.v = align2d(pts3d, pts2d(:,1:2), a.v);

% drawPoint3d(fpts);
setfig()


xImage = [0 1; 0 1];   %# The x data for the image corners
yImage = [0 0; 1 1];             %# The y data for the image corners
zImage = [0 0; 0 0];   %# The z data for the image corners
surf(xImage,yImage,zImage,...    %# Plot the surface
     'CData',im,...
     'FaceColor','texturemap','CDataMapping','direct');

drawPoint3d(pts2d);
% a.v = fpts;
displayMesh(a);


%%

setfig()
% xImage = [0 1; 0 1];   %# The x data for the image corners
% yImage = [0 0; 1 1];             %# The y data for the image corners
% zImage = [0 0; 0 0];   %# The z data for the image corners
% surf(xImage,yImage,zImage,...    %# Plot the surface
%      'CData',im,...
%      'FaceColor','texturemap','CDataMapping','direct');

drawPoint3d(pts2d3d,'color','red');
% a.v = fpts;
% displayMesh(a);

%%


pts3d;
pts2d = pts;

x3d_h = [pts3d ones(size(pts3d, 1), 1)];
x2d_h = [pts2d(:,1:2) ones(size(pts2d, 1), 1)];

A = [3     0   1
     0   3   1
     0     0     1];

[Rp,Tp,Xc,sol] = efficient_pnp(x3d_h, x2d_h, A);
b=a;
b.v= (bsxfun(@plus,b.v,Tp'))*Rp;
% drawPoint3d(b.v,'color','red');

% b.v=bsxfun(@rdivide, b.v, b.v(:,3));

displayMesh(b)


%%

A = [1.5     0   1
     0   1.5   1
     0     0     1];
cameraParams = cameraParameters('IntrinsicMatrix', A');
[rotationMatrix, translationVector] = extrinsics(pts2d(:,1:2), pts3d, cameraParams);
%%

b=a;
b.v= (bsxfun(@plus,b.v,translationVector))*rotationMatrix;
% drawPoint3d(b.v,'color','red');

% b.v=bsxfun(@rdivide, b.v, b.v(:,3));

displayMesh(b)

%%


