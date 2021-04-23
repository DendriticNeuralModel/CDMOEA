function ind=increaseSizeInteger(ind, TargetComplex, I, M)
%convert some links into direct connection(0<q<w) or inverse connection(w<q<0)
[~,complex,K]=Complex(ind,I,M);
zero_L=zeros(1,M);
for m=1:M
    zero_L(m)=numel(find(K(:,m)==0));
end
[zero_L,index]=sort(zero_L);
index(zero_L==0)=[];
remain=TargetComplex-complex;
while remain>0 && ~isempty(index)
    m=index(1);
    m_index=find(K(:,m)==0);
    for c=1:length(m_index)
        i=m_index(c);
        w_index=(m-1)*2*I+i;
        q_index=(m-1)*2*I+I+i;
        [ind(w_index),ind(q_index)]=case_one;
    end
    remain=remain-(I-numel(find(K(:,m)==2)));
    index(1)=[];
end
if remain<0 %add too much links
    ind=reduceSizeInteger(ind,TargetComplex,I,M);
end
if remain>0 %address 1-links until the number of needed links meets
    [state,complex,~]=Complex(ind,I,M);
    index=find(state==0);%only presents 1-links because 0-links are dealed with.
    while complex<TargetComplex && ~isempty(index)
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
        [ind(w_index),ind(q_index)]=case_one;
        complex=complex+1;
    end
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
