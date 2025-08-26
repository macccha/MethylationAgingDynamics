This repository contains the files used for data analysis, modelling, and parameter inference in the preprint https://www.biorxiv.org/content/10.1101/2025.08.13.669476v1.abstract.

The file sbi-methinheritance.ipynb contains the main bulk of the code. It infers the posterior of the model through the SBI package, and applies the inference to the aging data (MEF cells, Petkovich and Stubbs) used in the preprint.

The file wolf_analysis.py includes the inference of model parameters for the Wolf dataset.

The file nnsbi.pckl includes the inferred posterior through the SBI package as a pickle file.

The R scripts are used for data loading and data processing.

To run the scripts, the minimal version of python to run the SBI package is required. The last versions of the required python libraries can be used.

Demo instructions are in the demo folder.

To run the software on the data used in the preprint, it is necessary first to download the corresponding data from the sources indicated in the manuscript. The R files can then be used for first data processing: this should produce a .csv for the inference in python. The inference can then be carried out either with the notebook or the python script (for the Wolf dataset). The notebook contains also a section to create the posterior for the model dynamics for parameter inference.
