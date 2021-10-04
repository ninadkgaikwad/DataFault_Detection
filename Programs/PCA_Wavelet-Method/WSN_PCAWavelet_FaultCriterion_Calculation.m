function [ QValue_Threshold ] = WSN_PCAWavelet_FaultCriterion_Calculation( Error_Matrix )

%% Function Input and Output Argument Description:

% Input Arguments:

% Error_Matrix : 

% Output Arguments:

% QValue_Threshold :

%% The Code

% Getting Size of Error Matrix

[R,C]=size(Error_Matrix);

% Initializing SquaredError_Matrix, QValue_Matrix, QProportion_Matrix

SquaredError_Matrix=zeros(R,C);

QValue_Matrix=zeros(R,1);

QProportion_Matrix=zeros(R,C);

% Computing SquaredError_Matrix

SquaredError_Matrix=Error_Matrix.*Error_Matrix;

% Computing QValue_Matrix

QValue_Matrix=sum(SquaredError_Matrix,2);

% Computing QProportion_Matrix

for i=1:R % For each row in SquaredError_Matrix
    
    Row_Vector=SquaredError_Matrix(i,:); % Getting the correct row of SquaredError_Matrix
    
    QValue=QValue_Matrix(i,1); % Getting the correct QValue from QValue_Matrix
    
    Proportion_RowVector=(Row_Vector./QValue).*100;
    
    QProportion_Matrix(i,:)=Proportion_RowVector;
    
end

% Creating Variable for Graphs

x=1:R; % The x vector for the Q-Threshold Value line

QValue_Matrix1=QValue_Matrix';

Status=1; % Initializing Status

while (Status==1)
   
    % Getting Percentile Value from the User
    
   PercentileValue=input('Enter the Percentile Value for Q-Treshold: ');
   
   QValue_Threshold = prctile(QValue_Matrix,PercentileValue); % Geting QValue for user input Percentile
   
   y=zeros(1,1:R); % Initializing y vector the Q-Threshold Value line
   
   y(1,1:R)=QValue_Threshold;
   
   % Plotting the Graph
   
   figure(1);
   title('Q-Value Plot : Training');
   xlabel('Samples');
   ylabel('Q-Values');
   hold on
   scatter(x,QValue_Matrix1,'MarkerEdgeColor','b') % Ploting the Scatter of the Q Values
   plot(x,y,'Color','r','LineWidth',1); % Plotting Q Threshold Value Line
   hold off
    
   % Getting Status from User
   
   Status=input('Enter 1: To Select new Percentile Value; 0: To move ahead : ');
   
   close(1);
   
end

% Creating Q-Contribution Graph

while(Status1==1)

    % Asking user for Sample Vector
    
    Sample_Vector=input('Enter Sample Vector for viewing Q-Contribution Plot [e.g. 1:10] : ');
    
    % Plotting Q-Contribution Graph
    figure(2)
    title('Q-Contribution Plot : Training');
    xlabel('Samples');
    ylabel('Q-Values');
    bar(QProportion_Matrix(Sample_Vector,:),'stacked')
    
    Status1=input('Enter 1: To Select new Samle Vector; 0: To move ahead : ');

    close(2);
    
end

end
