LBRVCON3 ;SSI/ALA/KMB/JSR - STEPS 6 AND 7 [ 07/06/2000  3:35 PM ]
 ;;2.5;Library;**3,8**;APR 19, 2000
EN I '$D(^XTMP("LBRY",LBRVSTA,"ODA6","DONE")) D STP6 S ^XTMP("LBRY",LBRVSTA,"ODA6","DONE")=""
 I '$D(^XTMP("LBRY",LBRVSTA,"ODA7","DONE")) D STP7 S ^XTMP("LBRY",LBRVSTA,"ODA7","DONE")=""
 S ^XTMP("LBRY",LBRVSTA,"DONE")=$H
 Q
STP6 S ODA=$P(^XTMP("LBRY",LBRVSTA,"ODA6"),"^",1)
 D MES^LBRPUTL("I am beginning Step 6....for "_LBRVSTA_" at "_$$HTE^XLFDT($H)_"  please wait ")
 F I="AC","B","C","D","E" K ^LBRY(681,I)
 S $P(^LBRY(681,0),"^",3)=1,$P(^LBRY(682,0),"^",3)=1
GDA6 S ODA=$O(^A7RLBRY(LBRVSTA,681,ODA)) Q:ODA'>0
 S USR=$P($G(^A7RLBRY(LBRVSTA,681,ODA,1)),U,3)
 I USR'="" D
 . S USR=$$STRIP^XLFSTR(USR,"*")
 . S USRN=$O(^VA(200,"B",USR,""))
 . I USRN'="" S $P(^A7RLBRY(LBRVSTA,681,ODA,1),U,3)=USRN
 S VND=$P($G(^A7RLBRY(LBRVSTA,681,ODA,1)),U,5)
 I VND'="" D
 . S VND=$$STRIP^XLFSTR(VND,"*") ; PER INTEGRATION TEAM REQUEST
 . S VNDN=$O(^PRC(440,"B",VND,""))
 . I VNDN'="" S $P(^A7RLBRY(LBRVSTA,681,ODA,1),U,5)=VND
MNDA ;  Get next available DA
 S DINUM=$P(^LBRY(681,0),"^",3)
MNDRET F  S DINUM=DINUM+1 Q:'$D(^LBRY(681,DINUM,0))
 S X=DINUM,DLAYGO=681,DIC(0)="L",DIC="^LBRY(681,"
 D FILE^DICN S (DA,NDA)=+Y
 I NDA=-1 S DINUM=X G MNDRET
 S %X="^A7RLBRY(LBRVSTA,681,"_ODA_",",%Y="^LBRY(681,"_NDA_"," D %XY^%RCR
 F I="AC","B" K ^LBRY(681,NDA,2,I)
 S $P(^LBRY(681,NDA,2,0),"^",2)="681.02IPA"
 S $P(^LBRY(681,NDA,0),U)=NDA
 F  S TDA=$O(^A7RLBRY(LBRVSTA,682,"ZC",ODA,TDA)) Q:TDA=""  D
 . S TDA1="" F  S TDA1=$O(^A7RLBRY(LBRVSTA,682,"ZC",ODA,TDA,TDA1)) Q:TDA1=""  D
 .. S $P(^A7RLBRY(LBRVSTA,682,TDA,4,TDA1,0),U,3)=NDA
 .. K ^A7RLBRY(LBRVSTA,682,"ZC",ODA,TDA,TDA1)
 S $P(^XTMP("LBRY",LBRVSTA,"ODA6"),"^",1)=ODA G GDA6
STP7 S ODA=$P(^XTMP("LBRY",LBRVSTA,"ODA7"),"^",1)
 D MES^LBRPUTL("I am beginning Step 7....for "_LBRVSTA_" at "_$$HTE^XLFDT($H)_"  please wait ")
GDA7 S ODA=$O(^A7RLBRY(LBRVSTA,682,ODA)) Q:'ODA
 S FLAG=""
 S:ODA?.N FLAG="Y"
 Q:FLAG=""
 S USR=$P($G(^A7RLBRY(LBRVSTA,682,ODA,1)),U,6)
 I USR'="" D
 . S USR=$$STRIP^XLFSTR(USR,"*")
 . Q:USR=""
 . S USRN=$O(^VA(200,"B",USR,""))
 . I USRN'="" S $P(^A7RLBRY(LBRVSTA,682,ODA,1),U,6)=USRN
 S LDA=0 F  S LDA=$O(^A7RLBRY(LBRVSTA,682,ODA,4,LDA)) Q:LDA'>0  D
 . S USR=$P($G(^A7RLBRY(LBRVSTA,682,ODA,4,LDA,0)),U,4)
 . ;Q:USR=""
 . I USR'="" D
 . . S USR=$$STRIP^XLFSTR(USR,"*")
 . . Q:USR=""
 . . S USRN=$O(^VA(200,"B",USR,""))
 . . I USRN'="" S $P(^A7RLBRY(LBRVSTA,682,ODA,4,LDA,0),U,4)=USRN
 . S USR=$P($G(^A7RLBRY(LBRVSTA,682,ODA,4,LDA,0)),U,8)
 . I USR'="" D
 . .  S USR=$$STRIP^XLFSTR(USR,"*")
 . .  Q:USR=""
 . .  S USRN=$O(^VA(200,"B",USR,""))
 . .  I USRN'="" S $P(^A7RLBRY(LBRVSTA,682,ODA,4,LDA,0),U,8)=USRN
NNDA ;  Get next available DA
 S DINUM=$P(^LBRY(682,0),"^",3)
RET F  S DINUM=DINUM+1 Q:'$D(^LBRY(682,DINUM,0))
 S X=DINUM,DLAYGO=682,DIC(0)="L",DIC="^LBRY(682,"
 D FILE^DICN S (DA,NDA)=+Y
 I NDA=-1 S DINUM=X G RET
 Q:'ODA
 S %X="^A7RLBRY(LBRVSTA,682,"_ODA_",",%Y="^LBRY(682,"_NDA_"," D %XY^%RCR
 K ^LBRY(682,NDA,4,"B")
 S LBRYINT=1
 S $P(^LBRY(682,NDA,0),U)=NDA D ^LBRYX33
 S $P(^XTMP("LBRY",LBRVSTA,"ODA7"),"^",1)=ODA G GDA7