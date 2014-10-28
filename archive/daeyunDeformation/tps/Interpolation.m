classdef Interpolation < handle
    properties
        rbfCenters;
        source;
        target;
        lambda;
        Wd;
    end

    methods
        function self = Interpolation(varargin)
            if nargin >= 1
                self.source = varargin{1};
                self.rbfCenters = self.source;
            end

            if nargin >= 2
                self.target = varargin{2};
            end

            if nargin >= 3
                self.lambda = varargin{3};
            end
        end


        function self = positions(self, source, target, lambda)
            validatePoints(source);
            validatePoints(target);

            assert(isequal(size(source), size(target)));

            if isempty(self.rbfCenters)
                self.rbfCenters = source;
            end
            self.source = source;
            self.target = target;

            if ~exist('lambda', 'var')
                self.lambda=0;
            else
                self.lambda=lambda;
            end
        end


        function deformation = interpolate(self)
            sSize=size(self.source);
            rSize=size(self.rbfCenters);

            assert(isequal(sSize(2), rSize(2)));

            L=pairwiseTpsRadialBasis(self.source, self.rbfCenters);

            if ~isempty(self.lambda)
                assert(isequal(size(L, 1), size(L, 2)));
                L = L + self.lambda*eye(size(L));
            end

            P=[ones(sSize(1),1) self.source];
            PT=[ones(rSize(1),1) self.rbfCenters]';
            A=[L P; PT zeros(rSize(2)+1)];
            Y=[self.target;zeros(sSize(2)+1,sSize(2))];
            X=A\Y;

            deformation = Deformation(self.rbfCenters, X);
        end


        function deformation = interpolate2D(self, Wd)
            sSize=size(self.source);
            rSize=size(self.rbfCenters);

            assert(isequal(sSize(2), rSize(2)));
            if ndims(self.target) == 2
                self.target = [self.target zeros(size(self.target, 1), 1)];
            end

            L = pairwiseTpsRadialBasis(self.source, self.rbfCenters);

            if ~isempty(self.lambda)
                assert(isequal(size(L, 1), size(L, 2)));
                L = L + self.lambda*eye(size(L));
            end

            if ~exist('Wd', 'var')
                self.Wd = 1;
            else
                self.Wd = Wd;
            end


            % Z coordinate
            nullSpace = [0 0 1];

            % Estimate depth differences between target points based on extrinsic camera matrix.
            sourceCamView = computePnP(self.source, self.source, self.target(:, 1:2));
            normal = normalize(nullSpace);
            proj = sourceCamView - bsxfun(@times, sum(bsxfun(@times, sourceCamView, normal), 2), normal);

            % Scalar factor
            tDist = pdist2(self.target, self.target);
            pDist = pdist2(proj, proj);
            scale = mean(tDist(:))/mean(pDist(:));

            % Target depth constraint
            tDepth = scale * (sourceCamView(:, 3) - circshift(sourceCamView(:, 3), -1));

            % Depth constraint pairs
            D = eye(sSize(1)) + circshift(-eye(sSize(1)), 1, 2);

            V = eye(sSize(1));
            P = [ones(sSize(1),1) self.source];
            PT = [ones(rSize(1),1) self.rbfCenters]';

            
            A = [kron(eye(3), L)   kron(eye(3), P)   [zeros(2*sSize(1), sSize(1)); V];
                 kron(eye(3), PT)  zeros(12)         [zeros(12, sSize(1))]];
            
            Y = [self.target(:); zeros(12, 1)];

            % Depth constraints
            A = [A; zeros(sSize(1), size(A, 2)-sSize(1)) self.Wd*D];
            Y = [Y; self.Wd*tDepth];

            % Adding \epsilon*I prevents A from being singular
            X=(A+1e-4*eye(size(A)))\Y;

            
            rW = reshape(X(1:sSize(1)*3), [sSize(1), 3]);
            rP = reshape(X(sSize(1)*3+1:sSize(1)*3+12), [4, 3]);

            rX = [rW; rP];
            
            deformation = Deformation(self.rbfCenters, rX);
        end
    end
end
