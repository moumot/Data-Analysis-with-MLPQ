%Example of use of this function:
%x = [1 ;5; 8; 12];      %the x coordinates
%y = [68 ;71; 76; 73];   %the y coordinates
%tolerance = 5;          %the error tolerance value
%pline(x, y, tolerance); %function call

function pline(x, y,tolerance)
begin.x=x(1);
begin.y=y(1);
count=numel(x);
SL=-inf;
SU=inf;
id=1;
fid1=fopen('result.txt','wt');             
fprintf(fid1, 'begin %%MLPQ%% \n');

for i=1:count-1
   slope1=(y(i+1)-tolerance-begin.y)/(x(i+1)-begin.x);
   SL2=max(SL,slope1); 
   slope2=(y(i+1)+tolerance-begin.y)/(x(i+1)-begin.x);
   SU2=min(SU,slope2);
   if SL2<=SU2
   SL=SL2;    
   SU=SU2;    
   else 
   if(SL+SU)/2==0
   fprintf(fid1, 'R(id,x,y)  :- id=%d,   y=%f, x>=%d, x<=%d. \n',id,begin.y-(SL+SU)/2*begin.x,begin.x,x(i));
   end     
   if(SL+SU)/2>0
   fprintf(fid1, 'R(id,x,y)  :- id=%d,   y-%fx=%f, x>=%d, x<=%d. \n',id,(SL+SU)/2, begin.y-(SL+SU)/2*begin.x,begin.x,x(i));
   else
   fprintf(fid1, 'R(id,x,y)  :- id=%d,   y+%fx=%f, x>=%d, x<=%d. \n',id,-(SL+SU)/2, begin.y-(SL+SU)/2*begin.x,begin.x,x(i));   
   end   
   
   id=id+1;
   begin.y=(SL+SU)/2*(x(i)-begin.x)+begin.y; 
   begin.x=x(i); 
   SL=(y(i+1)-tolerance-begin.y)/(x(i+1)-begin.x);
   SU=(y(i+1)+tolerance-begin.y)/(x(i+1)-begin.x);
   
   end
end
  if(SL+SU)/2==0
  fprintf(fid1, 'R(id,x,y)  :- id=%d,   y=%f, x>=%d, x<=%d. \n',id,begin.y-(SL+SU)/2*begin.x,begin.x,x(i+1));
  end
  if(SL+SU)/2>0
  fprintf(fid1, 'R(id,x,y)  :- id=%d,   y-%fx=%f, x>=%d, x<=%d. \n',id,(SL+SU)/2, begin.y-(SL+SU)/2*begin.x,begin.x,x(i+1));
  else
  fprintf(fid1, 'R(id,x,y)  :- id=%d,   y+%fx=%f, x>=%d, x<=%d. \n',id,-(SL+SU)/2, begin.y-(SL+SU)/2*begin.x,begin.x,x(i+1));   
  end  
fprintf(fid1, 'end %%MLPQ%% \n');

fclose(fid1);