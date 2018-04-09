% Thomson Kneeland
% 3/31/2018

% Lagrange Polynomials

% Program finds the Lagrange Interpolating Polynomial for given user
% inputs.
% I attempted to create a universal program rather than simply solve the
% lab problem so that this code can be reusable and robust for future purposes.

% Though MATLAB can handle dynamic structures, my research tells me that
% MATLAB is inefficient at handling these, so we will overestimate an
% initial large array of 30 elements and reduce it based on user input.

% Note: since this code is being built from scratch, it will be
% "overcommented" for the sake of my own learning process and as documentation
% for my own future reference

clc
clear 
close all

num = 0; % number of user inputs entered
n = 30; % max number of inputs allowed
xPoints = zeros(n,1);  % initialize x and y inputs
yPoints = zeros(n,1);
disp("This program finds the Lagrange polynomial for an input set of points")
fprintf('\n')

%prompt for user entered points
while 1
    in = input('Enter the x value for a point or press enter if you have entered all points:  ');
    if isempty(in)  % exit loop if user presses 'enter'
        break
    else xPoints(num+1) = in;
    end    
    yPoints(num+1) = input('Enter the y value for this point:  ');
    fprintf('\n')
    num = num + 1; % increment user input count for next loop
end
fprintf('\n')

% calculate Lagrange coefficient
numerator=1;
denominator=1;
x = sym('x'); % create x variable
lagrange = sym('x',[num,1]); % initialize list for Lagrange polynomial terms using symbol

% multiplicatively loop through all members of set, but omit any i=j
for i = 1:num
    for j = 1:num
        if i==j
            continue
        end
        numerator = numerator*(x-xPoints(j));
        denominator = denominator*(xPoints(i)-xPoints(j));
    end
    % calculate each term 
    lagrange(i) = yPoints(i)* numerator/denominator; % store each polynomial in list
    numerator = 1;  % reset for next iteration
    denominator = 1;
end

% sum Lagrange terms for final equation
equation = lagrange(1); % initialize variable with first Lagrange polynomial 
for k = 2:num % add remaining terms to equation
    equation = equation +lagrange(k);
end
equation = expand(equation)  % expand polynomial

%equation=expand
disp("The Lagrange Interpolating Polynomial through those points is:")
disp(vpa(equation,7))

% plot
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
fplot(equation,[xMin,xMax]) % ADD INPUT POINTS- NOT DONE
axis('square')
xlabel('x')
ylabel('f(x)')
title('Lagrange Interpolation Polynomial')

%prompt for evaluation at a user entered point
while 1
    x0 = input('Enter an x value at which you would like to evaluate the interpolation function or press enter to quit:  ');
    if isempty(x0)  % exit loop if user presses 'enter'
        break
    else subs(equation,x,x0);
    output=double(ans); % display in double format (to prevent  fractional output)
    fprintf(1,'The function at point %f is %f\n',x0,output);
    fprintf('\n')
    end    
end

% Test cases for user entry and verification:

% f(x)=1/x
% x0=2      x1=2.75        x2=4
% f(2)=.5   f(2.75)=4/11   f(4)=.25
% expect f(3)=.333333
% expect equation f(x)=1/3(x-2.75)(x-4)-64/165(x-2)(x-4)+1/10(x-2)(x-2.75)
% book result = .32955
% Our result = .329545
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
% program result: 2.284164
% VERIFIED

% Find polynomical passing through (2,4) and (5,1)
% expect:  -4/3(x-5)+1/3(x-2)
% program output: 6-x     
% VERIFIED, albeit different form


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
