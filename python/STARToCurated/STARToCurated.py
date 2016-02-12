'''
Created on Feb 12, 2016

@author: kumaran
'''
import psycopg2,sys
sys.path.append('/home/kumaran/git/bmrb/python/Metabolomics/StarParser/parser')
import bmrb
class BMRBDB(object):
    '''
    classdocs
    '''


    def __init__(self, dbname,user,host):
        '''
        Constructor
        '''
        #self.conn=psycopg2.connect("dbname=%s user=%s host=%s"%(dbname,user,host))
    
    def getSTARTdata(self,bmrbid):
        self.starData=bmrb.entry.fromDatabase(bmrbid)
        print self.starData['entry_information']['_Entry_author']
    
    def close(self):
        self.conn.close()
       
    
    def load_country_table(self):
        cur=self.conn.cursor()
        dat=open('../../country.txt','r').read().split("\n")[:-1]
        for country in dat:
            cmd="insert into \"Country\" values(DEFAULT,\'%s\');"%(country)
            cur.execute(cmd)
            self.conn.commit()
        cur.close()
        
    def list_table(self,table_name):
        self.cur1=self.conn.cursor()
        cmd="select * from \"%s\" ;"%(table_name)
        self.cur1.execute(cmd)
        for i in self.cur1.fetchall():
            print i
        self.cur1.close()
        
        








if __name__=="__main__":
    #p=BMRBDB('bmrb','web','manta.bmrb.wisc.edu')
    p=BMRBDB('bmrb','nmr','localhost')
    #p.load_country_table()
    #p.close()
    p.getSTARTdata(15060)