clc
clear
close all
flag=28;
if flag==100
    load data
else 
    load data28
end
x=measure_matrix;
y=measure_result;
x=x2fx(x,'interaction');
x=x(:,2:end);
[B FitInfo]=lasso(x,y,'CV',size(y,1));
plottype={'CV','L1','lambda'};
for i=1:2
    lassoPlot(B,FitInfo,'PlotType',plottype{i});
end
y_hat=FitInfo.Intercept(FitInfo.IndexMinMSE)+x*B(:,FitInfo.IndexMinMSE);
plotyyhat(y,y_hat);
figure
plot(1:size(y,1),[y';y_hat'],'-*')
legend('experiment','prediction')
%%
betaname=drugIndex(drug_7);
matchDrug=matchDrugname(drug_7);
chooseindex=find(abs(B(:,FitInfo.IndexMinMSE)));
drug_choose=union([],betaname(chooseindex,:));
figure;plot(B(:,FitInfo.IndexMinMSE));
if flag==100
    sheet='beta100';
else
    sheet='beta28';
end
xlswrite('data.xlsx',B(:,FitInfo.IndexMinMSE),sheet,'A1')
xlswrite('data.xlsx',betaname,sheet,'B1')
xlswrite('data.xlsx',matchDrug,sheet,'D1')
%%%
system('start data.xlsx')


function yy=drugIndex(drug_7)
[m,n]=size(drug_7);
if m==1
    drug_7=drug_7';
end
iterm1=[drug_7 drug_7];
iterm2=nchoosek(drug_7,2);
yy=[iterm1;iterm2];
end

%%%%
%sign the name to the drug pairs
function result=matchDrugname(drug_7);
[all1 all2 all3]=xlsread('data.xlsx','gather100_manu');
all3=all3(2:end,:);
betaname=drugIndex(drug_7);
result={};
for i=1:size(betaname,1)
    pair=betaname(i,:);
    result{i,1}=all3{find(cell2mat(all3(:,3))==pair(1)),2};
    result{i,2}=all3{find(cell2mat(all3(:,3))==pair(2)),2};
end
end

function yy=plotyyhat(y,y_hat)
figure
plot(y,y_hat,'*')
hold on
A=polyfit(y,y_hat,1);
R=corrcoef(y,y_hat);
z=polyval(A,y);
yy=R(1,2);
tmp=0:0.1:1;
plot(tmp,tmp,'g',y,z,'r')%?????????¨²??
title(['R=' num2str(yy)]);
end