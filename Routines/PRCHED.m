PRCHED ;WISC/RHD,AKS-EDIT ROUTINES FOR SUPPLY SYSTEM--LOG CODE SHEETS ;10/30/92  1:55 PM
V ;;5.1;IFCAP;;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
EN1 ;CREATE ISSUE REQUEST LOG CODE SHEETS
 D ST
EN01 Q:'$D(PRC("SITE"))  S DIC="^PRC(443,",DIC(0)="AEQMZ",DIC("A")="Select TRANSACTION NUMBER: "
 S DIC("S")="I $P(^(0),U,3)]"""",$D(^PRCS(410,+Y,0)),+^(0)=PRC(""SITE""),$P(^(0),U,2)=""O"",$P(^(0),U,4)=5,$D(^(""IT"",""AB""))" D ^DIC K DIC G:Y'>0 Q S PRCHR=+Y
 ;
EN11 ;ENTRY POINT IF CALLED
 I $D(^PRCS(410,PRCHR,100)),$P(^(100),U,5)]"" D ERR G EN01
 ;LOOP THRU ITEMS TO FIND NSN'S
 F PRCHIT=0:0 S PRCHIT=$O(^PRCS(410,PRCHR,"IT",PRCHIT)) Q:'PRCHIT  I ^(PRCHIT,0) S PRCHPRN=$P(^(0),U,5) I 'PRCHPRN W !!,$C(7),"There is no Repetitive (PR Card) Number for Line Item # "_$P(^(0),U,1)_".",!!?16,"** CANNOT CONTINUE! **" K PRCHR Q
 G:'$D(PRCHR) Q
 S PRCHTYP="I",PRCHKEY=$P(^PRCS(410,PRCHR,0),U,1) W !!!
 S PRCFA("DICS")="I Y=661!(Y=662)!(Y=663)!(Y=666)!(Y=671)!(Y=669)"
 K PRCFA("TTF") S PRCFA("TT")=663 D GT G:'% EN01
 S PRCHCP=+$P(PRCHKEY,"-",4),PRCHCP=$S($L(PRCHCP)=2:"0"_PRCHCP,1:PRCHCP)
 I '$D(^PRC(420,PRC("SITE"),1,+PRCHCP,0)) S PRCHCP="ER" G Q
 S PRCHCPN=+PRCHCP
 I $L(PRCHCP)'=3 S PRCHCP=$S($P(^PRC(420,PRC("SITE"),1,+PRCHCP,0),U,12)=1:"GPF",$P(^(0),U,12)=3:"",1:"ER") G Q:PRCHCP="ER"
 I PRCHCP="" D CP
 ;S PRCHDPT=$S($D(^PRC(420,PRC("SITE"),1,PRCHCPN,0)):$P($P(^(0),U,18)," ",1),1:"")
 S PRCHDPT=$P($P($G(^PRC(420,PRC("SITE"),1,PRCHCPN,0)),U,18)," ",1)
 I PRCHDPT="" W !!,$C(7),"THIS CONTROL POINT HAS NO LOG DEPT #, YOU CANNOT PROCEED!" G Q
 D EDIT G:'$D(^PRCS(410,DA,100)) EN01 S X=^(100) I $P(X,U,1)=""!($P(X,U,3)="")!($P(X,U,8)="") W $C(7),!!,"YOU MUST FILL IN ALL THIS DATA TO GENERATE THE LOG CODE SHEETS!!" G EN01
 D EN^PRCHCS6,^PRCHCS3
 G EN01
 ;
Q I $D(PRCHCP) W:PRCHCP="ER" !,"THIS IS NOT A VALID CONTROL POINT, YOU CANNOT PROCEED!",$C(7)
 K PRCHCS,PRCHCP,PRCHCPN,PRCHTP,PRCHAMT,PRCHRPT,PRCHRD,PRCHCMI,PRCHFA,PRCHLOG,PRCHDIET,PRCHDPT,PRCHDRD,PRCHDT,PRCHDTP,PRCHKEY,PRCHN,PRCHNM,PRCHREQ,PRCHTYP
 Q
 ;
CP W !!,"This Special Control Point is CASCA/CANTEEN.",!
 ;
C1 R "Select ""OGA"" or ""CTN"": ",PRCHCP:DTIME
 I PRCHCP["^" S PRCHCP="ER" G Q
 S PRCHCP=$S(PRCHCP["O":"OGA",PRCHCP["C":"CTN",1:"")
 I PRCHCP="" W !!,"Enter ""O"" for Other Goverment Agencies, or ""C"" for Canteen.",!! G C1
 Q
 ;
EDIT S PRCHMO=$E(DT,4,5),DIE="^PRCS(410,",DA=PRCHR
 S DR="66//"_PRCHDPT_";57;59//"_$S(PRCHMO="10":"0",PRCHMO="11":"J",PRCHMO="12":"K",1:+PRCHMO)_";I $E(PRCHDPT,1,2)'=""11"" S Y="""";58//"_$S($P(DT,6,7)>15:2,1:2) D ^DIE
 S:$D(^PRCS(410,DA,100)) PRCHDPT=$P(^(100),U,8)
 Q
 ;
ST S PRCF("X")="S" D ^PRCFSITE
 Q
 ;
GT S PRCHLOG=1 D TT^PRCFAC Q:'%  S PRCFA("TTF")=PRCFA("TT")
 K PRCHTP S PRCHTP(1)="410,"_PRCHR_",^PRCS(410,",PRCHTP(2)="410.02,PRCHLI,^PRCS(410,"_PRCHR_",""IT"","
 Q
 ;
ERR W !?3,"LOG code sheets already created and signed.  Use Edit A Code Sheet option.",$C(7)
 Q