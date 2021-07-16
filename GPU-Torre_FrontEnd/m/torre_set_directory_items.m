function torre_set_directory_items(tree_node, dir_item)

dir_node = uitreenode(tree_node, 'Text', dir_item);


if isfolder(dir_item)
subdir_item = dir(dir_item);

for i = 3 : length(subdir_item)
   torre_set_directory_items(dir_node, subdir_item(i).name)
end


end


end