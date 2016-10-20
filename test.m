function test(lambdaF,lambdaH)
global mapBigram;
global mapUnigram;


test_file = fopen('test.txt');
initialize();
mapLexicon = containers.Map('KeyType','char','ValueType','double');

tline = fgetl(test_file);
%[X, Y, O] = textread([PathNames,fileNames],'%s %s %s','delimiter',';');
while ischar(tline)
    operations=[];
    str=[];
    disp('new Line')
    disp(tline)
    [str{1}, rmn] = strtok(tline,' ');
    while (length(str{end})~=0)
        
        [str{end+1}, rmn] = strtok(rmn,' ');
    end
    
    operation = 0; %no change
    sum = 0;
    max = -inf;
    
    for i=1:length(str)
        
        
        x = str{i};
        
        if( ~isKey(mapLexicon,x))
            mapLexicon(x) = mapLexicon.Count+1;
        end
        index = mapLexicon(x);
        
        
        
        allY =  deletion(x);
        %allY{1}=  insertion(x);
        %allY{2} =  deletion(x);
        %allY{3} =  substitution(x);
        %allY{4} =  transposition(x);
        %allY{5} =  splitting(x);
        %allY{6} =  merging(x,str{i+1});
        %allY{7} =  beginPhrase(x);
        %allY{8} =  endPhrase(x);
%        allY{end} = [];
         Ys{i} = allY;
    end
    
    
    
    indexes = ones(length(str)-1,1);
    %sentence= [];
    
    rep = true;
    
%    operation_j = allY2{1};
%    ind = 1;
%    currY = operation_j{ind};
%    sentence(strInd) = currY;
%    ind = ind+1;
%while(rep2)
    
    while (rep)
        rep = false;
        row =  indexes(1);
        display(Ys{1})
        word = Ys{1}(row);
        sentence(1) = word;

        for strInd = 2:length(indexes)
            
            row =  indexes(strInd);
            if (row <= size(Ys{strInd},2))
                word = Ys{strInd}(row);
                if (isempty(word))
                    indexes(strInd-1) = indexes(strInd-1)+1;
                    indexes(strInd:end) = 1;
                    rep = true;
                else
                    sentence(strInd) = word;
                end
            else
                indexes(strInd-1) = indexes(strInd-1)+1;
                indexes(strInd:end) = 1;
                rep = true;
            end
            
            
        end
    end
    rep = true
    for j=1:length(sentence)
            x = str{j};
            y = sentence(j);
            operation =1;
            c =  condition(x,y,operation);
            index = mapLexicon(x);


        if (c> 0)
                val = mapUnigram(y{1});
                indY = val{1}(2);
                h{c,operation,index,indY{1}} = 1
                f(index,indY{1}) = bigram(x,y)
        end
       
   end
%end
    for i=1:length(allY)
        
        y= allY(i);
        
        operation =1; % deletion
        %sum(find(y==lexicon))~=0
        c =  condition(x,y,operation);
        
        if (c> 0)
            val = mapUnigram(y{1});
            indY = val{1}(2);
            h{c,operation,index,indY{1}} = 1;
        end
        try
            f(index,indY{1}) = bigram(x,y);
        catch
            display('eror')
        end
        %        percent = perCal(f,h,lambdaF,lambdaH);
        
    end
    
    
    
    
    while (~isempty(str{i}))
        
        
        
    end
    
    
    
    
    
    tline = fgetl(test_file);
end

fclose(test_file);


end



function initialize()
global mapBigram;
global mapUnigram;


[perBigram, wordsBigram, extra] = textread(['./','Bigram.txt'],'%s %s %s','delimiter','\t');
[perUnigram, wordsUnigram,extra] = textread(['./','Unigram.txt'],'%s %s %s','delimiter','\t');

for i=1:length(wordsBigram)
    val{i} = {[perBigram(i);i]};
end

mapBigram = containers.Map(wordsBigram,val);

for i=1:length(wordsUnigram)
    val2{i} = {[perUnigram(i);i]};
end
mapUnigram = containers.Map(wordsUnigram,val2);




end


function per= bigram(x,y)

global mapBigram;

str = strcat(x,' ',y);
%indRow = find(ismember(wordsBigram,str));
if( ~isKey(mapBigram,str))
    per = 0.000001;
else
    per = mapBigram(str);
end

end

function c = condition(x,y,operation)
global mapUnigram;

%ind = find(ismember(wordsUnigram,y));
if (isKey(mapUnigram,y))
    c=1;
else
    c=0;
end


end

function per = perCal(f,h,lambdaF,lambdaH)

per = lamdaF*f + lambdaH .* h;

end











function Y = deletion(X)
Y=[];
for i=1:length(X)
    Y{i} = strcat(X(1:i-1),X(i+1:end));
end

end


function Y = insertion(X)
Y=[];
for i=1:length(X)+1
    for c='a':'z'
        Y{end+1} = strcat(X(1:i-1),c,X(i:end));
    end
end

end

function Y = substitution(X)
Y=[];
init = X ;
for i=1:length(X)
    for c='a':'z'
        X(i) = c;
        Y{end+1} = X;
        X = init;
    end
end
end

function Y = transposition(X)
Y=[];
init = X ;
for i=1:length(X)
    for j=i+1:length(X)
        temp = X(i);
        X(i) = X(j);
        X(j) = temp;
        Y{end+1} = X;
        X = init;
        
    end
end
end

function Y =splitting(X)
Y=[];
init = X ;
for i=1:length(X)-1
    
    Y{end+1}=strcat(X(1:i),',',X(i+1:end));
    
end
end

function Y =merging(X,Z)

Y{1} = strcat(X,Z);

end

function Y =beginPhrase(X)

Y{1} = strcat('" ', X);

end

function Y =endPhrase(X)

Y{1} = strcat( X , ' "');

end



