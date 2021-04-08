import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

fname = sys.argv[1] 
my_file = open(fname, "r")
content_list = my_file.readlines()

ls = []
for x in content_list:
	x = x.strip()
	ls.append(float(x))

nls = np.asarray(ls)
mn = np.mean(nls)
md = np.median(nls)
# print(ls)
plt.hist(ls, bins=(int)(sys.argv[2]))
plt.axvline(x=mn, label="mean at {}".format(round(mn,2)), c='r')
plt.axvline(x=md, label="median at {}".format(round(md,2)), c='k')
plt.legend()
plt.savefig(fname[0:-4]+'.png')
plt.show()