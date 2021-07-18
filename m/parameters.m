%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D
function parameters(varargin)

parameters_size = 5;

if length(varargin) > 1
    torre_data = readcell(varargin{2});
else

if not(evalin('base','exist(''torre'')'))
torre_data = readcell('parameters_data.dat');
if size(torre_data,2) < parameters_size
      torre_data(:,parameters_size) = {''};
end
for torre_i = 1 : size(torre_data,1)
if ismissing(torre_data{torre_i,parameters_size})
torre_data{torre_i,parameters_size} = '';
end
end
elseif not(isstruct(evalin('base','torre')))
torre_data = readcell('parameters_data.dat');
if size(torre_data,parameters_size) < parameters_size
      torre_data(:,parameters_size) = {''};
end
for torre_i = 1 : size(torre_data,1)
if ismissing(torre_data{torre_i,parameters_size})
torre_data{torre_i,parameters_size} = '';
end
end
else 
torre_data = evalin('base', 'torre.parameters_data');
end
end

category_cell = 'All';

if evalin('base','exist(''torre'')')
if isstruct(evalin('base','torre'))
    if evalin('base','isfield(torre,''find_category'')')
        if not(isempty(evalin('base','torre.find_category')))
   category_cell = evalin('base','torre.find_category');
        end
    end
    end
end

if not(isempty(varargin))
    category_cell = varargin{1};
end

if ismember('All',category_cell) 
    category_cell = unique(torre_data(:,3))';
end
if  isempty(category_cell)
category_cell = unique(torre_data(:,3))';
end

for torre_i = 1 : size(torre_data)
    if ismember(torre_data{torre_i,3},category_cell)
        if not(ismember(torre_data{torre_i,4},{'Expression evaluate'}))
        if isequal(torre_data{torre_i,4},'Assign')
    assignin('base',torre_data{torre_i,1},torre_data{torre_i,2});
        elseif isequal(torre_data{torre_i,4},'Evaluate')
         evalin('base',[ torre_data{torre_i,1} ' = ' torre_data{torre_i,2} ';' ]);       
        end
        end
    end
end

for torre_i = 1 : size(torre_data)
    if ismember(torre_data{torre_i,3},category_cell)
     if isequal(torre_data{torre_i,4},'Expression evaluate')
         evalin('base',[torre_data{torre_i,2} ';']); 
        end
    end
end
         
clear torre_data; 

end