function [] = show_image_nicely(the_matrix_you_want_to_show_as_nice_image)

%The meaning of script is that is takes the matrix x,y and copy it three times
%so the third dimension is added so it becomes x,y,z. This means that the
%x,y,z can be showed as a RNG picture, where each channel have same value.
%The last step is to convert it into uint8


final=uint8(cat(3,the_matrix_you_want_to_show_as_nice_image,the_matrix_you_want_to_show_as_nice_image,the_matrix_you_want_to_show_as_nice_image));
figure()
imshow(final)

end


