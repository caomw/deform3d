%% Demo #1
%% Load data
Mesh=load_mesh('/Users/daeyun/Documents/MATLAB/thesisMisc/mesh/', 'french-chair.obj');
Mesh.v=Mesh.v';
Mesh.f=Mesh.f';
obj2d=imread(sprintf('thesisMisc/2d/scenes/2.jpg'));
match3dInd=importdata('/Users/daeyun/Documents/MATLAB/thesisMisc/2dMatch/french-chair.txt');
match2d=importdata('/Users/daeyun/Documents/MATLAB/thesisMisc/2dMatch/french-chair-2d.txt');
match3d=Mesh.v(match3dInd,:);

[h, w, ~] = size(obj2d);
match2d = match2d./min(h, w);
%%

figure
hold on
axis equal
[w,h,~]=size(obj2d);
hr=h/w;
xImage = [0 hr; 0 hr];   %# The x data for the image corners
yImage = [0 0; 1 1];             %# The y data for the image corners
zImage = [0 0; 0 0];   %# The z data for the image corners
surf(xImage,yImage,zImage,...    %# Plot the surface
     'CData',obj2d,...
     'FaceColor','texturemap','CDataMapping','direct');
setfig();
axis on;
view([0 0 -1]);


deformation = Interpolation(match3d, match2d, 0).interpolate2D(1);
fV = deformation.apply(Mesh.v);

fMesh.v = fV;
fMesh.f = Mesh.f;

fMesh.v(:,3) = fMesh.v(:,3) - max(fMesh.v(:, 3)) - 0.05;

drawPoint3d([match2d zeros(size(match2d, 1), 1)],'marker','.','markersize', 10, 'color', 'r');
displayMesh(fMesh);
view([0 0 -1]);

%% Load data
Mesh=load_mesh('/Users/daeyun/Documents/MATLAB/thesisMisc/mesh/', 'sofa-sq.obj');
Mesh.v=Mesh.v';
Mesh.f=Mesh.f';
obj2d=imread(sprintf('thesisMisc/2d/scenes/1.jpg'));
match3dInd=importdata('/Users/daeyun/Documents/MATLAB/thesisMisc/2dMatch/sofa-sq.txt');
match2d=importdata('/Users/daeyun/Documents/MATLAB/thesisMisc/2dMatch/sofa-sq-2d.txt');
match3d=Mesh.v(match3dInd,:);

[h, w, ~] = size(obj2d);
match2d = match2d./min(h, w);
%%

figure
hold on
axis equal
[w,h,~]=size(obj2d);
hr=h/w;
xImage = [0 hr; 0 hr];   %# The x data for the image corners
yImage = [0 0; 1 1];             %# The y data for the image corners
zImage = [0 0; 0 0];   %# The z data for the image corners
surf(xImage,yImage,zImage,...    %# Plot the surface
     'CData',obj2d,...
     'FaceColor','texturemap','CDataMapping','direct');
setfig();
axis on;
view([0 0 -1]);


deformation = Interpolation(match3d, match2d, 0.1).interpolate2D(1);
fV = deformation.apply(Mesh.v);

fMesh.v = fV;
fMesh.f = Mesh.f;

fMesh.v(:,3) = fMesh.v(:,3) - max(fMesh.v(:, 3)) - 0.05;

drawPoint3d([match2d zeros(size(match2d, 1), 1)],'marker','.','markersize', 10, 'color', 'r');
displayMesh(fMesh);
view([0 0 -1]);