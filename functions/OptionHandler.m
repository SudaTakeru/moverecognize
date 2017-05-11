% Option Hndler
% This is a class which can handle options like 'flag, value' or 'flag'.
%
% Copyright (c) 2013 Yoshihiro Nakamura
% This software is released under the MIT License.
% http://opensource.org/licenses/mit-license.php

classdef OptionHandler
    properties
        options;
    end

    methods
        function obj = OptionHandler(options)
            % @param {string{}} options cell array expressing options.
            obj.options = OptionHandler.peelCell(options);
        end

        function value = get(obj, optionName, defaultValue)
            % get a value next to the specific flag.
            % If the flag doesn't exist, this returns default value.
            % @param {string} optionName flag
            % @param {any} defaultValue default value
            % @return value corresponding to the flag
            n = length(obj.options);
            for i = 1:n
                if strcmpi(obj.options{i}, optionName) && i+1 <= n
                    value = obj.options{i+1};
                    break;
                end
            end
            if ~exist('value','var')
                value = defaultValue;
            end
        end

        function tf = exist(obj, optionName)
            % check whether the specific flag is contained in options
            % @param {string} optionName flag
            % @return T/F
            for i = 1:length(obj.options)
                if strcmpi(obj.options{i}, optionName)
                    tf = true;
                    break;
                end
            end
            if ~exist('tf','var')
                tf = false;
            end
        end
    end
    
    methods(Static)
        function core = peelCell(cells)
            % When using the varargin of subclass's function as the varargin of superclass's function,
            % in superclass's function, varargin is nested.
            % This function handles these nested cells.
            if iscell(cells) && length(cells) == 1 && iscell(cells{1})
                core = OptionHandler.peelCell(cells{1});
            else
                core = cells;
            end
        end
    end
end