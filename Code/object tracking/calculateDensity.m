%{
Function Name: calculateDensity
Input: Patch matrix, kernel, height, width,map of indexed image and kernel type
Output: Probability  Density Function of the patch
Logic: PDF is created based on the kernel type.
%}
function [ q ] = calculateDensity( patch, kernel, height, width,map,kernel_type)


    q = zeros(size(map,1),1);
    for i=1:height
        for j=1:width
            q(patch(i,j)+1) = q(patch(i,j)+1) + kernel(i,j);
        end
    end


%Normalization constant
C = 1/sum(sum(kernel));
q =q*C;
end

