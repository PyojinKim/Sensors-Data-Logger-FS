function [gradientsSubnet,gradientsParams,loss] = modelGradients(dlnet,fcParams,dlX1,dlX2,pairLabels)
% The modelGradients function calculates the binary cross-entropy loss between the
% paired images and returns the loss and the gradients of the loss with respect to
% the network learnable parameters

    % Pass the image pair through the network 
    Y = forwardSiamese(dlnet,fcParams,dlX1,dlX2);
    
    % Calculate binary cross-entropy loss
    loss = binarycrossentropy(Y,pairLabels);
       
    % Calculate gradients of the loss with respect to the network learnable
    % parameters
    [gradientsSubnet,gradientsParams] = dlgradient(loss,dlnet.Learnables,fcParams);
end

function loss = binarycrossentropy(Y,pairLabels)
    % binarycrossentropy accepts the network's prediction, Y, the true
    % label, pairLabels, and returns the binary cross-entropy loss value.
    
    % Get the precision of the prediction to prevent errors due to floating
    % point precision    
    y = extractdata(Y);
    if(isa(y,'gpuArray'))
        precision = classUnderlying(y);
    else
        precision = class(y);
    end
      
    % Convert values less than floating point precision to eps.
    Y(Y < eps(precision)) = eps(precision);
    %convert values between 1-eps and 1 to 1-eps.
    Y(Y > 1 - eps(precision)) = 1 - eps(precision);
    
    % Calculate binary cross-entropy loss for each pair
    loss = -pairLabels.*log(Y) - (1 - pairLabels).*log(1 - Y);
    
    % Sum over all pairs in minibatch and normalize.
    loss = sum(loss)/numel(pairLabels);
end