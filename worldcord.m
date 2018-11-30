function [x,y,z] = worldcord(xm,ym,zm,theta,focal,basis)

if ~isscalar(xm)
   error('Input xm must be scalar') 
end    

if ~isscalar(ym)
   error('Input ym must be scalar') 
end  
if ~isscalar(zm)
   error('Input zm must be scalar') 
end  
if ~isscalar(theta)
   error('Input theta must be scalar') 
end  
if ~isscalar(focal)
   error('Input focal must be scalar') 
end  
if ~isscalar(basis)
   error('Input basis must be scalar') 
end  

x = basis*(xm*tan(theta)+focal)/(2*(-xm*tan(theta)+focal));
y = basis*focal*tan(theta)/(-xm*tan(theta)+focal);
z = -basis*ym*tan(theta)/(xm*tan(theta)-focal);
end
