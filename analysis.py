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
    'person_id',
    'x_occurrence',
    'x_psychiatric',
    'xn_psychiatric',
    'is_psychiatric',
    'x_visit',
    'x_procedure',
    'avg_occu_duration',
    'min_occu_duration',
    'max_occu_duration',
    'is_death',
    'x_age',
    'is_sex_male',
    'is_sex_female',
    'x_mellitus',
    'x_hypertension',
    'x_alz',
    'x_critical',
    'is_critical',
    'x_crit_duration',
    'x_crit0_psychiatric',
    'x_crit1_psychiatric',
    'x_crit2_psychiatric',
    'd0',
    'd1',
    'd2'
]

df = pd.read_csv('results-20190922-131603-notitle.csv', header = None, names = names)

Y = df['is_critical']
X = df.drop(['person_id', 'is_critical', 'd0', 'd1', 'd2'], axis=1) # df.iloc[x1:y1, x2:y2]
#X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.3)

X2 = sm.add_constant(X)
est = sm.OLS(Y, X2)
est2 = est.fit()
print(est2.summary())

#logit_model = sm.Logit(Y, X).fit()
#print logit_model.summary()

clf = LogisticRegression()
#print clf.fit(X_train, Y_train)
#print clf.score(X_test, Y_test)
print clf.fit(X, Y)
#print clf.coef_

coef = clf.coef_[0]
print coef

print "===== Logistic Regression: Result  ====="
coefs = zip(coef, names[1:])
print "coef.e  \tcoef.d  \tname"
for x in coefs:
    print ('%.2E' % x[0]), "\t", x[0], "\t", x[1]
