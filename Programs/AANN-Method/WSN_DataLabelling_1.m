function [ SensorDataMatrixLabelled_Cell, SensorTotalNum ] = WSN_DataLabelling_1( SensorDataMatrix, AC_Data, UpperBound, LowerBound, RateOfChange, SensorGroup, Res )

%% Function Input and Output Argument Description:

% Input Arguments:

% SensorDataMatrix : 
% AC_Data : 
% UpperBound :
% LowerBound :
% RatOfChange : 
% SensorGroup :
% Res : 

% Output Arguments:

% SensorDataMatrixLabelled_Cell :
% SensorTotalNum : 

%% The Code

% Get Size of the SensorDataMatrix

[R, C]=size(SensorDataMatrix);

% Computing Cell Length

Cell_Length=2*C;

% Initializing Cell Elements

Data_Part=zeros(R,4); % Col 1:Sensor Measurements; Col 2,3:Labels for ANN ([1,0]=No Fault;[0,1]=Fault); Col 4: Labels for SVM ([1]=No Fault;[-1]=Fault)

CharLabel_Part=cell(R,1); % Fault and No-Fault Labels

% Initializing SensorDataMatrixLabelled_Cell

SensorDataMatrixLabelled_Cell=cell(1,Cell_Length);

for i=1:Cell_Length
    
   if (i<=Cell_Length)
       
       SensorDataMatrixLabelled_Cell(1,i)=Data_Part;
       
   else
       
       SensorDataMatrixLabelled_Cell(1,i)=CharLabel_Part;
       
   end
    
end



% Fault Labelling Algorithm

for j=1:C % Through the Colums
    
    for i=1:R % Through the Rows
        
        % Initialize the FaultVector

        FaultVector=zeros(1,5) % One for each Data Rule that can be violated by Faulty Data
        
        % Upper Bound Violation
        
        if (SensorDataMatrix(i,j)>=UpperBound)
            
           FaultVector(1,1)=1;
            
        end
        
        % Lower Bound Violation
        
        if (SensorDataMatrix(i,j)<=LowerBound)
            
           FaultVector(1,2)=1;
            
        end        
        
        % AC Set Point Violation
        
        if (AC_Data(i,1)==1) % AC Status ON
            
            if ((SensorDataMatrix(i,j)>(AC_Data(i,2)+1))||(SensorDataMatrix(i,j)<(AC_Data(i,2)-1)))  
                
                FaultVector(1,3)=1;
                
            end
                   
        end 
        
         % Rate of Change Violation         
                
        if (i==1)
            
           FaultVector(1,4)=0;
           
        else
            
            % Computing Rate of Change of Sensor Measurement
            
            RoC=(SensorDataMatrix(i,j)-SensorDataMatrix(i-1,j))/Res;
            
            RoC=abs(RoC);
            
            RoC1= abs(RateOfChange(1,j));
            
            if (RoC>RoC1)
               
               FaultVector(1,4)=1; 
                
            end
            
        end
        
        % Regression Value Violation : Calling External Function
        
         [ RegressionViolation ] = WSN_Regression_FaultLabelling_1( SensorGroup, SensorDataMatrix(i,:), j );
         
         if (RegressionViolation==0) % No Violation
             
             FaultVector(1,5)=0;
             
         elseif (RegressionViolation==1) % Violation
             
             FaultVector(1,5)=1;
             
         end
         
         % Analysis of Fault Vector
         
         FaultVector_Status=find(FaultVector);
         
         Status=length(FaultVector_Status);
         
         if (Status==0) % Data Not Faulty
             
             % Data Part
             
             Data=SensorDataMatrixLabelled_Cell{1,j};
             
             Data(i,1)=SensorDataMatrix(i,j); % Storing Sensor Data
             
             Data(i,2:3)=[1,0]; % Not Faulty for ANN
             
             Data(i,4)=1; % Not Faulty for SVM
             
             % Character Part
             
             SensorDataMatrixLabelled_Cell(1,j)={Data}; % Storing Updated Data in Cell Array
             
             Character=SensorDataMatrixLabelled_Cell{1,j+C};
             
             Character(i,1)={'Not Faulty'}; % String Label 
             
             SensorDataMatrixLabelled_Cell(1,j+C)={Character}; % Storing Updated Data in Cell Array
             
         elseif (Status>0) % Data Faulty
             
             % Data Part
             
             Data=SensorDataMatrixLabelled_Cell{1,j};
             
             Data(i,1)=SensorDataMatrix(i,j); % Storing Sensor Data
             
             Data(i,2:3)=[0,1]; % Not Faulty for ANN
             
             Data(i,4)=-1; % Not Faulty for SVM
             
             SensorDataMatrixLabelled_Cell(1,j)={Data}; % Storing Updated Data in Cell Array
             
             % Character Part
             
             Character=SensorDataMatrixLabelled_Cell{1,j+C};
             
             Character(i,1)={'Faulty'}; % String Label 
             
             SensorDataMatrixLabelled_Cell(1,j+C)={Character}; % Storing Updated Data in Cell Array             
             
         end
        
    end
    
end

end

