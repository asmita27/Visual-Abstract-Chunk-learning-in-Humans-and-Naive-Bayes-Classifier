function Finalvector = checkforall (selectedChunksArray, imageIncreement,myCell) %takenPositions
global newPanel; % new panel to keep a track of filled ppositions
global Final; 
global countValidArray; % 
Final = zeros(1,1); % 
countValidArray = 1; %
newPanel = zeros(1,4); %
global add; %to keep a track while iterating for the final vector 
add = 1;
counter = 1;
% while loop to iterate through all the selected chunks to display valid
% positions
while (counter ~= (length(selectedChunksArray))+1)
    %position = cell2mat(myCell(chunkNo,5));
    chunkNo = selectedChunksArray(counter); 
    position = cell2mat(myCell(chunkNo,5)); % no of selected chunks 
    count = 1;
    
    % for loop to iterate through first chunk valid position
    
    for i=1:length(position(1,:))
    imageIncreement1 = position(1,i)+imageIncreement(chunkNo,1);
    imageIncreement2 = position(1,i)+imageIncreement(chunkNo,2);
    imageIncreement3 = position(1,i)+imageIncreement(chunkNo,3);
    
    
    check1 = check(position(1,i));
    check2 = check(imageIncreement1 );
    check3 = check(imageIncreement2 );
    check4 = check(imageIncreement3 );
    
    if (check1 && check2 && check3 && check4 )
        newValidposition(count) = position(1,i);
        count = count+1;
        i = i + 1;
    else
        i = i + 1;
        
    end
    
    end
    randposition = randperm(length(newValidposition(:,1)),1);
    
    if (randposition == 0)
        checkforall(takenPositions,selectedChunksArray,imageIncreement,myCell)
    else
        %add values for new valid positions array
        %add values to the existing positiosn array 
    addvalues(newValidposition(randposition),chunkNo,imageIncreement)
    end
   counter = counter+1;
   countValidArray = countValidArray + 1;
end
Finalvector = Final;
end


function proceed = check( number)
global newPanel;
if(newPanel(:,1) ~= number)
    proceed = true;
    
else
    proceed = false;
end 

if(newPanel(:,2) ~= number)
    proceed = true;
    
else
    proceed = false;
end 
if(newPanel(:,3) ~= number)
    proceed = true;
    
else
    proceed = false;
end 
if(newPanel(:,4) ~= number)
    proceed = true;
    
else
    proceed = false;
end 

end

function addvalues(randposition,chunkNo,imageIncreement)
global newPanel;
global add;
global Final;
global countValidArray;
    newPanel(add,1) = randposition;
    Final(countValidArray,1) = randposition;
    
    
    newPanel(add,2) = randposition + imageIncreement(chunkNo,1);
    Final(countValidArray,2) = randposition+imageIncreement(chunkNo,1);
   
    
    newPanel(add,3) = randposition +imageIncreement(chunkNo,2);
    Final(countValidArray,3) = randposition +imageIncreement(chunkNo,2);
    
    newPanel(add,4) = randposition +imageIncreement(chunkNo,3);
    Final(countValidArray,4) = randposition +imageIncreement(chunkNo,3);
    add = add+1;
end

