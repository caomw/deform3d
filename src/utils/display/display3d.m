function display3d(Mesh)

patch('Faces',Mesh.f,'Vertices',Mesh.v, ...
    'FaceColor',[1.0 1.0 1.0].*.1, 'FaceAlpha', 1,...
    'EdgeColor',[1 1 1].*.2, 'EdgeAlpha', 1);
% 'MarkerEdgeColor','none', 'MarkerEdgeColor','none', ...
% 'FaceLighting','gouraud', 'AmbientStrength',0.15);
camlight('headlight');
material('dull');

end