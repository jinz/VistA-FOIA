LBRYPPR0 ;ISC2/DJM-PREDICTION PATTERN ROUTINE ;[ 06/03/97  5:11 PM ]
 ;;2.5;Library;**2**;Mar 11, 1996
 ;
VI G:LBNM<1 IC S LBY=$P(LBRYPP2,U,4),LBX=+$E(LBJDT,4,5)
 D FIND^LBRYPPR G:LBZ<1 IC
 S LBVOL=$S($D(LBVOL):LBVOL,1:$P(LBJD,U,2)),VOL=$P(LBRYPP2,U)
 G:$E(VOL)="+" VI1
 S LBVOL=$S($P(LBRYPP0,U,2)'["NOVOL":VOL,1:"") G VI2
VI1 S LBVOL=LBVOL+$E(VOL,2,5)
VI2 S LBISS=$S($D(LBISS):LBISS,1:$P(LBJD,U,3)),ISS=$P(LBRYPP2,U,2)
 G:$E(ISS)="+" VI3 S LBISS=ISS G COPY
VI3 S LBISS=LBISS+$E(ISS,2,5) G COPY
IC S LBVOL=$S($D(LBVOL):LBVOL,1:$P(LBJD,U,2))
 S LBISS=$S($D(LBISS):LBISS,1:$P(LBJD,U,3)),ISS=$P(LBRYPP2,U,3)
 G:$E(ISS)="+" IC1 S LBISS=ISS G COPY
IC1 S LBISS=LBISS+$E(ISS,2,5)
COPY S (COPY,CO681)=0
 F  G:CO681>0 FINI S COPY=$O(^LBRY(681,"AC",LBRYLOC,COPY)) G:COPY'>0 BEGIN^LBRYPPR S COPY1=0 D COPY1
COPY1 Q:CO681>0  S COPY1=$O(^LBRY(681,"AC",LBRYLOC,COPY,COPY1)) Q:COPY1'>0  S COPY2=^LBRY(681,COPY1,1),START=$P(COPY2,U,10),STOP=$P(COPY2,U,11) I START="",STOP="" S CO681=CO681+1 G COPY1
 I START]"",STOP="",START-DT<1 S CO681=CO681+1 G COPY1
 I START="",STOP]"",STOP-DT'<0 S CO681=CO681+1 G COPY1
 I START]"",STOP]"",START-DT<1,STOP-DT'<0 S CO681=CO681+1
 G COPY1
FINI I $D(^LBRY(682,"AC",LBRYLOC,LBJDT)) G EXT
 S LBNUM=$P(^LBRY(682,0),U,3) F  S LBNUM=LBNUM+1 Q:'$D(^LBRY(682,LBNUM,0))
 K DO S X=LBNUM,DIC="^LBRY(682,",DIC(0)="LN",DLAYGO=682 D FILE^DICN K DLAYGO
 S DIE=DIC,DA=+Y,DR="[LBRY PREDICT INSERT]" D ^DIE
EXT K LBJDT,LBVOL,LBISS,START,STOP,VOL,ISS,COPY,COPY1,COPY2,CO681,LBX,LBY
 K LBZ,LBRYPP,LBNM,LBA1,LBJD,LBNM,LBRYPP0,LBRYPP1,LBRYPP3,LBRYPP2,LBJDY
 K EMY,LBRYEF1,LBXA,PUD,X1,X2,XZ,LBJDM,LBJDD,LBMOZ,EM,LBEM,YY,LBWKZ
 K NEWWK,NXTWK,FM,WOMLBXA,LBXB,LBY1,LBYA,LBYB,DIC,DIE,DR,LBN
 K LBNUM,LBRYX,WOM,LBRDOW
 Q
