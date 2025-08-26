#Import necessary libraries
import torch
from sbi.analysis import pairplot
from sbi.inference import NPE
from sbi.utils import BoxUniform
from sbi.utils.user_input_checks import (
    check_sbi_inputs,
    process_prior,
    process_simulator,
)
import pickle
import pandas as pd
import numpy as np
import math

#Load inferred posterior
f = open('/data/others/ciarchi/Ageing/alpha/nnsbi.pckl', 'rb')
posterior = pickle.load(f)
f.close()

#Read file
print("Reading file...")
readfile = pd.read_csv("/data/others/ciarchi/Ageing/alpha/wolf.csv")

#Save samples
print("Sampling sites...")
g = readfile.groupby(['start','seqnames'])
readfile = readfile[g.ngroup().isin(np.random.choice(g.ngroups,200000,replace=False))]


#Save vectors
average_meth = readfile["avg.meth"].tolist()
average_cov = readfile["avg.cov"].tolist()
variance = readfile["var.meth"].tolist()

#Create vector of alphas
alphas = np.zeros(len(average_meth))

# Infer alpha for every site
print("Starting inference of alpha...")
for i in range(0,len(average_meth)):
    if math.isnan(variance[i]):
        alphas[i] = 2.0
        continue
    elif variance[i] == 0:
        alphas[i] = 2.0
        continue
    else:
        x_obs = [average_meth[i],variance[i],5]
        alphas[i] = posterior.sample((1,), x=x_obs, show_progress_bars=False)[0,1].item()

#Add column to data frame
readfile["alpha"] = alphas

#Save to .csv
print("Saving file...")
readfile.to_csv('/data/others/ciarchi/Ageing/alpha/wolf_alpha.csv')