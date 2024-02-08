#!/usr/bin/env python

import h5py
import numpy as np
import pandas as pd
import json
import matplotlib.pyplot as plt
import os
import sys

folder = sys.argv[1]
    
clear = len(sys.argv) > 2 and sys.argv[2] == "clear"

mat = h5py.File('{}/trx.mat'.format(folder))
os.system("cp {}/trx.mat {}/trx_new.mat".format(folder, folder))
newmat = h5py.File('{}/trx_new.mat'.format(folder), "r+")

trx = newmat["trx"]

std_tags = ["back", "back_large", "back_strong", "back_weak",
            "cast", "cast_large", "cast_strong", "cast_weak",
            "hunch", "hunch_large", "hunch_strong", "hunch_weak",
            "roll", "roll_large", "roll_strong", "roll_weak",
            "run", "run_large", "run_strong", "run_weak",
            "stop", "stop_large", "stop_strong", "stop_weak",
            "small_motion"]

# Read the label data
with open("{}/predicted.label".format(folder), "r") as f:
    data = json.load(f)

labels = data["labels"]
hist = dict.fromkeys(labels, 0)
for i, pairs in enumerate(data["data"]):
    pairid = pairs["id"]
    for n in range(len(pairs["t"])):
        hist[labels[pairs["labels"][n]-1]] += 1
print(hist)

numero = []
for i in range(len(data["data"])):
    numero.append(int(mat[trx["numero_larva_num"][0][i]][0][0]))

for i in range(len(data["data"])):
    print(i+1, "/", len(data["data"]))
    idstr = data["data"][i]["id"]
    j = np.where(np.array(numero) == int(idstr))[0][0]
    t1 = mat[trx["t"][0][j]][0]
    t2 = data["data"][i]["t"]

    # For each time step, work out the label
    for n in range(len(t2)):
        # Get the label
        label = labels[data["data"][i]["labels"][n]-1]
        if clear:
            for tag in std_tags:
                newmat[trx[tag][0][j]][0,n] = -1
        newmat[trx[label][0][j]][0,n] = 1
            
        newmat.flush()

# Save changes
newmat.close()