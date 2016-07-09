%%
 %findSimilarity(newPatch,kernel,q_pdf,p_pdf,h,w)
%%
function [coff,weights]=findSimilarity(newPatch,kernel,q_pdf,p_pdf,height,width)
weights = zeros(height,width);
coff = 0;
for i=1:height
    for j=1:width
        weights(i,j) = sqrt(q_pdf(newPatch(i,j)+1)/p_pdf(newPatch(i,j)+1));
        coff = coff+weights(i,j)*kernel(i,j);
    end
end
% Normalization of f
coff = coff/(height*width);