# Temporal-Enhanced-Ultrasound
All code and models related to TeUS and my MSc thesis. 


# Script instructions
TeUS ViTUS Script Guide

1. Helper Scripts
- Contains a lot of scripts and functions that are used by other scripts
- FFT, detrending, creating GIFs, bmode images, time series plots, etc.


2. Jan17 Phantom Scripts
- This folder contains the scripts used on the 9 phantoms for my thesis
- Experiment_Master_5fold.m - The main script that will run all experiments using 5fold CV and save average results. 
You can specify the 'type' which are provided in 'loadFold.m', and the data will be loaded and results outputted. 
- generateEMBCFolds.m - Actually generates the TeUS or ViTUS 6folds using all planes of all phantoms.
There are a few parameters that need to be changed depending on the experiments. Most of these are at the top
(element, numberSamplesFromCenter, initialFocus, amplitude, number of acquired frames, etc). The rest of the code simply
loads and converts the data.
- Tree_Folds.m - this is ran inside the master_5fold.m script. It is the decision tree model that will load the train/test folds, select the phantoms used for classification, and produce results. 
- Tree_8train4test.m is a faster version that uses the train/test split. 

- There is a separate folder for some TeUS and ViTUS scripts

TeUS
- generateTrainTestAllPlanes.m is the script that generates a train/test file for TeUS. 
- Jan20_9classes.m is a script that only uses 2 planes - one for train and one for test. Allows for fast testing. 

ViTUS
- createVirtualTeUSROI.m is an important function that will generate dynamic ROIs. 
Within this script, there is a for loop that goes through the number of necessary 
frames, calculates where the ROI should be, and selectes the RF data from that area.

IMPORTANT: To do dynamic ROI ViTUS, line 11 should be: movingROI(:,:,i) = phantom_RF(sample1:sample2, element1:element2,i). 
Note that the 3rd dimension is 'i' meaning that the frame used to create the movingROI changes 

To do single frame ViTUS, line 11 should be: movingROI(:,:,i) = phantom_RF(sample1:sample2, element1:element2,1). Here, the 
3rd dimension is '1' meaning the first frame is always used. 

- generateTrainTestAllPlanes_virtualTeus.m is the script that generates a train/test split for ViTUS



To run the experiments, simply specify the type in 'Experiment_Master_5fold.m' and the rest will happen automatically. 
