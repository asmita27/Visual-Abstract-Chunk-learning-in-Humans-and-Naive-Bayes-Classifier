%% SCRIPT FOR ANALYSIS
% This script performs Naive Bayes Classifiication for Visual Abstract
% Chunk classification. 10 folds cross validation is performed for training
% data 
% Input   : Name of the files to be processed. 
% Returns : Final Maximum a Posterori 
%           Naive Bayes structure with all subjects data separated in
%           Blocks(time duration) and merged data. 



clear 
files = {'Subject1.mat', 'Subject2.mat','Subject3.mat'};

for count = 1:numel(files)
load(files{count})

 N = num2str(count);
nameArray(count,1) =  {strcat('Subject',N)};
NaiveBayes.(nameArray{count,1}).data = data;
NaiveBayes.(nameArray{count,1}).merge.final_data = cat(1, data.Block1.chunkPresented,data.Block2.chunkPresented,data.Block3.chunkPresented);
NaiveBayes.(nameArray{count,1}).merge.CorrectResponse = cat(1, data.Block1.CorrectResponse,data.Block2.CorrectResponse,data.Block3.CorrectResponse);
NaiveBayes.(nameArray{count,1}).merge.final_labels = cat(1,data.Block1.labels,data.Block2.labels,data.Block3.labels);
NaiveBayes.(nameArray{count,1}).merge.randprob = cat(1,data.Block1.Randomdprob,data.Block2.Randomdprob,data.Block3.Randomdprob);
c = cvpartition(NaiveBayes.(nameArray{count,1}).merge.final_data(:,1),'KFold',10);
Test_data = c.TestSize;
for i = 2:length(Test_data)
Test_data(i) = Test_data(i) + Test_data(i-1);
end

fold = ["fold1","fold2","fold3","fold4","fold5","fold6","fold7","fold8","fold9","fold10"];
for i = 1:10
    
    % CROSS VALIDATION DATA 
    if (i ==1)
        NaiveBayes.(nameArray{count,1}).merge.(fold(i)).test_data = NaiveBayes.(nameArray{count,1}).merge.final_data(1:Test_data(i),:);
        NaiveBayes.(nameArray{count,1}).merge.(fold(i)).data = NaiveBayes.(nameArray{count,1}).merge.final_data(Test_data(i):length(NaiveBayes.(nameArray{count,1}).merge.final_data),:);
    
        NaiveBayes.(nameArray{count,1}).merge.(fold(i)).test_labels= NaiveBayes.(nameArray{count,1}).merge.final_labels(1:Test_data(i));
        NaiveBayes.(nameArray{count,1}).merge.(fold(i)).labels = NaiveBayes.(nameArray{count,1}).merge.final_labels(Test_data(i):length(NaiveBayes.(nameArray{count,1}).merge.final_data),:);
    else
        local_data = NaiveBayes.(nameArray{count,1}).merge.final_data;
        local_labels = NaiveBayes.(nameArray{count,1}).merge.final_labels;
        NaiveBayes.(nameArray{count,1}).merge.(fold(i)).test_data =  local_data(Test_data(i-1):Test_data(i),:);
        local_data(Test_data(i-1):Test_data(i),:) = [];
        NaiveBayes.(nameArray{count,1}).merge.(fold(i)).data = local_data;
    
        NaiveBayes.(nameArray{count,1}).merge.(fold(i)).test_labels= local_labels(Test_data(i-1):Test_data(i));
        local_labels(Test_data(i-1):Test_data(i)) = [];
        NaiveBayes.(nameArray{count,1}).merge.(fold(i)).labels = local_labels;
    end
    
    %% 
    


NaiveBayes.(nameArray{count,1}).merge.(fold(i)).NumberofTrials = size(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).data,1);
NaiveBayes.(nameArray{count,1}).merge.(fold(i)).NumberofFeatures = size(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).data,2);


for k = 1:NaiveBayes.(nameArray{count,1}).merge.(fold(i)).NumberofTrials
   NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class1N(k)= length(find(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).labels(1:k)==1));
   NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class2N(k) = length(find(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).labels(1:k)==2));
end


for k = 1:NaiveBayes.(nameArray{count,1}).merge.(fold(i)).NumberofTrials
    for j=1:NaiveBayes.(nameArray{count,1}).merge.(fold(i)).NumberofFeatures
        NaiveBayes.(nameArray{count,1}).merge.(fold(i)).N_featureC1(k,j)=length(intersect(find(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).data(1:k,j)~=0),find(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).labels(1:k)==1)));
        NaiveBayes.(nameArray{count,1}).merge.(fold(i)).N_featureC2(k,j)=length(intersect(find(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).data(1:k,j)~=0),find(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).labels(1:k)==2)));
    end
end

% prior
NaiveBayes.(nameArray{count,1}).merge.(fold(i)).a_pi = 1;
NaiveBayes.(nameArray{count,1}).merge.(fold(i)).b_pi = 1;
for j=1:NaiveBayes.(nameArray{count,1}).merge.(fold(i)).NumberofFeatures
    NaiveBayes.(nameArray{count,1}).merge.(fold(i)).a_u(j) = 1;
    NaiveBayes.(nameArray{count,1}).merge.(fold(i)).b_u(j) = 1;
    NaiveBayes.(nameArray{count,1}).merge.(fold(i)).a_v(j) = 1;
    NaiveBayes.(nameArray{count,1}).merge.(fold(i)).b_v(j) = 1;
end

% MAP , fit data 
len1 = NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class1N(end);
NaiveBayes.(nameArray{count,1}).merge.(fold(i)).piClass1 = (NaiveBayes.(nameArray{count,1}).merge.(fold(i)).a_pi + NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class1N(len1) + 1) ./ (NaiveBayes.(nameArray{count,1}).merge.(fold(i)).a_pi + NaiveBayes.(nameArray{count,1}).merge.(fold(i)).b_pi + NaiveBayes.(nameArray{count,1}).merge.(fold(i)).NumberofTrials + 2);
NaiveBayes.(nameArray{count,1}).merge.(fold(i)).piClass2 = 1 - NaiveBayes.(nameArray{count,1}).merge.(fold(i)).piClass1;

for k = 1:NaiveBayes.(nameArray{count,1}).merge.(fold(i)).NumberofTrials
for j=1:NaiveBayes.(nameArray{count,1}).merge.(fold(i)).NumberofFeatures
   NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class1MAP(k,j) = (NaiveBayes.(nameArray{count,1}).merge.(fold(i)).a_u(j) + NaiveBayes.(nameArray{count,1}).merge.(fold(i)).N_featureC1(k,j)+ 1)./(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).a_u(j) +NaiveBayes.(nameArray{count,1}).merge.(fold(i)).b_u(j) + NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class1N(k) + 2);
   NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class2MAP(k,j) = (NaiveBayes.(nameArray{count,1}).merge.(fold(i)).a_v(j) + NaiveBayes.(nameArray{count,1}).merge.(fold(i)).N_featureC2(k,j)+ 1)./(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).a_v(j) + NaiveBayes.(nameArray{count,1}).merge.(fold(i)).b_v(j) + NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class2N(k)+ 2);
end
end

len = NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class1N(end);
NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Weight1 = log(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class1MAP(len,:)./(1-NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class1MAP(len,:))) - log(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class2MAP(len,:)./(1-NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class2MAP(len,:)));
NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Weight0 = sum(log((1-NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class1MAP(len,:))./(1-NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class2MAP(len,:))))+log(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).piClass1./NaiveBayes.(nameArray{count,1}).merge.(fold(i)).piClass2);




for j = 1:length(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).test_data)
  
  NaiveBayes.(nameArray{count,1}).merge.(fold(i)).sigmoid(j) = 1./(1+exp((-NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Weight1*-NaiveBayes.(nameArray{count,1}).merge.(fold(i)).test_data(j,:)') - NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Weight0));

end

for j =1:length(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).sigmoid)
    
    if(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).sigmoid(j)>0.5)
        NaiveBayes.(nameArray{count,1}).merge.(fold(i)).PredictClass(j) = 2;
    else
        NaiveBayes.(nameArray{count,1}).merge.(fold(i)).PredictClass(j) = 1;
    end
end

% Prediction accuracy
NaiveBayes.(nameArray{count,1}).merge.(fold(i)).prediction_acc = (sum(abs(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).PredictClass'== NaiveBayes.(nameArray{count,1}).merge.(fold(i)).test_labels)))/size(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).test_data,1)

end

%% BLOCK 1

NaiveBayes.(nameArray{count,1}).Block1.final_data = data.Block1.chunkPresented;
NaiveBayes.(nameArray{count,1}).Block1.final_labels = data.Block1.labels;
c = cvpartition(NaiveBayes.(nameArray{count,1}).Block1.final_data(:,1),'KFold',10);
Test_data = c.TestSize;
for i = 2:length(Test_data)
Test_data(i) = Test_data(i) + Test_data(i-1);
end
fold = ["fold1","fold2","fold3","fold4","fold5","fold6","fold7","fold8","fold9","fold10"];
for i = 1:10
    
    % CROSS VALIDATION DATA 
    if (i ==1)
        NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).test_data = NaiveBayes.(nameArray{count,1}).Block1.final_data(1:Test_data(i),:);
        NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).data = NaiveBayes.(nameArray{count,1}).Block1.final_data(Test_data(i):length(NaiveBayes.(nameArray{count,1}).Block1.final_data),:);
    
        NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).test_labels= NaiveBayes.(nameArray{count,1}).Block1.final_labels(1:Test_data(i));
        NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).labels = NaiveBayes.(nameArray{count,1}).Block1.final_labels(Test_data(i):length(NaiveBayes.(nameArray{count,1}).Block1.final_data),:);
    else
        local_data = NaiveBayes.(nameArray{count,1}).Block1.final_data;
        local_labels = NaiveBayes.(nameArray{count,1}).Block1.final_labels;
        NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).test_data =  local_data(Test_data(i-1):Test_data(i),:)
        local_data(Test_data(i-1):Test_data(i),:) = []
        NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).data = local_data
    
        NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).test_labels= local_labels(Test_data(i-1):Test_data(i))
        local_labels(Test_data(i-1):Test_data(i)) = [];
        NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).labels = local_labels
    end
    
    %% 
    


NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).NumberofTrials = size(NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).data,1);
NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).NumberofFeatures = size(NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).data,2);


for k = 1:NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).NumberofTrials
   NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Class1N(k)= length(find(NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).labels(1:k)==1));
   NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Class2N(k) = length(find(NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).labels(1:k)==2));
end

for k = 1:NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).NumberofTrials
for j=1:NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).NumberofFeatures
  NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).N_featureC1(k,j)=length(intersect(find(NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).data(1:k,j)~=0),find(NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).labels(1:k)==1)));
  NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).N_featureC2(k,j)=length(intersect(find(NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).data(1:k,j)~=0),find(NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).labels(1:k)==2)));
end
end

% prior
NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).a_pi = 1;
NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).b_pi = 1;
for j=1:NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).NumberofFeatures
    NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).a_u(j) = 1;
    NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).b_u(j) = 1;
    NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).a_v(j) = 1;
    NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).b_v(j) = 1;
end

% MAP , fit data 
len1 = NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Class1N(end);
NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).piClass1 = (NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).a_pi + NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Class1N(len1) + 1) ./ (NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).a_pi + NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).b_pi + NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).NumberofTrials + 2);
NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).piClass2 = 1 - NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).piClass1;

for k = 1:NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).NumberofTrials
for j=1:NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).NumberofFeatures
   NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Class1MAP(k,j) = (NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).a_u(j) + NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).N_featureC1(k,j)+ 1)./(NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).a_u(j) +NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).b_u(j) + NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Class1N(k) + 2);
   NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Class2MAP(k,j) = (NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).a_v(j) + NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).N_featureC2(k,j)+ 1)./(NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).a_v(j) + NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).b_v(j) + NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Class2N(k)+ 2);
end
end


len = NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Class1N(end);
NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Weight1 = log(NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Class1MAP(len,:)./(1-NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Class1MAP(len,:))) - log(NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Class2MAP(len,:)./(1-NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Class2MAP(len,:)));
NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Weight0 = sum(log((1-NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Class1MAP(len,:))./(1-NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Class2MAP(len,:))))+log(NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).piClass1./NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).piClass2);




for j = 1:length(NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).test_data)
  
   NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).sigmoid(j) = 1./(1+exp(-NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Weight1*NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).test_data(j,:)'-NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).Weight0));
    
end

for j =1:length(NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).sigmoid)
    
    if(NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).sigmoid(j)>=0.5)
        NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).PredictClass(j) = 2;
    else
        NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).PredictClass(j) = 1;
    end
end

% Prediction accuracy
NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).prediction_acc = (sum(abs(NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).PredictClass'-NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).test_labels)))/size(NaiveBayes.(nameArray{count,1}).Block1.(fold(i)).test_data,1)

end

%% BLOCK 2

NaiveBayes.(nameArray{count,1}).Block2.final_data = data.Block2.chunkPresented;
NaiveBayes.(nameArray{count,1}).Block2.final_labels = data.Block2.labels;
c = cvpartition(NaiveBayes.(nameArray{count,1}).Block2.final_data(:,1),'KFold',10);
Test_data = c.TestSize;
for i = 2:length(Test_data)
Test_data(i) = Test_data(i) + Test_data(i-1);
end
fold = ["fold1","fold2","fold3","fold4","fold5","fold6","fold7","fold8","fold9","fold10"];
for i = 1:10
    
    % CROSS VALIDATION DATA 
    if (i ==1)
        NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).test_data = NaiveBayes.(nameArray{count,1}).Block2.final_data(1:Test_data(i),:);
        NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).data = NaiveBayes.(nameArray{count,1}).Block2.final_data(Test_data(i):length(NaiveBayes.(nameArray{count,1}).Block2.final_data),:);
    
        NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).test_labels= NaiveBayes.(nameArray{count,1}).Block2.final_labels(1:Test_data(i));
        NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).labels = NaiveBayes.(nameArray{count,1}).Block2.final_labels(Test_data(i):length(NaiveBayes.(nameArray{count,1}).Block2.final_data),:);
    else
        local_data = NaiveBayes.(nameArray{count,1}).Block2.final_data;
        local_labels = NaiveBayes.(nameArray{count,1}).Block2.final_labels;
        NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).test_data =  local_data(Test_data(i-1):Test_data(i),:)
        local_data(Test_data(i-1):Test_data(i),:) = []
        NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).data = local_data
    
        NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).test_labels= local_labels(Test_data(i-1):Test_data(i))
        local_labels(Test_data(i-1):Test_data(i)) = [];
        NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).labels = local_labels
    end
    
    %% 
    


NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).NumberofTrials = size(NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).data,1);
NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).NumberofFeatures = size(NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).data,2);

for k = 1:NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).NumberofTrials
   NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Class1N(k)= length(find(NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).labels(1:k)==1));
   NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Class2N(k) = length(find(NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).labels(1:k)==2));
end


for k = 1:NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).NumberofTrials
for j=1:NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).NumberofFeatures
  NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).N_featureC1(k,j)=length(intersect(find(NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).data(1:k,j)~=0),find(NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).labels(1:k)==1)));
  NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).N_featureC2(k,j)=length(intersect(find(NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).data(1:k,j)~=0),find(NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).labels(1:k)==2)));
end
end

% prior
NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).a_pi = 1;
NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).b_pi = 1;
for j=1:NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).NumberofFeatures
    NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).a_u(j) = 1;
    NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).b_u(j) = 1;
    NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).a_v(j) = 1;
    NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).b_v(j) = 1;
end

% MAP , fit data 
len1 = NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Class1N(end);
NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).piClass1 = (NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).a_pi + NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Class1N(len1) + 1) ./ (NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).a_pi + NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).b_pi + NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).NumberofTrials + 2);
NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).piClass2 = 1 - NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).piClass1;

for k = 1:NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).NumberofTrials
for j=1:NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).NumberofFeatures
   NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Class1MAP(k,j) = (NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).a_u(j) + NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).N_featureC1(k,j)+ 1)./(NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).a_u(j) +NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).b_u(j) + NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Class1N(k) + 2);
   NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Class2MAP(k,j) = (NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).a_v(j) + NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).N_featureC2(k,j)+ 1)./(NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).a_v(j) + NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).b_v(j) + NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Class2N(k)+ 2);
end
end

len = NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Class1N(end);
NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Weight1 = log(NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Class1MAP(len,:)./(1-NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Class1MAP(len,:))) - log(NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Class2MAP(len,:)./(1-NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Class2MAP(len,:)));
NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Weight0 = sum(log((1-NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Class1MAP(len,:))./(1-NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Class2MAP(len,:))))+log(NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).piClass1./NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).piClass2);





for j = 1:length(NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).test_data)
  
   NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).sigmoid(j) = 1./(1+exp(-NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Weight1*NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).test_data(j,:)'-NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).Weight0));
end

for j =1:length(NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).sigmoid)
    
    if(NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).sigmoid(j)>=0.5)
        NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).PredictClass(j) = 2;
    else
        NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).PredictClass(j) = 1;
    end
end

% Prediction accuracy
NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).prediction_acc = (sum(abs(NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).PredictClass'-NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).test_labels)))/size(NaiveBayes.(nameArray{count,1}).Block2.(fold(i)).test_data,1)

end

%% BLOCK 3

NaiveBayes.(nameArray{count,1}).Block3.final_data = data.Block3.chunkPresented;
NaiveBayes.(nameArray{count,1}).Block3.final_labels = data.Block3.labels;
c = cvpartition(NaiveBayes.(nameArray{count,1}).Block3.final_data(:,1),'KFold',10);
Test_data = c.TestSize;
for i = 2:length(Test_data)
Test_data(i) = Test_data(i) + Test_data(i-1);
end
fold = ["fold1","fold2","fold3","fold4","fold5","fold6","fold7","fold8","fold9","fold10"];
for i = 1:10
    
    % CROSS VALIDATION DATA 
    if (i ==1)
        NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).test_data = NaiveBayes.(nameArray{count,1}).Block3.final_data(1:Test_data(i),:);
        NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).data = NaiveBayes.(nameArray{count,1}).Block3.final_data(Test_data(i):length(NaiveBayes.(nameArray{count,1}).Block3.final_data),:);
    
        NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).test_labels= NaiveBayes.(nameArray{count,1}).Block3.final_labels(1:Test_data(i));
        NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).labels = NaiveBayes.(nameArray{count,1}).Block3.final_labels(Test_data(i):length(NaiveBayes.(nameArray{count,1}).Block3.final_data),:);
    else
        local_data = NaiveBayes.(nameArray{count,1}).Block3.final_data;
        local_labels = NaiveBayes.(nameArray{count,1}).Block3.final_labels;
        NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).test_data =  local_data(Test_data(i-1):Test_data(i),:)
        local_data(Test_data(i-1):Test_data(i),:) = []
        NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).data = local_data
    
        NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).test_labels= local_labels(Test_data(i-1):Test_data(i))
        local_labels(Test_data(i-1):Test_data(i)) = [];
        NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).labels = local_labels
    end
    
    %% 
    


NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).NumberofTrials = size(NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).data,1);
NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).NumberofFeatures = size(NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).data,2);


for k = 1:NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).NumberofTrials
   NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Class1N(k)= length(find(NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).labels(1:k)==1));
   NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Class2N(k) = length(find(NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).labels(1:k)==2));
end

for k = 1:NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).NumberofTrials
for j=1:NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).NumberofFeatures
  NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).N_featureC1(k,j)=length(intersect(find(NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).data(1:k,j)~=0),find(NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).labels(1:k)==1)));
  NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).N_featureC2(k,j)=length(intersect(find(NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).data(1:k,j)~=0),find(NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).labels(1:k)==2)));
end
end

% prior
NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).a_pi = 1;
NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).b_pi = 1;
for j=1:NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).NumberofFeatures
    NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).a_u(j) = 1;
    NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).b_u(j) = 1;
    NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).a_v(j) = 1;
    NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).b_v(j) = 1;
end

% MAP , fit data 
len1 = NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Class1N(end);
NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).piClass1 = (NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).a_pi + NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Class1N(len1) + 1) ./ (NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).a_pi + NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).b_pi + NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).NumberofTrials + 2);
NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).piClass2 = 1 - NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).piClass1;

for k = 1:NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).NumberofTrials
for j=1:NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).NumberofFeatures
   NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Class1MAP(k,j) = (NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).a_u(j) + NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).N_featureC1(k,j)+ 1)./(NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).a_u(j) +NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).b_u(j) + NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Class1N(k) + 2);
   NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Class2MAP(k,j) = (NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).a_v(j) + NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).N_featureC2(k,j)+ 1)./(NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).a_v(j) + NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).b_v(j) + NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Class2N(k)+ 2);
end
end

len = NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Class1N(end);
NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Weight1 = log(NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Class1MAP(len,:)./(1-NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Class1MAP(len,:))) - log(NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Class2MAP(len,:)./(1-NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Class2MAP(len,:)));
NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Weight0 = sum(log((1-NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Class1MAP(len,:))./(1-NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Class2MAP(len,:))))+log(NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).piClass1./NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).piClass2);



for j = 1:length(NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).test_data)
  
   NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).sigmoid(j) = 1./(1+exp(-NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Weight1*NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).test_data(j,:)'-NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).Weight0));
 end

for j =1:length(NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).sigmoid)
    
    if(NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).sigmoid(j)>=0.5)
        NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).PredictClass(j) = 2;
    else
        NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).PredictClass(j) = 1;
    end
end

% Prediction accuracy
NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).prediction_acc = (sum(abs(NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).PredictClass'-NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).test_labels)))/size(NaiveBayes.(nameArray{count,1}).Block3.(fold(i)).test_data,1)

end


end

for count = 1:length(nameArray)
    for i = 1:length(fold)
        l1 = length(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class1MAP);
        l2 = length(NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class2MAP);
       NaiveBayes.(nameArray{count,1}).final_C1MAP(i,:) = NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class1MAP(l1,:);
       NaiveBayes.(nameArray{count,1}).final_C2MAP(i,:) = NaiveBayes.(nameArray{count,1}).merge.(fold(i)).Class2MAP(l2,:);
    end
end

for count = 1:length(nameArray)
    NaiveBayes.final_C1MAP = mean(NaiveBayes.(nameArray{count,1}).final_C1MAP,1);
    NaiveBayes.final_C1std = std(NaiveBayes.(nameArray{count,1}).final_C1MAP,1);
    NaiveBayes.final_C2MAP = mean(NaiveBayes.(nameArray{count,1}).final_C2MAP,1);
    NaiveBayes.final_C2std = std(NaiveBayes.(nameArray{count,1}).final_C2MAP,1);
end
