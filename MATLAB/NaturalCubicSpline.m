% Thomson Kneeland

% Natural Cubic Spline Interpolation

% Program finds the natural Cubic Spline polynomials for a set of inputs.
% we depict the function(s) as a set of 
% n points and n-1 subintervals and polynomials. The program uses a Natural
% Cubic Spline, as we do not know the derivative values of the function at the
% beginning/ending boundaries

clc
clear 
close all

num = 0; % number of user inputs entered
n = 20;  % max number of terms
xPoints = zeros(n,1);  % initialize for user input x values


disp("This program finds the interpolating polynomials for an input set of points using Natural Cubic Spline Interpolation")
fprintf('\n')

%prompt for user entered points
while 1
    in = input('Enter the x value for a point or press enter if you have entered all points:  ');
    if isempty(in)  % exit loop if user presses 'enter'
        break
    else xPoints(num+1) = in;
    end    
    num = num + 1; % increment user input count for next loop
    aCoeff(num,1) = input('Enter the function value for this point:  ');
    fprintf('\n')
end
fprintf('\n')

% initialze variables now that we know input dimension
A = zeros(num); % matrix for difference calculations
bCoeff = zeros(num,1); % coefficient vectors
dCoeff = zeros(num,1);
h = zeros(num-1,1); % vector for n-1 subintervals 
b = zeros(num,1); % vector for matrix multiplication Ax=b

% calculate subinterval lengths h
for i=1:(num-1)
    h(i)=xPoints(i+1)-xPoints(i); % calculate subinterval
end

% calculate strictly diagonally dominant matrix A
A(1,1)=1; % initialize diagonal corners
A(num,num)=1;
col=1; % column placeholder
for row=2:num-1
    A(row,col)=h(row-1);
    A(row,col+1)=2*(h(row-1)+h(row));
    A(row,col+2)=h(row);
    col=col+1;
end

% calculate b for Ax=b
% initialize first and last elements of vector with 0
b(1)=0;
b(num)=0;
for row=2:num-1
   b(row)=(3/h(row))*(aCoeff(row+1)-aCoeff(row))-(3/h(row-1))*(aCoeff(row)-aCoeff(row-1)); 
   %b(row)=3*(aCoeff(row+1)/h(row)-aCoeff(row)/h(row)-aCoeff(row)/h(row-1)+aCoeff(row-1)/h(row-1)); 
   %alternate, doesnt change output precision
end

% Now, given we have Ax=b, solve for x, which is the cCoeff vector
cCoeff=A\b;
 
% given cCoeff and aCoeff f(x), calculate bCoeff
for i=1:(num-1)
    bCoeff(i)=(1/h(i))*(aCoeff(i+1)-aCoeff(i))-(h(i)/3)*(2*cCoeff(i)+cCoeff(i+1));
end

% given cCoeff, calculate dCoeff
for i=1:(num-1)
    %dCoeff(i)=(cCoeff(i+1)-cCoeff(i))/(3*h(i)); % very inaccurate
    dCoeff(i)=cCoeff(i+1)/(3*h(i))-cCoeff(i)/(3*h(i));
end

% Use coefficients to output spline polynomials
x = sym('x');
poly = table(1,1);  % variable for final polynomial, initialize with f[xo]
div = 1; % counter for keeping track of divided difference term

% n-1 cubic polynomials with 4 terms
for k=1:(num-1)
    poly = aCoeff(k)+bCoeff(k)*(x-xPoints(k))+cCoeff(k)*(x-xPoints(k))^2+dCoeff(k)*(x-xPoints(k))^3;
    splines(k)=poly;
    poly=0; %reset polynomial for next iteration
end

disp("The Natural Cubic Splines through these points are:")
for i=1:num-1
    fprintf(1,'From %f to %f:\n',xPoints(i),xPoints(i+1));
    disp(vpa(splines(i),5 ))
end

% PLOTS
% find maxima/minima of user entered values for axes constraints
% these values would need to be adjusted based on the order of values
% entered. we have set it up to plot well for the population data provided
% at the specific interval
xMin = min(xPoints(1:num));
xMax = max(xPoints(1:num));
if xMin<=0
    xMin=xMin*1.01;%1.01
else
    xMin=.99*xMin;
end

if xMax<=0
    xMax=xMax*.99;
else
    xMax=xMax*1.01;
end

f1 = figure(1);
fplot(splines(1),[xMin,xPoints(2)]) % first spline
hold on
fplot(splines(num-1),[xPoints(num-1),xMax]) %last spline
for k =2:(num-2) % middle splines
    fplot(splines(k),[xPoints(k),xPoints(k+1)])
end

axis('square')
xlabel('x')
ylabel('f(x)')
title('Natural Cubic Spline Interpolant')

% prompt for evaluation at a user entered point
% find subinterval user point belongs to and evaluate with the associated
% spline polynomial
while 1
    x0 = input('Enter an x value at which you would like to evaluate the spline function or press enter to quit:  ');
    if isempty(x0)  % exit loop if user presses 'enter'
        break
    else  % evaluate equation with x = user input x0
        boolean = 0; % boolean for exiting for loop
        for i=2:num
            if (x0<= xPoints(i)) & (boolean==0)
                eq=i-1; % interval found
                boolean = 1; %boolean blocks future for loops
            end
        end
        if boolean==0  % interval not found, so x0 = extrapolation
            eq=num-1;
        end
        output=(double(subs(splines(eq),x,x0))); % display in double format (to prevent fractional output)
    fprintf(1,'The spline value at %f is %f\n',x0,output);
    fprintf('\n')
    end    
end 

% Test examples
% MATLAB function
% p = [1960 1970 1980 1990 2000 2010]
% q = [179323 203302 226542 249633 281422 308746]
% xx = 1950:1:2010
% s = spline(p,q,xx)
% plot(p,q,'o',xx,s)

% approximate f(x) = e^x at
% (0,1), (1,2.718),(2,7.389),(3,20.0855)
% expectation from book:
% c=(0,.75685,5.83007)
% b=(1.46600,2.22285,8.80977)
% d=(.25228,1.69107,-1.94336)
% OUTPUT:
% c=(0,.7573,5.8298,0)
% b=(1.4656,2.2229,8.8100)
% d=(.25224,1.6908,-1.9433)
% VERIFIED; f(x) input lost precision as approximation of e


% LAB PROBLEM
% input:  
% (1960, 179323)
% (1970, 203302)
% (1980, 226542)
% (1990, 249633)
% (2000, 281422)
% (2010, 308746)
