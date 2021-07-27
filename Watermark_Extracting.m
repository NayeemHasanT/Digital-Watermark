
[fname pthname]=uigetfile('*.jpg;*.png;*.tiff;*bmp','Select the Asset Image'); %select image
img=imread([pthname fname]);  %#read in MATLAB's stock image
A2=im2double(img); 
sx=size(A2);%watermark size
I2=A2;

[LLr,LHr,HLr,HHr]=dwt2(I2,'db1'); %DWT Decomposition
[LLr2,LHr2,HLr2,HHr2]=dwt2(LLr,'db1');
 
I=LHr2;
wt=I;
wt=I;

n = 1;
m = 2:b+1;
Top = zeros(n, length(m));
for o = 1:n
  Top(o, :) = m(randperm(length(m)));
end

number=Top;
numbernew=Top;

[r,c]=size(wt); 
n=r;
%.....................................................inverse Zig-zag ....
k=1;
for i=1:n
    for j=1:i;
         if mod(i,2)==0
                    zig(k)=(wt(j,i+1-j));
                        k=k+1;         
                     else
                    zig(k)=wt(i+1-j,j);
                    k=k+1; 

    end
    end
end

for i=1:n-1
    for j=1:n-i
        if mod(i,2)==0
           zig(k)=wt(n-j+1,j+i);
           k=k+1;
        else
           zig(k)=wt(i+j,n-j+1);
           k=k+1;
        end
       
    end
end
zig=double(zig);
%....................................................end ....

for a=1:n*n/2      
x1(a)=(zig(2*a));        %...................parallel vector.....
x2(a)=(zig(2*a-1));
end

x1=double(x1);
x2=double(x2);

x1da=dct(x1);    %...............DCT.................
x2da=dct(x2);

x1da(numbernew);
x2da(numbernew);
....................Bit extarction..........................
xExtrp=x1da(numbernew)-x2da(numbernew);
xExtr(xExtrp >=0) = 1;
xExtr(xExtrp <0) = -1;
numbernew;
.............................End.............................
            