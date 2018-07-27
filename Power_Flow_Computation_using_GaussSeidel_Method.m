%*************************************************************************%
%                               PRESENTATION

%Xi'An Jiaotong - Liverpool University
%EEE403 –Power System Networks and Smart Grid
%Module leader: Dr. Kejun Qian 
%Department of Electrical and Electronic Engineering 
%Author: Mateo RAMÍREZ
%Master Program - Sustainable Energy Technologies
%*************************************************************************%

%*************************************************************************%
%Clear loop
%*************************************************************************%
clearvars
clc
image = imread('Figure1.png');
imshow(image)

%*************************************************************************%
%User Interface Pop-Up Window
%*************************************************************************%
prompt={'Power Input_Bus1 [p.u.]:','Z_12 [p.u.]:','Z_13 [p.u.]:','Z_23 [p.u.]:','Load_Bus2:','Load_Bus3:','V2:','V3:','P.U. MVA Base:'};
dlg_title='Power Flow Analysis'; 
num_lines = [1,50];
defaultans={'1.05+0i','0.02+0.04i','0.01+0.03i','0.0125+0.025i','256.6+110.2i','138.6+45.2i','1+0i','1+0i','100'};
answer=inputdlg(prompt,dlg_title,num_lines,defaultans);

%*************************************************************************%
%Read Inputs
%*************************************************************************%
v1 = str2num(answer{1});                                                    %Read Power Input V1
z12 = str2num(answer{2});                                                   %Read Impedance Input z12
z13 = str2num(answer{3});                                                   %Read Impedance Input z13
z23 = str2num(answer{4});                                                   %Read Impedance Input z23
lb2 = str2num(answer{5});                                                   %Read Load Bus Input S2
lb3 = str2num(answer{6});                                                   %Read Load Bus Input S3
v2 = str2num(answer{7});                                                    %Read Voltage 2 V2
v3 = str2num(answer{8});                                                    %Read Voltage 3 V3
pubase = str2num(answer{9});                                                %PU MVA Base

%*************************************************************************%
%Variables Declared
%*************************************************************************%
n = 1;                                                                      %n while loop declaration

%*************************************************************************%
%Convert Impedances to Admitances
%*************************************************************************%
y12 = 1/z12;
y13 = 1/z13;
y23 = 1/z23;

%*************************************************************************%
%Convert Buses into Loads and into "Per-Unit"
%*************************************************************************%
s2 = (-1)*(lb2/pubase);
s3 = (-1)*(lb3/pubase);

%*************************************************************************%
%Identify Load P (real) and Q (imag) Values
%*************************************************************************%
p2 = real(s2);
q2 = imag(s2);
p3 = real(s3);
q3 = imag(s3);

%*************************************************************************%
%Create de the Bus Admittance Matrix
%*************************************************************************%
GS = [(y12+y13) -(y12) -(y13); 
      -(y12) (y12+y23) -(y23); 
      -(y13) -(y23) (y23+y13)];

%*************************************************************************%
%Current-Node Calculation Gauss - Siedel
%*************************************************************************%
while n > 0.0000001                                                         %Loop until error is less than 0.0000001
    
    v2e = (((p2-(q2*i))/conj(v2))+y12*v1+y23*v3)/(y12+y23);                 %Assign calculation to v2e
    v3e = (((p3-(q3*i))/conj(v3))+y13*v1+y23*v2)/(y13+y23);                 %Assign calculation to v3e
    e2 = abs(v2e - v2);                                                     %Error between v2e and v2 in memory
    e3 = abs(v3e - v3);                                                     %Error between v3e and v3 in memory
    v2 = v2e;                                                               %Assign v2e to v2 to keep in memory
    v3 = v3e;                                                               %Assgng v3e to v3 to keep in memory
    em = [e2,e3];                                                           %Create an error array
    n = max(em);                                                            %Obtain max value from error array and compare with "while" loop

end

%*************************************************************************%
%S1 Calculation
%*************************************************************************%
s1 = v1*(v1*(y12+y13)-(y12*v2+y13*v3));

%*************************************************************************%
%Display Results
%*************************************************************************%
disp('Bus Admittance Matrix:')
disp('         Yi1                Yi2                Yi3')
disp(GS)
%disp('V2 Value =')
%disp(v2)
%disp('V3 Value =')
%disp(v3)
%disp('S1 Value =')
%disp(s1)

uiwait(msgbox({['V2 Voltage = ' num2str(v2)];['V3 Voltage = ' num2str(v3)];['S1 Power = ' num2str(s1)]} ,'About !','modal'));
%msgbox({['The result is ' num2str(v2);' The result is ' num2str(v3)]})


