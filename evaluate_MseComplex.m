function [MSE, complex, K] = evaluate_MseComplex( input, target, pop, M, PS )
[G,~] = size(pop);
[I,J] = size(input);
k = 5;
Threshold_logic=zeros(I,M,G);
K=zeros(I,M,G);
O = zeros(J,G);
MSE=zeros(1,G);
complex=zeros(1,G);

for g=1:G
    w=zeros(I,M);                  
    q=zeros(I,M);                  
    
    Parameter=pop(g,:);
    for m=1:M
        w(:,m)= Parameter((1+2*I*(m-1)):(I+2*I*(m-1)))';
        q(:,m)= Parameter((1+I+2*I*(m-1)):(2*m*I))';
    end
    Threshold=q./w;
    
    for m=1:M
        for i=1:I
            if (0<w(i,m)&&w(i,m)<q(i,m))
                K(i,m,g)=0;
            end
            if (w(i,m)<0&&q(i,m)>0)
                K(i,m,g)=0;
            end
            if (q(i,m)<0&&w(i,m)>0)
                K(i,m,g)=2;
            end
            if (q(i,m)<w(i,m)&&w(i,m)<0)
                K(i,m,g)=2;
            end
            if (w(i,m)<q(i,m)&&q(i,m)<0)
                K(i,m,g)=-1;
            end
            if (0<q(i,m)&&q(i,m)<w(i,m))
                K(i,m,g)=1;
            end
        end
    end
    %% %%%%%%%%%%%%%  Calculation Fitness one %%%%%%%%%%%%%
    Left_synapse=I*M;
    for m=1:M
        canstant=1;  sestant=0;
        for i=1:I
            canstant=canstant*K(i,m,g);
            if K(i,m,g)==2
                sestant= sestant+1;
            end
        end
        if canstant~=0
            synapse = sestant;
        else
            synapse = I;
        end
        Left_synapse=Left_synapse-synapse;
    end

   complex(g)=Left_synapse;
    
   %% %%%%%%%%%%%%%  Calculation Fitness two %%%%%%%%%%%%%
    x=input;
    T=target;
    Y=zeros(I,M,J);
    Z=ones(M,J);
    V=zeros(1,J);
    mse=zeros(1,J);
    for j=1:J
        % build synaptic layers
        for m=1:M
            for i=1:I
                Y(i,m,j)=1/(1+exp(-k*(w(i,m)*x(i,j)-q(i,m))));
            end
        end
        
        % build dendrite layers
        for m=1:M
            Q=1;
            for i=1:I
                Q=Q*Y(i,m,j);
            end
            Z(m,j)=Q;
        end
        
        % build  membrane layers
        constant=0;
        for m=1:M
            constant=constant+Z(m,j);
        end
        V(j)=constant;
        
        % build a soma layer
        O(j,g)=1/(1+exp(-k*(V(j)-0.5)));
        mse(j)=(1/2)*((O(j,g)-T(j))^2);
    end
    MSE(g) = mean(mse);
    Threshold_logic(:,:,g) = mapminmax('reverse',Threshold, PS);
end
end


