/*	$Id$ */
/*
 * Copyright (c) 2015 Kristaps Dzonsons <kristaps@bsd.lv>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
#include <assert.h>
#include <cairo.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#include "kplot.h"
#include "compat.h"
#include "extern.h"

static int
kdata_mean_set(struct kdata *d, size_t pos, double x, double y)
{
	double	 delta, delta_n;
	void	*p;

	assert(KDATA_MEAN == d->type);

	/* FIXME: zeroing the new values? */
	if (pos > d->pairsz) {
		d->pairsz = pos + 1;
		p = reallocarray(d->pairs, 
			d->pairsz, sizeof(struct kpair));
		if (NULL == p)
			return(0);
		d->pairs = p;
		p = reallocarray(d->d.mean.ns, 
			d->pairsz, sizeof(size_t));
		if (NULL == p)
			return(0);
		d->d.mean.ns = p;
	}

	d->d.mean.ns[pos]++;
        delta = y - d->pairs[pos].y;
        delta_n = delta / (double)d->d.mean.ns[pos];
	d->pairs[pos].y += delta_n;
	d->pairs[pos].x = x;
	return(1);
}

struct kdata *
kdata_mean_alloc(struct kdata *dep)
{
	struct kdata	*d;

	if (NULL == (d = calloc(1, sizeof(struct kdata))))
		return(NULL);

	d->refs = 1;
	d->type = KDATA_MEAN;
	if (NULL == dep) 
		return(d);

	d->pairsz = dep->pairsz;
	d->pairs = calloc(d->pairsz, sizeof(struct kpair));
	d->d.mean.ns = calloc(d->pairsz, sizeof(size_t));
	if (NULL == d->pairs || NULL == d->d.mean.ns) {
		free(d->pairs);
		free(d->d.mean.ns);
		free(d);
		return(NULL);
	}
	kdata_dep_add(d, dep, kdata_mean_set);
	return(d);
}

int
kdata_mean_add(struct kdata *d, struct kdata *dep)
{
	void	*p;
	size_t	 i;

	assert(KDATA_MEAN == d->type);

	if (d->pairsz < dep->pairsz) {
		p = reallocarray(d->pairs, 
			dep->pairsz, sizeof(struct kpair));
		if (NULL == p)
			return(0);
		d->pairs = p;
		/* FIXME: don't loop, just do the math. */
		for (i = d->pairsz; i < dep->pairsz; i++)
			memset(&d->pairs[i], 0, sizeof(struct kpair));
		p = reallocarray(d->d.mean.ns, 
			dep->pairsz, sizeof(size_t));
		if (NULL == p)
			return(0);
		d->d.mean.ns = p;
		for (i = d->pairsz; i < dep->pairsz; i++) 
			d->d.mean.ns[i] = 0;
		d->pairsz = dep->pairsz;
	}

	kdata_dep_add(d, dep, kdata_mean_set);
	return(1);
}
