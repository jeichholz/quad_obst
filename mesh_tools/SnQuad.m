function [omegas,weights]=SnQuad(n)
%[omegas,wieghts]=SnQuad(n)
%**************************************************************************
%DESCRIPTION:  SnQuad returns quadrature nodes and wieghts for S_n
%quadrature. 
%
%INPUT:
%n    : The S_n quadrature you want.  Here, n refers to the number of
%distinct cosines, not the number of nodes.  The number of nodes is
%n*(n+2).  n must be one of 2,4,6,8,12,16.  If any other value is entered,
%16 will be the used value.
%
%OUPUT: 
%omegas: an array describing the nodes for the quadrautre. row i of
%the array is (x_i,y_i,z_i) of node i.
%
%wieghts: the wieghts to be used in numerical integration. The i'th entry
%of this array is the wieght to be used with node i.
%



QuadratureNumber=n;
%Simply read the table.  Use 16 as default.
if (QuadratureNumber == 2)
    mu(1) = 1/sqrt(3);
    weight(1) = 1;
    weightArr = [1];
else if (QuadratureNumber == 4 )
        mu(1) = .3500212;
        mu(2) = .8688903;
        weight(1) = 1/3;
        weightArr= [1,1,1];
    else if (QuadratureNumber == 6)
            mu(1) = .2666355;
            mu(2) = .6815076;
            mu(3) = .9261808;
            weight(1) = .1761263;
            weight(2) = .1572071;
            weightArr=[1,2,2,1,2,1];
        else if ( QuadratureNumber == 8 )
                mu(1) = .2182179;
                mu(2) = .5773503;
                mu(3) = .7867958;
                mu(4) = .9511897;
                weight(1) = .1209877;
                weight(2) = .0907407;
                weight(3) = .0925926;
                weightArr=[1,2,2,2,3,2,1,2,2,1];
            else if (QuadratureNumber == 12 )
                    mu(1) = .1672126;
                    mu(2) = .4595476;
                    mu(3) = .6280191;
                    mu(4) = .7600210;
                    mu(5) = .8722706;
                    mu(6) = .9716377;
                    weight(1) = .0707626;
                    weight(2) = .0558811;
                    weight(3) = .0373377;
                    weight(4) = .0502819;
                    weight(5) = .0258513;
                    weightArr=[1,2,2,3,4,3,3,5,5,3,2,4,5,4,2,1,2,3,3,2,1];
                else
                    mu(1) = .1389568;
                    mu(2) = .3922893;
                    mu(3) = .5370966;
                    mu(4) = .6504264;
                    mu(5) = .7467506;
                    mu(6) = .8319966;
                    mu(7) = .9092855;
                    mu(8) = .9805009;
                    weight(1) = .0489872;
                    weight(2) = .0413296;
                    weight(3) = .0212326;
                    weight(4) = .0256207;
                    weight(5) = .0360486;
                    weight(6) = .0144589;
                    weight(7) = .0344958;
                    weight(8) = .0085179;
                    weightArr = [1,2,2,3,5,3,4,6,6,4,4,7,8,7,4,3,6,8,8,6,3,2,5,6,7,6,5,2,1,2,3,4,4,3,2,1];
                end
            end
        end
    end
end

nu = mu;
eta = mu;

xx = 1;
for i = length(eta):-1:1
    for j = 1 : length(eta)-i+1
        Quad1(xx,1:3) = [mu(j),nu(length(eta)-i+1-j+1),eta(i)];
        Quad1(xx,4) = weight(weightArr(xx))*pi/2;
        xx=xx+1;
    end
end

Quad2 = Quad1; Quad2(:,2) =Quad2(:,2).*(-1);
Quad3 = Quad2; Quad3(:,3) = Quad3(:,3).*(-1);
Quad4 = Quad1; Quad4(:,3) = Quad4(:,3).*(-1);
Quad5 = Quad1; Quad5(:,1) = Quad5(:,1).*(-1);
Quad6 = Quad2; Quad6(:,1) = Quad6(:,1).*(-1);
Quad7 = Quad3; Quad7(:,1) = Quad7(:,1).* (-1);
Quad8 = Quad4; Quad8(:,1) = Quad8(:,1).*(-1);

% Now you have all the directions set up, and all the associated wieghts. 
%Make a list of all the angles, not separated by octant.  I do this because
%it makes it easier to integrate.  

allAngles(1:length(Quad1(:,1)),:)=Quad1;
allAngles(length(Quad1(:,1))+1:2*length(Quad1(:,1)),:)=Quad2;
allAngles(2*length(Quad1(:,1))+1:3*length(Quad1(:,1)),:)=Quad3;
allAngles(3*length(Quad1(:,1))+1:4*length(Quad1(:,1)),:)=Quad4;
allAngles(4*length(Quad1(:,1))+1:5*length(Quad1(:,1)),:)=Quad5;
allAngles(5*length(Quad1(:,1))+1:6*length(Quad1(:,1)),:)=Quad6;
allAngles(6*length(Quad1(:,1))+1:7*length(Quad1(:,1)),:)=Quad7;
allAngles(7*length(Quad1(:,1))+1:8*length(Quad1(:,1)),:)=Quad8;

omegas=allAngles(:,1:3);
weights=allAngles(:,4);