% M = importMeshDir('/Users/daeyun/Documents/MATLAB/thesisMisc/mesh/');
Mesh = load_mesh('/Users/daeyun/Documents/MATLAB/thesisMisc/mesh/', 'french-chair.obj');
Mesh.v = Mesh.v';
Mesh.f = Mesh.f';
obj2d = imread(sprintf('thesisMisc/2d/scenes/2.jpg'));
%%
figure
displayMesh(Mesh);
clickA3DPoint(Mesh.v);

%%

matches=importdata('/Users/daeyun/Documents/MATLAB/thesisMisc/2dMatch/french-chair.txt');



figure;
displayMesh(Mesh);

v = [6 1 1];
view(v);
cameratoolbar('Show');
cameratoolbar('SetMode', 'orbit');
cameratoolbar('SetCoordSys', 'y');

for j = 1:numel(matches)
    m=matches(j);
    drawPoint3d(Mesh.v(m,:), 'marker', '.', 'markersize', 50, 'color', 'r')
    
    text(Mesh.v(m,1), Mesh.v(m,2), Mesh.v(m,3),sprintf('%d, %d', j, m),'HorizontalAlignment','left','FontSize',20,'color','blue');
end

figure
hold on;
imshow(obj2d)
cameratoolbar('Show');
cameratoolbar('SetMode', 'orbit');
cameratoolbar('SetCoordSys', 'y');

for j = 1:numel(matches)
    fprintf('select %d, %d:\n', j, matches(j));
    [x, y] = ginput(1);
    fprintf('%d, %d\n', x, y);
    drawPoint(x, y, 'marker', '.', 'markersize', 50, 'color', 'r');
    points2d(j,:)=[x y];
end