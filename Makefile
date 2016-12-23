# eschalot Makefile

# If you modify the Makefile, please make sure it works with
# both BSD and GNU makes. Avoid the fancy features.

PROG1		?= eschalot
PROG2		?= worgen
PROG3		?= typecard

MANPAGE		?= eschalot.1.gz
MANDIR		?= /usr/local/share/man/man1

PREFIX		?= /usr/local
BINDIR		?= ${PREFIX}/bin

LIBS		+= -lpthread -lssl -lcrypto

WARNINGS	+= -Wall -W -Wunused -pedantic -Wpointer-arith \
		-Wreturn-type -Wstrict-prototypes \
		-Wmissing-prototypes -Wshadow -Wcast-qual -Wextra

CFLAGS		+= -std=c99
CFLAGS		+= -O2
CFLAGS		+= -fPIC
CFLAGS		+= -finline-functions
#CFLAGS		+= -fomit-frame-pointer
#CFLAGS		+= -m64
#CFLAGS		+= -mtune=native -march=native
#CFLAGS		+= -g

DEBUGFLAGS	+= -g -rdynamic

CC		?= cc
GZIP		?= gzip -ck
INSTALL		?= install -c -o root -g bin -m 755
MANINSTALL	?= install -c -o root -g root -m 644
RM		?= /bin/rm -f

all:		${PROG1} ${PROG2}

${PROG1}:	${PROG1}.c Makefile
		${CC} ${CFLAGS} ${WARNINGS} -o $@ ${PROG1}.c ${LIBS}

${PROG2}:	${PROG2}.c Makefile
		${CC} ${CFLAGS} ${WARNINGS} -o $@ ${PROG2}.c

${MANPAGE}:	docs/eschalot.1.man Makefile
		${GZIP} docs/eschalot.1.man > ${MANPAGE}

# make typecard - quick overview of the basic types on the system
${PROG3}:	${PROG3}.c Makefile
		${CC} ${CFLAGS} -o $@ ${PROG3}.c
		./${PROG3}

install:	all ${MANPAGE}
		${INSTALL} ${PROG1} ${BINDIR}
		${INSTALL} ${PROG2} ${BINDIR}
		${MANINSTALL} ${MANPAGE} ${MANDIR}

clean:
		${RM} ${PROG1} ${PROG2} ${PROG3} ${MANPAGE} *.o *.p *.d *.s *.S *~ *.core .depend

# Simple procedure to speed up basic testing on multiple platforms
WF1		= top150adjectives.txt
WF2		= top400nouns.txt
WF3		= top1000.txt
WLIST		= wordlist.txt
RESULTS		= results.txt

test:		all
		./${PROG2} 8-16 ${WF1} 3-16 ${WF2} 3-16 ${WF3} 3-16 > ${WLIST}
		./${PROG1} -vct4 -f ${WLIST} >> ${RESULTS}

cleantest:
		${RM} ${WLIST} ${RESULTS}

cleanall:	clean cleantest

debug: CFLAGS += ${DEBUGFLAGS}
debug: all
