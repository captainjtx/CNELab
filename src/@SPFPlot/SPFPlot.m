classdef SPFPlot < BioSigPlot
    properties
        %         RawData
        %         SubspaceData
        %         ReconData
        MixMat
        DemixMat
        
        Weight
        
        SPWeightFig
    end
    methods
        function obj=SPFPlot(data,method,varargin)
            
            if strcmpi(method,'pca')
                var=data'*data;
                [V,D]=eig(var);
                
                [e,ID]=sort(diag(D),'descend');
                
                SV=V(:,ID);
                
                subspaceData=data*SV;
                reconData=data;
                
                mix=SV';
                demix=SV;
                weg=e;
            elseif strcmpi(method,'ica')
                [icasig, A, W] = fastica(data','verbose', 'off', 'displayMode', 'off');
                reconData=data;
                subspaceData=icasig';
                
                mix=A';
                demix=W';
                
                weg=[];
            end
            
            obj@BioSigPlot({data,subspaceData,reconData},varargin{:});
            
            obj.MixMat=mix;
            obj.DemixMat=demix;
            obj.Weight=weg;
            
            set(obj.Fig,'Name',method);
            set(obj.BtnMaskChannel,'ClickedCallback',@(src,evt)maskSubspaceChannel(obj,src));
            set(obj.BtnUnMaskChannel,'ClickedCallback',@(src,evt)maskSubspaceChannel(obj,src));
            
            set(obj.MenuClearMask,'Callback',@(src,evt)maskSubspaceChannel(obj,src));
            set(obj.MenuMask,'Callback',@(src,evt)maskSubspaceChannel(obj,src));
            
            if ~isempty(obj.Weight)
                obj.SPWeightFig=figure('Name','Subspce Weight Plot','NumberTitle','off');
                
                plot(e,'--rs','LineWidth',2,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','g',...
                    'MarkerSize',10)
                xlabel('Subspace Dimension')
                ylabel('Subspace Weight')
            end
        end
        
        function delete(obj)
            if ishandle(obj.SPWeightFig)
                delete(obj.SPWeightFig);
            end
        end
        
        function maskSubspaceChannel(obj,src)
            
            if ismember(src,[obj.MenuClearMask,obj.BtnUnMaskChannel])
                mask=1;
            elseif ismember(src,[obj.MenuMask,obj.BtnMaskChannel])
                mask=0;
            end
            pmt=obj.Mask_;
            
            tmp=obj.applyPanelVal(obj.Mask_,mask);
            
            tmp{1}=ones(size(tmp{1}));
            tmp{3}=ones(size(tmp{3}));
            
            obj.Mask=tmp;
            if ~all(tmp{2}==pmt{2})
                
                obj.Data{3}=obj.PreprocData{2}*diag(tmp{2})*obj.MixMat;
                obj.PreprocData{3}=obj.Data{3};
                
                obj.redraw;
                
                notify(obj,'MaskSubspace');
            end
            
        end
        
    end
    
    events
        MaskSubspace
    end
    
end