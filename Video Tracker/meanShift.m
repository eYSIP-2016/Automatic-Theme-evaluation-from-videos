%%
% [lossFlag, newPatchX, newPatchY, bCoeff, index_out] = meanShift(newFrame,...
%                                     q, x, y, h, w, kernel, grad_x, grad_y,...
%                                     bCoeff, index_in,map);
%%
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

