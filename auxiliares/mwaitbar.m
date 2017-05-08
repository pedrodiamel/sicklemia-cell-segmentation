function fout = mwaitbar(x,whichbar, varargin)
%WAITBAR Display wait bar.
%   H = WAITBAR(X,'message', property, value, property, value, ...)
%   creates and displays a waitbar of fractional length X.  The
%   handle to the waitbar figure is returned in H.
%   X should be between 0 and 1.  Optional arguments property and
%   value allow to set corresponding waitbar figure properties.
%   Property can also be an action keyword 'CreateCancelBtn', in
%   which case a cancel button will be added to the figure, and
%   the passed value string will be executed upon clicking on the
%   cancel button or the close figure button.
%
%   WAITBAR(X) will set the length of the bar in the most recently
%   created waitbar window to the fractional length X.
%
%   WAITBAR(X,H) will set the length of the bar in waitbar H
%   to the fractional length X.
%
%   WAITBAR(X,H,'message') will update the message text in
%   the waitbar figure, in addition to setting the fractional
%   length to X.
%
%   WAITBAR is typically used inside a FOR loop that performs a
%   lengthy computation.  
%
%   Example:
%       h = waitbar(0,'Please wait...');
%       for i=1:1000,
%           % computation here %
%           waitbar(i/1000,h)
%       end
%
%   See also DIALOG, MSGBOX.

%   Copyright 1984-2006 The MathWorks, Inc.
%   $Revision: 1.23.4.13 $  $Date: 2007/09/27 22:48:16 $

if nargin>=2
    
    if ischar(whichbar) || iscellstr(whichbar)       
        %we are initializing
        type=2; 
        name = whichbar;    
        
    elseif isnumeric(whichbar)        
        %we are updating, given a handle
        type = 1; 
        f = whichbar;        
        
    else
    error('MATLAB:waitbar:InvalidInputs', 'Input arguments of type %s%s', class(whichbar),' not valid.')
    end
    
elseif nargin==1
    
    %f = findobj(allchild(0),'flat','Tag','TMWWaitbar');
    f =  gcf;   
    type  = 1;
    
else
error('MATLAB:waitbar:InvalidArguments', 'Input arguments not valid.');
end


x = max(0,min(100*x,100));
try 
switch type
    
    case 1,  % waitbar(x)    update
        p = findobj(f,'Type','patch');
        l = findobj(f,'Type','line');
        if isempty(f) || isempty(p) || isempty(l),
        error('MATLAB:waitbar:WaitbarHandlesNotFound', 'Couldn''t find waitbar handles.');
        end
        
        %xpatch = get(p,'XData');
        xpatch = [0 x x 0];
        set(p,'XData',xpatch)
        xline = get(l,'XData');
        set(l,'XData',xline);

        if nargin>2,
            % Update waitbar title:
            hAxes = findobj(f,'type','axes','Tag','TMWWaitbar');
            hTitle = get(hAxes,'title');
            set(hTitle,'string',varargin{1});
        end

        
    case 2,  % waitbar(x,name)  initialize
       
        %vertMargin = 0;
        if nargin > 2,
            % we have optional arguments: property-value pairs
            if rem (nargin, 2 ) ~= 0
            error('MATLAB:waitbar:InvalidOptionalArgsPass',  'Optional initialization arguments must be passed in pairs');
            end
        end
               
        %oldRootUnits = get(0,'Units');

        set(0, 'Units', 'points');
        screenSize = get(0,'ScreenSize');

        axFontSize=get(0,'FactoryAxesFontSize');

        pointsPerPixel = 72/get(0,'ScreenPixelsPerInch');

        width = 360 * pointsPerPixel;
        height = 75 * pointsPerPixel;
        pos = [screenSize(3)/2-width/2 screenSize(4)/2-height/2 width height];
       
        % figure actual
        f = gcf;
                
        h = findobj(get(f,'Children'),'flat','Tag','TMWWaitbar');
        if ~isempty(h)
        delete(h);
        end
        
        
        %colormap([]);
        %axNorm=[.05 .3 .9 .2];
        %axPos = axNorm.*[pos(3:4),pos(3:4)] + [0 vertMargin 0 0];
        axPos = [50 25 400 25];
        
        
        h = axes('XLim',[0 100],...
            'Tag','TMWWaitbar',...
            'DrawMode','fast',...
            'Color',[0.231 0.443 0.337],...
            'YLim',[0 1],...
            'Box','on', ...
            'Units','Pixel',...
            'FontSize', axFontSize,...
            'Position',axPos,...            
            'XTickMode','manual',...
            'YTickMode','manual',...
            'XTick',[],...
            'YTick',[],...
            'XTickLabelMode','manual',...
            'XTickLabel',[],...
            'YTickLabelMode','manual',...
            'YTickLabel',[]);


        %tHandle=title(name);
        tHandle = get(h,'title');
        %tHandle =  get(h,'YLabel');
        set(tHandle,...
            'HorizontalAlignment','left',...
            'Units','Pixel',...
            'FontWeight', 'bold',...
            'FontName', 'Transistor',...
            'Color', [0.0 1.0 0.0],...
            'String',name,...            
            'Position',[412 6]);
        
        % oldTitleUnits=get(tHandle,'Units');
        %set(tHandle,...
        %    'Units',      'points',...
        %    'String',     name);

        
        %if figPosDirty
        %    set(f,'Position',pos);
        %end

        xpatch = [0 x x 0];
        ypatch = [0 0 1 1];
        xline  = [100 0 0 100 100];
        yline  = [0 0 1 1 0];
        
        patch(xpatch,ypatch,[0.0 1.0 0.0],'EdgeColor',[0.0 1.0 0.0],'EraseMode','normal');
        l = line(xline,yline,'EraseMode','none');
        set(l,'Color',get(gca,'XColor'));
        

        %set(f,'HandleVisibility','callback','visible', visValue);        
        %set(0, 'Units', oldRootUnits);
    
end  % case

catch
        delete(findobj(allchild(0),'flat','Tag','TMWWaitbar'));
        error('MATLAB:waitbar:InvalidArguments','Improper arguments for waitbar');
end
drawnow;

if nargout==1,
    fout = f;
end
