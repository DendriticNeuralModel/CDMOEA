function [state,complex,K]=Complex(ind,II,M)
%state:link(1,1)-link(I,1) link(1,2)-link(I,2)---link(I,M)
%ind:w(1,1)-w(I,1)-q(1,1)-q(I,1)---w(1,M)-w(I,M)-q(1,M)-q(I,M)
K = zeros(II,M);
w=zeros(II,M);                  
q=zeros(II,M);                  
state=ones(1,II*M);   
for m=1:M
    w(:,m)= ind(1,(1+2*II*(m-1)):(II+2*II*(m-1)))';
    q(:,m)= ind(1,(1+II+2*II*(m-1)):(2*m*II))';
end
 for m=1:M
        for i=1:II
            if (0<w(i,m)&&w(i,m)<q(i,m))
                K(i,m)=0;    % constant 0 
            end
            if (w(i,m)<0&&q(i,m)>0)
                K(i,m)=0;    % constant 0
            end
            if (q(i,m)<0&&w(i,m)>0)
                K(i,m)=2;    % constant 1
                state(1,II*(m-1)+i)=0;
            end
            if (q(i,m)<w(i,m)&&w(i,m)<0)
                K(i,m)=2;    % constant 1
                state(1,II*(m-1)+i)=0;
            end
            if (w(i,m)<q(i,m)&&q(i,m)<0)
                K(i,m)=-1;   % Direct
            end
            if (0<q(i,m)&&q(i,m)<w(i,m))
                K(i,m)=1;    % Inverse
            end
        end
 end

    
Left_synapse=II*M;
for m=1:M
    canstant=1;  sestant=0;
    for i=1:II
        canstant=canstant*K(i,m);
        if K(i,m)==2
            sestant= sestant+1;
        end
    end
    if canstant~=0
        synapse = sestant;
    else
        synapse = II;
        state(1,II*(m-1)+1:II*m)=0;
    end
    Left_synapse=Left_synapse-synapse;
end
complex=Left_synapse;
end
