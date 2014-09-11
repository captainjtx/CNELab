classdef SPFPlot < BioSigPlot
    properties
        RawData
        SubspaceData
        ReconData
    end
    methods
        function obj=SPFPlot(data,varargin)
            obj@BioSigPlot({data});
            obj.RawData=data;
        end
        
    end
    
end