function torre_set_directory_items(tree_node, dir_item)

for i = 3 : length(dir_item)
   new_node = uitreenode(tree_node, 'Text', dir_item(i).name);
if isfolder([dir_item(i).folder '/' dir_item(i).name])
    new_dir_item = dir([dir_item(i).folder '/' dir_item(i).name]);
    torre_set_directory_items(new_node, new_dir_item)
end

end

end