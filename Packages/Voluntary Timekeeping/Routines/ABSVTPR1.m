ABSVTPR1 ;VAMC ALTOONA/CTB - MISC REPORTS MENU ;5/22/97  10:58 AM
V ;;4.0;VOLUNTARY TIMEKEEPING;**3,6,7**;JULY 6, 1994
OUT K %DT,%,%X,B,ABSVX("CREATE"),ABSVX("BDATE"),ABSVX("EDATE"),BDATE,COMB,DA,DA1,DDH,DIC,DIE,DIJ,DIK,DP,DQ,DR,DUOUT,EDATE,MONTH,NN,NAME,ORG,SER,VOL,TC,TC1,TC2,TC3,VOLDA,X,X1,XZ,Y,ZI
 Q
RANGE ;ENTER RANGE OF DATES
 S DIR(0)="DA^2800101:3500101:E",DIR("A")=$S($D(BPROMPT):BPROMPT,1:"Select Beginning Date: ")
 D ^DIR K DIR,BPROMPT
 I $$DIR^ABSVU2 S Y=-1 Q
 S BDATE=$S($D(MONTH):$E(Y,1,5)_"00",1:Y)
 S DIR(0)="DA^"_BDATE_":3500101:E",DIR("A")=$S($D(EPROMPT):EPROMPT,1:"Select Ending Date: "),DIR("B")=$$FULLDAT^ABSVU2(BDATE)
 D ^DIR K DIR,EPROMPT
 I $S($D(DTOUT):1,$D(DUOUT):1,$D(DIRUT):1,$D(DIROUT):1,1:0) K DTOUT,DUOUT,DIRUT,DIROUT S Y=-1 Q
 S EDATE=$S($D(MONTH):$$EOM(Y),1:Y)
 I $D(FULLDAT) S EDATE=EDATE_"^"_$$FULLDAT^ABSVU2(EDATE),BDATE=BDATE_"^"_$$FULLDAT^ABSVU2(BDATE) K FULLDAT
 K DIR,MONTH Q
EOM(X) N MO,DAY,YR
 S YR=$E(X,1,3)+1700,MO=$E(X,4,5)
 I "01,03,05,07,08,10,12"[MO Q $E(X,1,5)_31
 I "04,06,09,11"[MO Q $E(X,1,5)_30
 I X<1,X>12 Q X
 I YR#4 Q $E(X,1,5)_28
 Q $E(X,1,5)_29
WEEKLY ;PRINT WEEKLY TIME SUMMARY REPORT
 D ^ABSVSITE Q:'%
 S L=0,DIC="^ABS(503331,",(FR,TO)="?",DIS(0)="I $P($G(^ABS(503331,D0,0)),U,7)=ABSV(""SITE"")",(BY,FLDS)="[ABSV WEEKLY WORK SUMMARY]" D EN1^DIP,DIKILL^ABSVQ,OUT
 QUIT
TELLIST ;PRINT TELEPHONE LIST OF VOLUNTEERS
 NEW TYPE
 D ^ABSVSITE Q:'%
 S DIR(0)="S^1:ACTIVE VOLUNTEERS;2:TERMINATED VOLUNTEERS",DIR("A")="Select Telephone List Type"
 S DIR("?")="Select Printout Type.  You may enter an '^' to quit."
 D ^DIR
 K DIR
 I $$DIR^ABSVU2 QUIT
 S TYPE=+Y
 S L=0,DIC="^ABS(503330,",BY=.01,FR="A",TO="zzzz",FLDS=".01;L35,16.9;L20,1;L12"
 D @TYPE
 D EN1^DIP,DIKILL^ABSVQ,OUT
 QUIT
1 ;PRINT LIST OF ACTIVE VOLUNTEERS
 S DIS(0)="I $D(^ABS(503330,D0,4,"_ABSV("INST")_",0)),$P(^(0),U,8)=""""",DHD="VOLUNTEER TELEPHONE LIST - ACTIVE - "_ABSV("SITENAME")
 QUIT
2 ;PRINT LIST OF TERMINATED VOLUNTEERS
 S DIS(0)="I $D(^ABS(503330,D0,4,"_ABSV("INST")_",0)),$P(^(0),U,8)]""""",DHD="VOLUNTEER TELEPHONE LIST - TERMINATED - "_ABSV("SITENAME")
 QUIT
SELSER ;PRINT SELECTED SERVICES
 D ^ABSVSITE Q:'%
 S X="Using this option you may select up to 10 services to print out per session.*" D MSG^ABSVQ W !
 S XZ=1,DIC=503332,DIC(0)="AEMQZ",DIC("A")="Select Service #1: "
 F ZI=1:1 Q:XZ>10  D ^DIC Q:+Y<0  W:'$D(^ABS(503335,"AE",+Y)) !,"THERE ARE NO ENTRIES IN THE TIME CARD FILE FOR THIS SERVICE",*7 I $D(^(+Y)) S ABSVX("LIST",+Y)=$P(Y(0),"^",2),XZ=XZ+1,DIC("A")="Select Service #"_XZ_": "
 K DIC I $D(ABSVX("LIST"))'>9 S X="No Services Selected.*" D MSG^ABSVQ G OUT
 S BPROMPT="Select Beginning Month/Year: ",EPROMPT="Select Ending Month: ",MONTH=""
 W ! D RANGE K MONTH
 G:Y<0 OUT S ABSVX("EDATE")=EDATE,ABSVX("BDATE")=$E(BDATE,1,5)_"00"
 S ZTRTN="SO1^ABSVTPR1",ZTDESC="VOLUNTARY SELECTED SERVICE LISTING",ZTSAVE("ABSV*")="",ZTSAVE("EDATE")="",ZTSAVE("BDATE")="" D ^ABSVQ D OUT Q
SO1 ;DQ SELECTED SERVICE LISTING
 K ^TMP("ABSVSELSERV",$J)
 I '$D(ZTQUEUED) D WAIT^ABSVYN
 S DA=0
 F  S DA=$O(ABSVX("LIST",DA)) Q:'DA  D
  . S N=0
  . F  S N=$O(^ABS(503335,"AE",DA,N)) Q:'N  D
  . . S X=^ABS(503335,N,0)
  . . I $P(X,"^",12)=ABSV("SITE"),$P(X,"^",5)'<BDATE,$P(X,"^",5)'>EDATE S ^TMP("ABSVSELSERV",$J,N)=""
  . . Q
  . Q
 K ABSVX("LIST") I '$D(^TMP("ABSVSELSERV",$J)) S X="No Time Cards Found.*" D:'$D(ZTQUEUED) MSG^ABSVQ D:$D(ZTQUEUED) KILL^%ZTLOAD G OUT
 S IOP=ABIOP
 S L=0,DIC="^ABS(503335,",BY="+#@1.3,+4,.01",(FR,TO)="",FLDS="[ABSV SERVICE LIST]",DHD="VOLUNTEER HOURS BY SERVICE",BY(0)="^TMP(""ABSVSELSERV"",$J,",L(0)=1
 D EN1^DIP,DIKILL^ABSVQ
 K ^TMP("ABSVSELSERV",$J)
 I $D(ZTQUEUED) D KILL^%ZTLOAD Q
 QUIT
OLIST ;PRINT SUMMARY ORG REPORT FOR OCC HRS
 D ^ABSVSITE Q:'%
 S FULLDAT="" D RANGE Q:Y<1
 S L=0,DIC="^ABS(503336,",FR=+BDATE,TO=+EDATE,DIS(0)="I $P($G(^ABS(503336,D0,0)),U,3)=ABSV(""SITE"")",(BY,FLDS)="[ABSV OCC HRS ORG SUMMARY]"
 S DHD=ABSV("SITENAME")_" - OCCASSIONAL HOURS BY ORGANIZATION - "_$P(BDATE,"^",2)_" THRU "_$P(EDATE,"^",2)
 D EN1^DIP,DIKILL^ABSVQ Q
SLIST ;PRINT SUMMARY SERVICE REPORT
 D ^ABSVSITE Q:'%
 S FULLDAT="" D RANGE Q:Y<1
 S L=0,DIC="^ABS(503336,",FR=+BDATE,TO=+EDATE,DIS(0)="I $P($G(^ABS(503336,D0,0)),U,3)=ABSV(""SITE"")",(BY,FLDS)="[ABSV OCC HRS SERV SUMMARY]"
 S DHD=ABSV("SITENAME")_" - OCCASSIONAL HOURS BY SERVICE - "_$P(BDATE,"^",2)_" THRU "_$P(EDATE,"^",2)
 D EN1^DIP,DIKILL^ABSVQ,OUT
 QUIT
OCCSUM ;PRINT OCCASSIONAL HRS SUMMARY
 D ^ABSVSITE Q:'%
 S FULLDAT="" D RANGE Q:Y<1
 S L=0,DIC="^ABS(503336,",FR=+BDATE,TO=+EDATE,DIS(0)="I $P($G(^ABS(503336,D0,0)),U,3)=ABSV(""SITE"")",(BY,FLDS)="[ABSV OCC HRS SUMMARY]"
 S DHD=ABSV("SITENAME")_" - OCCASSIONAL HOURS REPORT - "_$P(BDATE,"^",2)_" THRU "_$P(EDATE,"^",2)
 D EN1^DIP,DIKILL^ABSVQ,OUT
 QUIT