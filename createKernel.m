%%
function [ kernel, grad_x, grad_y ] = createKernel( height, width ,kernel_type)
    
    %% gaussian kernel
    if strcmp(kernel_type,'gaussian');
        sigma1 = height/6;
        sigma2 = width/6;
        kernel=zeros(height,width);
        for i=1:height
            for j=1:width
                kernel(i,j) = exp((-1/2.0)*((i-(1/2.0)*height)^2/sigma1^2+(j-(1/2.0)*width)^2/sigma2^2));
            end
        end

        [grad_x,grad_y] = gradient(-kernel);
    end
    %% gaussian kernel
    if strcmp(kernel_type,'epanechnikov');
        kernel=zeros(height,width);
        for i=1:height
            for j=1:width
                kernel(i,j) = 1-(2*i/height-1)^2-(2*j/width-1)^2;
                if(kernel(i,j)<0)
                    kernel(i,j)=0;
                end
            end

        end
       
        [grad_x,grad_y] = gradient(-kernel);
   end



end
