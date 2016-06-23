# Created by: Kris Moore <kmoore@FreeBSD.org>
# $FreeBSD$

PORTNAME=	life-preserver
PORTVERSION=	%%CHGVERSION%%
PORTEPOCH=	1
CATEGORIES=	sysutils

MAINTAINER=	kmoore@FreeBSD.org
COMMENT=	PC-BSD Life Preserver Utility

LICENSE=	BSD3CLAUSE

RUN_DEPENDS=	${LOCALBASE}/share/pcbsd/scripts/functions.sh:sysutils/trueos-libsh \
		sshpass:security/sshpass \
		stunnel:security/stunnel

USES=		pkgconfig tar:xz
NO_BUILD=	yes
MAKE_ARGS=	PREFIX=${STAGEDIR}${PREFIX}

USE_GITHUB=	yes
GH_ACCOUNT=	trueos
GH_PROJECT=	lpreserver
GH_TAGNAME=	%%GHTAG%%

.include <bsd.port.pre.mk>

.if ${OSVERSION} < 1000000
IGNORE=		requires FreeBSD 10 or later
.endif

.include <bsd.port.post.mk>
