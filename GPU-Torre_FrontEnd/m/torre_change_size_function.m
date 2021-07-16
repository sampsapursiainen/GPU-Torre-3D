function [p_vec_window] = torre_change_size_function(object_handle, current_size, varargin)

relative_size = [];
if not(isempty(varargin))
    if length(varargin) > 0 %#ok<ISMT>
        relative_size = varargin{1};
    end
end

p_vec_window = get(object_handle(1),'Position');
    h = [];
    for i = 1 : length(object_handle)
        h_aux = get(object_handle(i), 'Children');
        h = [h; h_aux];
    end
if isempty(relative_size)
    for i = 1 : length(h)
        p_vec_object = get(h(i),'Position');
        fontsize_scaling = isprop(h(i),'FontSize');
        if fontsize_scaling
            fontsize_object = get(h(i),'FontSize');
        end
        if length(p_vec_object)==4
            p_vec = [p_vec_object(1).*p_vec_window(3)./current_size(3) p_vec_object(2).*p_vec_window(4)./current_size(4) p_vec_object(3).*p_vec_window(3)./current_size(3) p_vec_object(4).*p_vec_window(4)./current_size(4)];
            h(i).Position = p_vec;
            if fontsize_scaling
                set(h(i),'FontSize',fontsize_object*p_vec_window(4)./current_size(4));
            end
        end
    end
else
    h_position = get(h,'Position');
    for i = 1 : length(h)
        if size(h_position{i},2) == 4
            set(h(i),'Position',relative_size{i}.*p_vec_window([3 4 3 4]));
            fontsize_scaling = isprop(h(i),'FontSize');
            if fontsize_scaling
                fontsize_object = get(h(i),'FontSize');
                set(h(i),'FontSize',fontsize_object*p_vec_window(4)./current_size(4));
            end
        end
    end
end
end