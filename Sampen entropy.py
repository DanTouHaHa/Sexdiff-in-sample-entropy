import numpy as np
import pandas as pd
import scipy.io as scio
import os
from scipy.io import loadmat,savemat
def sampEn(L:np.array, std : float ,m: int= 2, r: float = 0.2):
    """ 
    
    Input: 
        L: 
        std: 
        m: 2
        r: 0.2 or 0.1
    Output: 
        SampEn
    """
    N = len(L)
    B = 0.0
    A = 0.0
    # Split time series and save all templates of length m
    xmi = np.array([L[i:i+m] for i in range(N-m)])
    xmj = np.array([L[i:i+m] for i in range(N-m+1)])  
    # Save all matches minus the self-match, compute B
    B = np.sum([np.sum(np.abs(xmii-xmj).max(axis=1) <= r * std)-1 for xmii in xmi])
    # Similar for computing A
    m += 1
    xm = np.array([L[i:i+m] for i in range(N-m+1)])
    A = np.sum([np.sum(np.abs(xmi-xm).max(axis=1) <= r * std)-1 for xmi in xm])
    # Return SampEn
    return -np.log(A/B)
# path = 'E:\Fudan_Luoqiang_MDDProject\848MDD_794NC\data ananlysis\Dosen160' 
data = scio.loadmat('S20-2_NC.mat')
print(data)
 #print(data.keys())
print(data['NC'].shape)
result=[]
for i in range(data['NC'].shape[0]): 
    temp_result=[]
    for j in range(data['NC'].shape[2]):
        temp_data=data['NC'][i, :, j] 
        temp_entropy=sampEn(temp_data, np.std(temp_data)) 
        temp_result.append(temp_entropy)
    result.append(temp_result)

result_np=np.array(result)
print(result_np.shape)
np.savetxt('result_S20_NC.csv', result_np, delimiter=',')

