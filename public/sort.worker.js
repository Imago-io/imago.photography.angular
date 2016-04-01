var alphanumsort, datesort, alphanum;

alphanum = function(a, b) {
  var aa, bb, c, chunkify, d, x;
  chunkify = function(t) {
    var i, j, m, n, tz, x, y;
    tz = [];
    x = 0;
    y = -1;
    n = 0;
    i = void 0;
    j = void 0;
    while (i = (j = t.charAt(x++)).charCodeAt(0)) {
      m = i === 46 || (i >= 48 && i <= 57);
      if (m !== n) {
        tz[++y] = "";
        n = m;
      }
      tz[y] += j;
    }
    return tz;
  };
  aa = chunkify(a);
  bb = chunkify(b);
  x = 0;
  while (aa[x] && bb[x]) {
    if (aa[x] !== bb[x]) {
      c = Number(aa[x]);
      d = Number(bb[x]);
      if (c === aa[x] && d === bb[x]) {
        return c - d;
      } else {
        return (aa[x] > bb[x] ? 1 : -1);
      }
    }
    x++;
  }
  return aa.length - bb.length;
};

datesort = function(a, b) {
  return new Date(a.created) - new Date(b.created);
};

modifiedsort = function(a, b) {
  return new Date(a.modified) - new Date(b.modified);
};

alphanumsort = function(a, b) {
  a.name || (a.name = '');
  b.name || (b.name = '');
  return alphanum(a.name.toLocaleLowerCase(), b.name.toLocaleLowerCase());
};

ordersort = function(a, b) {
  return a.order - b.order;
}

self.addEventListener('message', function(e) {

  var sortfunction;

  if (e.data.order.charAt(0) === '-'){
    var reverse = true;
    e.data.order = e.data.order.substring(1);
  }

  if (e.data.order === 'order') {

    sortfunction = ordersort;

  } else if (e.data.order === 'name') {

    sortfunction = alphanumsort;

  } else if (e.data.order === 'created') {

    sortfunction = datesort;

  } else if (e.data.order === 'modified') {

    sortfunction = modifiedsort;

  }

  e.data.assets.sort(sortfunction)

  if (reverse){
    e.data.assets.reverse()
  }

  self.postMessage(e.data);


}, false);
