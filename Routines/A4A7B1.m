A4A7B1 ;CFB/SF/TUSC;NEW PERSON 3/6/16/20 LOCATOR PRINT ;4/11/96  11:46
 ;;1.01;NEW PERSON;**9**;2/9/96
DEVICE W !!,"This report could take some time, remember to QUEUE the report.",! K IOP,%ZIS S %ZIS="QM" D ^%ZIS K %ZIS I POP W !,"Print terminated. No device specified." G END
 I '$D(IO("Q")) U IO G START
 S ZTRTN="START^A4A7B1",ZTDESC="PRINT 3/6/16/20",ZTPRI=1,ZTSAVE("*")="" K IO("Q") D ^%ZTLOAD,HOME^%ZIS G END
START ;
 S A4A7B("TYPE","OUTP")="OUTPUT TRANSFORM",A4A7B("TYPE","EXEH")="EXECUTABLE HELP",A4A7B("TYPE","UINP")="USER INPUT",A4A7B("TYPE","AUD")="AUDIT",A4A7B("TYPE","DEL")="DELETE",A4A7B("TYPE","LAYGO")="LAYGO",A4A7B("TYPE","CR")="CROSS REFERENCE"
 S A4A7B("TYPE","SCR")="SCREEN",A4A7B("TYPE","C")="COMPUTED",A4A7B("TYPE","V")="VARIABLE POINTER"
 S A4A7B("TYPE","PTR")="REGULAR POINTER",A4A7B("TYPE","INP")="INPUT TRANSFORM",A4A7B("TYPE","^DIE(")="INPUT TEMPLATE",A4A7B("TYPE","^DIBT(")="SORT TEMPLATE"
 S A4A7B("TYPE","^DIPT(")="PRINT TEMPLATE",A4A7B("TYPE","ROU")="ROUTINE",A4A7B("TYPE","^DIST(.403,")="FORM",A4A7B("TYPE","^DIST(.404,")="BLOCK"
 S A4A7B("TYPE","^DIST(.44,")="FOREIGN FORMAT",A4A7B("TYPE","ID")="FILE IDENTIFIER",A4A7B("TYPE","ACT")="FILE ACTION",A4A7B("TYPE","M")="MISCELANEOUS"
 S A4A7B("ID")="" F  S A4A7B("ID")=$O(^UTILITY("A4A7B","XQ82",A4A7B("ID"))) Q:A4A7B("ID")=""  D
 .S A4A7B("ITEM")=""
 .F  S A4A7B("ITEM")=$O(^UTILITY("A4A7B","XQ82",A4A7B("ID"),A4A7B("ITEM"))) Q:A4A7B("ITEM")=""  D
 ..S A4A7B("LOST")="" F  S A4A7B("LOST")=$O(^UTILITY("A4A7B","XQ82",A4A7B("ID"),A4A7B("ITEM"),A4A7B("LOST"))) Q:A4A7B("LOST")=""  D
 ...S A4A7B("TYPE")="" F  S A4A7B("TYPE")=$O(^UTILITY("A4A7B","XQ82",A4A7B("ID"),A4A7B("ITEM"),A4A7B("LOST"),A4A7B("TYPE"))) Q:A4A7B("TYPE")=""  S A4A7B("DATA")=$G(^(A4A7B("TYPE"))) D 1,HDRID,UPPTR D
BODY ....;
 ....W !! I (IOSL-$Y)<10 W @IOF
 ....F A4A7B=1:1:4 I A4A7B("HDR",A4A7B)'="" W A4A7B("HDR",A4A7B),!
 ....F A4A7B=0:1 Q:$E(A4A7B("DATA"),1+(A4A7B*(IOM-5)),(IOM-5)+(A4A7B*(IOM-5)))=""  W $E(A4A7B("DATA"),1+(A4A7B*(IOM-5)),(IOM-5)+(A4A7B*(IOM-5))),!
END K A4A7B D ^%ZISC Q
1 S A4A7B("HDR",1)="POINTER TO FILE "_A4A7B("LOST")
2 S A4A7B("HDR",2)="IS FOUND IN "_$S($D(A4A7B("TYPE",A4A7B("TYPE"))):A4A7B("TYPE",A4A7B("TYPE")),1:A4A7B("TYPE",$P(A4A7B("TYPE"),"*",1))) Q
HDRID ;
 S (A4A7B("HDR",3),A4A7B("HDR",4))=""
 I A4A7B("TYPE")="WHSCR"!(A4A7B("TYPE")="WHACT") S A4A7B("HDR",3)=$S(A4A7B("ID")="WHSCR":"WHOLE FILE SCREEN",1:"WHOLE FILE ACTION")-" "_A4A7B("ID")_" FILE "_A4A7B("ID") Q
 I $E(A4A7B("TYPE"),1,2)="CR" S A4A7B("HDR",3)="CROSS REFERENCE "_$P(A4A7B("TYPE"),"^",3)_" FILE "_A4A7B("ID")_" FIELD "_A4A7B("ITEM") Q
 I $E(A4A7B("TYPE"))="M" S A4A7B("HDR",3)="MISCELANEOUS IN FILE "_A4A7B("ID")_" FIELD "_A4A7B("ITEM")_" NODE "_$P(A4A7B("TYPE"),"*",2) Q
 I A4A7B("TYPE")="ROU" S A4A7B("HDR",3)="ROUTINE "_A4A7B("ID")_" LINE "_A4A7B("ITEM") Q
 I $E(A4A7B("TYPE"))["^" S A4A7B("HDR",3)=A4A7B("TYPE",A4A7B("TYPE"))_" NAMED "_A4A7B("ID")_" NODE "_A4A7B("ITEM") Q
 S A4A7B("HDR",3)=A4A7B("TYPE",A4A7B("TYPE"))_" FILE "_A4A7B("ID")_" FIELD "_A4A7B("ITEM")
 Q
UPPTR ;
 Q:'+A4A7B("ID")  S A4A7B("X")=+A4A7B("ID"),A4A7B("HDR",4)=A4A7B("ID")_";"_A4A7B("ITEM")
UP I $G(^DD(A4A7B("X"),0,"UP")) S A4A7B("Z")=^("UP"),A4A7B("Y")=$O(^DD(A4A7B("Z"),"SB",A4A7B("X"),"")),A4A7B("X")=A4A7B("Z"),A4A7B("HDR",4)=A4A7B("HDR",4)_" MULTIPLE OF "_A4A7B("X")_";"_A4A7B("Y") G UP
 Q