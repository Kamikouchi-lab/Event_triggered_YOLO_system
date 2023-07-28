# Event-triggered feedback system using YOLO for optogenetic manipulation of neural activity

[![DOI](https://zenodo.org/badge/587573141.svg)](https://zenodo.org/badge/latestdoi/587573141)

# About System
Paper : [Yamanouchi et al., 2023](https://ieeexplore.ieee.org/document/10150245)

## APs of each model
<img src=/Images/model_evaluation.png width=500>

## System abstract

### Abstract
Manipulation of neural activity is necessary for identifying the neural basis of animal behavior. Optogenetic methods allow time-specific manipulation of neural activity in animals with high precision. Devices have been proposed for optogenetics experiments that automatically detect animal behavior and trigger photostimulations, but it is difficult for biologists to implement these devices in an experimental system because of the complicated system and programming. In this study, we establish an event-triggered feedback system for optogenetic manipulation of neural activity that is introduced in the experimental system easily and highly applicable. Using fly copulation as an example, we evaluated the models for fly copulation detections and succeeded in detecting copulation initiation with high accuracy.
(From paper)

<img src=/Images/system_ab.jpg width=500>

## About Files
Colab_training : There are programs for creating each models and YOLO models.

copulation_detection_system : There are an Event-triggered system program and an Arduino program.

R_program : There are R programs for data analysis.

Images : There are images of the paper

Example_movies : There are sample movies of this sytem
