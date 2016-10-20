function QueryRefinement(lambdaF,lambdaH)

global mapLexicon2;
global mapStopWords ;
global mapUnigram ;


%test_file = fopen('test.txt');
initialize();
%mapLexicon = containers.Map('KeyType','char','ValueType','double');
mapLexicon2 = containers.Map('KeyType','char','ValueType','any');
mapStopWords = containers.Map('KeyType','char','ValueType','any');
mapOperations = containers.Map('KeyType','char','ValueType','any');

%tline = fgetl(test_file);
tline = 'this is';
%while ischar(tline)
    
    str=[];
    disp('new Line')
    disp(tline)
    [str{1}, rmn] = strtok(tline,' ');
    while (length(str{end})~=0)
        [str{end+1}, rmn] = strtok(rmn,' ');
    end
    
    for i=1:length(str)
        
        x = str{i};
        
        
        
        allY{1} =  endPhrase(x);
        mapOperations(strcat(i,',',1)) = length(allY{6});
        % allY =  deletion(x);
        %  Ys{i}{1} = allY;
        allY{6}=  insertion(x);        
        mapOperations(strcat(i,',',6)) = length(allY{1});
        
        allY{2} =  deletion(x);
        mapOperations(strcat(i,',',2)) = length(allY{2});
        
        allY{3} =  substitution(x);
        mapOperations(strcat(i,',',3)) = length(allY{3});
        
        allY{4} =  transposition(x);
        mapOperations(strcat(i,',',4)) = length(allY{4});
        allY{5} =  splitting(x);
        mapOperations(strcat(i,',',5)) = length(allY{5});
         if (i~=length(str))
               allY{6} =  merging(x,str{i+1});
                mapOperations(strcat(i,',',6)) = length(allY{6});
         end
   
        allY{5} =  beginPhrase(x);
        mapOperations(strcat(i,',',5)) = length(allY{5});
        
        
        
  %      allY{7} = x;
  %      mapOperations(strcat(i,',',7)) = length(allY{7});
        
        
        %Ys{i} = allY{:};
        Ys{i}=[allY{1}(:);allY{2}(:);allY{3}(:);allY{4}(:);allY{5}(:);allY{6}(:)];
        
        % Ys{i}{1} =  insertion(x);
        % Ys{i}{2}  =  deletion(x);
        % Ys{i}{3}  =  substitution(x);
        % Ys{i}{4}  =  transposition(x);
        % Ys{i}{5}  =  splitting(x);
        % Ys{i}{6}  =  merging(x,str{i+1});
        % Ys{i}{7}  =  beginPhrase(x);
        % Ys{i}{8}  =  endPhrase(x);
        
        
    end
    
    
    
    indexes = ones(length(str)-1,1);
    rows = ones(length(str)-1,1);
    
    rep = true;
    rep2 = true;
    
       
    maxSum = -Inf;
    maxSen = [];
    while(rep2)
        
        
        while (rep)
            
            
            rep = false;
            row =  indexes(1);
            rows(1) = row;
            if (row <= size(Ys{1},1))
                oper = Ys{1};
                word = oper(row);
                sentence{1} = word;
                if (isempty(word))
                    rep2 = false;
                    rep = false;
                end
            else
                
                rep = false;
                rep2 = false;
            end
            
            for strInd = 2:length(indexes)
                
                row =  indexes(strInd);
                rows(strInd) = row;
                
                if (row <= size(Ys{strInd},1))
                    oper = Ys{strInd};
                    word = oper(row);
                    if (isempty(word))
                        indexes(strInd-1) = indexes(strInd-1)+1;
                        indexes(strInd:end) = 1;
                        rep = true;
                    else
                        
                        sentence{strInd} = word;
                    end
                else
                    
                    indexes(strInd-1) = indexes(strInd-1)+1;
                    indexes(strInd:end) = 1;
                    rep = true;
                end
                
                
            end
            
        end
        indexes(end) = indexes(end)+1;
        
        rep = true;
        summ = 0;
        nxt = false;
        for j=1:length(sentence)
            if (nxt) 
                x = str{j+1};
            else
                x = str{j};
            end
            y = sentence{j};
            operation =1;
            
            while (rows(j)>=mapOperations(strcat(j,',',operation)))
                operation = operation +1;
            end
             operation = operation -1;
             if operation ==6
                 nxt = true;
             else
                 nxt = false;
             end
            c =  condition(x,y,operation);
            
            for k=1:length(c)
                
                h(k) = 1;
                f = bigram(x,y);
                percent = perCal(f,h,lambdaF,lambdaH);
                
            end
            
            summ = summ + percent;
            
            
        end
        
        if (summ > maxSum)
            maxRow = rows;
            maxSum = summ;
            maxSen = sentence;
             maxSen{:}
            
        end
        sentence = [];
        rows = ones(length(str)-1,1);
        
        
    end
    maxSen{:}
    
    
%    tline = fgetl(test_file);
%end




fclose(test_file);


end



function initialize()
stopwords_cellstring={'a', 'about', 'above', 'above', 'across', 'after', ...
    'afterwards', 'again', 'against', 'all', 'almost', 'alone', 'along', ...
    'already', 'also','although','always','am','among', 'amongst', 'amoungst', ...
    'amount', 'an', 'and', 'another', 'any','anyhow','anyone','anything','anyway', ...
    'anywhere', 'are', 'around', 'as', 'at', 'back','be','became', 'because','become',...
    'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'below',...
    'beside', 'besides', 'between', 'beyond', 'bill', 'both', 'bottom','but', 'by',...
    'call', 'can', 'cannot', 'cant', 'co', 'con', 'could', 'couldnt', 'cry', 'de',...
    'describe', 'detail', 'do', 'done', 'down', 'due', 'during', 'each', 'eg', 'eight',...
    'either', 'eleven','else', 'elsewhere', 'empty', 'enough', 'etc', 'even', 'ever', ...
    'every', 'everyone', 'everything', 'everywhere', 'except', 'few', 'fifteen', 'fify',...
    'fill', 'find', 'fire', 'first', 'five', 'for', 'former', 'formerly', 'forty', 'found',...
    'four', 'from', 'front', 'full', 'further', 'get', 'give', 'go', 'had', 'has', 'hasnt',...
    'have', 'he', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', ...
    'hers', 'herself', 'him', 'himself', 'his', 'how', 'however', 'hundred', 'ie', 'if',...
    'in', 'inc', 'indeed', 'interest', 'into', 'is', 'it', 'its', 'itself', 'keep', 'last',...
    'latter', 'latterly', 'least', 'less', 'ltd', 'made', 'many', 'may', 'me', 'meanwhile',...
    'might', 'mill', 'mine', 'more', 'moreover', 'most', 'mostly', 'move', 'much', 'must',...
    'my', 'myself', 'name', 'namely', 'neither', 'never', 'nevertheless', 'next', 'nine',...
    'no', 'nobody', 'none', 'noone', 'nor', 'not', 'nothing', 'now', 'nowhere', 'of', 'off',...
    'often', 'on', 'once', 'one', 'only', 'onto', 'or', 'other', 'others', 'otherwise',...
    'our', 'ours', 'ourselves', 'out', 'over', 'own','part', 'per', 'perhaps', 'please',...
    'put', 'rather', 're', 'same', 'see', 'seem', 'seemed', 'seeming', 'seems', 'serious',...
    'several', 'she', 'should', 'show', 'side', 'since', 'sincere', 'six', 'sixty', 'so',...
    'some', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhere', ...
    'still', 'such', 'system', 'take', 'ten', 'than', 'that', 'the', 'their', 'them',...
    'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', ...
    'therein', 'thereupon', 'these', 'they', 'thickv', 'thin', 'third', 'this', 'those',...
    'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too',...
    'top', 'toward', 'towards', 'twelve', 'twenty', 'two', 'un', 'under', 'until', 'up',...
    'upon', 'us', 'very', 'via', 'was', 'we', 'well', 'were', 'what', 'whatever', 'when',...
    'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein',...
    'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever',...
    'whole', 'whom', 'whose', 'why', 'will', 'with', 'within', 'without', 'would', 'yet',...
    'you', 'your', 'yours', 'yourself', 'yourselves', 'the'};

global mapBigram;
global mapUnigram;
global mapStopWords ;


[perBigram, wordsBigram, extra] = textread(['./','bigram.txt'],'%s %s %s','delimiter','\t');
[perUnigram, wordsUnigram,extra] = textread(['./','unigram.txt'],'%s %s %s','delimiter','\t');

for i=1:length(wordsBigram)
    val{i} = {[perBigram(i);i]};
end

mapBigram = containers.Map(wordsBigram,val);

for i=1:length(wordsUnigram)
    val2{i} = {[perUnigram(i);i]};
end
mapUnigram = containers.Map(wordsUnigram,val2);


mapStopWords = containers.Map(stopwords_cellstring,[1:length(stopwords_cellstring)]);


end


function per= bigram(x,y)

global mapBigram;

str = strcat(x,' ',y);

if( ~isKey(mapBigram,str))
    per = 0.0001;
else
    per = mapBigram(str);
end

end

function c = condition(x,y,operation)
global mapUnigram;
global mapStopWords;

c = zeros(1,2*operation);
%ind = find(ismember(wordsUnigram,y));
if (isKey(mapUnigram,y))
    c(operation)=1;
end
if(isKey(mapStopWords,x))
    c(2*operation)=1;
end
if ( isnan(str2double(x)))
    c(2*operation)=1;
end
if ( ~isnan(str2double(x)))
    c(2*operation)=1;
end







end

function per = perCal(f,h,lambdaF,lambdaH)

per = lambdaF*f + lambdaH .* h;

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

Y{1} = strcat(' " ', X);

end

function Y =endPhrase(X)

Y{1} = strcat( X , ' " ');

end



