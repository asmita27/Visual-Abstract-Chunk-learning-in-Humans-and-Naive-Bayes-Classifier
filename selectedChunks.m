function [newIndexArray,randomProb,chunkPresented] = selectedChunks(class)
pd = makedist ( 'Normal');
t = truncate (pd, 0, 1);
randomProb = random (t, 1, 1);
newIndexArray = zeros(1);
chunkPresented = zeros(1);
count = 1;
for i = 1:length(class)
    if(randomProb<=class(i))
        newIndexArray(count) = i;
        count = count + 1;
    end
end
if (newIndexArray(1,1) == 0)
    newIndexArray = selectedChunks (class);
else
    chunkPresented = presented(newIndexArray);
end
end
function chunkPresented = presented(newIndexArray)
    for i = 1:length(newIndexArray)
        chunkPresented(1,newIndexArray(i)) = 1;
    end
end
        