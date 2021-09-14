function torre_set_directory_items(tree_node, dir_item, varargin)

dir_path = [];
if not(isempty(varargin))
dir_path = varargin{1};
end

dir_node = uitreenode(tree_node, 'Text', dir_item);

if isfolder([dir_path '/' dir_item])

subdir_item = dir([dir_path '/' dir_item]);

for i = 3 : length(subdir_item)
subdir_item(i).name
isfolder([dir_path '/' dir_item '/' subdir_item(i).name])
    
   torre_set_directory_items(dir_node, subdir_item(i).name,[dir_path '/' dir_item])
   
end
end
end