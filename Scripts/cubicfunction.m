function cubicfunction( X,Y )
fid1=fopen('result.txt','wt');
fprintf(fid1, 'begin %%MLPQ%% \n');

pp = csape(X,Y,'variational');
breaks=[0,1,2,3];
l = 3;
k=4;
[breaks,coefs,l,k] = unmkpp(pp);

n=length(X);
syms x ;

for i = 1:n-1
    fprintf(fid1, 'R(id,y,x,xto2,xto3)  :- id=%d, x>=%d, x<=%d, ',i,X(i),X(i+1));
    P = 0;
    for j = 1:n
        if(abs(coefs(i,j))<0.00000001)
            coefs(i,j)=0;
        end
        P=vpa(coefs(i,j),5)*(x-X(i))^(n-j) + P;
        
    end
    f1=vpa(P,4);
    f2=simplify(f1);
    f3=vpa(f2,4);
    f=char(f3);
    
%     f4 = strrep(f, '*', ' * 0 * ');
%     f5=sym(f4);
%     disp(f5);
%     f5 = double(f5);
%     f6 = vpa(f5, 4);
%     f6 = double(f6);
    
    pos = find( f == '+' | f == '-', 1 , 'last' );
    f7 = f( 1 : ( pos - 1 ) );
    f8 = f( ( pos + 1 ) : end );
    
    f7=strrep(f7,'x^2','xto2');
    f7=strrep(f7,'x^3','xto3');
    f7=strrep(f7,'*','');
    fprintf(fid1, '%s-y = %s.\n',  f7, f8);
end

fprintf(fid1, 'end %%MLPQ%% \n');

fclose(fid1);

end

