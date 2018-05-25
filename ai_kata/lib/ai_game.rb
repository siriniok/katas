10 PRINT "Задумай    живое      существо":SLEEP 2000
20 DIM B$(511):DIM O$(511)
21 GOSUB 200
30 DIM P1%(511):DIM P2%(511):DIM P3%(511):DIM P4%(511)
40 N=1:M=1:X%=1:O$(1)="кот":M$=""
50 I=1:J=1
60 IF B$(I)="" THEN GOTO 100
70 M$=B$(I)+"?":GOSUB 180
80 IF X%+1=2 THEN J=P4%(I):I=P2%(I):GOTO 60
90 J=P3%(I):I=P1%(I):GOTO 60
100 M$="Это "+O$(J)+"?":GOSUB 180
110 IF X%=1 THEN GOTO 150
120 M=M+1:INPUT "Сдаюсь, кто это?",O$(M)
130 INPUT "Чем "+O$(M)+" отличается от "+O$(J)+"?",B$(I)
140 P1%(I)=N+1:N=N+2:P2%(I)=N:P3%(I)=J:P4%(I)=M
150 M$="Продолжаем?":GOSUB 180
160 IF X%=1 THEN GOTO 50
170 END
180 X%=MESSAGEFORM("Отвечайчестно:-)","Да","Нет","",M$)
190 RETURN
200 FOR I%=0 TO 510
210 B$(I%)="":O$(I%)=""
220 NEXT I%
