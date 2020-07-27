function feedback(correctclass,selectedclass)
if (correctclass == selectedclass)
    Feedback = 'Correct response';
    % feedback = strcat('correct response', var// which the selected panel
    % no) for adding string together 
    resumedialog(Feedback);
else
    Feedback = 'Incorrect response';
    resumedialog(Feedback);
end
end

function resumedialog(var)
d = dialog('Position',[500 400 250 150],'Name','Feedback');

  UIControl_FontSize_bak = get(0, 'DefaultUIControlFontSize');
           set(0, 'DefaultUIControlFontSize', 30);
 txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 40],...
               'String',var);
         
           set(0, 'DefaultUIControlFontSize', UIControl_FontSize_bak);
           
pause(1)
close;
end 
