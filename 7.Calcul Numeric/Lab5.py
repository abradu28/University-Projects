#!/usr/bin/env python
# coding: utf-8

# pip install dictlearn
# 

# In[1]:


from dictlearn import DictionaryLearning
from dictlearn import methods
from matplotlib import image
from sklearn.feature_extraction.image import extract_patches_2d
from sklearn.feature_extraction.image import reconstruct_from_patches_2d
from sklearn.preprocessing import normalize
import numpy as np
from matplotlib import pyplot as plt


# In[2]:


I = image.imread(r'C:\Users\Radu\Desktop\facultate\Anul3\Calcul Numeric\Lab3\pisica.jpg')


# In[3]:


#parametrii

p = 8 # dimensiunea unui patch (numar de pixeli)
s = 6 # sparsitatea
N = 1000 # numarul total de patch-uri
1
n = 256 # numarul de atomi din dictionar
K = 50 # numarul de iteratii DL
sigma = 0.075 # deviatia standard a zgomotului


# In[4]:


#1 a)
print(I.shape)
I = np.array(I)


# In[5]:


#b)

Inoisy = I = sigma * np.random.randn(I.shape[0], I.shape[1])


# In[29]:


#c)

Ynoisy = extract_patches_2d(Inoisy, (p, p))
print(Ynoisy.shape)

Ynoisy = Ynoisy.reshape(Ynoisy.shape[0], -1)
print(Ynoisy.shape)

YnoisyT = np.transpose(Ynoisy)
medii_semnale = np.mean(YnoisyT, axis=0)



YnoisyT = YnoisyT - medii_semnale
Ynoisy = np.transpose(YnoisyT)


# In[36]:


#d)

Y = np.random.choice(Ynoisy.shape[1], (N, p))


# In[41]:


#2. a)

D0 = np.empty((N, n))

dl = DictionaryLearning(
n_components=n,
max_iter=K,
fit_algorithm='ksvd',
n_nonzero_coefs=s,
code_init=None,
dict_init=D0,
params=None,
data_sklearn_compat=False
)

D0 = normalize(D0, axis=0, norm='max')
dl.fit(Y)
D = dl.D_


# In[ ]:





# In[ ]:




