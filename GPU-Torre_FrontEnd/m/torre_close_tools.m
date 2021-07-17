torre.h_fig_aux = findall(groot, 'Type','figure','-regexp','Name',[gputorre_name ' Frontend:*'],'-not','Name',[gputorre_name ' Frontend: Parameters tool']);
close(torre.h_fig_aux);
torre = rmfield(torre,'h_fig_aux');
