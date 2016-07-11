%{
Function Name:findSimilarity
Input: New patch, kernel, previous PDF, current PDF, height of the patch, width of the patch
Output: Returns the Bhattacharya Coefficient and weights matrix
Logic: Finds the similarity between two PDFs using the bhattacharyya
coefficient
%}
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