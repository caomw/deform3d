classdef Constraint

    properties
        type;
        weight;
        points;
    end

    methods
        function obj=Constraint(type, weight, points)
            obj.type = type;
            obj.weight = weight;
            obj.constraint = constraint;
        end
    end

end