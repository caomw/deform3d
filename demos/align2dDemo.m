load('align2dDemo');

i=4; % Set to 2, 3, or 4

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

deformation = Interpolation(pts3d, pts, 0).interpolate2D();

fv = deformation.apply(corMesh{i}.v);

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