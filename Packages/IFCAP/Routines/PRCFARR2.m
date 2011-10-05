PRCFARR2 ;ISC-SF/TKW-CONT. OF RR FOR TRANSMISSION ;6/20/95  08:46
V ;;5.1;IFCAP;;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
EN S (PRCFI,PRCFL)=0,PRCFJ=8
 N PRCFSWT S PRCFSWT=$P($G(^PRC(442,PRCFPO,11,0)),"^",4)
 I '$D(FED) N FED S FED=0 I "13578"[$P(PRCF1,U,7),$P(PRCF1,U,7)]"" S FED=2
 N BOC,IENFMS,FMSLNO,FMSAMT
ITM ;#8    ITEM NO.,QTY.ORDERED,UNIT OF PURCH.,UNIT COST,TOTAL COST,QTY.RCVD.,$ AMT.RCVD.,NO.OF DESCRIPTIONS,ITEM DESCRIPTION (MULT).
 S PRCFI=$O(^PRC(442,PRCFPO,2,PRCFI)) G SHP^PRCFARR3:'PRCFI,ITM:'$D(^(PRCFI,0)) S PRCFI0=^(0),PRCFI2=$G(^(2)),PRCFI4=$G(^(4))
 ;S PRCFRN=+$O(^PRC(442,PRCFPO,2,"AB",PRCFPRD,PRCFI,0)) K SERIAL
 ;ADDED SO ITEMS NOT RECEIVED ON A PARTIAL NOT SENT ON REPORT
 K SERIAL I PRCFPR=0 G:PRCFSWT>1 ITM
 G ITM:'$D(^PRC(442,PRCFPO,2,PRCFI,3,"AC",PRCFPR))
 S PRCFIEN=$O(^PRC(442,PRCFPO,2,PRCFI,3,"AC",PRCFPR,""))
 G ITM:PRCFIEN="" S PRCFRN0=$G(^PRC(442,PRCFPO,2,PRCFI,3,PRCFIEN,0))
 S X=$P(PRCFI0,"^",2) D FAMT^PRCFARR
 S Y=$P($G(^PRCD(420.5,+$P(PRCFI0,"^",3),0)),"^",1)
 S Z=+$J($P(PRCFI0,"^",9),0,4) S:'$F(Z,".") Z=Z_"."
 S BOC=+$P(PRCFI0,U,4),FMSLNO=""
 S IENFMS=$O(^PRC(442,PRCFPO,22,"B",BOC,""))
 I IENFMS]"" S FMSLNO=$P($G(^PRC(442,PRCFPO,22,IENFMS,0)),U,3)
 S FMSLNO="000"_FMSLNO,FMSLNO=$E(FMSLNO,$L(FMSLNO)-2,$L(FMSLNO))
 S PRCFL=PRCFL+1,PRCFX="8^"_FMSLNO_U_$P(PRCFI2,U,5)_+$P(PRCFI0,U,1)
 S $P(PRCFX,U,5+FED)=X ; Quantity
 S $P(PRCFX,U,6+FED)=Y ; Unit of Purchase
 S $P(PRCFX,U,7+FED)=Z ; Unit Cost
 S X=$P(PRCFI2,U,1) D FAMT^PRCFARR
 S $P(PRCFX,U,8+FED)=X ; Total Cost
 S X=$P(PRCFRN0,"^",2) D FAMT^PRCFARR
 S $P(PRCFX,U,9+FED)=$S(X<0:-X,1:X) ; Quantity Received
 S X=$FN($P(PRCFRN0,U,3)-$P(PRCFRN0,U,5),"",2) D FAMT^PRCFARR
 S $P(PRCFX,U,10+FED)=$S(X<0:-X,1:X) ; Dollar Amt. Rec'd
 S PRCTOT=PRCTOT+X
 S FMSAMT=$P(PRCFRN0,U,3)-$P(PRCFRN0,U,5) S:NET FMSAMT=$FN(FMSAMT*MULT,"",2) ; Take the discount, if any.
 S X=FMSAMT D FAMT^PRCFARR S $P(PRCFX,U,11+FED)=$S(X<0:-X,1:X) ; FMS Dollar Amt.
 S FMSTOT=FMSTOT+X ; Accumulate Document Total
 K ^UTILITY($J,"W") S DIWL=1,DIWR=33,DIWF="",PRCFL1=0,PRCF=0 F PRCFK=0:0 S PRCF=$O(^PRC(442,PRCFPO,2,PRCFI,1,PRCF)) Q:'PRCF  S X=^(PRCF,0),X=$TR(X,U) D DIWP^PRCUTL($G(DA))
 F I=0:0 S I=$O(^UTILITY($J,"W",1,I)) Q:'I  I $D(^(I,0)) S PRCFL1=PRCFL1+1
 S:$P(PRCFI0,"^",6)]"" PRCFL1=PRCFL1+1 S:$P(PRCFI0,"^",13)]"" PRCFL1=PRCFL1+1 S:$P(PRCFI0,"^",12) PRCFL1=PRCFL1+1
 S $P(PRCFX,U,12+FED)=PRCFL1
 S J=13+FED F I=0:0 S I=$O(^UTILITY($J,"W",1,I)) Q:'I  I $D(^(I,0)) S X=$E(^(0),1,33) D:($L(PRCFX)+$L(X)+1)>220 NX S $P(PRCFX,"^",J)=X,J=J+1
 I $P(PRCFI0,"^",6)]"" D:($L(PRCFX)+33)>220 NX S $P(PRCFX,"^",J)="STK#: "_$E($P(PRCFI0,"^",6),1,27),J=J+1
 ;I $P(PRCFI0,"^",13)]"" D:($L(PRCFX)+23)>220 NX S $P(PRCFX,"^",J)="NSN:  "_$P(PRCFI0,"^",13),J=J+1
 I $P(PRCFI0,"^",13)]"" D:($L(PRCFX)+23)>220 NX S $P(PRCFX,"^",J)=$P(PRCFI0,"^",13),J=J+1
 I $P(PRCFI0,"^",12) D:($L(PRCFX)+21)>220 NX S $P(PRCFX,"^",J)="Items per "_$S($D(^PRCD(420.5,+$P(PRCFI0,"^",3),0)):$P(^(0),"^",1),1:"")_": "_$P(PRCFI0,"^",12),J=J+1
 ;I $P(PRCFI4,"^",1) D:($L(PRCFX)+14)>220 NX S $P(PRCFX,"^",J)="GSA/DLA# :"_$P(PRCFI4,"^",1),J=J+1
 D:PRCFX'="" NX G ITM
NX ; Setting Serial Number
 G:$D(SERIAL) NX1 D:FED
 . S SERIAL=$P(PRCFI4,U,1),$P(PRCFX,U,5)=$P(PRCFI4,U,1) ; Serial Number
 . S $P(PRCFX,U,6)=$P(PRCFI0,U,13) ; National Stock Number (NSN)
 . Q
NX1 S ^TMP("PRCFARR",$J,PRCFJ,0)=PRCFX_"^",PRCFX="",K=1,J=1,PRCFJ=PRCFJ+1 Q