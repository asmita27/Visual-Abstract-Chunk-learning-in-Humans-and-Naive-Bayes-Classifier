function resumedialog(~)
d = dialog('Position',[500 400 250 150],'Name','click to resume');
btn = uicontrol('Parent',d,...
           'Position',[75 70 100 25],...
           'String','Resume',...
           'Callback','delete(gcf)');
exitbutton = uicontrol('Parent',d,...
           'Position',[85 20 70 25],...
           'String','exit',...
           'Callback','exit');
        
uiwait(d);
 