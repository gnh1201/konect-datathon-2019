#!/usr/bin/env python
# -*- coding: utf-8 -*-

#%matplotlib inline
import math
import numpy as np
import scipy
from scipy.stats import binom, hypergeom
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
import statsmodels.api as sm

names = [
    'is_critical',
    'x_psychiatric',
    'xn_psychiatric',
    'x_occurrence',
    'x_visit',
    'x_procedure',
    'avg_occu_duration',
    'min_occu_duration',
    'max_occu_duration',
    'x_death',
    'x_age',
    'x_sex',
    'x_mellitus',
    'x_hypertension',
    'x_alz',
    'x_critical',
    'x_crit_duration',
    'x_crit0_psychiatric',
    'x_crit1_psychiatric',
    'x_crit2_psychiatric'
]

df = pd.read_csv('results-20190922-043020-notitle.csv', header = None, names = names)

Y = df['is_critical']
X = df.drop(['is_critical'], axis=1) # df.iloc[x1:y1, x2:y2]
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.3)

clf = LogisticRegression()
print clf.fit(X_train,Y_train)
print clf.score(X_test, Y_test)
print clf.coef_

X2 = sm.add_constant(X)
est = sm.OLS(Y, X2)
est2 = est.fit()
print(est2.summary())

#logit_model = sm.Logit(Y, X).fit()
#print logit_model.summary()

coef = clf.coef_[0]
print coef

print "===== Logistic Regression (Train:Test = 7:3) ====="
coefs = zip(coef, names[1:])
for x in coefs:
    print ('%.2E' % x[0]), "\t", x[0], "\t", x[1]
