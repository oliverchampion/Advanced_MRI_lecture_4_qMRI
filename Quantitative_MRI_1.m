clc
clear all
close all
%% add relevant toolboxes
addpath(genpath('L:\basic\divi\Pub\Software\matlab\toolbox_common\nifti\20140122'))
%% loading the data
data=load_untouch_nii('data.nii.gz');
%% loading the mask
mask=load_untouch_nii('segmentation_liver.nii.gz');
%% defining the b-values at which the acquisitions have been obtained on the scanner
bvalues=[0 50 40 30 40 250 50 40 600 10 30 600 30 75 600 400 600 600 10 20 20 150 600 20 40 40 600 10 600 100 150 600 50 400 10 0 0 100 0 30 600 150 10 600 0 600 30 75 30 10 40 100 20 100 50 50 100 250 100 20 600 100 600 30 50 250 30 10 600 30 20 0 0 0 600 0 50 0 75 0 10 40 50 75 50 0 100 100 20 20 250 20 0 40 0 150 100 100 100 400 40 10 400 0 ];
%% showing a slice from the 4D volume. Note the slice is flipped to show the patient in the right orientation
figure;
imshow(flip(squeeze(data.img(:,20:110,10,1))'),[]);
figure;
imshow(flip(squeeze(mask.img(:,20:110,10))'),[]);
figure;
imshow(double(flip(squeeze(data.img(:,20:110,10,1))')).*double(flip(squeeze(mask.img(:,20:110,10))')),[]);


%% select a slice to work with
data_slice=flip(squeeze(data.img(:,20:110,10,:)));
mask_slice=flip(squeeze(mask.img(:,20:110,10)))>0.5;

%% the scan was obtained with repeated measures per b-value to increase signal to noise ratio. Here we take the mean to reduce the number of datapoints to increase analysis speed.
%% take the mean per b-value to reduce the amount of data (saves time)
ubval=unique(bvalues);
dummy=1;
for ub=ubval
    data_slice2(:,:,dummy)=mean(data_slice(:,:,bvalues==ub),3);
    dummy=dummy+1;
end
data_slice=data_slice2;

%% Selecting only the voxels from within the mask
data_sel=reshape(data_slice(repmat(mask_slice,[1,1,length(ubval)])),[],length(ubval));
sprintf('size of data_sel is %d selected voxels times %d b-values',size(data_sel,1),size(data_sel,2))

%% define the IVIM fit function
% ADC as example
funADC = @(data)@(x) sum((data-x(1)*exp(-ubval * x(2))).^2);
x0ADC=[1,0.003]; %initial guess; starting point for fit
data_mean=mean(data_sel,1);
yADC=fminsearch(funADC(data_mean),x0ADC)
b=0:650;
figure;
plot(ubval,data_mean,'x')
hold on
plot(b,yADC(1)*exp(-b* yADC(2)));
xlabel('b-value (mm^2/s)') 
ylabel('Signal (a.u.)')
set(gca, 'YScale', 'log')

%% Exercise 1a


%% Exercise 1b: implement IVIM
close all

%% Exercise 1c


%% Exercise 1d
% we will start with normalizing the IVIM signal to have good S0 guesses.
close all
data_norm=double(data_slice)./(repmat(double(data_slice(:,:,ubval==0)),[1,1,size(data_slice,3)]));

%% 1e:

%% 1f (BONUS):
% hint: to save time, start testing at 1 SNR and only once that works, loop
% over all SNRs

snrs=[100, 50, 20, 10, 7, 5];
for snr=snrs

end