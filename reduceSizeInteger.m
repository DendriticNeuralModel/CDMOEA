function ind=reduceSizeInteger(ind,TargetComplex,I,M)
%convert some links into 1-links(q<0<w)
[~,complex,K]=Complex(ind,I,M);
if complex==0 
    min0=I+1;
    j=0;
    for m=1:M
        if min0>numel(find(K(:,m)==0))
            min0 =numel(find(K(:,m)==0));
            j=m;
        end
    end
    m=j;
    if min0==0 
        i=randi(I);
        w_index=(m-1)*2*I+i;
        q_index=(m-1)*2*I+I+i;
        [ind(w_index),ind(q_index)]=case_one; 
    elseif min0==I
        label=randi(I);
        for i=1:I
            w_index=(m-1)*2*I+i;
            q_index=(m-1)*2*I+I+i;
            if i==label
                [ind(w_index),ind(q_index)]=case_one; 
            else
                [ind(w_index),ind(q_index)]=case_two;
            end
        end
    else
        index=find(K(:,j)==0);
        one_length=numel(find(K(:,j)==2));
        zero_length=length(index);
        label=0;
        if (one_length+zero_length)==I
            label=randi(zero_length);
        end
        for c=1:zero_length
            i=index(c);
            w_index=(m-1)*2*I+i;
            q_index=(m-1)*2*I+I+i;
            if c==label
                [ind(w_index),ind(q_index)]=case_one; 
            else
                [ind(w_index),ind(q_index)]=case_two;  
            end
        end
    end
end
[state,complex]=Complex(ind,I,M);
index=find(state==1);
while complex>TargetComplex && ~isempty(index)
    temp=randi(length(index));
    link=index(temp);
    index(temp)=[];
    m=ceil(link/I);
    if mod(link,I)==0
        i=I;
    else
        i=mod(link,I);
    end
    w_index=(m-1)*2*I+i;
    q_index=(m-1)*2*I+I+i;
    r1=rand*10;
    r2=rand*(-10);
    ind(w_index)=r1;
    ind(q_index)=r2;
    complex=complex-1;
end
end

%create direct or inverse connection
function [w,q]=case_one
    label=randi(2);
    if label==1 %create a direct connection
        r1=rand*10;
        r2=rand*10;
        while r2==r1
            r2=rand*10;
        end
        if r2<r1
            temp=r1;
            r1=r2;
            r2=temp;
        end
        w=r2;
        q=r1;
    else %create a inverse connection
        r1=rand*(-10);
        r2=rand*(-10);
        while r2==r1
            r2=rand*(-10);
        end
        if r2<r1
            temp=r1;
            r1=r2;
            r2=temp;
        end
        w=r1;
        q=r2;
    end
end

%create non-0 connection
function [w,q]=case_two
    w=-10+20*rand;
    q=-10+20*rand;
    while max(w,0)<q
        w=-10+20*rand;
        q=-10+20*rand;
    end
end