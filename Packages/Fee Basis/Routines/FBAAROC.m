FBAAROC ;AISC/GRR-ENTER/EDIT REPORT OF CONTACT ;06JUL86
 ;;3.5;FEE BASIS;;JAN 30, 1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
2 W !! S DIC="^DPT(",DIC(0)="QEAZM" D ^DIC G Q:Y<0!(X="")!(X="^") S FBDA=+Y
ENT ;
 I '$D(^FBAAA(FBDA)) K DD,DO S DIC="^FBAAA(",DIC(0)="LQ",DLAYGO=161,(X,DINUM)=FBDA D FILE^DICN S FBDA=+Y
 I '$D(^FBAAA(FBDA,2,0)) S ^FBAAA(FBDA,2,0)="^161.02D^^"
 S DA=FBDA
 I $D(DA) S DIE="^FBAAA(",DR="[FBAA REPORT OF CONTACT]" D ^DIE G 2:'$D(FBD1),2:$D(Y)'=0
 I '$D(^FBAAA(FBDA,2,FBD1,0)) K DIE,DR G 2
 D SITEP^FBAAUTL G:FBPOP Q S SITE=$P(FBSITE(0),"^",1),ROC=FBD1,DFN=FBDA
PRINT S DIR(0)="Y",DIR("A")="Want to print this Report of Contact",DIR("B")="NO" D ^DIR K DIR G:$D(DIRUT)!'Y 2
 S VAR="DFN^ROC^SITE",VAL=DFN_"^"_ROC_"^"_SITE,PGM="START^FBAAPRC" D ZIS^FBAAUTL G 2:FBPOP
 D START^FBAAPRC G 2
Q K DAT,FBDA,FBD1,D0,D1,DA,DFN,DI,DIC,DIE,DIRUT,DR,DQ,DWLW,J,X,Y,F,FBCOUNTY,FBDX,I,PGM,PI,T,VAL,VAR,Z,ZZ,ROC,SITE,DFN,FBSITE,FBDAT
 D CLOSE^FBAAUTL Q