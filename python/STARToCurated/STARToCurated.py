'''
Created on Feb 12, 2016

@author: kumaran
'''
import psycopg2

class BMRBDB(object):
    '''
    classdocs
    '''


    def __init__(self, dbname,user,host):
        '''
        Constructor
        '''
        self.conn=psycopg2.connect("dbname=%s user=%s host=%s"%(dbname,user,host))
    
    def close(self):
        self.conn.close()
       
        
    def list_table(self,table_name):
        self.cur1=self.conn.cursor()
        cmd="select * from \"%s\" ;"%(table_name)
        self.cur1.execute(cmd)
        for i in self.cur1.fetchall():
            print i
        self.cur1.close()
        
        








if __name__=="__main__":
    p=BMRBDB('bmrb','web','manta.bmrb.wisc.edu')
    p.list_table("Entry")
    p.close()