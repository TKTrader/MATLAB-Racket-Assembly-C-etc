% Thomson Kneeland
% 4/1/2018

% Divided Differences

% Program finds the an interpolating polynomial for given user
% inputs using the Newton divided differences method.
% I attempted to create a robust program (rather than simply solving the
% lab problem) so that this code can be reusable and robust for future purposes.

clc
clear 
close all

num = 0; % number of user inputs entered
n = 10;  % max number of terms
table = zeros(n); % initialize matrix for difference calculations
xPoints = zeros(n,1);  % initialize for user input x values
disp("This program finds the interpolating polynomial for an input set of points using Newton's divided difference method")
fprintf('\n')

%prompt for user entered points
while 1
    in = input('Enter the x value for a point or press enter if you have entered all points:  ');
    if isempty(in)  % exit loop if user presses 'enter'
        break
    else xPoints(num+1) = in;
    end    
    table(num+1,1) = input('Enter the function value for this point:  ');
    fprintf('\n')
    num = num + 1; % increment user input count for next loop
end
fprintf('\n')

% calculate divided differences, corresponds to tree graph
counter=num;  % decrementer to reduce extraneous computation
for col=2:num
    counter=counter-1; % decrement row computation count
    rowID=col;         % variable to keep track of first term in denominator
    for row=1:counter    
        table(row,col)=(table(row+1,col-1)-table(row,col-1))/(xPoints(rowID)-xPoints(row));
        rowID=rowID+1; % increment row
    end
    rowID=2; % reset row for next iteration
end 

% calculate Divided Difference polynomial
%term = sym('x'); % variable for term
term = 1;
x = sym('x');
poly = table(1,1);  % variable for final polynomial, initialize with f[xo]
div = 1; % counter for keeping track of divided difference term

% polynomial has n terms and n-1 divided difference terms; f[xo] is given
for k=2:num % iterate through n-1 divided difference terms
    for t=1:(k-1) % number of x terms in specific term
        term = term*(x-xPoints(t));
    end
    poly = poly+term*table(1,k); % add term to final polynomial
    term = 1; % reset term for next iteration
end

poly=expand(poly); % expand polynomial
disp("The Newton Divided Difference Interpolating Polynomial through those points is:")
disp(vpa(poly,5))  % displays as decimal, not fraction

% plots
% find maxima/minima of user entered values for axes constraints
% these values would need to be adjusted based on the order of values
% entered. we have set it up to plot well for the population data provided
% at the specific interval
xMin = min(xPoints(1:num));
xMax = max(xPoints(1:num));
if xMin<=0
    xMin=xMin*1.01;
else
    xMin=.99*xMin;
end

if xMax<=0
    xMax=xMax*.99;
else
    xMax=xMax*1.01;
end

f1 = figure(1);
fplot(poly,[xMin,xMax]) % ADD INPUT POINTS (INCOMPLETE)
axis('square')
xlabel('x')
ylabel('f(x)')
title('Newton Divided Difference Interpolation Polynomial')

% prompt for evaluation at a user entered point
while 1
    x0 = input('Enter an x value at which you would like to evaluate the interpolation function or press enter to quit:  ');
    if isempty(x0)  % exit loop if user presses 'enter'
        break
    else subs(poly,x,x0); % evaluate equation with x = user input x0
    output=double(ans); % display in double format (to prevent  fractional output)
    fprintf(1,'The function at point %f is %f\n',x0,output);
    fprintf('\n')
    disp('The tabular view of divided differences is:')
    disp(table(1:num,1:num))
    fprintf('\n')
    end    
end 

% Test examples
% x = 1.0    f(x)= .7651977
% x = 1.3    f(x)= .6200860
% x = 1.6    f(x)= .4554022
% x = 1.9    f(x)= .2818186
% x = 2.2    f(x)= .1103623
% expect P4(1.5) = .5118200
% result: .5118200
% VERIFIED

% approximate e^.826
% x0=.82         x1=.83   
% f(.82)=2.270500   f(.83)=2.293319
% expect:  e^.826 = 2.2841638 (true value)
% book result: 2.2841914
% our result: 2.284191   
% VERIFIED

% approximate e^.826
% x0=.82         x1=.83      x2=.84
% f(.82)=2.270500   f(.83)=2.293319    f(.84)=2.316367
% expect:  e^.826 = 2.2841638 (true value)
% book result: 2.2841639
% program result: 2.24164
% VERIFIED, close

% Find polynomical passing through (2,4) and (5,1)
% expect:  -4/3(x-5)+1/3(x-2)
% program output: 6-x     
% VERIFIED EQUATION

% LAB PROBLEM
% input:  
% (1960, 179323)
% (1970, 203302)
% (1980, 226542)
% (1990, 249633)
% (2000, 281422)
% (2010, 308746)
% output:
% 1950: 192539.0000
% 1975: 215525.7148 
% 2014: 306214.8876
% 2020: 266165.0000
% VERIFIED AS SAME AS Lagrange program Results!
