classdef Deformation < handle
    properties
        weights;
        rbfCenters;
    end
    methods
        % Deformation(rbfCenters, weights)
        function self = Deformation(varargin)
            if nargin >= 1
                self.rbfCenters = varargin{1};
            end

            if nargin >= 2
                self.weights = varargin{2};
            end
        end

        function set.rbfCenters(self, centers)
            sz = size(centers);
            d = min(sz);
            n = max(sz);

            assert(n > d, 'Deformation() needs at least d+1 points');
            if size(centers, 2) ~= d
                centers = centers';
                warning('Deformation.apply(): input size should be n by d');
            end

            self.rbfCenters = centers;
        end

        function set.weights(self, weights)
            self.weights = weights;
        end

        % show deformation field
        function visualize(self)
            if isempty(self.weights) || isempty(self.rbfCenters)
                %warning('Deformation not initialized. Generating random values.');

                %source = rand(5, 2);
                %target = source + (rand(5, 2)/8);

                %df = Interpolation(source, target).interpolateLine();
                %self.rbfCenters = df.rbfCenters;
                %self.weights = df.weights;
            %elseif 0
                warning('Deformation not initialized. Generating random values.');

                source = [rand(5, 2) zeros(5, 1)];
                target = source + [(rand(5, 2)/5) rand(5, 1)/5];
                lines = [0 0 0 0 0;0 0 0 0 0;1 1 1 1 1]';

                df = Interpolation(source, target).interpolate2D(lines);
                self.rbfCenters = df.rbfCenters;
                self.weights = df.weights;
            end

            d = size(self.rbfCenters, 2);
            assert(d < 4, 'visualization only supports 2D and 3D');

            minCoord = min(self.rbfCenters);
            maxCoord = max(self.rbfCenters);

            margin = 0.5*max((maxCoord - minCoord));
            minCoord = minCoord - margin;
            maxCoord = maxCoord + margin;

            spacing = 0.05*max((maxCoord - minCoord));

            for i = 1:d
                grid1d{i} = minCoord(i):spacing:maxCoord(i);
            end

            [gridMesh{1:d}] = meshgrid(grid1d{:});

            for i = 1:d
                gridPoints(:,i) = gridMesh{i}(:);
            end

            figure
            hold on;
            axis equal;
            xlabel('x');
            ylabel('y');
            zlabel('z');

            fGridPoints = self.apply(gridPoints);

            %arrow3(gridPoints, fGridPoints, 'q', 0.03, 0.07);
            drawPoint3d(fGridPoints, 'color', 'blue', 'marker', '.');
            %drawPoint(gridPoints, 'color', 'black', 'marker', '.');
            drawPoint3d(target, 'color', 'red', 'marker', 'x');
            drawPoint3d(self.apply(source), 'color', 'blue', 'marker', 'o');
            drawEdge([source self.apply(source)]);

            size(fGridPoints)
            size(gridPoints)
        end

        function printProperties(self)
            fprintf('weights: \n');
            disp(self.weights);
            fprintf('RBF centers: \n');
            disp(self.rbfCenters);
        end

        function fPoints = apply(self, points)
            sz = size(points);
            d = min(sz);
            n = max(sz);

            assert(~isempty(self.weights) && ~isempty(self.rbfCenters), 'Deformation not initialized');
            assert(d==size(self.rbfCenters,2), 'Deformation.apply(): Dimension does not match the BRF centers.');
            assert(n > d, 'Deformation.apply() needs at least d+1 points');
            if size(points, 2) ~= d
                points = points';
                warning('Deformation.apply(): input size should be n by d');
            end

            A = pairwiseTpsRadialBasis(points, self.rbfCenters);
            V = [ones(n, 1) points];

            M = [A V];

            fPoints = M*self.weights;
        end
    end
end
