  function Vect2Constraints(V)
 digits(10) % you could adjust variable-precision accuracy by your own need 
num=length(V);
   for i=1:num
   X(i,1)=V(i,1);
   Y(i,1)=V(i,2);
   end 
id=1;
fid1=fopen('result.txt','wt');             
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
   subquestion(x2,y2,id,x3,y3);
   id=id+1;
   end
   
end 

fid1=fopen('result.txt','at+'); 
fprintf(fid1, 'end %%MLPQ%% \n');
fclose(fid1);
end

function subquestion(X,Y, id,x1,y1)

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

fid1=fopen('result.txt','at+');       
fprintf(fid1, 'R(id,x,y)  :- id=%d',id);
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
                   e2=-(x)/(vx(1,p)-vx(2,p))*(vy(1,p)-vy(2,p));
                   factor=-1/(vx(1,p)-vx(2,p))*(vy(1,p)-vy(2,p));
                   e3=(-vx(2,p))/(vx(1,p)-vx(2,p))*(vy(1,p)-vy(2,p))+vy(2,p);
                       f= simplify(vpa(e2,7));
                       f2=char(f);
                       f3= simplify(vpa(e3,7));
                       f4=char(f3);
                         if y1<=(x1-vx(2,p))/(vx(1,p)-vx(2,p))*(vy(1,p)-vy(2,p))+vy(2,p)
                             if factor > 0
                             fprintf(fid1, ', y+%s<=%s',f2,f4); 
                             else    
                             fprintf(fid1, ', y%s<=%s',f2,f4);  
                             end     
                         else     
                             if factor > 0
                             fprintf(fid1, ', y+%s>=%s',f2,f4); 
                             else    
                             fprintf(fid1, ', y%s>=%s',f2,f4);  
                             end     
                         end 
           
                    end 
                          
             end


   end
fprintf(fid1,'.\n');
fclose(fid1);

end


