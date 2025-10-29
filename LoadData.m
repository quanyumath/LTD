function [data, map, b, Img, La] = LoadData(option)
% Airport2 4[0.5 2e-1] Airport4 2[0.1 5e-1] 
% Beach2 6[25 1e0]   Beach4 4[5e-2 5e-4]
% Urban2 2[5e-2 1e0]  Urban5 4[5e-2 4e-1]
if option == 1
    load abu-airport-2
    b = 4;
    Img = 'Airport2';
    La = [5e-1 5e-1];
elseif option == 2
    load abu-airport-4
    b = 2;
    Img = 'Airport4';
    La = [1e-1 5e-1];
elseif option == 3
    load abu-urban-2
    b = 2;
    Img = 'Urban2';
    La = [1e-2 5e-1];
elseif option == 4
    load abu-urban-5
    b = 4;
    Img = 'Urban5';
    La = [1e-2 5e-1];
end



% function [data, map, b, Img] = LoadData(option)
% % Airport2 4[0.5 2e-1] Airport4 2[0.1 5e-1] 
% % Beach2 6[25 1e0]   Beach4 4[5e-2 5e-4]
% % Urban2 2[5e-2 1e0]  Urban5 4[5e-2 4e-1]
% if option == 1
%     load abu-airport-2
%     b = 4;
%     Img = 'Airport2';
%     La = [5e-1 5e-1];
% elseif option == 2
%     load abu-airport-4
%     b = 2;
%     Img = 'Airport4';
%     La = [1e-1 5e-1];
% elseif option == 3
%     load abu-beach-2
%     b = 6;
%     Img = 'Beach2';
% elseif option == 4
%     load abu-beach-4
%     b = 4;
%     Img = 'Beach4';
% elseif option == 5
%     load abu-urban-2
%     b = 2;
%     Img = 'Urban2';
%     
% elseif option == 6
%     load abu-urban-5
%     b = 4;
%     Img = 'Urban5';
% end
% 
% 
% 
% 
% 
% 
% 
% 
