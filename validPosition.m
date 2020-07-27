function panelNo = validPosition(takenPositions, validposition, imageIncreement,chunkNo)

k =length(validposition(1,:));
count = 1;
for i = 1:k
    imageIncreement1 = validposition(1,i)+imageIncreement(chunkNo,1);
    imageIncreement2 = validposition(1,i)+imageIncreement(chunkNo,2);
    imageIncreement3 = validposition(1,i)+imageIncreement(chunkNo,3);
    
    
    check1 = check(takenPositions, validposition(1,i));
    check2 = check(takenPositions, imageIncreement1 );
    check3 = check(takenPositions, imageIncreement2 );
    check4 = check(takenPositions, imageIncreement3 );
    
    if (check1 && check2 && check3 && check4 )
        newValidposition(count) = validposition(1,i);
        count = count+1;
        i = i + 1;
    else
        i = i + 1;
        
    end
end
    randposition = randperm(length(newValidposition(:,1)),1);
    panelNo = newValidposition(randposition) ;
end


function proceed = check(array, number)
if(array(:,1) ~= number)
    proceed = true;
else
    proceed = false;
end 
end

