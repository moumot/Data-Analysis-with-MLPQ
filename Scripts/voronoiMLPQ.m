function voronoiMLPQ(x1,y) 
digits(10)  % you could adjust variable-precision accuracy by your own need 
num=length(x1);
[vx,vy] = voronoi(x1,y);
A=[];
id=1;
num2=length(vx);
A=zeros(num,num2);   % updates: initialization for Array A. 
 
            
for i=1:num2   
    for j=1:num
    d1=((x1(j)-vx(1,i))^2+(y(j)-vy(1,i))^2);
    d2=((x1(j)-vx(2,i))^2+(y(j)-vy(2,i))^2);    
    D1(j)=d1;    
    D2(j)=d2;    
    end
    tmp1=min(D1);
    k=1;
    B1=[];
    B2=[];
    for L=1:num
    if abs(D1(L)-tmp1)<2500*eps; % Updates the number to 2500 for better floating point comparison in 7 hospital example. You could increase it or decrease by your own need. 
    B1(k)=L;
    k=k+1;
    end
    end 
    m=1;
    tmp2=min(D2);
    for n=1:num
    if abs(D2(n)-tmp2)<2500*eps;% Updates the number to 2500 for better floating point comparison in 7 hospital example. You could increase it or decrease by your own need. 
    B2(m)=n; 
    m=m+1;
    end
    end  
    c=intersect(B1,B2);
    num3=length(c);
    for j=1:num3        
    A(c(j),i)=1;
   end 
end

fid1=fopen('result.txt','wt');  
fprintf(fid1, 'begin %%MLPQ%% \n');
for q=1:num 
 fprintf(fid1, 'R(id,x,y)  :- id=%d',id);
 id=id+1;
    for p=1:num2  
        if A(q,p)==1
            if vx(1,p)==vx(2,p) 
             if x1(q)<=vx(1,p)
              fprintf(fid1, ', x<=%f',vx(1,p));  
             else
              fprintf(fid1, ', x>=%f',vx(1,p));  
             end 
            else
                   if vy(1,p)==vy(2,p) 
                      if y(q)<=vy(1,p)
                        fprintf(fid1, ', y<=%f',vy(2,p));  
                      else
                         fprintf(fid1, ', y>=%f',vy(2,p));  
                      end                 
                   else   
                  %   syms x
                     
                  % e2=(x-vx(2,p))/(vx(1,p)-vx(2,p))*(vy(1,p)-vy(2,p))+vy(2,p);
                   coefficient = -(vy(1,p)-vy(2,p))/(vx(1,p)-vx(2,p)); %negative of the coefficient
                   displacement = -vx(2,p)*(-coefficient) + vy(2,p);

                   coeff = simplify(vpa(coefficient,7)); 
                   disp = simplify(vpa(displacement,7));
                   
                   Coeff = char(coeff);
                   Disp = char(disp);
                   
%                        f= simplify(vpa(e2,7));
%                               f2=char(f);
                         if y(q)<= (x1(q)-vx(2,p))/(vx(1,p)-vx(2,p))*(vy(1,p)-vy(2,p))+vy(2,p)  
                           fprintf(fid1, ', %sx + y <=%s', Coeff, Disp);  
                            else
                           fprintf(fid1, ', %sx + y >=%s', Coeff, Disp);  
                         end 
           
                   
                   end 
                          
            end
        end     
    end             
  fprintf(fid1,'.\n');  
end

fprintf(fid1, 'end %%MLPQ%% \n');
fclose(fid1);
end

