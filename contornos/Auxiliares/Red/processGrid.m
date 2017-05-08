function gridOut = processGrid(gridIn, data)
% processGrid: Construct a grid data structure, and check for consistency.
%
%   gridOut = processGrid(gridIn, data)
%
% Processes all the various types of grid argument allowed.
%
% gridIn may be a scalar, in which case it is assumed to be the dimension.
%
% gridIn may be a vector, in which case it contains the number of grid nodes
%   in each dimension; the grid is assumed to be a unit square.
%
% gridIn may be a structure, in which case it must be:
%   (each vector has length equal to the number of dimensions):
%	  gridIn.dim   Scalar dimension of the grid.
%	  gridIn.min   Vector specifying the lower left corner of the grid.
%	  gridIn.max   Vector specifying the upper right corner of the grid.
%	  gridIn.N     Vector specifying the number of grid nodes in each dim.
%	  gridIn.dx    Vector specifying the grid spacing in each dim.
%	  gridIn.vs    Cell vector, each element is a vector of 
%		         node locations for that dim.
%	  gridIn.xs    Cell vector, each element is an array
%		         (result of calling ndgrid on vs).
%	  gridIn.bdry  Cell vector of function handles pointing to boundary
%		         condition generating functions for each dim.
%         gridIn.bdryData
%                      Cell vector of data structures for the boundary
%		         condition generating functions.
%         gridIn.axis  Vector specifying computational domain bounds
%                        in a format suitable to pass to the axis()
%                        command (only defined for 2D and 3D grids,
%                        otherwise grid.axis == []).
%         gridIn.shape Vector specifying grid node count in a format
%                        suitable to pass to the reshape() command
%                        (usually grid.N', except for 1D grids).
%
% If any of the following fields are scalars, they are replicated dim times:
%    min, max, N, dx, bdry, bdryData.
% 
% In general, it is not necessary to supply the fields:
%    vs, xs, axis, shape.
%
% If one of N or dx is supplied, the other is inferred.
% If both are supplied, consistency is checked.
%
% Dimensional consistency is checked on all fields.
%
% Default settings (only used if value is not given or inferred)
%	  min   = zeros(dim, 1)
%	  max   = ones(dim, 1)
%	  N     = 101
%	  bdry  = periodic
%
% gridOut will be the full structure described for gridIn above.
%
% data is an optional input.
%   If data is present, it will be checked for dimensional consistency.

% Copyright 2004 Ian M. Mitchell (mitchell@cs.ubc.ca).
% This software is used, copied and distributed under the licensing 
%   agreement contained in the file LICENSE in the top directory of 
%   the distribution.
%
% Ian Mitchell, 1/22/03
%  new version  5/13/03 added fields dim, dx, vs, xs, bdry.
%  new version  1/13/04 added field bdryData.
%  new version  2/09/04 added field shape.

%----------------------------------------------------------------------------
defaultMin = 0;
defaultMax = 1;
defaultN = 101;
defaultBdry = @addGhostPeriodic;
defaultBdryData = [];

% This is just to avoid attempts to allocate 100 dimensional arrays.
maxDimension = 5;

%----------------------------------------------------------------------------
if(~isstruct(gridIn))
  if(prod(size(gridIn)) == 1)
    gridOut.dim = gridIn;
  elseif(ndims(gridIn) == 2)
    % Should be a vector of node counts.
    if(size(gridIn, 2) ~= 1)
      error('gridIn vector must be a column vector');
    else
      gridOut.dim = length(gridIn);
      gridOut.N = gridIn;
    end
  else
    error('Unknown format for gridIn parameter');
  end
else
  gridOut = gridIn;
end


%----------------------------------------------------------------------------
% Now we should have a partially complete structure in gridOut.

if(isfield(gridOut, 'dim'))
  if(gridOut.dim > maxDimension)
    error('dimension > %d, may be dangerously large', maxDimension);
  end
  if(gridOut.dim < 0)
    error('dimension must be positive');
  end
else
  error('grid structure must contain dimension');
end

%----------------------------------------------------------------------------
% Process grid boundaries.

if(isfield(gridOut, 'min'))
  if(~isColumnLength(gridOut.min, gridOut.dim))
    if(isscalar(gridOut.min))
      gridOut.min = gridOut.min * ones(gridOut.dim, 1);
    else
      error('min field is not column vector of length dim or a scalar');
    end
  end
else
  gridOut.min = defaultMin * ones(gridOut.dim, 1);
end

if(isfield(gridOut, 'max'))
  if(~isColumnLength(gridOut.max, gridOut.dim))
    if(isscalar(gridOut.max))
      gridOut.max = gridOut.max * ones(gridOut.dim, 1);
    else
      error('max field is not column vector of length dim or a scalar');
    end
  end
else
  gridOut.max = defaultMax * ones(gridOut.dim, 1);
end

if(any(gridOut.max <= gridOut.min))
  error('max bound must be strictly greater than min bound in all dimensions');
end

%----------------------------------------------------------------------------
% Process N and dx fields together, check for consistency.

if(isfield(gridOut, 'N'))
  if(any(gridOut.N <= 0))
    error('number of grid cells must be strictly positive'); 
  end
  if(~isColumnLength(gridOut.N, gridOut.dim))
    if(isscalar(gridOut.N))
      gridOut.N = gridOut.N * ones(gridOut.dim, 1);
    else
      error('N field is not column vector of length dim or a scalar');
    end
  end
  if(isfield(gridOut, 'dx'))
    if(any(gridOut.dx <= 0))
      error('grid cell size dx must be strictly positive');
    end
    % check consistency
    if(~isColumnLength(gridOut.dx, gridOut.dim))
      if(isscalar(gridOut.dx))
        gridOut.dx = gridOut.dx * ones(gridOut.dim, 1);
      else
        error('dx field is not column vector of length dim or a scalar');
      end
    end
    if(any((gridOut.N - 1) ~= round((gridOut.max - gridOut.min) ./gridOut.dx)))
      error('N and dx fields are inconsistent');
    end
  else
    % infer dx
    gridOut.dx = (gridOut.max - gridOut.min) ./ (gridOut.N - 1);
  end
else
  if(isfield(gridOut, 'dx'))
    if(any(gridOut.dx <= 0))
      error('grid cell size dx must be strictly positive');
    end
    % infer N 
    if(~isColumnLength(gridOut.dx, gridOut.dim))
      if(isscalar(gridOut.dx))
        gridOut.dx = gridOut.dx * ones(gridOut.dim, 1);
      else
        error('dx field is not column vector of length dim or a scalar');
      end
    end
    gridOut.N = round((gridOut.max - gridOut.min) ./ gridOut.dx) + 1;
  else
    % default N, infer dx
    gridOut.N = defaultN * ones(gridOut.dim, 1);
    gridOut.dx = (gridOut.max - gridOut.min) ./ (gridOut.N - 1);
  end
end

%----------------------------------------------------------------------------
if(isfield(gridOut, 'vs'))
  if(iscell(gridOut.vs))
    if(~isColumnLength(gridOut.vs, gridOut.dim))
      error('vs field is not column cell vector of length dim');
    else
      for i = 1 : gridOut.dim
        if(~isColumnLength(gridOut.vs{i}, gridOut.N(i)))
          error('vs cell entry is not correctly sized vector');
        end
      end
    end
  else
    error('vs field is not a cell vector');
  end
else
  gridOut.vs = cell(gridOut.dim, 1);
  for i = 1 : gridOut.dim
    gridOut.vs{i} = (gridOut.min(i) : gridOut.dx(i) : gridOut.max(i))';
  end
end

%----------------------------------------------------------------------------
if(isfield(gridOut, 'xs'))
  if(iscell(gridOut.xs))
    if(~isColumnLength(gridOut.xs, gridOut.dim))
      error('xs field is not column cell vector of length dim');
    else
      if(gridOut.dim > 1)
        for i = 1 : gridOut.dim
          if(any(size(gridOut.xs{i}) ~= gridOut.N'))
            error('xs cell entry is not correctly sized array');
          end
        end
      else
        if(length(gridOut.xs{1}) ~= gridOut.N)
          error('xs cell entry is not correctly sized array');
        end
      end
    end
  else
    error('xs field is not a cell vector');
  end
else
  gridOut.xs = cell(gridOut.dim, 1);
  if(gridOut.dim > 1)
    [ gridOut.xs{:} ] = ndgrid(gridOut.vs{:});
  else
    gridOut.xs{1} = gridOut.vs{1};
  end
end

%----------------------------------------------------------------------------
if(isfield(gridOut, 'bdry'))
  if(iscell(gridOut.bdry))
    if(~isColumnLength(gridOut.bdry, gridOut.dim))
      error('bdry field is not column cell vector of length dim');
    else
      for i = 1 : gridOut.dim
        % I don't know how to check if the entries are function handles
      end
    end
  else
    if(isscalar(gridOut.bdry))
      bdry = gridOut.bdry;
      gridOut.bdry = cell(gridOut.dim, 1);
      [ gridOut.bdry{:} ] = deal(bdry);
    else
      error('bdry field is not a cell vector or a scalar');
    end
  end
else
  gridOut.bdry = cell(gridOut.dim, 1);
  [ gridOut.bdry{:} ] = deal(defaultBdry);
end

%----------------------------------------------------------------------------
if(isfield(gridOut, 'bdryData'))
  if(iscell(gridOut.bdryData))
    if(~isColumnLength(gridOut.bdryData, gridOut.dim))
      error('bdryData field is not column cell vector of length dim');
    else
      for i = 1 : gridOut.dim
        % Don't know whether it is worth checking that entries are structures
      end
    end
  else
    if(isscalar(gridOut.bdryData))
      bdryData = gridOut.bdryData;
      gridOut.bdryData = cell(gridOut.dim, 1);
      [ gridOut.bdryData{:} ] = deal(bdryData);
    else
      error('bdryData field is not a cell vector or a scalar');
    end
  end
else
  gridOut.bdryData = cell(gridOut.dim, 1);
  [ gridOut.bdryData{:} ] = deal(defaultBdryData);
end

%----------------------------------------------------------------------------
if((gridOut.dim == 2) | (gridOut.dim == 3))
  if(isfield(gridOut, 'axis'))
    for i = 1 : gridOut.dim
      if(gridOut.axis(2 * i - 1) ~= gridOut.min(i))
        error('axis and min fields do not agree');
      end
      if(gridOut.axis(2 * i)     ~= gridOut.max(i))
        error('axis and max fields do not agree');
      end
    end
  else
    gridOut.axis = zeros(1, 2 * gridOut.dim);
    for i = 1 : gridOut.dim
      gridOut.axis(2 * i - 1 : 2 * i) = [ gridOut.min(i), gridOut.max(i) ];
    end
  end
else
  gridOut.axis = [];
end
  
%----------------------------------------------------------------------------
if(isfield(gridOut, 'shape'))
  if(gridOut.dim == 1)
    if(any(gridOut.shape ~= [ gridOut.N, 1 ]))
      error('shape and N fields do not agree');
    end
  else
    if(any(gridOut.shape ~= gridOut.N'))
      error('shape and N fields do not agree');
    end
  end
else
  if(gridOut.dim == 1)
    gridOut.shape = [ gridOut.N, 1 ];
  else
    gridOut.shape = gridOut.N';
  end
end

%----------------------------------------------------------------------------
% check data parameter for consistency
if(nargin > 1)
  if(ndims(data) ~= length(gridOut.shape))
    error('data parameter does not agree in dimension with grid');
  end
  if(any(size(data) ~= gridOut.shape))
    error('data parameter does not agree in array size with grid');
  end
end



%---------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------------------------------
function bool = isColumnLength(array, vectorLength)
%  bool = isColumnLength(array, vectorLength)
%
% helper function to check that an array is a column vector of some length

bool = ((ndims(array) == 2) & ...
        (size(array, 1) == vectorLength) & (size(array, 2) == 1));



%---------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------------------------------
function bool = isscalar(array)
%  bool = isscalar(array)
%
% helper function which checks whether the array is a scalar

bool = (prod(size(array)) == 1);
