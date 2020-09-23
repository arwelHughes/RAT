















classdef MyClass < matlab.mixin.CustomDisplay
   properties
      Prop1
      Prop2
      Prop3
      prop4
      
   end
   methods(Access = protected)
      function groups = getPropertyGroups(obj)
         if isscalar(obj)
             if obj.Prop1 == 1
            % Specify the values to be displayed for properties
                propList = struct('Prop1',obj.Prop1,...
                    'Prop2',obj.Prop2);
                groups = matlab.mixin.util.PropertyGroup(propList);
             else
            % Nonscalar case: call superclass method
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
             end
         end
      end
   end
end