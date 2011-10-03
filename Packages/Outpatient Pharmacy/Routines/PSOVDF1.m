PSOVDF1 ;BPOIFO/EL-OUTPATIENT PHARMACY (PRES, PREF, PPAR) HL7 MESSAGE ;10/04/04
 ;;7.0;OUTPATIENT PHARMACY;**190,205,220,235,261**;DEC 1997;Build 9
 ;
VALID ;;VDEF HL7 MESSAGE BUILDER
 ;
 ; DBIA #4248 - $$XCN200^VDEFEL (or <MultipleTag>^VDEFEL)
 ; DBIA #3552 - $$PARAM^HLCS2
 ; DBIA #3630 - BLDPID^VAFCQRY
 ; DBIA #10040 - 0-NODE of ^SC
 ; DBIA 4571 - ERR^VDEFREQ
 ; 
 ; This routine is called at tag EN as a Function by VDEFREQ1
 ;
 Q
 ;
EN(EVIEN,KEY,VFLAG,OUT,MSHP) ;
 ; This routine creates one of three Outpatient Pharmacy HL7 messages:
 ; RDE^O11^PRES, RDS^O13^PREF, or RDS^O13^PPAR
 ;
 ; Input Parameters:
 ;    EVIEN - IEN of message in file 577
 ;    KEY -   IEN to File #52 ^PSRX
 ;    VFLAG - "V" for VistA HL7 destination (default)
 ;    OUT -   Target array.  Must be passed by reference
 ;    MSHP -  4th piece is SUBTYPE (PRES, PREF, PPAR)
 ;
 ; Returns:
 ;    Two piece string with separator '^':
 ;    Piece 1 - "LM" - LOCAL ARRAY
 ;    Piece 2 - MSH segment, is not set
 ;    OUT - OUTPUT array includes HL7 message for every segment except MSH
 ;              
 ;  Message Body "MSH,PID,ORC1,RXE1,RXR1,FT1,OBX1,NTE1,ORC2,ORC3"
 ;  The Pharmacy Original Fill message will be generated by pgm:PSOVDF2 - (ORC1. . NTE1)
 ;
 ;
 N CTR,PSOVDFD0,PSOVDFD1,DFN,DRCODE,PSOVDRUG,ERR,FILE,FIELD,GIVECODE,GL,GLOB,GLOBAL,HLINST,PSOVDDIV,PSOVD59,PSOVERR
 N I,L,MSG,NTE,P,RES,SEPC,SEPE,SEPF,SEPR,SEPS,SRC,SUBTYPE,TARGET,PSOVDFES,PSOVESC,PSOVDFIN
 N HL7DEL,REPSEPC,REPSEPE,REPSEPF,REPSEPR,REPSEPS,TEMP,TP,UNIT,VAL,WR,X,Y,Z,VCMP,VFT7
 ;
 S (ERR,TARGET)=""
 D INIT
 I $G(ERR)'="" D ERR^VDEFREQ(ERR) S ZTSTOP=1 G QUIT
 D MSHPID
 I $G(ERR)'="" D ERR^VDEFREQ(ERR) S ZTSTOP=1 G QUIT
 D PROCESS^PSOVDF2
 D ORC2
QUIT Q TARGET
 ;
INIT ;
 K GL,OUT,TEMP,TP
 S (PSOVDFD0,PSOVDFES,DFN,DRCODE,PSOVDRUG,FILE,GIVECODE,GLOB,SEPC,SEPE,SEPF,SEPR,SEPS,SRC,SUBTYPE,UNIT,VAL)=""
 S (HL7DEL,REPSEPC,REPSEPE,REPSEPF,REPSEPR,REPSEPS)=""
 S OUT("HLS")=0
 S PSOVDFD0=KEY
 I $G(U)'="^" S U="^"
 S FILE=52
 S SUBTYPE=$P($G(MSHP),"~",4)
 S VAL=$G(HL("ECH")) I VAL="" S VAL="~|\&",HL("ECH")=VAL
 S SEPE=$E(VAL,3),REPSEPE=SEPE_"E"_SEPE
 S SEPC=$E(VAL,1),REPSEPC=SEPE_"S"_SEPE
 S SEPR=$E(VAL,2),REPSEPR=SEPE_"R"_SEPE
 S SEPS=$E(VAL,4),REPSEPS=SEPE_"T"_SEPE
 S VAL=$G(HL("FS")) I VAL="" S VAL="^",HL("FS")=VAL
 S SEPF=$E(VAL,1),REPSEPF=SEPE_"F"_SEPE
 S HL7DEL=$G(HL("ECH"))_$G(HL("FS"))
 S GLOB=$$ROOT^DILFD(FILE)_PSOVDFD0_")"
 M GL=@GLOB
 S DFN=$P($G(GL(0)),U,2)
 I $G(DFN)="" S ERR="MISSING DFN IN FILE-52 AT IEN="_PSOVDFD0 Q
 I $G(^DPT(DFN,0))="" S ERR="MISSING DFN IN FILE-2 AT FILE-52/IEN="_PSOVDFD0 Q
 S PSOVDFES=$$REPL(PSOVDFD0)
 S PSOVDFIN=$$SITE^VASITE,PSOVDFIN=$P($G(PSOVDFIN),"^",2),PSOVDFIN=$$REPL(PSOVDFIN)
 Q
 ;
PUT(P) ; Put in MSG
 I $G(VAL)="" Q
 S $P(MSG,SEPF,P)=VAL
 Q
 ;
REPL(L) ; REPLACE HL7 DELIMITER CHAR
 I $G(L)="" Q ""
 I $TR(L,$G(HL7DEL))=L Q L
 N X,Y,Z,RES
 S RES=L
 I $F(L,SEPE) S X=RES D
 . S Z=$P(X,SEPE,2,9999),Y=$P(X,SEPE)_REPSEPE_Z,RES=Y,X=Z I '$F(Z,SEPE) Q
 . F I=2:1 S Z=$P(X,SEPE,2,9999),Y=$P(RES,REPSEPE,1,I-1)_REPSEPE_$P(X,SEPE)_REPSEPE_Z,RES=Y,X=Z I '$F(Z,SEPE) Q
 I $F(RES,SEPC) F I=1:1 S Y=$P(RES,SEPC)_REPSEPC_$P(RES,SEPC,2,9999),RES=Y I '$F(RES,SEPC) Q
 I $F(RES,SEPR) F I=1:1 S Y=$P(RES,SEPR)_REPSEPR_$P(RES,SEPR,2,9999),RES=Y I '$F(RES,SEPR) Q
 I $F(RES,SEPS) F I=1:1 S Y=$P(RES,SEPS)_REPSEPS_$P(RES,SEPS,2,9999),RES=Y I '$F(RES,SEPS) Q
 I $F(RES,SEPF) F I=1:1 S Y=$P(RES,SEPF)_REPSEPF_$P(RES,SEPF,2,9999),RES=Y I '$F(RES,SEPF) Q
 Q RES
 ;
OUT D OUT^PSOVDF2 Q
OUT20 D OUT20^PSOVDF2 Q
 ;
MSHPID ;
MSH ; MSH
 S (HLINST,MSG,SRC)=""
 I '$D(SITEPARM) S SITEPARM=$$PARAM^HLCS2
 S HLINST=$P(SITEPARM,U,6),HLINST=$$REPL(HLINST),SRC=HLINST_"_"_FILE
 S TARGET="LM"_SEPF_MSG
 ;
PID ; PID
 K WR
 S (MSG)=""
 D BLDPID^VAFCQRY(DFN,1,"",.WR,.HL,.ERR)
 I $G(WR(1))="" S ERR="MISSING PID AT DFN="_DFN_" IN FILE-52 AT IEN="_PSOVDFD0 Q
 I $P(WR(1),U,3)="V" S $P(WR(1),U,3)=""
 D OUT20
 K WR
 Q
 ;
ORC2 ; RF
 I '$D(GL(1)) G ORC3
 K TEMP M TEMP=GL(1)
 S PSOVDFD1=0
ORC2A S PSOVDFD1=$O(TEMP(PSOVDFD1)) G ORC3:'PSOVDFD1
 S MSG=""
 S TP=$G(TEMP(PSOVDFD1,0)) I TP="" G ORC2A
 S PSOVESC=$$REPL(PSOVDFD1),VAL=PSOVESC D PUT(3)
 ; (7~4-10.1)
 S (VAL,WR)="",WR=$P(TP,U,19) I $G(WR)'="" D
 .S WR=$$HLDATE^HLFNC(WR,"TS") I WR>0 S WR=$$REPL(WR),$P(VAL,SEPC,4)=WR,$P(VAL,SEPC,7)="DISPENSED"
 ; (7~5-13)
 S WR=$P(TP,U,15) I $G(WR)'="" D
 .S WR=$$HLDATE^HLFNC(WR,"TS") I WR>0 S WR=$$REPL(WR),$P(VAL,SEPC,5)=WR,$P(VAL,SEPC,7)=$P(VAL,SEPC,7)_"/EXPIRATION"
 D PUT(7)
 S VAL="",$P(VAL,SEPC,2)=PSOVDFES D PUT(8)
 ; (9-7)
 S VAL=$P(TP,U,8) I $G(VAL)'="" S VAL=$$HLDATE^HLFNC(VAL,"TS") I VAL>0 S VAL=$$REPL(VAL) D PUT(9)
 ; (12-15)
 S VAL=$P(TP,U,17) I $G(VAL)'="" S VAL=$$XCN200^VDEFEL(VAL) D PUT(12)
 S VAL="REFILL" D PUT(16)
 S VAL=$P(TP,U,9) S:$G(VAL)="" VAL=$P($G(^PSRX(PSOVDFD0,2)),"^",9) I $G(VAL)'="" D
 .S PSOVD59=VAL I $D(PSOVDDIV(VAL)) S VAL=$G(PSOVDDIV(VAL)) S $P(VAL,SEPC,3)=$P($P(VAL,SEPC,3),"_")_"_52.1_8" D PUT(17) Q
 .N PSONCRF,PSONCRFP,PSOSTNUM
 .S X=$G(^PS(59,VAL,0)),PSONCRFP=$P($G(^("SAND")),"^",3)
 .S VAL=$P(X,U),(VAL,PSONCRF)=$$REPL(VAL) Q:VAL=""
 .S PSOSTNUM=$P(X,U,6),PSOSTNUM=$$REPL(PSOSTNUM)
 .S VAL=PSOSTNUM_SEPC_VAL_SEPC_HLINST_"_52.1_8"
 .I PSONCRFP'="" S PSONCRFP=$$REPL(PSONCRFP),VAL=VAL_SEPC_PSONCRFP_SEPC_PSONCRF_SEPC_"NCPDP"
 .S PSOVDDIV(PSOVD59)=$G(VAL)
 .D PUT(17)
 S VAL=$G(PSOVDFIN) D PUT(21)
 I $D(VCMP(PSOVDFD1)) S VAL=SEPC_SEPC_SEPC_VCMP(PSOVDFD1) D PUT(25)
 I $G(MSG)="" G ORC2Q
 S $P(MSG,U)="RF"
 S MSG="ORC"_SEPF_MSG D OUT
ORC2Q ; Q
 ;
RXE2 ; RF
 S MSG=""
 ; (1~4-.01)
 S (VAL,WR)="",WR=$P(TP,U,1) I $G(WR)'="" D
 .S WR=$$HLDATE^HLFNC(WR,"TS") I WR>0 S WR=$$REPL(WR),$P(VAL,SEPC,4)=WR,$P(VAL,SEPC,7)="REFILL" D PUT(1)
 ; (2~1..~3-6, 2~4-API , 2~6-NDC)
 S VAL=""
 I $T(NDC^PSOHDR)]"" D
 .S VAL=$$NDC^PSOHDR(PSOVDFD0,PSOVDFD1,"R")
 E  S VAL=$P($G(TEMP(PSOVDFD1,1)),U,3) D
 .I $G(VAL)="",$G(PSOVDRUG)'="" S VAL=$P($G(^PSDRUG(PSOVDRUG,2)),"^",4)
 I $G(VAL)'="" D
 .S VAL=$$REPL(VAL)
 .S X="",X=GIVECODE,$P(X,SEPC,4)=VAL,$P(X,SEPC,6)="NDC",VAL=X D PUT(2)
 E  S VAL=GIVECODE D PUT(2)
 S VAL=0 D PUT(3)
 ; (5-DEF="UNK" or API)
 S VAL=UNIT D PUT(5)
 ; (8~6-2)
 S (VAL,WR)=""
 S WR=$$GET1^DIQ(52.1,PSOVDFD1_","_PSOVDFD0_",",2,"","","PSOVERR") K PSOVERR I $G(WR)'="" S WR=$$REPL(WR),$P(VAL,SEPC,6)=WR D PUT(8)
 ; (10-1)
 S VAL=$P(TP,U,4),VAL=$$REPL(VAL) D PUT(10)
 ; (14|1-4)
 S VAL=$P(TP,U,5) I $G(VAL)="" G RXE2A
 S VAL=$$XCN200^VDEFEL(VAL,"PHARMACIST") D PUT(14)
 ; (18-17)
RXE2A S VAL=$P(TP,U,18) I $G(VAL)'="" S VAL=$$HLDATE^HLFNC(VAL,"TS") I VAL>0 S VAL=$$REPL(VAL) D PUT(18)
 ; (22-1.1)
 S VAL=$P(TP,U,10) I $G(VAL)'="" S VAL="D"_VAL,VAL=$$REPL(VAL) D PUT(22)
 D RXE31A^PSOVDF3
 D PUT(31)
 I $G(MSG)="" G RXE2Q
 S MSG="RXE"_SEPF_MSG D OUT
RXE2Q ; Q
 ;
NTE2 ; RF
 S MSG=""
 ; (3-52.1_3)
 S WR=$P(TP,U,3) I $G(WR)="" G NTE2Q
 S VAL=PSOVDFD1 D PUT(1)
 S VAL=$$REPL(WR)
 D PUT(3),RREM^PSOVDF3,PUT(4)
 S MSG="NTE"_SEPF_MSG D OUT
NTE2Q ; Q
 ;
FT12 ;  RF
 ; patch 261 - FT1
 D FT1R^PSOVDF3
FT12Q ; Q
 G ORC2A
 ;
ORC3 ; PAR       
 I '$D(GL("P")) Q
 K TEMP M TEMP=GL("P")
 S PSOVDFD1=0
ORC3A S PSOVDFD1=$O(TEMP(PSOVDFD1)) Q:'PSOVDFD1
 S MSG=""
 S TP=$G(TEMP(PSOVDFD1,0)) I TP="" G ORC3A
 S PSOVESC=$$REPL(PSOVDFD1),VAL=PSOVESC D PUT(3)
 ; (7~4-7.5)
 S WR=$P(TP,U,13) I $G(WR)'="" D
 .S WR=$$HLDATE^HLFNC(WR,"TS") I WR>0 S WR=$$REPL(WR),VAL="",$P(VAL,SEPC,4)=WR,$P(VAL,SEPC,7)="DISPENSED" D PUT(7)
 S VAL="",$P(VAL,SEPC,2)=PSOVDFES D PUT(8)
 ; (9-.08)
 S VAL=$P(TP,U,8) I $G(VAL)'="" S VAL=$$HLDATE^HLFNC(VAL,"TS") I VAL>0 S VAL=$$REPL(VAL) D PUT(9)
 ; (12-6)
 S VAL=$P(TP,U,17) I $G(VAL)'="" S VAL=$$XCN200^VDEFEL(VAL) D PUT(12)
 S VAL="PARTIAL" D PUT(16)
 S VAL=$P(TP,U,9) S:$G(VAL)="" VAL=$P($G(^PSRX(PSOVDFD0,2)),"^",9) I $G(VAL)'="" D
 .S PSOVD59=VAL I $D(PSOVDDIV(VAL)) S VAL=$G(PSOVDDIV(VAL)) S $P(VAL,SEPC,3)=$P($P(VAL,SEPC,3),"_")_"_52.2_.09" D PUT(17) Q
 .N PSONCPR,PSONCPRP,PSOSPNUM
 .S X=$G(^PS(59,VAL,0)),PSONCPRP=$P($G(^("SAND")),"^",3)
 .S VAL=$P(X,U),(VAL,PSONCPR)=$$REPL(VAL) Q:VAL=""
 .S PSOSPNUM=$P(X,U,6),PSOSPNUM=$$REPL(PSOSPNUM)
 .S VAL=PSOSPNUM_SEPC_VAL_SEPC_HLINST_"_52.2_.09"
 .I PSONCPRP'="" S PSONCPRP=$$REPL(PSONCPRP),VAL=VAL_SEPC_PSONCPRP_SEPC_PSONCPR_SEPC_"NCPDP"
 .S PSOVDDIV(PSOVD59)=$G(VAL)
 .D PUT(17)
 S VAL=$G(PSOVDFIN) D PUT(21)
 I $G(MSG)="" G ORC3Q
 S $P(MSG,U)="RF"
 S MSG="ORC"_SEPF_MSG D OUT
ORC3Q ; Q
 ;
RXE3 ; PAR
 S MSG=""
 ; (1~4-.01)
 S WR=$P(TP,U,1) I $G(WR)'="" D
 .S WR=$$HLDATE^HLFNC(WR,"TS") I WR>0 S WR=$$REPL(WR),VAL="",$P(VAL,SEPC,4)=WR,$P(VAL,SEPC,7)="PARTIAL" D PUT(1)
 ; (2~1..~3-6, 2~4-API, 2~6-NDC)
 S VAL=""
 I $T(NDC^PSOHDR)]"" D
 .S VAL=$$NDC^PSOHDR(PSOVDFD0,PSOVDFD1,"P")
 E  S VAL=$P($G(TEMP(PSOVDFD1,0)),U,12) D
 .I $G(VAL)="",$G(PSOVDRUG)'="" S VAL=$P($G(^PSDRUG(PSOVDRUG,2)),"^",4)
 I $G(VAL)'="" D
 .S VAL=$$REPL(VAL)
 .S X="",X=GIVECODE,$P(X,SEPC,4)=VAL,$P(X,SEPC,6)="NDC",VAL=X D PUT(2)
 E  S VAL=GIVECODE D PUT(2)
 S VAL=0 D PUT(3)
 ; (5-DEF="UNK" or API)
 S VAL=UNIT D PUT(5)
 ; (8~6-.02)
 S (VAL,WR)=""
 S WR=$$GET1^DIQ(52.2,PSOVDFD1_","_PSOVDFD0_",",.02,"","","PSOVERR") K PSOVERR I $G(WR)'="" S WR=$$REPL(WR),$P(VAL,SEPC,6)=WR D PUT(8)
 ; (10-.04)
 S VAL=$P(TP,U,4),VAL=$$REPL(VAL) D PUT(10)
 ; (14|1-.05)
 S VAL=$P(TP,U,5) I $G(VAL)="" G RXE3B
 S VAL=$$XCN200^VDEFEL(VAL,"PHARMACIST") D PUT(14)
 ; (18-8)
RXE3B S VAL=$P(TP,U,19) I $G(VAL)'="" S VAL=$$HLDATE^HLFNC(VAL,"TS") I VAL>0 S VAL=$$REPL(VAL) D PUT(18)
 S VAL=$P(TP,U,10) I $G(VAL)'="" S VAL="D"_VAL,VAL=$$REPL(VAL) D PUT(22)
 D RXE31^PSOVDF3
 D PUT(31)
 ;
 I $G(MSG)="" G RXE3Q
 S MSG="RXE"_SEPF_MSG D OUT
RXE3Q ; Q
 ;
NTE3 ; PAR
 S MSG=""
 ; (3-.03)
 S WR=$P(TP,U,3) I $G(WR)="" G NTE3Q
 S VAL=PSOVDFD1 D PUT(1)
 S VAL=$$REPL(WR)
 D PUT(3),PREM^PSOVDF3,PUT(4)
 S MSG="NTE"_SEPF_MSG D OUT
NTE3Q ; Q
FT13 ; patch 261
 D FT1R^PSOVDF3
 G ORC3A
 ;
 Q