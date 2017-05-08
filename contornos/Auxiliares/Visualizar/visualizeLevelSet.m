function  h = visualizeLevelSet( data, displayType, level, titleStr)
% visualizeLevelSet: Display the level set at a particular time.
%
%   h = visualizeLevelSet(g, data, displayType, level, titleStr)
%
% Displays a variety of level set visualizations in dimensions 1 to 3.
%   The current figure and axis is used.
%
% A warning will be generated if the requested level set is missing.
%   For those display types that do not plot a level set
%   (such as a surf plot in 2D), the warning can be disabled by 
%   setting parameter level to be the empty vector [].
%
% Parameters:
%   data         Array storing the implicit surface function.
%   displayType  String specifying the type of visualization (see below).
%   level        Which isosurface to display.  Defaults to 0.
%   titleStr     Optional string to place in the figure title.
%
%   h            Handle to the graphics object created.
%
%
% Dimension 2:
%   'contour'    Show an isocontour of the function as a solid curve in
%                  two dimensions.  Permits vector values for level parameter.
%   'surf'       Plot the function value vs the two dimensional state as
%                  a surface plot.
%


%---------------------------------------------------------------------------
  if(nargin < 4)
    level = 0;
  end

  if((strcmp(displayType, 'contour') || strcmp(displayType, 'contourslice'))...
     && (prod(size(level)) == 1))
    % Scalar input to contour plot should be repeated.
    level = [ level level ];
  end

  if(~isempty(level))
    if((all(data(:) < min(level(:)))) | (all(data(:) > max(level(:)))))
      warning('No implicitly defined surface exists');
    end
  end
  

  % In 2D, the visualization routines seem to be happy to use ndgrid.
  data  = data';
  [w,h] = size(data);
  vs{1} = 1:w;
  vs{2} = 1:h;
  xs = cell(2,1);
  [ xs{:} ] = ndgrid(vs{:});
  
  switch(displayType)
      case 'contour'
      hold on
      [ garbage, h ] = contour(xs{1}, xs{2}, data, level, 'b');
      %axis square;  axis manual;
      hold off
      
      case 'surf'
      h = surf(xs{1}, xs{2}, data);
      otherwise
      error('Unknown display type %s for %d dimensional system', ...
              displayType, dim);
  end
    

  
%---------------------------------------------------------------------------
  if(nargin >= 5)
    title(titleStr);
  end
  
  grid on;
  drawnow;
