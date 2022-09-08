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


from keras.utils.np_utils import to_categorical # convert to one-hot-encoding
from keras.models import Sequential
from keras.layers import Dense,Flatten, Dropout, BatchNormalization, Lambda, Conv2D, MaxPool2D
from tensorflow.keras.optimizers import Adam
from keras.callbacks import EarlyStopping, ModelCheckpoint
from tensorflow.image import resize
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.utils import shuffle
from keras.preprocessing.image import ImageDataGenerator
from keras.callbacks import ReduceLROnPlateau
from keras.callbacks import LearningRateScheduler
from tensorflow.keras.optimizers import SGD
from keras.applications.xception import Xception


# In[ ]:



#importarea datelor
train_data = pd.read_table('/kaggle/input/unibuc-2022-s24/train.txt', sep=',')
validation_data = pd.read_table('/kaggle/input/unibuc-2022-s24/validation.txt', sep=',')
test_data = pd.read_table('/kaggle/input/unibuc-2022-s24/test.txt', sep=',')
sample_submission = pd.read_table('/kaggle/input/unibuc-2022-s24/sample_submission.txt', sep=',')

#transformare in numpy
train_data_np = np.array(train_data)
validation_data_np = np.array(validation_data)
test_data_np = np.array(test_data)


# In[ ]:


train_images = []
validation_images = []
data_dir = '/kaggle/input/unibuc-2022-s24/'
#transformare in pixeli
for img in train_data_np[:, 0]:
    image = plt.imread(data_dir + 'train+validation/' + img)
    train_images.append(image)

train_images = np.array(train_images)
train_images.shape


for img in validation_data_np[:, 0]:
    image = plt.imread(data_dir + 'train+validation/' + img)
    validation_images.append(image)
    
validation_images = np.array(validation_images)
print(validation_images.shape)


# In[ ]:


train_data_np[:, 1]
train_labels = train_data_np[:, 1]
validation_labels = validation_data_np[:, 1]
validation_images, validation_labels = shuffle(validation_images, validation_labels) 
train_images, train_labels = shuffle(train_images, train_labels)

#convertire la one-hot label
train_labels = to_categorical(train_labels, num_classes=7, dtype='float32')
validation_labels = to_categorical(validation_labels, num_classes=7, dtype='float32')


# In[ ]:


#model CNN de tip sequential
model = Sequential()
#resize la imagini
model.add(Lambda(lambda x: resize(x, (244, 244))))
model.add(Xception(pooling='max', weights='imagenet', include_top=False))
model.add(Flatten())
model.add(Dense(32, activation='relu'))
model.add(BatchNormalization())
model.add(Dense(128, activation='relu'))
model.add(BatchNormalization())
model.add(Dense(7, activation='softmax'))


# In[ ]:


learning_rate = 1e-4
#parametri default
beta_1=0.9
beta_2=0.999
epsilon=1e-07
optimizer = Adam(learning_rate=learning_rate, beta_1=beta_1, beta_2=beta_2, epsilon=epsilon) 
#optimizer = SGD(learning_rate = 0.001, momentum=0.9, nesterov=False)
data_gen = ImageDataGenerator(rotation_range=25,
                             width_shift_range=0.3,
                             shear_range=0.12,
                            # zoom_range=0.1,
                             channel_shift_range=10,
                             horizontal_flip=True)

#train_flow = data_gen.flow(train_images, train_labels)
model.compile(optimizer=optimizer, loss='categorical_crossentropy', metrics=['accuracy'])
lrs = LearningRateScheduler(lambda x: 1e-3 * 0.90 ** x)
#epochs = 25
epochs = 25
#batch_size = 16
batch_size = 64
steps_per_epoch=train_images.shape[0] // batch_size
model.fit(train_images, train_labels, epochs=epochs, batch_size=batch_size, 
          validation_data=(validation_images, validation_labels),
          verbose=1,
          shuffle=True,
          steps_per_epoch=steps_per_epoch,
         callbacks = [lrs])


# In[ ]:


model.summary()


# In[ ]:


test_images = []
for img in test_data_np[:, 0]:
    image = plt.imread(data_dir + 'test/' + img)
    test_images.append(image)
test_images = np.array(test_images)

test_labels = model.predict(test_images)

test_labels.shape

np.argmax(test_labels[2])
# for i in range(0, 2819):
#     test_labels[i] = np.argmax(test_labels[i])

    
test_labels = np.argmax(test_labels, axis=1)
test_labels

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




