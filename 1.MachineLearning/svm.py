#!/usr/bin/env python
# coding: utf-8

# In[ ]:


# This Python 3 environment comes with many helpful analytics libraries installed
# It is defined by the kaggle/python Docker image: https://github.com/kaggle/docker-python
# For example, here's several helpful packages to load

import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)

# Input data files are available in the read-only "../input/" directory
# For example, running this (by clicking run or pressing Shift+Enter) will list all files under the input directory

import os
for dirname, _, filenames in os.walk('/kaggle/input'):
    for filename in filenames:
        print(os.path.join(dirname, filename))

# You can write up to 20GB to the current directory (/kaggle/working/) that gets preserved as output when you create a version using "Save & Run All" 
# You can also write temporary files to /kaggle/temp/, but they won't be saved outside of the current session


# In[ ]:





# In[ ]:


import matplotlib.pyplot as plt
import seaborn as sns

#citirea datelor cu panda
train_data = pd.read_table('/kaggle/input/unibuc-2022-s24/train.txt', sep=',')
validation_data = pd.read_table('/kaggle/input/unibuc-2022-s24/validation.txt', sep=',')
test_data = pd.read_table('/kaggle/input/unibuc-2022-s24/test.txt', sep=',')
sample_submission = pd.read_table('/kaggle/input/unibuc-2022-s24/sample_submission.txt', sep=',')

#transformarea datelor in numpy
train_data_np = np.array(train_data)
validation_data_np = np.array(validation_data)
test_data_np = np.array(test_data)


# In[ ]:


#pentru a putea prelucra datele avem nevoie sa tranformam
#imaginile in pixeli
train_images = []
validation_images = []
data_dir = '/kaggle/input/unibuc-2022-s24/'

for img in train_data_np[:, 0]:
    image = plt.imread(data_dir + 'train+validation/' + img)
    train_images.append(image)

train_images = np.array(train_images)
#train_images.shape


for img in validation_data_np[:, 0]:
    image = plt.imread(data_dir + 'train+validation/' + img)
    validation_images.append(image)
    
validation_images = np.array(validation_images)
#print(validation_images.shape)


# In[ ]:


#train_data_np[:, 1]
#extragerea etichetelor
train_labels = train_data_np[:, 1]
validation_labels = validation_data_np[:, 1]


# In[ ]:


train_images = train_images.reshape(train_images.shape[0], -1)
#train_labels


# In[ ]:


from sklearn import svm

#crearea modelului
clf = svm.SVC(gamma='auto', kernel='rbf')
clf.fit(train_images, train_labels.astype(int))


# In[ ]:


validation_images = validation_images.reshape(validation_images.shape[0], -1)
#validation_images.shape
#validation_images[1]


# In[ ]:


# clf = svm.SVC(C=1, gamma=0.1, kernel='rbf')
# clf.fit(train_images, train_labels.astype(int))
# clf.score(validation_images, validation_labels.astype(int))


# In[ ]:


# functie pentru determinarea celor mai buni parametrii
def find_best_score(C, gamma):
    clf = svm.SVC(C=C, kernel='rbf', gamma=gamma)
    clf.fit(train_images, train_labels.astype(int))
    return clf.score(validation_images, validation_labels.astype(int))

best_gamma = 0
best_C = 0
best_score = 0

ls = [100, 10, 1, 1e-1, 1e-2, 1e-3]

# aflam valorile optime ale parametrilor C si gamma
# pentru setul nostru de date

for C in ls:
    for gamma in ls:
        rez = find_best_score(C, gamma)
        print(rez)
        if rez > best_score:
            best_score = rez
            best_C = C
            best_gamma = gamma 


# In[ ]:


#C = 10 gamma = 0.01
best_C
best_gamma


# In[ ]:


test_images = []
for img in test_data_np[:, 0]:
    image = plt.imread(data_dir + 'test/' + img)
    test_images.append(image)
    
test_images = np.array(test_images)


# In[ ]:


test_images = test_images.reshape(test_images.shape[0], -1)


# In[ ]:


clf = svm.SVC(C=10, kernel='rbf', gamma=0.01)
clf.fit(train_images, train_labels.astype(int))
clf.score(validation_images, validation_labels.astype(int))


# In[ ]:


test_labels = clf.predict(test_images)


# In[ ]:


open('sample_submission.txt', 'w').close()
f = open("sample_submission.txt", "w")
f.write("id,label\n");
for i in range(0, len(test_labels)):
    value1 = test_labels[i];
    value2 = test_data_np[:, 0][i];
    f.write(str(value2) + "," + str(value1)+ "\n");
f.close()


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




