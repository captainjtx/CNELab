classdef SPFPlot < BioSigPlot
    properties
        %         RawData
        %         SubspaceData
        %         ReconData
        MixMat
        DemixMat
        
        Weight
        
        SPWeightFig
        
        sample
        channel
        dataset
        subspaceMask
    end
    methods
        function obj=SPFPlot(method,data,subspaceData,reconData,mix,demix,weg,varargin)
            obj@BioSigPlot({data,subspaceData,reconData},varargin{:});
            
            obj.MixMat=mix;
            obj.DemixMat=demix;
            obj.Weight=weg;
            
            set(obj.Fig,'Name',method);
            set(handle(obj.JBtnMaskChannel,'CallbackProperties'),'MousePressedCallback',@(src,evt)maskSubspaceChannel(obj,0));
            set(handle(obj.JBtnUnMaskChannel,'CallbackProperties'),'MousePressedCallback',@(src,evt)maskSubspaceChannel(obj,1));
 
%             set(obj.BtnGainIncrease,'ClickedCallback',@(src,evt)maskSubspaceChannel(obj,src));
%             set(obj.BtnGainDecrease,'ClickedCallback',@(src,evt)maskSubspaceChannel(obj,src));
            
            
            if ~isempty(obj.Weight)
                obj.SPWeightFig=figure('Name','Subspce Weight Plot','NumberTitle','off');
                
                plot(weg,'--rs','LineWidth',2,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','g',...
                    'MarkerSize',10)
                xlabel('Subspace Dimension')
                ylabel('Subspace Weight')
            end
            
            enableDisableFig(obj.Fig,true);
        end
        
        function delete(obj)
            if ishandle(obj.SPWeightFig)
                delete(obj.SPWeightFig);
            end
        end
        
        function maskSubspaceChannel(obj,mask)
            pmt=obj.Mask_;
            
            tmp=obj.applyPanelVal(obj.Mask_,mask);
            
            tmp{1}=ones(size(tmp{1}));
            tmp{3}=ones(size(tmp{3}));
            
            obj.Mask=tmp;
            if ~all(tmp{2}==pmt{2})
                
                obj.subspaceMask=tmp{2};
                
                obj.Data{3}=obj.PreprocData{2}*diag(tmp{2})*obj.MixMat;
                obj.PreprocData{3}=obj.Data{3};
                
                obj.redraw;
                
                notify(obj,'MaskSubspace');
            end
            
        end
        
    end
    
     methods
         %apply subspace filter
         function sfdata=subspacefilter(obj,data,varargin)
             ratio=0;
             if length(varargin)==1
                 %rather than completely remove the component, ratio can be
                 %used to suppress the component
                 ratio=varargin{1};
                 ratio=max(0,min(ratio,1));
             end
             subspacedata=data*obj.DemixMat;
             
             
             mask=obj.subspaceMask;
             mask(mask==0)=ratio;
             
             sfdata=subspacedata*diag(mask)*obj.MixMat;
         end
         
     end
    
    events
        MaskSubspace
    end
    
end