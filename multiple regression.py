from operator import index
import numpy as np
import pandas as pd
from statsmodels.formula.api import ols
import os
from statsmodels.stats.multitest import multipletests as HWJ  

files_list=os.listdir(r'E:\Fudan_Luoqiang_MDDProject\848MDD_794NC\数据分析\数据整理统计分析\Non_Global\Dosen160\AllsiteNC')
result_df=pd.DataFrame()
for file in files_list:
    if 'site' in file:
        data_frame = pd.read_excel(r'E:\Fudan_Luoqiang_MDDProject\848MDD_794NC\数据分析\数据整理统计分析\Non_Global\Dosen160\AllsiteNC\\'+file)
        #result_DS=[]
        #result_param_DS=[]
        #result_DS_fdr = [] #用于存储校正后的P值

        #result_D=[]
        #result_param_D=[]
        #result_D_fdr = [] #用于存储校正后的P值

        result_S=[]
        result_param_S=[]
        #result_S_fdr = [] #用于存储校正后的P值

        for key in data_frame.keys():
            if 'Network' in key:
                lm = ols(key+' ~   Sex + Age + Education + C(site) + mean_FD', data = data_frame).fit() #控制年龄性别教育的影响，看疾病的作用
                
                #result_DS.append(lm.pvalues) 
                #result_param_DS.append(lm.params)

                #result_D.append(lm.pvalues) #原始的P值
                #result_param_D.append(lm.params)     #β值，原始非标准化。          
                
                result_S.append(lm.tvalues) 
                result_param_S.append(lm.df_resid)
        
        #result_param_DS=[item['diagnosis:Sex'] for item in result_param_DS]
        #result_DS=[item['diagnosis:Sex'] for item in result_DS] #需要进行FDR校正，并将校正后的结果存储
        #result_DS_fdr = HWJ(result_DS, alpha = 0.05, method = 'fdr_bh', is_sorted=False, returnsorted=False)[1] #fdr校正

        #result_param_D=[item['diagnosis'] for item in result_param_D]
        #result_D=[item['diagnosis'] for item in result_D]       #需要进行FDR校正，并将校正后的结果存储
        #result_D_fdr = HWJ(result_D, alpha = 0.05, method = 'fdr_bh', is_sorted=False, returnsorted=False)[1]

        result_S=[item['Sex'] for item in result_S]             #需要进行FDR校正，并将校正后的结果存储
        #result_param_S=[item['Sex'] for item in result_param_S]
        #result_S_fdr = HWJ(result_S, alpha = 0.05, method = 'fdr_bh', is_sorted=False, returnsorted=False)[1]  #对P-value进行校正
       
        print(result_S)
        print(result_param_S)    
        #print(result_DS_fdr)
        #print(result_D_fdr)
        #print(result_S_fdr)

        #print(len(result_DS_fdr))
        #print(len(result_D_fdr))
        #print(len(result_S_fdr))

        #result_df.insert(len(result_df.keys()), file+'DS_pvalue', result_DS_fdr) 
        #result_df.insert(len(result_df.keys()), file+'DS_param', result_param_DS) 
        
        #result_df.insert(len(result_df.keys()), file+'D_pvalue', result_D_fdr) 
        #result_df.insert(len(result_df.keys()), file+'D_param', result_param_D) 

        result_df.insert(len(result_df.keys()), file+'S_pvalue', result_S) 
        #result_df.insert(len(result_df.keys()), file+'S_param', result_param_S) 
result_df.to_excel('Non_Global_Dosen160_NC_Sex_Network_t_df_difference_站点当作哑变量.xlsx', index=False) 