% targetvalue = maptorange(sourcevalue, sourcerange, targetrange [, varargin])
%
%       Maps values from one range onto another range, either linearly or 
%       along a given exponential curve.
%
% In:
%       sourcevalue - n-by-m matrix or single value to be converted.
%       sourcerange - 1-by-2 matrix indicating the source range.
%       targetrange - 1-by-2 matrix indicating the target range.
%
% Optional (name-value pairs):
%       restrict - whether or not to restrict the target value to be within the 
%                  target range. switch off to extrapolate. (0|1, default 1).
%       exp - set to 1 (default) for linear mapping, or to any other value
%             to map along an exponential curve. note that this curve can
%             be mirrored horizontally by inverting the source range,
%             and vertically by inverting the target range.
%
% Out:  
%       targetvalue - the remapped value(s).
%
% Usage example:
%       >> plot(0:.01:1, maptorange(0:.01:1, [0 1], [.5 0], 'exp', 5))
% 
%                       Copyright 2017 Laurens R Krol
%                       Team PhyPA, Biological Psychology and Neuroergonomics,
%                       Berlin Institute of Technology

% 2017-01-13 First version

% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

function targetvalue = maptorange(sourcevalue, sourcerange, targetrange, varargin)

% parsing input
p = inputParser;

addRequired(p, 'sourcevalue', @isnumeric);
addRequired(p, 'sourcerange', @(x) (all(numel(x) == 2) && isnumeric(x)));
addRequired(p, 'targetrange', @(x) (all(numel(x) == 2) && isnumeric(x)));

addParamValue(p, 'restrict', 1, @isnumeric);
addParamValue(p, 'exp', 1, @isnumeric);

parse(p, sourcevalue, sourcerange, targetrange, varargin{:})

restrict = p.Results.restrict;
exp = p.Results.exp;

% mapping
if numel(sourcevalue) > 1
    % recursively calling this function
    for i = 1:length(sourcevalue)
        sourcevalue(i) = maptorange(sourcevalue(i), sourcerange, targetrange, varargin{:});
        targetvalue = sourcevalue;
    end
else
    % converting source value into a percentage
    sourcespan = sourcerange(2) - sourcerange(1);
    if sourcespan == 0, error('Zero-length source range'); end
    valuescaled = (sourcevalue - sourcerange(1)) / sourcespan;
    valuescaled = valuescaled^exp;

    % taking given percentage of target range as target value
    targetspan = targetrange(2) - targetrange(1);
    targetvalue = targetrange(1) + (valuescaled * targetspan);

    if restrict
        % restricting value to the target range
        if targetvalue < min(targetrange)
            targetvalue = min(targetrange);
        elseif targetvalue > max(targetrange)
            targetvalue = max(targetrange);
        end
    end
end

end
