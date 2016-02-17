'''
Created on Feb 12, 2016

@author: kumaran
'''
import psycopg2,sys
from lxml.html.defs import table_tags
sys.path.append('/home/kumaran/git/STARParser/python')
import bmrb,re
class BMRBDB(object):
    '''
    classdocs
    '''


    def __init__(self, dbname,user,host):
        '''
        Constructor
        '''
        bmrb.raise_parse_warnings = False
        self.conn=psycopg2.connect("dbname=%s user=%s host=%s"%(dbname,user,host))
        self.mapping=dat=open('../../StarToCuratedMapping.csv','r').read()
    
    def entry(self,bmrbid):
        self.bmrbid=bmrbid
        try:
            self.starData=bmrb.entry.fromDatabase(self.bmrbid)
        except IOError:
            self.starData = None
    def table(self,table_name,primary_key,foreign_key=None):
        self.table_name=table_name
        self.pk=primary_key
        self.fk=foreign_key
        dict=re.findall('%s,(\S+),(\S+),([\Ss]*)'%(self.table_name),self.mapping)
        self.table_dict={}
        for i in dict:
            if i[1] not in ['serial','??']:
                self.table_dict.update({i[1]:i[0]})
        
    
   
        
    
    def find_ID(self,table,column_value,id):
        cmd="select \"%s\" from \"%s\" where "%(id,table)
        for cv in column_value[:-1]:
            cmd="%s \"%s\" = \'%s\' and "%(cmd,cv[0],cv[1])
        cmd="%s \"%s\" = \'%s\';"%(cmd,column_value[-1][0],column_value[-1][1])
        cur1=self.conn.cursor()
        cur1.execute(cmd)
        outdat=[i[0] for i in cur1.fetchall()]
        cur1.close()
        return outdat
        
    def insert_into(self,table,col_val,serial_id):
        cmd="insert into \"%s\" (\"%s\","%(table,serial_id)
        for i in col_val[:-1]:
            cmd="%s \"%s\","%(cmd,i[0])
        cmd="%s \"%s\") values (DEFAULT,"%(cmd,col_val[-1][0])
        for i in col_val[:-1]:
            cmd="%s \'%s\',"%(cmd,i[1])
        cmd="%s \'%s\');"%(cmd,col_val[-1][1])
        cur2=self.conn.cursor()
        cur2.execute(cmd)
        self.conn.commit()
        
        
    
    def close(self):
        self.conn.close()
        
    def get_dict(self,table):
        dict=re.findall('%s,(\S+),(\S+),([\Ss]*)'%(table),self.mapping)
        out_dict={}
        for i in dict:
            if i[1] not in ['serial','??']:
                out_dict.update({i[1]:i[0]})
        return out_dict
    
    def get_table_row(self,table):
        table_dict=self.get_dict(table)
        cv=[]
        if self.starData is not None:
            for tag in table_dict.keys():
                try:
                    tag_value=self.starData.getTag(tag)
                except ValueError:
                    tag_value=['.']
                if len(tag_value)>1:
                    print "STAR tag contains multiple value"
                elif len(tag_value)==1 :#and tag_value[0]!=".":
                    tag_value[0]=re.sub("'","''",tag_value[0]) # problem with single cote
                    cv.append((table_dict[tag],tag_value[0]))
                else:
                    pass
        return cv
            
    def get_FK(self,table,table_id):
        cv=self.get_table_row(table)
        print cv
        if len(cv)>0:
            fk=self.find_ID(table, cv, table_id)
        else:
            fk=[]
        return fk
        
    
    def load_table(self,table,table_id):
        self.table_dict=self.get_dict(table)
        fk=self.get_FK(table, table_id)
        try:
            self.starData=bmrb.entry.fromDatabase(self.bmrbid)
            self.cv=[]
            for tag in self.table_dict.keys():
                try:
                    tag_value=self.starData.getTag(tag)
                except ValueError:
                    pass
                print tag,tag_value
                if len(tag_value)>1:
                    print "STAR tag contains multiple value"
                elif len(tag_value)==1 and tag_value[0]!=".":
                    tag_value[0]=re.sub("'","''",tag_value[0]) # problem with single cote
                    self.cv.append((self.table_dict[tag],tag_value[0]))
                else:
                    pass
            print self.cv
            if len(self.cv)>0:
                if len(self.find_ID(table, self.cv, table_id))==0:
                    self.insert_into(table, self.cv, table_id)
                    print "%s table loaded for entry %s"%(table,bmrbid)
                else:
                    print "%s table entry already exists for %s "%(table,bmrbid)
            else:
                print "No information in the entry %s for the table %s "%(bmrbid,table)
        except IOError:
            print "%s does not exists"%(bmrbid)
        
    def load_table_Entry(self,bmrbid):
        dat=open('../../StarToCuratedMapping.csv','r').read()
        Entry_dict=self.get_dict('Entry')
        try:
            self.starData=bmrb.entry.fromDatabase(bmrbid)
            cv=[]
            for tag in Entry_dict.keys():
                try:
                    tag_value=self.starData.getTag(tag)
                except ValueError:
                    pass
                    
                if len(tag_value)>1:
                    print "Problem"
                elif len(tag_value)==1 and tag_value[0]!=".":
                    tag_value[0]=re.sub("'","''",tag_value[0]) # problem with single cote
                    cv.append((Entry_dict[tag],tag_value[0]))
                else:
                    pass
            if len(self.find_ID('Entry', cv, 'DB_Entry_ID'))==0:
                self.insert_into('Entry', cv, 'DB_Entry_ID')
                print "%s data loaded"%(bmrbid)
            else:
                print "Data for %s already exists"%(bmrbid)
            
        except IOError:
            print "%s does not exists"%(bmrbid)
    def load_table_Country(self):
        cur=self.conn.cursor()
        dat=open('../../country.txt','r').read().split("\n")[:-1]
        for country in dat:
            if len(self.find_ID('Country', [('Name', country)],'DB_Country_ID'))==0:
                cmd="insert into \"Country\" values(DEFAULT,\'%s\');"%(country)
                cur.execute(cmd)
                self.conn.commit()
            else:
                print country," already exists"
        cur.close()
        
        
    def list_table(self,table_name):
        self.cur1=self.conn.cursor()
        cmd="select * from \"%s\" ;"%(table_name)
        self.cur1.execute(cmd)
        for i in self.cur1.fetchall():
            print i
        self.cur1.close()
        
    
        

class Curated_Table(object):
    
    def __init__(self,bmrbid,table_name,primary_key=None,foreign_key=None):
        self.bmrbid=bmrbid
        bmrb.raise_parse_warnings = False
        try:
            self.starData=bmrb.entry.fromDatabase(self.bmrbid)
        except IOError:
            self.starData = None
        self.conn=psycopg2.connect("dbname=%s user=%s host=%s"%('bmrb','nmr','localhost'))
        self.mapping=dat=open('../../StarToCuratedMapping.csv','r').read()
        self.table=table_name
        if primary_key is None:
            self.primary_key="DB_%s_ID"%(self.table)
        else:
            self.primary_key=primary_key
        self.foreign_key=foreign_key
        self.mapping=dat=open('../../StarToCuratedMapping.csv','r').read()
        self.get_dict()
        self.get_row_value()
        

    def get_dict(self):
        dict=re.findall('%s,(\S+),(\S+),([\Ss]*)'%(self.table),self.mapping)
        self.table_dict={}
        for i in dict:
            if i[1] not in ['serial','??']:
                self.table_dict.update({i[1]:i[0]})
        

    def get_row_value(self):
        self.row=[]
        if self.foreign_key is not None:
            for fkk in self.foreign_key:
                if fkk[1] is not None:
                    self.row.append(fkk)
        if self.starData is not None:
            for tag in self.table_dict.keys():
                try:
                    #print tag
                    tag_value=self.starData.getTag(tag)
                except ValueError:
                    tag_value=['.']
                if len(tag_value)>1:
                    print "STAR tag contains multiple value"
                elif len(tag_value)==1 :#and tag_value[0]!=".":
                    tag_value[0]=re.sub("'","''",tag_value[0]) # problem with single cote
                    if 'date' in tag and tag_value[0]!='.':
                        self.row.append((self.table_dict[tag],tag_value[0]))
                    elif 'date' not in tag:
                        self.row.append((self.table_dict[tag],tag_value[0]))
                else:
                    pass

    def insert_row(self):
        self.check_row()
        print self.row
        if not self.rowExist:
            cmd="insert into \"%s\" (\"%s\","%(self.table,self.primary_key)
            for i in self.row[:-1]:
                cmd="%s \"%s\","%(cmd,i[0])
            cmd="%s \"%s\") values (DEFAULT,"%(cmd,self.row[-1][0])
            for i in self.row[:-1]:
                cmd="%s \'%s\',"%(cmd,i[1])
            cmd="%s \'%s\');"%(cmd,self.row[-1][1])
            cur2=self.conn.cursor()
            cur2.execute(cmd)
            self.conn.commit()
            print "Row inserted in to  table %s for the entry %s"%(self.table,self.bmrbid)
        else:
            print "Row already exists in table %s for the entry %s"%(self.table,self.bmrbid)
        self.get_id(self.primary_key)
    
    def insert_row2(self):
        self.check_row()
        print self.row
        if not self.rowExist:
            cmd="insert into \"%s\" ("%(self.table)
            for i in self.row[:-1]:
                cmd="%s \"%s\","%(cmd,i[0])
            cmd="%s \"%s\") values ("%(cmd,self.row[-1][0])
            for i in self.row[:-1]:
                cmd="%s \'%s\',"%(cmd,i[1])
            cmd="%s \'%s\');"%(cmd,self.row[-1][1])
            cur2=self.conn.cursor()
            cur2.execute(cmd)
            self.conn.commit()
            print "Row inserted in to  table %s for the entry %s"%(self.table,self.bmrbid)
        else:
            print "Row already exists in table %s for the entry %s"%(self.table,self.bmrbid)
        #self.get_id(self.primary_key)    
        
    def check_row(self):
        self.get_row_value()
        cmd="select count(*) from \"%s\" where "%(self.table)
        #print self.row,self.table,self.bmrbid
        if len(self.row)>0:
            for cv in self.row[:-1]:
                cmd="%s \"%s\" = \'%s\' and "%(cmd,cv[0],cv[1])
            cmd="%s \"%s\" = \'%s\';"%(cmd,self.row[-1][0],self.row[-1][1])
            cur1=self.conn.cursor()
            cur1.execute(cmd)
            outdat=[i[0] for i in cur1.fetchall()]
            cur1.close()
            #print outdat[0]
            if outdat[0]>0:
                self.rowExist=True
            else:
                self.rowExist=False
        else:
            self.rowExist=False
        return self.rowExist
        
    def get_id(self,id):
        self.get_row_value()
        cmd="select \"%s\" from \"%s\" where "%(id,self.table)
        if len(self.row)>0:
            for cv in self.row[:-1]:
                cmd="%s \"%s\" = \'%s\' and "%(cmd,cv[0],cv[1])
            cmd="%s \"%s\" = \'%s\';"%(cmd,self.row[-1][0],self.row[-1][1])
            cur1=self.conn.cursor()
            cur1.execute(cmd)
            outdat=[i[0] for i in cur1.fetchall()]
            cur1.close()
            self.id=outdat[0]
        else:
            self.id=None
        

if __name__=="__main__":
    #p=BMRBDB('bmrb','web','manta.bmrb.wisc.edu')
    #p=BMRBDB('bmrb','nmr','localhost')
    #p.load_table_Country()
    #p.load_table_Entry('16790')
    bmrbid='15060'
    Document=Curated_Table(bmrbid,'Document','DB_Doc_ID')
    Document.insert_row()
    Entry=Curated_Table(bmrbid,'Entry','DB_Entry_ID',[('DB_Doc_ID',Document.id)])
    Entry.insert_row()
    Journal=Curated_Table(bmrbid,'Journal')
    Journal.insert_row()
    Journal_paper=Curated_Table(bmrbid,"Journal_paper",None,[('DB_Doc_ID',Document.id),('DB_Journal_ID',Journal.id)])
    Journal_paper.insert_row2()
    Chem_comp=callable(bmrbid,'Chem_comp')
    #test=Curated_Table('15060','Document','DB_Doc_ID',[('DB_Doc_ID',Document.id)])
    #print test.table_dict
    #test.get_id(ent.primary_key)
    #test.insert_row()

    
#     for i in range(495,496):
#         p=BMRBDB('bmrb','nmr','localhost','%s'%(i))
#         p.get_FK("Organism", "DB_Organism_ID")
#         #p.load_table_Entry('%d'%(i))
#         p.close()
#     #p.getSTARTdata(15060)