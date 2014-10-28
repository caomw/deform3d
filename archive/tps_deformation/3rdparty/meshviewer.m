function fig = meshviewer(verts, faces, mesh_save)

if(nargin < 3)
    mesh_save = 'out.off';
end
verts = verts';
faces = faces';
% m = struct('v', verts', 'f', faces');
% m = samplePointsInMesh(m);

%Figure window
STATE.fig = figure(...%'MenuBar','none', ...%'Renderer', 'opengl', ...
    'WindowButtonDownFcn', {@mouseDown}, ...
    'WindowButtonMotionFcn', {@mouseMotion}, ...
    'WindowButtonUpFcn', {@mouseUp}, ...
    'WindowScrollWheelFcn', {@mouseScroll}, ...
    'KeyPressFcn', {@keyPress});
%3D bim Model view
%CS: z  y
%    | /
%    o--x
STATE.ax3d = axes('Parent', STATE.fig, ...
    'Projection','orthographic', ...
    'CameraViewAngleMode', 'manual', ...
    'CameraTargetMode', 'manual', ...
    'CameraPositionMode', 'manual', ...
    'CameraUpVectorMode', 'manual', ...
    ...%'CameraViewAngle', 50, ...
    'CameraTarget',   [0 0 0], ...
    'CameraPosition', [1 1 1], ...
    'CameraUpVector', [0 0 1], ...
    'XLimMode', 'manual', ...
    'XLim', [-10,10], ...
    'YLimMode', 'manual', ...
    'YLim', [0.1,100], ...
    'ZLimMode', 'manual', ...
    'ZLim', [-10,10], ...
    'DataAspectRatioMode', 'manual', ...
    'DataAspectRatio',[1 1 1],...
    'Position', [0 0 .5 .5], ...
    'Visible','off');
STATE.ax3d2 = axes('Parent', STATE.fig, 'Position', [.5,0,.5,.5], ...
    'XLimMode', 'manual', ...
    'XLim', [-1,1], ...
    'YLimMode', 'manual', ...
    'YLim', [0.1,100], ...
    'ZLimMode', 'manual', ...
    'ZLim', [-1,1]);
STATE.ax3d3 = axes('Parent', STATE.fig, 'Position', [0,.5,.5,.5],...
    'XLimMode', 'manual', ...
    'XLim', [-1,1], ...
    'YLimMode', 'manual', ...
    'YLim', [0.1,100], ...
    'ZLimMode', 'manual', ...
    'ZLim', [-1,1]);
STATE.ax3d4 = axes('Parent', STATE.fig, 'Position', [.5,.5,.5,.5],...
    'XLimMode', 'manual', ...
    'XLim', [-1,1], ...
    'YLimMode', 'manual', ...
    'YLim', [0.1,100], ...
    'ZLimMode', 'manual', ...
    'ZLim', [-1,1]);

STATE.pivot = [0,0,0];%mean(verts);
STATE.translate = [0,0,0];
%STATE.translate = [0 max(verts(:,2))*50 0] - STATE.pivot;
%STATE.translate = [max(verts(:,1))*50 0 0] - STATE.pivot;
%STATE.translate = - STATE.pivot;

STATE.translate_offset = [0 0 0];
STATE.rotate_x = 0; STATE.rotate_offset_x = 0;
STATE.rotate_z = 0; STATE.rotate_offset_z = 0;
STATE.rotate_y = 0; STATE.rotate_offset_y = 0;
STATE.scale = .1./std(verts(:));
STATE.tform = hgtransform('Parent', STATE.ax3d, ...
    'Matrix', makeMyTform(STATE.scale,STATE.translate,eye(4,4),STATE.pivot));
STATE.view3d = patch('Faces',faces,'Vertices',verts, ...
    'Parent', STATE.tform, ... %"Modelview" matrix (empty transform)
    'FaceColor',[1.0 1.0 1.0].*.25, 'FaceAlpha', 0.5,...
    'EdgeColor',[1 1 1].*.3, 'EdgeAlpha', 1);
% STATE.view3d = line([STATE.pivot(1),STATE.pivot(1)+100],[STATE.pivot(2),STATE.pivot(2)],...
%         [STATE.pivot(3),STATE.pivot(3)]);%, ...
%'MarkerEdgeColor','none', 'MarkerEdgeColor','none', ...
%'FaceLighting','gouraud', 'AmbientStrength',0.15);
camlight('headlight');
material('dull')
fig = STATE.fig;
STATE.COUNT = -1;

ANGLE_INCREMENT = 5/360*2*pi; %2 degrees

write_off(mesh_save, verts, faces);
plot_mesh_views(verts,faces);
%--------------------------------------------------------------------------
    function T = makeMyTform(s, t, R, pivot)
        T = makehgtform('scale',s)*makehgtform('translate',t+pivot)*R*makehgtform('translate',-pivot);
    end

    function setAngleIncrement(degree)
        ANGLE_INCREMENT = degree/360*2*pi; %2 degrees
    end

    function updateGL()
        %Set transform
        trans = STATE.translate_offset + STATE.translate;
        rot_x = makehgtform('xrotate',STATE.rotate_x + STATE.rotate_offset_x);
        rot_z = makehgtform('zrotate',STATE.rotate_z + STATE.rotate_offset_z);
        rot_y = makehgtform('yrotate',STATE.rotate_y + STATE.rotate_offset_y);
        set(STATE.tform, 'Matrix', makeMyTform(STATE.scale,trans,rot_x*rot_z*rot_y,STATE.pivot));
        %Redraw all
        drawnow;
    end

    function mouseDown(src, ~)
        click = get(src,'CurrentPoint');
        type = get(src,'SelectionType');
        STATE.type_init = type;
        STATE.click_init = click;
    end

    function mouseMotion(src, ~)
        if(~isfield(STATE,'type_init') || isempty(STATE.type_init)); return; end %Not dragging (just moving mouse)
        type = get(src,'SelectionType');
        if(~strcmpi(type, STATE.type_init)); return; end %State changed while dragging
        figpos = get(src,'Position'); %[x,y,w,h]
        delta = (get(src,'CurrentPoint') - STATE.click_init) ./ min(figpos(3:4));
        if(strcmpi(type,'normal')) %Left click
            STATE.rotate_offset_x = -delta(2);
        elseif(strcmpi(type,'extend')) %middle click
            STATE.rotate_offset_z = delta(1);
        else
            STATE.rotate_offset_y = -delta(2);
            %STATE.translate_offset = (1/STATE.scale).*[delta(1), 0, delta(2)];
        end
        STATE.COUNT = STATE.COUNT+1;
        if(mod(STATE.COUNT,10) == 0)
            STATE.COUNT = 0;
            plot_mesh()
        end
        %drawnow;
        updateGL();
    end


    function mouseUp(src, ~)
        STATE.translate = STATE.translate+STATE.translate_offset;
        STATE.translate_offset = [0 0 0];
        STATE.rotate_x = STATE.rotate_x + STATE.rotate_offset_x;
        STATE.rotate_offset_x = 0;
        STATE.rotate_z = STATE.rotate_z + STATE.rotate_offset_z;
        STATE.rotate_offset_z = 0;
        STATE.rotate_y = STATE.rotate_y + STATE.rotate_offset_y;
        STATE.rotate_offset_y = 0;
        STATE.type_init = [];
        STATE.click_init = [];
        updateGL();
    end

    function mouseScroll(src, eventdata)
        delta = eventdata.VerticalScrollCount;
        modifiers = get(src,'CurrentModifier');
        if(ismember(modifiers,'alt')) %Scale = scroll + alt
            STATE.scale = STATE.scale * (1 - 0.05*delta);
        else %Rotate about z-axis (up) = scroll
            STATE.translate = STATE.translate + [0, (1/STATE.scale/4)*delta, 0];
        end
        updateGL();
    end

    function keyPress(src, eventdata)
        if( eventdata.Character == ' ')
            fprintf('scale     = %.4f\n', STATE.scale);
            fprintf('translate = (%.4f, %.4f, %.4f)\n', STATE.translate);
            fprintf('pivot     = (%.4f, %.4f, %.4f)\n', STATE.pivot);
            fprintf('rotate x  = %.4f\n', STATE.rotate_x);
            fprintf('rotate z  = %.4f\n', STATE.rotate_z);
            tform = get(STATE.tform,'Matrix')
            
            disp(mesh_save);
            rot_x = makehgtform('xrotate',STATE.rotate_x + STATE.rotate_offset_x);
            rot_z = makehgtform('zrotate',STATE.rotate_z + STATE.rotate_offset_z);
            rot_y = makehgtform('yrotate',STATE.rotate_y + STATE.rotate_offset_y);
            verts_prime = (rot_x*rot_y*rot_z*[verts,ones(size(verts,1),1)]')';
            verts_prime = verts_prime(:,1:3);
            write_off(mesh_save, verts_prime, faces);
            [v,f] = read_off(mesh_save);
            plot_mesh_views(v',faces);%verts_prime, faces);

        end
        
        if(strcmp(eventdata.Key, 'a'))
            STATE.rotate_offset_x = STATE.rotate_offset_x + ANGLE_INCREMENT;
        elseif(strcmp(eventdata.Key, 'd')) 
            STATE.rotate_offset_x = STATE.rotate_offset_x - ANGLE_INCREMENT;
        elseif(strcmp(eventdata.Key, 'w')) 
            STATE.rotate_offset_y = STATE.rotate_offset_y + ANGLE_INCREMENT;
        elseif(strcmp(eventdata.Key, 's')) 
            STATE.rotate_offset_y = STATE.rotate_offset_y - ANGLE_INCREMENT;
        elseif(strcmp(eventdata.Key, 'r')) %reset angles
            STATE.rotate_offset_x = 0;
            STATE.rotate_offset_y = 0;
            STATE.rotate_offset_z = 0;
            STATE.rotate_x = 0;
            STATE.rotate_y = 0;
            STATE.rotate_z = 0;
        elseif(strcmp(eventdata.Key, 'leftarrow')) 
            STATE.rotate_offset_z = STATE.rotate_offset_z + ANGLE_INCREMENT;
        elseif(strcmp(eventdata.Key, 'rightarrow')) 
            STATE.rotate_offset_z = STATE.rotate_offset_z - ANGLE_INCREMENT;
        elseif(strcmp(eventdata.Key, 'return')) 
            STATE.translate = STATE.translate+STATE.translate_offset;
            STATE.translate_offset = [0 0 0];
            STATE.rotate_x = STATE.rotate_x + STATE.rotate_offset_x;
            STATE.rotate_offset_x = 0;
            STATE.rotate_z = STATE.rotate_z + STATE.rotate_offset_z;
            STATE.rotate_offset_z = 0;
            STATE.rotate_y = STATE.rotate_y + STATE.rotate_offset_y;
            STATE.rotate_offset_y = 0;
            plot_mesh();
        elseif(strcmp(eventdata.Key, '1')) 
            setAngleIncrement(1);
        elseif(strcmp(eventdata.Key, '2')) 
            setAngleIncrement(2);
        elseif(strcmp(eventdata.Key, '3')) 
            setAngleIncrement(3);
        elseif(strcmp(eventdata.Key, '4')) 
            setAngleIncrement(4);
        elseif(strcmp(eventdata.Key, '5')) 
            setAngleIncrement(5);
        elseif(strcmp(eventdata.Key, '6')) 
            setAngleIncrement(6);
        elseif(strcmp(eventdata.Key, '7')) 
            setAngleIncrement(7);
        elseif(strcmp(eventdata.Key, '8')) 
            setAngleIncrement(8);
        elseif(strcmp(eventdata.Key, '9')) 
            setAngleIncrement(9);
        end
        
        STATE.COUNT = STATE.COUNT+1;
        if(mod(STATE.COUNT,10) == 0)
            STATE.COUNT = 0;
            plot_mesh()
        end
        %drawnow;
        updateGL();
    end


    function plot_mesh()
        rot_x = makehgtform('xrotate',STATE.rotate_x + STATE.rotate_offset_x);
        rot_z = makehgtform('zrotate',STATE.rotate_z + STATE.rotate_offset_z);
        rot_y = makehgtform('yrotate',STATE.rotate_y + STATE.rotate_offset_y);
        verts_prime = (rot_x*rot_y*rot_z*[verts,ones(size(verts,1),1)]')';
        verts_prime = verts_prime(:,1:3);
        plot_mesh_views(verts_prime, faces);
    end

    function plot_mesh_views(verts, faces)
        bb = axis_aligned_bb(verts);
        STATE.view3d2 = trimesh(faces,verts(:,1),verts(:,2),verts(:,3), 'parent', STATE.ax3d2);
        view(STATE.ax3d2,0,90)
        hold(STATE.ax3d2);
        plot3(STATE.ax3d2, bb(:,1),bb(:,2),bb(:,3),'-k');
        hold(STATE.ax3d2);
        
        STATE.view3d2 = trimesh(faces,verts(:,1),verts(:,2),verts(:,3), 'parent', STATE.ax3d3);
        view(STATE.ax3d3,0,0)
        hold(STATE.ax3d3);
        plot3(STATE.ax3d3, bb(:,1),bb(:,2),bb(:,3),'-k');
        hold(STATE.ax3d3);
        
        STATE.view3d2 = trimesh(faces,verts(:,1),verts(:,2),verts(:,3), 'parent', STATE.ax3d4);
        view(STATE.ax3d4,90,0)
        hold(STATE.ax3d4);
        plot3(STATE.ax3d4, bb(:,1),bb(:,2),bb(:,3),'-k');
        hold(STATE.ax3d4);
    end

    function bb = axis_aligned_bb(verts)
        xs = [max(verts(:,1)),min(verts(:,1))];
        ys = [max(verts(:,2)),min(verts(:,2))];
        zs = [max(verts(:,3)),min(verts(:,3))];
        bb = [xs(1) ys(1) zs(1); ...
            xs(1) ys(1) zs(2); ...
            xs(1) ys(2) zs(2); ...
            xs(1) ys(2) zs(1); ...
            xs(1) ys(1) zs(1); ...
            
            xs(2) ys(1) zs(1); ...
            
            xs(2) ys(1) zs(2); ...
            xs(1) ys(1) zs(2); ...
            xs(2) ys(1) zs(2); ...
            
            xs(2) ys(2) zs(2); ...
            xs(1) ys(2) zs(2); ...
            xs(2) ys(2) zs(2); ...
            
            xs(2) ys(2) zs(1); ...
            xs(1) ys(2) zs(1); ...
            xs(2) ys(2) zs(1); ...
            
            xs(2) ys(1) zs(1)];
        
    end

end

