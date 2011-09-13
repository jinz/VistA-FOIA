PRCADR ;SF-ISC/YJK-PRINT ADDRESS,TRANS.,BALANCE ;9/13/96  11:54 AM [ 02/24/97  12:17 PM ]
V ;;4.5;Accounts Receivable;**21,45,108,141,241**;Mar 20, 1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;print debtor's 3rd party address,transaction,balances.
EN1 ;PRINT ADDRESS, SOCIAL SECURITY NUMBER AND DATE OF BIRTH.
 N RCDMC,RCTOP,RCKAT
 K PRCAGL D EN11 Q:'$D(PRCAGL)  D WR1^PRCADR2
 I $D(^PRCA(430,D0,8)),$P(^(8),U,7)["N" W !,"* UNABLE TO LOCATE *"
 D END1 Q
EN11 Q:'$D(D0)  S Z0=$S($P(^PRCA(430,D0,0),U,9)'="":$P(^(0),U,9),1:"") Q:Z0=""
EN12 S PRCADB=$P(^RCD(340,Z0,0),"^"),RCDMC=$D(^RCD(340,"DMC",1,Z0)),RCTOP=$D(^RCD(340,"TOP",Z0))
 S X=$$DADD^RCAMADD(PRCADB) S $P(PRCAGL,"^",1,6)=$P(X,"^",1,6),$P(PRCAGL,"^",9)=$P(X,"^",7) K PRCADB
 S Z1=$P(^RCD(340,Z0,0),";",1),Z2=$P($P(^(0),"^"),";",2),PRCASTE=$P(PRCAGL,U,5)
 S (PRCASSN,PRCADOB)="" I '$D(^VA(200,Z1,0)),'$D(^DPT(Z1,0)) Q
 S DFN=Z1 D DEM^VADPT I VAERR K VAERR Q
 S PRCASSN=$S(Z2["VA(200":$P(^VA(200,Z1,1),U,9),1:"")
 I Z2["DPT(" S DFN=Z1 D DEM^VADPT S PRCASSN=$P(VADM(2),"^",2)
 S RCKAT="" I $$EMGRES^DGUTL(DFN)["K" S RCKAT=1
 S PRCASSN=$S((PRCASSN["-")!($L(PRCASSN)>9):PRCASSN,1:$E(PRCASSN,1,3)_"-"_$E(PRCASSN,4,5)_"-"_$E(PRCASSN,6,9))
 S PRCADOB=$S(Z2["VA(200":$P(^VA(200,Z1,1),U,3),Z2["DPT":$P(VADM(3),"^",1),1:"")
 S PRCADOB=$$SLH^RCFN01(PRCADOB) K DFN,VAERR,VADM,Z1,Z2 Q
END1 K %,PRCADOB,PRCASSN,PRCASTE,PRCAGL,Z1,Z2,Z0 Q
EN2 ;prints all transaction type of AR in the Profile of AR.
 Q:'$D(D0)  S PRCAEN=0,PRCAK1=1 K PRCA("WROFF")
 F I=0:0 S PRCAEN=$O(^PRCA(433,"C",D0,PRCAEN)) Q:'PRCAEN  D WR2^PRCADR2 S PRCAK1=PRCAK1+1 I PRCAK1>7 D EN5 Q:$D(PRCA("HALT"))  S PRCAK1=-5
END2 K I,PRCAEN,PRCAK1,PRCAG,% Q  ;end of EN2
EN3 ;Print the balances and paid amount of Principal,Interest and Admin.
PRBAL S (PRCAK("PB"),PRCAK("IB"),PRCAK("AB"),PRCAK("IP"),PRCAK("PP"),PRCAK("AP"),PRCAK("MF"),PRCAK("CC"))=0
 I $D(^PRCA(430,D0,7)) D PRBAL1
 S (PRCAL(1),PRCAL(2),PRCAL(3),PRCAL(4),PRCAL(5),PRCAL(6),PRCACODE)=""
 I $D(^PRCA(430,D0,6)) S PRCAGL6=^(6),PRCAL(1)=$P(PRCAGL6,U,1),PRCAL(2)=$P(PRCAGL6,U,2),PRCAL(3)=$P(PRCAGL6,U,3),PRCAL(4)=$P(PRCAGL6,U,4),PRCACODE=$P(PRCAGL6,U,5),PRCAL(5)=$P(PRCAGL6,U,7),PRCAL(6)=$P(PRCAGL6,U,14)
 S PRCACODE=$S(PRCACODE]"""":PRCACODE,1:"DC/DOJ")
 S PRCALT=PRCAL(1) D LDATE S PRCAL(1)=PRCALT,PRCALT=PRCAL(2) D LDATE S PRCAL(2)=PRCALT,PRCALT=PRCAL(3) D LDATE S PRCAL(3)=PRCALT
 S PRCALT=PRCAL(4) D LDATE S PRCAL(4)=PRCALT,PRCALT=PRCAL(5) D LDATE S PRCAL(5)=PRCALT,PRCALT=PRCAL(6) D LDATE S PRCAL(6)=PRCALT
 D WR3^PRCADR2
END3 K PRCAL,PRCACODE,PRCALT,PRCAGL6,PRCAGL7,PRCAK Q
PRBAL1 S PRCAGL7=^PRCA(430,D0,7),PRCAK("PP")=$P(PRCAGL7,U,7),PRCAK("IP")=$P(PRCAGL7,U,8),PRCAK("AP")=$P(PRCAGL7,U,9)
 S PRCAK("PB")=$P(PRCAGL7,U,1),PRCAK("IB")=$P(PRCAGL7,U,2),PRCAK("AB")=$P(PRCAGL7,U,3),PRCAK("MF")=$P(PRCAGL7,U,4),PRCAK("CC")=$P(PRCAGL7,U,5)
 Q
LDATE Q:PRCALT=""  S PRCALT=$$SLH^RCFN01(PRCALT) Q
EN4 ;Print 3rd party address information.
 Q:'$D(D0)  S Z0=$S($P(^PRCA(430,D0,0),U,9)'="":$P(^(0),U,9),1:"") Q:Z0=""  S PRCADB=$P(^RCD(340,Z0,0),"^") S X=$$DADD^RCAMADD(PRCADB) S $P(PRCAGL,"^",1,6)=$P(X,"^",1,6),$P(PRCAGL,"^",9)=$P(X,"^",7) K PRCADB
 W !,?12,$P(PRCAGL,U) F X=2,3,4 W:$P(PRCAGL,U,X)'="" !,?12,$P(PRCAGL,U,X)
 I $P(PRCAGL,U,5)'="",$P(PRCAGL,U,5)'[" " W ", ",$P(PRCAGL,U,5)," ",$P(PRCAGL,U,6)
 W "      PHONE NO.: ",$P(PRCAGL,U,9)
END4 K %,PRCAGL,Z0 Q
EN5 K PRCA("HALT") Q:'$D(PRCAIO)
 I $E(IOST,1,2)["C-" R !,?8,"ENTER '^' TO HALT:  ",X:$S($D(DTIME):DTIME,1:999) I (X["^")!('$T) S PRCA("HALT")=1 Q
 I $E(IOST,1,2)["C-",$D(IOF) W @IOF
 Q
 ;
SVDT(D0) ;Called from the PRCA 3RD PROFILE print template
 N X S X="IBRFN" X ^%ZOSF("TEST") G SVDTQ:'$T
 S D0=$P($P($G(^PRCA(430,+D0,0)),"^"),"-",2)
 S X=$$SVDT^IBRFN(D0)
 Q X
SVDTQ Q 0