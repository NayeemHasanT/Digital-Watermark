[fname pthname]=uigetfile('*.jpg;*.png;*.tiff;*bmp','Select the Asset Image'); %select image
img=imread([pthname fname]);         %#read host image
imgDouble=im2double(img);        %#convert uint8 to double
imgGray=rgb2gray(img);           %#convert RGB image to grayscale
A=im2double(imgGray);
originalimage=A;

sx=size(A);%watermark size
I2=A;%get the first color in case of RGB image
 
[LLr,LHr,HLr,HHr]=dwt2(I2,'db1');     %DWT Decomposition
[LLr2,LHr2,HLr2,HHr2]=dwt2(LLr,'db1');

I=LLr2;
sizeofllr=size(I);  %subabnd Size: maximum lenght for watermark 


b= 255;  %lenght of watremark
wp = randi([-2, 1], [1,b]);

w(wp >-1) = 1;
w(wp <0) = -1;
wt=I;
 %..........................Random location selection........
n = 1;
m = 2:b+1;
Top = zeros(n, length(m));
for o = 1:n
  Top(o, :) = m(randperm(length(m)));
end
%.....................................................End ...........


number=Top;
numbernew=Top;
[r,c]=size(wt);  %Host image size
n=r;

%.....................................................Zig-zag ...........
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

%.....................................................End ...........
for a=1:n*n/2
x1(a)=(zig(2*a));
x2(a)=(zig(2*a-1));      
end

x1=double(x1);       % parallel vector
x2=double(x2);         % parallel vector

%...............................DCT.......................

x1d=dct(x1);
x2d=dct(x2);
x1dex=dct(x1);
x2dex=dct(x2);

eredA = randn(10,1);
Rco = corrcoef(x1,x2);


%...............................Embedding.......................
xp1=(.5*(x1d(number)+x2d(number)))+.2*w;
xp2=(.5*(x1d(number)+x2d(number)))-.2*w;

x1d(number)=xp1;
x2d(number)=xp2;

%...............................Inverse DCT.......................
xid1=idct(x1d);
xid2=idct(x2d);

[s1,s2]=size(x1d);


for a=1:((n*n/2))
x(2*a)=xid1(a);
x(2*a-1)=xid2(a);
end

[r,c]=size(wt);
n=r;

%.................................inverse zigzag.........................
k=1;
for i=1:n
    for j=1:i;
         if mod(i,2)==0
                    inz(j,i+1-j)=x(k);
                        k=k+1;         
                     else
                    inz(i+1-j,j)=x(k);
                    k=k+1; 

    end
    end
end
inz;



for i=1:n-1
    for j=1:n-i
        if mod(i,2)==0
           inz(n-j+1,j+i)=x(k);
           k=k+1;
        else
           inz(i+j,n-j+1)=x(k);
           k=k+1;
        end
       
    end
end
%..........................................................

preoriginalX = idwt2(inz,LHr2,HLr2,HHr2,'db1',sx);  %inverse DWT
originalX = idwt2(preoriginalX,LHr,HLr,HHr,'db1',sx); %inverse DWT


psnrofimage =psnrm(originalX,A)%......PSNR Function...............
%-----figure,imshow(originalX);title('originalx Image');

BB=originalX;
imwrite(BB,'pexfn2.jpg');  %....Watermarked Image...........

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

%............................image attack test.............

imwrite(BB1,'pexfn2.jpg','quality',10);
 %BB1 = imrotate(BB,45,'bilinear','crop'); %rotation
%{
BB11= imresize(BB, [256 256]); %sizing
 BB1= imresize(BB, [512 512]);
 %}
  %BB1 = imnoise(BB,'gaussian',.0005);
%BB1 = imnoise(BB,'gaussian',.001);
%BB1=imnoise(BB,'speckle',.01);
%BB1=imnoise(BB,'speckle',.02);
%BB1 = imnoise(BB,'salt',.01);
%BB1 = imnoise(BB,'salt',.02);
 %imshow(BB1);
%imwrite(BB1,'pexfn2.jpg');




