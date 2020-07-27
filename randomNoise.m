function noise = randomNoise(Panelsfilled)
if(Panelsfilled <= 12) % or 12
    noise = 8 + randperm(4,1);
else
    noise = 2 + randperm(6,1);
end
