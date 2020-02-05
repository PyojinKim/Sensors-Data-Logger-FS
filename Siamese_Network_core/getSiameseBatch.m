function [X1,X2,pairLabels] = getSiameseBatch(imds,miniBatchSize)
% getSiameseBatch returns a randomly selected batch or paired images. On
% average, this function produces a balanced set of similar and dissimilar
% pairs.

    pairLabels = zeros(1,miniBatchSize);
    imgSize = size(readimage(imds,1));
    X1 = zeros([imgSize 1 miniBatchSize]);
    X2 = zeros([imgSize 1 miniBatchSize]);

    for i = 1:miniBatchSize
        choice = rand(1);
        if choice < 0.5
            [pairIdx1,pairIdx2,pairLabels(i)] = getSimilarPair(imds.Labels);
        else
            [pairIdx1,pairIdx2,pairLabels(i)] = getDissimilarPair(imds.Labels);
        end
        X1(:,:,:,i) = imds.readimage(pairIdx1);
        X2(:,:,:,i) = imds.readimage(pairIdx2);
    end
end

function [pairIdx1,pairIdx2,pairLabel] = getSimilarPair(classLabel)
% getSimilarSiamesePair returns a random pair of indices for images
% that are in the same class and the similar pair label = 1.

    % Find all unique classes.
    classes = unique(classLabel);
    
    % Choose a class randomly which will be used to get a similar pair.
    classChoice = randi(numel(classes));
    
    % Find the indices of all the observations from the chosen class.
    idxs = find(classLabel==classes(classChoice));
    
    % Randomly choose two different images from the chosen class.
    pairIdxChoice = randperm(numel(idxs),2);
    pairIdx1 = idxs(pairIdxChoice(1));
    pairIdx2 = idxs(pairIdxChoice(2));
    pairLabel = 1;
end

function  [pairIdx1,pairIdx2,label] = getDissimilarPair(classLabel)
% getDissimilarSiamesePair returns a random pair of indices for images
% that are in different classes and the dissimilar pair label = 0.

    % Find all unique classes.
    classes = unique(classLabel);
    
    % Choose two different classes randomly which will be used to get a dissimilar pair.
    classesChoice = randperm(numel(classes),2);
    
    % Find the indices of all the observations from the first and second classes.
    idxs1 = find(classLabel==classes(classesChoice(1)));
    idxs2 = find(classLabel==classes(classesChoice(2)));
    
    % Randomly choose one image from each class.
    pairIdx1Choice = randi(numel(idxs1));
    pairIdx2Choice = randi(numel(idxs2));
    pairIdx1 = idxs1(pairIdx1Choice);
    pairIdx2 = idxs2(pairIdx2Choice);
    label = 0;
end