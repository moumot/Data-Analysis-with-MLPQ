function TINfunction(x,y,z)
TRI = delaunay(x,y);          % Get Delauney triangulation of sample points.
TR = triangulation(TRI,x,y);  % Generate triangle lists
CC = circumcenter(TR);        % Get circumcenter for each triangle.

% these lines are new
% figure(1); 
% f=worldmap([28 60],[-15 60]); 
% geoshow('landareas.shp', 'FaceColor', [0.15 0.5 0.15]) 
% geoshow('worldrivers.shp', 'Color', 'blue')

figure(2);
%[x,y] = meshgrid(1:15,1:15);
%z = peaks(15);
trisurf(TRI,y,x,z);
% h = trisurf(TRI,y,x,z);
% project(h,'yx')
% scaleruler

% triplot(TRI,x,y);
num=size(TRI,1);
fid1=fopen('result.txt','wt');
fprintf(fid1, 'begin %%MLPQ%% \n');
fclose(fid1);
for i=1:num
    triangleInter(x(TRI(i,1)), y(TRI(i,1)), x(TRI(i,2)), y(TRI(i,2)), x(TRI(i,3)), y(TRI(i,3)), z(TRI(i,1)), z(TRI(i,2)), z(TRI(i,3)), CC(i,:), i);
end
fid1=fopen('result.txt','at+');
fprintf(fid1, 'end %%MLPQ%% \n');
fclose(fid1);
end

function triangleInter(x1, y1, x2, y2, x3, y3, e1, e2, e3, circumcenter ,id)
syms x;
syms y;
syms p;
fid1=fopen('result.txt','at+');
fprintf(fid1, 'tin(id,x,y,z)  :- id=%d',id);
A = [1 x1 y1;1 x2 y2;1 x3 y3];
da = (det(A))/2;
n1 = (x*(y2-y3) -y*(x2-x3)+(x2*y3-x3*y2))/(2*da);
n2 = (x*(y3-y1) -y*(x3-x1)+(x3*y1-x1*y3))/(2*da);
n3 = (x*(y1-y2) -y*(x1-x2)+(x1*y2-x2*y1))/(2*da);
e = n1*e1 + n2*e2 + n3*e3;

%%%%%%%%%%Tetbook p. 440-441.%%%%%%%%%%%%%%%
deltax = x1-x3;
deltay = y1-y3;
deltaz = e1-e3;

thetax = x2-x3;
thetay = y2-y3;
thetaz = e2-e3;

a = deltay * thetaz - deltaz * thetay;
b = deltaz * thetax - deltax * thetaz;
c = deltax * thetay - deltay * thetax;
d = a*x1 + b*y1 + c*e1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x4=circumcenter(1,1);       % x-axis circumcenter of the ith triangle
y4=circumcenter(1,2);       % y-axis circumcenter of the ith triangle

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We use the fomart of ax + y = c for simplification
% a == slope, c == const below

if x1 == x2
    if x1 > x3
        fprintf(fid1, ', x <= %.2f', x1);
    else
        fprintf(fid1, ', x >= %.2f', x1);
    end
else
    slope1 = (y2 - y1) / (x1 - x2);
    const1 = (x1 * y2 - x2 * y1) / (x1 - x2);
    if y1 == y2
        if y3 >= y1
            fprintf(fid1, ', y >= %.2f', y1);
        else
            fprintf(fid1, ', y <= %.2f', y1);
        end
    else
        if slope1 * x4 + y4 >= const1
            if slope1 == 0
                fprintf(fid1, ', y >= %.2f', const1);
            else
                fprintf(fid1, ', %.2fx + y >= %.2f', slope1, const1);
            end
        else
            if slope1 == 0
                fprintf(fid1, ', y <= %.2f', const1);
            else
                fprintf(fid1, ', %.2fx + y <= %.2f', slope1, const1);
            end
        end
    end
end

if x1 == x3
    if x1 > x2
        fprintf(fid1, ', x <= %.2f', x1);
    else
        fprintf(fid1, ', x >= %.2f', x1);
    end
else
    slope2 = (y3 - y1) / (x1 - x3);
    const2 = (x1 * y3 - x3 * y1) / (x1 - x3);
    if y1 == y3
        if y2 >= y1
            fprintf(fid1, ', y >= %.2f', y1);
        else
            fprintf(fid1, ', y <= %.2f', y1);
        end
    else
        if slope2 * x4 + y4 >= const2
            if slope2 == 0
                fprintf(fid1, ', y >= %.2f', const2);
            else
                fprintf(fid1, ', %.2fx + y >= %.2f', slope2, const2);
            end
        else
            if slope2 == 0
                fprintf(fid1, ', y <= %.2f', const2);
            else
                fprintf(fid1, ', %.2fx + y <= %.2f', slope2, const2);
            end
        end
    end
end

if x2 == x3
    if x2 > x1
        fprintf(fid1, ', x <= %.2f', x2);
    else
        fprintf(fid1, ', x >= %.2f', x2);
    end
else
    
    slope3 = (y2 - y3) / (x3 - x2);
    const3 = (x3 * y2 - x2 * y3) / (x3 - x2);
    if y2 == y3
        if y1 >= y2
            fprintf(fid1, ', y >= %.2f', y2);
        else
            fprintf(fid1, ', y <= %.2f', y2);
        end
    else
        if slope3 * x4 + y4 >= const3
            if slope3 == 0
                fprintf(fid1, ', y >= %.2f', const3);
            else
                fprintf(fid1, ', %.2fx + y >= %.2f', slope3, const3);
            end
        else
            if slope3 == 0
                fprintf(fid1, ', y <= %.2f', const3);
            else
                fprintf(fid1, ', %.2fx + y <= %.2f', slope3, const3);
            end
        end
    end
end


%Find the plane equation for the triangle facet.

if (c ~= 0)  % c not equals to 0, then divide by -c
    format long
    a = a/(-c);
    format long
    b = b/(-c);
    %c divided by -c makes c = -1
    format long
    d = d/(-c);
end

if b > 0
    fprintf(fid1, ', %.2fx+%.2fy-z=%.2f.\n', a, b, d);
elseif b < 0
    fprintf(fid1, ', %.2fx%.2fy-z=%.2f.\n', a, b, d);
end

fclose(fid1);
end


