%{
Function Name: meanShift
Input: Image matrix, PDF of ROI in previous frame, x and y coordinate of top left of the patch,height and width of the patch, kernel,gradient of the kernel,
Bhattacharyya Coefficient, map of indexed matrix, maximum no of iteration for Mean Shift, threshold of similarity till which the mean is to be found iteratively.
Output: flag to indicate is object is present or not, x and y coordinates
of new patch,Bhattacharyya coefficient,index_out, no of iteration 
Logic: In this algorithm initially a region of interest is selected, then in consecutive iterations it looks in the region of interest and shifts the mean
in the direction of increasing density until no more shift is possible, i.e, it has reached the peak of the Probability Distribution Function (densest area). 
In the initial frame the object is chosen. Now the histogram is obtained and we come up with a PDF from this histogram. Histogram basically gives the
frequency of each of the pixel value. In the next frame we obtain the PDF of the same region and if the object has moved the PDF will not be exactly same. 
Now we use the Bhattacharyya Coefficient to check the similarity between the two PDFs any try to maximize the Bhattacharya Coefficient .Here we use mean shift which 
iteratively shifts the center of our ROI toward increasing Bhattacharya Coefficient until it reaches the maximum value. 
%}
function [ lossFlag,patch_x, patch_y, bCoeff, index_out ,itr] = meanShift( nf, q_pdf, patch_x, patch_y, patch_h, patch_w, kernel,  grad_x, grad_y,...
                                            bCoeff, index_in,map,max_itr,coff_thresh)
    [frame_height,frame_width]=size(nf);
    lossFlag =0;                                    
  
    nx=patch_x;
    ny=patch_y;
    newPatch = nf(ny:ny+patch_h-1,nx:nx+patch_w-1);
    p_pdf = calculateDensity(newPatch, kernel,patch_h,patch_w,map);
    itr = 1;
    %%computer similarity using battacharya cofficient
    [coff,weights]= findSimilarity(newPatch,kernel,q_pdf,p_pdf,patch_h,patch_w);                                  
    bCoeff(index_in)=coff;
    
    while itr<max_itr && coff<coff_thresh
        itr =itr+1;
        index_in = index_in+1;
        numerator_x= 0;
        numerator_y= 0;
        denominator = 0;
        for i = 1:patch_h
            for j = 1:patch_w
                numerator_x = numerator_x+i*weights(i,j)*grad_x(i,j);
                numerator_y = numerator_y+j*weights(i,j)*grad_y(i,j);
                denominator =  denominator+weights(i,j)*sqrt(grad_x(i,j)^2+grad_y(i,j)^2);
            end
        end
        %now find displacement and position of new candidate patch
        % if num is 0 do nothing else
        if denominator~=0
            patch_x=round(patch_x+numerator_x/denominator);
            patch_y =round(patch_y+numerator_y/denominator);
        end
        % set flag if object is lost
        if patch_x<1||patch_x+patch_w>frame_width...
                        ||patch_y<1||patch_y+patch_h>frame_height
            lossFlag=1;
     
            break;
        end
      
        %update the patch_window 
         newPatch = nf(patch_y:patch_y+patch_h-1,patch_x:patch_x+patch_w-1);
         p_pdf = calculateDensity(newPatch, kernel,patch_h,patch_w,map);
         [coff,weights]= findSimilarity(newPatch,kernel,q_pdf,p_pdf,patch_h,patch_w);     
         bCoeff(index_in)=coff;
         
    end
  
    index_out =index_in;
end

