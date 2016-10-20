function q=querymaker()
fileNames='dataset_pourmahdian.txt';
[~, Y,~,~,~] = textread(fileNames,'%s %s %s %s %s','delimiter','\t');
fID=fopen('query.txt','w');
for i=1:size(Y,1)
    sentence = textscan(Y{i}, '%s','Delimiter',' ');
    opr=randi([1 6]);
    nword=randi([1 size(sentence{1},1)]);
    iopr=0;
    switch opr
        case 1
           x=Delete(sentence{1},nword);
           iopr=2;
        case 2
            x=Insert(sentence{1},nword);
            iopr=1;
        case 3
            x=Substitute(sentence{1},nword);
            iopr=3;
        case 4
            x=Transpose(sentence{1},nword);
            iopr=4;
        case 5
            x=Split(sentence{1},nword);
            iopr=6;
        case 6
            x=Merge(sentence{1},nword);
            iopr=5;
    end
    fprintf(fID,'%s%s%s%s%d\n',x,';',Y{i},';',iopr);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s=Delete(sen,n)
s=[];
nchardel=randi([1 length(sen{n})]);
if(nchardel~=1)
w=[sen{n}(1:nchardel-1),sen{n}(nchardel+1:end)];  
else
    w=[sen{n}(nchardel+1:end)]; 
end
for i=1:length(sen)
    if(i==n)
        s=[s,' ',w];
    else
        s=[s,' ',sen{i}];
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s=Insert(sen,n)
s=[];

symbols = ['a':'z' 'A':'Z' '0':'9'];
 MAX_ST_LENGTH = 1;
 stLength = randi(MAX_ST_LENGTH);
 nums = randi(numel(symbols),[1 stLength]);
 st = symbols (nums);
 
nposins=randi([0 length(sen{n})]);
if(nposins==0)
    w=[st,sen{n}];  
else
    w=[sen{n}(1:nposins),st,sen{n}(nposins+1:end)];  
end
for i=1:length(sen)
    if(i==n)
        s=[s,' ',w];
    else
        s=[s,' ',sen{i}];
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s=Substitute(sen,n)
s=[];

symbols = ['a':'z' 'A':'Z' '0':'9'];
 MAX_ST_LENGTH = 1;
 stLength = randi(MAX_ST_LENGTH);
 nums = randi(numel(symbols),[1 stLength]);
 st = symbols (nums);
 
npossub=randi([1 length(sen{n})]);
if(npossub==1)
    w=[st,sen{n}(2:end)];  
else
    w=[sen{n}(1:npossub-1),st,sen{n}(npossub+1:end)];  
end
for i=1:length(sen)
    if(i==n)
        s=[s,' ',w];
    else
        s=[s,' ',sen{i}];
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s=Transpose(sen,n)
s=[];
ncharT=randi([1 max(1,length(sen{n})-1)]);
w=sen{n};
if(ncharT+1<=length(sen{n}))
w(ncharT)=sen{n}(ncharT+1);
w(ncharT+1)=sen{n}(ncharT);
end
for i=1:length(sen)
    if(i==n)
        s=[s,' ',w];
    else
        s=[s,' ',sen{i}];
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s=Split(sen,n)
s=[];
st=' ';
nposspl=randi([1 max(1,length(sen{n})-1)]);
    w=[sen{n}(1:nposspl),st,sen{n}(nposspl+1:end)];  
for i=1:length(sen)
    if(i==n)
        s=[s,' ',w];
    else
        s=[s,' ',sen{i}];
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s=Merge(sen,n)
w=[];
s=[];
nposmrg=randi([1 max(1,length(sen)-1)]);
if (length(sen)>1)
    w=[sen{nposmrg},sen{nposmrg+1}];  
else
    w=sen{1};
end
for i=1:length(sen)
    if(i==nposmrg)
        s=[s,' ',w];
    elseif(i==nposmrg+1)
        s=s;
    else
        s=[s,' ',sen{i}];
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%