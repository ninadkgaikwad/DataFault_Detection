%% Creating Data

a=randi(100,100);

WindowSize=10;

[r,c]=size(a);

aaaa=cell(1,c);

%% Different Modes

% ContinuousMode

for j=1:c
    
    aaa=zeros(WindowSize,((r+1)-WindowSize));

    for i=1:(r-(WindowSize-1))

        aa=a(i:(WindowSize+(i-1)),j);

        aaa(:,i)=aa;       
        

    end    
    
    aaaa(1,j)={aaa};
    
end

% Not ContinuousMode

b=floor(r/WindowSize);

for j=1:c

    aaa=zeros(WindowSize,b);
    
    for i=1:b

        aa=a((1+((i-1)*WindowSize)):(i*WindowSize),j);

        aaa(:,i)=aa;
        
        

    end
    
    aaaa(1,j)={aaa};
    
end