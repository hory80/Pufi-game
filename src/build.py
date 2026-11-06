#!/usr/bin/env python3
"""Construiește jocul Pufi din surse.
Rulare (din rădăcina repo-ului):  python3 src/build.py
- concatenează: joc-base.html + l10n_*.html (sortat) + module (rb, gm, aq, mw, cg, tm, pq, nt) + late_*.html (sortat)
- scrie dist/joc.html (fișier complet, folosit și de testele din src/tests/)
- injectează CSS-ul în <head> și scriptul în <body> din index.html (GitHub Pages / iOS)
NU edita index.html de mână: modificările se fac în src/ și apoi se rulează build-ul."""
import glob, os, json
ROOT=os.path.dirname(os.path.dirname(os.path.abspath(__file__))); SRC=os.path.join(ROOT,'src')
os.chdir(SRC)
_a=os.path.join(ROOT,'licenses','assets.json')
_d=json.load(open(_a)) if os.path.exists(_a) else {}
_slim={k:{x:(v.get('source') or {}).get(x) for x in ['page','author','license','license_url','file']}|{'status':v.get('status'),'mods':v.get('modifications')} for k,v in _d.items()}
open('late_credits_data.html','w').write('<script>window.__ASSETS='+json.dumps(_slim,ensure_ascii=False)+';</script>\n')
b=open('joc-base.html').read()
packs=''.join(open(f).read() for f in sorted(glob.glob('l10n_*.html')))
late=''.join(open(f).read() for f in sorted(glob.glob('late_*.html')))
mods=['rb_module.html','gm_module.html','aq_module.html','mw_module.html','cg_module.html','tm_module.html','pq_module.html','nt_module.html']
h=b+packs+''.join(open(f).read() for f in mods)+late
os.makedirs(os.path.join(ROOT,'dist'),exist_ok=True)
open(os.path.join(ROOT,'dist','joc.html'),'w').write(h)
p=os.path.join(ROOT,'index.html'); g=open(p).read()
i=h.index('<style>'); j=g.index('<style>'); k=g.rindex('\n</body>'); e=h.index('</style>')+len('</style>')
open(p,'w').write(g[:j]+h[i:e]+'\n</head>\n<body>\n'+h[e:]+g[k:])
os.remove('late_credits_data.html')
print('built',len(h))
