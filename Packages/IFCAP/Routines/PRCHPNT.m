PRCHPNT ;ID/RSD/RHD-PRINT PRE-PRINTED 2138 ;10/2/97  13:33
V ;;5.1;IFCAP;;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 S U="^"
 S PRCH0=$G(^PRC(442,D0,0)),PRCH1=$G(^(1)),PRCH12=$G(^(12)),PRCHSIT=$P(PRCH0,"-",1),PRCHSHP="" Q:PRCH0']""!(PRCH1']"")
 D SJD^PRCHFPNT
 S PRCHFPT=+$G(PRCHFPT),PRCHS=0 I +$P(PRCH0,U,2)'=4 S PRCHSHP=$G(^PRC(411,PRCHSIT,1,+$P(PRCH1,U,3),0))
 ;I '$T,$P(PRCH1,U,12)]"" S PRCHSHP=$S($D(^PRC(440.2,$P(PRCH1,U,12),0)):^(0),1:""),PRCHS=1 I +PRCHSHP>0 S $P(PRCHSHP,U,1)=$S($D(^DPT(+PRCHSHP,0)):$E($P(^(0),U,1),1,21),1:"")
 I '$T,$P(PRCH1,U,12)]"" S PRCHSHP=$G(^PRC(440.2,$P(PRCH1,U,12),0)),PRCHS=1 I +PRCHSHP>0 S $P(PRCHSHP,U,1)=$E($P($G(^DPT(+PRCHSHP,0)),U,1),1,21)
 S PRCHST=$G(^PRC(411,PRCHSIT,0)),PRCHHSP=$G(^(3)),X=+$P(PRCH12,U,6),PRCHINV=$G(^(4,X,0))
 S DIWL=1,DIWR=33,DIWF="",PRCH=0 F I=0:0 S PRCH=$O(^PRC(442,D0,2,PRCH)) Q:PRCH'>0  K ^UTILITY($J,"W") D LC
 S DIWL=1,DIWR=64,DIWF="",PRCH=0 K ^PRC(442,D0,15,9999999) I $D(^PRC(442,D0,11,PRCHFPT,0)),$P(^(0),U,10)="Y" S ^PRC(442,D0,15,9999999,0)=9999999
 F I=0:0 S PRCH=$O(^PRC(442,D0,15,PRCH)) Q:'PRCH  S PRCHI=PRCH,PRCHK=+^(PRCH,0) I $D(^PRC(442.7,PRCHK,0)),$O(^(1,0)) K ^UTILITY($J,"W") D LC1
 I $D(PRCHI),PRCHI,$D(^PRC(442,D0,15,PRCHI,0)) S $P(^(0),U,2)=$P(^(0),U,2)-1
 K PRCHI
 G STP
 ;
LC Q:'$D(^PRC(442,D0,2,PRCH,1,0))  S PRCHJ=0 F  S PRCHJ=$O(^PRC(442,D0,2,PRCH,1,PRCHJ)) Q:PRCHJ=""!(PRCHJ<0)  S X=^(PRCHJ,0) D DIWP^PRCUTL($G(DA))
 S PRCHLC=+^UTILITY($J,"W",1) S:PRCHLC>0 $P(^PRC(442,D0,2,PRCH,2),U,4)=PRCHLC
 Q
 ;
LC1 F PRCHJ=0:0 S PRCHJ=$O(^PRC(442.7,PRCHK,1,PRCHJ)) Q:'PRCHJ  S X=^(PRCHJ,0) D DIWP^PRCUTL($G(DA))
 S PRCHLC=+^UTILITY($J,"W",1) S:PRCHLC>0 $P(^PRC(442,D0,15,PRCH,0),U,2)=PRCHLC+1
 Q
 ;
STP F I=1:1:6 W !
 S:'$D(PRC("SITE")) PRC("SITE")=+PRCH0 D FTYP^PRCHFPNT
 W:PRCHS ?18,$P(PRCHFTYP," ",2,99) W ! W:PRCHS ?2,$P(PRCHHSP,U,1)," ",$P(PRCHHSP,U,2) W ?70,$P(PRCH1,U,11),!
 W:PRCHS ?2,$P(PRCHHSP,U,3),", ",$P($G(^DIC(5,$P(PRCHHSP,U,4),0)),U,2)," ",$P(PRCHHSP,U,5)
 S Y=$G(^DIC(49,+$P(PRCH1,U,2),0)) W ?69,$P(Y,U,1) W:$P(Y,U,8)]"" "(",$P(Y,U,8),")" W !!
 S PRCHV=$G(^PRC(440,+PRCH1,0)) W ?10,$P(PRCHV,U,1) I $P(PRCH0,U,2)=2 W ?69,$E($P($G(^DIC(49,$P(PRCH1,U,2),0)),U,1),1,14)
 W:'$T ?69,$P(PRCHSHP,U,1) W:'PRCHS " ",$P($P(PRCH0,U,1),"-",2)
 S V(1)=$P(PRCHV,U,2),V=2,S=1 S:'PRCHS S(S)=PRCHFTYP,S=S+1
 I $P(PRCHV,U,3)]"" S V(V)=$P(PRCHV,U,3),V=V+1 S:$P(PRCHV,U,4)]"" V(V)=$P(PRCHV,U,4),V=V+1 S:$P(PRCHV,U,5)]"" V(V)=$P(PRCHV,U,5),V=V+1
 ;S V(V)=$S($P(PRCHV,U,6)]"":($P(PRCHV,U,6)_", "),1:"   ")_$S($D(^DIC(5,+$P(PRCHV,U,7),0)):$P(^(0),U,2),1:"")_" "_$P(PRCHV,U,8),V=V+1
 S V(V)=$S($P(PRCHV,U,6)]"":($P(PRCHV,U,6)_", "),1:"   ")_$P($G(^DIC(5,+$P(PRCHV,U,7),0)),U,2)_" "_$P(PRCHV,U,8),V=V+1
 I $D(^PRC(440,+PRCH1,2)) S:$P(^(2),U,1)]"" V(V)="ACCT # "_$P(^(2),U,1),V=V+1 S V(V)=""
 S:$P(PRCHV,U,10)]"" V(V)=$P(PRCHV,U,10) I $P(PRCHST,U,19)="Y",$T,$P($G(^PRC(440,+PRCH1,2)),U,3)]"" S V(V)=V(V)_"    CALM ID: "_$P($G(^(2)),U,3)
 I $P(PRCH1,U,4)="Y" S V(8)=" VERBAL PURCHASE ORDER" S:$P(PRCH1,U,5)="Y" V(8)=" CONFIRMATION COPY, PLEASE DO NOT DUPLICATE"
 S PRCHEDI=$G(^PRC(440,+PRCH1,3)) I PRCHEDI]"",$P(PRCHEDI,U,2)="Y",$P($G(^PRC(442,D0,12)),U,16)'="n" D  S V(8)=PRCHEDIT_" DO NOT MAIL"
 .S PRCHEDIT="",PRCHEDIT=$P($G(^PRC(442,D0,12)),U,14)
 .S PRCHEDIT=$S(PRCHEDIT'="":"*EDI EMERGENCY ORDER-"_$P($G(^PRC(443.4,PRCHEDIT,0)),U)_"*",1:"*EDI ORDER*") Q
 K PRCHEDI,PRCHEDIT
 S:$P(PRCHSHP,U,2)]"" S(S)=$P(PRCHSHP,U,2),S=S+1 S:$P(PRCHSHP,U,3)]"" S(S)=$P(PRCHSHP,U,3),S=S+1 S:$P(PRCHSHP,U,4)]"" S(S)=$P(PRCHSHP,U,4),S=S+1
 S S(S)=$S($P(PRCHSHP,U,5)]"":($P(PRCHSHP,U,5)_", "),1:"   ")_$P($G(^DIC(5,+$P(PRCHSHP,U,6),0)),U,2)_" "_$P(PRCHSHP,U,7),S=S+2
 I $P(PRCHSHP,U,8)]"",'PRCHS S S(S)="DELIVERY HOURS:",S=S+1,S(S)=$P(PRCHSHP,U,8)
 F I=1:1:7 W !?10 W:$D(V(I)) V(I) W:$D(S(I)) ?69,S(I)
 W !?5 W:$D(V(8)) V(8) W:$D(S(8)) ?69,S(8)
 G FOB^PRCHPNT2
 ;
QUE S PRCHQ("DEST")="S9",PRCHQ="STQUE^PRCHPNT1",PRC("SITE")=PRCHSIT,DTIME=1 D ^PRCHQUE
 Q