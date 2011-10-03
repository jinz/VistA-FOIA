ORY36 ;SLC/MKB-Postinit for patch OR*3*36 ;10/9/98  15:10
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**36**;Dec 17, 1997
 ;
EN ; -- start here
 D LOC,EXP,NOTIF
 Q
 ;
LOC ; -- Add ORC NEW LOCATION to ORC HIDDEN ACTIONS
 ;
 N XQORM,ORBLANK,ORLOC,DA,DR,DIE,X,Y,ORSL
 S ORBLANK=+$O(^ORD(101,"B","ORB BLANK LINE4",0)) Q:ORBLANK'>0
 S ORLOC=+$O(^ORD(101,"B","ORC NEW LOCATION",0)) Q:ORLOC'>0
 S XQORM=+$O(^ORD(101,"B","ORC HIDDEN ACTIONS",0)) Q:XQORM'>0
 S DA=$O(^ORD(101,"AD",ORBLANK,XQORM,0)) Q:DA'>0  ;already replaced
 S DR=".01////"_ORLOC_";2///LOC;3///36;5///@;6///Change Ordering Info"
 S DA(1)=XQORM,DIE="^ORD(101,"_DA(1)_",10," D ^DIE
 S ORSL=+$O(^ORD(101,"B","ORC SEARCH LIST",0)) Q:ORSL'>0
 S DA=$O(^ORD(101,"AD",ORSL,XQORM,0)) Q:DA'>0
 S DA(1)=XQORM,DR="3///28" D ^DIE ;switch seq#
 S XQORM=XQORM_";ORD(101," D XREF^XQORM ;rebuild ^XUTL
 Q
 ;
EXP ; -- Add Edit action to Expiring Orders menu
 ;
 N ORMENU,X,Y,DIC,DA
 S ORMENU=+$O(^ORD(101,"B","ORCB EXPIRING MENU",0)) Q:ORMENU'>0
 S X=+$O(^ORD(101,"B","ORC CHANGE ORDERS",0)) Q:X'>0
 Q:$O(^ORD(101,"AD",X,ORMENU,0))  ;already added
 S DIC="^ORD(101,"_ORMENU_",10,",DIC(0)="LX",DA(1)=ORMENU
 S DIC("P")=$P(^DD(101,10,0),U,2),DIC("DR")="3///22"
 S X="ORC CHANGE ORDERS" D ^DIC
 Q
 ;
NOTIF ; -- Add Remove Alert action to follow-up menu
 ;
 N ORMENU,X,Y,DIC,DIE,DA,DR,ORI,ITM
 S ORMENU=+$O(^ORD(101,"B","ORCB NOTIFICATIONS",0)) Q:ORMENU'>0
 S X=+$O(^ORD(101,"B","ORCB DELETE ALERT",0)) Q:X'>0
 Q:$O(^ORD(101,"AD",X,ORMENU,0))  ;already done
 S DIE="^ORD(101,",DA=ORMENU,DR="41///40" D ^DIE K DA,DR,DIE
 S DIC="^ORD(101,"_ORMENU_",10,",DIC(0)="LX",DA(1)=ORMENU
 S DIC("P")=$P(^DD(101,10,0),U,2),DIC("DR")="2///RM;3///21"
 S X="ORCB DELETE ALERT" D ^DIC
 ; -- resequence menu items
 S DIE=DIC F ORI=1:1 S X=$T(ITEMS+ORI) Q:X["ZZZZZ"  D
 . S ITM=+$O(^ORD(101,"B",$P(X,";",3),0)),DA=+$O(^ORD(101,ORMENU,10,"B",ITM,0)) Q:DA'>0
 . S DR="3///"_$P(X,";",4) D ^DIE
 Q
 ;
ITEMS ;;NAME;SEQ#
 ;;ORC PREVIOUS SCREEN;12
 ;;ORB BLANK LINE1;13
 ;;VALM QUIT;22
 ;;ORB BLANK LINE2;23
 ;;ZZZZZ