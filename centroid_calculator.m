%% Centroid & Distance Calculator with Excel Append (Toggle)
clear; clc;


% Toggle writing to Excel
writeToExcel = false;  % <-- Set to true to append results to Excel

% Excel file to store results
excelFile = '/Users/singh.raunak/Library/CloudStorage/OneDrive-MayoClinic/SinghRaunak/Insula_Project/contact_centroids.xlsx';

% Check if Excel file exists, if not create header
if writeToExcel && ~isfile(excelFile)
    T = table([],[],[],[],[],[],[], 'VariableNames', ...
        {'PatientID','ContactGroup','ContactID','CentroidX','CentroidY','CentroidZ','DistanceToInsula'});
    writetable(T, excelFile);
end

% Patient-specific info
patientID = '12-214-787';
contactGroup = 'Post. Insula';  

% Define contacts
contactSamples = {
    % Contact 1
    [27.89, -47.55, -3.08;
     29.03, -47.92, -3.08;
     27.77, -47.47, -4.46;
     29.08, -47.47, -3.23;
     29.08, -47.99, -4.03;
     28.84, -47.51, -4.42];

    %Contact 2
    [37.83, -49.61, -2.68;
     37.86, -50.60, -2.68;
     37.77, -49.52, -3.47; 
     37.70, -49.90, -3.35; 
     38.39, -50.02, -3.06;  
     38.39, -49.51, -2.80];

    % Contact 3
    [48.06, -50.66, -2.18;
     48.31, -52.01, -1.89;
     47.59, -49.81, -2.21; 
     47.12, -51.02, -2.43; 
     48.17, -50.47, -2.25;  
     48.39, -50.13, -2.2];

    % Contact 4
    [58.26, -52.24, 0.84;
     56.80, -52.24, -0.15;
     56.63, -52.32, -0.46; 
     56.80, -52.32, 0.08; 
     56.85, -51.58, -0.42; 
     57.09, -52.67, -0.42];

    % Contact 5
    %[-34.57, 40.49, 49.75;
    % -34.57, 40.38, 49.72;
    % -34.58, 40.00, 49.74; 
    % -34.29, 40.34, 50.23; 
    % -33.88, 40.00, 50.17; 
    % -34.35, 40.66, 49.72];

    % Contact 6
    %[-34.35, 40.60, 51.68;
     %-34.14, 40.94, 51.53;
     %-34.76, 41.36, 51.56; 
     %-34.27, 41.38, 51.69; 
     %-33.91, 41.64, 51.58; 
     %-34.06, 41.26, 51.58];

    % Contact 7
    %[-34.26, 41.76, 53.79;
     %-34.35, 41.39, 53.32;
     %-34.63, 41.74, 53.63; 
     %-34.37, 41.37, 53.63; 
     %-34.45, 41.70, 53.61; 
     %-34.12, 41.15, 53.87];

   % Contact 8
    %[-34.12, 41.27, 55.94;
     %-34.47, 41.75, 55.83;
     %-34.57, 41.37, 55.67; 
     %-34.29, 41.30, 55.47; 
     %-34.33, 41.65, 55.64; 
     %-34.33, 41.78, 55.88];
};

% Corresponding insula points

insulaPoints = [
    38.87, -47.40, -4.42; % Contact 1
    37.99, -49.88, -2.80; % Contact 2
    40.09, -50.06, -3.35;  % Contact 3
    37.15, -51.75, -0.42; % Contact 4
    %-34.35, 40.32, 49.81; % Contact 5
    %-34.26, 41.22, 51.60;  % Contact 6
    %-34.12, 41.54, 53.79;  % Contact 7
    %-34.12, 41.27, 55.94;  % Contact 8
];

% Compute centroids and distances
numContacts = numel(contactSamples);
centroids = zeros(numContacts,3);
distances = zeros(numContacts,1);

for c = 1:numContacts
    voxels = contactSamples{c};
    centroids(c,:) = mean(voxels,1);
    
    diff = centroids(c,:) - insulaPoints(c,:);
    distances(c) = sqrt(sum(diff.^2));
end


% Appending table 
ContactIDs = strcat('C', string(1:numContacts))';
PatientIDs = repmat({patientID}, numContacts, 1);
ContactGroups = repmat({contactGroup}, numContacts, 1);

Tpatient = table(PatientIDs, ContactGroups, ContactIDs, ...
    centroids(:,1), centroids(:,2), centroids(:,3), distances, ...
    'VariableNames', {'PatientID','ContactGroup','ContactID','CentroidX','CentroidY','CentroidZ','DistanceToInsula'});


% Display results
disp('Results for patient (not yet written to Excel):');
disp(Tpatient);

% --------------------------------
% Append to Excel if toggle is ON

if writeToExcel
    Texisting = readtable(excelFile);
    Tall = [Texisting; Tpatient];
    writetable(Tall, excelFile);
    disp(['Patient ', patientID, ' results appended to Excel file.']);
end