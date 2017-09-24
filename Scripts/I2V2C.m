function I2V2C(image,tablename)

% usage >> I2V2C('map.JPG','Ohio');
% Use the mouse to repeaptedly select the points for a vector representation. 
% Once the last point is selected, right click or click any other key beside
% the left key to stop recording. The last point entered will be connected by
% a line to the first point entered. Each state needs a minimum of five points
% to convert it to a constraint representation.
% The output constraints will be in result.txt in the same directory as I2V2C.m. 
% The program cumulatively adds to the result.txt file new states/tables 
% when it is run again. For multiple states/tables, delete the duplicate 
% "begin%MPLQ%" and "end%MLPQ%" statements from results.txt.

imshow(image);   
xhold = 0;
yhold = 0;
k = 0;
hold on;  
while 1
    [xi, yi, button] = ginput(1);    
    if ~isequal(button, 1)          
        break
    end
    k = k + 1;
    points(1,k) = xi;
    points(2,k) = yi;
    if xhold
        plot([xhold xi], [yhold yi], 'go-');
    else
        plot(xi, yi, 'go');   
    end
    xhold = xi;
    yhold = yi;
end

hold off;
if k < size(points,2)
    points = points(:, 1:k);
end

V= points;
digits(10) % you could adjust variable-precision accuracy by your own need 
X = V(1,:);
Y = V(2,:);
X = X' +500;
Y = -Y' +3500;

id=1;
%fid1=fopen('result.txt','wt');             
fid1=fopen('result.txt','at+');             
fprintf(fid1, 'begin %%MLPQ%% \n');
fclose(fid1);
TRI = delaunay(X,Y);
num2=length(TRI); 

for k=1:num2
x2=[X(TRI(k,1));X(TRI(k,2));X(TRI(k,3))];   
y2=[Y(TRI(k,1));Y(TRI(k,2));Y(TRI(k,3))];    
x3=(X(TRI(k,1))+X(TRI(k,2))+X(TRI(k,3)))/3;
y3=(Y(TRI(k,1))+Y(TRI(k,2))+Y(TRI(k,3)))/3; 
X2=[X;X(1)];
Y2=[Y;Y(1)];
in = inpolygon(x3, y3, X2, Y2);
   if (in ==1)
   subquestion(x2,y2,id,x3,y3,tablename);
   id=id+1;
   end
end 

fid1=fopen('result.txt','at+'); 
fprintf(fid1, 'end %%MLPQ%% \n');
fclose(fid1);
end


function subquestion(X,Y, id,x1,y1,name)

vx(1,1)=X(1);
vx(2,1)=X(2); 
vy(1,1)=Y(1);
vy(2,1)=Y(2);

vx(1,2)=X(2);
vx(2,2)=X(3); 
vy(1,2)=Y(2);
vy(2,2)=Y(3);

vx(1,3)=X(3);
vx(2,3)=X(1); 
vy(1,3)=Y(3);
vy(2,3)=Y(1);

%This follows the vector to constraint MATLAB script of Prof. Revesz.
fid1=fopen('result.txt','at+');       
fprintf(fid1, '%s(id,x,y)  :- id=%d',name,id);
    for p=1:3  
            if vx(1,p)==vx(2,p) 
             
              if x1<=vx(1,p)
              fprintf(fid1, ', x<=%f',vx(1,p));  
             else
              fprintf(fid1, ', x>=%f',vx(1,p));  
              end 
             
           else
                   if vy(1,p)==vy(2,p) 
                     
                       if y1<=vy(1,p)
                        fprintf(fid1, ', y<=%f',vy(2,p));  
                      else
                         fprintf(fid1, ', y>=%f',vy(2,p));  
                      end  
                      
                   else   
                     syms x
                   e2=(x-vx(2,p))/(vx(1,p)-vx(2,p))*(vy(1,p)-vy(2,p))+vy(2,p);
                   nmx=-1*(x)/(vx(1,p)-vx(2,p))*(vy(1,p)-vy(2,p));
                   c=(-vx(2,p))/(vx(1,p)-vx(2,p))*(vy(1,p)-vy(2,p))+vy(2,p);
                       f= simplify(vpa(e2,7));
                              f2=char(f);
                              nmx=char(simplify( vpa(nmx,7))); 
                              nmx=strrep(nmx, '*', '');
                              if not(strcmp((nmx(1)),'-'))
                                  nmx=strcat('+',nmx);
                              end
                              c=num2str(c,300);
                         if y1<=(x1-vx(2,p))/(vx(1,p)-vx(2,p))*(vy(1,p)-vy(2,p))+vy(2,p)
                          %fprintf(fid1, ', y<=%s',f2);  
                          fprintf(fid1, ', y%s<=%s',nmx,c);  
                            else
                         % fprintf(fid1, ', y>=%s',f2);  
                          fprintf(fid1, ', y%s>=%s',nmx,c);
                         end 
           
                    end 
                          
             end


   end
fprintf(fid1,'.\n');
fclose(fid1);
fclose('all');

end