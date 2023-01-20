#!/usr/bin/env python
# coding: utf-8

# In[2]:


import numpy as np
import scipy.stats
import math


# In[3]:


#preturile date

x = [82, 106, 120, 68, 83, 89, 130, 92, 99, 89]
miu = 90
sigma = 10


# In[4]:


#1. distributia normala

scipy.stats.norm.pdf(x, miu, sigma)


# In[5]:


#2.  verosimilitatea pentru x1 = 82 
x1 = 82


def verosimilitate(x):
    return (1 / math.sqrt((2 * math.pi * sigma ** 2))) * math.e ** -(((x  - miu) ** 2) / (2 * sigma ** 2))

print(verosimilitate(x1))

print(scipy.stats.norm.pdf(x1, miu, sigma))

#acelasi rezultat


# In[6]:


#3

for i in x:
    print(verosimilitate(i))


# In[11]:


#4

#salvam verosimilitatea (P(x|theta))

ver = []

for i in x:
    ver.append(verosimilitate(i))

#probabilitatea a priori P(theta)

priori = 1 / 70


scipy.stats.norm.pdf(x, 100, 50)
scipy.stats.uniform.pdf(x, 1, 71)


# In[ ]:





# In[ ]:




